
type var = string

type exp =
    Var of var
  | Lam of var * exp
  | App of exp * exp


type token =
  | LPAREN
  | RPAREN
  | EOL
  | APP
  | DOT
  | LAMBDA
  | VAR
  | ID of (char)
;;

let print_token x = match x with
                |LPAREN->"("
                | RPAREN->")"
                | EOL->"\n"
                | DOT ->"."
                | APP->"App"
                | LAMBDA ->"L"
                | VAR ->"Var"
                | ID x->String.make 1 x
;;
            
