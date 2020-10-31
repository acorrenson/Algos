open Algos

(*****************************************)
(* Testing the module Binomial_heap      *)
(*****************************************)

let h = Binomial_heap.(empty
                       |> insert_list [23; 67; 1; -9; 278])

let m1, h1 = Binomial_heap.pop_min h
let m2, h2 = Binomial_heap.pop_min h1
let m3, h3 = Binomial_heap.pop_min h2

let g1:Dfs.directed_graph =
  [|[1;2];
    [2];
    [0;3;4];
    [];
    [3];
    [0;6];
    [5];
    [1;8];
    [1;9];
    [7]|]

let _ =
  let components_list = Dfs.kosaraju g1 in
  Printf.printf("Strongly connected components of g1 : ");
  List.iter (fun list -> Printf.printf "[ "; 
              List.iter (Printf.printf "%d ") list;
              Printf.printf "]") 
    components_list;
  Printf.printf "\n";
  assert (components_list = [[3];[4];[1;2;0];[6;5];[8;9;7]]);
  Printf.printf "Kosaraju's algorithm is correct\n"

let _ =
  Printf.printf "Min (1) := %d\n" m1;
  Printf.printf "Min (2) := %d\n" m2;
  Printf.printf "Min (3) := %d\n" m3

let g2 = 
  [|[(4,1);(2,2)];
    [(2,3);(3,4);(3,2)];
    [(1,1);(4,3);(5,4)];
    [];
    [(1,3)];
    []|]

let _ = 
  let distance_array,pred = Bfs.dijkstra g2 0 in 
  assert (distance_array.(0) = Finite 0);
  assert (distance_array.(1) = Finite 3);
  assert (distance_array.(2) = Finite 2);
  assert (distance_array.(3) = Finite 5);
  assert (distance_array.(4) = Finite 6);
  assert (distance_array.(5) = Infinite);
  assert (pred.(0) = None);
  assert (pred.(1) = Some 2);
  assert (pred.(2) = Some 0);
  assert (pred.(3) = Some 1);
  assert (pred.(4) = Some 1);
  assert (pred.(5) = None);
  Printf.printf "Dijkstra's algorithm on g2 is correct\n"

let h = Heap.of_array [| 1; 2; 3 |] (>)

let _ =
  Heap.(
    insert h 8;
    insert h 12;
    insert h (-19))

let _ =
  let a = Heap.to_array h in
  Heap.dump h;
  (* Check that h is a Heap *)
  Array.(iteri (fun i _ ->
      let sl = 2*i + 1 in
      let sr = 2*i + 2 in
      if sl < length a then assert (a.(sl) <= a.(i));
      if sr < length a then assert (a.(sr) <= a.(i));
      Printf.printf "Assert on node %d passed\n" i
    ) a)
