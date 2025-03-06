open Base
open Ast
open Typeinfer

exception Timeout

let get_var_name i = "_" ^ Int.to_string i

let _normalize t =
  let rename = ref (Map.empty (module String)) in
  let mem x = Map.mem !rename x in
  let get x = TVar (Map.find_exn !rename x) in
  let set x t = rename := Map.add_exn !rename ~key:x ~data:t in
  let counter = ref 0 in
  let next () =
    counter := !counter - 1;
    get_var_name !counter
  in
  let rec helper = function
    | TVar x ->
        if mem x then get x
        else
          let y = next () in
          set x y;
          get x
    | TInt -> TInt
    | TBool -> TBool
    | TFun (t1, t2) -> TFun (helper t1, helper t2)
    | TList t -> TList (helper t)
    | TProd (t1, t2) -> TProd (helper t1, helper t2)
  in
  let t' = helper t in
  (t', !rename)

let normalize t = fst (_normalize t)

let normalize_pty = function
  | Mono t -> Mono (normalize t)
  | Scheme (xs, t) ->
      let t', rename = _normalize t in
      let xs' =
        xs |> Vars.to_list
        |> List.map ~f:(fun x -> Map.find_exn rename x)
        |> Vars.of_list
      in
      Scheme (xs', t')

exception DoesNotRefine

(** t1 refines t2 if there's a substitution from t2 to t1 *)
let refines t1 t2 =
  let t1 = normalize t1 in
  let t2 = normalize t2 in
  let refinement = ref (Map.empty (module String)) in

  let rec helper t1 t2 =
    (* Fmt.epr "helper\n%! %a <= %a\n%!" Pretty.pp_ty t1 Pretty.pp_ty t2; *)
    match (t1, t2) with
    | _, TVar x -> (
        match Map.find !refinement x with
        | None -> refinement := Map.add_exn !refinement ~key:x ~data:t1
        | Some t1' -> if not (equal_ty t1 t1') then raise DoesNotRefine else ())
    | TInt, TInt -> ()
    | TBool, TBool -> ()
    | TFun (t1, t2), TFun (t1', t2') ->
        helper t1 t1';
        helper t2 t2'
    | TList t1, TList t2 -> helper t1 t2
    | TProd (t1, t2), TProd (t1', t2') ->
        helper t1 t1';
        helper t2 t2'
    | _ -> raise DoesNotRefine
  in
  try
    let () = helper t1 t2 in
    true
  with DoesNotRefine -> false

(* Unit test utilities *)
let texpr = Alcotest.testable Pretty.pp_expr equal_expr
let tvars = Alcotest.testable Vars.pp Vars.equal
let tty = Alcotest.testable Pretty.pp_ty equal_ty

let tpty =
  Alcotest.testable pp_pty (fun p1 p2 ->
      equal_pty (normalize_pty p1) (normalize_pty p2))

let tsigma =
  Alcotest.testable pp_sigma (fun s1 s2 ->
      let sort = List.sort ~compare:(fun (x, _) (y, _) -> String.compare x y) in
      let s1' = sort s1 in
      let s2' = sort s2 in
      equal_sigma s1' s2')

let generalize gamma t =
  let module I = Infer (struct
    let polymorphic = true
  end) in
  I.generalize gamma t

let solve : cons list -> sigma =
  let module I = Infer (struct
    let polymorphic = false
  end) in
  I.solve

let parse s =
  try Parse_util.parse s with _ -> Alcotest.fail ("Failed to parse: " ^ s)

let parse_file filename =
  try Parse_util.parse_file filename
  with _ -> Alcotest.fail ("Failed to parse file: " ^ filename)

let parse_ty s =
  try Parse_util.parse_ty s with _ -> Alcotest.fail ("Failed to parse: " ^ s)

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
