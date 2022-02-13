{ open Parser 

let incr_linenum lexbuf =
    let pos = lexbuf.Lexing.lex_curr_p in
    lexbuf.Lexing.lex_curr_p <- { pos with
      Lexing.pos_lnum = pos.Lexing.pos_lnum + 1;
      Lexing.pos_bol = pos.Lexing.pos_cnum;
    }
}

rule token = parse
 | [' ' '\r' '\t'] { token lexbuf }
 | '\n'            { incr_linenum lexbuf; token lexbuf }
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
 | ['a'-'z' '_']['a'-'z' 'A'-'Z' '0'-'9' '_']* as x { ID(x) }
 | "Int"           { TYINT }
 | "List"          { TYLIST }
 | "->"            { THINARROW }
 | ':'             { COLON }
 | ">"             { GT }
 | '='             { EQ }
 | "&&"            { AND }
 | "||"            { OR }
 | "<"             { LT }
 | '('             { LPAREN }
 | ')'             { RPAREN }
 | '['             { LBRACK }
 | ']'             { RBRACK }
 | '.'             { DOT }
 | ','             { COMMA }
 | "//"            { comment lexbuf }
 | eof             { EOF }

and comment = parse
 | '\n'            { incr_linenum lexbuf; token lexbuf }
 | _               { comment lexbuf }
 | eof             { EOF }
