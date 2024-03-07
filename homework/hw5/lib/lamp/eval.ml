open Base
open Ast

let todo () = Num (-1000)
let hmm () = Num (-2000)

(** Exception indicating that evaluation is stuck *)

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
  | Binop (_, e1, e2) -> failwith "TODO"
  | Var x -> failwith "TODO"
  | Scope (x, e') -> failwith "TODO"
  | Lambda (_, e) -> free_vars e
  | App (e1, e2) -> failwith "TODO"
  | Let (e1, e2) -> union (free_vars e1) (free_vars e2)
  | True | False -> failwith "TODO"
  | IfThenElse (e1, e2, e3) -> failwith "TODO"
  | Comp (_, e1, e2) -> failwith "TODO"
  | ListNil _ -> failwith "TODO"
  | ListCons (e1, e2) -> failwith "TODO"
  | ListMatch (e1, e2, e3) -> failwith "TODO"
  | Fix (_, e') -> failwith "TODO"
  | Pair (e1, e2) -> failwith "Hmm"
  | Fst e' -> failwith "Hmm"
  | Snd e' -> failwith "Hmm"

(** Perform substitution c[x -> e], i.e., substituting x with e in c *)
let rec subst (x : string) (e : expr) (c : expr) : expr =
  match c with
  | Num n -> c
  | Binop (op, c1, c2) -> todo ()
  | Var y -> todo ()
  | Scope (y, c') -> todo ()
  | Lambda (t, c') -> Lambda (t, subst x e c')
  | App (c1, c2) -> todo ()
  | Let (c1, c2) -> Let (subst x e c1, subst x e c2)
  | True | False -> c
  | IfThenElse (c1, c2, c3) -> todo ()
  | Comp (op, c1, c2) -> todo ()
  | ListNil _ -> c
  | ListCons (c1, c2) -> todo ()
  | ListMatch (c1, c2, c3) -> todo ()
  | Fix (t, c') -> Fix (t, subst x e c')
  | Pair (c1, c2) -> hmm ()
  | Fst c' -> hmm ()
  | Snd c' -> hmm ()

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
    | True -> todo ()
    | False -> todo ()
    | IfThenElse (e1, e2, e3) -> todo ()
    | Comp (op, e1, e2) -> todo ()
    | ListNil _ -> todo ()
    | ListCons (e1, e2) -> todo ()
    | ListMatch (e1, e2, Scope (x, Scope (y, e3))) -> todo ()
    | Fix (_, Scope (x, e')) -> todo ()
    | Pair (e1, e2) -> hmm ()
    | Fst e' -> hmm ()
    | Snd e' -> hmm ()
    | _ -> im_stuck (Fmt.str "Ill-formed expression: %a" Pretty.pp_expr e)
  with Stuck msg ->
    im_stuck (Fmt.str "%s\nin expression %a" msg Pretty.pp_expr e)

let eval_fast (e : expr) = failwith ".."
