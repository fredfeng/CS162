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

let test_eval_expr n e expected () =
  Alcotest.(check' int) ~msg:"same int" ~expected ~actual:(eval_expr n e)

let test_simplify_expr e expected () =
  Alcotest.(check' (testable Expr.pp Expr.equal))
    ~msg:"same expr" ~expected ~actual:(simplify e)

let test_eval_poly n p expected () =
  Alcotest.(check' int) ~msg:"same int" ~expected ~actual:(eval_poly n p)

let test_normalize e expected () =
  Alcotest.(check' (testable Poly.pp Poly.equal))
    ~msg:"same poly" ~expected ~actual:(normalize e)

let test_semantic_equiv e1 e2 expected () =
  Alcotest.(check' bool)
    ~msg:"same bool" ~expected ~actual:(semantic_equiv e1 e2)

let eval_expr_tests =
  [
    test_eval_expr 3
      DSL.(comp (add (const 1) (mul (const 2) x)) (add x (const 5)))
      12;
  ]

let simplify_tests =
  [
    test_simplify_expr
      DSL.(add x (add x (mul (const 1) (add (const 0) x))))
      DSL.(add x (add x x));
  ]

let normalize_tests =
  [
    test_normalize
      DSL.(
        add (const 4) (mul (add x (const 2)) (add (mul (const 3) x) (const 1))))
      [ 6; 7; 3 ];
  ]

let semantic_equiv_tests =
  [
    test_semantic_equiv
      DSL.(
        add (const 4) (mul (add x (const 2)) (add (mul (const 3) x) (const 1))))
      DSL.(add (const 6) (add (mul (const 7) x) (mul (const 3) (mul x x))))
      true;
  ]

let tests =
  [
    ("eval_expr", eval_expr_tests);
    ("simplify", simplify_tests);
    ("normalize", normalize_tests);
    ("semantic_equiv", semantic_equiv_tests);
  ]
