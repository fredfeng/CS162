{ 
  open Parser 
}

rule token = parse
 | [' ' '\r' '\t'] { token lexbuf }
 | '\n'            { Lexing.new_line lexbuf; token lexbuf }
 | "let"           { LET }
 | "in"            { IN }
 | "fun"           { FUN }
 | "rec"           { REC }
 | "with"          { WITH }
 | "match"         { MATCH }
 | "end"           { END }
 | "lambda"        { LAMBDA }
 | "if"            { IF }
 | "then"          { THEN }
 | "else"          { ELSE }
 | "true"          { TRUE }
 | "false"         { FALSE }
 | "Nil"           { NIL }
 | "::"             { CONS }
 | "+"             { PLUS }
 | "-"             { SUB }
 | "*"             { TIMES }
 | "Int"           { TYINT }
 | "List"          { TYLIST }
 | ['0'-'9']+ as n { NUMBER(int_of_string(n)) }
 | ['a'-'z' 'A'-'Z' '_']['a'-'z' 'A'-'Z' '0'-'9' '_']* as x { ID(x) }
 | "->"            { THINARROW }
 | ':'             { COLON }
 | ">"             { GT }
 | '='             { EQ }
 | "&&"            { AND }
 | "||"            { OR }
 | "|"             { BAR }
 | "<"             { LT }
 | '('             { LPAREN }
 | ')'             { RPAREN }
 | '['             { LBRACK }
 | ']'             { RBRACK }
 | '.'             { DOT }
 | ','             { COMMA }
 | "//"            { comment lexbuf }
 | eof             { EOF }
 | _               { raise (Err.Lexing {l = Lexing.lexeme_start lexbuf; s= Lexing.lexeme lexbuf} ) }

and comment = parse
 | '\n'            { Lexing.new_line lexbuf; token lexbuf }
 | _               { comment lexbuf }
 | eof             { EOF }
