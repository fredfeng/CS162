%{
open Ast
let mk_lambdas (xs : string list) (e : expr) =
  let f x e' = Lambda(Scope(x,e')) in
  List.fold_right f xs e

%}

/* Tokens */

%token EOF FUN REC MATCH BAR END GT EQ LT LPAREN RPAREN DOT COMMA
%token TRUE FALSE AND OR
%token LET IN IF THEN ELSE WITH LAMBDA
%token NIL CONS
%token TYINT TYLIST THINARROW COLON LBRACK RBRACK

%token PLUS SUB TIMES APP
%token <int> NUMBER
%token <string> ID

%nonassoc LPAREN RPAREN ID NIL NUMBER TRUE FALSE LBRACK RBRACK
%right LAMBDA
%left AND OR
%left LT GT EQ
%left PLUS SUB
%left TIMES
%right CONS
%left APP

%right THINARROW TYLIST

%start main
%type <Ast.expr> main

%%

main:
    | expr EOF { $1 }
    | error EOF { Err.syntax_error() }

bind:
    | ID { $1 }

bindlist:
    | bind                { [$1] }
    | bind COMMA bindlist { $1 :: $3 }


/* split up exprs into multiple parts. This is to avoid reducing expr
   prematurely, otherwise we end up with situations like (lambda f. f 3) parsed
   as ((lambda f. f) 3)
   */
expr:
    | LAMBDA bindlist DOT expr %prec LAMBDA  { mk_lambdas $2 $4 }
    | FUN bind WITH bindlist EQ expr IN expr { let x = $2 in Let(mk_lambdas $4 $6, Scope(x,$8)) }
    | LET bind EQ expr IN expr               { Let($4, Scope($2,$6)) }
    | binop                                  { $1 }
    | term                                   { $1 }

atom:
    | ID                                  { Var($1) }
    | NUMBER                              { Num($1) }

binop:
    | expr PLUS expr                      { Binop(Add, $1, $3) }
    | expr SUB  expr                      { Binop(Sub, $1, $3) }
    | expr TIMES expr                      { Binop(Mul, $1, $3) }

term:
    | atom                                { $1 }
    | LPAREN expr RPAREN                  { $2 }
    | term term %prec APP                 { App($1, $2) }
