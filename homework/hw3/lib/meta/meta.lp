// if applied to any argument, always get stuck to signal an error
let fail = lambda _. true + 1 in
// call a function with a random argument
let force = lambda f. f false in
let bonus = fail in

// Your code starts here
let var_enc = bonus in
let lam_enc = bonus in
let app_enc = bonus in

// Perform the substitution c[i |-> e]
fun rec subst with i, e, c = bonus
in
fun rec eval with e = 
    e 
        // free variable
        (lambda _. force fail)
        // lambda
        bonus
        // application
        (lambda e1,e2. 
            (eval e1)
                (lambda _. force fail)
                bonus
                (lambda _,_. force fail)) in


// convert an encoded lambda-calculus term into a tagged list
fun rec dec_ast with e = 
    e 
        (lambda i. 0::i)
        (lambda i,e1. 1::i::(dec_ast e1))
        (lambda e1,e2. 2::(dec_ast e1::dec_ast e2))

in


// DO NOT modify this
var_enc :: lam_enc :: app_enc :: subst :: eval :: dec_ast :: Nil