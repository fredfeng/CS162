// encode a natural number as a church numeral
// Only for improving readability of encodings
// in lambda-plus, and not part of lambda calculus
fun encode with n =
  if n = 0 then lambda f. lambda x. x
  else lambda f. lambda x. f ((encode (n-1)) f x) in

// decode a church numeral into a natural number
// Only for improving readability of encodings
// in lambda-plus, and not part of lambda calculus
fun decode with a =
  a (lambda x. x + 1) 0 in

let encoding_0 = encode 0 in
let encoding_1 = encode 1 in
let encoding_2 = encode 2 in
let encoding_3 = encode 3 in

// add two church numerals
fun encoding_add with a, b =
  lambda f. lambda x. b f (a f x) in

// multiply two church numerals
fun encoding_mul with a, b =
  lambda f. lambda x. b (a f) x in

// raise a to its b-th power
fun encoding_exp with a, b =
  lambda f. lambda x. (b a) f x in

// decode (encoding_add encoding_2 encoding_3)
// decode (encoding_mul encoding_2 encoding_3)
// decode (encoding_exp encoding_2 encoding_3)

// recursive factorial in lambda-plus,
fun fact with n =
  if n = 0 then 1
  else n * fact (n-1) in

// generator for factorial, which is non-recursive and
// expressible in lambda calculus
let mystery = lambda f. lambda n. 
  if n = 0 then 1
  else n * f (n-1) in

// always return 0 (seed for the generator)
let bad = lambda x. 0 in
// fact0 approximates fact at n = 0
let fact0 = mystery bad in
// fact1 approximates  fact at n = 0,1
let fact1 = mystery (mystery bad) in
// fact2 approximates fact at n = 0,1,2
let fact2 = mystery (mystery (mystery bad)) in
// fact3 approximates fact at n = 0,1,2,3
let fact3 = mystery (mystery (mystery (mystery bad))) in
// fact_inf approximates fact at n = 0,1,2,3,4,5, ...
// by applying mystery infinitely many times
// i.e. fact_inf == fact
// let fact_inf = mystery (mystery ... mystery (mystery (mystery (mystery bad))) in

// The Y combinator only works in a call-by-name language
let y_combinator = lambda f. (lambda x. f (x x)) (lambda x. f (x x y)) in
// The Z combinator works in call-by-value languages as well, e.g. lambda plus
let z_combinator = lambda f. (lambda x. f (lambda y. x x y)) (lambda x. f (lambda y. x x y)) in
let magic = z_combinator in
let fact_non_recursive = magic mystery in
fact_non_recursive 5