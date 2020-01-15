(* Duplicate the elements of a list *)
let duplicate list = 
(* to be written *)

(* Reverse a list *)
let rev list =
(* to be written *)

(* Converse a string to a list of characters. *)
let explode s =
  let rec exp i l =
    if i < 0 then l else exp (i - 1) (s.[i] :: l) in
  exp (String.length s - 1) []
;;

(* Find out whether a list is a palindrome *)
let is_palindrome str =
(* to be written *)