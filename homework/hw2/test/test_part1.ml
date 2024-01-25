(* open Base *)
open Part1

let test_singletons xs expected () =
  Alcotest.(check' (list (list int)))
    ~msg:"same list" ~expected ~actual:(singletons xs)

let test_map2d f xxs expected () =
  Alcotest.(check' (list (list int)))
    ~msg:"same list" ~expected ~actual:(map2d f xxs)

let test_product xs ys expected () =
  Alcotest.(check' (list (list (pair int bool))))
    ~msg:"same list" ~expected ~actual:(product xs ys)

let test_power xs expected () =
  let sort = List.sort [%derive.ord: int list] in
  Alcotest.(check' (list (list int)))
    ~msg:"same list after sorting" ~expected:(sort expected)
    ~actual:(sort (power xs))

let test_join2 x y expected () =
  Alcotest.(
    check'
      (option (pair int string))
      ~msg:"same option" ~expected ~actual:(join2 x y))

let singletons_tests =
  [
    test_singletons (* input *) [ 6; 7; 3 ]
      (* expected output *) [ [ 6 ]; [ 7 ]; [ 3 ] ];
  ]

let map2d_tests =
  [
    test_map2d
      (* input function *) (fun x -> x + 1)
      (* input list *) [ [ 1; 2 ]; [ 3; 4 ] ]
      (* expected output *) [ [ 2; 3 ]; [ 4; 5 ] ];
  ]

let product_tests =
  [
    test_product (* input xs *) [ 1; 2 ]
      (* input ys *) [ true; false ]
      (* expected output *)
      [ [ (1, true); (1, false) ]; [ (2, true); (2, false) ] ];
  ]

let power_tests =
  [
    test_power (* input *) [ 1; 2; 3 ]
      (* expected output *)
      [ []; [ 1 ]; [ 2 ]; [ 3 ]; [ 1; 2 ]; [ 1; 3 ]; [ 2; 3 ]; [ 1; 2; 3 ] ];
  ]

let join2_tests =
  [
    test_join2 (* input 1 *) (Some 1) (* input 2 *)
      (Some "a")
      (* expected output *) (Some (1, "a"));
  ]

let tests =
  [
    ("singletons", singletons_tests);
    ("map2d", map2d_tests);
    ("product", product_tests);
    ("power", power_tests);
    ("join2", join2_tests);
  ]
