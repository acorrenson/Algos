(**
   Combinatoric functions over (sorted, nodup) lists.
   The following algorithms are not intended to be very efficients
   but their implementation is very concise and clear.
*)

(** {2 Some workarounds are required}

    The following algorihtms make intensive use of [map] and [append].
    Since both functions are not tail-recursive,
    we need to be a clever enough to avoid blowing up the stack.

    An easy solution is to implement alternatives to [map] and [append]
    using continuations.

    As a benchmark, within the utop interpreter, [subset_n 20] computes
    the [1048576 = 2^20] subsets in less than 2 sec without memory issues.

    Still within the utop interpreter, [permut_n 10] computes
    the [3628800 = 10!] permuations in less than 6 sec without memory limitations.

    For the record, without using [tmap] and [tapp], [subset_n] and [permut_n] both
    crash with stack-overflows.
*)

(** Tail-recursive [map] with continuations *)
let tmap f l =
  let rec tmap_cont f k = function
    | [] -> k []
    | x::xs -> tmap_cont f (fun r -> k ((f x)::r)) xs
  in
  tmap_cont f (fun x -> x) l

(** Tail-recursive [append] with continuations *)
let tapp l1 l2 =
  let rec tapp_cont k l = function
    | [] -> k l
    | x::xs -> tapp_cont (fun r -> k (x::r)) l xs
  in
  tapp_cont (fun x -> x) l2 l1

(** New alias for [tapp] *)
let (@) = tapp

(** {2 Implementations} *)

(** Compute all subsets of a set (given as a list without duplications).
    [subset set] Preserves the order of the elements in [set] *)
let subset =
  List.fold_left (fun a v -> (tmap (fun l -> l @ [v]) a) @ a) [[]]

(** [subset_n n] is [subset [1..n]] *)
let subset_n n = subset (List.init n ((+) 1))

(** Computes all permutations ending by [p]
    and containing [p] ∪ [rem].

    For example [aux_perm [1; 2] [3; 4]] gives [[[3; 4; 1; 2]; [4; 3; 1; 2]]] *)
let rec aux_perm p rem =
  if rem = [] then [p]
  else List.fold_left (fun a x ->
      (aux_perm (x::p) (List.filter ((<>) x) rem)) @ a
    ) [] rem

(** Computes all permutations of a given list *)
let permut l = aux_perm [] l

(** [permut_n n] is [permut [1..n]] *)
let permut_n n = aux_perm [] (List.init n ((+) 1))