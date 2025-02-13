// an infinite list can be represented as a lambda that, 
// when called with anything, returns a list whose head is
// the first element of the list and whose tail is another
// infinite list

// an infinite list containing n, n+1, n+2, ...
fun rec countfrom with n =
    lambda _. n :: countfrom (n+1) in

// the infinite list of natural numbers 0, 1, 2, ...
let nat = countfrom 0 in

// force the materialization of an infinite list by calling it with
// a dummy argument
fun force with l = l false in

// filter a (potentially infinite) list
fun rec filter with l, p = 
    lambda _.
        match force l with
        | Nil -> Nil
        | h::t -> 
            if p h then h :: filter t p 
            else force (filter t p)
        end in

// take the length-n prefix of a (potentially infinite) list
fun rec take with l, n =
    match force l with
    | Nil -> Nil
    | h::t -> if n = 0 then Nil else h::(take t (n-1))
    end in

// check if x divides y
fun rec divides with x, y = 
    if x > y then false
    else if x = y then true
    else divides x (y-x) in

// boolean negation
let not = lambda b. if b then false else true in

// sieve of Eratosthenes
// https://youtu.be/bnRNiE_OVWA
fun rec sieve with l =
    lambda _.
        match force l with
        | Nil -> Nil // unreachable branch
        | h :: t ->
            h :: sieve (filter t (lambda n. not (divides h n)))
        end in

// infinite list of primes: 2, 3, 5, 7, ...
let primes = sieve (countfrom 2) in

// the first 50 primes
take primes 50

// feel free to replace 50 with other numbers!