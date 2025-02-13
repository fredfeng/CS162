// increments every element of a list by n
fun rec add_n with l, n =
    match l with
    | Nil -> Nil
    | x::xs -> x + n :: add_n xs n
    end
in add_n (1::2::Nil) 10 // evaluates to 11::12::Nil