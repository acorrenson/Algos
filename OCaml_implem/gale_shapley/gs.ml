

let mk_pref_table l =
  let n = List.length l in
  let table = Array.make_matrix n n 0 in
  List.iteri (fun i lpref ->
      List.iteri (fun j v -> table.(i).(v) <- j) lpref;
    ) l;
  table

let mk_prop_table l =
  Array.of_list l


let gs (l_apref : int list list) (l_bpref : int list list) =
  (* Build tables *)
  let b_table = mk_pref_table l_bpref in
  let a_table = mk_prop_table l_apref in

  (* Getters *)
  let b_pref b a a' = b_table.(b).(a) < b_table.(b).(a') in
  let a_next a =
    match a_table.(a) with 
    | x::xs -> a_table.(a) <- xs; x
    | _ -> assert false in

  (* Associations *)
  let n = Array.length a_table in
  let a_with = Array.make n (-1) in
  let b_with = Array.make n (-1) in

  (* Test if a given [b] is free *)
  let is_free b = b_with.(b) < 0 in
  (* Bind [a] with [b] *)
  let assoc a b = a_with.(a) <- b; b_with.(b) <- a in

  (* Pretty printing *)
  let pp_ask a b  = Printf.printf "A%d ask B%d\n" (a + 1) (b + 1) in
  let pp_ko b     = Printf.printf "B%d is already with A%d\n" (b + 1) (b_with.(b) + 1) in
  let pp_ok b     = Printf.printf "B%d accepts\n" (b + 1) in
  let pp_pref b a a' =
    Printf.printf "B%d prefers A%d than A%d (A%d is now free)\n" (b + 1) (a + 1) (a' + 1) (a' + 1) in

  (* Main loop *)
  let rec step = function
    | [] -> ()
    | a::next ->
      let a_best = a_next a in
      pp_ask a a_best;
      if is_free a_best then begin
        pp_ok a_best;
        assoc a a_best; step next
      end else begin
        pp_ko a_best;
        let b_curr = b_with.(a_best) in
        if b_pref a_best a b_curr then begin
          pp_pref a_best a b_curr;
          assoc a a_best; step (b_curr::next)
        end else begin
          pp_pref a_best b_curr a;
          step (a::next)
        end
      end
  in

  step (List.init n Fun.id);
  a_with


let la = [
  [3; 0; 1; 2];
  [0; 1; 3; 2];
  [2; 1; 0; 3];
  [3; 0; 1; 2];
]

let lb = [
  [1; 2; 3; 0];
  [1; 2; 3; 0];
  [2; 1; 3; 0];
  [3; 0; 1; 2];
]

let _ = Array.iteri (fun i v ->
    Printf.printf "A%d -> B%d\n" (i + 1) (v + 1);
  ) (gs la lb )




