open Base

let () =
  Alcotest.run "hw2"
    (List.map
       ~f:(fun (name, tests) ->
         (name, List.map ~f:(Alcotest.test_case name `Quick) tests))
       (Test_part1.tests @ Test_lamp.tests))
