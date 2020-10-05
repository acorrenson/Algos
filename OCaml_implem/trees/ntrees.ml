(** Basic type for n-ary trees *)
type 'a tree = Node of 'a * 'a tree list

(** Order for DFS traversal *)
type order = POST | PRE

(** Map on btrees *)
let rec map f = function
  | Node (value, sons) ->
    Node (f value, List.map (map f) sons)

(** Depth First traversal *)
let rec dfs ord = function
  | Node (value, sons) ->
    let paths = List.(map (dfs ord) sons |> flatten) in
    match ord with
    | PRE  -> value::paths
    | POST -> paths @ [value]

(** Breadth First traversal *)
let bfs bt =
  let rec step q p =
    match q with
    | [] -> p
    | Node (value, sons)::bts ->
      step (bts @ sons) (value::p)
  in
  step [bt] [] |> List.rev

(** Node constructor *)
let nd a l = Node (a, l)

(** Terminal node constructor *)
let lf a = nd a []

(** [dump str t f] dumps the tree [t] in the dot file [f].
    Values are stringified using [str]. *)
let dump str t f =
  let out = open_out f in
  let rec step (Node (v, s)) =
    List.iter (fun (Node (v', _) as s') ->
        Printf.fprintf out "\"%s\" -> \"%s\";\n" (str v) (str v');
        step s'
      ) s;
  in
  Printf.fprintf out "digraph {\n";
  step t;
  Printf.fprintf out "}\n"

