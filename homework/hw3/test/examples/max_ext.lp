fun rec max with l = 
    match l with
    | Nil -> $2 false
    | x::t -> $1 (match max t with
        | $1 y -> if x > y then x else y
        | $2 _ -> x
        end)
    end
in
max (7::10::5::1::4::2::Nil)