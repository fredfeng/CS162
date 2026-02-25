let map = 
    fix map is lambda f: 'a -> 'b, xs:List['a].
        match xs with
        | Nil -> Nil
        | x::ys -> f x :: map f ys 
        end
in
let filter =
    fix filter is lambda p: 'a -> Bool, xs:List['a].
        match xs with
        | Nil -> Nil
        | x::ys -> if p x then x::filter p ys else filter p ys
        end
in
let pipe = lambda x,f. f x
in
pipe (pipe (pipe (pipe (pipe (pipe
    (1::2::3::Nil)
    (filter (lambda x. x > 1)))
    (map (lambda x. x - 2)))
    (map (lambda x. x * 2)))
    (map (lambda x. x > 0)))
    (filter (lambda b. b)))
    (map (lambda b. if b then (lambda x,y.x) else (lambda x,y.y)))