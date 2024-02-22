open Base

(** Types *)
type ty = TInt | TBool | TFun of ty * ty | TList of ty | TProd of ty * ty
[@@deriving eq, show]

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
  | Lambda of ty option * expr
  | App of expr * expr
  (* let expression *)
  | Let of expr * expr
  (* booleans *)
  | True
  | False
  | IfThenElse of expr * expr * expr
  | Comp of relop * expr * expr
  (* lists *)
  | ListNil of ty option
  | ListCons of expr * expr
  | ListMatch of expr * expr * expr
  (* fix *)
  | Fix of ty option * expr
  (* products *)
  | Pair of expr * expr
  | Fst of expr
  | Snd of expr
  (* type annotation *)
  | Annot of expr * ty
[@@deriving eq, show]

(** Pretty-printers *)
module Pretty = struct
  open Fmt

  let rec pp_ty : ty Fmt.t =
   fun ppf -> function
    | TInt -> string ppf "Int"
    | TBool -> string ppf "Bool"
    | TFun (t1, t2) ->
        pf ppf "@[%a -> %a@]" (pp_nested pp_ty) t1 (pp_nested pp_ty) t2
    | TList t -> pf ppf "List[%a]" pp_ty t
    | TProd (t1, t2) ->
        pf ppf "@[%a * %a@]" (pp_nested pp_ty) t1 (pp_nested pp_ty) t2

  and pp_nested pp ppf t =
    let is_complex_ty = function TFun _ | TProd _ -> true | _ -> false in
    if is_complex_ty t then (parens pp) ppf t else pp ppf t

  let show_ty = to_to_string pp_ty

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
      | Num _ | Var _ | True | False | Pair _ | ListNil _ -> false
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
    | Lambda (topt, Scope (x, e)) ->
        pf ppf "@[<2>lambda %s%a.@ %a@]" x
          (option (const string ": " ++ pp_ty))
          topt pp_expr e
    | Lambda (_, e) -> pf ppf "lambda?? %a" pp_expr e
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
    | ListNil topt -> pf ppf "Nil%a" (option (brackets pp_ty)) topt
    | ListCons (e1, e2) ->
        pf ppf "@[<2>%a ::@ %a@]" (pp_nested pp_expr) e1 (pp_nested pp_expr) e2
    | ListMatch (e1, e2, Scope (h, Scope (t, e3))) ->
        pf ppf "@[<v>match %a with@;| Nil -> %a@;| %s :: %s -> %a@;end@]"
          pp_expr e1 pp_expr e2 h t pp_expr e3
    | ListMatch (e1, e2, e3) ->
        pf ppf "@[<v>match?? %a with@;| Nil -> %a@;| ?? -> %a@;end@]" pp_expr e1
          pp_expr e2 pp_expr e3
    | Fix (topt, Scope (f, e)) ->
        pf ppf "@[<2>fix %s%a is@ %a@]" f
          (option (const string ": " ++ pp_ty))
          topt pp_expr e
    | Fix (_, e) -> pf ppf "fix?? %a" pp_expr e
    | Pair (e1, e2) -> pf ppf "{@[<hv>%a,@ %a@]}" pp_expr e1 pp_expr e2
    | Fst e -> pf ppf "@[<2>fst@ %a@]" (pp_nested pp_expr) e
    | Snd e -> pf ppf "@[<2>snd@ %a@]" (pp_nested pp_expr) e
    | Annot (e, t) -> pf ppf "@[<2>%a : %a@]" pp_expr e pp_ty t

  let show_expr = to_to_string pp_expr
end

module Dsl = struct
  let lam x e = Lambda (None, Scope (x, e))
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
  let fix x ~is:e = Fix (None, Scope (x, e))
  let nil = ListNil None
  let cons e1 e2 = ListCons (e1, e2)

  let match_ e1 ~with_nil:e2 ~with_cons:(x, y, e3) =
    ListMatch (e1, e2, Scope (x, Scope (y, e3)))

  let pair e1 e2 = Pair (e1, e2)
  let fst e = Fst e
  let snd e = Snd e
  let ( @ ) e t = Annot (e, t)

  let lett x ~t e1 ~in_:e2 =
    match t with
    | None -> let_ x e1 ~in_:e2
    | Some t -> Let (e1 @ t, Scope (x, e2))
end
