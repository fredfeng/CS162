fun rec length with xs: List['a] =
    match xs with
    | Nil -> 0
    | _::ys -> 1 + length ys 
    end
in
length (Nil::Nil::Nil) + length (false::true::false::Nil)