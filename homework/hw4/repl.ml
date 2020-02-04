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
let t = Infer.infer e in
    Printf.printf "%s : %s\n" (Ast.to_string e) (Ast.type_to_string t);;

(printType test1);;
(printType test2);;
(printType test3);;
(printType test4);;
(printType test5);;