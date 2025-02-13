module Expr = Nice_parser.Make (struct
  type result = Ast.expr
  type token = Menhir_parser.token

  exception ParseError = Menhir_parser.Error

  let parse = Menhir_parser.expr_eof

  include Lexer
end)

module Command = Nice_parser.Make (struct
  type result = Cmd.t
  type token = Menhir_parser.token

  exception ParseError = Menhir_parser.Error

  let parse = Menhir_parser.repl_command_eof

  include Lexer
end)

module Script = Nice_parser.Make (struct
  type result = Cmd.script
  type token = Menhir_parser.token

  exception ParseError = Menhir_parser.Error

  let parse = Menhir_parser.script_eof

  include Lexer
end)
