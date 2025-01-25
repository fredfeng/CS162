open Ast

exception Stuck of string

val free_vars : expr -> Vars.t
(** Return the set of free variable references in an expression *)

val subst : string -> expr -> expr -> expr
(** Substitution *)

val eval : expr -> expr
(** Interpret an expression *)

type sigma = (string * expr) list
(** Substitution *)

val subst_multi : sigma -> expr -> expr
(** Simultaneous substitution *)

val alpha_equiv : expr -> expr -> bool
(** Alpha equivalence *)
