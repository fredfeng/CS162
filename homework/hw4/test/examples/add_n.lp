fun rec map : List[Int] with f: Int -> Int, l: List[Int] = 
    match l with
    | Nil -> Nil[Int]
    | x::xs -> f x :: map f l
    end in

// increments every element of a list by n
fun add_n : List[Int] with l: List[Int], n: Int = 
    map (lambda m: Int. n + m) l in

add_n (1::2::Nil[Int]) 10