open Ast
open Base

type env = (string * ty) list
(** Typing environment, aka Gamma *)

(** Helper function to look up a variable in the env *)
let find : env -> string -> ty option = List.Assoc.find ~equal:String.equal

(** Helper function to insert a (variable, ty) pair into the env *)
let add : env -> string -> ty -> env = List.Assoc.add ~equal:String.equal

exception Type_error of string

let ty_err msg = raise (Type_error msg)
let rec equal_ty (t1 : ty) (t2 : ty) : bool = failwith "TODO"

let rec abstract_eval (env : env) (e : expr) : ty =
  try
    match e with
    (* T-Int rule *)
    | Num _ -> TInt
    (* T-True and T-false *)
    | True | False -> TBool
    (* Your code here *)
    | _ -> failwith "TODO"
  with Type_error msg -> ty_err (msg ^ "\nin expression " ^ show_expr e)
