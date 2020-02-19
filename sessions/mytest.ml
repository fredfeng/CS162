(*

   lambda calculus interpreter

 *)

#use "exp.ml";;
#use "lexer.ml";;
#use "parser.ml";;
#use "eval.ml";;   

let clear () = Sys.command "clear";;

(* sample code for testing the evaluate function *)
let my_input = App( Lam("x", Lam("y", Var "x" ) ), Var "y" );;
let my_output = Lam("v0", Var "y");;
let my_eval = evaluate my_input;;
print_string (lambda_exp_2_str my_output);;
print_string "\n";;
print_string (lambda_exp_2_str my_eval);;
print_string "\n";;




