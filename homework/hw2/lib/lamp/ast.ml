open Base

(** Binary operators *)
type binop = Add | Sub | Mul [@@deriving eq, show]

(** AST of Lambda+ expressions *)
type expr =
  (* arithmetic *)
  | Num of int
  | Binop of binop * expr * expr
  (* binding *)
  | Var of string
  | Scope of string * expr
  (* lambda calculus *)
  | Lambda of expr
  | App of expr * expr
  (* let expression *)
  | Let of expr * expr
[@@deriving eq, show]

(** Pretty-printers *)
module Pretty = struct
  open Fmt

  let pp_binop : binop Fmt.t =
   fun ppf op ->
    string ppf (match op with Add -> "+" | Sub -> "-" | Mul -> "*")

  let show_binop = to_to_string pp_binop

  let rec pp_expr : expr Fmt.t =
   fun ppf ->
    let is_complex = function Num _ | Var _ -> false | _ -> true in
    let pp_nested pp ppf e =
      if is_complex e then (parens pp) ppf e else pp ppf e
    in
    function
    | Num n -> int ppf n
    | Var x -> string ppf x
    | Scope (x, e) -> pf ppf "@[<2>scope %s in %a@]" x pp_expr e
    | Binop (op, e1, e2) ->
        pf ppf "@[<2>%a %a %a@]" (pp_nested pp_expr) e1 pp_binop op
          (pp_nested pp_expr) e2
    | Lambda (Scope (x, e)) -> pf ppf "@[<2>lambda %s. %a@]" x pp_expr e
    | Lambda e -> pf ppf "@[<2>lambda?? %a@]" pp_expr e
    | Let (e1, Scope (x, e2)) ->
        pf ppf "@[<v>let %s = %a@;in %a@]" x pp_expr e1 pp_expr e2
    | Let (e1, e2) -> pf ppf "@[<v>let?? %a @;in %a@]" pp_expr e1 pp_expr e2
    | App (e1, e2) ->
        pf ppf "@[<2>%a %a@]" (pp_nested pp_expr) e1 (pp_nested pp_expr) e2

  let show_expr = to_to_string pp_expr
end
