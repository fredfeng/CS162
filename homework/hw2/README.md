# Homework Assignment 2

**Due Thursday January 27, 2022 at 11:59pm (pacific time)**

In this homework assignment, you will use λ<sup>+</sup> to implement three
functions. The purpose
of this assignment is to help you get familiar with λ<sup>+</sup> so that you
will be able to implement an interpreter for it later. It will also help you
practice recursion which will be vital for programming the upcoming assignments.

Note: We will set up Gradescope later this week. In the meantime, you can get started by downloading the language manual from GauchoSpace and reading it, and start using the interpreter and writing your own tests to do the assignment.

## Submission

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

Each problem will be tested using five test cases (not shown to you), for a
total of 15 test cases (hence 15 points total for this assignment). Your score
for this assignment will be the total number of test cases passed. Gradescope
will automatically grade your submissions and show you your score.

**Important notes**:
* Hint: you will need to use recursion in _all_ of these problems.
* Please make sure you have the latest version of `lamp` so that you do not
  encounter any weird bugs that we may have fixed. The homework assignment will
  be graded with the version of `lamp` compiled on Thu Jan 20 21:37:31 PST 2022, which you will be able to copy to your machine from CSIL.
* You may assume that a linked list is "well-typed", i.e. it is always of the
  form `n1 @ n2 @ ... @ Nil` where each `n` has the same type and there is a `Nil`
  at the end of the list. However, you must check to ensure that any linked list
  produced by your submissions is also "well-typed".
* This homework should not take a long time to do. If you are struggling, please
  ask questions on Slack or come to office hours. In particular, let us know if
  you need additional practice with recursion.

## Running the λ<sup>+</sup> interpreted

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

## Problem 1 (5 points)

Implement a `take` function which, given a list `l` and a number `n`, return a list containing the first `n` elements of `l` (or return `l` if it has fewer than `n` elements):
```
fun take with n, l =
  fill_this_out
in
take
```

For example, `take 5 (1 @ 2 @ 3 @ 4 @ 5 @ 6 @ 7 @ 8 @ Nil)` will evaluate to `1 @ 2 @ 3 @ 4 @ 5 Nil` and `take 3 (1 @ 2 @ Nil)` will evaluate to `1 @ 2 @ Nil`.

## Problem 2 (5 points)

Implement a function `get_smaller_than` that takes a number `n` and a list `l`, then returns all elements in `l` smaller than `n` in order:

```
fun get_smaller_than with n, l =
  fill_this_out
in
get_smaller_than
```

For example, `get_smaller_than 3 (1 @ 5 @ 3 @ 4 @ 2 @ 0 @ Nil)` would evaluate to `1 @ 2 @ 0 @ Nil` because 1, 2, and 0 are less than 3 (and appear in that order in the list) but none of the other elements in the input are.

## Problem 3 (5 points)

Implement a function `largest_elems` that, given a list `l` containing lists of numbers, returns a list containing largest element from each list (if a list is empty, it will not have an element for that list).

```
fun largest_elems with l =
  fill_this_out
in
rev
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
