(* this is a comment *)

(* let's define a variable, giving its type *)

let answer : int = 40 + 2

(* defining a function is similar, we give the type of both the parameter and
   the return value *)

let double (n : int) : int = n + n

(* we don't need to give the types, the compiler can *infer* the types for us,
   so it is doing not just type checking but also the job of figuring out the
   types *)

let square n = n * n

(* function application syntax in OCaml is "f x" rather than "f(x)" *)

let nine = square 3

(* here is a conditional *)

let abstract_value x = if x > 0 then x else -x

(* let's use some local variables, here is a local variable `greater_than_0` *)

let abstract_value2 x = let greater_than_0 = x > 0 in
                        if greater_than_0 then x else -x

(* This is the syntax for defining a local variable:

   let X = DEF_OF_X in EXPR_USING_X

 *)

(* we can define multiple local variables, note that `double` is an `int` inside
   this function but an `int -> int` outside it *)

let math_values x = let double = x + x in
                    let square = x * x in
                    [double; square]


(* when defining a recursive function, we need to use `let rec` to tell the
   compiler that the function "fact" should be available for its own
   definition. *)

let rec fact n = if n = 0 then 1 else n * fact (n - 1)

(* we sometimes use ";;" to separate top-level expressions, specifically when
   there is an ambiguity on where the next expression begins. every OCaml
   program is just a sequence of expressions *)

;;

(* when defining mutually recursive functions, we use let rec ... and ... *)

let rec even n = if n = 0 then true else odd (n - 1)
  and odd n' = if n' = 0 then false else even (n' - 1)

(* you can attach as many `and`s to a `let rec` as you need *)

;;

(* here are some random expressions, we need `;;` between them because the next
   expression's beginning is not clear (`4` may be part of current expression,
   or be start of the next expression) *)

3

;;

4 + answer

(* let's define a new type with two variants to represent an optional integer *)

type int_option =
  SomeInt of int (* either, we have an `int` *)
| NoInt          (* or nothing *)

(* in c++, the above would be similar to this : union int_option { int SomeInt; void? NoInt } *)

(* now, we can write a safe version of `fact` that returns nothing if the input
   is negative *)

let safe_fact n = if n < 0 then NoInt else SomeInt (fact n)

;;

(* we use `match` expressions to inspect values like an option, this is like
   `if` but more versatile *)

let inspect (o : int_option) = match o with (* match the value of `o` *)
    NoInt -> "no value inside"   (* if it is NoInt, return "no value inside" *)
  | SomeInt n -> string_of_int n (* if it is SomeInt, get the int inside and convert it o a string *)

(* we can also define a recursive data type, that is generic (holds any type,
   like templates). let's define a linked list *)

(* 'a is a type parameter, it is similar to a template parameter in C++

 * type name comes after the parameters, so this would become "int list",
 "string list" and so on. *)
type 'a list = 
  | Empty              (* a list is either empty *)
  | Cons of 'a * list  (* or, it has a first element (the 'a portion) and
                          contains a reference to the rest of the list (the list
                          portion) *)

(* For example, the following would be represented visually as:

 Cons (2, Cons (1, Empty))

 * 
 * [2 | x ]
 *      |
 *      v
 *     [1 | x]
 *          |
 *          v
 *          Empty *)

;;

(* OCaml already has lists, so we can write the list containing 2 and 1 like so: *)

2 :: (1 :: [])

       (* here, :: corresponds to Cons and [] corresponds to Empty *)

;;

(* we can also write this in a nicer way using the list syntax: *)

[2 ; 1 ]
