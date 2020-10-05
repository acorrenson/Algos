type 'a t

val set : 'a t -> int -> 'a -> unit

val get : 'a t -> int -> 'a

val fold_left : ('a -> 'b -> 'a) -> 'a -> 'b t -> 'a

val fold_right : ('b -> 'a -> 'a) -> 'b t -> 'a -> 'a

val map : ('a -> 'b) -> 'a t -> 'b t

val mapi : (int -> 'a -> 'b) -> 'a t -> 'b t

val of_array : 'a array -> 'a t

val length : 'a t -> int

val swap : 'a t -> int -> int -> unit

val iter : ('a -> unit) -> 'a t -> unit

val iteri : (int -> 'a -> unit) -> 'a t -> unit