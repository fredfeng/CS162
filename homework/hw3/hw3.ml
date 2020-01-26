(* return a list that contains the integers i through j inclusive *)
let interval i j =
(* to be written *)

(* Use tail-recursion to compute the number of elements in the list *)
let length list =
(* to be written *)

(* Eliminate consecutive duplicates of list elements. *)
let compress list =
(* to be written *)

(* Check if n is a prime number *)
 let is_prime n =
    let n = abs n in
    let rec is_not_divisor d =
      d * d > n || (n mod d <> 0 && is_not_divisor (d+1)) in
    n <> 1 && is_not_divisor 2;;

(* Goldbach's conjecture *)
let goldbach n =
(* to be written *)

type 'a binary_tree =
    | Empty
    | Node of 'a * 'a binary_tree * 'a binary_tree;;

(*Symmetric binary trees.*)
let is_symmetric = 
(* to be written *)


(* Eight queens problem. *)
let queens_positions n =
(* to be written *)


