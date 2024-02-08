open Base

(**
  IMPORTANT: 
  Later encodings can refer to previous ones. 
  Thus, DO NOT change the order of this list. *)
let encodings =
  [
    (********************
     * Bool encodings
     ********************)
    (* encoding of boolean true *)
    ("tt", "lambda x,y. x");
    (* encoding of boolean false *)
    ("ff", "lambda x,y. y");
    (********************
     * Nat encodings
     ********************)
    (* encoding of zero *)
    ("zero", "0");
    (* encoding of successor *)
    ("succ", "0");
    (* add two encoded nat *)
    ("add", "0");
    (* multiply two encoded nat *)
    ("mul", "0");
    (* factorial *)
    ("factorial", "0");
    (* predecessor *)
    ("pred", "0");
    (* subtraction *)
    ("sub", "0");
    (* is-zero *)
    ("is_zero", "lambda m. m tt (lambda _,_. ff)");
    (* less-than-or-equal *)
    ("leq", "0");
    (* equal *)
    ("eq", "lambda n,m. leq n m (leq m n) ff");
    (* less-than *)
    ("lt", "lambda n,m. (leq n (pred m))");
    (* greater-than *)
    ("gt", "lambda n,m. lt m n");
    (********************
     * List encodings
     ********************)
    (* encoding of empty list *)
    ("nil", "0");
    (* encoding of cons cell *)
    ("cons", "0");
    (* list length function *)
    ("length", "0");
    (********************
     * Tree encodings
     ********************)
    (* encoding of leaf *)
    ("leaf", "0");
    (* encoding of node *)
    ("node", "0");
    (* tree size function *)
    ("size", "0");
    (********************
     * Product encodings
     ********************)
    (* encoding of product constructor *)
    ("pair", "lambda x,y,f. f x y");
    (* encoding of fst *)
    ("fst_enc", "lambda p. p (lambda x,y. x)");
    (* encoding of snd *)
    ("snd_enc", "lambda p. p (lambda x,y. y)");
    (********************
     * Fixed-point encodings
     ********************)
    (* the Z combinator for computing fixed-points *)
    ( "fix_z",
      "lambda f. (lambda x. f (lambda v. x x v)) (lambda x. f (lambda v. x x \
       v))" );
  ]
  |> List.map ~f:(fun (x, e) -> (x, Parse_util.parse e))
