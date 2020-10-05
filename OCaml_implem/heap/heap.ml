open Resizable_array

type 'a t = {
  mutable size : int;
  values : 'a Resizable_array.t;
}

(* Get the parent of a given index *)
let parent i = (i - 1)/2

(* Get the right son of a given index *)
let sonl i = 2*i + 1

(* Get the left son of a given index *)
let sonr i = 2*i + 2

(* Restore the heap in [i]
   assuming that subtrees left and right*)
let rec heapify h i : unit =
  let imax = List.fold_left (fun acc j ->
      if get h.values j >= get h.values acc
      then j else acc
    ) i ([sonl i; sonr i] |> List.filter ((>) (h.size)))
  in
  if imax <> i then begin
    swap h.values i imax;
    heapify h imax
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
  let p = ref (parent i) in
  let c = ref i in
  let v = get h.values i in
  while (!c > 0 && get h.values !p <= v) do
    swap h.values !p !c;
    p := parent !p;
    c := parent !c;
  done

let insert h v =
  set (h.values) (h.size) v;
  sift_up h h.size;
  h.size <- h.size + 1

let to_array h =
  let open Resizable_array in
  Array.init h.size (get h.values)

let dump h =
  let arr = to_array h in
  Printf.printf "digraph {\n";
  Array.iteri (fun i v ->
      let is1 = 2*i + 1 in
      let is2 = 2*i + 2 in
      if is1 < h.size then Printf.printf "  %d -> %d;\n" v (arr.(is1));
      if is2 < h.size then Printf.printf "  %d -> %d;\n" v (arr.(is2));
    ) arr;
  Printf.printf "}\n"

