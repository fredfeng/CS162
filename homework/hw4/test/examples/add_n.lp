// increments every element of a list by n
(fix add_n: List[Int] -> Int -> List[Int] is
    lambda l: List[Int], n: Int.
        match l with
        | Nil -> Nil[Int]
        | x::xs -> x + n :: add_n xs n
        end
) (1::2::Nil[Int]) 10 // evaluates to 11::12::Nil