open Base

let () =
  Alcotest.run "hw5"
    (List.map
       ~f:(fun (name, tests) ->
         (name, List.map ~f:(Alcotest.test_case name `Quick) tests))
       Test_typing.tests)
