(*****************************
* Unification of type terms *
*****************************)

open Ast

(* invariant for substitutions: no id on a lhs occurs in any term earlier  *)
(* in the list                                                             *)
type substitution = (id * typ) list

(* check if a variable occurs in a term *)
let rec occurs (x : id) (t : typ) : bool =
(* to be written *)

(* substitute term s for all occurrences of var x in term t *)
let rec subst (s : typ) (x : id) (t : typ) : typ =
(* to be written *)

(* apply a substitution to t right to left *)
let apply (s : substitution) (t : typ) : typ =
(* to be written *)

(* unify one pair *)
let rec unify_one (s : typ) (t : typ) : substitution =
(* to be written *)

(* unify a list of pairs *)
and unify (s : (typ * typ) list) : substitution =
(* to be written *)

(* collect the constraints and perform unification *)
(* Hint: to call functions defined in infer.ml, use Infer. *)
(* For example, Infer.annotate / Infer.collect *)
let infer (e : expr) : typ =
(* to be written *)
