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
  todo ()

(** Perform substitution c[x -> e], i.e., substituting x with e in c *)
let rec subst (x : string) (e : expr) (c : expr) : expr = todo ()

(** Evaluate expression e *)
let rec eval e : expr =
  try
    match e with
    | Scope _ -> im_stuck (Fmt.str "Cannot evaluate %a" Pretty.pp_expr e)
    | _ -> todo ()
  with Stuck msg ->
    im_stuck (Fmt.str "%s\nin expression %a" msg Pretty.pp_expr e)
