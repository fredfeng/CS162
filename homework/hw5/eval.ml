open Ast

(** Helper function for parsing an expression. Useful for testing. *)
let parse (s: string) : Ast.expr =
  Parser.main Scanner.token (Lexing.from_string s)

(*******************************************************************
 **********************   Interpreter   ****************************
 *******************************************************************
 *******************************************************************)

(** Exception indicating that evaluation is stuck *)
exception Stuck of string

let rec eval e : expr = e