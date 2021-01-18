(** Pattern matching practice *)

(** Arithmetic expressions *)
type expr
  = (** A natural number constant *)
    Nat of int
  | (** A variable of unknown value *)
    Var of string
  | (** Addition *)
    Add of expr * expr
  | (** Multiplication *)
    Mul of expr * expr
;;

(** Example: 5 + (1 * 2) *)
let example_expr = Add(Nat(5), Mul(Nat(1), Nat(2)))

(** Simplify an arithmetic expression *)
let rec simplify (e : expr) : expr =
  failwith "TODO: homework"
;;
