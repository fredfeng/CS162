// an infinite list can be represented as an internal choice (an object)
// with two behaviors: querying the head element, and querying the tail

fun hd with l = l.1 in
fun tl with l = l.2 in

// take the length-n prefix of a (potentially infinite) list
fun rec take with l, n =
    if n = 0
    then Nil
    else hd l :: take (tl l) (n-1) in

// an infinite list containing n, n+1, n+2, ...
fun rec countfrom with n =
    (n, countfrom (n+1)) in

// the infinite list of natural numbers 0, 1, 2, ...
let nat = countfrom 0 in

// take nat 10

// filter an infinite list
fun rec filter with l, p = 
    let h = hd l in
    if p h
    then (h, filter (tl l) p)
    else filter (tl l) p in

// check if x divides y
fun rec divides with x, y = 
    if x > y then false
    else if x = y then true
    else divides x (y-x) 
in

let is_even = lambda n. divides 2 n in

// take (filter nat is_even) 10

// boolean negation
let not = lambda b. if b then false else true in

// sieve of Eratosthenes
// https://youtu.be/bnRNiE_OVWA
fun rec sieve with l =
    let h = hd l in 
    (h, sieve (filter (tl l) (lambda n. not (divides h n)))) in

// infinite list of primes: 2, 3, 5, 7, ...
let primes = sieve (countfrom 2) in

// the first 50 primes
take primes 50

// feel free to replace 50 with other numbers!