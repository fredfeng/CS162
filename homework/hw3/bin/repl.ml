open Base
open Lamp
open Ast

module Opts = struct
  let path : string option ref = ref None
  let quiet : bool ref = ref false
end

let () =
  let open Parser in
  Expr.pp_exceptions ();
  Command.pp_exceptions ();
  Script.pp_exceptions ()

let get_eval () e = Eval.eval e

let handler (f : unit -> unit) : unit =
  try f () with
  | Eval.Stuck msg -> Fmt.pr "runtime error: %s\n%!" msg
  | Stack_overflow ->
      Fmt.epr
        "Interpreter stack overflow; too many recursive function calls\n%!"

let context : (string * expr) list ref = ref []
let get_context () = context

let print_context () =
  Fmt.pr ">> context >>\n%!";
  Fmt.pr " @[%a@]\n%!"
    Fmt.(
      vbox (list ~sep:cut (box (pair ~sep:(any " ->@ ") string Pretty.expr))))
    (Base.List.rev !(get_context ()));
  Fmt.pr "<< context <<\n%!"

let context_expr e =
  Base.List.fold_left ~init:e
    ~f:(fun e (x, def) -> Ast.DSL.let_ x def ~in_:e)
    !(get_context ())

let check_and_run (e : expr) : expr = get_eval () e

let handle_let_or_eval (c : Cmd.t) =
  match c with
  | CLet (x, def) ->
      (let v = check_and_run (context_expr def) in
       Fmt.pr "%s = @[%a@]\n%!" x Pretty.expr v);
      get_context () := (x, def) :: !(get_context ())
  | CEval e ->
      Fmt.pr "<== @[%a@]\n%!" Pretty.expr e;
      if not !Opts.quiet then Fmt.pr "<== AST:\n%a\n%!" Ast.pp_expr e;
      let v = check_and_run (context_expr e) in
      Fmt.pr "[eval] ==> @[%a@]\n%!" Pretty.expr v
  | _ -> failwith "Impossible"

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
            | (CLet _ | CEval _) as c -> handle_let_or_eval c);
        repl ()
  with Stdlib.Sys.Break -> repl ()

let read_args () =
  let set_file s = Opts.path := Some s in
  let opts =
    [
      ("-q", Stdlib.Arg.Set Opts.quiet, "suppress AST printing (default: off)");
    ]
  in
  Stdlib.Arg.parse opts set_file ""

let main () =
  read_args ();
  match !Opts.path with
  | Some file_name ->
      handler (fun () ->
          let e = Parser.Expr.parse_file file_name in
          if not !Opts.quiet then Fmt.pr "Parsed: @[%a@]\n%!" Pretty.expr e;
          let v = check_and_run e in
          Fmt.pr "@[%a@]\n%!" Pretty.expr v)
  | None ->
      (* repl mode *)
      Fmt.pr "Welcome to lambda+! Built on: %s\n%!" Build_metadata.date;
      LNoise.history_set ~max_length:100 |> ignore;
      repl ()
;;

main ()
