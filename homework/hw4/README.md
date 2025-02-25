# Homework Assignment 4

**Due Wednesday, March 5th, 11:59PM (Pacific Time)**

In this assignment, you will use OCaml to implement the type system of λ<sup>+</sup>. 

## Instructions

0. Make sure you download the latest version of the reference manual [using this link](https://github.com/fredfeng/CS162/blob/master/homework/lamp.pdf). You will need to refer to the chapter on type checking in the language reference manual.
1. Either clone this directory, or download the zipped directory using [this link](https://download-directory.github.io/?url=https%3A%2F%2Fgithub.com%2Ffredfeng%2FCS162%2Ftree%2Fmaster%2Fhomework%2Fhw4).
2. The files required for this assignment are located in this folder. In particular, you will need to implement the `abstract_eval` function in [lamp/typecheck.ml](./lamp/typecheck.ml).
3. You must not change the type signatures of the original functions. Otherwise, your program will not compile. If you accidentally change the type signatures, you can refer to the corresponding `.mli` file to see what the expected type signatures are.
4. Once you're done, submit `lamp/typecheck.ml` to Gradescope.
5. If your program contains print statements, please remove them before submitting. You do not need to submit any other file, including any `.mli` file or test code. The autograder will automatically compile your code together with our testing infrastructure and run the tests.



### Mandatory type annotations

Note that the typing rules only provide a method for proving that a given expression has a *given* type. In a type "checker", we are more interested in _computing_ the type of an expression.

This is usually straightforward when the type of an expression can be assembled from the types of its subexpressions. However, this is not the case with lambdas, fix, and nil, which we require mandatory type annotations from the programmer that uses $\lambda^+$. (It is possible to write an algorithm to _infer_ the annotations needed; in fact, you will be implementing type inference in HW5.)

We thus add type annotations to the concrete syntax of $\lambda^+$ as follows:
* Lambdas are now of the form `lambda x: T. e`, where `T` is the type of `x`.
* Nil is now of the form `Nil[T]`, where `T` is the type of the elements of the list, **not the type of the list itself**!
* The fixed-point operator is now of the form `fix x: T is e`, where `T` is the type of `x`.
* The `fun` syntax has changed so that it is now
  `fun f: Tr with x1: T1, ..., xn: Tn = e1 in e2`, where `Ti` is the
  type of `xi` for each `i`, and `Tr` is the *return type* of the function `f`.


In terms of abstract syntax, the appropriate AST constructors have been augmented to take type annotations of the form `ty option`:
```diff
type expr =
  ...
- | Lambda of expr binder
+ | Lambda of ty option * expr binder

- | Fix of expr binder
+ | Fix of ty option * expr binder

- | ListNil
+ | ListNil of ty option
  ...
```
The reason we use `ty option` instead of `ty` even though those type annotations are mandatory for type checking is that in HW5 the annotations will become optional, so we anticipate the change and keep the AST consistent across assignments.

But for this assignment, you can assume that **any expression that is not correctly annotated is ill-typed**. In other words, when your code expects a mandatory type annotation (for `ListNil`, `Lambda`, or `Fix`), you can assume the `ty option` part of the AST is always `Some ty`. In case the annotation is missing (i.e., it's a `None`), then you can simply crash the program or do whatever you want.



### Optional type annotations

In contrast with the mandatory annotations discussed above, there are also "truly optional" type annotations. We introduce the syntax `e : T` to denote the annotation that `e` has type `T`. The associated AST constructor is `Annot of expr * ty`.

In the concrete syntax, let-bindings can also take an optional type annotation via `let x: T = e1 in e2`. This will be de-sugared into `let x = (e1 : T) in e2` after parsing, so we don't need to change the AST constructor for `Let`. For example, `let f: Int -> Int = lambda x: Int. x + 5 in f 0` will be parsed into:
```ocaml
Let(
  App(Var "f", Num 0),
  (
    "f",
    Annot(
      Lambda(
        Some TInt, 
        ("x", Binop(Add, Var "x", Num 5))),
      TFun(TInt, TInt)
    )
  )
)
```

Your code should correctly handle all optional annotations according to the T-Annot rule in the reference manual.



## Part 1: 📝 Exercises

For each of the following expressions $e$:
- Does there exist a type $T$ such that $\cdot \vdash e: T$, i.e., whether the expression is well-typed under an empty typing environment. If so, draw the type derivation tree.
- If no such $T$ exists, does there exists a combination of $\Gamma$ and $T$ such that $\Gamma \vdash e: T$. If so, draw the type derivation tree.

1. `lambda x: Bool. x + 2 * x`
2. `x`
3. `(lambda x: Int. x + 2 * y) 3`
4. `10 < 10`
5. `1::2::3+4::Nil[Int]`
6. `Nil[Bool]::(lambda x:Bool.x::Nil[Bool->Bool])::true::Nil[Bool]`
7. `if true then false else true`
8. `match Nil[Bool] with Nil -> Nil[Bool] | _::_ -> Nil[Int] end`
9. `(if 3>4 then 5 else 7+10*3) = 10`.
10. `let f = lambda x:Bool. if x then false else true in f (10 > 0)`
11. `1 :: 10 :: Nil[Int] :: Nil[Int]`
12. `(1::10) :: Nil[Int] :: Nil[List[Int]]`
13. `match 1::Nil[Int] with Nil -> 0 | hd::_ -> hd end`
14. `match 1::Nil[Int] with Nil -> 0 | _::tl -> tl end`
15. `match 1::2 with Nil -> 3 | x::y -> x+y end`
16. `(fix recur: Int -> Int is lambda n: Int. if n < 1 then 1 else recur (n-1) + recur (n-2)) 2`.
17. `(fix recur:List[Bool] -> Int is lambda xs: List[Bool]. match xs with Nil -> 0 | _::ys -> 1 + recur ys end) (false::true::Nil)`
18. `(fix recur:List[List[Int]] -> Int is lambda xs: List[List[Int]]. match xs with Nil -> 0 | _::ys -> 1 + recur ys end) Nil[List[Int]]`
19. `(fix recur: Int -> Int -> Bool is lambda n: Int. recur (n-1) 10`
20. `(fix recur: Int -> Int is lambda n: Int. n-1) 10`



## Part 2: Implementing the type checker (🧑‍💻)

Your task is to implement the `abstract_eval` function in [lamp/typecheck.ml](./lamp/typecheck.ml). Given a typing environment and expression, `abstract_eval` should either 1) evaluate the expression "abstractly" and return the type of the expression; or 2) raise a `Type_error` by calling `ty_err` if the expression cannot be proven to be well-typed. You need to implement the typing rules as described in the reference manual.

Before implementing `abstract_eval`, we suggest you implement an `equal_ty` helper function that checks if two types are the same. Later in your `abstract_eval`, use this function to check if the type of an expression matches the expected type, or to assert that two expressions have the same type.

We encourage you to construct your own test cases and test your type checker locally. Use the typing rules in combination with your own intuition to construct well-typed and ill-typed expressions. You can find unit test helpers in `test/test_typing.ml`, and you can execute unit tests with `dune runtest`.

If you wish to test your type checker interactively through REPL, run `dune exec bin/repl.exe -- -typed`, which will spawn an interpreter with type checking enabled. Although we will not be testing your `eval` function when grading this homework, feel free to copy over your `eval.ml` (otherwise the REPL will crash whenever it calls the stub `eval` function). If you do, you will need to slightly modify your `eval` to account for the type annotations.

The reference interpreter includes a type checker. You can enable type checking by running `~junrui/lamp -typed`.



## Tips
* Start with the basics: implement the typing rules for integer, booleans, nil, and cons values.
* Move on to the arithmetic, comparison, if-then-else, and type annotation rules. Make sure that a type error is raised when e.g. adding a number to a list or comparing two expression of different types.
* Lastly, implement the remaining rules, which require you to handle the typing environment $\Gamma$.



## Part 3: Extra Credit Problems

<details>
<summary>Click to show extra credit problems</summary>


### Problem 3.1 (1pt): 

We introduce two new language constructs:

1. The first one is called *unit*. 
   - There is one syntactic form to make a unit value: `()`. In this AST, this is represented by `Unit` in the AST. There is no way to consume the unit value.
   - We introduce a new concrete type `()` for the unit value (represented by `TUnit` in the AST). 
  
    Your task is to reverse engineer the operational semantics **and** the typing rule(s) of unit by augmenting your `eval` and `abstract_eval` functions.

2. The second construct is called *void*. 
   - There is no syntactic form to make a void value. There is one way to consume a void value: `match e with end`, represented as `Absurd of expr` in the AST. 
   - We introduce a new concrete type `!` for void (represented by `TVoid` in the AST. Your task is to reverse engineer the operational semantics of void by augmenting your `eval` function. 
  
    *Though experiment:* Is it possible to type check void in your `abstract_eval` function? If so, how? If not, what would you need to change in the type system to make it possible?

----
### Problem 3.2 (1pt)
In HW3, you reverse-engineered the operational semantics of *internal choice*.
> <details><summary>Spoiler</summary>
> Internal choices are just pairs/tuples with *lazy* evaluation semantics.
> </details>

Now, we introduce a new concrete type `T1 * T2` to represent an internal choice between values of type `T1` and values of type `T2`. This type is represented in the AST by `TProd` (short for **prod**uct). Your task is to reverse engineer the typing rules of products.



----
### Problem 3.3 (1pt)
In HW3, you reverse-engineered the operational semantics of *external choice*.
> <details><summary>Spoiler</summary>
> External choices are just enums with exactly two cases.
> </details>

We introduce a new concrete type `T1 + T2` to represent an *external choice* between values of type `T1` and values of type `T2`. This type is represented in the AST by `TSum`.

Your tasks are:

1. On paper, design the typing rules for `E1`, `E2`, and `Either`. Then, you use your typing rules to draw the type derivation tree for the [max_ext.lp](../hw3/test/examples/max_ext.lp) example program from HW3.
2. Is it possible to implement your rules in the `abstract_eval` function? If so, how? If not, what would you need to change in the type system or the type checking algorithm to make it possible? 

You do not need to write any code for this problem; simply let Junrui know your solutions by DM'ing him on Slack or going to his office hours.



----
#### Problem 3.4 (1pt)
Define a function `size: typ -> int option` that computes the number of behaviorally distinct expressions that provably have a given type. If the type has infinitely many such members, return `None`. 

For example,
- `size(Bool)` should return `Some 2` since the only boolean values are `true` and `false`. Note that we consider `true` and `2>1` to be behaviorally indistinguishable, since both of them evaluate to `true` under any context, so we don't count them separately.
- `size(Int)` should return `None` since there are infinitely many integers.
- `size(Bool -> Bool)` should return `Some 4`, since there are 4 boolean functions with distinct behaviors:
  1. The identity function that returns its input unchanged
  2. The constant function that always returns `true`
  3. The constant function that always returns `false`
  4. The function that negates its input

In implementing `size`:
- You need to handle all of the newly introduced types, including `TUnit`, `TVoid`, `TProd`, and `TSum`. 
- You do not need to consider expressions that may not terminate. I.e., you only need to count expressions that don't use `Fix`.
- You do not need to consider ill-typed expressions like `1+true`.

<details>
<summary>Hint</summary>
There's an edge case for the list type. The other ones are elementary-school math.
</details>

</details>