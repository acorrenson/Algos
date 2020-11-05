
type uf = {
  keys : int array;
  heights : int array;
}

let make n = {
  keys = Array.init n Fun.id;
  heights = Array.make n 1;
}

let rec find (uf : uf) (x : int) =
  if uf.keys.(x) = x then x
  else
    let _ = uf.keys.(x) <- find uf (uf.keys.(x))
    in uf.keys.(x)

let rec union uf x y =
  let rx = find uf x in
  let ry = find uf y in
  let hrx = uf.heights.(rx) in
  let hry = uf.heights.(ry) in
  if hrx > hry then
    uf.keys.(y) <- x
  else begin
    uf.keys.(x) <- y;
    if hrx = hry then uf.heights.(y) <- uf.heights.(y) + 1;
  end
