type expr =
  | Const of int
  | X
  | Add of expr * expr
  | Mul of expr * expr
  | Compose of expr * expr
[@@deriving show]

val eval_expr : int -> expr -> int
val simplify : expr -> expr

type poly = int list [@@deriving show]

val eval_poly : int -> poly -> int
val normalize : expr -> poly
val semantic_equiv : expr -> expr -> bool
