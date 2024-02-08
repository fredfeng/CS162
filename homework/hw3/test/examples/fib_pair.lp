fun rec fib with p, n = 
    let x = fst p in
    let y = snd p in
    if n = 0 then x
    else fib {y, x+y} (n-1)
in fib {0, 1} 30