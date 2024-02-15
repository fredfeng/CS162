open Base
open Ast
open Eval

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

(* Unit test utilities *)
let texpr = Alcotest.testable Pretty.pp_expr equal_expr
let tvars = Alcotest.testable Vars.pp Vars.equal

let parse s =
  try Parse_util.parse s with _ -> Alcotest.fail ("Failed to parse: " ^ s)

(** Test free variable function *)
let test_free_vars (e : expr) (expected : string list) () =
  Alcotest.(check' tvars)
    ~msg:"same set" ~expected:(Vars.of_list expected) ~actual:(free_vars e)

(** Test free variable function with concrete syntax input *)
let test_free_vars_s (e_str : string) (expected : string list) () =
  test_free_vars (parse e_str) expected ()

(** Test substitution c[ x |-> e ] = expected *)
let test_subst ~(x : string) ~(e : expr) ~(c : expr) (expected : expr) () =
  let c' =
    try subst x e c with Stuck msg -> failwith ("Got stuck!\n" ^ msg)
  in
  Alcotest.(check' texpr) ~msg:"same expr" ~expected ~actual:c'

(** Test substitution c[ x |-> e ] = expected, with concrete syntax inputs *)
let test_subst_s ~(x : string) ~(e : string) ~(c : string) (expected : string)
    () =
  test_subst ~x ~e:(parse e) ~c:(parse c) (parse expected) ()

(** Check an expression evaluate to the expected value *)
let test_eval_with (e : expr) (expected : expr) ~f () =
  try
    with_timeout 10 (fun () ->
        let v = f e in
        Alcotest.(check' texpr)
          ~msg:(Fmt.str "%a" Pretty.pp_expr e)
          ~expected ~actual:v)
  with
  | Stuck msg -> Alcotest.fail ("Got stuck!\n" ^ msg)
  | Timeout -> Alcotest.fail "Timeout!"

(** Check an expression evaluate to the expected value *)
let test_eval = test_eval_with ~f:eval

(** Check a expression (concrete syntax) evaluate to the expected value (concrete syntax) *)
let test_eval_s (e_str : string) (expected_str : string) () =
  test_eval (parse e_str) (parse expected_str) ()

let test_eval_file (filename : string) (expected_str : string) () =
  let e = Parse_util.parse_file filename in
  let expected = parse expected_str in
  test_eval e expected ()

(** Check an expression gets stuck during evaluation *)
let test_stuck (e : expr) () =
  try
    let v = eval e in
    Alcotest.fail (Fmt.str "evaluated to %a" Pretty.pp_expr v)
  with Stuck _ -> Alcotest.(check' unit) ~msg:"stuck" ~expected:() ~actual:()

(** Check a expression (concrete syntax) gets stuck during evaluation *)
let test_stuck_s (e_str : string) = test_stuck (parse e_str)

let free_vars_tests = [ test_free_vars_s "fix x is y" [ "y" ] ]

let subst_tests =
  [ test_subst_s ~x:"var" ~e:"1" ~c:"var < var" (*expected *) "1 < 1" ]

let eval_tests =
  (* test an input expression evaluates to the expected output *)
  let t = test_eval_s in
  (* parse the file containing an input expression, and check that it evaluates to the expected output *)
  let tf = test_eval_file in
  [
    test_eval_s (* input *) "1+2" (* expected *) "3";
    t "8+12-4*3" "8";
    t "let x = let x = 2 in x + 1 in x * 2" "6";
    t "fun f with f = f in f 2" "2";
    t "fun add with x,y = x + y in add 2 3" "5";
    t "(lambda x. (lambda f. f x) (lambda x. x *3)) 2" "6";
    t
      "(lambda f. (lambda x. f (lambda v. x x v)) (lambda x. f (lambda v. x x \
       v))) (lambda f, g, x. g x + 1) (lambda x. x*2) 3"
      "7";
    tf "examples/fib.lp" "832040";
    tf "examples/add_n.lp" "11::12::Nil";
    tf "examples/primes.lp"
      "2::3::5::7::11::13::17::19::23::29::31::37::41::43::47::53::59::61::67::71::Nil";
  ]

let product_tests =
  let tf = test_eval_file in
  [ tf "examples/fib_pair.lp" "832040"; tf "examples/mutual_rec.lp" "false" ]

let eval_stuck_tests = [ test_stuck_s (* input *) "if 1 then 2 else 3" ]

(** What is this? *)
let test_something t (e_str : string) (expected_str : string) () =
  try
    let v = with_timeout t (fun () -> eval_fast (parse e_str)) in
    Alcotest.(check' texpr) ~msg:".." ~expected:(parse expected_str) ~actual:v
  with
  | Stuck msg -> Alcotest.fail ("Got stuck!\n" ^ msg)
  | Timeout -> Alcotest.fail "Timeout!"

let some_tests =
  [
    test_something 1
      "(lambda n. match (lambda l. l false) (lambda _. match (lambda l. l \
       false) (lambda _. 2 :: ((fix countfrom is lambda n. lambda _. n :: \
       (countfrom (n + 1))) (2 + 1))) with | Nil -> Nil | h :: t -> h :: ((fix \
       sieve is lambda l. lambda _. match (lambda l. l false) l with | Nil -> \
       Nil | h :: t -> h :: (sieve (((lambda l. lambda p. lambda _. match \
       (lambda l. l false) l with | Nil -> Nil | h :: t -> if p h then h :: \
       (((fix filter is lambda l. lambda p. lambda _. match (lambda l. l \
       false) l with | Nil -> Nil | h :: t -> if p h then h :: ((filter t) p) \
       else (lambda l. l false) ((filter t) p) end) t) p) else (lambda l. l \
       false) (((fix filter is lambda l. lambda p. lambda _. match (lambda l. \
       l false) l with | Nil -> Nil | h :: t -> if p h then h :: ((filter t) \
       p) else (lambda l. l false) ((filter t) p) end) t) p) end) t) (lambda \
       n. (lambda b. if b then false else true) (((lambda x. lambda y. if x > \
       y then false else if x = y then true else ((fix divides is lambda x. \
       lambda y. if x > y then false else if x = y then true else (divides x) \
       (y - x)) x) (y - x)) h) n)))) end) (((lambda l. lambda p. lambda _. \
       match (lambda l. l false) l with | Nil -> Nil | h :: t -> if p h then h \
       :: (((fix filter is lambda l. lambda p. lambda _. match (lambda l. l \
       false) l with | Nil -> Nil | h :: t -> if p h then h :: ((filter t) p) \
       else (lambda l. l false) ((filter t) p) end) t) p) else (lambda l. l \
       false) (((fix filter is lambda l. lambda p. lambda _. match (lambda l. \
       l false) l with | Nil -> Nil | h :: t -> if p h then h :: ((filter t) \
       p) else (lambda l. l false) ((filter t) p) end) t) p) end) t) (lambda \
       n. (lambda b. if b then false else true) (((lambda x. lambda y. if x > \
       y then false else if x = y then true else ((fix divides is lambda x. \
       lambda y. if x > y then false else if x = y then true else (divides x) \
       (y - x)) x) (y - x)) h) n)))) end) with | Nil -> Nil | h :: t -> if n = \
       0 then Nil else h :: (((fix take is lambda l. lambda n. match (lambda \
       l. l false) l with | Nil -> Nil | h :: t -> if n = 0 then Nil else h :: \
       ((take t) (n - 1)) end) t) (n - 1)) end) 200"
      "2 :: 3 :: 5 :: 7 :: 11 :: 13 :: 17 :: 19 :: 23 :: 29 :: 31 :: 37 :: 41 \
       :: 43 :: 47 :: 53 :: 59 :: 61 :: 67 :: 71 :: 73 :: 79 :: 83 :: 89 :: 97 \
       :: 101 :: 103 :: 107 :: 109 :: 113 :: 127 :: 131 :: 137 :: 139 :: 149 \
       :: 151 :: 157 :: 163 :: 167 :: 173 :: 179 :: 181 :: 191 :: 193 :: 197 \
       :: 199 :: 211 :: 223 :: 227 :: 229 :: 233 :: 239 :: 241 :: 251 :: 257 \
       :: 263 :: 269 :: 271 :: 277 :: 281 :: 283 :: 293 :: 307 :: 311 :: 313 \
       :: 317 :: 331 :: 337 :: 347 :: 349 :: 353 :: 359 :: 367 :: 373 :: 379 \
       :: 383 :: 389 :: 397 :: 401 :: 409 :: 419 :: 421 :: 431 :: 433 :: 439 \
       :: 443 :: 449 :: 457 :: 461 :: 463 :: 467 :: 479 :: 487 :: 491 :: 499 \
       :: 503 :: 509 :: 521 :: 523 :: 541 :: 547 :: 557 :: 563 :: 569 :: 571 \
       :: 577 :: 587 :: 593 :: 599 :: 601 :: 607 :: 613 :: 617 :: 619 :: 631 \
       :: 641 :: 643 :: 647 :: 653 :: 659 :: 661 :: 673 :: 677 :: 683 :: 691 \
       :: 701 :: 709 :: 719 :: 727 :: 733 :: 739 :: 743 :: 751 :: 757 :: 761 \
       :: 769 :: 773 :: 787 :: 797 :: 809 :: 811 :: 821 :: 823 :: 827 :: 829 \
       :: 839 :: 853 :: 857 :: 859 :: 863 :: 877 :: 881 :: 883 :: 887 :: 907 \
       :: 911 :: 919 :: 929 :: 937 :: 941 :: 947 :: 953 :: 967 :: 971 :: 977 \
       :: 983 :: 991 :: 997 :: 1009 :: 1013 :: 1019 :: 1021 :: 1031 :: 1033 :: \
       1039 :: 1049 :: 1051 :: 1061 :: 1063 :: 1069 :: 1087 :: 1091 :: 1093 :: \
       1097 :: 1103 :: 1109 :: 1117 :: 1123 :: 1129 :: 1151 :: 1153 :: 1163 :: \
       1171 :: 1181 :: 1187 :: 1193 :: 1201 :: 1213 :: 1217 :: 1223 :: Nil";
  ]

let tests =
  [
    ("free_vars", free_vars_tests);
    ("subst", subst_tests);
    ("eval", eval_tests);
    ("eval_stuck", eval_stuck_tests);
    ("(hmm) product", product_tests);
    ("(bonus) ..", some_tests);
  ]
