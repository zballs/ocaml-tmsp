open Unix

exception Error of string

type service = < start : unit -> bool * exn option; 
				 onStart : unit -> exn option; 
				 stop : unit -> bool; 
				 onStop : unit -> exn option; 
				 reset : unit -> bool * exn option;
				 onReset : unit -> exn option;
				 isRunning : unit -> bool;
				 toString : unit -> string >

(****** Base service ******)

class base_service (name : string) = 
object(self)
	val name = name
	val mutable started = 0
	val mutable stopped = 0
	val startMtx = Mutex.create () 
	val stopMtx = Mutex.create ()

	(* TODO: implement atomic synchronization *)

	method private compare_and_swap_start (old_val : int) (new_val : int)  =
		Mutex.lock startMtx;
		if started = old_val then
			begin
				started <- new_val;
				Mutex.unlock startMtx;
				true 
			end
		else 
			begin 
				Mutex.unlock startMtx;
				false
			end

	method private load_start () = 
		Mutex.lock startMtx;
		let _started = started in 
		Mutex.unlock startMtx;
		_started

	method private compare_and_swap_stop (old_val : int) (new_val : int) = 
		Mutex.lock stopMtx;
		if stopped = old_val then
			begin
				stopped <- new_val;
				Mutex.unlock stopMtx;
				true
			end
		else 
			begin
				Mutex.unlock stopMtx;
				false
			end

	method private load_stop () = 
		Mutex.lock stopMtx;
		let _stopped = stopped in 
		Mutex.unlock stopMtx;
		_stopped

	method start () =  
		if self # compare_and_swap_start 0 1 then 
			if self # load_stop () = 1 then 
				(* log *)
				false, None 
			else 
				(* log *)
				let err = self # onStart () in
				true, err
		else 
			(* log *)
			false, None

	method onStart () =
		if true then 
			None
		else 
			(* never should happen *)
			Some (Error "Error:") 

	method stop () = 
		if self # compare_and_swap_stop 0 1 then
		begin
			(* log *) 
			ignore (self # onStop ());
			true
		end
		else 
			(* log *)
			false

	method onStop () =
		if true then 
			None
		else 
			(* never should happen *)
			Some (Error "Error:")

	method reset () = 
		if self # compare_and_swap_stop 1 0 then 
		begin
			ignore (self # compare_and_swap_start 1 0);
			let err = self # onReset () in 
			true, err
		end
		else 
			(* log *)
			false, None

	method onReset () = 
		Some (Error "The service cannot be reset")

	method isRunning () = 
		(self # load_start () = 1) && (self # load_stop () = 0)

	method toString () = name
end;;

(****** Quit service ******)

class quit_service  (name : string) = object
	inherit base_service name as base 
	val mutable quit = None

	method onStart () = 
		quit <- Some (Unix.open_process "quit");
		None

	method onStop () = 
		match quit with 
		| Some (i, o) -> 
			begin 
				ignore (Unix.close_process (i, o)); 
				print_endline "Quitting service...";
				quit <- None;
				None
			end
		| None -> 
			Some (Error "Service has not started")
	end;;











