let foldr = fix foldr is 
    lambda init: 'b, f: 'a -> 'b -> 'b, xs: List['a]. 
        (match xs with
        | Nil -> init
        | y::ys -> f y (foldr init f ys)
        end : 'b)
in 
let map: List['a] -> List['b] = lambda f: 'a -> 'b.
    foldr Nil (lambda x,acc. f x :: acc)
in
map (lambda x.x>1) (1::2::3::Nil)
