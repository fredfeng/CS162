open Base

let () =
  Alcotest.run "hw3"
    (List.map
       ~f:(fun (name, tests) ->
         (name, List.map ~f:(Alcotest.test_case name `Quick) tests))
       (Test_lamp.tests @ Test_meta.tests))
