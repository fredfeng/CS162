open Base
open Lamp
open Ast
open Eval

module Dsl = struct
  let lam x e = Lambda (Scope (x, e))
  let v x = Var x
  let i n = Num n
  let ( + ) e1 e2 = Binop (Add, e1, e2)
  let ( - ) e1 e2 = Binop (Sub, e1, e2)
  let ( * ) e1 e2 = Binop (Mul, e1, e2)
  let let_ x e1 ~in_:e2 = Let (e1, Scope (x, e2))
  let app e1 e2 = App (e1, e2)
end

(* Unit test utilities *)
let texpr = Alcotest.testable Pretty.pp_expr equal_expr
let tvars = Alcotest.testable Vars.pp Vars.equal

let parse s =
  try Parse_util.parse s
  with _ -> Alcotest.fail (Fmt.str "parse failed for %s" s)

let parse_file filename =
  try Parse_util.parse_file filename
  with _ -> Alcotest.fail (Fmt.str "parse failed for %s" filename)

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
  Alcotest.(check' texpr) ~msg:"eval" ~expected ~actual:v

(** Check a expression (concrete syntax) evaluate to the expected value (concrete syntax) *)
let test_eval_s (e_str : string) (expected_str : string) () =
  test_eval (parse e_str) (parse expected_str) ()

(** Check an expression gets stuck during evaluation *)
let test_stuck (e : expr) () =
  try
    let v = eval e in
    Alcotest.fail (Fmt.str "evaluated to %a" Pretty.pp_expr v)
  with Stuck _ -> ()

(** Check a expression (concrete syntax) gets stuck during evaluation *)
let test_stuck_s (e_str : string) = test_stuck (parse e_str)

let free_vars_tests = [ test_free_vars_s "lambda x. y" [ "y" ] ]

let subst_tests =
  [ test_subst_s ~x:"var" ~e:"1" ~c:"var + var" (*expected *) "1 + 1" ]

let eval_tests =
  let t = test_eval_s in
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
    t
      "let q = lambda x. x+1 in let b = lambda x, _. x in let a = lambda \
       y,x,f. f y (y x f) in let l = lambda x. x 0 (lambda _.q) in let k = \
       lambda p. p (lambda p.p) (lambda q,d,p. a (d p)) in let j = lambda p. p \
       (lambda p.b) (lambda q,d,p.k p (d p)) in let x = lambda p. p (lambda \
       p.a b) (lambda q,d,p.j p (d p)) in let m = lambda x. x b (lambda x,y.x) \
       in let o = lambda p. p (lambda p.p) (lambda q,d,p. d (m p)) in let f = \
       lambda f,x,y. f y x in l b + l (m (a (a b))) + l (f o (a (a (a (a b)))) \
       (a (a b))) + l (k (a b) (a (a b))) + l (j (a (a b)) (a (a b))) + l (f x \
       (a (a (a (a (a b))))) (a b))"
      "15";
  ]

let eval_stuck_tests = [ test_stuck_s (* input *) "(lambda x. x) + 1" ]

let subst_capture_tests =
  [
    test_subst_s ~x:"x" ~e:"lambda x. y" ~c:"lambda y. y x"
      (* expected output *) "lambda y0. (y0 (lambda x. y))";
  ]

let test_church_bool (e_str : string) (expected : string) () =
  let names = [ "tt"; "ff"; "bool_to_int"; "and"; "or"; "imply"; "xor" ] in
  let fs =
    List.map
      ~f:(fun name -> (name, parse_file (Fmt.str "../lib/part4/%s.lp" name)))
      names
  in
  let e = parse e_str in
  let glued =
    List.fold_right fs ~init:e ~f:(fun (name, f) e -> Dsl.let_ name f ~in_:e)
  in
  test_eval glued (parse expected) ()

let church_bool_tests =
  [
    test_church_bool (* intput *) "bool_to_int tt" (* expected output *) "1";
    test_church_bool (* intput *) "bool_to_int ff" (* expected output *) "0";
    test_church_bool (* intput *) "bool_to_int (and tt tt)"
      (* expected output *) "1";
  ]

let test_church_option (e_str : string) (expected : string) () =
  let names = [ "none"; "some"; "option_to_int"; "join" ] in
  let fs =
    List.map
      ~f:(fun name -> (name, parse_file (Fmt.str "../lib/part4/%s.lp" name)))
      names
  in
  let e = parse e_str in
  let glued =
    List.fold_right fs ~init:e ~f:(fun (name, f) e -> Dsl.let_ name f ~in_:e)
  in
  test_eval glued (parse expected) ()

let church_option_tests =
  [
    test_church_option (* intput *) "option_to_int none"
      (* expected output *) "0";
    test_church_option "option_to_int (some 6)" "60001";
  ]

let tests =
  [
    ("free_vars", free_vars_tests);
    ("subst", subst_tests);
    ("eval", eval_tests);
    ("eval_stuck", eval_stuck_tests);
    ("subst_capture", subst_capture_tests);
    ("church_bool_tests", church_bool_tests);
    ("church_option_tests", church_option_tests);
  ]
