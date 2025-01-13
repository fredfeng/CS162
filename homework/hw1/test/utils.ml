let test_io t msg f (i, o) () =
  Alcotest.(check' t) ~msg ~expected:o ~actual:(f i)

let uncurry f (x, y) = f x y
