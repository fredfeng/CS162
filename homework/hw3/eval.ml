open Ast

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

(* Raises an exception for things to be in the next assignment *)
let hw4 () = failwith "Homework 4"

(* Helper function to check that an expression is a value, otherwise raises a
   Stuck exception. *)
let assert_value e =
  if is_value e then () else im_stuck (string_of_expr e ^ " is not a value")

(* Evaluates expression e *)
let rec eval (e : expr) : expr =
  try
    match e with
    (* Things you need to implement *)
    | NumLit n -> todo ()
    | Binop (e1, op, e2) -> todo ()
    | IfThenElse (e1, e2, e3) -> todo ()
    | ListNil -> todo ()
    | ListCons (e1, e2) -> todo ()
    | ListHead e -> todo ()
    | ListTail e -> todo ()
    | ListIsNil e -> todo ()
    (* Things you don't need to implement in this assignment *)
    | _ -> hw4 ()
  with
  | Stuck msg -> im_stuck (msg ^ "\nin expression " ^ string_of_expr e)
