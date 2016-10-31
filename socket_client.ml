module TMSP = Types_piqi 
open TMSP
open Unix
open Thread

type callback = response -> unit
let nilCb (res : response) = ()

let _LOG = ""

class req_res (req : request) = 
object(self)
	val req = req 
	val mtx = Mutex.create ()
    val mutable finished = false
	val cond = Condition.create ()
	val mutable res = default_response ()
	val mutable cb = nilCb

	method setCallback (cb_ : callback) = 
		Mutex.lock mtx;
		if finished then 
		begin
			Mutex.unlock mtx;
			cb_ res;
		end
		else begin 
			cb <- cb_;
			Mutex.unlock mtx;
		end

	method getCallback () = 
		Mutex.lock mtx;
		let cb_ = cb in 
		Mutex.unlock mtx;
		cb_

	method setResponse (res_ : response) = 
		Mutex.lock mtx;
		res <- res_; 
		Mutex.unlock mtx;


	method setFinished () = 
		Mutex.lock mtx;
		finished <- true;
		Mutex.unlock mtx;

	method req () = 
		Mutex.lock mtx;
		let req_ = req in 
		Mutex.unlock mtx;
		req_

	method res () =
		Mutex.lock mtx;
		let res_ = res in 
		Mutex.unlock mtx;
		res_

	method signal () = 
		Condition.signal cond;

	method broadcast () = 
		Condition.broadcast cond;

	method wait () = 
		Condition.wait cond mtx;
end;;

(*******************************************************************)

exception Error of string

let addToEnd lst item = 
	let lst = List.rev lst in 
	let lst = List.rev (item :: lst) in 
	lst;;

let s_descr () = Unix.socket Unix.PF_INET Unix.SOCK_STREAM 0
let sockaddr (addr : string) (port : int) = Unix.ADDR_INET ((Unix.inet_addr_of_string addr), port) 

let resMatchesReq (req : request) (res : response) = 
	let reqType = Messages.requestType req in 
	if reqType = `null_message then false else 
	let resType = Messages.responseType res in 
	if resType = `null_message then false else reqType = resType;;
			

class socket_client (addr : string) (port : int) (mustConnect : bool) = 
object(self)

	val flushProcess = open_process "flush timer"
	val queueProcess = open_process "queue"

	val mustConnect = mustConnect

	val mtx = Mutex.create ()
	val addr = addr
	val port = port
	val conn = s_descr ()

	val mutable error = None
	val mutable reqSent = []
	val mutable resCb = nilCb

	method onStart () = 
		(* onStart service *)
		Unix.connect conn (sockaddr addr port);
		ignore (Thread.create self # sendRequestsRoutine ());
		ignore (Thread.create self # recvResponseRoutine ());

	method onStop () = 
		(* onStop service *)
		Mutex.lock mtx;
		Unix.close conn;
		ignore (self # flushQueue ());
		Mutex.unlock mtx;

	method error () = 
		Mutex.lock mtx;
		let err = error in 
		Mutex.unlock mtx;
		err

	method stopForError (str : string) = 
		Mutex.lock mtx;
		match error with 
		| None ->
			error <- Some (Error str);
			Mutex.unlock mtx;
		| Some (Error str) ->	
			Mutex.unlock mtx;
		(* stop service *)

	method setResponseCallback (cb : callback) = 
		Mutex.lock mtx;
		resCb <- cb;
		Mutex.unlock mtx;

	method flushRoutine () = 
		let flushIn = fst flushProcess in 
		let flush = (Marshal.from_channel flushIn : bool) in
		if flush then
			let reqres = new req_res (Messages.toRequestFlush ()) in
			let queueOut = snd queueProcess in
			Marshal.to_channel queueOut reqres [];
		else ();

	method queueRoutine (w : Io.writer) = 
		let queueIn = fst queueProcess in 
		let reqres = (Marshal.from_channel queueIn : req_res) in
			self # willSendReq reqres;
			let req = reqres # req () in
			match Messages.writeMessage req w with 
			| w, Some (Error str) ->
				w, Some (Error str)
			| w, None -> 
				let w = match req.Request.flush with
				| Some _ -> Io.flush w
				| None -> w in 
				w, None

	method sendRequestsRoutine () = 
		let notDone = ref true in 
		let w = ref (Io.new_writer conn 16) in
		while !notDone do
			ignore (Thread.create self # flushRoutine ());
			match self # queueRoutine !w with 
			| w_, Some (Error str) ->
				self # stopForError str;
				notDone := false;
				w := w_;
			| w_, None -> 
				w := w_;
		done;

	method recvResponseRoutine () = 
		let notDone = ref true in 
		let r = ref (Io.new_reader conn 16) in 
		while !notDone do
			match Messages.readMessage !r with
			| r_, None, Some (Error str) ->
				self # stopForError str; 
				notDone := false;
				r := r_;
			| r_, Some res, None ->
				match Messages.parseResponseError res with 
				| Some str ->
					self # stopForError str; 
					notDone := false;
					r := r_;
				| None -> 
					match self # didRecvResponse res with 
					| Some (Error str) -> 
						self # stopForError str; 
						notDone := false;
						r := r_;
					| None -> 
						r := r_;
		done;

	method willSendReq reqres = 
		Mutex.lock mtx;
		reqSent <- addToEnd reqSent reqres;
		Mutex.unlock mtx;

	method didRecvResponse (res : response) = 
		Mutex.lock mtx;
		let reqres = List.hd reqSent in 
		let req = reqres # req () in
		if (resMatchesReq req res) then begin
			reqres # setResponse res; 
			reqres # signal ();
			reqSent <- List.tl reqSent;
			let cb = reqres # getCallback () in 
			cb res;
			resCb res;
			Mutex.unlock mtx;
			None
		end
		else begin
			Mutex.unlock mtx;
			Some (Error "Unexpected response type")
		end

	method queueRequest (req : request) = 
		let reqres = new req_res req in 
		let queueOut = snd queueProcess in
		Marshal.to_channel queueOut reqres [];
		let flushOut = snd flushProcess in
		match req with
		| {Request.flush = Some _; _} -> 
			Marshal.to_channel flushOut true []; 
			reqres
		| _ -> reqres
		

	method flushQueue () = 
		let err = ref None in
		let queueIn = fst queueProcess in 
		while !err = None do
			match (Marshal.from_channel queueIn : req_res) with
			| exception _ -> 
				err := Some (Error "Marshal error");
			| reqres ->
				reqres # signal (); 
				reqres # setFinished ();
		done;
		!err


	method echoAsync (msg : string) = 
		self # queueRequest (Messages.toRequestEcho msg)

	method flushAsync () = 
		self # queueRequest (Messages.toRequestFlush ())

	method infoAsync () = 
		self # queueRequest (Messages.toRequestInfo ())

	method setOptionAsync (key : string) (value : string) = 
		self # queueRequest (Messages.toRequestSetOption key value)

	method appendTxAsync (tx : binary) =
		self # queueRequest (Messages.toRequestAppendTx tx) 

	method checkTxAsync (tx : binary) = 
		self # queueRequest (Messages.toRequestCheckTx tx)

	method queryAsync (query : binary) = 
		self # queueRequest (Messages.toRequestQuery query)

	method commitAsync () = 
		self # queueRequest (Messages.toRequestCommit ())

	method initChainAsync (validators : validator list) = 
		self # queueRequest (Messages.toRequestInitChain validators)

	method beginBlockAsync (height : uint64) = 
		self # queueRequest (Messages.toRequestBeginBlock height)

	method endBlockAsync (height : uint64) =
		self # queueRequest (Messages.toRequestEndBlock height)

	method echoSync (msg : string) = 
		let reqres = self # echoAsync msg in 
		ignore (self # flushSync ());
		match self # error () with 
		| Some (Error str) -> 
			Results.newError `internal_error str
		| None -> 
			match Messages.parseResponseEcho (reqres # res ()) with 
			| Some message -> Results.newResultOk (Bytes.of_string message) _LOG
			| None -> Results.newError `internal_error _LOG

	method flushSync () = 
		let reqres = self # flushAsync () in 
		match self # error () with 
		| Some (Error str) -> 
			Some (Error str)
		| None -> 
			begin
			reqres # wait ();
			self # error ()
			end

	method infoSync () = 
		let reqres = self # infoAsync () in 
		ignore (self # flushSync ());
		match self # error () with 
		| Some (Error str) ->
			Results.newError `internal_error str 
		| None ->
			match Messages.parseResponseInfo (reqres # res ()) with 
			| Some info -> Results.newResultOk (Bytes.of_string info) _LOG 
			| None -> Results.newError `internal_error _LOG

	method setOptionSync (key : string) (value : string) = 
		let reqres = self # setOptionAsync key value in 
		ignore (self # flushSync ());
		match self # error () with
		| Some (Error str) ->
			Results.newError `internal_error str
		| None ->
			match Messages.parseResponseSetOption (reqres # res ()) with 
			| Some log -> Results.newResultOk (Bytes.of_string log) _LOG
			| None -> Results.newError `internal_error _LOG 

	method appendTxSync (tx : bytes) = 
		let reqres = self # appendTxAsync tx in 
		ignore (self # flushSync ());
		match self # error () with 
		| Some (Error str) ->
			Results.newError `internal_error str
		| None ->
			match Messages.parseResponseAppendTx (reqres # res ()) with 
			| Some code, Some data, Some log -> 
				Results.newResult code data log
			| _ -> Results.newError `internal_error _LOG

	method checkTxSync (tx : bytes) = 
		let reqres = self # checkTxAsync tx in 
		ignore (self # flushSync ());
		match self # error () with 
		| Some (Error str) ->
			Results.newError `internal_error str
		| None ->
			match Messages.parseResponseCheckTx (reqres # res ()) with 
			| Some code, Some data, Some log -> 
				Results.newResult code data log
			| _ -> Results.newError `internal_error _LOG
			

	method querySync (query : bytes) = 
		let reqres = self # queryAsync query in 
		ignore (self # flushSync ());
		match self # error () with 
		| Some (Error str) ->
			Results.newError `internal_error str 
		| None ->
			match Messages.parseResponseQuery (reqres # res ()) with 
			| Some code, Some data, Some log -> 
				Results.newResult code data log
			| _ -> Results.newError `internal_error _LOG

	method commitSync () = 
		let reqres = self # commitAsync () in 
		ignore (self # flushSync ());
		match self # error () with 
		| Some (Error str) ->
			Results.newError `internal_error str 
		| None ->
			match Messages.parseResponseCommit (reqres # res ()) with 
			| Some code, Some data, Some log -> 
				Results.newResult code data log
			| _ -> Results.newError `internal_error _LOG

	method initChainSync (validators : validator list) = 
		ignore (self # initChainAsync validators);
		ignore (self # flushSync ());
		self # error ()

	method beginBlockSync (height : uint64) = 
		ignore (self # beginBlockAsync height);
		ignore (self # flushSync ());
		self # error ()

	method endBlockSync (height : uint64) = 
		let reqres = self # endBlockAsync height in 
		ignore (self # flushSync ());
		match self # error () with 
		| Some (Error str) -> None, Some (Error str)
		| None ->
			match Messages.parseResponseEndBlock (reqres # res ()) with 
			| Some validators -> Some validators, None
			| None ->  None, Some (Error "No validators in ResponseEndBlock")

end;;



