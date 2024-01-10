(* open Base *)

let () =
  Alcotest.run "hw1"
    (List.map
       (fun (name, tests) ->
         (name, List.map (Alcotest.test_case name `Quick) tests))
       (Part1.tests @ Part2.tests @ Part3.tests @ Part4.tests))
