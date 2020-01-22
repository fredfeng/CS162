(*

   lambda calculus interpreter

 *)

#use "exp.ml";;
#use "lexer.ml";;
#use "parser.ml";;
#use "eval.ml";;    

let clear () = Sys.command "clear";;


let lex x = 
	let y = x ^ "\n" in 
		Lexing.from_string y
;;


let parse x  = main token (lex  x);;


let rec to_int e = match e with
    App(x,y)-> 1 + (to_int x) + (to_int y)
   |Lam(a,b)->to_int b
   |_->0
              
;;             


let r = parse  "Lx.x y";;
print_string "string: Lx.x y";;
print_string "\nLambda Expression: ";;
print_string (lambda_exp_2_str r);;
print_string "\nparsed string: ";;
print_lambda r;;
print_string "\n";;

  
let myzero = parse "Lf.Lx.x";;
let myone = parse "Lf. Lx. f x";;
let mytwo = parse "Lf. Lx. f (f x)";;
let mythree = parse "Lf. Lx. f (f (f x))";;
let mysucc = parse "Ln. Lf. Lx. f (n f x)";;
let myplus = parse "Lm. Ln. Lf. Lx. m f (n f x)";;
let mymult = parse "Lm. Ln. Lf. m (n f)";;


let mytrue  = parse "Lx. Ly. x";;
let myfalse = parse "Lx.Ly. y";;
let myif = parse "La. Lb. Lc. a b c";;
let mynot  = parse "Lb. Lx. Ly.  b y x"
let myand = parse "La. Lb.parse Lx. Ly. b (a x y) y";;
let myor = parse "La. Lb. Lx. Ly.  b x (a x y)";;
let iszero  =parse "Ln. n (Lx. (Lx.Ly. y)) (Lx. Ly. x)"
let mypred = parse "Ln. Lf. Lx. n (Lg.  Lh.  h (g f)) (Lu.x) (Lu. u)";;
let myminus = parse "Lm. Ln. (n Ln. Lf. Lx. n (Lg.  Lh.  h (g f)) (Lu.x) (Lu. u)) m";;
  
(*
   Y = \f.(\x. f (x x)) (\x. f (x x))
  fact = \f.\n. if n = 0 then 1 else n * (f (n -1))

*)

let yfix = parse "Lf.(Lx. f (x x)) (Lx. f (x x))"

let if2 (a,b,c) = App(App(App(myif,a),b),c);;


let fact1 = 
   Lam ("f",
   Lam ("n",
    	(if2 
    	(
    	  (App (iszero, Var "n")),     (* condition *)
     	  (myone),						(* if branch *)
     	  (App (App (mymult, Var "n"), (App (Var "f", App (mypred, Var "n"))))) (* else *)
     	 )
        )
      
      ))
;;      

(* caclutate factorial of 3  *)
let e  =App(App(yfix, fact1), mythree)
;;

(* print the factorial 3 as int *)
let x = to_int (evaluate e)   (*  6 *)
;;
print_string "fact(3) = ";;
print_int x;;
print_string "\n";;


(* m = 2 + 3 *)
let m =  (App(App(myplus,mytwo),mythree));;
print_string "2+3=";;
print_int(to_int (evaluate m));;
print_string "\n";;
    
(* n = 2 * succ(n) = 2 * 6 = 12 *)
let n = App(App(mymult, mytwo), App(mysucc,m));;
let s = (evaluate n);;
print_string "2*6=";;
print_lambda s;;
print_string " = " ;;
print_int (to_int s);;
print_string "\n\n";;
