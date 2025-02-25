open Base

(** Monomorphic types *)
type ty =
  | TVar of string  (** Type variable *)
  | TInt
  | TBool
  | TList of ty
  | TFun of ty * ty
  | TUnit
  | TVoid
  | TProd of ty * ty
  | TSum of ty * ty
[@@deriving equal, show]

(** Binary operators *)
type binop = Add | Sub | Mul [@@deriving equal, show]

(** Relational comparison operators *)
type relop = Eq | Lt | Gt [@@deriving equal, show]

type 'a binder = string * 'a [@@deriving equal, show]

(** AST of Lambda+ expressions *)
type expr =
  (* arithmetic *)
  | Num of int
  | Binop of binop * expr * expr
  (* binding *)
  | Var of string
  (* lambda calculus *)
  | Lambda of ty option * expr binder
  | App of expr * expr
  (* let expression *)
  | Let of expr * expr binder
  (* booleans *)
  | True
  | False
  | IfThenElse of expr * expr * expr
  | Comp of relop * expr * expr
  (* lists *)
  | ListNil of ty option
  | ListCons of expr * expr
  | ListMatch of expr * expr * expr binder binder
  (* fix *)
  | Fix of ty option * expr binder
  (* type annotation *)
  | Annot of expr * ty
  (* unit *)
  | Unit
  (* internal choice *)
  | Both of expr * expr
  | I1 of expr
  | I2 of expr
  (* void *)
  | Absurd of expr
  (* external choice *)
  | E1 of expr
  | E2 of expr
  | Either of expr * expr binder * expr binder
[@@deriving equal, show]

(** Pretty-printers *)
module Pretty = struct
  open Fmt

  (** Pretty print a [ty] *)
  let rec ty : ty Fmt.t =
   fun ppf ->
    let open Fmt in
    function
    | TVar x -> string ppf x
    | TInt -> string ppf "Int"
    | TBool -> string ppf "Bool"
    | TFun (t1, t2) -> pf ppf "@[%a -> %a@]" (pp_nested pp_ty) t1 pp_ty t2
    | TList t -> pf ppf "List[%a]" pp_ty t
    | TSum (t1, t2) ->
        pf ppf "@[%a + %a@]" (pp_nested pp_ty) t1 (pp_nested pp_ty) t2
    | TProd (t1, t2) ->
        pf ppf "@[%a * %a@]" (pp_nested pp_ty) t1 (pp_nested pp_ty) t2
    | TUnit -> string ppf "()"
    | TVoid -> string ppf "!"

  and pp_nested pp ppf t =
    let is_complex_ty = function TFun _ | TProd _ -> true | _ -> false in
    if is_complex_ty t then Fmt.parens pp ppf t else pp ppf t

  let binop : binop Fmt.t =
   fun ppf op ->
    string ppf (match op with Add -> "+" | Sub -> "-" | Mul -> "*")

  let relop : relop Fmt.t =
   fun ppf op -> string ppf (match op with Eq -> "=" | Lt -> "<" | Gt -> ">")

  let rec expr : expr Fmt.t =
   fun ppf ->
    let is_complex = function
      | Num _ | Var _ | True | False | Both _ | ListNil _ -> false
      | _ -> true
    in
    let pp_nested pp ppf e =
      if is_complex e then (parens pp) ppf e else pp ppf e
    in
    let pp = pp_nested pp_expr in
    function
    | Num n -> int ppf n
    | Var x -> string ppf x
    | Binop (op, e1, e2) -> pf ppf "%a %a@ %a" pp e1 pp_binop op pp e2
    | Lambda (topt, (x, e)) ->
        pf ppf "lambda %s%a.@ %a" x
          (option (const string ": " ++ pp_ty))
          topt pp_expr e
    | Let (e1, (x, e2)) ->
        pf ppf "@[<v>le@[t %s = %a in@]@ @[%a@]@]" x pp_expr e1 pp_expr e2
    | App (e1, e2) -> pf ppf "%a@ %a" pp e1 pp e2
    | True -> string ppf "true"
    | False -> string ppf "false"
    | IfThenElse (e1, e2, e3) ->
        pf ppf "@[<hv>if %a@ then %a@ else %a@]" pp_expr e1 pp_expr e2 pp_expr
          e3
    | Comp (op, e1, e2) -> pf ppf "%a %a@ %a" pp e1 pp_relop op pp e2
    | ListNil topt -> pf ppf "Nil%a" (option (brackets pp_ty)) topt
    | ListCons (e1, e2) -> pf ppf "%a ::@ %a" pp e1 pp e2
    | ListMatch (e1, e2, (h, (t, e3))) ->
        pf ppf "@[<v>match %a with@;| Nil -> %a@;| %s :: %s -> %a@;end@]"
          pp_expr e1 pp_expr e2 h t pp_expr e3
    | E1 e -> pf ppf "$1@ %a" pp e
    | E2 e -> pf ppf "$2@ %a" pp e
    | Either (e1, (x, e2), (y, e3)) ->
        pf ppf
          "@[<v>match @[%a@] with@;| $1 %s -> @[%a@]@;| $2 %s -> @[%a@]@;end@]"
          pp_expr e1 x pp_expr e2 y pp_expr e3
    | Fix (topt, (f, e)) ->
        pf ppf "fix %s%a is@ %a" f
          (option (const string ": " ++ pp_ty))
          topt pp_expr e
    | Both (e1, e2) -> pf ppf "(%a,@ %a)" pp e1 pp e2
    | I1 e -> pf ppf "%a.1" pp e
    | I2 e -> pf ppf "%a.2" pp e
    | Annot (e, t) -> pf ppf "%a :@ %a" pp e pp_ty t
    | Unit -> string ppf "()"
    | Absurd e -> pf ppf "match %a with end" pp e
end
