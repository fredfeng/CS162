// increments every element of a list by n
(fix add_n is
    lambda l, n.
        match l with
        | Nil -> Nil
        | x::xs -> x + n :: add_n xs n
        end
) (1::2::Nil[Int]) 10 // evaluates to 11::12::Nil