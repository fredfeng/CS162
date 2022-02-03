(* Binary operators *)
type binop = Add | Sub | Mul | Gt | Lt | And | Or | Eq

(* AST of Lambda+ expressions *)
type expr =
  | NumLit of int
  | Var of string
  | Binop of expr * binop * expr
  | IfThenElse of expr * expr * expr
  | LetBind of string * expr * expr
  | Lambda of string * expr
  | App of expr * expr
  | ListNil
  | ListCons of expr * expr
  | ListHead of expr
  | ListTail of expr
  | ListIsNil of expr
  | Fix of expr

(* Pretty print binop as string *)
let string_of_binop (op: binop) : string =
  match op with
  | Add -> "+" | Sub -> "-" | Mul -> "*" | Lt -> "<" | Gt -> ">"
  | Or -> "||" | And -> "&&" | Eq -> "="

(* Pretty print expr as string *)
let rec string_of_expr : expr -> string =
  let is_complex = function
    | NumLit(_) -> false
    | Var(_) -> false
    | ListNil -> false
    | _ -> true
  in
  let parens e = "(" ^ string_of_expr e ^ ")" in
  let pp_nested e = if is_complex e then parens e else string_of_expr e in
  function
  | NumLit(n) -> string_of_int n
  | Var(x) -> x
  | Binop(e1, op, e2) -> pp_nested e1 ^ " " ^ string_of_binop op ^ " " ^ pp_nested e2
  | IfThenElse(e1, e2, e3) ->
    "if " ^ string_of_expr e1 ^ " then " ^ string_of_expr e2 ^ " else " ^ string_of_expr e3
  | Lambda(x, e) -> "lambda " ^ x  ^ ". " ^ string_of_expr e
  | LetBind(x, e1, e2) -> "let " ^ x  ^ " = " ^ string_of_expr e1 ^ " in " ^ string_of_expr e2
  | App(e1, e2) -> pp_nested e1 ^ " " ^ pp_nested e2
  | ListNil -> "Nil"
  | ListCons(e1, e2) ->
    let p2 = match e2 with
      | ListCons _ -> string_of_expr e2
      | _ -> pp_nested e2
    in
    pp_nested e1 ^ " @ " ^ p2
  | ListHead(e) -> "!" ^ pp_nested e
  | ListTail(e) -> "#" ^ pp_nested e
  | ListIsNil(e) -> "isnil " ^ pp_nested e
  | Fix e -> "fix " ^ pp_nested e

(* Returns true iff the given expr is a value *)
let rec is_value : expr -> bool = function
  | NumLit _ -> true
  | Lambda _ -> true
  | ListNil -> true
  | ListCons(e1, e2) -> is_value e1 && is_value e2
  | _ -> false
