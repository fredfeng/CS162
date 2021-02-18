open Ast
open Eval

(* Unit test utilities *)
let tty = Alcotest.testable (fun ppf -> fun t -> Fmt.string ppf (string_of_typ t)) (=) ;;
let ttyi = Alcotest.testable (fun ppf -> fun t -> Fmt.string ppf (Typeinfer.string_of_ityp t)) (=) ;;

(** Helper function to parse an expression *)
let parse (s: string) : Ast.expr =
  Parser.main Scanner.token (Lexing.from_string s)
;;

(** Helper function to check that the type inference algorithm assigns type t to e *)
let check_tyinf s t () =
  let e = parse s in
  let (tact, _) =
    try Typeinfer.type_infer e with
    | Typecheck.Type_error msg -> Alcotest.fail ("Type error!\n" ^ msg)
  in
  Alcotest.(check' ttyi) ~msg:"typecheck" ~expected:t ~actual:tact

(** Helper function to check that the type inference algorithm assigns type t to e *)
let check_tyinf_b s () =
  let e = parse s in
  try
    let (t, _) = Typeinfer.type_infer e in
    Alcotest.fail ("inferred type " ^ Typeinfer.string_of_ityp t)
  with
  | Typecheck.Type_error _ -> Alcotest.(check pass) "type_error" () ()

(** Helper function to check that unify finds the given solution *)
let check_unify msg cons sub_exp () =
  let actual = Typeinfer.unify cons in
  Alcotest.(check' (list (pair int ttyi))) ~msg:msg
    ~expected:sub_exp
    ~actual:(Typeinfer.Sub.bindings actual)

let main () =
  let open Alcotest in
  let open Typeinfer in
  (* Test inferred type of expression *)
  let test_tinf_t s exp = test_case s `Quick (check_tyinf s exp) in
  (* Test that an expression is ill-typed (using type inference) *)
  let test_tinf_b s = test_case s `Quick (check_tyinf_b s) in
  (* Test unify finds a solution *)
  let test_unify m cons exp = test_case m `Quick (check_unify m cons exp) in
  (* Test suite *)
  run "lambda-plus" [
    (* unification finds a solution *)
    "unify_good", [
      (* Note: you should try to finish unify *before* you write test cases,
         because the variables in the solution might change *)
      test_unify "example1"
        (* X0 = Int
           X1 = List[X0] *)
        [
          IVar 0, IInt;
          IVar 1, IList (IVar 0);
        ]
        (* X0 => Int
           X1 => List[Int] *)
        [
          0, IInt;
          1, IList IInt;
        ];
    ];
    "infer_good", [
      test_tinf_t "(lambda x. x + 1)" (IFun (IInt, IInt)) ;
      test_tinf_t "1 @ Nil" (IList IInt) ;
    ];
    "infer_bad", [
      test_tinf_b "1 + Nil" ;
    ];
  ]
;;

main ()
