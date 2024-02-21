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
let tty = Alcotest.testable Pretty.pp_ty Typecheck.equal_ty

let parse s =
  try Parse_util.parse s with _ -> Alcotest.fail ("Failed to parse: " ^ s)

let parse_file filename =
  try Parse_util.parse_file filename
  with _ -> Alcotest.fail ("Failed to parse file: " ^ filename)

let parse_ty s =
  try Parse_util.parse_ty s with _ -> Alcotest.fail ("Failed to parse: " ^ s)

let check_equal_ty t1 t2 expected () =
  Alcotest.(check' bool)
    ~msg:"equal types" ~expected
    ~actual:(Typecheck.equal_ty (parse_ty t1) (parse_ty t2))

(** Helper function to check that the type checker abstractly evaluates 
  * the expression to type t *)
let check_well_typed ~gamma e t () =
  let tact =
    try Typecheck.abstract_eval gamma e
    with Typecheck.Type_error msg -> failwith ("Type error!\n" ^ msg)
  in
  Alcotest.(check' tty)
    ~msg:(Fmt.str "%a" Pretty.pp_expr e)
    ~expected:t ~actual:tact

(** Helper function to check that the type checker abstractly evaluates 
  * the expression (given as a string) to type t *)
let check_well_typed_s ~gamma s t () =
  check_well_typed
    ~gamma:(List.map gamma ~f:(fun (x, t) -> (x, parse_ty t)))
    (parse s) (parse_ty t) ()

let check_well_typed_file ~gamma s t () =
  check_well_typed ~gamma (parse_file s) (parse_ty t) ()

(** Helper function to check that the type checker determines that the expression is
    ill-typed. *)
let check_ill_typed ~gamma s () =
  try
    let t = Typecheck.abstract_eval gamma (parse s) in
    Alcotest.fail ("abstractly evaluated to " ^ show_ty t)
  with Typecheck.Type_error _ -> ()

let equal_ty_tests = [ check_equal_ty "Int" "Int" (* expected output *) true ]

let well_typed_tests =
  [
    check_well_typed_s ~gamma:[] (* input expression *) "0"
      (* expected output type *) "Int";
    check_well_typed_s
      ~gamma:[ ("x", "Int") ]
      (* input expression *) "x" (* expected output type *) "Int";
  ]

let ill_typed_tests =
  [ check_ill_typed ~gamma:[] (* input expression *) "true+1" ]

let tests =
  [
    ("equal_ty", equal_ty_tests);
    ("well_typed", well_typed_tests);
    ("ill_typed", ill_typed_tests);
  ]
