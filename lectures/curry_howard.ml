(* OCaml's type system *)
(* algebraic data type + parametric polymorphism *)

(* 1. algebraic data type = generalized enum *)

(* basic enum *)
type color = Red | Green | Blue

(* each case is a constructor that accepts some data *)
type expr = NumLit of int | Add of int * int | ...

(* parametric polymorphism = "template" for producing new types *)

(* e.g., represent the fact that a computation may either return an int, or may produce an error *)
type maybe_int = Nothing | Just of int
let safe_div (x: int) (y: int) : maybe_int =
  if y = 0 then Nothing else Just (x/y)
(* what if the computation returns either a bool, or may produce an error *)
type maybe_bool = Nothing | Just of bool
(* what if the computation returns either a float, or may produce an error *)
type maybe_float = Nothing | Just of float
(* there are infinitely many types in OCaml (because we can manufacture new ones using algebraic data types) *)

(* so we write a single template, where the return type becomes a parameter and may be replaced with any type *)
type 'a maybe = Nothing | Just of 'a
let safe_div (x: int) (y: int) : int maybe =
  if y = 0 then Nothing else Just (x/y)

(* 2. polymorphism = function works over multiple types *)
(* parametric = those multiple types are represented using a type parameter *)
(* algebraic data type + parametric polymorphism *)

(* side note: there can be multiple parameters *)
type 'a exception_bad = Error of 'a | Just of 'a
(* problem: the data carried by error must have the same type as Just *)
type ('e, 'a) myexception = Error of 'e | Just of 'a

(* Two perspectives on OCaml types:
   1. Types = sets
   2. Types = logical propositions *)

(* Perspective 1: types are sets *)
(* What can you do with sets:
   - check for membership relationship (manifested by simple type systems like lambda-plus')
   - check for subset relationship (need a more powerful types like subset types)
   - measure its size!
*)
type mybool = MyTrue | MyFalse
(* |mybool| = 2 *)
type myunit = MyUnitValue
(* |myunit| = 1 *)
type myvoid = |
(* |myvoid| = 0 *)
type color = Red | Green | Blue
(* |color| = 3 *)
type myint = MyZero | MySucc of myint
(* |myint| = inf = |Z| *)

type 'a idenitty = Id of 'a
(* |mybool myidentity| = ? *)
(* |myunit myidentity| = ? *)
(* |myint myidentity| = ? *)
(* |'a myidentity| = |'a| *)
type ('a, 'b) pair = Pair of 'a * 'b
(* |(myunit, myunit) pair| = 1 *)
(* |(mybool, myunit) pair| = 2 *)
(* |(mybool, mycolor) pair| = 6 *)
(* |(myvoid, myunit) pair| = 0 *)
(* |('a, 'b) pair| = |'a| * |'b| *)
type ('a, 'b) either = Left of 'a | Right of 'b
(* |(myunit, myunit) either| = 2 *)
(* |(mybool, myunit) either| = 3 *)
(* |(mybool, mycolor) either| = 5 *)
(* |(myvoid, myunit) pair| = 1 *)
(* |('a, 'b) either| = |'a| + |'b| *)
(* "algebraic" because "|" is like "+", and "*" is like "\times"  *)

type 'a mylist = MyNil | 'a * 'a mylist
(* |mybool mylist| = 1 + 2 + 4 + 8 + ... *)
(* Suppose |'a| = x. |'a mylist| = x^0 + x^1 + x^2 + x^3 + ... *)
(* list <-> the polynomial function f(x) = x^0 + x^1 + x^2 + x^3 + ... *)

(* in general, an algebraic data type (with k parameters) is equivalent to (<->) a polynomial function in k variables *)
(* Let 'x t1 <-> f(x), 'y t2 <-> g(y) *)

(* what can we do to polynomial functions? *)
(* addition: f(x) + g(y). What type corresponds to h(x,y) = f(x) + g(y) ? *)
(* multiplication: f(x) * g(y). What type corresponds to h(x,y) = f(x) * g(y) ? *)
(* taking derivative: f'(x). What type corresponds to h(x) = f'(x) ?
   answer: the zipper data structure: *)


(* Perspective 2: Interpreting OCaml types as logical propositions *)


(* There are two equivalent ways of defining two-argument functions *)

(* curried: *)
let add : int -> int -> int
  = fun x -> fun y -> x + y

(* uncurried: *)
let add': (int * int) -> int = fun (x,y) -> x+y

(* `curry` takes a uncurried function, and returns an equivalent curried function *)
let curry (f: ('a * 'b) -> 'c) : 'a -> 'b -> 'c =
  fun x -> fun y -> f (x,y)
(* The type looks like the proposition: ((A & B) -> C) -> (A -> B -> C) *)

(* `uncurry` takes a curried function, and returns an equivalent uncurried function *)
let uncurry (g: 'a -> 'b -> 'c) : ('a * 'b) -> 'c =
  fun xy -> 
    match xy with
    | (x, y) -> g x y
(* The type looks like the proposition: (A -> B -> C) -> ((A & B) -> C) *)

(* Those two propositions are valid: their truth tables only contain TRUE! *)

type ('a, 'b) p_and = | Both of 'a * 'b
(* Interpretation: 
   To prove A && B, we need to a proof of A and a proof of B *)

let curry (f: ('a, 'b) p_and -> 'c) : 'a -> 'b -> 'c =
  fun x -> fun y -> f (Both (x, y))

let uncurry (g: 'a -> 'b -> 'c) : ('a, 'b) p_and -> 'c =
  fun xy ->
    match xy with
    | Both (x,y) -> g x y

(* A && B -> B && A *)
let proof_that_and_is_commutative: ('a, 'b) p_and -> ('b, 'a) p_and =
  fun xy ->
    match xy with
    | Both (x, y) -> Both (y, x)

type ('a, 'b) p_or = Left of 'a | Right of 'b
(* Interpretation:
  To prove A || B, we need to either a proof of A, or a proof of B *)
(* this type is the same as myexception & either *)

(* A || B -> B || A *)
let proof_that_or_is_commutative: ('a, 'b) p_or -> ('b, 'a) p_or =
  fun x_or_y ->
    match x_or_y with
    | Left x -> Right x
    | Right y -> Left y

(* A && (B || C) -> A && B || A && C *)
let proof_that_and_is_distributive: ('a, ('b, 'c) p_or) p_and -> (('a, 'b) p_and, ('a, 'c) p_and) p_or =
  fun a__and__b_or_c ->
    match a__and__b_or_c with
    | Both (a, b_or_c) ->
      match b_or_c with
      | Left b -> Left (Both (a, b))
      | Right c -> Right (Both (a, c))

(* There is only one proof of TRUE *)
type p_true = | Obvious
(* this is the same as myunit *)

(* There is no proof of FALSE *)
type p_false = |
(* this is the same as myvoid *)

(* A -> TRUE *)
let proof_that_anything_implies_true: 'a -> p_true =
  fun _ -> Obvious

(* FALSE -> A *)
let proof_that_false_implies_anything: p_false -> 'a =
  fun f -> match f with | _ -> failwith "this branch is unreachable"

(* TRUE && FALSE -> FALSE *)
let proof_that_true_and_false_implies_false: (p_true, p_false) p_and -> p_false =
    fun t_f ->
      match t_f with
      | Both (t, f) -> proof_that_false_implies_anything f

(* "not A" is defined to be "A implies FALSE" *)
type 'a p_not = 'a -> p_false

(* Sanity check 1: not TRUE -> FALSE *)
let proof_that_not_true_implies_false : p_true p_not -> p_false =
  fun not_t ->
    not_t Obvious

(* Or equivalently *)
let not_not_true_is_provable : p_true p_not p_not =
  proof_that_not_true_implies_false

(* Sanity check 2: not FALSE *)
let not_false_is_provable: p_false p_not =
  proof_that_false_implies_anything

(* Sanity check 3: A -> not A -> FALSE *)
let contradiction: 'a -> ('a p_not) -> p_false =
  fun a ->
    fun not_a -> 
      not_a a

(* A -> not (not A) *)
(* which is A -> ((A -> FALSE) -> FALSE) *)
let proof_that_a_implies_not_not_a: 'a -> 'a p_not p_not =
  fun a ->
    (* want not (not A), which is (A -> FALSE) -> FALSE *)
    fun not_a -> contradiction a not_a

(* (A->B) -> (not B -> not A) *)
(* which is (A->B) -> ((B->FALSE) -> (A->FALSE)) *)
(* Example:
   If you've taken CS162, then you love OCaml
   <-> If you don't love OCaml, then you haven't taken CS162 
   I.e.,
   in an imaginary world where everyone who has taken CS162 loves OCaml,
   we know that anyone who doesn't love OCaml must haven't taken CS162. *)
let proof_of_contrapositive: ('taken -> 'love) -> ('love p_not -> 'taken p_not) =
  fun taken_implies_love ->
    fun not_love ->
      (* Want: not taken_cs162, which is taken_cs162 -> FALSE *)
      (fun taken ->
        (* Want: FALSE *)
        let love = taken_implies_love taken (* modus ponens <=> function application *)
      in contradiction love not_love)

(* The following three intuitive propositions are not provable! *)
(* let not_not_a_implies_a: 'a p_not p_not -> 'a =
  fun not_not_a -> ??? *)
(* let law_of_excluded_middle: ('a, 'a p_not) p_or = ??? *)
(* let de_morgans_law: ('a, 'b) p_or p_not -> ('a p_not, 'b p_not) p_and =
  fun not__a_or_b -> ??? *)

(* Curry-Howard correspondence *)
(* Type = Proposition *)
(* Program = Proof *)
(* Program P has type T = There is a constructive proof P for proposition T *)

(* Coq is a language with a type system strictly more powerful than OCaml's *)
(* You can encode any statement you want to prove into a type. Then you can write a functional program with that type.
   If your program type-checks, then you have a certificate that the statement is formally proven, and the proof has been mechanically verified by the type checker. *)
(* Catch: if the type system is so powerful, why don't we use it everywhere? 
   Answer: The type system is so powerful that the halting problem can be stated as a type.
   So type checking can't be fully automated (otherwise the halting problem would be decidable).
   As a consequence, programmers need to provide a lot of hints (aka type annotations) to the type checker, 
   which is too much for practical purposes.
   The typical ratio of program to annotation in Coq is usually 1/10. 
   I.e., every 1 line of code needs 10 lines of annotation.
   This is clearly impractical for most software systems. 
   However, the tradeoff may be worthwhile for safety-critical systems (like aviation/medical/finacial software).

   Mainstream functional languages usually use a much less powerful type system called System F (or Hindley-Milner),
   which is expressive enough that a lot of interesting and common properties can still be encoded and
   automatically checked, but not so expressive to encode the halting problem.
   *)