let lp = "\
// if applied to any argument, always get stuck to signal an error \n\
let fail = lambda _. true + 1 in \n\
// call a function with a random argument \n\
let force = lambda f. f false in \n\
let bonus = fail in \n\
 \n\
// Your code starts here \n\
let var_enc = bonus in \n\
let lam_enc = bonus in \n\
let app_enc = bonus in \n\
 \n\
// Perform the substitution c[i |-> e] \n\
fun rec subst with i, e, c = bonus \n\
in \n\
fun rec eval with e =  \n\
    e  \n\
        // free variable \n\
        (lambda _. force fail) \n\
        // lambda \n\
        bonus \n\
        // application \n\
        (lambda e1,e2.  \n\
            (eval e1) \n\
                (lambda _. force fail) \n\
                bonus \n\
                (lambda _,_. force fail)) in \n\
 \n\
 \n\
// convert an encoded lambda-calculus term into a tagged list \n\
fun rec dec_ast with e =  \n\
    e  \n\
        (lambda i. 0::i) \n\
        (lambda i,e1. 1::i::(dec_ast e1)) \n\
        (lambda e1,e2. 2::(dec_ast e1::dec_ast e2)) \n\
 \n\
in \n\
 \n\
 \n\
// DO NOT modify this \n\
var_enc :: lam_enc :: app_enc :: subst :: eval :: dec_ast :: Nil \n\
"
