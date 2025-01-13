open Base
open Hw1.Part4

module Expr = struct
  type t = [%import: Hw1.Part4.expr] [@@deriving show, eq]
end

module Poly = struct
  type t = [%import: Hw1.Part4.poly] [@@deriving show, eq]
end

(** Wrapper functions for constructing ASTs. 
    You can either use plain constructors to build an AST, or
    call the functions in this module. *)
module DSL = struct
  (** Build a constant AST node *)
  let const (n : int) : expr = Const n

  (** Build a variable AST node *)
  let x : expr = X

  (** Build an addition AST node with a left AST and a right AST *)
  let add (e1 : expr) (e2 : expr) : expr = Add (e1, e2)

  (** Build a multiplication AST node with a left AST and a right AST *)
  let mul (e1 : expr) (e2 : expr) : expr = Mul (e1, e2)

  (** Build a composition AST node with a left AST and a right AST *)
  let comp (e1 : expr) (e2 : expr) : expr = Compose (e1, e2)
end

let test_eval_expr =
  Utils.test_io Alcotest.(int) "same int" (Utils.uncurry eval_expr)

let test_simplify =
  Utils.test_io Alcotest.(testable Expr.pp Expr.equal) "same expr" simplify

let test_eval_poly =
  Utils.test_io Alcotest.(int) "same int" (Utils.uncurry eval_poly)

let test_normalize = Utils.test_io Alcotest.(list int) "same list" normalize

let test_semantic_equiv =
  Utils.test_io Alcotest.bool "same bool" (Utils.uncurry semantic_equiv)

let eval_expr_tests =
  [ ((3, DSL.(comp (add (const 1) (mul (const 2) x)) (add x (const 5)))), 12) ]

let simplify_tests =
  [ DSL.(add x (add x (mul (const 1) (add (const 0) x))), add x (add x x)) ]

let eval_poly_tests = [ ((3, [ 6; 7; 3 ]), 54) ]

let normalize_tests =
  [
    ( DSL.(
        add (const 4) (mul (add x (const 2)) (add (mul (const 3) x) (const 1)))),
      [ 6; 7; 3 ] );
  ]

let semantic_equiv_tests =
  [
    ( DSL.
        ( add (const 4) (mul (add x (const 2)) (add (mul (const 3) x) (const 1))),
          add (const 6) (add (mul (const 7) x) (mul (const 3) (mul x x))) ),
      true );
  ]

let tests =
  [
    ("eval_expr", List.map ~f:test_eval_expr eval_expr_tests);
    ("simplify", List.map ~f:test_simplify simplify_tests);
    ("eval_poly", List.map ~f:test_eval_poly eval_poly_tests);
    ("normalize", List.map ~f:test_normalize normalize_tests);
    ("semantic_equiv", List.map ~f:test_semantic_equiv semantic_equiv_tests);
  ]
