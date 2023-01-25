type expr
  = Nat of int
  | Var of string
  | Add of expr * expr
  | Mul of expr * expr

val simplify : expr -> expr
