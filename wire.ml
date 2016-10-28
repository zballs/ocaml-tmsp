open Hex

type hex = Hex.t

let abs_val i = if i < 0 then -i else i;;

let pow (x : int) (n : int) =
	let rec exp x n res = 
	if n = 0 then res else
		exp x (n-1) (x * res) in
	exp x n 1;;

let hex_to_bytes (h : hex) = Bytes.of_string (Hex.to_string h);;
let bytes_to_hex (b : bytes) = Hex.of_string (Bytes.to_string b);;

let uvarint_size (i : int) = 
	if i = 0 then 0 else 
		let rec calc (i : int) (j : int) = 
		if j = 8 then 8 else 
			if i < (1 lsl (j * 8)) then j 
			else calc i (j+1) in 
		calc i 1;;

let make_bytes (n : int) (i : int) = Bytes.make n (Char.chr i);;
let make_byte (i : int) = make_bytes 1 i;;
let first_byte (b : bytes) = Bytes.get b 0;;
let rest_bytes (b : bytes) = let len = (Bytes.length b) - 1 in Bytes.sub b 1 len

let encode_big_endian (i : int) (size : int) = 
	let rec set_bytes (b : bytes) (i : int) (idx : int) =
	if idx = 0 then b
	else let b = Bytes.cat (make_byte (i mod 256)) b in 
		set_bytes b (i / 256) (idx-1) in
	set_bytes Bytes.empty i size;;


let decode_big_endian (b : bytes) (size : int) = 
	if size = 0 then (b, 0)
	else let rec calc (b : bytes) (total : int) (size : int) = 
		if size = 0 then 
			(b, total) 
		else
			let code = Char.code (first_byte b) in 
			calc (rest_bytes b) (total + (code * (pow 256 (size-1)))) (size-1) in
	calc b 0 size;;

let encode_varint (i : int) = 
	let size = uvarint_size (abs_val i) in 
	if size = 0 then Bytes.empty else
		let bytes = encode_big_endian i size in
		let size = if size < 0 then size + 0xF0 else size in
		Bytes.cat (make_byte size) bytes;;

let decode_varint (b : bytes) = 
	let size = Char.code (first_byte b) in
	if size = 0 then (b, 0) else
		let sign = if size > 0xF0 then -1 else 1 in 
		let (b, n) = decode_big_endian (rest_bytes b) (size mod 0xF0) in 
		b, sign*n;;

let encode_bytes (b : bytes) = 
	let size = encode_varint (Bytes.length b) in 
	Bytes.cat size b;;

let decode_bytes (b : bytes) =
	let (b, _) = decode_varint b in b;;

let encode_string (str : string) = 
	let b = Bytes.of_string str in
	encode_bytes b;;

let decode_string (b : bytes) = 
	let (b, _) = decode_bytes b in 
	let str = Bytes.to_string b in str;;







