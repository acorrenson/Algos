(** Module implementing (imperative) Binary Heaps *)

(** Abstract type for binary heaps *)
type 'a t

(** Array to binary heap conversion *)
val of_array : 'a array -> 'a t

(** Binary heap to array conversion *)
val to_array : 'a t -> 'a array

(** Insert a value *)
val insert : 'a t -> 'a -> unit

(** Dump a binary heap in stdout (in dot format) *)
val dump : int t -> unit