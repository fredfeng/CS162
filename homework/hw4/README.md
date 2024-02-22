# Homework Assignment 4

**Due Friday, March 1st, 11:59PM (pacific time)**

In this assignment, you will use OCaml to implement the type system of
λ<sup>+</sup>. 

## Instructions

0. Make sure you download the latest version of the reference manual [using this link](https://github.com/fredfeng/CS162/blob/master/homework/lamp.pdf). You will need to refer to the chapter on type checking in the language reference manual.
1. Either clone this directory, or download the zipped directory using [this link](https://download-directory.github.io/?url=https%3A%2F%2Fgithub.com%2Ffredfeng%2FCS162%2Ftree%2Fmaster%2Fhomework%2Fhw4).
2. The files required for this assignment are located in this folder. In
  particular, you will need to implement the `abstract_eval` function in
  [lib/lamp/typecheck.ml](./lib/lamp/typecheck.ml).
3. You must not change the type signatures of the original functions. Otherwise, your program will not compile. If you accidentally change the type signatures, you can refer to the corresponding `.mli` file to see what the expected type signatures are.
4. Once you're done, run `make`, which will create an archive called `submission.zip` containing `lib/lamp/typecheck.ml`. Submit the zip file to Gradescope, or manually turn in your `typecheck.ml` file. 
5. If your program contains print statements, please remove them before submitting. You do not need to submit any other file, including any `.mli` file or test code. The autograder will automatically compile your code together with our testing infrastructure and run the tests.




### Mandatory type annotations

First, note that the typing rules only provide a method for proving that a given expression has a given type. In a type checker, we are more interested in _finding_ the type of an expression by abstractly evaluating the expression.

To facilitate this, we must include **mandatory** type annotations in lambdas, fix, and nil. In terms of concrete syntax:
* Lambdas are now of the form `lambda x: T. e`, where `T` is the type of `x`.
* Nil is now of the form `Nil[T]`, where `T` is the type of the elements of the list, **not the type of the list itself**!
* The fixed-point operator is now of the form `fix x: T is e`, where `T` is the type of `x`.
* The `fun` syntax has changed so that it is now
  `fun f: Tr with x1: T1, ..., xn: Tn = e1 in e2`, where `Ti` is the
  type of `xi` for each `i`, and `Tr` is the *return type* of the function `f`.

The type annotations are necessary because it would otherwise be difficult to assign a type to an expression such as `Nil` or `lambda x. x`. It is possible to write an algorithm to _infer_ the annotations needed; in fact, you will be implementing type inference for homework assignment 5.

In terms of abstract syntax, the appropriate AST constructors have been augmented to take type annotations of the form `ty option`. 
If you look in `ast.ml`, you will observe that the type annotations in `Lambda`, `Fix`, and `ListNil` are defined as `... of typ option ...`. For this assignment you can assume that any expression that is not correctly annotated is ill-typed. In other words, when your code is processing a required type annotation, but the annotation is missing (i.e., it's a `None`), then you can simply crash the program or do whatever you want. For example, your type checker is allowed to reject programs containing nils, lambdas, and lets that do not have type annotations.



### Optional type annotations

There are also **optional** type annotations. We introduce the syntax `(e @ T)` to denote the programmer annotation that `e` has type `T`. The associated AST constructor is `Annot of expr * ty`.

Let-bindings now also take an optional type annotation. The syntax is `let x: T = e1 in e2`. In the parser, this is de-sugared into `let x = (e1 @ T) in e2`.

Your code should correctly handle all optional annotations according to the T-Annot rule in the reference manual.



For example, the following are now valid λ<sup>+</sup> programs:

* `let f: Int -> Int = lambda x: Int. x + 5 in f 0`
* `fun f: Int with l: List[Int] = match l with Nil -> 0 | h::_ -> h end in f Nil[Int]`


### Part 1: 📝 Exercises

For each of the following expressions $e$, determine 
- whether there exists a type $T$ such that $\vdash e: T$.
- if no such $T$ exists, determine whether there exists a combination of $\Gamma$ and $T$ such that $\Gamma \vdash e: T$:

1. `lambda x: Bool. x + 2 * x`
2. `x`
3. `(lambda x: Int. x + 2 * y) 3`
4. `10 < 10`
5. `1::2::3+4::Nil[Int]`
6. `Nil[Bool]::(lambda x:Bool.x::Nil[Bool->Bool])::true::Nil[Bool]`
7. `if true then false else true`
8. `match Nil[Bool] with Nil -> Nil[Bool] | _::_ -> Nil[Int] end`
1. `(if 3>4 then 5 else 7+10*3) = 10`.
2. `let f = lambda x:Bool. if x then false else true in f (10 > 0)`
3. `1 :: 10 :: Nil[Int] :: Nil[Int]`
4. `(1::10) :: Nil[Int] :: Nil[List[Int]]`
5. `match 1::Nil[Int] with Nil -> 0 | hd::_ -> hd end`
6. `match 1::Nil[Int] with Nil -> 0 | _::tl -> tl end`
7. `match 1::2 with Nil -> 3 | x::y -> x+y end`
8. `(fix recur: Int -> Int is lambda n: Int. if n < 1 then 1 else recur (n-1) + recur (n-2)) 2`.
9.  `(fix recur:List[Bool] -> Int is lambda xs: List[Bool]. match xs with Nil -> 0 | _::ys -> 1 + recur ys end) (false::true::Nil)`
10. `(fix recur:List[List[Int]] -> Int is lambda xs: List[List[Int]]. match xs with Nil -> 0 | _::ys -> 1 + recur ys end) Nil[List[Int]]`
11. `(fix recur: Int -> Int -> Bool is lambda n: Int. recur (n-1) 10`
12. `(fix recur: Int -> Int is lambda n: Int. n-1) 10`



### Part 2: Implementing the type checker (🧑‍💻)

Of note is the new file, `typecheck.ml`. You will use the typing rules to implement a `abstract_eval` function that, when given a typing environment and expression, will either 1) evaluates the expression to some type; or 2) raise a `Type_error` by calling `ty_err` if the expression cannot be proven to be well-typed (reminder: a type system may reject some "well-behaved" programs!).

Before implementing `abstract_eval`, you will need to implement a `equal_ty` function that checks if two types are equal. Later in your `abstract_eval`, use this function to check if the type of an expression matches the expected type, or to assert that two expressions have the same type.

You should construct your own test cases and test your type checker locally. Use the typing rules in combination with your own intuition to construct well-typed and ill-typed expressions. You can find unit test helpers in `lib/test/test_typing.ml`, and you can execute unit tests with `dune runtest`.

If you wish to test your type checker interactively through REPL, run `dune exec bin/repl.exe -- -typed` to start your interpreter with type checking enabled. In this mode, the interpreter will print the type of the result of evaluating an expression, in addition to the value itself. Although we will not be testing your `eval` function when grading this homework, feel free to copy over your `eval.ml`. If you do, you will need to slightly modify your code to account for the type annotations.

For file mode, do `dune exec bin/repl.exe -- -typed <filename>`.

The reference interpreter includes a type checker. You can enable type checking by running `~junrui/lamp -typed`.



## Tips
* You won't need to write more than 100 lines of code for this assignment. Most of it will be quite straightforward.
* Start with the basics: implement the typing rules for integer, booleans, nil, and cons values.
* Move on to the arithmetic, comparison, if-then-else, and type annotation rules. Make sure that a type error is raised when e.g. adding a number to a list or comparing two expression of different types.
* Lastly, implement the remaining rules, which require you to handle the typing environment $\Gamma$.