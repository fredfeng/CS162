(*********************************************************************
 * Abstract syntax trees for lambda expressions and type expressions *
 *********************************************************************)

type id = string

(* lambda expressions *)
type expr =
  | Fun of id * expr
  | App of expr * expr
  | Var of id

(* type expressions *)
type typ =
  | TVar of id
  | Arrow of typ * typ

(* annotated expressions *)
type aexpr =
  | AFun of id * aexpr * typ
  | AApp of aexpr * aexpr * typ
  | AVar of id * typ

let rec to_string (e : expr) : string =
  match e with
    | Var x -> x
    | Fun (x, e) -> Printf.sprintf "fun %s -> %s" x (to_string e)
    | App (Fun _ as e1, e2) -> Printf.sprintf "%s %s" (protect e1) (protect e2)
    | App (e1, e2) -> Printf.sprintf "%s %s" (to_string e1) (protect e2)

and protect (e : expr) : string =
  match e with
    | Var x -> x
    | _ -> Printf.sprintf "(%s)" (to_string e)

let rec type_to_string (e : typ) : string =
  match e with
    | TVar x -> "'" ^ x
    | Arrow (Arrow (u, v) as s, t) -> Printf.sprintf "(%s) -> %s" (type_to_string s) (type_to_string t)
    | Arrow (s, t) -> Printf.sprintf "%s -> %s" (type_to_string s) (type_to_string t)

let rec aexpr_to_string (e : aexpr) : string =
  match e with
    | AVar (x, a) -> Printf.sprintf "(%s:%s)" x (type_to_string a)
    | AApp (e1, e2, a) -> Printf.sprintf "((%s %s):%s)" (aexpr_to_string e1) (aexpr_to_string e2) (type_to_string a)
    | AFun (x, e, a) -> Printf.sprintf "((Fun %s -> %s):%s)" x (aexpr_to_string e) (type_to_string a)
