open Base

(** Binary operators *)
type binop = Add | Sub | Mul [@@deriving equal, show]

type 'a binder = string * 'a [@@deriving equal, show]
(** Binder *)

(** AST of Lambda+ expressions *)
type expr =
  (* arithmetic *)
  | Num of int
  | Binop of binop * expr * expr
  (* variable *)
  | Var of string
  (* lambda calculus *)
  | Lambda of expr binder
  | App of expr * expr
  (* let expression *)
  | Let of expr * expr binder
[@@deriving equal, show]

(** Pretty-printers *)
module Pretty = struct
  open Fmt

  let binop : binop Fmt.t =
    Fmt.(using (function Add -> "+" | Sub -> "-" | Mul -> "*") string)

  let rec expr : expr Fmt.t =
   fun ppf ->
    let is_complex = function Num _ | Var _ -> false | _ -> true in
    let pp_nested pp ppf e =
      if is_complex e then (parens pp) ppf e else pp ppf e
    in
    function
    | Num n -> int ppf n
    | Var x -> string ppf x
    | Binop (op, e1, e2) ->
        pf ppf "@[<2>%a@ %a@ %a@]" (pp_nested pp_expr) e1 pp_binop op
          (pp_nested pp_expr) e2
    | Lambda (x, e) -> pf ppf "@[<2>lambda %s.@ %a@]" x pp_expr e
    | Let (e1, (x, e2)) ->
        pf ppf "@[<v>let %s = %a in@;%a@]" x pp_expr e1 pp_expr e2
    | App (e1, e2) ->
        pf ppf "@[<2>%a@ %a@]" (pp_nested pp_expr) e1 (pp_nested pp_expr) e2
end
