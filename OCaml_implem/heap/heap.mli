(** Module implementing (imperative) Binary Heaps *)

(** Abstract type for binary heaps *)
type 'a t

(** Array to binary heap conversion *)
val of_array : 'a array -> ('a -> 'a -> bool) -> 'a t

(** Binary heap to array conversion *)
val to_array : 'a t -> 'a array

(** Insert a value *)
val insert : 'a t -> 'a -> unit

(** Extract the root value *)
val extract : 'a t -> 'a

(** Returns true if the heap is empty *)
val is_empty : 'a t -> bool

(** Dump a binary heap in stdout (in dot format) *)
val dump : int t -> unit