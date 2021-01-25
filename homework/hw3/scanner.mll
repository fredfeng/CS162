{ open Parser }

rule token = parse
 | [' ' '\r' '\t' '\n'] { token lexbuf }
 | "let"           { LET }
 | "in"            { IN }
 | "fun"           { FUN }
 | "with"          { WITH }
 | "lambda"        { LAMBDA }
 | "if"            { IF }
 | "then"          { THEN }
 | "else"          { ELSE }
 | "isnil"         { ISNIL }
 | "!"             { HEAD }
 | "#"             { TAIL }
 | "Nil"           { NIL }
 | "@"             { CONS }
 | "+"             { PLUS }
 | "-"             { SUB }
 | "*"             { TIMES }
 | ['0'-'9']+ as n { NUMBER(int_of_string(n)) }
 | ['a'-'z' '_']['a'-'z' '0'-'9' '_']* as x { ID(x) }
 | "->"            { THINARROW }
 | ">"             { GT }
 | '='             { EQ }
 | "&&"            { AND }
 | "||"            { OR }
 | "<"             { LT }
 | '('             { LPAREN }
 | ')'             { RPAREN }
 | '.'             { DOT }
 | ','             { COMMA }
 | '#'             { comment lexbuf }
 | eof             { EOF }

and comment = parse
 | '\n'            { token lexbuf }
 | _               { comment lexbuf }
