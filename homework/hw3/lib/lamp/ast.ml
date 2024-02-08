open Base

(** Binary operators *)
type binop = Add | Sub | Mul [@@deriving eq, show]

(** Relational comparison operators *)
type relop = Eq | Lt | Gt [@@deriving eq, show]

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
  (* booleans *)
  | True
  | False
  | IfThenElse of expr * expr * expr
  | Comp of relop * expr * expr
  (* lists *)
  | ListNil
  | ListCons of expr * expr
  | ListMatch of expr * expr * expr
  (* fix *)
  | Fix of expr
  (* products *)
  | Pair of expr * expr
  | Fst of expr
  | Snd of expr
[@@deriving eq, show]

(** Pretty-printers *)
module Pretty = struct
  open Fmt

  let pp_binop : binop Fmt.t =
   fun ppf op ->
    string ppf (match op with Add -> "+" | Sub -> "-" | Mul -> "*")

  let show_binop = to_to_string pp_binop

  let pp_relop : relop Fmt.t =
   fun ppf op -> string ppf (match op with Eq -> "=" | Lt -> "<" | Gt -> ">")

  let show_relop = to_to_string pp_relop

  let rec pp_expr : expr Fmt.t =
   fun ppf ->
    let is_complex = function
      | Num _ | Var _ | True | False | Pair _ | ListNil -> false
      | _ -> true
    in
    let pp_nested pp ppf e =
      if is_complex e then (parens pp) ppf e else pp ppf e
    in
    function
    | Num n -> int ppf n
    | Var x -> string ppf x
    | Scope (x, e) -> pf ppf "@[<2>scope %s in %a@]" x pp_expr e
    | Binop (op, e1, e2) ->
        pf ppf "@[<2>%a@ %a %a@]" (pp_nested pp_expr) e1 pp_binop op
          (pp_nested pp_expr) e2
    | Lambda (Scope (x, e)) -> pf ppf "@[<2>lambda %s.@ %a@]" x pp_expr e
    | Lambda e -> pf ppf "lambda?? %a" pp_expr e
    | Let (e1, Scope (x, e2)) ->
        pf ppf "@[<v>let %s = %a in@;%a@]" x pp_expr e1 pp_expr e2
    | Let (e1, e2) -> pf ppf "@[<v>let?? %a in@;%a@]" pp_expr e1 pp_expr e2
    | App (e1, e2) ->
        pf ppf "@[<2>%a@ %a@]" (pp_nested pp_expr) e1 (pp_nested pp_expr) e2
    | True -> string ppf "true"
    | False -> string ppf "false"
    | IfThenElse (e1, e2, e3) ->
        pf ppf "@[<hv>if %a@ then %a@ else %a@]" pp_expr e1 pp_expr e2 pp_expr
          e3
    | Comp (op, e1, e2) ->
        pf ppf "@[<2>%a@ %a %a@]" (pp_nested pp_expr) e1 pp_relop op
          (pp_nested pp_expr) e2
    | ListNil -> string ppf "Nil"
    | ListCons (e1, e2) ->
        pf ppf "@[<2>%a ::@ %a@]" (pp_nested pp_expr) e1 (pp_nested pp_expr) e2
    | ListMatch (e1, e2, Scope (h, Scope (t, e3))) ->
        pf ppf "@[<v>match %a with@;| Nil -> %a@;| %s :: %s -> %a@;end@]"
          pp_expr e1 pp_expr e2 h t pp_expr e3
    | ListMatch (e1, e2, e3) ->
        pf ppf "@[<v>match?? %a with@;| Nil -> %a@;| ?? -> %a@;end@]" pp_expr e1
          pp_expr e2 pp_expr e3
    | Fix (Scope (f, e)) -> pf ppf "@[<2>fix %s is@ %a@]" f pp_expr e
    | Fix e -> pf ppf "fix?? %a" pp_expr e
    | Pair (e1, e2) -> pf ppf "{@[<hv>%a,@ %a@]}" pp_expr e1 pp_expr e2
    | Fst e -> pf ppf "@[<2>fst@ %a@]" (pp_nested pp_expr) e
    | Snd e -> pf ppf "@[<2>snd@ %a@]" (pp_nested pp_expr) e

  let show_expr = to_to_string pp_expr
end

module Dsl = struct
  let lam x e = Lambda (Scope (x, e))
  let v x = Var x
  let i n = Num n
  let ( + ) e1 e2 = Binop (Add, e1, e2)
  let ( - ) e1 e2 = Binop (Sub, e1, e2)
  let ( * ) e1 e2 = Binop (Mul, e1, e2)
  let let_ x e1 ~in_:e2 = Let (e1, Scope (x, e2))
  let app e1 e2 = App (e1, e2)
  let ( = ) e1 e2 = Comp (Eq, e1, e2)
  let ( < ) e1 e2 = Comp (Lt, e1, e2)
  let ( > ) e1 e2 = Comp (Gt, e1, e2)
  let if_ e1 ~then_:e2 ~else_:e3 = IfThenElse (e1, e2, e3)
  let fix x ~is:e = Fix (Scope (x, e))
  let nil = ListNil
  let cons e1 e2 = ListCons (e1, e2)

  let match_ e1 ~with_nil:e2 ~with_cons:(x, y, e3) =
    ListMatch (e1, e2, Scope (x, Scope (y, e3)))

  let pair e1 e2 = Pair (e1, e2)
  let fst e = Fst e
  let snd e = Snd e
end
