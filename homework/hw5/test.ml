open Ast
open Eval

(* Unit test utilities *)
let tty = Alcotest.testable (fun ppf -> fun t -> Fmt.string ppf (string_of_typ t)) (=) ;;
let ttyi = Alcotest.testable (fun ppf -> fun t -> Fmt.string ppf (Typeinfer.string_of_ityp t)) (=) ;;

(** Helper function to parse an expression *)
let parse (s: string) : Ast.expr =
  Parser.main Scanner.token (Lexing.from_string s)
;;

let normalize_ityp _t =
  let module M = Map.Make (Int) in
  let open Typeinfer in
  let rec go m t = match t with
    | IInt -> (IInt, m)
    | IVar n -> begin match M.find_opt n m with
        | Some n' -> (IVar n', m)
        | None -> let n' = M.cardinal m in (IVar n', M.add n n' m)
      end
    | IList t ->
      let (t', m') = go m t in
      (IList t', m')
    | IFun (t1, t2) ->
      let (t1', m') = go m t1 in
      let (t2', m'') = go m' t2 in
      (IFun (t1', t2'), m'')
  in
  let (_t', _) = go M.empty _t in
  _t'

(** Helper function to check that the type inference algorithm assigns type t to e *)
let check_tyinf s t () =
  let e = parse s in
  let (tact, _) =
    try Typeinfer.type_infer e with
    | Typecheck.Type_error msg -> Alcotest.fail ("Type error!\n" ^ msg)
  in
  Alcotest.(check' ttyi) ~msg:"typecheck" ~expected:t ~actual:(normalize_ityp tact)

(** Helper function to check that the type inference algorithm assigns type t to e *)
let check_tyinf_b s () =
  let e = parse s in
  try
    let (t, _) = Typeinfer.type_infer e in
    Alcotest.fail ("inferred type " ^ Typeinfer.string_of_ityp t)
  with
  | Typecheck.Type_error _ -> Alcotest.(check pass) "type_error" () ()

(** Helper function to check that the given constraints can be unified *)
let check_unify cons exp ~fail () =
  try
    let open Typeinfer in
    let sub = Sub.bindings (Typeinfer.unify cons) in
    let pp_sub (i, t) = Format.sprintf "%d => %s\n%!" i (string_of_ityp t) in
    if fail
    then Alcotest.fail ("unified to " ^ (String.concat "\n" (List.map pp_sub sub)))
    else Alcotest.(check' (list (pair int ttyi))) ~msg:"unify" ~expected:exp ~actual:sub
  with
  | Typecheck.Type_error msg ->
    if fail
    then Alcotest.(check pass) "unify_fail" () ()
    else failwith ("Type error!\n" ^ msg)

let main () =
  let open Alcotest in
  let open Typeinfer in
  (* Test inferred type of expression *)
  let test_tinf_t s exp = test_case s `Quick (check_tyinf s exp) in
  (* Test that an expression is ill-typed (using type inference) *)
  let test_tinf_b s = test_case s `Quick (check_tyinf_b s) in
  (* Test unify finds a solution *)
  let test_unify s c exp = test_case s `Quick (check_unify c exp ~fail:false) in
  (* Test unify fails *)
  let test_unify_f s c = test_case s `Quick (check_unify c [] ~fail:true) in
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
      (* You can also use the DSL in Typeinfer: *)
      begin
        let open Typeinfer.Dsl in
        test_unify "example2"
          (* X0 = Int -> Int,
             X1 = List[X0] *)
          [v 0, i => i; v 1, l (v 0)]
          (* X0 => Int -> Int,
             X1 => List[Int -> Int] *)
          [0, i => i; 1, l (i => i)]
      end
    ];
    "infer_good", [
      test_tinf_t "(lambda x. x + 1)" (IFun (IInt, IInt)) ;
      test_tinf_t "1 @ Nil" (IList IInt) ;

      (* You *must* return "free" type variables that naturally result as output
         of type inference. The normalize_ityp function in this file will be
         used to renumber the output of your type inference. *)
      test_tinf_t "lambda x. !x @ x" (IFun (IList (IVar 0), IList (IVar 0))) ;
    ];
    "infer_bad", [
      test_tinf_b "1 + Nil" ;
    ];
  ]
;;

main ()
