%{
open Ast
%}

%token <string> VAR
%token LPAREN RPAREN
%token IMP
%token EOL
%token FUN
%token APP

%nonassoc FUN
%nonassoc VAR LPAREN
%left APP

%start main  /* entry point */
%type <Ast.expr> main

%%

main:
  expr EOL             { $1 }
;

expr:
  | VAR                 { Var $1 }
  | FUN VAR IMP expr %prec FUN { Fun ($2, $4) }
  | LPAREN expr RPAREN  { $2 }
  | expr expr %prec APP { App ($1, $2) }
;

