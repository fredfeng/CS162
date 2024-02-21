%{
open Ast
let mk_lambdas (xs : (string * ty option) list) (e : expr) (r: ty option) =
  let f (x, topt) e' = Lambda(topt, Scope(x,e')) in
  List.fold_right f xs (match r with None -> e | Some r -> Annot(e, r))

let rec mk_tfun_of_list (xs: (string * ty option) list) (r: ty option) : ty option = 
    match r with 
    | Some r ->
        List.fold_right (fun (x,topt) fo -> 
            match topt, fo with
            | Some t, Some r -> Some (TFun(t,r))
            | _ -> None) xs (Some r)
    | None -> None
let mk_let (x: string) (ty: ty option) (e1: expr) (e2: expr) : expr = 
    match ty with
    | Some t -> Let(Annot(e1, t), Scope(x, e2))
    | None -> Let(e1, Scope(x, e2))
%}

/* Tokens */

%token EOF FUN REC MATCH BAR END GT EQ LT LPAREN RPAREN DOT COMMA AT FIX IS LBRACE RBRACE
%token TRUE FALSE TYBOOL FST SND
%token LET IN IF THEN ELSE WITH LAMBDA
%token NIL CONS SEMI SHARP
%token TYINT TYLIST THINARROW COLON LBRACK RBRACK
%token CLET CPRINT CCLEAR CLOAD CSAVE CPLUSMETA CMINUSMETA

%token PLUS SUB TIMES APP
%token <int> NUMBER
%token <string> ID
%token <string> FILE

%nonassoc LPAREN RPAREN ID NIL NUMBER TRUE FALSE 
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

%start ty
%type <Ast.ty> ty
%%

command:
    | CLET bind EQ expr { let (x,t) = $2 in Cmd.CLet(x,t,$4) }
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
    | error EOF { Err.syntax_error () }

ty_atom:
    | TYINT { TInt }
    | TYBOOL { TBool }
    | LPAREN; ty; RPAREN { $2 }

ty_expr:
    | TYLIST LBRACK ty RBRACK { TList $3 }
    | ty_atom { $1 }

ty:
    | ty_expr; THINARROW; ty { TFun ($1, $3) }
    | ty_expr; TIMES; ty { TProd ($1, $3) }
    | ty_expr { $1 }

bind:
    | ID COLON ty { ($1, Some $3) }
    | ID { ($1, None) }

bindlist:
    | bind  { [$1] }
    | bind COMMA bindlist { $1 :: $3 }

/* split up exprs into multiple parts. This is to avoid reducing expr
   prematurely, otherwise we end up with situations like (lambda f. f 3) parsed
   as ((lambda f. f) 3)
   */
expr:
    | LAMBDA bindlist DOT expr %prec LAMBDA         { mk_lambdas $2 $4 None }
    | FUN REC bind WITH bindlist EQ expr IN expr    { let (x,r) = $3 in 
                                                        let xs = $5 in
                                                        let e1 = $7 in
                                                        let e2 = $9 in
                                                        Let(Fix (mk_tfun_of_list xs r, Scope(x, mk_lambdas xs e1 r)), Scope(x, e2)) }
    | FUN bind WITH bindlist EQ expr IN expr        { let (x,r) = $2 in 
                                                        let xs = $4 in
                                                        let e1 = $6 in
                                                        let e2 = $8 in
                                                        Let(mk_lambdas xs e1 r, Scope(x, e2)) }
    | FIX bind IS expr                              { let (x, topt) = $2 in Fix (topt, Scope(x, $4)) }
    | LET bind EQ expr IN expr                      { let (x, topt) = $2 in
                                                        let e1 = $4 in 
                                                        let e2 = $6 in
                                                        mk_let x topt e1 e2 }
    | IF expr THEN expr ELSE expr              { IfThenElse($2, $4, $6) }
    | FST term                             { Fst $2 }
    | SND term                             { Snd $2 }
    | list_match                            { $1 }
    | binop                                  { $1 }
    | expr AT ty                          { Annot($1, $3) }
    | term                                   { $1 }

tyarg_opt:
    | LBRACK; ty; RBRACK { Some $2 }
    | { None }
atom:
    | ID                                  { Var($1) }
    | NUMBER                              { Num($1) }
    | TRUE                                { True }
    | FALSE                               { False }
    | NIL tyarg_opt                       { ListNil $2 }

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
    | expr SUB expr                       { Binop(Sub, $1, $3) }
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
