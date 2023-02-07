open Ast
open Eval
open Format

let rec repl () =
  match LNoise.linenoise "> " with
  | None -> ()
  | Some l -> begin
      LNoise.history_add l |> ignore;
      try
        let e = parse l in
        printf "<== %s\n%!" (string_of_expr e);
        let v = eval e in
        printf "==> %s\n%!" (string_of_expr v)
      with
      | Parsing.Parse_error -> printf "parse error\n%!"
      | Stuck msg -> printf "error: %s\n%!" msg
      | Stack_overflow ->
        printf "error: interpreter stack overflow; too many recursive function calls\n%!"
    end;
    repl ()
  ;;

if Array.length Sys.argv >= 2
then begin
  (* execute expression in file *)
  let file_name = Array.get Sys.argv 1 in
  let ch = open_in file_name in
  let contents = really_input_string ch (in_channel_length ch) in
  close_in ch;
  let e = parse contents in
  printf "%s\n%!" (string_of_expr (eval e))
end
else begin
  (* repl mode *)
  printf "Welcome to lambda+! Built on: %s\n%!" Build_metadata.date;
  LNoise.history_set ~max_length:100 |> ignore;
  repl ()
end