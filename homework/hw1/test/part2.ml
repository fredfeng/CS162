open Base
open Hw1.Part2

let test_compress =
  Utils.test_io Alcotest.(list string) "same list" (compress String.equal)

let test_max = Utils.test_io Alcotest.(option int) "same int" max
let test_join = Utils.test_io Alcotest.(option (list int)) "same list" join

let test_lookup =
  Utils.test_io
    Alcotest.(option string)
    "same string"
    (Utils.uncurry (lookup Int.equal))

(** A list of (input, output) pairs *)
let compress_tests = [ ([ "a"; "a" ], [ "a" ]) (* add your tests here *) ]

(** A list of (input, output) pairs *)
let max_tests = [ ([ 1; 2 ], Some 2) (* add your tests here *) ]

(** A list of (input, output) pairs *)
let join_tests =
  [ ([ Some 1; Some 2 ], Some [ 1; 2 ]) (* add your tests here *) ]

(** A list of ((input key * input dict) * output) pairs *)
let lookup_tests = [ ((1, [ (1, "hi") ]), Some "hi") (* add your tests here *) ]

let tests =
  [
    ("compress", List.map ~f:test_compress compress_tests);
    ("max", List.map ~f:test_max max_tests);
    ("join", List.map ~f:test_join join_tests);
    ("lookup", List.map ~f:test_lookup lookup_tests);
  ]
