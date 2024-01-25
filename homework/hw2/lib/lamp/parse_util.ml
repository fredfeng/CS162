(** Helper function for parsing an expression. Useful for testing. *)
let parse (s : string) : Ast.expr =
  Parser.main Scanner.token (Lexing.from_string s)
