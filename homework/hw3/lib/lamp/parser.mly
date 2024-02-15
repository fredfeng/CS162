%{
open Ast
let mk_lambdas (xs : string list) (e : expr) =
  let f x e' = Lambda(Scope(x,e')) in
  List.fold_right f xs e

%}

/* Tokens */

%token EOF FUN REC MATCH BAR END GT EQ LT LPAREN RPAREN DOT COMMA SHARP
%token AT FIX IS LBRACE RBRACE FST SND
%token TRUE FALSE
%token LET IN IF THEN ELSE WITH LAMBDA
%token NIL CONS
%token TYINT TYBOOL TYLIST THINARROW COLON LBRACK RBRACK
%token CLET CPRINT CCLEAR CLOAD CSAVE CPLUSMETA CMINUSMETA

%token PLUS SUB TIMES APP
%token <int> NUMBER
%token <string> ID
%token <string> FILE

%nonassoc LPAREN RPAREN ID NIL NUMBER TRUE FALSE LBRACK RBRACK
%right LAMBDA
%right CONS
%left LT GT EQ
%left PLUS SUB
%left TIMES
%left APP

%right THINARROW TYLIST

%start main
%type <Ast.expr> main

%start command
%type <Cmd.t> command

%start commands
%type <Cmd.t list> commands


%%

command:
    | CLET bind EQ expr { let x = $2 in Cmd.CLet(x,$4) }
    | CPRINT  { Cmd.CPrint}
    | CCLEAR { Cmd.CClear}
    | CLOAD FILE { Cmd.CLoad $2 }
    | CSAVE FILE { Cmd.CSave $2 }
    | CPLUSMETA { Cmd.CMeta }
    | CMINUSMETA { Cmd.CExitMeta }
    | expr {Cmd.CEval $1 }

command_list:
    | { [] }
    | command commands { $1 :: $2 }

commands:
    | command_list EOF { $1 }
    | error EOF { Err.syntax_error () }

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
    | FIX bind IS expr                       { Fix(Scope($2, $4)) }      
    | FUN bind WITH bindlist EQ expr IN expr { let f = $2 in Let(mk_lambdas $4 $6, Scope(f,$8)) }
    | FUN REC bind WITH bindlist EQ expr IN expr { let f = $3 in Let(Fix(Scope(f, mk_lambdas $5 $7)), Scope(f,$9)) }
    | LET bind EQ expr IN expr               { Let($4, Scope($2,$6)) }
    | IF expr THEN expr ELSE expr            { IfThenElse($2, $4, $6) }
    | FST term                               { Fst $2 }
    | SND term                               { Snd $2 }
    | list_match                             { $1 }
    | binop                                  { $1 }
    | term                                   { $1 }

atom:
    | ID                                  { Var($1) }
    | NUMBER                              { Num($1) }
    | TRUE                                { True }
    | FALSE                               { False }
    | NIL                                 { ListNil }

bar_opt:
    | { () }
    | BAR { () }

nil_branch:
    | NIL THINARROW expr                  { $3 }

cons_branch:
    | ID CONS ID THINARROW expr           { ($1, $3, $5) }

list_match:
    | MATCH expr WITH bar_opt nil_branch BAR cons_branch END
        { 
            let (x,y,e3) = $7 in
            ListMatch($2, $5, Scope(x, Scope(y, e3)))}

binop:
    | expr PLUS expr                      { Binop(Add, $1, $3) }
    | expr SUB  expr                      { Binop(Sub, $1, $3) }
    | expr TIMES expr                     { Binop(Mul, $1, $3) }
    | expr LT expr                        { Comp(Lt, $1, $3) }
    | expr GT expr                        { Comp(Gt, $1, $3) }
    | expr EQ expr                        { Comp(Eq, $1, $3) }
    | expr CONS expr                      { ListCons($1, $3) }

term:
    | atom                                { $1 }
    | LPAREN expr RPAREN                  { $2 }
    | term term %prec APP                 { App($1, $2) }
    | LBRACE expr COMMA expr RBRACE       { Pair($2, $4) }
