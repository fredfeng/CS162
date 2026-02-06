exception Syntax of { sl : int; sc : int; el : int; ec : int }
exception Lexing of { l : int; s : string }

let syntax_error () =
  let start_pos = Parsing.rhs_start_pos 1 in
  let end_pos = Parsing.rhs_end_pos 1 in
  let sl = start_pos.pos_lnum
  and sc = start_pos.pos_cnum - start_pos.pos_bol
  and el = end_pos.pos_lnum
  and ec = end_pos.pos_cnum - end_pos.pos_bol in
  raise (Syntax { sl; sc; el; ec })
