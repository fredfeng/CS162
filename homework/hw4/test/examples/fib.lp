fun rec fib: Int with n: Int =
    if n = 0 then 0
    else if n = 1 then 1
    else 
        let x = fib (n-1) in
        let y : Int = fib (n-2) in
        x + y
in (fib 30 @ Int)