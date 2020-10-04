open Resizable_array

type 'a t = {
  mutable size : int;
  values : 'a Resizable_array.t;
}

let rec heapify h i : unit =
  let i' = i + 1 in
  let imax = List.fold_left (fun acc j ->
      if get h.values (j - 1) >= get h.values (acc - 1)
      then j else acc
    ) i' ([2*i'; 2*i' + 1] |> List.filter ((>=) (h.size)))
  in
  if imax <> i' then begin
    swap h.values i (imax - 1);
    heapify h (imax - 1)
  end


let of_array a =
  let ra = Resizable_array.of_array a in
  let l = Resizable_array.length ra in
  let h = {size = l; values = ra} in
  for i = (l/2) - 1 downto 0 do
    heapify h i
  done;
  h

let sift_up h i =
  let p = ref (i/2) in
  let c = ref i in
  let v = get h.values i in
  while (!c > 0 && get h.values !p <= v) do
    swap h.values !p !c;
    p := !p / 2;
    c := !c / 2;
  done

let insert h v =
  set (h.values) (h.size) v;
  sift_up h h.size;
  h.size <- h.size + 1

let dump h =
  Printf.printf "digraph {\n";
  let open Resizable_array in

  iter (fun v -> Printf.printf "%d;\n" v) h.values;
  iteri (fun i v ->
      let is1 = 2*i + 1 in
      let is2 = 2*i + 2 in
      if is1 < h.size then Printf.printf "  %d -> %d;\n" v (get h.values is1);
      if is2 < h.size then Printf.printf "  %d -> %d;\n" v (get h.values is2)
    ) h.values;

  Printf.printf "}\n"

