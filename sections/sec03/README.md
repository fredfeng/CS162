# Section 3

## Fun with Infinity
You have seen how linked lists can be modeled using data types in OCaml:

```ocaml
type 'a list = Nil | Cons of 'a * 'a list
```

That is, a linked list is either empty (represented by the `Nil` constructor) or contains a piece of data of type `'a` and a tail which is another linked list (represented by the `Cons` constructor).

This definition allows us to construct lists of arbitrary lengths. But what about infinite-length lists? Clearly, we don't need the `Nil` case anymore, since infinite lists can't possibly be empty. So we might be tempted to define them as:
```ocaml
type 'a inf = Cons of 'a * 'a inf
```

That is, an infinite list has a head, followed by another infinite list. But we can't really construct infinite lists using `Cons`. Suppose we want to construct the list of natural numbers. If we invoke `Cons`, we would need to provide the head (which is just `0`), and a tail of natural numbers greater than `0`, which is also constructed using `Cons`. And this tail starts with `1`, and has another tail (of integers greater than `1`) also constructed from `Cons`. So we would end up writing
```ocaml
Cons (0, (Cons (1, (Cons (2, (Cons (3, ...)))))))
```
which is an infinite expression. Unfortunately, our programs must be finite. So this definition of infinite lists doesn't really work.

The key to addressing this difficulty is *finding a finite representation for something infinite*. In fact, we have already seen an example of this--namely, recursive functions. A recursive function is a finite representation of a potentially infinite process, since you can easily write infinite recursion using a finite definition like:

```ocaml
let rec diverge (x: int) : int = 1 + diverge x in
diverge 0
```

Although infinite recursion is usually bad, it's actually exactly what we need to represent infinite lists: an infinite list can be precisely captured by a finite, recursive method of computing -- or, **generating** -- every element in the list. For example, the list of Fibonacci numbers is clearly infinite. But by saying that every element can be generated as the sum of the previous two elements, we have effectively represented the infinite Fibonacci sequence using a finite computation method. Using this method, we can theoretically compute every possible Fibonacci number given enough time.

Let's try to apply this idea to define the list of natural numbers. Instead of explicitly enumerating every element of the list using `Cons`, we can define it just like a recursive function.

Before doing so, let's first rephrase the notion of natural numbers slightly: it is a list of integers no less than `0`. Since the threshold `0` is kind of arbitrary, let's instead define a generic helper function `from` that generates all integers greater than or equal to an arbitrary threshold `n` (we can easily derive the list of natural numbers from this helper function):

```ocaml
let rec from (n: int): int inf = Cons (n, from (n+1))
```

That is, the recipe for generating an infinite list of integers no less than `n` is that, we first generate `n`, and then we recursively generate the the integers no less than `n+1`.

This definition is almost good, execpt that it will run forever. If you type `from 0` into `utop`, you will get

```ocaml
# from 0;;
Stack overflow during evaluation (looping recursion?).
```

This is kind of expected, since our recursive function neither has a base case nor attempoints to decompose a big problem into smaller sub-problems. In fact, running `from 0` makes the interpreter constructing the same infinite expression that we previously tried to write down:
```ocaml
(* Evaluation trace:
from 0
===> Cons (0, from 1)
===> Cons (0, Cons (1, from 2))
===> Cons (0, Cons (1, Cons (2, from 3)))
...
*)
```

It may not seem so, but we have actually made progress! We are now able to encode an infinite list using a *finite* expression in OCaml, albeit statically. It just so happens that we can't do anything useful with this expression during runtime, since running it results in an infinite loop in which the interpreter tries to compute every element in the list.

Fortunately, we don't actually need the concrete value of every element in an infinite list all at once in order to do something useful. Because we've got a recipe for generating everything in the list, we can lazily compute the elements on the fly, only when we need them. For instance, if we want to write a function that returns the first 3 elements of an infinite list, we really only need to invoke the recipe three times to compute the first three elements, while safely disregarding the rest.

The above observation -- that we don't want the interpreter to eagerly generate the entire list since we usually don't need it -- leads us to the final piece of the puzzle. What we really want is a mechanism to *stop the interpreter from being too eager*: once it generates an element, it should immediately hand the element back to us (so that we can do some quick calculation), while it pauses/suspends generating the remaining stuff *unless we specifically ask it to resume again*.

Luckily, there's a neat trick to do so: wrapping potentially diverging computation under an *anonymous function*. Consider the `diverge` function which we defined a while ago:
```ocaml
let rec diverge (x: int) : int = 1 + diverge x
```

Trying to evaluate the following expression `diverge 0` led to infinite recursion:

```ocaml
# let bad = diverge 0;;
Stack overflow during evaluation (looping recursion?).
```

However, the evaluation of the following expression terminates!
```ocaml
# let not_bad_yet = fun () -> diverge 0;;
- : unit -> int = <fun>
```
We wrapped the diverging expression (`diverge 0`) inside an anonymous function (that takes a unit value as the argument). The reason evaluating this expression terminates is that the interpreter can't really do anything about a function until it is applied to some arguments. So `not_bad_yet` will manifest its badness until invoke it on the unit value:

```ocaml
# let bad_again = not_bad_yet ();;
Stack overflow during evaluation (looping recursion?).
```

This is exactly the last mechanism we need handle infinite lists! Instead of
```ocaml
let rec from (n: int) : int inf = Cons (n, from (n+1))
```
which diverges immediately, we can *suspend* the infinite computation using the same function-wrapping trick:
```ocaml
let rec from (n: int) = Cons (fun () -> (n, from (n+1)))
```

That is, we are now representing infinite lists using a piece of suspended computation. If we ask the computation to be resumed (i.e., by applying the anonymous function to the unit value `()`), it will return (1) the first element in the infinite list, and (2) another piece of suspended computation that will eventually compute the remaining tail, if we ask for it. In other words, `from` is lazy now. If we ask for the whole infinite list, it will grudgingly give us the first item, and throws its hands up, refusing to give us the next item unless we ask again.

Of course, the above definition of `from` doesn't type check anymore, since `Cons` now takes a function instead of a pair as its input. So we need to go back and modify the type accordingly:
```ocaml
(* Compared to previously:
   type 'a inf = Cons of ('a * 'a inf) *)
type 'a inf = Cons of (unit -> ('a * 'a inf))
```

We can trace the execution of `from 0` to see the first two rounds of interaction between us and the lazy `from`:
```ocaml
# let nat = from 0 in
  match nat with
  | Cons sus ->
    (* round 1 *)
    let unsus = sus () in
    match unsus with
    | (a, nat') ->
    print_int a;
    match nat' with
    | Cons sus' ->
      (* round 2 *)
      let unsus' = sus' () in
      match unsus' with
      | (b, nat'') ->
      print_int b;
      print_string "\n";
      nat'';;
```

You'll see
```ocaml
01
- : int inf = Cons <fun>
```
since we asked for the first two natural numbers (using `sus ()` and `sus' ()`). We also get  as the return value a piece of suspended computation (`nat''`) that will give us the remaining natural numbers 2, 3, 4, ...

> 💡 It might be helpful to work out the type of each variable (`nat`, `sus`, `unsus`, `a`, etc.) in above code snippet.