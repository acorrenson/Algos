type 'a binomial_tree = {value: 'a; order: int; children: 'a binomial_heap}
and 'a binomial_heap = 'a binomial_tree list
(* We represent binomial heaps as lists of binomial trees with distinct ascending orders. *)

let rec insert_tree a h =
  let rec ins a = function
    | [] -> [a]
    | b::t -> if a.order < b.order then a::b::t
      else if b.order < a.order then b::(ins a t)
      else ins (merge_tree a b) t
  in ins a h

and merge_tree a b =
  if a.value < b.value then {value = a.value; order = a.order + 1; children = insert_tree b a.children}
  else {value = b.value; order = b.order + 1; children = insert_tree a b.children}
(* merge_tree expects binomial trees of the same order *)

let merge_heap h = List.fold_right insert_tree h

let find_min h =
  let rec minimum m = function
    | [] -> m
    | a::t -> if a.value < m.value then minimum a t else minimum m t
  in match h with
  | [] -> failwith "empty heap"
  | a::t -> minimum a t

let pop_min h =
  let a = find_min h in
  let rec remove_a = function
    | [] -> failwith "empty heap"
    | b::t -> if b == a then t else b::(remove_a t)
  in a.value, merge_heap (remove_a h) (a.children)

let singleton x = {value = x; order = 0; children = []}

let insert x h = insert_tree (singleton x) h

let insert_list l h = List.fold_right insert l h
