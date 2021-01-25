%{
open Ast
let mk_lambdas (xs : string list) (e : expr) =
  let f x e' = Lambda(x, e') in
  List.fold_right f xs e
%}

/* Tokens */

%token EOF FUN THINARROW GT EQ LT LPAREN RPAREN DOT COMMA
%token TRUE FALSE AND OR
%token LET IN IF THEN ELSE FUN WITH LAMBDA
%token NIL CONS HEAD TAIL ISNIL

%token PLUS SUB TIMES APP
%token <int> NUMBER
%token <string> ID

%nonassoc LPAREN ID NIL NUMBER TRUE FALSE
%right LAMBDA
%left AND OR
%left LT GT EQ
%left PLUS SUB
%left TIMES
%right CONS
%left APP
%nonassoc HEAD TAIL

%start main
%type <Ast.expr> main
%%

main:
    | expr EOF { $1 }

idlist:
    | ID              { [$1] }
    | ID COMMA idlist { $1 :: $3 }


/* split up exprs into multiple parts. This is to avoid reducing expr
   prematurely, otherwise we end up with situations like (lambda f. f 3) parsed
   as ((lambda f. f) 3)
   */
expr:
    | LAMBDA idlist DOT expr %prec LAMBDA { mk_lambdas $2 $4 }
    | FUN ID WITH idlist EQ expr IN expr  { LetBind($2, mk_lambdas $4 $6, $8) }
    | LPAREN expr RPAREN                  { $2 }
    | IF expr THEN expr ELSE expr         { IfThenElse($2, $4, $6) }
    | LET ID EQ expr IN expr              { LetBind($2, $4, $6) }
    | term                                { $1 }

atom:
    | ID                                  { Var($1) }
    | NUMBER                              { NumLit($1) }
    | NIL                                 { ListNil }

binop:
    | term PLUS term                      { Binop($1, Add, $3) }
    | term SUB term                       { Binop($1, Sub, $3) }
    | term TIMES term                     { Binop($1, Mul, $3) }
    | term LT term                        { Binop($1, Lt, $3) }
    | term GT term                        { Binop($1, Gt, $3) }
    | term EQ term                        { Binop($1, Eq, $3) }
    | term AND term                       { Binop($1, And, $3) }
    | term OR term                        { Binop($1, Or, $3) }

term:
    | atom                                { $1 }
    | binop                               { $1 }
    | HEAD term                           { ListHead($2) }
    | TAIL term                           { ListTail($2) }
    | ISNIL term                          { ListIsNil($2) }
    | LPAREN expr RPAREN                  { $2 }
    | term term %prec APP                 { App($1, $2) }
    | term CONS term                      { ListCons($1, $3) }
