// Mutual recursion can be realized by combining fix and products
let even_odd = fix even_odd is
    {
        lambda n.
            let odd = snd even_odd in
            if n = 0 then true
            else odd (n-1)
        ,
        lambda n.
            let even = fst even_odd in
            if n = 0 then false
            else even (n-1)
    } in
let even = fst even_odd in
let odd  = snd even_odd in
if odd 11111 then even 11111 else even 0