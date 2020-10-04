open Algos

(*****************************************)
(* Testing the module Binomial_heap      *)
(*****************************************)

let h = Binomial_heap.(empty
                       |> insert_list [23; 67; 1; -9; 278])

let m1, h1 = Binomial_heap.pop_min h
let m2, h2 = Binomial_heap.pop_min h1
let m3, h3 = Binomial_heap.pop_min h2

let _ =
  Printf.printf "Min (1) := %d\n" m1;
  Printf.printf "Min (2) := %d\n" m2;
  Printf.printf "Min (3) := %d\n" m3;

