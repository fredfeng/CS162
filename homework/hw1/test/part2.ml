open Hw1.Part2

let test_compress xs expected () =
  Alcotest.(check' (list string))
    ~msg:"same list" ~expected ~actual:(compress String.equal xs)

let test_max xs expected () =
  Alcotest.(check' (option int)) ~msg:"same int" ~expected ~actual:(max xs)

let test_join xs expected () =
  Alcotest.(check' (option (list int)))
    ~msg:"same list" ~expected ~actual:(join xs)

let test_lookup k d expected () =
  Alcotest.(check' (option string))
    ~msg:"same string" ~expected ~actual:(lookup Int.equal k d)

let compress_tests =
  [ test_compress (* input list *) [ "a"; "a" ] (* expected output *) [ "a" ] ]

let max_tests =
  [ test_max (* input list *) [ 1; 2 ] (* expected output *) (Some 2) ]

let join_tests =
  [
    test_join
      (* input list *) [ Some 1; Some 2 ]
      (* expected output *) (Some [ 1; 2 ]);
  ]

let lookup_tests =
  [
    test_lookup (* key *) 1
      (* input dict *) [ (1, "hi") ]
      (* expected value *) (Some "hi");
  ]

let tests =
  [
    ("compress", compress_tests);
    ("max", max_tests);
    ("join", join_tests);
    ("lookup", lookup_tests);
  ]
