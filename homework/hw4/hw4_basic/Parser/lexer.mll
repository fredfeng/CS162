{
open Parser
exception Eof
}

let alphabetic = ['a'-'z' 'A'-'Z']
let alphanumeric = ['a'-'z' 'A'-'Z' '0'-'9']*
rule token = parse
  | [' ' '\t']  { token lexbuf } (* skip blanks *)
  | ['\n'] { EOL }
  | "fun"  { FUN }
  | alphabetic alphanumeric as id { VAR id }
  | '('    { LPAREN }
  | ')'    { RPAREN }
  | "->"   { IMP }
  | eof    { EOL }
