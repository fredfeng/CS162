(*****************************
 * Main entry point *
 *****************************)

let parse (s : string) : Ast.expr =
  Parser.main Lexer.token (Lexing.from_string s)
  
let test1 = "fun x -> x";;
let test2 = "fun x -> fun y -> fun z -> x z (y z)";;
let test3 = "fun x -> fun y -> x";;
let test4 = "fun f -> fun g -> fun x -> f (g x)";;
let test5 = "fun f -> (fun x -> f x x) (fun y -> f y y)";;

let printType str =   
let e = parse str in
let t = Unify.infer e in
    Printf.printf "%s : %s\n" (Ast.to_string e) (Ast.type_to_string t);;

(printType test1);;
(printType test2);;
(printType test3);;
(printType test4);;
(printType test5);;


(*****************************
 * Sanity Checks *
 * uncomment to use *
 *****************************)
(* open Ast;;

let println_string s = 
	print_string (s^"\n")
;;

let rec println_collect ll = 
	match ll with
		[] -> println_string ""
		| (lhs,rhs)::t -> 
			begin
				print_string (type_to_string lhs);
				print_string " = ";
				print_string (type_to_string rhs);
				print_string "\n";
				println_collect t;
			end
;; *)

(*
(* ******** *)
println_string "====hello====";;
(* compile test *)
println_string "Hello World!";;
*)

(* (* ******** *)
println_string "====expr====";;
(* represent a lambda expression of type expr *)
let myexpr0 = Fun ("x", Var "x");;
println_string (to_string myexpr0);;

let myexpr1 = App (Fun ("x", Var "x"), Var "y");;
println_string (to_string myexpr1);;

let myexpr2 = App (Fun ("x", Var "x"), Fun ("y", Var "y"));;
println_string (to_string myexpr2);; *)


(* (* ******** *)
println_string "====aexpr====";;
(* represent an annotated lambda expression of type aexpr *)
let myaexpr0 = AFun (
	"x", 
	AVar ("x", TVar "a"), 
	Arrow(TVar "a", TVar "a")
);;
println_string (aexpr_to_string myaexpr0);;

let myaexpr1 = AApp (
	AFun (
		"x", 
		AVar ("x", TVar "a"), 
		Arrow (TVar "a", TVar "a")
	), 
	AVar ("y", TVar "b"), 
	TVar "c"
);;
println_string (aexpr_to_string myaexpr1);;

let myaexpr2 = AApp (
	AFun (
		"x", 
		AVar ("x", TVar "a"), 
		Arrow (TVar "a", TVar "a")
	), 
	AFun (
		"y", 
		AVar ("y", TVar "b"), 
		Arrow (TVar "b", TVar "b")
	), 
	TVar "c"
);;
println_string (aexpr_to_string myaexpr2);; *)


(* (* ******** *)
println_string "====annotate====";;
(* see how the annotate function works *)
Infer.reset_type_vars();;
let annotate_myexpr0 = Infer.annotate myexpr0;;
println_string (aexpr_to_string annotate_myexpr0);;

Infer.reset_type_vars();;
let annotate_myexpr1 = Infer.annotate myexpr1;;
println_string (aexpr_to_string annotate_myexpr1);;

Infer.reset_type_vars();;
let annotate_myexpr2 = Infer.annotate myexpr2;;
println_string (aexpr_to_string annotate_myexpr2);; *)


(* (* ******** *)
println_string "====collect====";;
(* see how the collect function works *)
let collect_myaexpr0 = Infer.collect [annotate_myexpr0] [];;
println_string "collected constraints 0:";;
println_collect collect_myaexpr0;;

let collect_myaexpr1 = Infer.collect [annotate_myexpr1] [];;
println_string "collected constraints 1:";;
println_collect collect_myaexpr1;;

let collect_myaexpr2 = Infer.collect [annotate_myexpr2] [];;
println_string "collected constraints 2:";;
println_collect collect_myaexpr2;; *)

