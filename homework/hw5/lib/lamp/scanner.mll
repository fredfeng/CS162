{ open Parser 

}

rule token = parse
 | [' ' '\r' '\t'] { token lexbuf }
 | '\n'            { Lexing.new_line lexbuf;  token lexbuf }
 | "#load"         { CLOAD }
 | "#save"         { CSAVE }
 | "#print"        { CPRINT }
 | "#clear"        { CCLEAR }
 | "#let"          { CLET }
 | "+meta"         { CPLUSMETA }
 | "-meta"         { CMINUSMETA }
 | "#synth"        { CSYNTH }
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
 | "fix"           { FIX }
 | "is"            { IS }
 | "fst"           { FST }
 | "snd"           { SND }
 | "Nil"           { NIL }
 | "::"            { CONS }
 | "+"             { PLUS }
 | "-"             { SUB }
 | "*"             { TIMES }
 | "{"             { LBRACE }
 | "}"             { RBRACE }
 | "Int"           { TYINT }
 | "Bool"          { TYBOOL }
 | "List"          { TYLIST }
 | '\''            { TICK }
 | "forall"        { FORALL }
 | ['0'-'9']+ as n { NUMBER(int_of_string(n)) }
 | ['a'-'z' 'A'-'Z' '_']['a'-'z' 'A'-'Z' '0'-'9' '_']* as x { ID(x) }
 | ['a'-'z' 'A'-'Z' '0'-'9' '_' '-' '/' ]+ ".txt" as x { FILE(x) }
 | "->"            { THINARROW }
 | '@'             { AT }
 | ':'             { COLON }
 | ">"             { GT }
 | '='             { EQ }
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
