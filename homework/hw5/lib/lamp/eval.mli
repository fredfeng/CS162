open Ast

exception Stuck of string

val free_vars : expr -> Vars.t
(** Return the set of free variable references in an expression *)

val subst : string -> expr -> expr -> expr
(** Substitution *)

val eval : expr -> expr
(** Interpret an expression *)

val eval_fast : expr -> expr
(** Fast version of eval *)
