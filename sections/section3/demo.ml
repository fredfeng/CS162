(** Binary tree *)
type 'a tree =
  | Empty
  | Node of 'a tree * 'a * 'a tree
;;

(** A simple example of pattern matching and recursion. *)
let rec size t = match t with
  | Empty -> 0
  | Node (left, data, right) -> 1 + size left + size right
;;

(** More elaborate pattern matching *)
let rec is_right_leaning t = match t with
  | Empty -> true
  | Node (Empty, _, r) -> is_right_leaning r
  | _ -> false
;;

(** Or-patterns *)
let rec is_full t = match t with
  | (Node (Node _, _, Empty) | (Node (Empty, _, Node _))) -> false
  | Node (l, _, r) -> is_full l && is_full r
  | Empty -> true
;;

(** Nested matches *)
let snd_element l = match l with
  | [] -> failwith "empty list"
  | _ :: l' -> begin match l' with
      | [] -> failwith "list only has 1 item"
      | x :: _ -> x
    end
;;

(** Exceptions, defined just like a single constructor *)
exception DivExc of int ;;

(** How to raise an exception *)
let my_div x y =
  if y = 0
  then raise (DivExc x)
  else x / y
;;

(** How to catch an exception *)
let print_div x y =
  try
    print_int (my_div x y)
  with
  (* this is just pattern matching *)
  | DivExc n ->
    print_string ("Tried to divide " ^ string_of_int x ^ " by 0")
;;

(* Every file defines a _module_. For example, this demo file will create a Demo
   module. You can think of a module as a reusable "collection of types,
   variables, and functions." *)

(* How to use functions / types from another module *)
Format.printf "%s: %i" "Number of $$" 5 ;;

(* OCaml has features to create modules on the fly! Here, we create a module
   that is concerned with a set data structure on strings. *)
module StrSet = Set.Make (String) ;;
StrSet.singleton "x"

let _ =
  (* You can import names in a module locally using the "let open" form *)
  let open StrSet in
  singleton "x"

(* Or you can import names in a module at the top level. Typically these go at
   the beginning of the file. *)
open StrSet
