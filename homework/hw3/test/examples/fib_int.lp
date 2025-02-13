fun rec fib with p, n = 
    if n = 0 then p.1
    else 
        let x = p.1 in 
        let y = p.2 in
        fib (y, x+y) (n-1)
in fib (0, 1) 30