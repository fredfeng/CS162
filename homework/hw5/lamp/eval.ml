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
  match e with _ -> todo ()

(** Perform substitution c[x -> e], i.e., substituting x with e in c *)
let rec subst (x : string) (e : expr) (c : expr) : expr =
  match c with _ -> todo ()

(** Evaluate expression e *)
let rec eval (e : expr) : expr =
  try match e with _ -> todo ()
  with Stuck msg ->
    im_stuck (Fmt.str "%s\nin expression %a" msg Pretty.expr e)
