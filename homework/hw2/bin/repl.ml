open Lamp
open Ast
open Eval
open Format

module Opts = struct
  let path : string option ref = ref None
end

let handler (f : unit -> unit) : unit =
  try f () with
  | Parsing.Parse_error -> Fmt.epr "Syntax error\n%!"
  | Err.Syntax { sl; sc; el; ec } ->
      Fmt.epr "Syntax error: %d.%d-%d.%d\n%!" sl sc el ec
  | Err.Lexing { l; s } ->
      Fmt.epr "Lexing error: At offset %d: unexpected character: %s\n%!" l s
  | Stuck msg -> printf "runtime error: %s\n%!" msg
  | Stack_overflow ->
      Fmt.epr
        "Interpreter stack overflow; too many recursive function calls\n%!"

let rec repl () =
  match LNoise.linenoise "> " with
  | None -> ()
  | Some l ->
      LNoise.history_add l |> ignore;
      handler (fun () ->
          let e = Parse_util.parse l in
          Fmt.pr "<== %a\n%!" Pretty.expr e;
          let v = eval e in
          Fmt.pr "==> %a\n%!" Pretty.expr v);
      repl ()

let read_args () =
  let set_file s = Opts.path := Some s in
  let opts = [] in
  Arg.parse opts set_file ""

let () =
  read_args ();
  match !Opts.path with
  | Some file_name ->
      let ch = open_in file_name in
      let contents = really_input_string ch (in_channel_length ch) in
      close_in ch;
      handler (fun () ->
          let e = Parse_util.parse contents in
          let v = eval e in
          Fmt.pr "%a\n%!" Pretty.expr v)
  | None ->
      (* repl mode *)
      Fmt.pr "Welcome to lambda+! Built on: %s\n%!" Build_metadata.date;
      LNoise.history_set ~max_length:100 |> ignore;
      repl ()
