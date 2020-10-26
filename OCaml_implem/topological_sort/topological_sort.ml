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
