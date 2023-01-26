# Homework Assignment 2

**Due Monday, Feb 6th, 2023 at 11:59pm (pacific time)**

This assignment has two parts. In the first part, you will implement some functions that manipulate infinite lists. In the second part, you will use λ<sup>+</sup> to implement three functions.

## Part 1

We will cover infinite lists in OCaml in [section 3](../../sections/sec03/README.md) (feel free to read ahead).

In what follows, we use the informal notation `[a; b; c; ...]` to refer to an infinite list containing `a`, `b`, `c`, and so on (note that we can't really write this in OCaml).

In `inf.ml`, we implemented provided the type definition of infinite lists:

```ocaml
type 'a inf = Cons of (unit -> ('a * 'a inf))
```
as well as a few examples of functions that operate over them (i.e., `cons`, `from`, and `map`). Your job is to implement the following functions. You may not use any OCaml library function except for `List.map`.

1. (1 pt) `val repeat : 'a -> 'a inf` takes an element `x` and returns an infinite list that only consists of `x`. 

    For example, `repeat 0` will return `[0; 0; 0; ...]`.

1. (2 pt) `val fib : int inf` represents the Fibonacci sequence, starting from 0 and 1. That is, `fib` will be `[0; 1; 1; 2; 3; 5; 8; 13; ...]`.

1. (2 pts) `val firstn : int -> 'a inf -> 'a list` returns the first `n` elements of an infinite list.
    
    For example, `firstn 3 fib` will return the OCaml list `[0; 1; 1]`.

1. (2 pts) `val interleave : 'a inf -> 'a inf -> 'a inf` will interleave the elements from two infinite lists. 
    
    For example, `interleave [0; 2; 4; ...] [1; 3; 5; ...]` will return `[0; 1; 2; 3; 4; 5; ...]`.

1. (2 pt) `val z : int inf` enumerates the integers as:
    ```ocaml
    [0; 1; -1; 2; -2; 3; -3; ...]
    ```
    Give a **non-recursive** definition of `z` using the stuff that has been already defined.

1. (2 pts) `val product : 'a inf -> 'b inf -> ('a * 'b) inf inf` will return the 2-dimensional product of two infinite lists. Give a **non-recursive** definition of `product` using the stuff that has been already defined.

    For example, if `xs` is `[0; 1; 2; ...]`, and `ys` is `['a'; 'b'; 'c'; ...]`, then `product xs ys` will look like
    ```ocaml
    [ 
      [(0,'a'); (0,'b'); (0;'c'); ...];
      [(1,'a'); (1,'b'); (1;'c'); ...];
      [(2,'a'); (2,'b'); (2;'c'); ...];
      ...
    ]
    ```
    

1. (2 pts) `val corner : int -> 'a inf inf -> 'a list list` returns the "top-left" corner of a 2-dimensional infinite list. Give a **non-recursive** definition of `corner` using the stuff that has been already defined.

    Using the example from `product`, the expression `corner 2 (product xs ys)` will evaluate to the following 2x2 corner:
    ```ocaml
    [
      [(0,'a'); (0,'b')];
      [(1,'a'); (1,'b')]
    ]
    ```

1. (2 pts) `val diag: 'a inf inf -> 'a inf` returns the diagonal entries of a 2-dimensional infinite list. 
    
    Using the example from `product`, the expression `diag (product xs ys)` will evaluate to
    ```ocaml
    [ (0,'a');
              (1,'b');
                     (2,'c');
                             ... ]
    ```


### Submission

Submit `inf.ml` on gradescope. You do not need to submit `inf.mli`.


---
## Part 2: λ<sup>+</sup>

The purpose of this part of the assignment is to help you get familiar with λ<sup>+</sup> so that you will be able to implement an interpreter for it later.

### Running the λ<sup>+</sup> interpreted

The interpreter is available at `~emre/lamp` on CSIL. You can either run it on CSIL or download it to run on another Linux computer.
If you are running the interpreter on your own computer and have issues, _you are on your own_.
So, make sure to test your programs on CSIL before thinking there is a problem with Gradescope or the λ<sup>+</sup> interpreter.

You can either use the read-eval-print-loop (REPL) where you can evaluate separate expressions by running the interpreter without any arguments:

```
% ~emre/lamp
Welcome to lambda+! Built on: Thu Jan 20 21:37:31 PST 2022
+settings: typecheck=off
> 1
<== 1
==> 1
> 1+1
<== 1 + 1
==> 2
> let f = lambda x. x * 2 in f 3
<== let f = lambda x. x * 2 in f 3
==> 6
> fun f with m = if m > 1 then m * (f (m - 1)) else 1 in f 6
<== let f = fix (lambda f. lambda m. if m > 1 then m * (f (m - 1)) else 1) in f 6
==> 720
```

On the session above, each line beginning with a `> ` is an expression we gave to the repl.  The line beginning with `<== ` is the expression the repl has parsed. Most of the time this is the same as the expression you write with parentheses to delimit sub-expressions. But we have some syntactic sugar (specifically, `fun FUNCTION with ARG1, ARG2, ... = BODY in EXPR_USING_FUNCTION` to denote recursive functions) which gets expanded to the abstract syntax of the language (it gets expanded to `let FUNCTION = fix (lambda FUNCTION. lambda ARG1. ... BODY) in EXPR_USING_FUNCTION`). For more details on this, please read the language manual.

Or, if you want to run a program from a file, you can give the file as an argument to `lamp` like `~emre/lamp my_program.lp`.



### Problem 1 (5 pts)

Implement a `take` function which, given a list `l` and a number `n`, return a list containing the first `n` elements of `l` (or return `l` if it has fewer than `n` elements):
```
fun take with n, l =
  fill_this_out
in
take
```

For example, `take 5 (1 @ 2 @ 3 @ 4 @ 5 @ 6 @ 7 @ 8 @ Nil)` will evaluate to `1 @ 2 @ 3 @ 4 @ 5 Nil` and `take 3 (1 @ 2 @ Nil)` will evaluate to `1 @ 2 @ Nil`.



### Problem 2 (5 pts)

Implement a function `get_smaller_than` that takes a number `n` and a list `l`, then returns all elements in `l` smaller than `n` in order:

```
fun get_smaller_than with n, l =
  fill_this_out
in
get_smaller_than
```

For example, `get_smaller_than 3 (1 @ 5 @ 3 @ 4 @ 2 @ 0 @ Nil)` would evaluate to `1 @ 2 @ 0 @ Nil` because 1, 2, and 0 are less than 3 (and appear in that order in the list) but none of the other elements in the input are.



### Problem 3 (5 pts)

Implement a function `largest_elems` that, given a list `l` containing lists of numbers, returns a list containing largest element from each list (if a list is empty, it will not have an element for that list).

```
fun largest_elems with l =
  fill_this_out
in
largest_elems
```

For example,
 - `largest_elems Nil` should evaluate to `Nil`.
 - `largest_elems ((1 @ 2 @ Nil) @ Nil)` should evaluate to `2 @ Nil`. (The given argument is a nested list, so we'd write it like `[[1; 2]]` in OCaml's friendlier syntax).
 - `largest_elems ((1 @ 2 @ Nil) @ Nil @ (4 @ 3 @ Nil) @ Nil)` should evaluate to `2 @ 4 @ Nil`. Using friendlier list syntax, the argument is the nested list `[[1; 2]; []; [4; 3]]` and `largest_elems` would return the list `[2; 4]` because the largest element in the first list is `2`, the second list doesn't have any elements, and the largest element in the third list is `4`.

*Hint*: You can write a helper like the max function you had from the previous homework, but you need to change it because lambda+ doesn't have `option`, and you need to handle empty lists carefully.
If you have helpers like these, you can define them in your program like this:
```
fun helper with arg1, arg2, ... =
  fill_this_out
in
fun largest_elems with l =
  fill_this_out
in
largest_elems
```


### Important notes
* Please make sure you have the latest version of `lamp` so that you do not
  encounter any weird bugs that we may have fixed. The homework assignment will
  be graded with the version of `lamp` compiled on **???**, which you will be able to copy to your machine from CSIL.
* You may assume that a linked list is "well-typed", i.e. it is always of the
  form `n1 @ n2 @ ... @ Nil` where each `n` has the same type and there is a `Nil`
  at the end of the list. However, you must check to ensure that any linked list
  produced by your submissions is also "well-typed".
* This part of the homework should not take a long time to do. If you are struggling, please
  ask questions on Slack or come to office hours.



### Submission

For each problem, place your solution in a separate file, with the following
format:

```
fun the_function with arg1, ..., argn =
  body_of_function
in
the_function
```

You **must** use this format or your submission may fail to pass a few test
cases. A template is provided to you for each problem.

Once you are done, turn in the following files on Gradescope:
* `take.lp`
* `get_smaller_than.lp`
* `largest_elems.lp`


## Part 3: Bonus Questions

It turns out we can model a lot of interesting stuff with infinite lists. The following bonus questions illustrate a few possibilities.

### Bonus Question 1: Turing Completeness

(2 pts) A language is *Turing complete* if it can simulate arbitrary Turing machines. Fill the missing parts in `turing.ml` to simulate Turing machines and show OCaml is Turing-complete. Next, come up with a concrete Turing machine of your choice, and simulate it on the empty tape.


### Bonus Question 2: Small Infinities

1. (1 pt) Each rational number can be represented as a pair of integers `(a, b)`. One of the many possible representation schemes is the following:
  
    - Whole numbers are presented by integers `a` and `b=1`. For example, `0/1` represents `0`, `1/1` represents `1`, `-2/1` represents `-2`, and so on.
    - Fractions are represented by a non-zero integer `a` and a positive integer `b` such that they have no common divisors.

    Implement `is_rational: int * int -> bool` that determines whether a pair of integers is a valid representation of a rational number according to this representation scheme.

    Then, implement `q: (int * int) inf inf` that contains all the rational numbers represented in this way. The order does not matter, as long as each rational number appears exactly once somewhere in the list.

2. (2 pts) Implement `inject: 'a inf inf -> 'a inf` that turns a 2-dimensional infinite list into a 1-dimensional infinite list, such that every element in the input appears exactly once in the output. [*Hint.*](https://www.geneseo.edu/~aguilar/public/notes/Real-Analysis-HTML/figures/cantor-snake.svg)



### Bonus Question 3: Big Infinities

Given a set S, the *power set* of S is the set of all subsets of S. For example, let's say S is represented by the list `[0;1;2]`. Then its power set can be represented as
```ocaml
[ []; [0]; [1]; [2]; [0;1]; [0;2]; [1;2]; [0;1;2] ]
```
Note that the empty set, represented by `[]`, is always in the power set of any set. (As an exercise, you might want to implement the power set function for finite lists/sets.)

The same notion of power sets applies even if S is infinite, with one distinction: a subset of S can be either finite or infinite. For example, consider `nat`, which represents the set of all natural numbers $\mathbb{N}$.
- An example of a finite subset of $\mathbb{N}$ is $\{2, 3\}$, represented in OCaml as `[2;3]` of type `int list`.
- An example of an infinite subset of $\mathbb{N}$ is the set of all even natural numbers, represented in OCaml by the infinite list `even`, which has type `int inf`.

In what follows, you will implement the power set function for each case separately.

1. (2 pts) Implement `pow_fin: 'a inf -> 'a list inf` that will take a list representing an infinite set, and enumerate all of its finite subsets. The order of enumeration doesn't matter, as long as each finite subset appears exactly once somewhere in the output. For example, one possible enumeration of `nat` can be
    ```ocaml
    [ []; [0]; [1]; [0;1]; [2]; [0;2]; [1;2]; [0;1;2]; ... ]
    ```

2. (100 pts) Implement `pow_inf: 'a inf -> 'a inf inf` that will take a list representing an infinite set, and enumerate all of its infinite subsets. The order of enumeration doesn't matter, as long as each infinite subset appears exactly once somewhere in the output. For example, one possible enumeration of `nat` can be
    ```ocaml
    [ nat; even; odd; primes; ... ]
    ```

### Submission
There won't be autograder tests for any of these questions. Please talk to the TAs after the due date; they'll grade your solutions manually.