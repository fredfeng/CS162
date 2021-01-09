# Homework Assignment 1

**Due Monday, January 18, 2021 at 11:59pm (pacific time)**

In this homework assignment, you will use λ<sup>+</sup> to implement four
functions (3 involving linked lists, 1 involving basic recursion). The purpose
of this assignment is to help you get familiar with λ<sup>+</sup> so that you
will be able to implement an interpreter for it later. It will also help you
practice recursion, which will be vital for programming in OCaml.

## Submission

For each problem, place your solution in a separate file, with the following
format:

```
fun the_function with arg1, ..., argn =
  body_of_function
in
the_function
```

You may also use a `let` expression or any other expression as long as it
evaluates to a function.

Once you are done, turn in four files on Gradescope:
* `cat.lp`
* `rev.lp`
* `max.lp`
* `fib.lp`

Each problem will be tested using five test cases (not shown to you), for a
total of 20 test cases (hence 20 points total for this assignment). Your score
for this assignment will be the total number of test cases passed.

* Hint: you will need to use recursion in _all_ of these problems.
* You may assume that a linked list is "well-typed", i.e. it is always of the
  form `n1 @ n2 @ ... @ Nil` where each `n` is an integer and there is a `Nil`
  at the end of the list. However, you must check to ensure that any linked list
  produced by your submissions is also "well-typed".
* This homework should not take a long time to do. If you are struggling, please
  ask questions on Slack or come to office hours. In particular, let us know if
  you need additional practice with recursion.

## Problem 1 (5 points)

Implement a `cat` function that will concatenate two lists:
```
fun cat with l1, l2 =
  fill_this_out
in
cat
```

For example, `cat Nil Nil ` will evaluate to `Nil` and `cat (1 @ 2 @ Nil) (3 @ 4
Nil)` will evaluate to `1 @ 2 @ 3 @ 4 @ Nil`.

## Problem 2 (5 points)

Implement a `rev` function that will reverse a linked list. Hint: there are two
common ways to do this, but the easiest way is to use `cat` in Problem 1.
```
fun rev with l =
  fill_this_out
in
rev
```

For example, `rev (10 @ 1 @ 3 @ 4 @ Nil)` will evaluate to `4 @ 3 @ 1 @ 10 @ Nil`.

## Problem 3 (5 points)

Implement a `max` function that will find the largest element in a linked list.
```
fun max with l =
  fill_this_out
in
max
```

For example, `max (9 @ 3 @ 15 @ 5 @ Nil)` will evaluate to `15`.

## Problem 4 (5 points)

Implement a `fib` function that computes the `n`th Fibonacci number.
```
fun fib with n =
  fill_this_out
in
fib
```

Take `fib 0` to evaluate to `0` and `fib 1` to evaluate to `1`. For example,
`fib 10` will evaluate to `55`.

You can write the `fib` function in any way you would like, except if you
explicitly list out every single possible case (in which case you will receive
at most 2 points for this problem). You may assume that `0 <= n <= 30` for the
purposes of grading.
