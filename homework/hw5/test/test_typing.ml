open Base
open Lamp
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
let texpr = Alcotest.testable Pretty.expr equal_expr
let tvars = Alcotest.testable Vars.pp Vars.equal
let tty = Alcotest.testable Pretty.ty equal_ty

let parse s =
  try Parser.Expr.parse_string s
  with _ -> Alcotest.fail ("Failed to parse: " ^ s)

let parse_file filename =
  try Parser.Expr.parse_file filename
  with _ -> Alcotest.fail ("Failed to parse file: " ^ filename)

let parse_ty s =
  try Parser.Ty.parse_string s
  with _ -> Alcotest.fail ("Failed to parse: " ^ s)

(** Helper function to check that [e] is inferred to have type [expected] 
  * under [gamma]. The [p] flag enables let-polymorphism. *)
let check_well_typed ~gamma (e : expr) (expected : ty) () =
  let actual =
    try with_timeout 1 (fun () -> Typeinfer.infer_with_gamma ~gamma e)
    with Typeinfer.Type_error msg -> failwith ("Type error!\n" ^ msg)
  in
  Alcotest.(check' tty)
    ~msg:(Fmt.str "%a" Pretty.expr e)
    ~expected:(Typeinfer.Utils.normalize expected)
    ~actual:(Typeinfer.Utils.normalize actual)

(** Helper function to check that [e_str] (concrete syntax) is inferred 
  * to have type [expected]  under [gamma]. The [p] flag enables 
  * let-polymorphism. *)
let check_well_typed_s ~gamma (e_str : string) (expected_str : string) () =
  check_well_typed ~gamma (parse e_str) (parse_ty expected_str) ()

let check_well_typed_file ~gamma filename t () =
  check_well_typed ~gamma (parse_file filename) t ()

(** Helper function to check that type inference determines that [e] is ill-typed *)
let check_ill_typed ~gamma (e : expr) () =
  try
    let t = with_timeout 1 (fun () -> Typeinfer.infer_with_gamma ~gamma e) in
    Alcotest.fail Fmt.(str "inferred %a" Pretty.ty t)
  with Typeinfer.Type_error _ -> ()

(** Helper function to check that type inference determines that [e_str]
    (concrete syntax) is ill-typed. *)
let check_ill_typed_s ~gamma (e_str : string) () =
  check_ill_typed ~gamma (parse e_str) ()

let well_typed_tests =
  let t = check_well_typed_s ~gamma:[] in
  [
    check_well_typed_s (* typing environment *)
      ~gamma:[] (* input expression *) "0" (* expected inferred type *) "Int";
    t "lambda x. x" "'a -> 'a";
  ]

let ill_typed_tests = [ check_ill_typed_s ~gamma:[] "true+1" ]
let tests = [ ("well_typed", well_typed_tests); ("ill_typed", ill_typed_tests) ]
