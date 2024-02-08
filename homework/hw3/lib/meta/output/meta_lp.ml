let lp = "\
let fail = lambda _. true + 1 in \n\
let force = lambda f. f false in \n\
let var_enc = lambda i. lambda v,l,a. v i in \n\
let lam_enc = lambda i,e. lambda v,l,a. l i e in \n\
let app_enc = lambda e1,e2. lambda v,l,a. a e1 e2 in \n\
fun rec subst with i, e, c =  \n\
    c  \n\
        (lambda j. if i = j then e else c) \n\
        (lambda j,c1. if i = j then c else lam_enc j (subst i e c1)) \n\
        (lambda c1,c2. app_enc (subst i e c1) (subst i e c2)) \n\
in \n\
fun rec eval with e =  \n\
    e  \n\
        (lambda _. force fail) \n\
        (lambda _, _. e) \n\
        (lambda e1,e2.  \n\
            (eval e1) \n\
                (lambda _. force fail) \n\
                (lambda i, e11. eval (subst i (eval e2) e11)) \n\
                (lambda _,_. force fail)) in \n\
// convert an encoded lambda-calculus term into a tagged list \n\
fun rec to_list with e =  \n\
    e  \n\
        (lambda i. 0::i) \n\
        (lambda i,e1. 1::i::(to_list e1)) \n\
        (lambda e1,e2. 2::(to_list e1::to_list e2)) \n\
in \n\
var_enc :: lam_enc :: app_enc :: subst :: eval :: to_list :: Nil \n\
"
