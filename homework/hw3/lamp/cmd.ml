open Ast

type t =
  | CLet of string * expr
  | CLoad of string
  | CSave of string
  | CPrint
  | CClear
  | CEval of expr

type script = t list
