open Base
open Ast

let todo () = failwith "TODO"

exception Stuck of string
(** Exception indicating that evaluation is stuck *)

(** Raises an exception indicating that evaluation got stuck. *)
let im_stuck msg = raise (Stuck msg)

(** Computes the set of free variables in the given expression *)
let rec free_vars (e : expr) : Vars.t =
  (* This line imports the functions in Vars, so you can write [diff .. ..]
     instead of [Vars.diff .. ..] *)
  let open Vars in
  (* Your code goes here *)
  match e with
  | Num _ -> empty
  | Binop (_, e1, e2) -> todo ()
  | Var x -> todo ()
  | Scope (x, e) -> todo ()
  | Lambda e -> free_vars e
  | App (e1, e2) -> todo ()
  | Let (e1, e2) -> union (free_vars e1) (free_vars e2)

(** Perform substitution c[x -> e], i.e., substituting x with e in c *)
let rec subst (x : string) (e : expr) (c : expr) : expr =
  match c with
  | Num n -> Num n
  | Binop (op, c1, c2) -> todo ()
  | Var y -> todo ()
  | Scope (y, c') -> todo ()
  | Lambda c' -> Lambda (subst x e c')
  | App (c1, c2) -> todo ()
  | Let (c1, c2) -> Let (subst x e c1, subst x e c2)

(** Evaluate expression e *)
let rec eval (e : expr) : expr =
  try
    match e with
    | Num n -> Num n
    | Binop (op, e1, e2) -> todo ()
    | Var _ -> todo ()
    | Scope _ ->
        im_stuck (Fmt.str "Cannot evaluate scope alone: %a" Pretty.pp_expr e)
    | Lambda _ -> todo ()
    | App (e1, e2) -> todo ()
    | Let (e1, Scope (x, e2)) -> todo ()
    | _ -> im_stuck (Fmt.str "Ill-formed expression: %a" Pretty.pp_expr e)
  with Stuck msg ->
    im_stuck (Fmt.str "%s\nin expression %a" msg Pretty.pp_expr e)
