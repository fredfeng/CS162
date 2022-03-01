open Ast

module Env = Map.Make (String) ;;
type env = typ Env.t

exception Type_error of string ;;

let ty_err msg = raise (Type_error msg)

let rec typecheck (_ : env) (e : expr) : typ =
  try
  match e with
    | _ ->
      (* feel free to replace this with your own eval *)
      failwith "TODO: hw4"
  with
  | Type_error msg -> ty_err (msg ^ "\nin expression " ^ string_of_expr e)
