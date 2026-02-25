open Ast

type env = (string * ty) list

val abstract_eval : env -> Ast.expr -> ty

exception Type_error of string
