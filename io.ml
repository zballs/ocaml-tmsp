module TMSP = Types_piqi
open TMSP
open Unix
open Buffer

type buffer = Buffer.t 

type reader = {
	chan: in_channel;
	buf : buffer
}

exception Error of string;;

let new_reader (c : file_descr) (n : int) = 
	let chan = in_channel_of_descr c in
	let buf = create n in 
	{chan=chan; buf=buf};;

let receive (r : reader) (n : int) = 
	let buf = r.buf in  
	let err = match add_channel buf r.chan n with
	| exception _ -> 
		Some (Error "Read error") (* EOF *)
	| _ -> None in
	{r with buf=buf}, err;;

let read (r : reader) =  
	let maxlength = 1024 in
	let (r, err) = receive r maxlength in 
	let b = to_bytes r.buf in 
	let buf = r.buf in 
	reset buf;
	{r with buf=buf}, b, err;;

type writer = {
	chan: out_channel; 
	buf: buffer
}

let new_writer (c : file_descr) (n : int) = 
	let chan = out_channel_of_descr c in 
	let buf = create n in 
	{chan=chan; buf=buf};;

let send (w : writer) (b : bytes)  =
	let buf = w.buf in
	add_bytes buf b; 
	let err = match output_buffer w.chan buf with
	| exception _ -> 
		Some (Error "Send error")
	| _ -> 
		None in 
	{w with buf=buf}, err;;

let write (w : writer) (b : bytes) =
	let (w, err) = send w b in 
	let buf = w.buf in 
	reset buf;
	{w with buf=buf}, err;;

let flush (w : writer) = 
	let chan = w.chan in 
	ignore (flush chan);
	{w with chan=chan};;


