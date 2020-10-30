type priority_couple = int*int

type weighted_graph = (priority_couple list) array

type priority_queue = priority_couple Heap.t

type distance = Infinite | Finite of int

type predecessor = int option

let priority_couple_order_fun (p1, _) (p2, _) = p1 < p2

let distance_order_fun distance1 distance2 =
  match distance1,distance2 with 
  | Infinite,_ -> true
  | _,Infinite -> false
  | Finite d1,Finite d2 -> d1 > d2

let dijkstra graph source =
  let n = Array.length graph in
  let visited = Array.make n false in
  if source >= n then failwith "Source of Dijkstra's Algorithm is not in the graph"
  else begin
    let distance_array = Array.make n (Infinite) in 
    let _ = distance_array.(source) <- Finite 0 in 
    let prio_queue = Heap.of_array [|(0,source)|] priority_couple_order_fun in
    let pred = Array.make n (None) in
    while not(Heap.is_empty prio_queue) do 
      let (closest_distance,closest) = Heap.extract prio_queue in 
      if not(visited.(closest)) then begin
        List.iter (fun (weight,node) -> 
            let new_distance = closest_distance + weight in
            if distance_order_fun distance_array.(node) (Finite new_distance)
            then begin
              distance_array.(node) <- Finite new_distance;
              Heap.insert prio_queue (new_distance,node);
              pred.(node) <- Some closest;
            end)
          graph.(closest);
        visited.(closest) <- true
      end
    done;
    (distance_array,pred)
  end
