# Homework Assignment 4

**Due Monday, February 22 at 11:59 pm (pacific time)**

In this assignment, you will use OCaml to implement the type system of
λ<sup>+</sup>. You will need to refer to the latest version of the manual posted
on Gauchospace.

## Overview

* The files required for this assignment are located in this folder. In
  particular, you will need to implement the `typecheck` function in
  [`typecheck.ml`](typecheck.ml).
* This homework will be similar to the previous one, but will be simpler and
  shorter. You will need to write about 75 lines of code for this assignment.
  Most of it will be quite straightforward.
* To test your code, you can use the unit test helpers defined in `test.ml`.
  Create test cases by building derivation trees with pencil and paper. We will
  not be scoring how you test your code.

## Description

In this folder, you will be provided with an _updated_ version of the homework 3
files. **You should use these files instead of the homework 3 files to do this
assignment.**

### Type annotations

First, note that the typing rules only provide a method for proving that a given
expression has a given type. In a type checker, we are more interested in
_finding_ the type of an expression. To facilitate this, we must include type
annotations in lambdas, let expressions, and nil.

* Lambdas are now of the form `lambda x: T. e`, where `T` is the type of `x`.
* Let expressions are now of the form `let x: T = e1 in e2`, where `T` is the
  type of `x`.
* Nil is now of the form `Nil[T]`, where `T` is the type of the elements of the
  list.
* On the concrete syntax side, the `fun` syntax has changed so that it is now
  `fun f: TF with x1: T1, ..., xn: Tn = e1 in e2`, where `Ti` is the
  type of `xi` for each `i`, and `TF` is the type of the function `f`.

For example, the following are now valid λ<sup>+</sup> programs:

* `let f: Int -> Int = lambda x: Int. x + 5 in f 0`
* `fun f: List[Int] -> Int with l: List[Int] = if isnil l then 0 else !l in f Nil[Int]`

The type annotations are necessary because it would otherwise be difficult to
assign a type to an expression such as `Nil` or `lambda x. x`. It is possible to
write an algorithm to _infer_ the types needed; in fact, you will be
implementing type inference for homework assignment 5.

If you look in `ast.ml`, you will observe that the type annotations in `Let`,
`Lambda`, and `ListNil` are defined as `typ option`. For this assignment you can
assume that any expression that is not correctly annotated is ill-typed. For
example, your type checker is allowed to reject programs containing nils,
lambdas, and lets that do not have type annotations.

Although we will not be testing your `eval` function when grading this
homework, feel free to copy over your `eval.ml`. If you do, you will need to
slightly modify your code to account for the type annotations.

### What you need to do 

Of note is the new file, `typecheck.ml`. You will use the typing rules to
implement a `typecheck` function that, when given a typing environment and
expression, will either 1) return the type of the expression; or 2) raise a
`Type_error` if the expression is cannot be proven to be well-typed (reminder: a
type system may reject some "well-behaved" programs!).

You should construct your own test cases and test your type checker locally
(although we will not be grading your testing). Use the typing rules in
combination with your own intuition to construct well-typed and ill-typed
expressions. You can find unit test helpers in `test.ml`, and you can execute
unit tests with `make test`. For convenience, we have provided a `Dsl` module in
`ast.ml` that will help you concisely construct test cases, should you choose
to use it.

The reference interpreter also now includes a type checker (download the latest
version from Gauchospace). You can enable type checking by running `./lamp
-typed`.

**A note on the let rule**: technically, the `T-Let` rule as shown in the manual
allows ill-typed programs such as `let x = 10 in let f = lambda y. y + x in let
x = Nil[Int] in f 5` that redefine variables with `let`. For your own
satisfaction, you are allowed to add an additional condition to the let rule
that disallows redefinition. We will not be checking this edge case in the
autograder.

## Tips

* Start with the basics: implement the typing rules for integer, nil, and cons
  values. For type checking to be interesting, you will need values of different
  types.
* Move on to the arithmetic, inequality, equality, and if-then-else rules. Make
  sure that a type error is raised when e.g. adding a number to a list or
  comparing two expression of different types.
* Next, implement the `T-Var`, `T-Lambda`, and `T-App` rules.
* Now implement the rules for the list operations.
* Lastly, implement the `T-Let` rule.

## Submission and Scoring

**Note: the autograder will be set up later this week.**

Submit `typecheck.ml` on Gradescope, where an autograder will run your code on a
set of test cases. _You should test your code with your own test cases before
submitting it to the autograder. The autograder will only tell you if you are
missing anything; if you are failing some test cases, it will not tell you why.
Blindly guessing solutions will waste a lot of your time._

As outlined in the grading policy, your score for this assignment will be the
percentage of test cases passed, plus whatever additional credit is awarded to
you for partially correct solutions that demonstrate understanding of the course
material.

Some of the things we will be looking for during grading are:
* Your `typecheck` function correctly returns the type of a well-typed
  expression.
* Your `typecheck` function correctly raises a `Type_error` exception if the
  program is ill-typed.
