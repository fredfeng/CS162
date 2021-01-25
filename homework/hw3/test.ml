open Ast
open Eval

(* Unit test utilities *)

let texpr = Alcotest.testable (fun ppf -> fun e -> Fmt.pf ppf "%s" (string_of_expr e)) (=) ;;

(** Helper function to parse an expression *)
let parse (s: string) : Ast.expr =
  Parser.main Scanner.token (Lexing.from_string s)
;;

(** Helper function to check evaluation of an expression *)
let check_eval env e expected () =
  let v =
    try eval e env with
    | Stuck msg -> failwith ("Got stuck!\n" ^ msg)
  in
    Alcotest.(check' texpr) ~msg:"eval" ~expected:expected ~actual:v

(** Helper function to check evaluation of an expression (given a string of the expression) *)
let check_eval_s env s expected () =
  check_eval env (parse s) expected ()
;;

(** Helper function to check that evaluation gets stuck *)
let check_stuck env s () =
  try
    let v = eval (parse s) env in
    Alcotest.fail ("evaluated to " ^ string_of_expr v)
  with
  | Stuck _ -> ()

let main () =
  let open Alcotest in
  (* Test that an expression (as a string) evaluates to the expected expression *)
  let test_e s exp = test_case s `Quick (check_eval_s Env.empty s exp) in
  (* Test that an expression gets stuck *)
  let test_stuck s = test_case s `Quick (check_stuck Env.empty s) in
  (* Test suite *)
  run "lambda-plus" [
    "eval", [
      test_e "5" (NumLit(5)) ;
    ];
    "stuck", [
      test_stuck "x" ;
    ]
  ]
;;

main ()
