(* Agenda:
  - Review: anonymous functions
  - Review: currying & partial application
  - Review: higher-order functions
  - Introduction to infinite lists *)

(* 1. Anonymous functions *)
(* The following definitions of add are equivalent *)
let add x y = x + y
let add = fun x y -> x + y
let add = fun x -> fun y -> x + y

(* 2. Currying & partial application *)
(* 
add 1
==> (replace name with definition)
(fun x -> fun y -> x + y) 1
==> (application is substitution)
fun y -> 1 + y
*)
let inc = add 1

(* 3. Higher-order functions *)
(* Examples: map, filter, fold, ...
   Use them and be cool *)

(* val map: ('a -> 'b) -> 'a list -> 'b list *)
let _ = assert (List.map inc [1;2;3] = [2;3;4])

(* Exercise: 2D increment *)
let mystery = failwith "your code here"
let _ = assert (List.map mystery [[1; 2; 3]; [4; 5; 6]] = [[2; 3; 4]; [5; 6; 7]])

(* Solutions (all are equivalent): *)
let mystery l = List.map inc l
let mystery = fun l -> List.map inc l
let mystery = List.map inc


(* 4. Introduction to infinite lists *)
(* See README.md *)