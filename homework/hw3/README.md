# Homework Assignment 3

**Due Monday, February 8 at 11:59 pm (pacific time)**

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
  would be the best one to use some of them on.
* To test your code, you can either compare your output against the reference
  interpreter or use the unit test helpers defined in `test.ml`. We will not be
  scoring how you test your code. Note that the reference interpreter has been
  updated again, so please download the latest version from Gauchospace.

### Setting up

For this assignment,
[you will need to have `opam` installed](/sections/section1/install_ocaml.md).
Once it is installed, copy this folder somewhere and open it in a terminal.
Install the required OCaml dependencies from your homework 3 folder using:

```bash
# Make sure you run these from the homework 3 folder!
opam install -y --deps-only .
opam install -y --deps-only --with-test .
```
you can safely ignore the warning messages as long as the packages are installed
successfully.

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

You may also want to keep the reference interpreter from Gauchospace handy to
check your implementation against.

It is also possible to debug with `utop`. Start it using the following
command:
```
dune utop -- .
```
This will open up `utop` with the homework code available, e.g.:
```
────────┬─────────────────────────────────────────────────────────────┬─────────
        │ Welcome to utop version 2.6.0 (using OCaml version 4.10.0)! │         
        └─────────────────────────────────────────────────────────────┘         

Type #utop_help for help about using utop.

─( 19:32:32 )─< command 0 >──────────────────────────────────────{ counter: 0 }─
utop # open Eval ;; open Ast ;;
─( 19:32:32 )─< command 1 >──────────────────────────────────────{ counter: 0 }─
utop # eval (NumLit 5) empty_env ;;
- : Ast.expr = Ast.NumLit 5
─( 19:32:38 )─< command 2 >──────────────────────────────────────{ counter: 0 }─
utop # eval (Binop(NumLit 5, Add, NumLit 10)) empty_env ;;
- : Ast.expr = Ast.NumLit 15
```

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
argument will not capture any variables. You will also need to alpha rename in
let-bound variables, if necessary. Here are some examples of alpha renaming:
* `(lambda x, y. x y) (lambda x. y)` will evaluate to `(lambda y0. (lambda x. y) y0)`.
* `(lambda x, y. x y y0) (lambda x. y)` will evaluate to `(lambda y1. ((lambda x. y) y1) y0)`
* `(lambda f, y. let y0 = 5 in y) (lambda x. y)` will evaluate to `lambda y0. let y00 = 5 in y0`

_(Feb. 4) One small note on alpha renaming_: you are expected to alpha rename
let bindings contained inside of lambdas, e.g. the let-bound `x` in `(lambda z.
lambda y. let x = 5 in z) (lambda y. x)` should be renamed to `x0`. However, due
to an oversight in the assignment description, you can ignore alpha renaming for
when substituting in the body of a let expression, e.g. you do not need to
rename the `x` of the left lambda in `let x0 = 5 in (lambda f. lambda x. x)
(lambda y. x)`. The `subst` function would need to be changed to take the
environment as an argument to handle this case, and we thought it would be
unfair to change the assignment description so close to the deadline.

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
* Go back and update your `Let` rule so that it handles alpha renaming.

## Submission and Scoring

Submit `eval.ml` on Gradescope, where an autograder will run your code on a set
of test cases. _You should test your code with your own test cases before
submitting it to the autograder. The autograder will only tell you if you are
missing anything; if you are failing some test cases, it will not tell you why.
Blindly guessing solutions will waste a lot of your time._

You can test your code locally with unit tests (in `test.ml`) or compare the
output against the reference interpreter (which may be buggy, so use your best
judgment). The best way to construct test cases is to make up some programs and
then put together a derivation tree with pencil and paper.

As outlined in the grading policy, your score for this assignment will be the
percentage of test cases passed, plus whatever additional credit is awarded to
you for partially correct solutions that demonstrate understanding of the course
material.

Some of the things we will be looking for during grading are:
* Your `eval` function evaluates expressions to the correct values, as described
  by the manual.
* Your `eval` function correctly raises a `Stuck` exception if no evaluation
  rule matches. We reserve the right to deduct points if you hardcode Stuck
  exceptions to avoid doing the rest of the assignment properly.
* Alpha-renaming is performed correctly during substitution. This is worth a
  relatively low but still significant number of points.
