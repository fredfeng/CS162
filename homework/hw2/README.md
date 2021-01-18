# Homework Assignment 2

**Due Monday, January 25, 2021 at 11:59pm (pacific time)**

In this homework assignment, you will use OCaml to implement four functions. The
purpose of this assignment is to help you get familiar with programming in OCaml
and with the helper functions in lambda calculus.

## Submission

Complete each problem in the `.ml` files in this folder. Once you are done, turn
them in on Gradescope.

**Important notes**:
* You can test your code by running each file in `ocaml` or `utop` and manually
  entering some test cases. If you are willing to put in some additional work,
  you could also set up unit tests using a package like
  [Alcotest](https://github.com/mirage/alcotest).
* Because you are learning a new programming language and using features that
  may be unfamiliar to you, we recommend that you start early on this homework.
* In terms of time, this homework will take longer to do than homework 1 but not
  a substantially larger amount of time (e.g. it should not take a whole day to
  do HW 2). If you are struggling, please ask questions on Slack or come to
  office hours.
* The problems were designed so that you'll only need to write 5-15 lines of
  code for each one.
* Pattern matching and recursion will need to be used in each problem.
* Reminder: you should use `=` to check for equality, because `==` will not work
  as you will expect.

## Problem 1 (5 points)

| File          | Goal of this exercise          |
| -----------   | ------------------------------ |
| `compress.ml` | Practice basic tasks in OCaml. |

Implement a function `compress : ’a list -> ’a list` that takes a list and
returns a new list with all consecutive duplicate elements removed. For example:

```ocaml
# compress [“a”;“a”;“a”;“a”;“b”;“c”;“c”;“a”;“a”;“d”;“e”;“e”;“e”;“e”];;
- : string list = [“a”; “b”; “c”; “a”; “d”; “e”]
```

You are **not** allowed to use in built-in OCaml functions for this problem. If
you do, you will not be awarded any points for completing this problem.

## Problem 2 (10 points)

| File          | Goal of this exercise                                |
| ---------     | ---------------------------------------------------- |
| `simplify.ml` | Practice pattern matching and symbolic manipulation. |

Given the data type of arithmetic expressions in `expr.ml`, implement the
`simplify` function that will simplify arithmetic expressions. In
particular:

* Operations on constants should be simplified, e.g. `1 + (1 * 3)` is simplified
  to `4`.
* Addition and multiplication identities should be simplified, e.g. `1 * (x +
  0 + (5 * 0))` is simplified to `x`. Specifically, you need to handle addition
  by 0, multiplication by 0, and multiplication by 1.

Although `Nat` is defined as carrying an `int`, you may assume that all `Nat`s
are carrying non-negative numbers.

## Problem 3 (5 points)

| File    | Goal of this exercise     |
| ------- | ------------------------- |
| `lc.ml` | Practice lambda calculus. |

Using the [`Set`](https://caml.inria.fr/pub/docs/manual-ocaml/libref/Set.S.html)
data structure, implement the `free_vars` function used to compute the set of
free variables in a lambda calculus expression. Refer back to the slides in
Lecture 3 for some examples.

For convenience, we have defined for you a `StrSet` type (i.e. a set of
strings). Some of the functions which you may find useful are:
* `StrSet.mem x s`: returns `true` iff `x` is a member of the set `s`
* `StrSet.diff s1 s2`: returns a set consisting of the elements of `s1` with all
  elements of `s2` removed.
* `StrSet.singleton x`: returns a set containing exactly one string `x`.
* `StrSet.union s1 s2`: returns the union of `s1` and `s2`.

## Problem 4 (10 points)

| File     | Goal of this exercise     |
| -------- | ------------------------- |
| `lc.ml`  | Practice lambda calculus. |

Using the `free_vars` function in Problem 3, implement the `subst` function for
substituting a variable with an expression. You can find this function on slide
9 of the Lecture 3 slides.

* You do not need to implement alpha renaming for this assignment. Instead, in
  the case of `[x -> s](\y. t1)` when `y` is a free variable in `s`, you should
  `raise` a `Capturing` exception and indicate the variable that is being
  captured. For example, `subst "y" (Lam("x", Var("y"))) (Var("x"))` should
  trigger a `Capturing("x")` exception.
* You still need to account for the other capturing case when substituting. For
  example, `subst "x" (Var("y")) (Lam("x", Var("x")))` should evaluate to `(Lam("x",
  Var("x")))`.

Example:
```ocaml
# subst "x" (Lam("y", Var("y"))) (Lam("z", App(Var("x"), Var("z"))))
- : expr = Lam ("z", App (Lam ("y", Var "y"), Var "z"))
```
