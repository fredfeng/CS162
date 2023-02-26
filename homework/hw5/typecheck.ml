open Ast

module Env = Map.Make (String) type env = typ Env.t

exception Type_error of string 
let ty_err msg = raise (Type_error msg)

let todo () = failwith "TODO"

let rec typecheck (env : env) (e : expr) : typ =
  try
  match e with
  | _ -> todo ()
  with
  | Type_error msg -> ty_err (msg ^ "\nin expression " ^ string_of_expr e)
