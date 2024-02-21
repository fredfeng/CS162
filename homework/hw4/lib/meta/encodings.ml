let raw = "\
// ************************ \n\
// ******* Decoders ******* \n\
// ************************ \n\
 \n\
#let dec_bool = lambda b. (b true) false \n\
#let dec_nat = lambda n. (n 0) (lambda _. lambda r. r + 1) \n\
#let dec_list = lambda xs. (xs Nil) (lambda x. lambda _. lambda r. x :: r) \n\
#let dec_tree = lambda t. t Nil (lambda x,_,_,l,r. x::(l::r)) \n\
#let dec_prod = lambda p. p (lambda x. lambda y. { x, y }) \n\
 \n\
// Convert an encoded lambda-calculus term into a tagged list \n\
#let dec_ast = fun rec dec_ast with e = \n\
    e  \n\
        (lambda i. 0::i) \n\
        (lambda i,e1. 1::i::(dec_ast e1)) \n\
        (lambda e1,e2. 2::(dec_ast e1::dec_ast e2)) in dec_ast \n\
 \n\
 \n\
 \n\
 \n\
// ************************ \n\
// ******* Encoders ******* \n\
// ************************ \n\
 \n\
// boolean \n\
#let tt = lambda x,y. x \n\
#let ff = lambda x,y. y \n\
 \n\
#let bonus = 0 \n\
 \n\
// nat \n\
#let zero = bonus \n\
#let succ = bonus \n\
#let add = bonus \n\
#let mul = bonus \n\
#let factorial = bonus \n\
#let pred = bonus \n\
#let sub = bonus \n\
#let is_zero = lambda m. m tt (lambda _,_. ff) \n\
#let leq = bonus \n\
#let eq = bonus \n\
#let lt = lambda n,m. (leq n (pred m)) \n\
#let gt = lambda n,m. lt m n \n\
 \n\
// list \n\
#let nil = bonus \n\
#let cons = bonus \n\
#let length = bonus \n\
 \n\
// tree \n\
#let leaf = bonus \n\
#let node = bonus \n\
#let size = bonus \n\
 \n\
// product \n\
#let pair = lambda x,y,f. f x y \n\
#let fst_enc = lambda p. p (lambda x,y. x) \n\
#let snd_enc = lambda p. p (lambda x,y. y) \n\
 \n\
// fix \n\
#let fix_z = lambda f. (lambda x. f (lambda v. x x v)) (lambda x. f (lambda v. x x v)) \n\
 \n\
 \n\
 \n\
// ***************************************** \n\
// ******* Meta-Circular Interpreter ******* \n\
// ***************************************** \n\
 \n\
#let fail = lambda _. true + 1 \n\
#let force = lambda f. f false \n\
 \n\
// AST encoders \n\
#let var_enc = bonus \n\
#let lam_enc = bonus \n\
#let app_enc = bonus \n\
 \n\
#let subst = fun rec subst with i, e, c =  \n\
    bonus \n\
in subst \n\
 \n\
#let eval = fun rec eval with e =  \n\
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
                (lambda _,_. force fail)) in eval \n\
"
