open Base
open Ast

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
let texpr = Alcotest.testable Pretty.pp_expr equal_expr
let tvars = Alcotest.testable Vars.pp Vars.equal
let tty = Alcotest.testable Pretty.pp_ty equal_ty

let parse s =
  try Parse_util.parse s with _ -> Alcotest.fail ("Failed to parse: " ^ s)

let parse_file filename =
  try Parse_util.parse_file filename
  with _ -> Alcotest.fail ("Failed to parse file: " ^ filename)

let parse_ty s =
  try Parse_util.parse_ty s with _ -> Alcotest.fail ("Failed to parse: " ^ s)

(** Helper function to check that [e] is inferred to have type [expected] 
  * under [gamma]. The [p] flag enables let-polymorphism. *)
let check_well_typed ~(p : bool) ~gamma (e : expr) (expected : ty) () =
  let actual =
    try with_timeout 1 (fun () -> Typeinfer.infer_with_gamma ~gamma ~p e)
    with Typeinfer.Type_error msg -> failwith ("Type error!\n" ^ msg)
  in
  Alcotest.(check' tty)
    ~msg:(Fmt.str "%a" Pretty.pp_expr e)
    ~expected:(Typeinfer.Utils.normalize expected)
    ~actual:(Typeinfer.Utils.normalize actual)

(** Helper function to check that [e_str] (concrete syntax) is inferred 
  * to have type [expected]  under [gamma]. The [p] flag enables 
  * let-polymorphism. *)
let check_well_typed_s ~gamma ~(p : bool) (e_str : string)
    (expected_str : string) () =
  check_well_typed ~gamma ~p (parse e_str) (parse_ty expected_str) ()

let check_well_typed_file ~gamma filename t () =
  check_well_typed ~gamma (parse_file filename) t ()

(** Helper function to check that type inference determines that [e] is
    ill-typed. The [p] flag enables let-polymorphism. *)
let check_ill_typed ~gamma ~(p : bool) (e : expr) () =
  try
    let t = with_timeout 1 (fun () -> Typeinfer.infer_with_gamma ~gamma ~p e) in
    Alcotest.fail Fmt.(str "inferred %a" Pretty.pp_ty t)
  with Typeinfer.Type_error _ -> ()

(** Helper function to check that type inference determines that [e_str]
    (concrete syntax) is ill-typed. The [p] flag enables let-polymorphism. *)
let check_ill_typed_s ~gamma ~(p : bool) (e_str : string) () =
  check_ill_typed ~gamma ~p (parse e_str) ()

let well_typed_tests =
  [
    check_well_typed_s (* do not turn on let-polymorphism *)
      ~p:false (* typing environment *)
      ~gamma:[] (* input expression *) "0" (* expected inferred type *) "Int";
    check_well_typed_s ~p:false ~gamma:[] "lambda x. x" "'a -> 'a";
    check_well_typed_s (* turn on let-polymorphism *)
      ~p:true ~gamma:[] "let id = lambda x. x in {id false, {id 0, id id}}"
      "Bool * (Int * ('a -> 'a))";
  ]

let ill_typed_tests = [ check_ill_typed_s ~p:false ~gamma:[] "true+1" ]
let tests = [ ("well_typed", well_typed_tests); ("ill_typed", ill_typed_tests) ]
