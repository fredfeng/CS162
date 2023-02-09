# Homework Assignment 3

**Due Wednesday, Feb 15 at 11:59PM**

In HW3 and HW4, you will use OCaml to implement the big-step operational
semantics for λ<sup>+</sup>. In this assignment, you will implement the subset of λ<sup>+</sup> involving arithmetic, boolean, and list operations, while let-bindings and functions will be the main focus of the next assignment.


## Overview

* You will need to refer to section on operational semantics of the [reference manual](../../misc/lambda-plus-reference-manual.pdf).
* The files required for this assignment are located in this folder. In
  particular, you will need to write all your code in [`eval.ml`](eval.ml).
  The only function you need to implement is `eval`.
* You will need to write about 50 lines of code for this assignment.
* To test your code, you can either compare your output against the reference
  interpreter or use the unit test helpers defined in `test.ml`. We will not be
  scoring how you test your code.


### Setting up

For this assignment,
[you will need to have `opam` installed](/sections/section1/README.md#installing-opam).
Once it is installed, copy this folder somewhere and open it in a terminal.
Install the required OCaml dependencies from your homework 3 folder using:

```bash
# Make sure you run these from the homework 3 folder!
opam install dune linenoise alcotest
```

The files are set up to be built with the [`dune` build
tool](https://dune.readthedocs.io/en/stable/), which the above command will help
install for you.
* Run `make` to compile your code. This just invokes `dune build` to compile the project.
* Run `make test` to compile and execute the unit tests located in `test.ml`.
* Run `make dist` to compile the interpreter and copy it to `./lamp`.
* Run `make run` to compile and execute the interpreter.


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
lectures/handout into OCaml code for the following subset of λ<sup>+</sup>:
```ocaml
type expr =
  | NumLit of int
  | Binop of expr * binop * expr
  | IfThenElse of expr * expr * expr
  | ListNil
  | ListCons of expr * expr
  | ListHead of expr
  | ListTail of expr
  | ListIsNil of expr
```

Simply replace places marked with `todo ()` with your own code.

You don't need to worry about the remaining subset of λ<sup>+</sup>, such as let bindings and lambdas, until the next assignment. For now, the starter code simply raises an exception in those cases, and the autograder will only test your interpreter on the subset of λ<sup>+</sup> listed above.


## Tips

- You can test your code locally with unit tests (in `test.ml`) or compare the
output against the reference interpreter (which may be buggy, so use your best
judgment). To run your own interpreter interactively, run `dune exec ./repl.exe`. You can also interpret a λ<sup>+</sup> source file via `dune exec ./repl.exe -- <source-file>.lp`.

- The best way to construct test cases is to **make up some programs and
then put together a derivation tree with pencil and paper**.

- `dune` conveniently has a feature to automatically recompile/retest your code
whenever you make a change. To use it, run `dune build --watch` or `dune
runtests --watch`, respectively.

- It is also possible to debug with `utop`. Assuming that you have installed it with `opam install utop`, you can do the following:
command:
  ```
  dune utop -- .
  ```
  This will open up `utop` with the homework code available, e.g.:
  ```
  ────────┬─────────────────────────────────────────────────────────────┬─────────
          │ Welcome to utop version 2.8.0 (using OCaml version 4.13.0)! │         
          └─────────────────────────────────────────────────────────────┘         

  Type #utop_help for help about using utop.

  ─( 19:32:32 )─< command 0 >──────────────────────────────────────{ counter: 0 }─
  utop # open Eval ;; open Ast ;;
  ─( 19:32:32 )─< command 1 >──────────────────────────────────────{ counter: 0 }─
  utop # eval (NumLit 5) ;;
  - : Ast.expr = Ast.NumLit 5
  ─( 19:32:38 )─< command 2 >──────────────────────────────────────{ counter: 0 }─
  utop # eval (Binop(NumLit 5, Add, NumLit 10)) ;;
  - : Ast.expr = Ast.NumLit 15
  ```

## Submission and Scoring

Submit `eval.ml` on Gradescope, where an autograder will run your code on a set
of test cases. _You should test your code with your own test cases before
submitting it to the autograder. The autograder will only tell you if you are
missing anything; if you are failing some test cases, it will not tell you why.
Blindly guessing solutions will waste a lot of your time._


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
