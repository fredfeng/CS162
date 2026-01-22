open Base
open Lamp
open Ast
open Eval

module Dsl = struct
  let lam x e = Lambda (x, e)
  let ( ?? ) x = Var x
  let ( ! ) n = Num n
  let ( + ) e1 e2 = Binop (Add, e1, e2)
  let ( - ) e1 e2 = Binop (Sub, e1, e2)
  let ( * ) e1 e2 = Binop (Mul, e1, e2)
  let let_ x e1 ~in_:e2 = Let (e1, (x, e2))
  let app e1 e2 = App (e1, e2)
end

(* Unit test utilities *)
let texpr = Alcotest.testable Pretty.expr equal_expr
let tvars = Alcotest.testable Vars.pp Vars.equal

let parse s =
  try Parse_util.parse s
  with _ -> Alcotest.fail (Fmt.str "parse failed for %s" s)

let parse_file filename =
  try Parse_util.parse_file filename
  with _ -> Alcotest.fail (Fmt.str "parse failed for %s" filename)

(** Test free variable function *)
let test_free_vars ((e, expected) : expr * string list) () =
  Alcotest.(check' tvars)
    ~msg:"same set" ~expected:(Vars.of_list expected) ~actual:(free_vars e)

(** Test free variable function with concrete syntax input *)
let test_free_vars_s ((e_str, expected) : string * string list) () =
  test_free_vars (parse e_str, expected) ()

(** Test substitution c[ x |-> e ] = expected *)
let test_subst (x, e, c, expected) () =
  let c' =
    try subst x e c with Stuck msg -> failwith ("Got stuck!\n" ^ msg)
  in
  Alcotest.(check' texpr) ~msg:"same expr" ~expected ~actual:c'

(** Test substitution c[ x |-> e ] = expected, with concrete syntax inputs *)
let test_subst_s (x, e, c, expected) =
  test_subst (x, parse e, parse c, parse expected)

(** Check an expression evaluate to the expected value *)
let test_eval (e, expected) () =
  let v = try eval e with Stuck msg -> failwith ("Got stuck!\n" ^ msg) in
  Alcotest.(check' texpr) ~msg:"eval" ~expected ~actual:v

(** Check a expression (concrete syntax) evaluate to the expected value (concrete syntax) *)
let test_eval_s (e_str, expected_str) =
  test_eval (parse e_str, parse expected_str)

(** Check an expression gets stuck during evaluation *)
let test_stuck (e : expr) () =
  try
    let v = eval e in
    Alcotest.fail (Fmt.str "evaluated to %a" Pretty.expr v)
  with Stuck _ -> ()

(** Check a expression (concrete syntax) gets stuck during evaluation *)
let test_stuck_s (e_str : string) = test_stuck (parse e_str)

let test_subst_multi (sigma, e, expected) () =
  let e' =
    try subst_multi sigma e with Stuck msg -> failwith ("Got stuck!\n" ^ msg)
  in
  Alcotest.(check' texpr) ~msg:"same expr" ~expected ~actual:e'

let test_subst_multi_s (sigma, e, expected) =
  test_subst_multi
    (List.map ~f:(fun (x, s) -> (x, parse s)) sigma, parse e, parse expected)

let test_alpha_equiv (e1, e2, expected) () =
  Alcotest.(check' bool)
    ~msg:"alpha equiv" ~expected ~actual:(alpha_equiv e1 e2)

let test_alpha_equiv_s (e1, e2, expected) =
  test_alpha_equiv (parse e1, parse e2, expected)

let free_vars_tests = [ ("lambda x. y", [ "y" ]) ]

let subst_tests =
  [ test_subst_s ("tmp", "1", "tmp + tmp2", (*expected *) "1 + tmp2") ]

let eval_tests =
  [
    test_eval_s ((* input *) "1+2", (* expected *) "3");
    test_eval_s
      ( "let q = lambda x. x+1 in let b = lambda x, _. x in let a = lambda \
         y,x,f. f y (y x f) in let l = lambda x. x 0 (lambda _.q) in let k = \
         lambda p. p (lambda p.p) (lambda q,d,p. a (d p)) in let j = lambda p. \
         p (lambda p.b) (lambda q,d,p.k p (d p)) in let x = lambda p. p \
         (lambda p.a b) (lambda q,d,p.j p (d p)) in let m = lambda x. x b \
         (lambda x,y.x) in let o = lambda p. p (lambda p.p) (lambda q,d,p. d \
         (m p)) in let f = lambda f,x,y. f y x in l b + l (m (a (a b))) + l (f \
         o (a (a (a (a b)))) (a (a b))) + l (k (a b) (a (a b))) + l (j (a (a \
         b)) (a (a b))) + l (f x (a (a (a (a (a b))))) (a b))",
        "15" );
  ]

let eval_stuck_tests = [ test_stuck_s (* input *) "(lambda x. x) + 1" ]

let subst_multi_tests =
  [
    test_subst_multi_s
      ([ ("x", "1"); ("y", "2") ], "x + y", (* expected *) "1 + 2");
  ]

let alpha_equiv_tests =
  [
    test_alpha_equiv_s ("lambda x. x", "lambda y. y", (* expected output *) true);
    test_alpha_equiv_s
      ("lambda x. y", "lambda y. x", (* expected output *) false);
  ]

let tests =
  [
    ("free_vars", List.map ~f:test_free_vars_s free_vars_tests);
    ("subst", subst_tests);
    ("eval", eval_tests);
    ("eval_stuck", eval_stuck_tests);
    ("subst_multi", subst_multi_tests);
    ("alpha_equiv", alpha_equiv_tests);
  ]
