# Homework Assignment 3

**Due Wednesday, February 3 at 11:59 pm (pacific time)**

In this assignment, you will use OCaml to implement the big-step operational
semantics of λ<sup>+</sup>. You will need to refer to the manual posted on
Gauchospace.

## Overview

* The files required for this assignment are located in this folder. In
  particular, you will need to write all your code in [`eval.ml`](eval.ml).
  There will be three functions you will need to implement: `free_vars`,
  `subst`, and `eval`.
* This homework is expected to take a long time, so **start early**. For
  reference, the reference interpreter took the TA (who is experienced in
  functional programming) about 2-3 hours to implement. If you are new to OCaml
  and functional programming, you should expect this assignment to take at least
  4 times the amount of time it took to complete HW2. You should either 1) spend
  some time every day completing parts of this assignment; or 2) ensure that you
  have enough time to complete it in one sitting.
* You will need to write about 150 lines of code for this assignment. However,
  you will realize (as you are writing the code) that most of it is repetitive.
* Reminder: you have 10 penalty-free late days for this course. This assignment
  would be the best one to use them on.
* To test your code, you can either compare your output against the reference
  interpreter or use the unit test helpers defined in `test.ml`. We will not be
  scoring how you test your code. Note that the reference interpreter has been
  updated again, so please download the latest version from Gauchospace.

### Setting up

For this assignment, you will need to have `opam` installed. Once it is
installed, copy this folder somewhere and open it in a terminal. Install the
required OCaml dependencies using:

```
opam install --deps-only --with-test .
```

The files are set up to be built with the [`dune` build
tool](https://dune.readthedocs.io/en/stable/), which the above command will help
install for you.
* Run `make` to compile your code. This just invokes `dune build` to compile the project.
* Run `make test` to compile and execute the unit tests located in `test.ml`.
* Run `make dist` to compile the interpreter and copy it to `./lamp`.
* Run `make run` to compile and execute the interpreter.

`dune` conveniently has a feature to automatically recompile/retest your code
whenever you make a change. To use it, run `dune build --watch` or `dune
runtests --watch`, respectively.

### Organization of the code

In this folder, you will be provided a version of the reference interpreter
source code without the evaluation part implemented. The files are:
* [`ast.ml`](ast.ml): Contains the AST definition and some helper functions.
* [`parser.mly`](parser.mly) and [`scanner.mll`](scanner.mly): Contains the
  parser and scanner definitions. You do not need to look these files, but you
  are welcome to if you are interested in how parsing works.
* [`eval.ml`](eval.ml): This is the file which you will need to complete for this assignment.
* [`repl.ml`](repl.ml): Contains the code for the interpreter executable.
* [`test.ml`](test.ml): Contains some sample unit tests.

## What you need to do

The main goal is to translate the evaluation rules provided to you in the
lectures/handout into OCaml code. Do this in the `eval` function. To deal with
function application, you will also need to implement the `free_vars` and
`subst` functions, which are like extended versions of the functions you
implemented in Homework 2.

If no evaluation rule matches, you should raise a `Stuck msg` exception, where
`msg` is some error message indicating why evaluation got stuck. You can use
whatever you want as a message as long as the exception is raised in the
appropriate locations. A helper function `im_stuck "message"` is provided to
make it easier to raise the exception.

Unlike Homework 2, you will need to implement alpha renaming for this
assignment. To be consistent with the autograder, whenever you need to
alpha-rename some argument `y` of an abstraction `\y. e`, you should rename `y`
to `yn` where `n` is the smallest natural number such that using `yn` as an
argument will not capture any variables. For example, `(\x. \y. x y) (\x. y)`
will evaluate to `(\y0. x (\x. y))`.

Some of the things we will be looking for during grading are:
* Your `eval` function evaluates expressions to the correct values, as described
  by the manual.
* Your `eval` function correctly raises a `Stuck` exception if no evaluation
  rule matches.

## Tips

* This assignment may seem overwhelming, but it is really just a collection of
  small tasks.
* You should start by implementing the `Int`, `Arith`, `PredTrue`, and
  `PredFalse` rules. These will be simple and repetitive, and somewhat similar
  to `simplify` from Homework 2, but will get you warmed up. Test them out and
  make sure they do what you expect before you move on.
* Next, implement the `IfTrue` and `IfFalse` rules.
* Now implement the `Let` and `Var` rules.
* The various list rules should be easy for you to implement if you managed to
  do the above successfully.
* Lastly, implement the `Lambda` and `App` rules, which are the most complex
  implementation wise. In the process, you will need to implement `free_vars`
  and `subst`; these will be similar to the ones you implemented in HW 2, just
  with additional cases.

## Submission and Scoring

The assignment will be submitted on Gradescope. Submissions and the autograder
will be set up at a later time (ETA: the weekend before the due date). However,
you can test your code with unit tests or compare the output against the
reference interpreter.
