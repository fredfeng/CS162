open Base
open Hw1.Part1

let test_fib = Utils.test_io Alcotest.int "same int" fib

(** A list of (input, output) pairs *)
let fib_tests = [ (10, 55) (* add your tests here *) ]

let tests = [ ("fib", List.map ~f:test_fib fib_tests) ]
