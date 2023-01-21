*( product type *)
type point = int * int
let p = (0, 1)
let origin = (0, 0)
let reflect (p: point) : point =
  match p with
  | (x, y) -> (y, x)

(* sum type *)
(* how to construct int options *)
type 'a option = 
  |	None
  |	Some of 'a

let x : int option = Some 0
let y : int option = None

(* how to destruct and then construct int options *)
(* version 1: three pattern matches *)
let funny_add (x_opt_and_y_opt : (int option * int option)) : int option =
  match x_opt_and_y_opt with
  | (x_opt, y_opt) -> (
    match x_opt with
    | Some x -> (
      match y_opt with 
      | Some y -> Some (x+y)
      | None -> None
    )
    | None -> None
  )
(* version 2: two pattern matches *)
let funny_add (x_opt_and_y_opt : (int option * int option)) : int option =
  match x_opt_and_y_opt with
  | (x_opt, y_opt) -> (
    match (x_opt, y_opt) with
    | (Some x, Some y) -> Some (x+y)
    | _ -> None
  )
(* version 3: one pattern match *)
let funny_add (x_opt_and_y_opt : (int option * int option)) : int option =
  match x_opt_and_y_opt with
  | (Some x, Some y) -> Some (x+y)
  | _ -> None

(* version 4: pattern match at the arguments *)
let funny_add ((x_opt, y_opt) : (int option * int option)) : int option =
  match (x_opt, y_opt) with
  | (Some x, Some y) -> Some (x+y)
  | _ -> None

(* generic binery tree *)
type 'a tree = Leaf | Node of 'a tree * 'a tree * 'a
(* how to construct binary trees *)
let t0: int tree = Leaf
let t1: int tree = Node (Leaf, Leaf, 0)
let t2: int tree = Node (t0, t1, 100)

(* recursion exercises *)
(* returns the number of inner node *)
let rec size (t: 'a tree) : int =
  match t with
  | Leaf -> 0 (* base case *)
  | Node (l, r, _) -> (* recursive case *)
    let x = size l in
    let y = size r in
    (x + y + 1)

(* preserves the shape of the tree but erases all values *)
let rec shape (t: 'a tree) : unit tree =
  match t with
  | Leaf -> Leaf
  | Node (l, r, x) ->
    let shape_l = shape l in
    let shape_r = shape r in
    Node (shape_l, shape_r, ())

(* returns the longest path from the root to a leaf *)
let rec longest_path (t: 'a tree) : 'a list =
  match t with
  | Leaf -> []
  | Node (l, r, x) ->
    let pl = longest_path l in
    let pr = longest_path r in
    let longer = 
      if List.length pl > List.length pr
      then pl
      else pr in
    x :: longer

(*# 
Pack consecutive duplicates of list elements into sublists.
pack ["a"; "a"; "a"; "a"; "b"; "c"; "c"; "a"; "a"; "d"; "d"; "e"; "e"; "e"; "e"];;
- : string list list =
[["a"; "a"; "a"; "a"]; ["b"]; ["c"; "c"]; ["a"; "a"]; ["d"; "d"];
 ["e"; "e"; "e"; "e"]]
 *)

let pack lst =
  let rec aux cur acc l =
    match l with
    | [] -> acc
    | [x] -> (x::cur)::acc
    | x1::(x2::x3 as t) ->
        if (x1 = x2) then aux (x1::cur) acc t
        else aux [] ((x1::cur)::acc) t
  in
  List.rev(aux [] [] lst);;