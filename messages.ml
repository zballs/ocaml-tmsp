open Marshal

module TMSP = Types_piqi
open TMSP

let request = default_request ()
let response = default_response ()

(* Requests *)

let toRequestEcho (message : string) =
	{request with 
		Request.echo = Some Request_echo.({
			message = Some message
		})
	}

let toRequestFlush () =
	{request with
		Request.flush = Some Request_flush.({
			_dummy = ()
		})
	}

let toRequestInfo () =
	{request with
		Request.info = Some Request_info.({
			_dummy = ()
		})
	}

let toRequestSetOption (key : string) (value : string) = 
	{request with
		Request.set_option = Some Request_set_option.({
			key = Some key;
			value = Some value
		})
	}

let toRequestAppendTx (tx : binary) = 
	{request with
		Request.append_tx = Some Request_append_tx.({
			tx = Some tx
		})
	}

let toRequestCheckTx (tx : binary) = 
	{request with
		Request.check_tx = Some Request_check_tx.({
			tx = Some tx
		})
	}

let toRequestCommit () = 
	{request with
		Request.commit = Some Request_commit.({
			_dummy = ()
		})
	}

let toRequestQuery (query : binary) = 
	{request with
		Request.query = Some Request_query.({
			query = Some query
		})
	}

let toRequestInitChain (validators : validator list) = 
	{request with
		Request.init_chain = Some Request_init_chain.({
			validators = validators
		})
	}

let toRequestBeginBlock (height : uint64) = 
	{request with
		Request.begin_block = Some Request_begin_block.({
			height = Some height
		})
	}

let toRequestEndBlock (height : uint64) = 
	{request with
		Request.end_block = Some Request_end_block.({
			height = Some height
		})
	}

(* Responses *)

let toResponseError (error : string) = 
	{response with
		Response.error = Some Response_error.({
			error = Some error
		})
	}

let toResponseEcho (message : string) = 
	{response with
		Response.echo = Some Response_echo.({
			message = Some message
		})	
	}

let toResponseFlush () = 
	{response with
		Response.flush = Some Response_flush.({
			_dummy = ()
		})
	}

let toResponseInfo (info : string) = 
	{response with
		Response.info = Some Response_info.({
			info = Some info
		})
	}

let toResponseSetOption (log : string) =
	{response with
		Response.set_option = Some Response_set_option.({
			log = Some log
		})
	}

let toResponseAppendTx (code : code_type) (data : binary) (log : string) = 
	 {response with
		Response.append_tx = Some Response_append_tx.({
			code = Some code;
			data = Some data;
			log = Some log
		})
	}

let toResponseCheckTx (code : code_type) (data : binary) (log : string) =
	{response with
		Response.check_tx = Some Response_check_tx.({
			code = Some code;
			data = Some data;
			log = Some log
		})
	}

let toResponseCommit (code : code_type) (data : binary) (log : string) = 
	{response with
		Response.commit = Some Response_commit.({
			code = Some code;
			data = Some data;
			log = Some log
		})
	}

let toResponseQuery (code : code_type) (data : binary) (log : string) = 
	{response with
		Response.query = Some Response_query.({
			code = Some code;
			data = Some data;
			log = Some log
		})
	}

let toResponseInitChain () = 
	{response with
		Response.init_chain = Some Response_init_chain.({
			_dummy = ()
		})
	}

let toResponseBeginBlock () =
	 {response with
		Response.begin_block = Some Response_begin_block.({
		 	_dummy = ()
		})
	}

let toResponseEndBlock (validators : validator list) = 
	{response with
		Response.end_block = Some Response_end_block.({
			diffs = validators
		})
	}

(* Match request *)

let isRequestEcho (req : request) = 
	match req with
	| {Request.echo = Some _; Request.flush = None; Request.info = None; Request.set_option = None; Request.append_tx = None; Request.check_tx = None; Request.commit = None; Request.query = None; Request.init_chain = None; Request.begin_block = None; Request.end_block = None} -> true 
	| _ -> false 

let isRequestFlush (req : request) = 
	match req with
	| {Request.echo = None; Request.flush = Some _; Request.info = None; Request.set_option = None; Request.append_tx = None; Request.check_tx = None; Request.commit = None; Request.query = None; Request.init_chain = None; Request.begin_block = None; Request.end_block = None} -> true 
	| _ -> false 

let isRequestInfo (req : request) = 
	match req with
	| {Request.echo = None; Request.flush = None; Request.info = Some _; Request.set_option = None; Request.append_tx = None; Request.check_tx = None; Request.commit = None; Request.query = None; Request.init_chain = None; Request.begin_block = None; Request.end_block = None} -> true 
	| _ -> false 

let isRequestSetOption (req : request) = 
	match req with
	| {Request.echo = None; Request.flush = None; Request.info = None; Request.set_option = Some _; Request.append_tx = None; Request.check_tx = None; Request.commit = None; Request.query = None; Request.init_chain = None; Request.begin_block = None; Request.end_block = None} -> true 
	| _ -> false 

let isRequestAppendTx (req : request) = 
	match req with
	| {Request.echo = None; Request.flush = None; Request.info = None; Request.set_option = None; Request.append_tx = Some _; Request.check_tx = None; Request.commit = None; Request.query = None; Request.init_chain = None; Request.begin_block = None; Request.end_block = None} -> true 
	| _ -> false 

let isRequestCheckTx (req : request) = 
	match req with
	| {Request.echo = None; Request.flush = None; Request.info = None; Request.set_option = None; Request.append_tx = None; Request.check_tx = Some _; Request.commit = None; Request.query = None; Request.init_chain = None; Request.begin_block = None; Request.end_block = None} -> true 
	| _ -> false 

let isRequestCommit (req : request) = 
	match req with
	| {Request.echo = None; Request.flush = None; Request.info = None; Request.set_option = None; Request.append_tx = None; Request.check_tx = None; Request.commit = Some _; Request.query = None; Request.init_chain = None; Request.begin_block = None; Request.end_block = None} -> true 
	| _ -> false 

let isRequestQuery (req : request) = 
	match req with
	| {Request.echo = None; Request.flush = None; Request.info = None; Request.set_option = None; Request.append_tx = None; Request.check_tx = None; Request.commit = None; Request.query = Some _; Request.init_chain = None; Request.begin_block = None; Request.end_block = None} -> true 
	| _ -> false 

let isRequestInitChain (req : request) = 
	match req with
	| {Request.echo = None; Request.flush = None; Request.info = None; Request.set_option = None; Request.append_tx = None; Request.check_tx = None; Request.commit = None; Request.query = None; Request.init_chain = Some _; Request.begin_block = None; Request.end_block = None} -> true 
	| _ -> false 

let isRequestBeginBlock (req : request) = 
	match req with
	| {Request.echo = None; Request.flush = None; Request.info = None; Request.set_option = None; Request.append_tx = None; Request.check_tx = None; Request.commit = None; Request.query = None; Request.init_chain = None; Request.begin_block = Some _; Request.end_block = None} -> true 
	| _ -> false 

let isRequestEndBlock (req : request) = 
	match req with
	| {Request.echo = None; Request.flush = None; Request.info = None; Request.set_option = None; Request.append_tx = None; Request.check_tx = None; Request.commit = None; Request.query = None; Request.init_chain = None; Request.begin_block = None; Request.end_block = Some _} -> true 
	| _ -> false 

let requestType (req : request) = 
	if isRequestEcho req then `echo else
	if isRequestFlush req then `flush else
	if isRequestInfo req then `info else 
	if isRequestSetOption req then `set_option else
	if isRequestAppendTx req then `append_tx else 
	if isRequestCheckTx req then `check_tx else
	if isRequestCommit req then `commit else
	if isRequestQuery req then `query else 
	if isRequestInitChain req then `init_chain else
	if isRequestBeginBlock req then `begin_block else
	if isRequestEndBlock req then `end_block else
	`null_message

(* Parse request *)

let parseRequestEcho (req : request) = 
	match req with 
	| {Request.echo = Some {Request_echo.message = string_option}; _} -> string_option
	| _ -> None 

let parseRequestSetOption (req : request) = 
	match req with 
	| {Request.set_option = Some {Request_set_option.key = string_option1; Request_set_option.value = string_option2}; _} -> 
		string_option1, string_option2
	| _ -> None, None 

let parseRequestAppendTx (req : request) = 
	match req with 
	| {Request.append_tx = Some {Request_append_tx.tx = binary_option}; _} ->
		binary_option
	| _ -> None

let parseRequestCheckTx (req : request) = 
	match req with 
	| {Request.check_tx = Some {Request_check_tx.tx = binary_option}; _} ->
		binary_option
	| _ -> None

let parseRequestQuery (req : request) = 
	match req with 
	| {Request.query = Some {Request_query.query = binary_option}; _} ->
		binary_option
	| _ -> None 

let parseRequestInitChain (req : request) = 
	match req with 
	| {Request.init_chain = Some {Request_init_chain.validators = validators}; _} ->
		Some validators
	| _ -> None

let parseRequestBeginBlock (req : request) = 
	match req with 
	| {Request.begin_block = Some {Request_begin_block.height = uint_option}; _} ->
		uint_option
	| _ -> None

let parseRequestEndBlock (req : request) = 
	match req with 
	| {Request.end_block = Some {Request_end_block.height = uint_option}; _} ->
		uint_option
	| _ -> None


(* Match response *)

let isResponseError (res : response) = 
	match res with
	| {Response.error = Some _; Response.echo = None; Response.flush = None; Response.info = None; Response.set_option = None; Response.append_tx = None; Response.check_tx = None; Response.commit = None; Response.query = None; Response.init_chain = None; Response.begin_block = None; Response.end_block = None} -> true 
	| _ -> false 

let isResponseEcho (res : response) = 
	match res with
	| {Response.error = None; Response.echo = Some _; Response.flush = None; Response.info = None; Response.set_option = None; Response.append_tx = None; Response.check_tx = None; Response.commit = None; Response.query = None; Response.init_chain = None; Response.begin_block = None; Response.end_block = None} -> true 
	| _ -> false 

let isResponseFlush (res : response) = 
	match res with
	| {Response.error = None; Response.echo = None; Response.flush = Some _; Response.info = None; Response.set_option = None; Response.append_tx = None; Response.check_tx = None; Response.commit = None; Response.query = None; Response.init_chain = None; Response.begin_block = None; Response.end_block = None} -> true 
	| _ -> false 

let isResponseInfo (res : response) = 
	match res with
	| {Response.error = None; Response.echo = None; Response.flush = None; Response.info = Some _; Response.set_option = None; Response.append_tx = None; Response.check_tx = None; Response.commit = None; Response.query = None; Response.init_chain = None; Response.begin_block = None; Response.end_block = None} -> true 
	| _ -> false 

let isResponseSetOption (res : response) = 
	match res with
	| {Response.error = None; Response.echo = None; Response.flush = None; Response.info = None; Response.set_option = Some _; Response.append_tx = None; Response.check_tx = None; Response.commit = None; Response.query = None; Response.init_chain = None; Response.begin_block = None; Response.end_block = None} -> true 
	| _ -> false 

let isResponseAppendTx (res : response) = 
	match res with
	| {Response.error = None; Response.echo = None; Response.flush = None; Response.info = None; Response.set_option = None; Response.append_tx = Some _; Response.check_tx = None; Response.commit = None; Response.query = None; Response.init_chain = None; Response.begin_block = None; Response.end_block = None} -> true 
	| _ -> false 

let isResponseCheckTx (res : response) = 
	match res with
	| {Response.error = None; Response.echo = None; Response.flush = None; Response.info = None; Response.set_option = None; Response.append_tx = None; Response.check_tx = Some _; Response.commit = None; Response.query = None; Response.init_chain = None; Response.begin_block = None; Response.end_block = None} -> true 
	| _ -> false 

let isResponseCommit (res : response) = 
	match res with
	| {Response.error = None; Response.echo = None; Response.flush = None; Response.info = None; Response.set_option = None; Response.append_tx = None; Response.check_tx = None; Response.commit = Some _; Response.query = None; Response.init_chain = None; Response.begin_block = None; Response.end_block = None} -> true 
	| _ -> false 

let isResponseQuery (res : response) = 
	match res with
	| {Response.error = None; Response.echo = None; Response.flush = None; Response.info = None; Response.set_option = None; Response.append_tx = None; Response.check_tx = None; Response.commit = None; Response.query = Some _; Response.init_chain = None; Response.begin_block = None; Response.end_block = None} -> true 
	| _ -> false 

let isResponseInitChain (res : response) = 
	match res with
	| {Response.error = None; Response.echo = None; Response.flush = None; Response.info = None; Response.set_option = None; Response.append_tx = None; Response.check_tx = None; Response.commit = None; Response.query = None; Response.init_chain = Some _; Response.begin_block = None; Response.end_block = None} -> true 
	| _ -> false 

let isResponseBeginBlock (res : response) = 
	match res with
	| {Response.error = None; Response.echo = None; Response.flush = None; Response.info = None; Response.set_option = None; Response.append_tx = None; Response.check_tx = None; Response.commit = None; Response.query = None; Response.init_chain = None; Response.begin_block = Some _; Response.end_block = None} -> true 
	| _ -> false 

let isResponseEndBlock (res : response) = 
	match res with
	| {Response.error = None; Response.echo = None; Response.flush = None; Response.info = None; Response.set_option = None; Response.append_tx = None; Response.check_tx = None; Response.commit = None; Response.query = None; Response.init_chain = None; Response.begin_block = None; Response.end_block = Some _} -> true 
	| _ -> false 

let responseType (res : response) = 
	if isResponseError res then `error else
	if isResponseEcho res then `echo else
	if isResponseFlush res then `flush else
	if isResponseInfo res then `info else 
	if isResponseSetOption res then `set_option else
	if isResponseAppendTx res then `append_tx else 
	if isResponseCheckTx res then `check_tx else
	if isResponseCommit res then `commit else
	if isResponseQuery res then `query else 
	if isResponseInitChain res then `init_chain else
	if isResponseBeginBlock res then `begin_block else
	if isResponseEndBlock res then `end_block else
	`null_message

(* Parse response *)

let parseResponseError (res : response) = 
	match res with 
	| {Response.error = Some {Response_error.error = string_option}; _} -> string_option 
	| _ -> None

let parseResponseEcho (res : response) = 
	match res with 
	| {Response.echo = Some {Response_echo.message = string_option}; _} -> string_option
	| _ -> None 

let parseResponseInfo (res : response) = 
	match res with 
	| {Response.info = Some {Response_info.info = string_option}; _} -> string_option
	| _ -> None 

let parseResponseSetOption (res : response) = 
	match res with 
	| {Response.set_option = Some {Response_set_option.log = string_option}; _} -> string_option 
	| _ -> None 

let parseResponseAppendTx (res : response) = 
	match res with 
	| {Response.append_tx = Some {Response_append_tx.code = code_type_option; Response_append_tx.data = binary_option; Response_append_tx.log = string_option}; _} ->
		code_type_option, binary_option, string_option
	| _ -> None, None, None

let parseResponseCheckTx (res : response) = 
	match res with 
	| {Response.check_tx = Some {Response_check_tx.code = code_type_option; Response_check_tx.data = binary_option; Response_check_tx.log = string_option}; _} ->
		code_type_option, binary_option, string_option
	| _ -> None, None, None

let parseResponseCommit (res : response) = 
	match res with 
	| {Response.commit = Some {Response_commit.code = code_type_option; Response_commit.data = binary_option; Response_commit.log = string_option}; _} ->
		code_type_option, binary_option, string_option
	| _ -> None, None, None

let parseResponseQuery (res : response) = 
	match res with 
	| {Response.query = Some {Response_query.code = code_type_option; Response_query.data = binary_option; Response_query.log = string_option}; _} ->
		code_type_option, binary_option, string_option
	| _ -> None, None, None

let parseResponseEndBlock (res : response) = 
	match res with 
	| {Response.end_block = Some {Response_end_block.diffs = validators}; _} -> Some validators
	| _ -> None


exception Error of string

(* Write TMSP message *)

let writeMessage msg (w : Io.writer) = 
	let b = Marshal.to_bytes msg [] in 
	let (w, err) = Io.write w b in 
	w, err;;

(* Read TMSP message *)

let readMessage (r : Io.reader) = 
	let (r, b, err) = Io.read r in 
	match err with 
	| Some (Error str) -> 
		r, None, Some (Error str)
	| None ->
		let (msg, err) = match Marshal.from_bytes b 0 with 
		| exception _ ->
			None, Some (Error "Marshaling error")
		| msg ->
			Some msg, None in 
		r, msg, err;;



