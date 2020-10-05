(** Basic type for binary trees *)
type 'a btree =
  | Leaf
  | Node of 'a btree * 'a * 'a btree

(** Order for DFS traversal *)
type order = POST | PRE | INF

(** Map on btrees *)
let rec map f = function
  | Leaf -> Leaf
  | Node (left, value, right) ->
    Node (map f left, f value, map f right)

(** Depth First traversal *)
let rec dfs ord = function
  | Leaf -> []
  | Node (left, value, right) ->
    let lpath = dfs ord left in
    let rpath = dfs ord right in
    match ord with
    | POST  -> lpath @ rpath @ [value]
    | PRE   -> [value] @ lpath @ rpath
    | INF   -> lpath @ [value] @ rpath

(** Breadth First traversal *)
let bfs bt =
  let rec step q p =
    match q with
    | [] -> p
    | Leaf::bts -> step bts p
    | Node (left, value, right)::bts ->
      step (bts @ [left; right]) (value::p)
  in
  step [bt] [] |> List.rev

(** Node constructor *)
let nd a b c = Node (b, a, c)

(** Terminal node constructor *)
let lf a = nd a Leaf Leaf

let dump str t f =
  let out = open_out f in
  let rec step = function
    | Leaf -> ()
    | Node (Leaf, _, Leaf) -> ()
    | Node ((Node (_, vl, _) as l), v, (Node (_, vr, _) as r)) ->
      let str_v = (str v) in
      Printf.fprintf out "\"%s\" -> \"%s\";\n" (str_v) (str vl);
      Printf.fprintf out "\"%s\" -> \"%s\";\n" (str_v) (str vr);
      step l;
      step r
    | Node ((Node (_, v', _) as l), v, Leaf) 
    | Node (Leaf, v, (Node (_, v', _) as l)) ->
      Printf.fprintf out "\"%s\" -> \"%s\";\n" (str v) (str v');
      step l
  in
  Printf.fprintf out "digraph {\n";
  step t;
  Printf.fprintf out "}\n"