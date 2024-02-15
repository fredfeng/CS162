open Ast

type t =
  | CLet of string * expr
  | CLoad of string
  | CSave of string
  | CPrint
  | CClear
  | CMeta
  | CExitMeta
  | CEval of expr
