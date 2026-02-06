open Base

(** Binary operators *)
type binop = Add | Sub | Mul [@@deriving equal, show]

(** Relational comparison operators *)
type relop = Eq | Lt | Gt [@@deriving equal, show]

type 'a binder = string * 'a [@@deriving equal, show]

(** AST of Lambda+ expressions *)
type expr =
  (* binding *)
  | Var of string
  (* lambda calculus *)
  | Lambda of expr binder
  | App of expr * expr
  (* let expression *)
  | Let of expr * expr binder
  (* boolean *)
  | True
  | False
  | IfThenElse of expr * expr * expr
  (* arithmetic *)
  | Num of int
  | Binop of binop * expr * expr
  | Comp of relop * expr * expr
  (* list *)
  | ListNil
  | ListCons of expr * expr
  | ListMatch of expr * expr * expr binder binder
  (* fix *)
  | Fix of expr binder
  (* external choice *)
  | Both of expr * expr
  | I1 of expr
  | I2 of expr
  (* internal choice *)
  | E1 of expr
  | E2 of expr
  | Either of expr * expr binder * expr binder
[@@deriving equal, show]

(** Pretty-printers *)
module Pretty = struct
  open Fmt

  let pp_binop : binop Fmt.t =
   fun ppf op ->
    string ppf (match op with Add -> "+" | Sub -> "-" | Mul -> "*")

  let pp_relop : relop Fmt.t =
   fun ppf op -> string ppf (match op with Eq -> "=" | Lt -> "<" | Gt -> ">")

  let rec expr : expr Fmt.t =
   fun ppf ->
    let is_complex = function
      | Num _ | Var _ | True | False | Both _ | ListNil | I1 _ | I2 _ -> false
      | _ -> true
    in
    let pp_nested pp ppf e =
      if is_complex e then (parens pp) ppf e else pp ppf e
    in
    let pp = pp_nested expr in
    function
    | Num n -> int ppf n
    | Var x -> string ppf x
    | Binop (op, e1, e2) -> pf ppf "%a %a@ %a" pp e1 pp_binop op pp e2
    | Lambda (x, e) -> pf ppf "lambda %s.@ %a" x expr e
    | Let (e1, (x, e2)) ->
        pf ppf "@[<v>le@[t %s = %a in@]@ @[%a@]@]" x expr e1 expr e2
    | App (e1, e2) -> pf ppf "%a@ %a" pp e1 pp e2
    | True -> string ppf "true"
    | False -> string ppf "false"
    | IfThenElse (e1, e2, e3) ->
        pf ppf "@[<hov>if %a@ then %a@ else %a@]" expr e1 expr e2 expr e3
    | Comp (op, e1, e2) -> pf ppf "%a %a@ %a" pp e1 pp_relop op pp e2
    | ListNil -> pf ppf "Nil"
    | ListCons (e1, e2) -> pf ppf "%a ::@ %a" pp e1 pp e2
    | ListMatch (e1, e2, (h, (t, e3))) ->
        pf ppf "@[<v>match %a with@;| Nil -> %a@;| %s :: %s -> %a@;end@]" expr
          e1 expr e2 h t expr e3
    | E1 e -> pf ppf "$1@ %a" pp e
    | E2 e -> pf ppf "$2@ %a" pp e
    | Either (e1, (x, e2), (y, e3)) ->
        pf ppf
          "@[<v>match @[%a@] with@;| $1 %s -> @[%a@]@;| $2 %s -> @[%a@]@;end@]"
          expr e1 x expr e2 y expr e3
    | Fix (f, e) -> pf ppf "fix %s is@ %a" f expr e
    | Both (e1, e2) -> pf ppf "(%a,@ %a)" expr e1 expr e2
    | I1 e -> pf ppf "%a.1" pp e
    | I2 e -> pf ppf "%a.2" pp e
end

module DSL = struct
  let lam x e = Lambda (x, e)
  let v x = Var x
  let i n = Num n
  let ( + ) e1 e2 = Binop (Add, e1, e2)
  let ( - ) e1 e2 = Binop (Sub, e1, e2)
  let ( * ) e1 e2 = Binop (Mul, e1, e2)
  let let_ x e1 ~in_:e2 = Let (e1, (x, e2))
  let app e1 e2 = App (e1, e2)
  let ( = ) e1 e2 = Comp (Eq, e1, e2)
  let ( < ) e1 e2 = Comp (Lt, e1, e2)
  let ( > ) e1 e2 = Comp (Gt, e1, e2)
  let if_ e1 ~then_:e2 ~else_:e3 = IfThenElse (e1, e2, e3)
  let fix x ~is:e = Fix (x, e)
  let nil = ListNil
  let cons e1 e2 = ListCons (e1, e2)

  let match_ e1 ~with_nil:e2 ~with_cons:(x, y, e3) =
    ListMatch (e1, e2, (x, (y, e3)))

  let pair e1 e2 = Both (e1, e2)
  let fst e = I1 e
  let snd e = I2 e
end
