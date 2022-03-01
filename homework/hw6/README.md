# Homework Assignment 6

**Due Friday, March 11 at 11:59 pm (pacific time)**

In this assignment, you will use OCaml to implement a simplified version of
Hindley-Milner type inference for λ<sup>+</sup>. You will need to refer to the
latest version of the manual posted on Gauchospace.

## Overview

* The files required for this assignment are located in this folder. In
  particular, you will need to implement the constraint generation `gen_cons`
  and the unification function `unify_helper` in
  [`typeinfer.ml`](typeinfer.ml). We provide a wrapper around `unify_helper`
  named `unify`. You don't need to modify this function at all, we provide it so
  that both the result of `unify` and the result of `type_infer` are fully
  substituted.
* **When you need to do unification recursively inside `unify_helper`, you
  should call `unify_helper` to satisfy the OCaml compiler.**  (If you want, and
  if you are comfortable with `let rec ... and ...` syntax in OCaml, you can
  also use the `let rec unify_helper = ... and unify = ...` to merge the
  definitions, and call `unify` directly).
* Most of the code for this assignment (including the "boilerplate" constraint
  typing rules) will be provided to you, with the crucial and interesting parts
  missing. While you will not have to write too much code (~90 lines), the
  concepts used in this assignment will be more involved compared to the
  previous assignment. If you do not understand the concepts that well, this
  assignment will be challenging to do (in which case you should go to office
  hours / ask questions).
* To test your code, you can use the unit test helpers defined in
  [`test.ml`](test.ml). Create test cases by generating constraints and solving
  them with pencil and paper. We will not be scoring how you test your code.

## Description

In this folder, you will be provided with an _updated_ version of the homework 5
files. **You should use these files instead of the homework 5 files to do this
assignment,** but feel free to copy over your `eval.ml` (with modifications) and
`typecheck.ml` from the previous assignments.

There are two parts to this homework, which are you advised to do in order:
constraint generation and constraint solving.

### Alternate type AST

Since we must introduce type variables, we have defined a new algebraic data
type called `ityp` (located in `typeinfer.ml`), or types used in type inference.
You should use `ityp` instead of `typ` in this assignment.

### Constraint generation

First, you should complete the `gen_cons` function used to generate typing
constraints. Your `gen_cons` must take type annotations into account. For
example, you should use type annotations if they are provided (e.g. such as in
`lambda x:Int. x`), or generate type variables if they are not.

The `Context.t` data type contains the typing environment, the set of generated
constraints, and a counter used for generating fresh variables. Operations used
on `Context.t`s are defined in the `Context` module. Like the other data
structures in OCaml, `Context.t` is immutable: if you want to modify it, you
must construct a copy with the desired modifications. For example,
`Context.add_eqn t1 t2 ctx` will return a _copy_ of `ctx` that has the
additional constraint `t1 = t2`.

### Constraint solving

Next, you should implement the unification algorithm in the `unify_helper`
function.  You can find the unification algorithm in the lecture slides/videos
or in Chapter 22 of _Types and Programming Languages_. You are also allowed to
use, change, or delete the predefined helper functions as you wish, as long as
your implementation produces the correct solutions.

You do not need to ensure that all type variables are concrete, but you do need
to ensure that the variables are "fully substituted." For example, if
`unify_helper` is provided the following set of constraints:

```plain
X0 = List X1
X2 = Int
```

then the following solution is acceptable as an answer because `X1` is
legitimately a "free variable" in the RHS of the equations:

```plain
X0 => List X1
X2 => Int
```

However, if the provided constraints are:

```plain
X0 = List X1
X0 = List X2
X3 = X1 -> X4
```

then your solution should be:

```
X0 => List X1
X2 => X1
X3 => X1 -> X4

OR

X0 => List X2
X1 => X2
X3 => X2 -> X4
```

but not:

```
X0 => List X2
X2 => X1
X3 => X1 -> X4
```

because `X2` is not a free variable with respect to the substitution, i.e. it is
"bound" in the substitution.

### Testing your code

* You should construct your own test cases and run your own tests locally
(although we will not be grading your testing).
* You can find unit test helpers in `test.ml`, and you can execute unit tests
  with `make test`. For convenience, we have provided a `Dsl` module in `ast.ml`
  that will help you concisely construct test cases, should you choose to use
  it.
* **Make sure you test your constraint generation and your unification
  separately.** If you generate incorrect constraints, your unification will not
  produce the correct answers ("garbage in, garbage out"). Likewise, if your
  unification is incorrect, you will obviously get the wrong answers.
* Afterwards, you should test your constraint generation and unification
  together, so that you can get a sense of how well they do as an actual type
  inference procedure (which is the goal of this assignment).
* Be careful when implementing unification; it is easy to end up with infinite
  recursion. In particular, you *must* implement the occurs check *correctly* or
  you will hang the autograder and get a score of zero.
* The reference interpreter also now includes type inference (download the
  latest version from Gauchospace). You can enable type inference by running
  `./lamp -tyinf`. If you would like to run the interpreter with your own
  implementation, use `make run`.

## Submission and Scoring

Submit `typeinfer.ml` on Gradescope, where an autograder will run your code on a
set of test cases. _You should test your code with your own test cases before
submitting it to the autograder. The autograder will only tell you if you are
missing anything; if you are failing some test cases, it will not tell you why.
Blindly guessing solutions will waste a lot of your time._

As outlined in the grading policy, your score for this assignment will be the
percentage of test cases passed, plus whatever additional credit is awarded to
you for partially correct solutions that demonstrate understanding of the course
material.

Some of the things we will be looking for during grading are:
* Your `gen_cons` function generates constraints that, when run through a
  unification algorithm, will correctly infer the type of an expression.
* You `gen_cons` function correctly handles user-provided type annotations.
* Your `unify_helper` function will correctly solve a given set of constraints,
  or raise an error message otherwise (e.g. if it attempts to unify two
  "unequal" types).
* Your `gen_cons` and `unify_helper` functions can be used together to correctly
  infer types for a variety of well-typed expressions or correctly reject a
  variety of ill-typed expressions.

Note: if you do not implement the occurs check correctly in your `unify_helper`,
you may easily end up with an infinite loop--in which case the autograder will
time out and assign you a score of zero. Take extra care to ensure that your
occurs check is _implemented and correct_ before you submit.
