(* Arithmetic expressions *)
type expr
  = (* A natural number constant *)
    Nat of int
  | (* A variable of unknown value *)
    Var of string
  | (* Addition *)
    Add of expr * expr
  | (* Multiplication *)
    Mul of expr * expr


(* Example: 5 + (1 * 2) *)
let example_expr = Add(Nat(5), Mul(Nat(1), Nat(2)))


let rec simplify (e : expr) : expr =
  failwith "Your code here"