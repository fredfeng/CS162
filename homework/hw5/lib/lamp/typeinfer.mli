open Base
open Ast

type gamma = (string * pty) list

val pp_gamma : gamma Fmt.t
val find : gamma -> string -> pty option
val add : gamma -> string -> pty -> gamma

exception Type_error of string

type cons = ty * ty

val pp_cons : cons Fmt.t
val equal_cons : cons -> cons -> bool
val compare_cons : cons -> cons -> int
val show_cons : cons -> string

type sigma = (string * ty) list [@@deriving eq, ord, show]

val pp_sigma : sigma Fmt.t

module Utils : sig
  val subst : string -> ty -> ty -> ty
  val free_vars : ty -> Vars.t
  val apply_sigma : sigma -> ty -> ty
  val normalize : ty -> ty
end

module Infer : functor
  (_ : sig
     val polymorphic : bool
   end)
  -> sig
  val _cs : cons list ref
  val ( === ) : ty -> ty -> unit
  val curr_cons_list : unit -> cons list
  val var_counter : int ref
  val ty_str_of_int : int -> string
  val incr : unit -> int
  val fresh_var_str : unit -> string
  val fresh_var : unit -> ty
  val generalize : gamma -> ty -> pty
  val instantiate : pty -> ty
  val abstract_eval : gamma -> expr -> ty
  val solve : cons list -> sigma
  val unify : sigma -> cons list -> sigma
  val backward : sigma -> sigma
end

val infer : p:bool -> expr -> ty
val infer_with_gamma : gamma:gamma -> p:bool -> expr -> ty
