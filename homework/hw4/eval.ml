open Ast

(** Variable set. Based on OCaml standard library Set. *)
module VarSet = Set.Make (String)

(* Helper function for parsing an expression. Useful for testing. *)
let parse (s: string) : Ast.expr =
  Parser.main Scanner.token (Lexing.from_string s)
(*******************************************************************|
|**********************   Interpreter   ****************************|
|*******************************************************************|
|*******************************************************************)

(* Exception indicating that evaluation is stuck *)
exception Stuck of string

(* Raises an exception indicating that evaluation got stuck. *)
let im_stuck msg = raise (Stuck msg)

(* Raises an exception for things that need to be implemented
 * in this assignment *)
let todo () = failwith "TODO"

(* Helper function to check that an expression is a value, otherwise raises a
   Stuck exception. *)
let assert_value e =
  if is_value e then () else im_stuck (string_of_expr e ^ " is not a value")

(** Computes the set of free variables in the given expression *)
let rec free_vars (e : expr) : VarSet.t =
  failwith "TODO: homework" ;;

(** Performs the substitution [x -> ex]e *)
let rec subst (x : string) (e1 : expr) (e2 : expr) : expr =
  failwith "TODO: homework" ;;

(** Evaluates e under the environment env. You need to copy over your
   implementation of homework 3. *)
let rec eval (e : expr) : expr =
  try
    match e with
    | _ -> todo ()
  with
  | Stuck msg -> im_stuck (msg ^ "\nin expression " ^ string_of_expr e)
  ;;
