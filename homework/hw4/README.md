# Homework Assignment 3

**Due Thursday, February 17 at 11:59 pm (pacific time)**

In HW3 and HW4, you will use OCaml to implement the big-step
operational semantics for λ<sup>+</sup>. In this assignment, you will
implement the remainder of λ<sup>+</sup>, specifically lambdas, `let`,
fixpoints, and function application. To implement this fragment of the
language, you will need to implement substitution and alpha renaming.


## Overview

* You will need to refer to section on operational semantics of the manual 
  posted on Gauchospace.
* The files required for this assignment are located in this folder. In
  particular, you will need to write all your code in [`eval.ml`](eval.ml).
  You need to implement `eval`, `free_vars`, and `subst` functions.
* You will need to write about 100 lines of code (on top of the 50 for
  HW3) for this assignment.
* To test your code, you can either compare your output against the reference
  interpreter or use the unit test helpers defined in `test.ml`. We will not be
  scoring how you test your code.
* **This homework builds on top of homework 3, so you will need to
  copy over your implementation for the evaluation rules covered in
  homework 3 before starting this homework.**


### Setting up

For this assignment,
[you will need to have `opam` installed](/sections/section1/README.md#installing-opam).
Once it is installed, copy this folder somewhere and open it in a terminal.
Install the required OCaml dependencies from your homework 4 folder using:

```bash
# Make sure you run these from the homework 4 folder!
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
  | Var of string
  | LetBind of string * expr * expr
  | Lambda of string * expr
  | App of expr * expr
  | Fix of expr
```

Some of these evaluation rules use substitution. So, you need to
implement substitution with α-renaming.

Similar to homework 3, you need to replace places marked with `todo ()`
with your own code.  You need to implement the following functions for this
purpose (the rules for those functions are also in the handout):
- `free_vars : expr -> VarSet.t` takes an expression and returns the
  set of free variables that are in that expression. The return type
  is a set of strings. You can see [this
  tutorial](https://ocaml.org/learn/tutorials/set.html) and [the API
  documentation](https://ocaml.org/api/Set.S.html) for how to use sets
  in OCaml. To access a set function like `mem`, you need to use
  `VarSet.mem`. Some set functions you may need are `mem`,
  `singleton`, `diff`, `empty`, and `union`.
  
You will need to implement alpha renaming for this assignment. To be
consistent with the autograder, whenever you need to alpha-rename some
argument `y` of an abstraction `\y. e`, you should rename `y` to `yn`
where `n` is the smallest natural number such that using `yn` as an
argument will not capture any variables. You will also need to alpha
rename in let-bound variables, if necessary. Here are some examples of
alpha renaming:
* `(lambda x, y. x y) (lambda x. y)` will evaluate to `(lambda y0. (lambda x. y) y0)`.
* `(lambda x, y. x y y0) (lambda x. y)` will evaluate to `(lambda y1. ((lambda x. y) y1) y0)`
* `(lambda f, y. let y0 = 5 in y) (lambda x. y)` will evaluate to `lambda y0. let y00 = 5 in y0`
* `(lambda z. lambda y. let x = 5 in z) (lambda y. x)` will evaluate to `lambda y. let x0 = 5 in lambda y. x`

We suggest implementing a helper function for finding the next
available name and testing it separately.

## Tips

- This assignment may seem overwhelming, but it is really just a collection of
  small tasks.
- There is no rule for variables, so a free variable should get
  stuck.
- You should start with implementing `Lambda` as it is an easier case.
- The remaining rules require substitution, so you should implement
  `free_vars` and `subst`. You can implement `subst` without
  α-renaming first, then add α-renaming later on.
- Once you tested your `free_vars` and `subst` functions, the next
  easiest case is `App`. After implementing it, you can test it on
  some small cases like `(lambda x. x + x) 5`.
- Then, you can proceed to the `Let` case which is slightly more complicated.
- If you haven't implemented α renaming yet. You should implement it now.
- Finally, you should implement the `Fix` case. Note that you cannot
  write `fix` using the concrete syntax, you need to use `fun f with arg1, ..., argn = e1 in e2` syntax to create a recursive
  function. This gets translated to `let f = fix (lambda f. lambda arg1. ... lambda argn. e1) in e2`.

- You can test your code locally with unit tests (in `test.ml`) or compare the
output against the reference interpreter (which may be buggy, so use your best
judgment). To run your own interpreter interactively, run `dune exec ./repl.exe`. You can also interpret a λ<sup>+</sup> source file via `dune exec ./repl.exe -- <source-file>.lp`.

- The best way to construct test cases is to **make up some programs
and then put together a derivation tree with pencil and paper**. You
can then check your reasoning against the λ<sup>+</sup> interpreter
available to you.

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
* Your `free_vars` and `subst` functions work correctly, and the
  substitution function handles α renaming.
