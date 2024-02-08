// an infinite list can be represented as a function that, 
// when called with anything, returns a cons cell whose head is
// the first element of the list and whose tail is another function
// representing the rest of the infinite list.

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

// the first 20 primes
take primes 20

// feel free to replace 20 with other numbers!



// Congratulations! You have found a hidden bonus problem (2 points): 
// Optimize your interpreter asymptotically so that expressions like
// `take primes 500` finishes within 5sec on a slow machine like CSIL
// without any hardcoding.
// 
// *Hint 1*: What is a **closure**? 
// https://youtu.be/-TN--YqcJhI
// (The reference interpreter on CSIL also has a `-cls` flag to turn on
// closure-based substitution.)
//
// *Hint 2*: Use OCaml's `Base.Map` for efficient dictionaries:
// https://ocaml.org/p/base/latest/doc/Base/Map/index.html
// Example:
// ```
// (* the type of dictionaries from strings to integers *)
// type dict = int Map.M(String).t
// (* the empty map *)
// let empty : dict = Map.empty (module String)
// (* add a key-value pair to the empty map *)
// let m : dict = Map.set empty ~key:"x" ~data:1
// (* look up the value of a key in the map *)
// let v : int = Map.find m "x"
// ```