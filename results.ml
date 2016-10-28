module TMSP = Types_piqi
open TMSP

type result = {
	code : code_type;
	data : bytes;
	log : string
}

let newResult (code : code_type) (data : bytes) (log : string) = 
	{code=code; data=data; log=log};;

let isOK (res : result) = 
	res.code = `ok;;

let isErr (res : result) = 
	res.code <> `ok;;

let error (res : result) = 
	Printf.sprintf (* error *)

let prependLog (res : result) (log : string) = 
	{code=res.code; data=res.data; log=String.concat "" [log; ";"; res.log]};;

let appendLog (res : result) (log : string) = 
	{code=res.code; data=res.data; log=String.concat "" [res.log; ";"; log]};;

let setLog (res : result) (log : string) = 
	{code=res.code; data=res.data; log=log};;

let setData (res : result) (data : bytes) = 
	{code=res.code; data=data; log=res.log};;

let newResultOk (data : bytes) (log : string) = 
	{code=`ok; data=data; log=log};;

let ok = newResultOk Bytes.empty "";;

let newError (code : code_type) (log : string) = 
	{code=code; data=Bytes.empty; log=log}







