module TMSP = Types_piqi
open TMSP
open Batteries

let newResult = Results.newResult
let newResultOk = Results.newResultOk
let ok = Results.ok 

class application = 
	object(self)
	val mutable hashCount = 0
	val mutable txCount = 0 
	val mutable serial = false 

	method info () = Printf.sprintf "hashes:%d\ntxs:%d\n" hashCount txCount

	method set_option (key : string) (value : string) = 
		if (key = "serial") && (value = "on") then 
		begin
			serial <- true;
			Printf.sprintf "%s=%s\n" key value
		end
		else Printf.sprintf "Invalid key=value: %s=%s\n" key value

	method append_tx (tx : binary) = 
		if serial then 
			let (_, txValue) = Wire.decode_varint (tx : bytes) in 
			if (txValue <> txCount) then newResult `bad_nonce (Wire.encode_varint txCount) ""
			else begin
				txCount <- txCount + 1;
				newResultOk (Wire.encode_varint txCount) ""
			end
		else begin
			txCount <- txCount + 1;
			newResultOk (Wire.encode_varint txCount) ""
		end
	
	method check_tx (tx : binary) = 
		if serial then 
			let (_, txValue) = Wire.decode_varint (tx : bytes) in 
			if (txValue <> txCount) then newResult `bad_nonce Bytes.empty ""
			else ok
		else ok

	method commit () = 
		hashCount <- hashCount + 1; 
		if txCount = 0 then newResultOk (Wire.encode_varint hashCount) ""
		else let b = Wire.encode_big_endian txCount 8 in
			let hash = BatString.rev (Bytes.to_string b) in 
			newResultOk (Wire.encode_varint hashCount) hash

	method query (query : binary) = ok
	method init_chain (validators : validator list) = ()
	method begin_block (height : uint64) = ()
	method end_block (height : uint64) = ([] : validator list)
end;;






