open Ast
open Base

type gamma = (string * ty) list

(** Find the type of a variable in gamma *)
let find : gamma -> string -> ty option = List.Assoc.find ~equal:String.equal

(** Add a (var, type) pair to gamma *)
let add : gamma -> string -> ty -> gamma = List.Assoc.add ~equal:String.equal

exception Type_error of string

let ty_err msg = raise (Type_error msg)
let todo () = failwith "TODO"
let rec equal_ty (t1 : ty) (t2 : ty) : bool = todo ()

(** Abstractly evaluate expression e to some type
  * under the typing environment gamma *)
let rec abstract_eval (gamma : gamma) (e : expr) : ty =
  try
    match e with
    | _ -> todo ()
    | _ -> ty_err ("[synth] ill-formed: " ^ show_expr e)
  with Type_error msg -> ty_err (msg ^ "\nin expression " ^ show_expr e)
