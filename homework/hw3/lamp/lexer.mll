{ 
open Menhir_parser
exception LexError of string

let failwith msg = raise (LexError msg)

let illegal c =
    failwith (Printf.sprintf "[lexer] unexpected character: '%c'" c)
}

let ws = ' ' | '\t'
let newline = "\r\n" | '\r' | '\n'

rule next_token = parse
 | ws+ { next_token lexbuf }
 | newline         { Lexing.new_line lexbuf; next_token lexbuf }
 | "#load"         { CLOAD }
 | "#save"         { CSAVE }
 | "#print"        { CPRINT }
 | "#clear"        { CCLEAR }
 | "#let"          { CLET }
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
 | ".1"            { FST }
 | ".2"            { SND }
 | "Nil"           { NIL }
 | "::"            { CONS }
 | "+"             { PLUS }
 | "-"             { SUB }
 | "*"             { TIMES }
 | "$1"         { E1 }
 | "$2"         { E2 }
 | ['0'-'9']+ as n { NUMBER(Base.Int.of_string(n)) }
 | ['a'-'z' 'A'-'Z' '_']['a'-'z' 'A'-'Z' '0'-'9' '_']* as x { ID(x) }
 | ['a'-'z' 'A'-'Z' '0'-'9' '_' '-' '/' ]+ ".txt" as x { FILE(x) }
 | "->"            { THINARROW }
 | ">"             { GT }
 | '='             { EQ }
 | "|"             { BAR }
 | "<"             { LT }
 | '('             { LPAREN }
 | ')'             { RPAREN }
 | '.'             { DOT }
 | ','             { COMMA }
 | "//"            { comment lexbuf }
 | eof             { EOF }
 | _ as c          { illegal c }

and comment = parse
 | newline         { Lexing.new_line lexbuf; next_token lexbuf }
 | _               { comment lexbuf }
 | eof             { EOF }
