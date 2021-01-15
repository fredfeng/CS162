(* Basic OCaml syntax *)

(* This is a comment. *)

(* An OCaml program is just a list of expressions.*)

(* Declare a variable *)
let my_variable : int = 100
  ;;
(* Use a semicolon to "end" an expression at the top level *)

(* Declare a function *)
let my_function (x : int) : int =
  x + 5
  ;;

(* Note: you don't actually need type annotations. OCaml can _infer_ all of them. *)
let my_variable2 = 100
  ;;
let my_function2 x = x + 5
  ;;

(* let expressions *)
let my_value =
  let foo = 10 in foo
  ;;
(*
  Note that there is a difference: at the top level, you are allowed to omit
  "in", so you can just create a variable binding.
*)

(* if then else _expression_*)
if true then 1 else 2
  ;;

(*
  So there's one gotcha I want to point out early, and that's equality.
  In most situations, you want to use the single equal sign '=' as the equality
  operator. The '==' equality won't do what you expect.

  If you're interested in the details: '=' is similar to .equals in Java, whereas
  '==' is similar to '==' in Java. Most of the time you'll want to use '='.
*)
let name = "foo" in
  if name = "bar" then 5 else 10
;;

(*
  The bread and butter of OCaml is algebraic data types. It's best shown by
  example. First, consider a simple example of an _option type_:
*)
type int_option = NoInt | SomeInt of int
  ;;

(*
  This is a data type that represents an "optional" value with two cases:
  either we have NoInt (i.e. no value), or we have SomeInt value. For example,
  suppose we want to divide two numbers. We can't divide by zero, in which case
  we have "no" value.
*)
let safe_div x y : int_option =
  if y == 0 then NoInt else SomeInt(x / y)
  ;;

safe_div 10 5 ;;
safe_div 10 0 ;;

(*
  Once we have an option value, we need to be able to use it. We can consider
  the possible _cases_ of this value--there are only two, NoInt and SomeInt--
  and use _pattern matching_ to define what to do in each case.
*)
match safe_div 10 5 with
| NoInt -> print_endline "Can't divide by zero"
| SomeInt(x) -> print_int x
;;

(*
  Let's consider something more complex now.
  The following will declare a linked list of integers, which consists of either:
    1) the empty list
	2) a cons cell containing head (an integer) and tail (an int list)

  We can define this similar to how we defined option, but we have two fields
  for cons. To specify multiple fields, separate them with a "*". Recall that
  "*" means "multiplication"; in this context, it's "Cartesian product."
*)
type int_list = IntNil | IntCons of int * int_list
  ;;

let my_list = IntCons(1, IntCons(2, IntNil))
  ;;

(* Again, we can use pattern matching to "deconstruct" a list: *)
match my_list with
| IntNil -> print_endline "This is an empty list"
| IntCons(_, _) -> print_endline "This is not an empty list"
;;

(*
  Now let me explain why this is called "pattern matching."

  The left hand side of the arrow is called a pattern. Basically, it lets me
  specify what "case" I want to look for in this match.

  The "_" is called a "wildcard" and will match any value.

  A pattern can be a variable, a constant, a wildcard, a constructor (where
  its arguments are replaced with patterns), and more.

  See Chapter 7.6 of "The OCaml system"

  Here are examples of different patterns you could use:
*)
(* ignore all of the fields *)
match my_list with
| IntNil -> 1
| IntCons _ -> 0
;;
(* catch all for non-nil case *)
match my_list with
| IntNil -> 1
| _ -> 0
;;
(* match a nested cons cell *)
match my_list with
| IntCons(_, IntCons(x, _)) -> x
| _ -> 0
;;
(* match a cons cell whose head is a constant *)
match my_list with
| IntCons(1, _) -> 1
| _ -> 0
;;

(*
  A more interesting use is computing functions on lists. For example, suppose
  we want to find the sum of a list. We can define a recursive function with
  the let rec keyword and then use pattern matching:
*)
let rec sum list = match list with
  | IntNil -> 0
  | IntCons(hd, tl) -> hd + sum tl
;;

sum (IntCons(1, IntCons(2, IntCons(3, IntNil)))) ;;

(* Exercise: define a binary tree data structure on integers and a recursive
   function to compute the sum of all of its elements. *)
(* type int_tree = ??? *)
(* let rec tree_sum = ??? *)


(* OCaml also supports "generics" or type variables. More formally, this is
   referred to as _parametric polymorphism_. *)

type 'a gen_list = Nil | Cons of 'a * 'a gen_list
  ;;

(*
  We call gen_list the _type constructor_ and 'a the _type parameter_.
  Unlike most programming languages, the type parameters go before the type
  constructor in OCaml.

  This allows us to reuse the list type with different data structures. For
  example:
*)
let my_names : string gen_list = Cons("hello", Cons("world", Nil))
  ;;

(* using the standard library versions of list and option: *)
let safe_head (xs : 'a list) : 'a option =
  match xs with
  | [] -> None
  | h :: _ -> Some(h)

(*
  Ok, as a last thing, I want to show you examples of the standard
  library versions of list and option. Don't make your own in actual
  code.
*)

(*
  Option is defined as

  type 'a option = None | Some of 'a
*)

(* none *)
None
  ;;

(* some *)
Some(5)
  ;;

(*
  You can think of list being defined as

  type 'a list = [] | :: of 'a * 'a list

  OCaml also provides some syntax sugar for lists.
*)

(* empty list *)
let _ = []
  ;;
(* cons *)
1 :: []
  ;;

(* list literal *)
[1; 2; 5]
  ;;

(* append *)
List.append [1; 2; 3] [3; 4; 5]
  ;;
(* reverse *)
List.rev [1; 2; 3]
  ;;
