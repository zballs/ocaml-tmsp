open Unix

module TMSP = Types_piqi
open TMSP

exception Error of string

module M = Map.Make(struct type t = int let compare = compare end);;

let s_descr () = Unix.socket Unix.PF_INET Unix.SOCK_STREAM 0;;
let sockaddr (addr : string) (port : int) = Unix.ADDR_INET ((Unix.inet_addr_of_string addr), port);; 

class socket_server (addr : string) (port : int) (app : App.application)  = 
	object(self) 

	val addr = addr 
	val port = port
	val listener = s_descr()
	val listenBacklog = 10

	val connsMtx = Mutex.create()
	val mutable conns = M.empty 
	val mutable nextConnID = 0

	val appMtx = Mutex.create()
	val app = app

	method app = app

	method init () = 
		Unix.setsockopt listener SO_REUSEADDR true;
		Unix.set_nonblock listener;
		Unix.bind listener (sockaddr addr port);

	method onStart () =
		(* service stuff *)
		Unix.listen listener listenBacklog;

	method onStop () =
		(* service stuff *) 
		Unix.close listener;
		Mutex.lock connsMtx;
		M.iter (fun c -> Unix.close) conns;
		conns <- M.empty;
		Mutex.unlock connsMtx;

	method addConn (c : file_descr) =
		Mutex.lock connsMtx;
		let id = nextConnID in 
		conns <- M.add id c conns;
		nextConnID <- id + 1;
		Mutex.unlock connsMtx;
		id

	method rmConn (id : int) = 
		Mutex.lock connsMtx;
		let c = M.find id conns in 
		Unix.close c;
		conns <- M.remove id conns;
		Mutex.unlock connsMtx;

	method acceptConnectionsRoutine () = 
		while true do
			print_endline "Waiting for connection...";
			let (c, addr) = Unix.accept listener in 
			print_endline "Accepted a new connection";
			let id = self#addConn c in
			let (errorIn, errorOut) = Unix.open_process "errors" in
			let (responseIn, responseOut) = Unix.open_process "responses" in 
			ignore (Thread.create self#handleRequests (c, responseOut, errorOut));
			ignore (Thread.create self#handleResponses (c, responseIn, errorOut));
			ignore (Thread.create self#recvErr (id, errorIn));
		done; 

	method recvErr (id, errorIn : int * in_channel) = 
		match Marshal.from_channel errorIn with
		| Error str -> 
			print_endline str;
			self # rmConn id;
		| _ -> print_endline "Unrecognized error";

	method handleRequests (c, responseOut, errorOut : file_descr * out_channel * out_channel) = 
		let count = ref 0 in 
		let notDone = ref true in
		let r = ref (Io.new_reader c 16) in 
		while !notDone do
			match Messages.readMessage !r with
			| r_, None, Some (Error str) -> 
				Marshal.to_channel errorOut (Error str) [];
				notDone := false;
				r := r_;
			| r_, Some req, None -> 
				Mutex.lock appMtx;
				count := !count + 1;
				self # handleRequest (req : request) responseOut;
				Mutex.unlock appMtx;
				r := r_;
		done;

	method handleRequest (req : request) (responseOut : out_channel) = 
		let response = match Messages.requestType req with 
		| `echo ->
			(match Messages.parseRequestEcho req with
			| Some message -> Messages.toResponseEcho message
			| None -> Messages.toResponseError "RequestEcho missing message")
		| `flush -> 
			Messages.toResponseFlush ()
		| `info -> 
			let data = self # app # info () in 
			Messages.toResponseInfo data
		| `set_option -> 
			(match Messages.parseRequestSetOption req with 
			| Some key, Some value -> 
				let log = self # app # set_option key value in 
				Messages.toResponseSetOption log
			| _ -> 
				Messages.toResponseError "RequestSetOption missing key-value")
		| `append_tx -> 
			(match Messages.parseRequestAppendTx req with 
			| Some tx ->
				let result = (self # app # append_tx tx : Results.result) in 
				Messages.toResponseAppendTx result.Results.code result.Results.data result.Results.log
			| None -> 
				Messages.toResponseError "RequestAppendTx missing tx")
		| `check_tx ->
			(match Messages.parseRequestCheckTx req with 
			| Some tx ->
				let result = (self # app # check_tx tx : Results.result) in 
				Messages.toResponseCheckTx result.Results.code result.Results.data result.Results.log
			| None -> 
				Messages.toResponseError "RequestCheckTx missing tx")
		| `commit ->
			let result = (self # app # commit () : Results.result) in 
			Messages.toResponseCommit result.Results.code result.Results.data result.Results.log
		| `query ->
			(match Messages.parseRequestQuery req with
			| Some query -> 
				let result = (self # app # query query : Results.result) in 
				Messages.toResponseQuery result.Results.code result.Results.data result.Results.log
			| None -> 
				Messages.toResponseError "RequestQuery missing query")
		| `init_chain -> 
			(match Messages.parseRequestInitChain req with
			| Some validators ->
				self # app # init_chain validators;
				Messages.toResponseInitChain ()
			| None -> 
				Messages.toResponseError "RequestInitChain missing validators")
		| `begin_block ->
			(match Messages.parseRequestBeginBlock req with
			| Some height ->
				self # app # begin_block height;
				Messages.toResponseBeginBlock ()
			| None -> 
				Messages.toResponseError "RequestBeginBlock missing height")
		| `end_block ->
			(match Messages.parseRequestEndBlock req with 
			| Some height ->
				let validators = self # app # end_block height in 
				Messages.toResponseEndBlock validators
			| None -> 
				Messages.toResponseError "RequestEndBlock missing height")
		| _ -> Messages.toResponseError "Unknown request" in 
		Marshal.to_channel responseOut response [];

	method handleResponses (c, responseIn, errorOut : file_descr * in_channel * out_channel) = 
		let count = ref 0 in
		let notDone = ref true in 
		let w = ref (Io.new_writer c 16) in 
		while !notDone do 
			let res = (Marshal.from_channel responseIn : response) in
			match Messages.writeMessage res !w with 
			| w_, Some (Error str) ->
				Marshal.to_channel errorOut (Error str) []; 
				notDone := false;
				w := w_;
			| w_, None ->
				if Messages.isResponseFlush res then w := Io.flush w_ else w := w_;
				count := !count + 1;
		done;
end;;








