(* Return the sum of the elements in list l *)
let sumList list =
match list with
| [] -> 0
| head::tail -> head + (sumList tail);;

(* Compute the Fibonacci number of n *)
let fibonacci n =
if n < 3 then
    1
else
    fibonacci (n-1) + fibonacci (n-2);;
