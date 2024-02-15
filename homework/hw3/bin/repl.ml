open Ast
open Eval
open Format

module Opts = struct
  let path : string option ref = ref None
  let fast : bool ref = ref false
  let meta : bool ref = ref false
  let quiet : bool ref = ref false
end

let get_eval () e = if !Opts.fast then eval_fast e else eval e

let handler (f : unit -> unit) : unit =
  try f () with
  | Parsing.Parse_error -> Fmt.epr "Syntax error\n%!"
  | Err.Syntax { sl; sc; el; ec } ->
      Fmt.epr "Syntax error: %d.%d-%d.%d\n%!" sl sc el ec
  | Err.Lexing { l; s } ->
      Fmt.epr "Lexing error: At offset %d: unexpected character: %s\n%!" l s
  | Stuck msg -> Fmt.pr "runtime error: %s\n%!" msg
  | Stack_overflow ->
      Fmt.epr
        "Interpreter stack overflow; too many recursive function calls\n%!"
  | Meta.Error s -> Fmt.epr "Meta error: %s\n%!" s

let context : (string * expr) list ref = ref []
let meta_context : (string * expr) list ref = ref []
let get_context () = if !Opts.meta then meta_context else context

let print_context () =
  Fmt.pr ">> context >>\n%!";
  Fmt.pr " @[%a@]\n%!"
    Fmt.(
      vbox (list ~sep:cut (box (pair ~sep:(any " ->@ ") string Pretty.pp_expr))))
    (Base.List.rev !(get_context ()));
  Fmt.pr "<< context <<\n%!"

let context_expr e =
  Base.List.fold_left ~init:e
    ~f:(fun e (x, def) -> Ast.Dsl.let_ x def ~in_:e)
    !(get_context ())

let handle_let_or_eval (c : Cmd.t) =
  match c with
  | CLet (x, def) ->
      let def_v' =
        if !Opts.meta then (
          let def_v' = Meta.eval (context_expr def) in
          Fmt.pr "[meta] %s = %a\n%!" x Meta.pp_large def_v';
          def_v')
        else
          let def_v = get_eval () (context_expr def) in
          Fmt.pr "%s = %a\n%!" x Pretty.pp_expr def_v;
          def_v
      in
      get_context () := (x, def_v') :: !(get_context ())
  | CEval e ->
      Fmt.pr "<== %a\n%!" Pretty.pp_expr e;
      if not !Opts.quiet then Fmt.pr "<== AST:\n%a\n%!" pp_expr e;

      if !Opts.meta then
        let v' = Meta.eval (context_expr e) in
        Fmt.pr "[meta] ==> %a\n%!" Meta.pp_large v'
      else
        let v = get_eval () (context_expr e) in
        Fmt.pr "[eval] ==> %a\n%!" Pretty.pp_expr v
  | _ -> failwith "Impossible"

let commands = [ "+meta"; "-meta"; "#print"; "#clear"; "#load"; "#save" ]
let replayable = function Cmd.CLet _ -> true | _ -> false

let rec repl () =
  try
    match
      if !Opts.meta then LNoise.linenoise "meta> " else LNoise.linenoise "> "
    with
    | None -> ()
    | Some l ->
        LNoise.history_add l |> ignore;
        handler (fun () ->
            match Parse_util.parse_cmd l with
            | CMeta ->
                Opts.meta := true;
                Fmt.pr ". entering meta-circular mode\n%!"
            | CExitMeta ->
                Opts.meta := false;
                context := !meta_context @ !context;
                Fmt.pr ". exiting meta-circular mode\n%!"
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
                let ch = open_in f in
                let contents = really_input_string ch (in_channel_length ch) in
                close_in ch;
                contents |> Parse_util.parse_cmd_list
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
      ("-q", Arg.Set Opts.quiet, "don't print AST (default: off)");
      ("-fast", Arg.Set Opts.fast, "use eval_fast (default: off)");
    ]
  in
  Arg.parse opts set_file ""

let main () =
  read_args ();
  match !Opts.path with
  | Some file_name ->
      let ch = open_in file_name in
      let contents = really_input_string ch (in_channel_length ch) in
      close_in ch;
      handler (fun () ->
          let e = Parse_util.parse contents in
          let v = get_eval () e in
          Fmt.pr "%a\n%!" Pretty.pp_expr v)
  | None ->
      (* repl mode *)
      Fmt.pr "Welcome to lambda+! Built on: %s\n%!" Build_metadata.date;
      LNoise.history_set ~max_length:100 |> ignore;
      repl ()
;;

main ()
