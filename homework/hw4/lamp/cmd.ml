open Ast

type t =
  | CLet of string * ty option * expr
  | CLoad of string
  | CSave of string
  | CPrint
  | CClear
  | CEval of expr
  | CSynth of ty

type script = t list
