open Base
open Util

type expr =
  | Const of int
  | X
  | Add of expr * expr
  | Mul of expr * expr
  | Compose of expr * expr

(* Pretty-printer *)
let rec pp_expr ppf = function
  | Const n -> Fmt.pf ppf "%d" n
  | X -> Fmt.pf ppf "x"
  | Add (e1, e2) -> Fmt.pf ppf "(%a + %a)" pp_expr e1 pp_expr e2
  | Mul (e1, e2) -> Fmt.pf ppf "(%a * %a)" pp_expr e1 pp_expr e2
  | Compose (e1, e2) -> Fmt.pf ppf "(%a; %a)" pp_expr e1 pp_expr e2

(* Convert an expression into a pretty string *)
let show_expr (e : expr) : string = Fmt.to_to_string pp_expr e
let rec eval_expr (x : int) (e : expr) : int = todo ()
let rec simplify (e : expr) : expr = todo ()

type poly = int list [@@deriving show]

let rec eval_poly (x : int) (p : poly) : int = todo ()
let rec normalize (e : expr) : poly = bonus ()
let semantic_equiv (e1 : expr) (e2 : expr) : bool = bonus ()
