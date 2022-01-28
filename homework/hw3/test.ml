open Ast
open Eval

(* Unit test utilities *)

let texpr = Alcotest.testable (fun ppf -> fun e -> Fmt.pf ppf "%s" (string_of_expr e)) (=) ;;

(* Helper function to parse an expression *)
let parse (s: string) : Ast.expr =
  Parser.main Scanner.token (Lexing.from_string s)

(* Helper function to check evaluation of an expression *)
let check_eval e expected () =
  let v =
    try eval e with
    | Stuck msg -> failwith ("Got stuck!\n" ^ msg)
  in
    Alcotest.(check' texpr) ~msg:"eval" ~expected:expected ~actual:v

(* Helper function to check evaluation of an expression (given a string of the expression) *)
let check_eval_s s expected () =
  check_eval (parse s) expected ()

(* Helper function to check that evaluation gets stuck *)
let check_stuck s () =
  try
    let v = eval (parse s) in
    Alcotest.fail ("evaluated to " ^ string_of_expr v)
  with
  | Stuck _ -> ()
;;

let open Alcotest in
(* Test that an expression (as a string) evaluates to the expected expression *)
let test_e s exp = test_case s `Quick (check_eval_s s exp) in
(* Test that an expression gets stuck *)
let test_stuck s = test_case s `Quick (check_stuck s) in
(* Test suite *)
run "lambda-plus" [
  "eval", [
    test_e "5" (NumLit(5)) ;
  ];
  "stuck", [
    test_stuck "1 > Nil" ;
  ]
]
