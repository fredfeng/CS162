(** Lambda calculus practice *)

(********************************************************************************
   Definitions and helper functions
 ********************************************************************************)

(** Lambda calculus terms *)
type expr
  = (** A variable *)
    Var of string
  | (** Function application *)
    App of expr * expr
  | (** Lambda abstraction *)
    Lam of string * expr
  ;;

(** Example: identity function λx. x *)
let example_expr1 = Lam("x", Var("x"))
  ;;

(** Example 2: (λx. λy. y) a *)
let example_expr2 = App(Lam("x", Lam("y", Var("y"))), Var("a"))
  ;;

(** Convert an expression to a pretty printed string. This is useful for
    debugging. Example usage:

   utop[2]> ppf_expr example_expr2 ;;
   - : string = "(λx. λy. y) a"
*)
let rec ppf_expr : expr -> string =
  let wrapped = function
    | Var _ as e -> ppf_expr e
    | e -> "(" ^ ppf_expr e ^ ")"
  in
  function
  | Var(x) -> x
  | Lam(x, e) -> "λ" ^ x ^ ". " ^ ppf_expr e
  | App(e1, e2) -> wrapped e1 ^ " " ^ wrapped e2

(**
   Module representing a set of strings. To get the type corresponding to a set
   of strings, use
       StrSet.t
*)
module StrSet = Set.Make(String)
;;


(********************************************************************************
   Homework problems
 ********************************************************************************)

(** Compute the free variables FV(e) *)
let rec free_vars (e : expr) : StrSet.t =
  failwith "TODO: homework"
;;

exception Capturing of string

(** Perform the substitution [x -> e1]e2 *)
let rec subst (x : string) (e1 : expr) (e2 : expr) : expr =
  failwith "TODO: homework"
;;
