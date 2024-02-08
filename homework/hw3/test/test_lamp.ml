open Base
open Ast
open Eval

(* Unit test utilities *)
let texpr = Alcotest.testable Pretty.pp_expr equal_expr
let tvars = Alcotest.testable Vars.pp Vars.equal

let parse s =
  try Parse_util.parse s with _ -> Alcotest.fail ("Failed to parse: " ^ s)

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
let test_eval (e : expr) (expected : expr) () =
  let v = try eval e with Stuck msg -> failwith ("Got stuck!\n" ^ msg) in
  Alcotest.(check' texpr)
    ~msg:(Fmt.str "%a" Pretty.pp_expr e)
    ~expected ~actual:v

(** Check an expression evaluate to the expected value *)
let test_eval_with (e : expr) (expected : expr) ~f () =
  let v = try f e with Stuck msg -> failwith ("Got stuck!\n" ^ msg) in
  Alcotest.(check' texpr)
    ~msg:(Fmt.str "%a" Pretty.pp_expr e)
    ~expected ~actual:v

(** Check a expression (concrete syntax) evaluate to the expected value (concrete syntax) *)
let test_eval_s (e_str : string) (expected_str : string) () =
  test_eval (parse e_str) (parse expected_str) ()

let test_eval_file (filename : string) (expected_str : string) () =
  let e = Parse_util.parse_file filename in
  let expected = parse expected_str in
  test_eval e expected ()

(** Check an expression gets stuck during evaluation *)
let test_stuck (e : expr) () =
  try
    let v = eval e in
    Alcotest.fail (Fmt.str "evaluated to %a" Pretty.pp_expr v)
  with Stuck _ -> ()

(** Check a expression (concrete syntax) gets stuck during evaluation *)
let test_stuck_s (e_str : string) = test_stuck (parse e_str)

let free_vars_tests = [ test_free_vars_s "fix x is y" [ "y" ] ]

let subst_tests =
  [ test_subst_s ~x:"var" ~e:"1" ~c:"var < var" (*expected *) "1 < 1" ]

let eval_tests =
  let t = test_eval_s in
  let tf = test_eval_file in
  [
    test_eval_s (* input *) "1+2" (* expected *) "3";
    t "8+12-4*3" "8";
    t "let x = let x = 2 in x + 1 in x * 2" "6";
    t "fun f with f = f in f 2" "2";
    t "fun add with x,y = x + y in add 2 3" "5";
    t "(lambda x. (lambda f. f x) (lambda x. x *3)) 2" "6";
    t
      "(lambda f. (lambda x. f (lambda v. x x v)) (lambda x. f (lambda v. x x \
       v))) (lambda f, g, x. g x + 1) (lambda x. x*2) 3"
      "7";
    tf "examples/fib.lp" "832040";
    tf "examples/add_n.lp" "11::12::Nil";
    tf "examples/primes.lp"
      "2::3::5::7::11::13::17::19::23::29::31::37::41::43::47::53::59::61::67::71::Nil";
    tf "examples/fib_pair.lp" "832040";
    tf "examples/mutual_rec.lp" "false";
  ]

let eval_stuck_tests = [ test_stuck_s (* input *) "if 1 then 2 else 3" ]

let tests =
  [
    ("free_vars", free_vars_tests);
    ("subst", subst_tests);
    ("eval", eval_tests);
    ("eval_stuck", eval_stuck_tests);
    (* ("encoded_nat", encoded_nat_tests); *)
    (* ("encoded_list", encoded_list_tests); *)
    (* ("encoded_tree", encoded_tree_tests); *)
  ]
