(** Helper function for parsing an expression. Useful for testing. *)
let parse (s : string) : Ast.expr =
  Parser.main Scanner.token (Lexing.from_string s)

let parse_file (f : string) : Ast.expr =
  let ch = open_in f in
  let contents = really_input_string ch (in_channel_length ch) in
  close_in ch;
  parse contents
