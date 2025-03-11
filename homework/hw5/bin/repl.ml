open Base
open Lamp
open Ast

module Opts = struct
  let path : string option ref = ref None
  let fast : bool ref = ref false
  let quiet : bool ref = ref false
  let typed : bool ref = ref false
  let tyinf : bool ref = ref true
end

let () =
  let open Parser in
  Expr.pp_exceptions ();
  Command.pp_exceptions ();
  Script.pp_exceptions ();
  Ty.pp_exceptions ()

let get_eval () e = Eval.eval e

let handler (f : unit -> unit) : unit =
  try f () with
  | Eval.Stuck msg -> Fmt.pr "runtime error: %s\n%!" msg
  | Stack_overflow ->
      Fmt.epr
        "Interpreter stack overflow; too many recursive function calls\n%!"
  | Typecheck.Type_error s -> Fmt.epr "Type error: %s\n%!" s
  | Typeinfer.Type_error s -> Fmt.epr "Type error: %s\n%!" s

let context : ((string * ty option) * expr) list ref = ref []
let meta_context : ((string * ty option) * expr) list ref = ref []
let get_context () = context

let print_context () =
  Fmt.pr ">> context >>\n%!";
  Fmt.pr " @[%a@]\n%!"
    Fmt.(
      vbox
        (list ~sep:cut
           (box
              (pair ~sep:(any " ->@ ")
                 (pair string (option (const string " : " ++ Pretty.ty)))
                 Pretty.expr))))
    (Base.List.rev !(get_context ()));
  Fmt.pr "<< context <<\n%!"

let context_expr e =
  Base.List.fold_left ~init:e
    ~f:(fun e ((x, t), def) -> Ast.Expr.lett x ~t def ~in_:e)
    !(get_context ())

let check_and_run (e : expr) : expr =
  (if !Opts.typed then
     let ty = Typecheck.abstract_eval [] e in
     Fmt.pr "type ==> @[%a@]\n%!" Pretty.ty ty
   else if !Opts.tyinf then
     let ty = Typeinfer.infer e in
     Fmt.pr "inferred type ==> @[%a@]\n%!" Pretty.ty ty);
  get_eval () e

let handle_let_or_eval (c : Cmd.t) =
  match c with
  | CLet (x, t, def) ->
      (let v = check_and_run (context_expr def) in
       Fmt.pr "%s = @[%a@]\n%!" x Pretty.expr v);
      get_context () := ((x, t), def) :: !(get_context ())
  | CEval e ->
      Fmt.pr "<== @[%a@]\n%!" Pretty.expr e;
      if not !Opts.quiet then Fmt.pr "<== AST:\n@[%a@]\n%!" Ast.Pretty.expr e;
      let v = check_and_run (context_expr e) in
      Fmt.pr "[eval] ==> @[%a@]\n%!" Pretty.expr v
  | _ -> failwith "Impossible"

let commands = [ "#print"; "#clear"; "#load"; "#save" ]
let replayable = function Cmd.CLet _ -> true | _ -> false

let rec repl () =
  try
    match LNoise.linenoise "> " with
    | None -> ()
    | Some l ->
        LNoise.history_add l |> ignore;
        handler (fun () ->
            match Lamp.Parser.Command.parse_string l with
            | CPrint -> print_context ()
            | CClear ->
                get_context () := [];
                Fmt.pr ". context cleared\n%!"
            | CLoad f ->
                (* match LNoise.history_load ~filename:f with
                   | Ok () -> *)
                Fmt.pr ". loading history from %s\n%!" f;
                Fmt.pr ". replaying history...\n%!";
                (* load content of file f and split it into lines *)
                Parser.Script.parse_file f
                |> Base.List.filter ~f:replayable
                |> Base.List.iter ~f:(fun c ->
                       try handle_let_or_eval c with _ -> ());
                Fmt.pr ". history replayed\n%!"
                (* | Error e -> Fmt.pr ". error loading history: %s\n%!" e) *)
            | CSave f -> (
                match LNoise.history_save ~filename:f with
                | Ok () -> Fmt.pr ". history saved to %s\n%!" f
                | Error e -> Fmt.pr ". error saving history: %s\n%!" e)
            | (CLet _ | CEval _) as c -> handle_let_or_eval c
            | CSynth t -> (
                match Curry_howard.synthesize t with
                | Some e ->
                    Fmt.pr "[synthesis] ==> %a\n%!" Fmt.(Pretty.expr) e;
                    ignore @@ check_and_run e
                | None -> Fmt.pr "[synthesis] fail\n%!"));
        repl ()
  with Stdlib.Sys.Break -> repl ()

let read_args () =
  let set_file s = Opts.path := Some s in
  let opts =
    [
      ( "-typed",
        Stdlib.Arg.Set Opts.typed,
        "enable type checking in interpreter (default: off)" );
      ( "-tyinf",
        Stdlib.Arg.Set Opts.tyinf,
        "enable type inference in interpreter (default: off)" );
      ("-q", Stdlib.Arg.Set Opts.quiet, "suppress AST printing (default: off)");
      ( "-fast",
        Stdlib.Arg.Set Opts.fast,
        "use closure semantics instead of eager substitution (default: off)" );
    ]
  in
  Stdlib.Arg.parse opts set_file ""

let main () =
  read_args ();
  match !Opts.path with
  | Some file_name ->
      handler (fun () ->
          let v = check_and_run (Parser.Expr.parse_file file_name) in
          Fmt.pr "@[%a@]\n%!" Pretty.expr v)
  | None ->
      (* repl mode *)
      Fmt.pr "Welcome to lambda+! Built on: %s\n%!" Build_metadata.date;
      LNoise.history_set ~max_length:100 |> ignore;
      repl ()
;;

main ()
