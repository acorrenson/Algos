(**
   A module implementing binomial heaps
*)

(** Binomial trees *)
type 'a binomial_tree = {
  value: 'a;
  order: int;
  children: 'a binomial_heap
}

(** We implements binomial heaps as list of binomial trees *)
and 'a binomial_heap = 'a binomial_tree list

(** Insert a binomial tree in a binomial heap *)
let rec insert_tree a h =
  let rec ins a = function
    | [] -> [a]
    | b::t -> if a.order < b.order then a::b::t
      else if b.order < a.order then b::(ins a t)
      else ins (merge_tree a b) t
  in ins a h

(** Merge two binomial trees *)
and merge_tree a b =
  if b.order = a.order then begin
    if a.value < b.value then {value = a.value; order = a.order + 1; children = insert_tree b a.children}
    else {value = b.value; order = b.order + 1; children = insert_tree a b.children}
  end else failwith "merge_tree expects binomial trees of the same order"

(** Merge two binomial heap *)
let merge_heap h = List.fold_right insert_tree h

(** Find the minimum of a binomial heap *)
let find_min h =
  let rec minimum m = function
    | [] -> m
    | a::t -> if a.value < m.value then minimum a t else minimum m t
  in match h with
  | [] -> failwith "empty heap"
  | a::t -> minimum a t

(** Remove the minimum of a binomial heap.
    Returns the minimum and the new heap. *)
let pop_min h =
  let a = find_min h in
  let rec remove_a = function
    | [] -> failwith "empty heap"
    | b::t -> if b == a then t else b::(remove_a t)
  in a.value, merge_heap (remove_a h) (a.children)

let singleton x = {value = x; order = 0; children = []}

let empty = []

(** Insert an element in a binomial heap *)
let insert x h = insert_tree (singleton x) h

(** Insert a list of elements in a binomial heap *)
let insert_list l h = List.fold_right insert l h

