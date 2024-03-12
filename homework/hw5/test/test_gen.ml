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

let normalize_cons (t1, t2) : cons =
  if compare_ty t1 t2 < 0 then (t1, t2) else (t2, t1)

let normalize_cs (cs : cons list) : cons list =
  cs |> List.map ~f:normalize_cons |> List.sort ~compare:compare_cons

(* Unit test utilities *)
let tcs = Alcotest.testable Fmt.(vbox (list pp_cons)) (List.equal equal_cons)

(** Construct a dummy [Infer] module to expose the constraints *)
let gen ~(gamma : gamma) (e : expr) : cons list =
  let module I = Infer (struct
    let polymorphic = false
  end) in
  let _ = I.abstract_eval gamma e in
  I.curr_cons_list ()

(** Helper function to check that solving the input constraints [cs] indeed
  * yields the expected solution [sigma]. *)
let check_gen ~(gamma : gamma) (e_str : string) ~(cs : cons list) () =
  let parse s =
    try Parse_util.parse s with _ -> Alcotest.fail ("Failed to parse: " ^ s)
  in
  let actual =
    try with_timeout 1 (fun () -> gen ~gamma (parse e_str))
    with Typeinfer.Type_error msg -> failwith ("Type error!\n" ^ msg)
  in
  Alcotest.(check' tcs)
    ~msg:Fmt.(str "%s" e_str)
    ~expected:(normalize_cs cs) ~actual:(normalize_cs actual)

let gen_tests =
  let ( == ) t1 t2 = (t1, t2) in
  let open DSL in
  [
    check_gen (* input gamma *)
      ~gamma:[ ("x", mono ??"X"); ("y", mono ??"Y") ]
      (* input expression *)
      "if 1 then x else y" (* expected constraints *)
      ~cs:[ bool == int; ??"X" == ??"Y" ];
    (* The order of the expected constraints doesn't matter, and
        you can freely swap the two sides of a constraint.
        So the following is equivalent:
       ~cs:[ ??"Y" == ??"X"; int == bool ]

       But multiplicities matter, so this is not equivalent:
        ~cs:[ ??"X" == ??"Y"; int == bool; int == bool ]
    *)
  ]

let tests = [ ("gen", gen_tests) ]
