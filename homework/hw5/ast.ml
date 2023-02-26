(** Binary operators *)
type binop = Add | Sub | Mul | Gt | Lt | And | Or | Eq



(** Types *)
type typ =
  | TInt
  | TFun of typ * typ
  | TList of typ
  


(** AST of Lambda+ expressions *)
type expr =
  | NumLit of int
  | Var of string
  | Binop of expr * binop * expr
  | IfThenElse of expr * expr * expr
  | LetBind of string * typ option * expr * expr
  | Lambda of string * typ option * expr
  | App of expr * expr
  | ListNil of typ option
  | ListCons of expr * expr
  | ListHead of expr
  | ListTail of expr
  | ListIsNil of expr
  | Fix of expr
  


(** Pretty print binop as string *)
let string_of_binop (op: binop) : string =
  match op with
  | Add -> "+" | Sub -> "-" | Mul -> "*" | Lt -> "<" | Gt -> ">"
  | Or -> "||" | And -> "&&" | Eq -> "="


let rec string_of_typ : typ -> string =
  let is_complex = function
    | TFun _ -> true
    | _ -> false
  in
  let pp_nested t =
    let s = string_of_typ t in if is_complex t then "(" ^ s ^ ")" else s
  in
  function
  | TInt -> "Int"
  | TFun (t1, t2) -> pp_nested t1 ^ " -> " ^ string_of_typ t2
  | TList t -> Format.sprintf "List[%s]" (pp_nested t)

(** Pretty print expr as string *)
let rec string_of_expr : expr -> string =
  let is_complex = function
    | (NumLit _ | Var _ | ListNil _) -> false
    | _ -> true
  in
  let parens e = "(" ^ string_of_expr e ^ ")" in
  let pp_nested e = if is_complex e then parens e else string_of_expr e in
  let pp_topt topt = Option.fold ~none:"" ~some:(fun t -> ": " ^ string_of_typ t) topt in
  function
  | NumLit n -> string_of_int n
  | Var x -> x
  | Binop (e1, op, e2) -> pp_nested e1 ^ " " ^ string_of_binop op ^ " " ^ pp_nested e2
  | IfThenElse (e1, e2, e3) ->
    Format.sprintf "if %s then %s else %s"
      (string_of_expr e1) (string_of_expr e2) (string_of_expr e3)
  | Lambda (x, topt, e) -> Format.sprintf "lambda %s%s. %s" x (pp_topt topt) (string_of_expr e)
  | LetBind (x, topt, e1, e2) ->
    Format.sprintf "let %s%s = %s in %s"
      x (pp_topt topt) (string_of_expr e1) (string_of_expr e2)
  | App (e1, e2) -> pp_nested e1 ^ " " ^ pp_nested e2
  | ListNil topt ->
    "Nil" ^ Option.fold ~none:"" ~some:(fun t -> Format.sprintf "[%s]" (string_of_typ t)) topt
  | ListCons (e1, e2) ->
    let p2 = match e2 with
      | ListCons _ -> string_of_expr e2
      | _ -> pp_nested e2
    in
    pp_nested e1 ^ " @ " ^ p2
  | ListHead e -> "!" ^ pp_nested e
  | ListTail e -> "#" ^ pp_nested e
  | ListIsNil e -> "isnil " ^ pp_nested e
  | Fix e -> "fix " ^ pp_nested e


(** Returns true iff the given expr is a value *)
let rec is_value : expr -> bool = function
  | NumLit _ -> true
  | Lambda _ -> true
  | ListNil _ -> true
  | ListCons (e1, e2) -> is_value e1 && is_value e2
  | _ -> false


module Dsl = struct
  let lam x ?t:(t=None) e = Lambda(x, t, e) 
  let v x = Var x 
  let i n = NumLit n 
  let (+:) e1 e2 = Binop (e1, Add, e2) 
  let (-:) e1 e2 = Binop (e1, Sub, e2) 
  let ( *:) e1 e2 = Binop (e1, Mul, e2) 
  let (>:) e1 e2 = Binop (e1, Gt, e2) 
  let (<:) e1 e2 = Binop (e1, Lt, e2) 
  let (&&:) e1 e2 = Binop (e1, And, e2) 
  let (||:) e1 e2 = Binop (e1, Or, e2) 
  let (=:) e1 e2 = Binop (e1, Eq, e2) 
  let ite e1 e2 e3 = IfThenElse (e1, e2, e3) 
  let let_ x ?t:(t=None) e1 e2 = LetBind (x, t, e1, e2) 
  let app e1 e2 = App (e1, e2) 
  let nil = ListNil None 
  let nil' t = ListNil t 
  let cons e1 e2 = ListCons (e1, e2) 
  let list ?t:(t=None) es = List.fold_right cons es (nil' t) 
  let tail e = ListTail e 
  let head e = ListHead e 
  let isnil e = ListIsNil e 

  let tint = TInt 
  let tlist t = TList t 
  let tfun t1 t2 = TFun (t1, t2) 
end
