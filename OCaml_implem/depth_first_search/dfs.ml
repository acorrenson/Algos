type directed_graph = (int list) array

let dfs graph pre post =
  let n = Array.length graph in
  let visited = Array.make n false in 
  let rec explore i adj_list =
    if not visited.(i) then 
      begin
        visited.(i) <- true;
        pre i;
        List.iter (fun j -> explore j graph.(j)) adj_list;
        post i; 
      end
  in 
  Array.iteri explore graph

(* Returns the sorted list of the nodes in the graph and an ordering function *)
let topological_sort graph = 
  let order_list = ref [] in
  let post i = order_list := i::(!order_list) in
  let _ = dfs graph (fun _ -> ()) post in
  let sorted_list = !order_list in
  let order_fun i j = 
    let rec order_fun_aux i j = 
      function
      | [] -> failwith "order_fun : Nodes i and j are not in the graph"
      | h::_ when h = i -> true
      | h::_ when h = j -> false
      | _::t -> order_fun_aux i j t
    in
    order_fun_aux i j sorted_list
  in
  (sorted_list,order_fun)

let kosaraju graph =
  let strongly_connected_components_list = ref [] in 
  let current_component = ref [] in 
  let current_parent = ref (-1) in
  let pre i =
    begin
      if !current_parent = -1 
      then current_parent := i;
      current_component := i::(!current_component);
    end
  in
  let post i =
    if !current_parent = i then 
      begin
        strongly_connected_components_list := current_component::(!strongly_connected_components_list);
        current_component := [];
        current_parent := -1;
      end
  in
  let _ = dfs graph pre post in 
  !strongly_connected_components_list