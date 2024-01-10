open Hw1.Part1

let test_fib i n () =
  Alcotest.(check' int) ~msg:"same int" ~expected:n ~actual:(fib i)

let fib_tests = [ test_fib (* input *) 10 (* expected output *) 55 ]
let tests = [ ("fib", fib_tests) ]
