fun rec length: Int with xs: List['a] =
    match xs with
    | Nil -> 0
    | _::ys -> 1 + length ys 
    end
in
length (1::Nil) + length (false::true::false::Nil)