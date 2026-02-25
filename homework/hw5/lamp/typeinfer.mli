open Ast

type gamma = (string * ty) list

exception Type_error of string

module Utils : sig
  val normalize : ty -> ty
end

type soln = (string * ty) list [@@deriving show, equal]

val infer : expr -> ty
val infer_with_gamma : gamma:gamma -> expr -> ty
