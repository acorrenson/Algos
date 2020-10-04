type 'a t = {
  default : 'a;
  mutable values : 'a Array.t;
}

let get a i = 
  (* if i >= Array.length a.values then a.default *)
  a.values.(i)

let set a i v =
  let old_array = a.values in
  let old_len = Array.length old_array in
  if i >= old_len then begin
    a.values <- Array.make (2 * old_len) a.default;
    Array.blit old_array 0 a.values 0 old_len;
    a.values.(i) <- v
  end else a.values.(i) <- v

let map f a = { default = f a.default; values = Array.map f a.values}

let mapi f a = { default = f 0 a.default; values = Array.mapi f a.values}

let fold_left f acc a = Array.fold_left f acc a.values

let fold_right f a acc = Array.fold_right f a.values acc

let of_array a = { default = a.(0); values = a}

let length a = Array.length a.values

let swap a i j =
  let tmp = a.values.(i) in
  a.values.(i) <- a.values.(j);
  a.values.(j) <- tmp

let iter f a = Array.iter f a.values

let iteri f a = Array.iteri f a.values
