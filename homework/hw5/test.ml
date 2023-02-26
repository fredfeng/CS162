open Ast
open Eval

(* Unit test utilities *)
let tty = Alcotest.testable (fun ppf -> fun t -> Fmt.string ppf (string_of_typ t)) (=) 

(** Helper function to parse an expression *)
let parse (s: string) : Ast.expr =
  Parser.main Scanner.token (Lexing.from_string s)


(** Helper function to check that the type checker assigns type t to e *)
let check_ty env e t () =
  let tact =
    try Typecheck.typecheck env e with
    | Typecheck.Type_error msg -> failwith ("Type error!\n" ^ msg)
  in
  Alcotest.(check' tty) ~msg:"typecheck" ~expected:t ~actual:tact

(** Helper function to check that the type checker assigns type t to the expression
    (given as a string) *)
let check_ty_s env s t () =
  check_ty env (parse s) t ()


(** Helper function to check that the type checker determines that the expression is
    ill-typed. *)
let check_ty_b env s () =
  try
    let t = Typecheck.typecheck env (parse s) in
    Alcotest.fail ("type checked to " ^ string_of_typ t)
  with
  | Typecheck.Type_error _ -> ()
;;

let open Alcotest in
(* Test that an expression has the expected type *)
let test_ty_t s exp = test_case s `Quick (check_ty_s Typecheck.Env.empty s exp) in
(* Test that an expression is ill-typed *)
let test_ty_b s = test_case s `Quick (check_ty_b Typecheck.Env.empty s) in
(* Test suite *)
run "lambda-plus" [
  "well_typed", [
    test_ty_t "5+10" TInt ;
  ];
  "ill_typed", [
    test_ty_b "1 + Nil[Int]" ;
  ]
]
