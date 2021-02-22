%{
open Ast
let mk_lambdas (xs : (string * typ option) list) (e : expr) =
  let f (x, topt) e' = Lambda(x, topt, e') in
  List.fold_right f xs e
%}

/* Tokens */

%token EOF FUN GT EQ LT LPAREN RPAREN DOT COMMA
%token TRUE FALSE AND OR
%token LET IN IF THEN ELSE FUN WITH LAMBDA
%token NIL CONS HEAD TAIL ISNIL
%token TYINT TYLIST THINARROW COLON LBRACK RBRACK

%token PLUS SUB TIMES APP
%token <int> NUMBER
%token <string> ID

%nonassoc LPAREN ID NIL NUMBER TRUE FALSE LBRACK RBRACK
%right LAMBDA
%left AND OR
%left LT GT EQ
%left PLUS SUB
%left TIMES
%right CONS
%left APP
%nonassoc HEAD TAIL

%right THINARROW TYLIST

%start main
%type <Ast.expr> main

%start ty
%type <Ast.typ> ty
%%

main:
    | expr EOF { $1 }

idlist:
    | ID              { [$1] }
    | ID COMMA idlist { $1 :: $3 }

ty_atom:
    | TYINT { TInt }
    | LPAREN ty RPAREN { $2 }

ty_expr:
    | TYLIST LBRACK ty RBRACK { TList $3 }
    | ty_atom { $1 }

ty:
    | ty_expr THINARROW ty { TFun ($1, $3) }
    | ty_expr { $1 }

bind:
    | ID COLON ty { ($1, Some $3) }
    | ID { ($1, None) }

bindlist:
    | bind                { [$1] }
    | bind COMMA bindlist { $1 :: $3 }

tyarg_opt:
    | LBRACK ty RBRACK { Some $2 }
    | { None }

/* split up exprs into multiple parts. This is to avoid reducing expr
   prematurely, otherwise we end up with situations like (lambda f. f 3) parsed
   as ((lambda f. f) 3)
   */
expr:
    | LAMBDA bindlist DOT expr %prec LAMBDA  { mk_lambdas $2 $4 }
    | FUN bind WITH bindlist EQ expr IN expr { let (x, topt) = $2 in LetBind(x, topt, mk_lambdas $4 $6, $8) }
    | LPAREN expr RPAREN                     { $2 }
    | IF expr THEN expr ELSE expr            { IfThenElse($2, $4, $6) }
    | LET bind EQ expr IN expr               { let (x, t) = $2 in LetBind(x, t, $4, $6) }
    | term                                   { $1 }

atom:
    | ID                                  { Var($1) }
    | NUMBER                              { NumLit($1) }
    | NIL tyarg_opt                       { ListNil $2 }

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
    | HEAD term                           { ListHead $2 }
    | TAIL term                           { ListTail $2 }
    | ISNIL term                          { ListIsNil $2 }
    | LPAREN expr RPAREN                  { $2 }
    | term term %prec APP                 { App($1, $2) }
    | term CONS term                      { ListCons($1, $3) }
