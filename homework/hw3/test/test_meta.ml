open Base
module T = Test_lamp

let get_dec x = List.Assoc.find_exn Meta.decodings x ~equal:String.equal

(* Load the encoding and decoding functions, and check
   whether an expression evaluates to expected *)
let test_encoding (e_str : string) (expected : string) () =
  let defs = Encodings.encodings @ Meta.decodings in
  let glue =
    List.fold_right defs ~init:(T.parse e_str) ~f:(fun (x, def) e ->
        Eval.subst x def e)
  in
  Test_lamp.test_eval glue (T.parse expected) ()

(* Test the meta-circular interpreter *)
let test_meta (e_str : string) (expected : string) () =
  Test_lamp.test_eval_with ~f:Meta.eval (T.parse e_str)
    (expected |> T.parse |> Meta.finalize)
    ()

(* Test the meta-circular interpreter and decode the result before comparing it with expected *)
let test_meta_with_decoder (e_str : string) (expected : string) ~decoder () =
  let glue e =
    List.fold_right Meta.decodings ~init:e ~f:(fun (x, def) e ->
        Eval.subst x def e)
  in
  Test_lamp.test_eval_with
    ~f:(fun e -> Eval.eval (glue (Ast.App (T.parse decoder, Meta.eval e))))
    (T.parse e_str) (T.parse expected) ()

let nat_tests =
  [
    test_encoding "dec_nat (succ (succ zero))" "2";
    test_encoding "dec_nat (add (succ zero) (succ zero))" "2";
    test_encoding "dec_bool (leq (succ zero) (succ zero))" "true";
  ]

let list_tests =
  [
    test_encoding "dec_list (cons 1 (cons 2 nil))" "1::2::Nil";
    test_encoding "dec_nat (length (cons 1 (cons 2 nil)))" "2";
  ]

let tree_tests =
  [
    test_encoding "dec_tree (node 1 (node 2 leaf leaf) (node 3 leaf leaf))"
      "1::((2::(Nil::Nil))::(3::(Nil::Nil)))";
    test_encoding
      "dec_nat (size (node 1 (node 2 leaf leaf) (node 3 leaf leaf)))" "7";
  ]

let meta_tests =
  [
    test_meta
      (* input *)
      "let tt = lambda x,y.x in let ff = lambda x,y.y in let not = lambda b. b \
       ff tt in not tt"
      (* output, which should be the encoding of false *)
      "lambda x,y.y";
    test_meta_with_decoder (* input *)
      "let not = lambda b. if b then false else true in not true"
      (* output, which should be false since this test function performs decoding *)
      "false" ~decoder:"dec_bool";
    test_meta_with_decoder ~decoder:"dec_nat" (* input *) "2*3"
      (* output, which should be the encoding of 6 *)
      "6";
  ]

let tests =
  [
    (* ("nat_encoding", nat_tests);
       ("list_encoding", list_tests);
       ("tree_encoding", tree_tests); *)
    ("meta_encoding", meta_tests);
  ]
