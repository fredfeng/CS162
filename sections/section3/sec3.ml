(* generate a list of numbers in the given range [a, b) *)
let rec range a b = if a >= b then []
                    else a :: range (a + 1) b ;;

(*

range 0 3 -> 0 :: range 1 3 -> 0 :: 1 :: range 2 3 -> 0 :: 1 :: 2 :: range 3 3 -> 0 :: 1 :: 2 :: []

 *)

(* returns sum l + n *)
let rec accumulate (l : int list) (n : int) = match l with
    [] -> n
  | h :: t -> accumulate t (h + n)
;;


let rec range2 a b =
  let rec tail_rec_range a b list_so_far =
    if a >= b then list_so_far
    else tail_rec_range (a + 1) b (a :: list_so_far)
  in
  List.rev @@ tail_rec_range a b []
;;

(* some helper functions for the examples below *)
let square n = n * n ;;
let greet name = "Hi there, " ^ name ;;

let rec do_all (f : 'a -> 'b) (ns : 'a list) : 'b list = match ns with
    [] -> []
  | head :: tail -> f head :: do_all f tail
;;

let square_all = do_all square ;;
let greet_all = do_all greet ;;

(* question: can we generalize above? *)

(* creating lambdas in OCaml: fun args -> ... *)
(* if automatically pattern matching: function | pat1 -> | pat2 -> ... *)

open List;;

(* filtering *)

let is_prime n =
  let rec divides a b = b mod a = 0
  and is_there_a_divisor_less_than k =
    if k <= 1 then
      false
    else if divides k n then
      true
    else
      is_there_a_divisor_less_than (k - 1)
  and sqrt_of_n = Float.to_int @@ Float.sqrt @@ Float.of_int n
  in
  n > 1 && not (is_there_a_divisor_less_than sqrt_of_n)
;;

let test_numbers = [0;1;2;3;4;5;6;7;8;9;10;11;12;13;17;77;103;105;107] ;;

let keep_only_primes = filter is_prime ;;

(* folding left vs right *)

let rec apply_binary (op : 'a -> 'a -> 'a) (base : 'a) (ns : 'a list) = match ns with
    [] -> base
  | h :: t -> op h (apply_binary op base t)
;;

let sum ns = apply_binary ( + ) 0 ns
let prod ns = apply_binary ( * ) 1 ns

let fact n = prod @@ range 2 (n + 1) ;;

let concatenate (strs : string list) : string = apply_binary (^) "" strs;;

(* general structure traversal *)
