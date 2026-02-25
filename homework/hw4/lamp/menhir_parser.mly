%{

let mk_lambdas (xs : (string * Ast.ty option) list) (e : Ast.expr) (r: Ast.ty option) =
  let f (x, topt) e' = Ast.Lambda(topt, (x,e')) in
  List.fold_right f xs (match r with None -> e | Some r -> Annot(e, r))

let mk_tfun_of_list (xs: (string * Ast.ty option) list) (r: Ast.ty option) : Ast.ty option =
  match r with
  | Some r ->
    List.fold_right (fun (x,topt) fo ->
      match topt, fo with
      | Some t, Some r -> Some (Ast.TFun(t,r))
      | _ -> None) xs (Some r)
  | None -> None
let mk_let (x: string) (ty: Ast.ty option) (e1: Ast.expr) (e2: Ast.expr) : Ast.expr =
  match ty with
  | Some t -> Ast.Let(Ast.Annot(e1, t), (x, e2))
  | None -> Ast.Let(e1, (x, e2))
%}

/* Tokens */

%token EOF FUN REC MATCH BAR END GT EQ LT LPAREN RPAREN DOT COMMA FIX IS
%token TRUE FALSE TYBOOL
%token LET IN IF THEN ELSE WITH LAMBDA
%token NIL CONS
%token TYINT TYLIST THINARROW COLON LBRACK RBRACK
%token CLET CPRINT CCLEAR CLOAD CSAVE CSYNTH
%token TICK FORALL
%token FST SND CASE1 CASE2 VOID

%token PLUS SUB TIMES
%token <int> NUMBER
%token <string> ID
%token <string> FILE

%nonassoc IN DOT ELSE IS CASE1 CASE2
%nonassoc COLON
%right CONS
%left LT GT EQ
%left PLUS SUB
%right THINARROW
%left TIMES

%start expr_eof
%type <Ast.expr> expr_eof

%start repl_command_eof
%type <Cmd.t> repl_command_eof

%start script_eof
%type <Cmd.t list> script_eof

%start ty_eof
%type <Ast.ty> ty_eof


%%

file_command:
  | CLET bind EQ expr
    { let (x,t) = $2 in Cmd.CLet(x,t,$4) }
  | CPRINT
    { Cmd.CPrint}
  | CCLEAR
    { Cmd.CClear}
  | CLOAD FILE
    { Cmd.CLoad $2 }
  | CSAVE FILE
    { Cmd.CSave $2 }
  | CSYNTH ty
    { Cmd.CSynth $2 }

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

ty_var:
  | TICK ID
    { ("\'" ^ $2) }

ty_atom:
  | x=ty_var
    { Ast.TVar x }
  | TYINT
    { Ast.TInt }
  | TYBOOL
    { Ast.TBool }
  | LPAREN t=ty RPAREN
    { t }
  | LPAREN RPAREN
    { Ast.TUnit }
  | VOID
    { Ast.TVoid }

ty_eof:
  | t=ty EOF
    { t }

ty:
  | t=ty_atom
    { t }
  | t1=ty THINARROW t2=ty
    { TFun (t1, t2) }
  | t1=ty TIMES t2=ty
    { TProd (t1, t2) }
  | t1=ty PLUS t2=ty
    { TSum (t1, t2) }
  | TYLIST LBRACK t=ty RBRACK
    { TList t }

bind:
  | x=ID COLON t=ty
    { (x, Some t) }
  | x=ID
    { (x, None) }

bindlist:
  | l=separated_nonempty_list(COMMA, bind)
    { l }

expr:
  | e=app
    { e }
  | e=expr COLON t=ty
    { Ast.Annot(e, t) }
  | LAMBDA bs=bindlist DOT e=expr
    { mk_lambdas bs e None }
  | FUN REC b=bind WITH bs=bindlist EQ e1=expr IN e2=expr
    { let (x,r) = b in
      Let(Fix (mk_tfun_of_list bs r, (x, mk_lambdas bs e1 r)), (x, e2)) }
  | FUN b=bind WITH bs=bindlist EQ e1=expr IN e2=expr
    { let (x,r) = b in
      Let(mk_lambdas bs e1 r, (x, e2)) }
  | FIX b=bind IS e=expr
    { let (x, topt) = b in Fix (topt, (x, e)) }
  | LET b=bind EQ e1=expr IN e2=expr
    { let (x, topt) = b in
      mk_let x topt e1 e2 }
  | IF e1=expr THEN e2=expr ELSE e3=expr
    { IfThenElse(e1, e2, e3) }
  | e=list_match
    { e }
  | e=sum_match
    { e }
  | e=void_match
    { e }
  | e=binop(expr)
    { e }
  | CASE1; e=expr
    { E1 e }
  | CASE2; e=expr
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

tyarg_opt:
  | LBRACK ty RBRACK
    { Some $2 }
  |
    { None }

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

case(TAG):
  | TAG x=ID THINARROW e=expr
    { (x, e) }

sum_match:
  | MATCH e1=expr WITH option(BAR) b2=case(CASE1) BAR b3=case(CASE2) END
    { Ast.Either(e1, b2, b3) }

void_match:
  | MATCH e1=expr WITH END
    { Ast.Absurd e1 }

term:
  | x=ID
    { Ast.Var x }
  | n=NUMBER
    { Ast.Num n }
  | TRUE
    { Ast.True }
  | FALSE
    { Ast.False }
  | NIL t=tyarg_opt
    { ListNil t }
  | LPAREN e=expr RPAREN
    { e }
  | LPAREN e1=expr COMMA e2=expr RPAREN
    { Ast.Both(e1, e2) }
  | e=term FST
    { Ast.I1 e }
  | e=term SND
    { Ast.I2 e }
  | LPAREN RPAREN
    { Ast.Unit }

