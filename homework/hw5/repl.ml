open Ast
open Eval
open Format

module Opts = struct
  let path : (string option) ref = ref None
  let typed : bool ref = ref false
end

let rec repl () =
  match LNoise.linenoise "> " with
  | None -> ()
  | Some l -> begin
      LNoise.history_add l |> ignore;
      try
        let e = parse l in
        begin
          if !Opts.typed then
            let ty = Typecheck.typecheck Typecheck.Env.empty e in
            printf "<-- type: %s\n%!" (string_of_typ ty);
        end;
        let v = eval e in
        printf "==> %s\n%!" (string_of_expr v)
      with
      | Parsing.Parse_error -> printf "parse error\n%!"
      | Stuck msg -> printf "runtime error: %s\n%!" msg
      | Typecheck.Type_error msg -> printf "type error: %s\n%!" msg
      | Stack_overflow ->
        printf "error: interpreter stack overflow; too many recursive function calls\n%!"
    end;
    repl ()


let read_args () =
  let set_file s = Opts.path := Some s in
  let opts = [
    "-typed", Arg.Set Opts.typed, "enable type checking in interpreter (default: off)";
  ]
  in
  Arg.parse opts set_file ""

;;

read_args ();
match !Opts.path with
| Some file_name ->
  let ch = open_in file_name in
  let contents = really_input_string ch (in_channel_length ch) in
  close_in ch;
  let e = parse contents in
  printf "<== %s\n%!" (string_of_expr e);
  printf "%s\n%!" (string_of_expr (eval e))
| None ->
  (* repl mode *)
  printf "Welcome to lambda+! Built on: %s\n%!" Build_metadata.date;
  let ty_mode =
    if !Opts.typed then "on"
    else "off"
  in
  printf "+settings: typecheck=%s\n%!" ty_mode;
  LNoise.history_set ~max_length:100 |> ignore;
repl ()