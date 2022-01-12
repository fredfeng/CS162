# Homework Assignment 1

**Due Thursday, January 20, 2021 at 11:59pm (pacific time)**

In this homework assignment, you will use OCaml to implement six functions. The
purpose of this assignment is to help you get familiar with programming in OCaml.

## Submission

Complete each problem in the `.ml` files in this folder. Once you are done, turn
them in on Gradescope.

**Important notes**:
* You are **not** allowed to use in built-in OCaml functions for any of the 
  problems. If you do, you will not be awarded any points. Exception: you may 
  use `List.hd` and `List.tl`. However, be wary of edge cases if you do.
* Because you are learning a new programming language and using features that
  may be unfamiliar to you, we recommend that you start early on this homework.
* This homework should not take a long time to do. If you are struggling, please
  ask questions on Slack or come to office hours. In particular, let us know if
  you need additional practice with recursion.
* The problems were designed so that you'll only need to write 5-15 lines of
  code for each one.
* Pattern matching and recursion will need to be used in each problem.
* Reminder: you should use `=` to check for equality, because `==` will not 
  work as you will expect.
* You can test your code by running `ocaml` or `utop` to get a REPL, loading
  your file with `#use filename.ml ;;`, and manually entering some test cases.
  If you are willing to put in some additional work, you could also set up unit
  tests using a package like [Alcotest](https://github.com/mirage/alcotest).



## Problem 1 (5 points)

| File                         | Goal of this exercise          |
| ---------------------------- | ------------------------------ |
| [`fib.ml`](fib.ml)           | Practice basic recursion.      |

Implement a function `fib : int -> int` that computes the `n`th Fibonacci number.

Take `fib 0` to evaluate to `0` and `fib 1` to evaluate to `1`. For example,
`fib 10` will evaluate to `55`.

You may write the `fib` function in any way you would like, except if you
explicitly list out every single possible case (in which case you will receive
at most 2 points for this problem). You may assume that `0 <= n <= 30` for the
purposes of grading.



## Problem 2 (5 points)

| File                         | Goal of this exercise          |
| ---------------------------- | ------------------------------ |
| [`max.ml`](max.ml)           | Practice recursion on lists.   |

Implement a function `max: int list -> int option` that will either find the largest element in a non-empty list, or will return `None` if the list is empty.

For example, `max [9; 3; 15; 5]` will evaluate to `Some 15`.



## Problem 3 (5 points)

| File                         | Goal of this exercise          |
| ---------------------------- | ------------------------------ |
| [`cat.ml`](cat.ml)           | Practice recursion on lists.   |

Implement a function `cat: 'a list -> 'a list -> 'a list` that will concatenate two lists.

For example, `cat [1; 2] [3; 4]` will evaluate to `[1; 2; 3; 4]`.



## Problem 4 (5 points)

| File                         | Goal of this exercise          |
| ---------------------------- | ------------------------------ |
| [`rev.ml`](rev.ml)           | Practice recursion on lists.   |

Implement a function `rev: 'a list -> 'a list` that will reverse a list.

For example, `rev [10; 1; 3; 4]` will evaluate to `[4; 3; 1; 10]`.



## Problem 5 (5 points)

| File                         | Goal of this exercise          |
| ---------------------------- | ------------------------------ |
| [`compress.ml`](compress.ml) | Practice basic tasks in OCaml. |

Implement a function `compress : ’a list -> ’a list` that takes a list and
returns a new list with all consecutive duplicate elements removed. For example:

```ocaml
# compress ["a";"a";"a";"a";"b";"c";"c";"a";"a";"d";"e";"e";"e";"e"];;
- : string list = ["a"; "b"; "c"; "a"; "d"; "e"]
```



## Problem 6 (10 points)

| File                   | Goal of this exercise                                |
| ---------------------- | ---------------------------------------------------- |
| [`arith.ml`](arith.ml) | Practice pattern matching and symbolic manipulation. |

Given the data type `expr` of arithmetic expressions, implement the `simplify`
function that will simplify arithmetic expressions. In particular:

* Operations on constants should be simplified, e.g. `1 + (1 * 3)` is simplified
  to `4`.
* Addition and multiplication identities should be simplified, e.g. `1 * (x +
  0 + (5 * 0))` is simplified to `x`. Specifically, you need to handle addition
  by 0, multiplication by 0, and multiplication by 1.
* All other combinations of addition and multiplication should be left as-is.
  For example, you do not need to distribute multiplication (e.g. you should
  leave `2 * (x + 1)` as-is). You should leave expressions such as `x + (2 * x)`
  as-is.

Although `Nat` is defined as carrying an `int`, you may assume that all `Nat`s
are carrying non-negative numbers.

Example:
```
# simplify (Add (Var "x", Add (Var "x", Mul(Nat 1, Add(Nat 0, Var "y")))));;
- : expr = Add (Var "x", Add (Var "x", Var "y"))
```