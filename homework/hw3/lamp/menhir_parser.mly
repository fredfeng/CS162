%{

let mk_lambdas (xs : string list) (e : Ast.expr) : Ast.expr =
  let f x e' = Ast.Lambda((x,e')) in
  List.fold_right f xs e
%}

/* Tokens */

%token EOF FUN REC MATCH BAR END GT EQ LT LPAREN RPAREN DOT COMMA FIX IS
%token TRUE FALSE
%token LET IN IF THEN ELSE WITH LAMBDA
%token NIL CONS
%token THINARROW  
%token CLET CPRINT CCLEAR CLOAD CSAVE
%token FST SND E1 E2

%token PLUS SUB TIMES
%token <int> NUMBER
%token <string> ID
%token <string> FILE

%nonassoc IN DOT ELSE IS
%right CONS
%left LT GT EQ
%left PLUS SUB
%left TIMES
%nonassoc E1 E2

%start expr_eof
%type <Ast.expr> expr_eof

%start repl_command_eof
%type <Cmd.t> repl_command_eof

%start script_eof
%type <Cmd.t list> script_eof

%%

file_command:
  | CLET bind EQ expr
    { let x = $2 in Cmd.CLet(x,$4) }
  | CPRINT
    { Cmd.CPrint}
  | CCLEAR
    { Cmd.CClear}
  | CLOAD FILE
    { Cmd.CLoad $2 }
  | CSAVE FILE
    { Cmd.CSave $2 }

repl_command:
  | c=file_command
    { c }
  | expr
    { Cmd.CEval $1 }

repl_command_eof:
  | c=repl_command EOF
    { c }

script_eof:
  | cs=list(file_command) EOF
    { cs }

expr_eof:
  | e=expr EOF
    { e }

bind:
  | x=ID
    { x }

bindlist:
  | l=separated_nonempty_list(COMMA, bind)
    { l }

expr:
  | e=app
    { e }
  | LAMBDA bs=bindlist DOT e=expr
    { mk_lambdas bs e }
  | FUN REC x=bind WITH bs=bindlist EQ e1=expr IN e2=expr
    { Let(Fix ((x, mk_lambdas bs e1)), (x, e2)) }
  | FUN x=bind WITH xs=bindlist EQ e1=expr IN e2=expr
    { Let(mk_lambdas xs e1, (x, e2)) }
  | FIX x=bind IS e=expr
    { Fix (x,e) }
  | LET b=bind EQ e1=expr IN e2=expr
    { let x = b in
      Ast.Let (e1, (x,e2)) }
  | IF e1=expr THEN e2=expr ELSE e3=expr
    { IfThenElse(e1, e2, e3) }
  | e=list_match
    { e }
  | e=sum_match
    { e }
  | e=binop(expr)
    { e }
  | E1; e=expr
    { E1 e }
  | E2; e=expr
    { E2 e }
  
binop(expr):
  | expr PLUS expr
    { Binop(Add, $1, $3) }
  | expr SUB expr
    { Binop(Sub, $1, $3) }
  | expr TIMES expr
    { Binop(Mul, $1, $3) }
  | expr LT expr
    { Comp(Lt, $1, $3) }
  | expr GT expr
    { Comp(Gt, $1, $3) }
  | expr EQ expr
    { Comp(Eq, $1, $3) }
  | expr CONS expr
    { ListCons($1, $3) }

app:
  | term
    { $1 }
  | e1=app e2=term
    { App(e1, e2) }

nil_branch:
  | NIL THINARROW e=expr
    { e }

cons_branch:
  | x=ID CONS y=ID THINARROW e=expr
    { (x, y, e) }

list_match:
  | MATCH e1=expr WITH option(BAR) e2=nil_branch BAR b3=cons_branch END
    {
      let (x,y,e3) = b3  in
      Ast.ListMatch(e1, e2, (x, (y, e3)))}

branch(TAG):
  | TAG x=ID THINARROW e=expr
    { (x, e) }

sum_match:
  | MATCH e1=expr WITH option(BAR) b2=branch(E1) BAR b3=branch(E2) END
    { Ast.Either(e1, b2, b3) }

term:
  | x=ID
    { Ast.Var x }
  | n=NUMBER
    { Ast.Num n }
  | TRUE
    { Ast.True }
  | FALSE
    { Ast.False }
  | NIL
    { ListNil }
  | LPAREN e=expr RPAREN
    { e }
  | LPAREN e1=expr COMMA e2=expr RPAREN
    { Ast.Both(e1, e2) }
  | e=term FST
    { Ast.I1 e }
  | e=term SND
    { Ast.I2 e }

