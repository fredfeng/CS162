// Mutual recursion can be realized by combining fix and internal choice
let even_odd = fix even_odd is
    (
        lambda n.
            let odd = even_odd.2 in
            if n = 0 then true
            else odd (n-1)
        ,
        lambda n.
            let even = even_odd.1 in
            if n = 0 then false
            else even (n-1)
     ) in
let even = even_odd.1 in
let odd  = even_odd.2 in
if odd 11111 then even 11111 else even 0