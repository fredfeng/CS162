(* Duplicate the elements of a list *)
let duplicate list =
let rec fr el dup = match dup with
| head::tail -> fr (el @ [head;head]) tail
| [] -> el in
fr [] list;;

(* Reverse a list *)
let rev list =
let rec fr el = function
  | [] -> el
  | head::tail -> fr (head::el) tail in
fr [] list;;

(* Converse a string to a list of characters. *)
let explode s =
  let rec exp i l =
    if i < 0 then l else exp (i - 1) (s.[i] :: l) in
  exp (String.length s - 1) [];;

(* Find out whether a list is a palindrome *)
let is_palindrome str =
  explode (str) = rev (explode (str));;
