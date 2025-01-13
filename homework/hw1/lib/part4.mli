type expr =
  | Const of int
  | X
  | Add of expr * expr
  | Mul of expr * expr
  | Compose of expr * expr

val pp_expr : expr Fmt.t
val eval_expr : int -> expr -> int
val simplify : expr -> expr

type poly = int list

val pp_poly : poly Fmt.t
val eval_poly : int -> poly -> int
val normalize : expr -> poly
val semantic_equiv : expr -> expr -> bool
