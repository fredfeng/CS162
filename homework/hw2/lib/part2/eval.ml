open Ast

let todo () = failwith "TODO"
let bonus () = failwith "BONUS"

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
  | Lambda binder -> todo ()
  | App (e1, e2) -> todo ()
  | Let (e1, binder) -> union (free_vars e1) (todo ())

(** Perform substitution c[x -> e], i.e., substituting x with e in c *)
let rec subst (x : string) (e : expr) (c : expr) : expr =
  match c with
  | Num n -> Num n
  | Binop (op, c1, c2) -> todo ()
  | Var y -> todo ()
  | Lambda binder -> todo ()
  | App (c1, c2) -> todo ()
  | Let (c1, binder) -> Let (subst x e c1, todo ())

(** Evaluate expression e *)
let rec eval (e : expr) : expr =
  try
    match e with
    | Num n -> Num n
    | Binop (op, e1, e2) -> todo ()
    | Var x -> todo ()
    | Lambda binder -> todo ()
    | App (e1, e2) -> todo ()
    | Let (e1, (x, e2)) -> todo ()
    | _ -> im_stuck (Fmt.str "Ill-formed expression: %a" Pretty.expr e)
  with Stuck msg ->
    im_stuck (Fmt.str "%s\nin expression %a" msg Pretty.expr e)

type sigma = (string * expr) list
(** Substitution  *)

(** Perform simultaneous substitution c[sigma], i.e., substituting variables in c according to sigma *)
let rec subst_multi (sigma : sigma) (c : expr) : expr = bonus ()

(** Alpha-equivalence *)
let alpha_equiv (e1 : expr) (e2 : expr) : bool = bonus ()
