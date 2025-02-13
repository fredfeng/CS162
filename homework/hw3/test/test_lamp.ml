open Base
open Lamp
open Ast
open Eval

exception Timeout

(* run a function with specified timeout:
   https://discuss.ocaml.org/t/computation-with-time-constraint/5548/9 *)
let with_timeout timeout f =
  let _ =
    Stdlib.Sys.set_signal Stdlib.Sys.sigalrm
      (Stdlib.Sys.Signal_handle (fun _ -> raise Timeout))
  in
  ignore (Unix.alarm timeout);
  try
    let r = f () in
    ignore (Unix.alarm 0);
    r
  with e ->
    ignore (Unix.alarm 0);
    raise e

(* Unit test utilities *)
let texpr = Alcotest.testable Pretty.expr equal_expr
let tvars = Alcotest.testable Vars.pp Vars.equal

let parse s =
  try Parser.Expr.parse_string s
  with _ -> Alcotest.fail ("Failed to parse: " ^ s)

(** Test free variable function *)
let test_free_vars (e : expr) (expected : string list) () =
  Alcotest.(check' tvars)
    ~msg:"same set" ~expected:(Vars.of_list expected) ~actual:(free_vars e)

(** Test free variable function with concrete syntax input *)
let test_free_vars_s (e_str : string) (expected : string list) () =
  test_free_vars (parse e_str) expected ()

(** Test substitution c[ x |-> e ] = expected *)
let test_subst ~(x : string) ~(e : expr) ~(c : expr) (expected : expr) () =
  let c' =
    try subst x e c with Stuck msg -> failwith ("Got stuck!\n" ^ msg)
  in
  Alcotest.(check' texpr) ~msg:"same expr" ~expected ~actual:c'

(** Test substitution c[ x |-> e ] = expected, with concrete syntax inputs *)
let test_subst_s ~(x : string) ~(e : string) ~(c : string) (expected : string)
    () =
  test_subst ~x ~e:(parse e) ~c:(parse c) (parse expected) ()

(** Check an expression evaluate to the expected value *)
let test_eval_with (e : expr) (expected : expr) ~f () =
  try
    with_timeout 10 (fun () ->
        let v = f e in
        Alcotest.(check' texpr)
          ~msg:(Fmt.str "%a" Pretty.expr e)
          ~expected ~actual:v)
  with
  | Stuck msg -> Alcotest.fail ("Got stuck!\n" ^ msg)
  | Timeout -> Alcotest.fail "Timeout!"

(** Check an expression evaluate to the expected value *)
let test_eval = test_eval_with ~f:eval

(** Check a expression (concrete syntax) evaluate to the expected value (concrete syntax) *)
let test_eval_s (e_str : string) (expected_str : string) () =
  test_eval (parse e_str) (parse expected_str) ()

let test_eval_file (filename : string) (expected_str : string) () =
  let e = Parser.Expr.parse_file filename in
  let expected = parse expected_str in
  test_eval e expected ()

(** Check an expression gets stuck during evaluation *)
let test_stuck (e : expr) () =
  try
    let v = eval e in
    Alcotest.fail (Fmt.str "evaluated to %a" Pretty.expr v)
  with Stuck _ -> Alcotest.(check' unit) ~msg:"stuck" ~expected:() ~actual:()

(** Check a expression (concrete syntax) gets stuck during evaluation *)
let test_stuck_s (e_str : string) = test_stuck (parse e_str)

let free_vars_tests =
  let t = test_free_vars_s in
  [ t "fix x is y" [ "y" ] ]

let subst_tests =
  let t x e c = test_subst_s ~x ~e ~c in
  [ t (* arguments *) "var" "1" "var < var" (*expected *) "1 < 1" ]

let eval_tests =
  (* test an input expression evaluates to the expected output *)
  let t = test_eval_s in
  (* parse the file containing an input expression, and check that it evaluates to the expected output *)
  let tf = test_eval_file in
  [
    t (* input *) "1+2" (* expected *) "3";
    tf (* input file *) "examples/fib.lp" (* expected *) "832040";
    tf "examples/add_n.lp" "11::12::Nil";
    tf "examples/primes.lp"
      "2::3::5::7::11::13::17::19::23::29::31::37::41::43::47::53::59::61::67::71::Nil";
  ]

let eval_stuck_tests =
  let t = test_stuck_s in
  [ t (* input *) "if 1 then 2 else 3" ]

let tests =
  [
    ("free_vars", free_vars_tests);
    ("subst", subst_tests);
    ("eval", eval_tests);
    ("eval_stuck", eval_stuck_tests);
  ]
