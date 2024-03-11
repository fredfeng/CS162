open Base
open Ast
open Typeinfer

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
let tsigma =
  Alcotest.testable pp_sigma (fun s1 s2 ->
      let sort = List.sort ~compare:[%derive.ord: string * ty] in
      let s1' = sort s1 in
      let s2' = sort s2 in
      equal_sigma s1' s2')

(** Construct a dummy [Infer] module to expose its [solve] function *)
let solve : cons list -> sigma =
  let module I = Infer (struct
    let polymorphic = false
  end) in
  I.solve

(** Helper function to check that solving the input constraints [cs] indeed
  * yields the expected solution [sigma]. *)
let check_solution ~(cs : cons list) ~(sigma : sigma) () =
  let actual =
    try with_timeout 1 (fun () -> solve cs)
    with Typeinfer.Type_error msg -> failwith ("Type error!\n" ^ msg)
  in
  Alcotest.(check' tsigma)
    ~msg:Fmt.(str "%a" (list ~sep:comma pp_cons) cs)
    ~expected:sigma ~actual

(** Helper function to check that the [solve] deems the input constraints [cs]
  * unsolvable. *)
let check_unsolvable (cs : cons list) () =
  try
    let sigma = with_timeout 1 (fun () -> solve cs) in
    Alcotest.failf "Expected unsolvable, but got %a" pp_sigma sigma
  with Typeinfer.Type_error _ ->
    Alcotest.(check pass) Fmt.(str "%a" (list ~sep:comma pp_cons) cs) () ()

let solvable_tests =
  [
    check_solution
      ~cs:[ (TVar "X", TVar "Y"); (TVar "Y", TBool) ]
      ~sigma:[ ("X", TBool); ("Y", TBool) ];
  ]

let unsolvable_tests = [ check_unsolvable [ (TInt, TBool) ] ]
let tests = [ ("solvable", solvable_tests); ("unsolvable", unsolvable_tests) ]
