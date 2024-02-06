# Homework Assignment 2

**Due Wednesday, Feb 7th at 11:59PM (Pacific Time)**

## Overview

In this assignment, you will augment the simple arithmetic language in the last assignment with lambda calculus. The resulting language is called $\lambda^+$. This language is so powerful that it can simulate the execution of any Turing machine, and thus any computer program in any programming language: C++, Python, Java, or your favorite programming language.

This homework will consist of four parts. 
- The first part gives you some practice with higher-order functions in OCaml.
- The second part is a review of the core concepts of lambda calculus with plenty of pen-and-paper exercises to reinforce your understanding.
- The third part asks you to implement an interpreter for $\lambda^+$ in OCaml.
- The fourth part (bonus) walks you through a recipe that can be used to encode all kinds of fancy data structures into lambda calculus.


## Instructions

1. Either clone this directory, or download the zipped directory using [this link](https://download-directory.github.io/?url=https%3A%2F%2Fgithub.com%2Ffredfeng%2FCS162%2Ftree%2Fmaster%2Fhomework%2Fhw2).
2. Run `opam install . --deps-only` in the root directory of this homework to install the necessary dependencies. **You need to run this command again**, since this assignment contains new dependencies that were not used in HW1.
3. Complete `lib/part1/part1.ml`, `lib/lamp/eval.ml`, and (for bonus) `lib/part4/*.lp` by replacing the placeholders denoted by `todo` or `bonus` with your own code. You must not change the type signatures of the original functions. Otherwise, your program will not compile. If you accidentally change the type signatures, you can refer to the corresponding `.mli` file to see what the expected type signatures are.
4. Once you're done, submit `lib/part1/part1.ml`, `lib/lamp/eval.ml`, and (for bonus) `lib/part4/*.lp` to Gradescope. If your program contains print statements, please remove them before submitting. You do not need to submit any other file, including any `.mli` file or test code. The autograder will automatically compile your code together with our testing infrastructure and run the tests.


**Important notes**:
* Problems marked with `📝` are pencil-and-paper problems, and are ungraded. You do not need to submit your solution. The goal is to review concepts that will help you solve subsequent problems, and/or to give you some practice with the kinds of questions that will appear on the midterm. Solutions to these problems will be released by the TAs and discussed in sections.
* Problems marked with `🧑‍💻` are programming tasks, and will be autograded on Gradescope. There are 8 of them in total. In solving those problems:
  * You are **not** allowed to use in built-in OCaml library functions in your solutions. If you do, you will not be awarded any points. Note that language features like pattern-matching do not count as library functions. You may use library functions like `Format.printf` and `Int.equal` to test your code, but you must remove them before submitting.
  * You are **not** allowed to use any kind of imperative features, including mutable state (e.g. references and arrays), loops, etc. If you do, you will not be awarded any points.
* Problems marked with `⭐️bonus⭐️` are optional. You will receive extra credit by solving them. You will not be tested on them in the midterm *unless we explicitly say so*.
* The homework may appear to be long, but again, we decided to err on the more verbose side since we believe this might be more helpful. As usual, the TAs will go over a lot of the expository texts in the discussion sections.
* The actual programming problems were designed so that you won't write more than 100 lines of code in total, but they do require a deep understanding of the concepts covered in lectures.
* Some parts of the next assignment will build on the concepts and the code you wrote in this assignment, so it's important to get them right!
* If you are struggling, please do not hesitate to ask questions in the `#hw2` Slack channel or come to office hours.



## Testing

We have provided one unit test for each programming problem. To run all unit tests, simply run 
```bash
dune runtest
```
in the root directory of this homework. This will compile your programs and report tests that fail.

We highly encourage you to add your own tests, since the autograder won't show you what the official test cases are (only the identifiers of passed/failed cases will be shown). You can locate the provided test cases in `test/test_*.ml`. For example, in `test/test_part1.ml`, you will find the following line:
```ocaml
let singletons_tests =
  [
    test_singletons (* input *) [ 6; 7; 3 ]
      (* expected output *) [ [ 6 ]; [ 7 ]; [ 3 ] ];
  ]
```
`test_singletons` is a helper function that we defined for you. Its first argument is the input to your `singletons`, and its second argument is the expected output. You can add your own test cases by adding more elements to the list.


## Part 1. Higher-Order Functions in OCaml

> Total: 5 points
> 
> **Important notes**: 
> 1. You may not use recursion (i.e., the `rec` keyword) to solve problems in this part. If you do, you will not be awarded any points.
> 2. You only need to modify `lib/part1/part1.ml`.

In OCaml, functions can take other functions as input, and return other functions as output. This is a very powerful feature that allows us to write very concise code. You have seen simple instances of higher-order function in HW1. For example, your `compress` has type `('a -> 'a -> bool) -> 'a list -> 'a list`, so it's a function whose first argument is another *function* of type `'a -> 'a -> bool`!

**Problem 1** (📝): In OCaml, a function can be defined using `let`, in which case the function has a name. However, sometimes we just want to make a one-off function on-the-fly, without giving it a name. These functions are called *anonymous functions*, or *lambda functions*, and can be defined using the syntax 
```ocaml
fun <arg1> <arg2> ... <argn> -> <body>
```
Using this syntax, write down a function of type `int -> int -> int` that takes two integers and returns their sum.


**Problem 2** (📝): Without looking at the lecture slides:
- Informally describe what each of `map`, `filter` and `fold` does, and give an example of how to use each of them.
- Write down the type signature of each of them. Check your solution against TODO. It's ok to reorder some of the arguments.
- Try writing down the implementation of each of them. Then compare what you wrote with the implementation in the lecture slides.


**Problem 3** (🧑‍💻, 1 point): Using `map` and an anonymous function, complete the implementation of
```ocaml
let singletons (xs : 'a list) : 'a list list = 
    map .. ns
```
which takes a list and returns a list of singleton lists, each containing one element from the original list. For example, `singletons [6; 7; 3]` will evaluate to `[[6]; [7]; [3]]`.

You may not use recursion or pattern matching in your solution. If you do, you will not be awarded any points.


**Problem 4** (🧑‍💻, 1 point): Using `map` and anonymous functions, define the function `map2d : ('a -> 'b) -> 'a list list -> 'b list list` that applies a function to every element in a 2d list. Example:
```ocaml
map2d (fun x -> x + 1) [[1; 2]; [3; 4]] = [[2; 3]; [4; 5]]
```
You may not use recursion or pattern matching in your solution. If you do, you will not be awarded any points.

*Hint*: Use `map` twice.


**Problem 5** (🧑‍💻, 1 point): Using `map` and anonymous functions, define the function `product : 'a list -> 'b list -> ('a * 'b) list list` that computes the cartesian product of two lists. For example, `product [1; 2] [true; false]` will evaluate to
```ocaml
[ 
    [ (1, true); (1, false) ];
    [ (2, true); (2, false) ]
]
```

If we think of the first list as the row labels and the second list as the column labels, then the cartesian product is the table of all possible pairs of row and column labels. For example, the above example can be visualized as

|     | true      | false      |
| --- | --------- | ---------- |
| 1   | (1, true) | (1, false) |
| 2   | (2, true) | (2, false) |

You may not use recursion or pattern matching in your solution. If you do, you will not be awarded any points.

*Hint*: Use `map` twice.


---
Consider the recursion recipe we talked about [in the first section](../../sections/sec01/sec01.pdf):
1. Identify the recursive structure of the problem
2. Decompose the problem structure into:
   1. Base case(s)
   2. Inductive/recursive case(s)
3. Solve the base case
4. To solve the inductive case:
   1. Apply the function to all recursive sub-problems.
   2. *Assuming that the solutions to all sub-problems are correct*, combine them into a solution to the original problem.

If we specialize this recipe to the list data structure, we get the following "template":
```ocaml
let rec solve (xs: 'a list) : 'result =
    match xs with
    | [] -> base_case
    | x::xs' ->
        let r = solve xs' in 
        combine x r
```
Note that the same template applies to a wide range of problems. The only difference is that each problem may differ by
1. How we solve the base case (`base_case`)
2. In the recursive case, how we combine the the current head value `x` and the solution to subproblem `y` to get a solution to the original problem (`combine x y`)

Since those are the only places that might be different for each problem, we can turn them into parameters of the `solve` function:
```ocaml
let rec solve 
    (base_case: 'result) 
    (combine: 'a -> 'result -> 'result) 
    (xs: 'a list) : 'result =
    match xs with
    | [] -> base_case
    | x::xs' ->
        let r = solve base_case combine xs' in 
        combine x r
```
Essentially, we are letting the specific problem dictates what to do with `base_case` and `combine`, which it can do by calling `solve` with an appropriate base case value and an appropriate `combine` function. Note that `solve` is a higher-order function since it takes another function (`combine`) as input.

As an example, recall the [`lookup` function from HW1](https://github.com/fredfeng/CS162/tree/master/homework/hw1#problem-4--5-points). We can re-implement it without recursion by using `solve`:
```ocaml
let lookup (equal: 'k -> 'k -> bool) (k1: 'k) (d: ('k * 'v) list) : 'v option =
    solve 
        None 
        (fun (k2,v) result -> if equal k1 k2 then Some v else result)
        d
```
Here, the `base_case` is `None`, since the empty dictionary cannot contain our query key. The `combine` function takes the first thing in our dictionary, which is a key-value pair, and a (correct!) result of recursively looking up the key in the rest of the dictionary. If the first key already matches, we return the value associated with it. Otherwise, we return the recursive result.


**Problem 6** (📝): Re-implement the following functions using `solve`, by calling it with the appropriate `base_case` and `combine` arguments:
1. `compress` from HW1
2. `max` from HW1
3. `join` from HW1
5. `map`
6. `filter`

You must call `solve`. You may not use recursion in your solution.


**Problem 7** (🧑‍💻, 1 point): Implement the function `power : 'a list -> 'a list list` that will take a list representing a set, and return a list representing the *power set* of the input set. The power set of set $S$ is the set of all subsets of $S$. For example, `power [1; 2; 3]` will evaluate to
```ocaml
[ []; [ 1 ]; [ 2 ]; [ 3 ]; [ 1; 2 ]; [ 1; 3 ]; [ 2; 3 ]; [ 1; 2; 3 ] ]
```
The order of the subsets do not matter for the purpose of grading.

1. You may not use recursion (including defining recursive helper functions) in your solution.
2. You may use `@` which concatenates two lists. For example, `[1;2;3] @ [4;5]` will evaluate to `[1;2;3;4;5]`. 

*Hint*: Use `solve` and `map`.


> **Background note**: In functional programming literature, `solve` usually goes by the name `fold_right`.




---
Under the hood, "multi-argument" functions in OCaml are simply one-argument functions that return another function as its output. For example, under the hood, `int -> int -> int` is the same as `int -> (int -> int)`, which is a one-argument function that takes an integer, and returns another `int -> int` *function* as its output.

For example,
```ocaml
fun (x : int) (y : int) : int 
    -> x + y
```
is secretly a function that takes an integer `x`, and returns another function that takes an integer `y` and returns `x + y`. I.e., it's exactly the same as
```ocaml
fun (x : int) : (int -> int) 
    -> fun (y : int) : int 
        -> x + y
```

A subtle but very useful corollary is that if we have a multi-argument function, we don't need to supply all of the arguments at once. We can supply one argument at a time, and get a function back which awaits the remaining arguments. For example,
```ocaml
(fun x y -> x + y) 1 2
```
supplies both arguments and evaluates to `3`, but
```ocaml
(fun x y -> x + y) 1
```
supplies only the first argument, and gives us a *function* back:
```ocaml
(fun x y -> x + y) 1
== (fun x -> fun y -> x + y) 1
== fun y -> 1 + y
```
I.e., we get a function that always increment its input by `1`!


**Problem 8** (🧑‍💻, 1 point) Consider the function `join2`:
```ocaml
let join2 (x: 'a option) (y: 'b option) : ('a * 'b) option =
    match x, y with
    | Some x, Some y -> Some (x, y)
    | _ -> None
```
The `join2` function takes two options, and if both are `Some`, it returns a `Some` that contains a pair of the two values. Otherwise, it returns `None`. This is similar to the `join` function you implemented in HW1, but for products instead of lists.

You task is to re-implement `join2` as an explicitly one-argument function that returns another function as its output:
```ocaml
let join2 : 'a option -> ('b option -> ('a * 'b) option) =
    fun x ->
       match x with
       | Some x -> (* todo *)
       | None -> (* todo *)
```


## Part 2. Names, Bindings, and Substitution

> **This part only contains 📝 problems.**
> 
> Total: N/A

Read through the [notes for section 3](../../sections/sec03/README.md), and do the exercises in the notes.

The TAs will thoroughly walk through this part of the assignment in the discussion sections. However, you are encouraged to read through this part and take a stab at the exercises before the section, and write down any questions you have or problems/concepts you would like the TAs to go over in detail. This will help you get the most out of the sections.



## Part 3. Lambda Calculus in OCaml

> Total: 35 points + 3 ⭐️bonus⭐️ points
>
> **Important note**: You only need to modify `lib/lamp/eval.ml`.

In this part, we will augment the simple arithmetic expression language defined in the previous assignment with lambda calculus. We'll call resulting language is $\lambda^+$. 

Since this is not a toy language anymore, the language will have a well-defined syntax and semantics. We wrote a parser that turns concrete syntax into abstract syntax for you, so you can focus on building the interpreter that consumes abstract syntax trees as input. But it helps to understand the concrete syntax since it may be easier for you to write test programs using the concrete syntax.



### 3.1 Concrete Syntax and Informal Semantics

You can read about the informal semantics and the concrete syntax of $\lambda^+$ in the Overview section of the $\lambda^+$ [language reference manual](https://github.com/fredfeng/CS162/blob/master/homework/lamp.pdf). **Only sections up to and including Section 2.3 (Named Function Definitions) are relevant for this assignment.** The remaining language constructs will be the focus of the next assignment.You're encouraged to quickly scan through the reference manual first without worrying about the details. You can revisit it later when you're working on the problems in this part.

The language itself is basically the arithmetic expression language you implemented in HW1 + lambda calculus, and it largely resembles OCaml (modulo some syntax differences). There are, however, a few things that are worth pointing out:


1. There's no unary minus operator, since we can just write `0 - x` instead of `-x`. This is just to make the parser and your interpreter simpler.

2. Although the concrete syntax supports multi-argument lambdas, the parser will de-sugar them into curried single-argument lambdas. For example, the following concrete syntax
   ```ocaml
   lambda x, y, z. x + y + z
   ```
   will be de-sugared into something like this
   ```ocaml
   lambda x. (lambda y. (lambda z. x + y + z))
   ```
   So in the AST, you will only see single-argument lambdas.

3. Similarly, a function application with multiple arguments will be parsed into a chain of single-argument function applications. For example, the following concrete syntax
   ```ocaml
   f x y z
   ```
   will be translated into something like this
   ```ocaml
   ((f x) y) z
   ```
    So in the AST, you will only see binary function applications.

4. Named function definitions like `fun f with x = e1 in e2` is just a syntactic sugar for `let f = lambda x. e1 in e2`. The parser will de-sugar them for you. So in the AST, you won't see function definitions being explicitly represented as one of the constructors.



### 3.2 Abstract Syntax

A straightforward way to represent the abstract syntax tree of $\lambda^+$ -- which we *won't* end up using -- is to modify the `expr` data type we defined back in HW1 with new constructors for lambda calculus and let-expression. For example, we *could* -- but won't -- augment `expr` like this:
```ocaml
type binop = Add | Sub | Mul
type expr = 
          (* arithmetic *)
          | Num of int
          | Binop of binop * expr * expr
          (* lambda calculus *)
          | Var of string
          | Lambda of string * expr
          | App of expr * expr
          (* let expression *)
          | Let of string * expr * expr
```
Here,
- the `Var of string` case would represent a variable reference. We can use strings to represent variable names.
- the `Lambda of string * expr` case would represent a lambda abstraction that declares a variable name to be in scope in the body expression.
- the `App of expr * expr` case would represent a function application.
- the `Let of string * expr * expr` case would represent a let-expression that first binds a variable name to an expression, and makes the variable in scope in the body expression.

For example, the concrete syntax `(lambda f. f 0) (lambda x. let y = x + 1 in y)` would be parsed into the following abstract syntax tree:
```ocaml
App (
    Lambda ("f", App (Var "f", Num 0)), 
    Lambda ("x", 
        Let ("y", Add (Var "x", Num 1), 
             Var "y")))
```

Although this representation is conceptually simple, working with it would unfortunately result in a lot of code duplication. The reason is that both the `Lambda` and `Let` cases contain the *binding* operation of declaring a variable name to be in scope in some other expression. Thus, if we want to define substitution for `Lambda` and `Let`, then we would end up repeating a lot of code in the two cases. Furthermore, since the next assignment will augment $\lambda^+$ with more features that involve binding, any code duplication would only be multiplied, if we don't prevent it now.

Thus, we will factor out the common pattern of binding into separate constructors:

```ocaml
type binop = Add | Sub | Mul
type expr = 
          (* arithmetic *)
          | Num of int
          | Binop of binop * expr * expr
          (* binding *)
          | Var of string
          | Scope of string * expr
          (* lambda calculus *)
          | Lambda of expr
          | App of expr * expr
          (* let expression *)
          | Let of expr * expr
```

In this representation, the `Scope of string * expr` case represents the binding operation of declaring a variable name to be in scope in some body expression. The previous example `(lambda f. f 0) (lambda x. let y = x + 1 in y)` will be now parsed into the following `expr`:
```ocaml
App (
    Lambda (Scope ("f", App (Var "f", Num 0))), 
    Lambda (Scope ("x", 
        Let (Add (Var "x", Num 1), 
             Scope("y", Var "y")))))
```

Note that for `Let`, the expression whose value will be bound to the variable is the **first** argument to the constructor, and the second argument is the `Scope` constructor that declares the variable name to be in scope in let-body. For example, if the above example were instead parsed into
```ocaml
Let (
    Scope("y", Add (Var "x", Num 1)),
    Var "y")
```
then we are saying that the variable `y` is in scope in the expression `x+1`, and out-of-scope in the body expression `y`, which is not what we want!


**Problem 1** (📝): Pretend you are the parser. For the following programs in concrete syntax, write down the abstract syntax tree as a value of type `expr`.
1. `let x = 2 in let y = x * x in x + y`
2. `(lambda x, y. let z = x + y in z * z) 2 3`
3. `fun f with x = let x = x + 1 in x in f f`



### 3.3 Well-Formedness of ASTs

A subtle point about the current `expr` type is that we can technically use the `expr` constructors to make non-sensible ASTs from a binding point of view. For example, we can write the following:
```ocaml
Lambda (
    Scope ("x", Scope "y", 
        Num 1))
```
or
```ocaml
Binop (
    Add,
    Scope ("x", Num 1),
    Num 2)
```
These expressions are not well-formed. However, because we wrote the parser ourselves that always generates well-formed ASTs, a malicious programmer cannot trick the parser into generating an ill-formed AST using some input program in concrete syntax.

However, it *is* possible that, when you write your own interpreter, you may accidentally generate an ill-formed AST (e.g., as the output of the `subst` function) if you aren't careful. Thus, you should be very careful to maintain the well-formedness of ASTs **as an invariant**. An invariant like this is bit like a contract:
- You are allowed to assume that all input `expr` are well-formed
- In return, you must ensure that any output `expr` is well-formed

Thus, it will be helpful to write a function that checks whether an `expr` is well-formed. 


**Problem 2** (📝): Finish the definition of the `wf` function, which takes a list of in-scope variables `vs`, and checks if the input expression `e` is well-formed in terms of the binding structure.
```ocaml
let rec wf (vs: string list) (e: expr) : bool =
    match e with
    | Num _ -> true
    | Binop (_, Scope _, Scope _) -> 
        (* binop doesn't bind anything *)
        false
    | Binop (_, e1, e2) -> wf vs e1 && wf vs e2
    | Var x -> (* todo *)
    | Scope _ -> 
         (* a binder by itself is ill-formed;  it must be part of 
            another language construct that uses it *)
         false
    | Lambda (Scope (x, body)) -> (* todo *)
    | Lambda _ -> false
    | Let (e1, Scope(x, e2)) -> 
        (* recursively check e1 is well-formed *)
        wf vs e1 && ( (* todo *) )
    | Let _ -> false
```
You should also check for out-of-scope references.


*Hints*: 
1. You may find it helpful to define helper functions that are similar to you did with list-based dictionaries in HW1. It's just that this time, we only need to keep track of the keys, not the values, so we use `string list` instead of `(string * 'v) list`.
2. Each todo can be implemented with just 1 line of code, although that 1 line may be a call to a helper function. If you wrote more than 1 line, you are probably overthinking it.

**Problem 3** (📝): Give two examples of `e` for which `wf ["x"] e` will return `false`, and one example of `e` for which `wf ["x"] e` will return `true`.




### 3.4 Semantics

**Problem 4** (🧑‍💻, 5 points): Implement the free variable function `free_vars: expr -> Vars.t` that computes the set of free variable references in an expression. The `Vars` module provides a type (`Vars.t`) to represent a set of strings, and functions that operate on such sets, e.g.:
```ocaml
(* the empty set *)
val empty : Vars.t
(* add a string to a set *)
val add : string -> Vars.t -> Vars.t
(* take the difference of two sets *)
val diff : Vars.t -> Vars.t -> Vars.t
(* check if a set contains a string *)
val mem : string -> Vars.t -> bool
...
```
Please refer to `vars.mli` for the full list of functions in the `Vars` module.

*Hint*: The only interesting cases are `Var` and `Scope`.



**Problem 5** (🧑‍💻, 15 points): Finish the implementation of the substitution function 
```ocaml
let rec subst (x: string) (e: expr) (c: expr) : expr = 
    match c with
    ...
```
Here, `subst x e c` denotes the substitution `c[x |-> e]`, i.e., substituting all free occurrences of `x` in context `c` with expression `e`.

You don't need to implement capture-avoiding substitution, or do any kind of alpha-renaming. You can also assume that `e` is well-formed, and you should maintain the invariant that `c` is part of a well-formed expression.

*Hint*: The only interesting cases are `Var` and `Scope`.


**Problem 6** (⭐️bonus⭐️, 3 points): Modify the `Scope (x, e)` case of your `subst` function to implement capture-avoiding substitution using alpha-renaming.

> **Important note**: If you choose not to do this problem, you should still understand how to do alpha-renaming and capture-avoiding substitution on a conceptual level, since you may be asked to do so in the midterm.

To be consistent with the autograder, whenever you need to alpha-rename some name `y` of a binder `scope y in e`, you should rename `y` to `yn` where `n` is the smallest natural number such that using `yn` as an argument will not capture any variables. Here are some examples of alpha renaming:
* `(lambda x, y. x y) (lambda x. y)` will evaluate to `(lambda y0. (lambda x. y) y0)`.
* `(lambda x, y. x y y0) (lambda x. y)` will evaluate to `(lambda y1. ((lambda x. y) y1) y0)`
* `(lambda f, y. let y0 = 5 in y) (lambda x. y)` will evaluate to `lambda y0. let y00 = 5 in y0`
* `(lambda z. lambda y. let x = 5 in z) (lambda y. x)` will evaluate to `lambda y. let x0 = 5 in lambda y. x`

We suggest implementing a helper function for finding the next available name and testing it separately. By default helper functions are not visible outside the file they are defined in. To make them visible, simply add the type signature of your helper function to `eval.mli`.



**Problem 7** (🧑‍💻, 15 points): Finish the implementation of the interpreter
```ocaml
let rec eval (e: expr) : expr = 
    match e with
    ...
```
The `eval` function will "run" your program by performing binary operations, evaluating function arguments, applying arguments to functions using `subst`, etc. You might want to refer to Section 4 (Operational Semantics) of the [language reference manual](https://github.com/fredfeng/CS162/blob/master/homework/lamp.pdf) for the precise meaning of each language construct. If no evaluation rule applies, then your interpreter should call `im_stuck` to signal that the interpreter is stuck.

You can assume that the input expression is well-formed.

---
Now you have a working interpreter for a Turing-complete programming language! Since we've also written a parser for you, you can run your interpreter interactively like you run `utop`, or use it to run program files. To run it interactively, simply run
```bash
dune exec lib/lamp/repl.exe
```
After which you should see a welcome message, and a prompt `>` after which you can type in expressions to evaluate. For example:
```
Welcome to lambda+! Built on: Wed Jan 24 12:54:56 PST 2024
> 1 + 1
<== 1 + 1
==> 2
```
Use the ⬆️/⬇️ arrow keys to navigate the history of commands you typed in. 

You can also run your interpreter on a program file with
```bash
dune exec lib/lamp/repl.exe -- <path-to-file>
```
We provided some example programs in `lib/lamp/examples`.

We also wrote a reference interpreter located on CSIL at `~junrui/lamp` which you can use to compare the output of your interpreter. 
To run the reference interpreter, simply run `~junrui/lamp` (interactive mode) or `~junrui/lamp <path-to-file>` (file mode). 

> If you discovered any bug in the reference interpreter, please let us know!


## Part 4. Church Encoding

> This part is completely optional.
> 
> Total: 3 ⭐️bonus⭐️ points

In lectures, we learned that lambda calculus is super powerful, and can express all kinds of data structures and operations, e.g., booleans, natural numbers, etc. Of course, lambda calculus doesn't support booleans or natural numbers natively, so we had to find a way to *encode* them into expressions that are valid in lambda calculus. Although those *Church encodings* don't look like their counterparts, they have the same *behavior* as their counterparts.

> *Tip*: For this part, you'll be writing a lot of lambda calculus expressions. You can use our reference interpreter on CSIL to play the expressions you came up with. You may also find it helpful to use them as realistic cases to stress-test the interpreter you wrote in part 3.


### 4.1 Why Should I Care about Church Encoding?

Before diving into the Church encoding, let's first motivate why we care about it in the first place. After all, *half* of this README is taken by this bonus part on Church encoding that you don't even have to do, so it better be worth your time in case you choose to do it!

Your first reaction to Church encoding might be: 

> 1. Since almost every sensible programming language already has booleans and numbers built in, why should we even bother to go through the mental gymnastic of encoding booleans and natural numbers into the language? Why doesn't lambda calculus also just treat them as primitives, like every other language?
> 
> 2. Is Church encoding just some academic exercise that has no practical value? As a future software engineer, or someone who's probably not gonna use functional programming in my day job[^1], why should I care?


[^1]: unless you work at Jane Street, of course


To answer the first question, note that when we encounter a new language, one of the most important questions we might want to ask is:

*"How expressive is this language?"*

For example, using this new language, can we do things like: integer arithmetic? branching? loops and recursion? procedural abstraction? mutable memory? message passing? generics?

The programming language we choose will fundamentally shape the way we think about and solve problems. So we really want expressive languages that make it easy to express a wide range of problem-solving paradigms. 

However, the more features the language has, the more difficult for us to understand, master, and analyze it. This is because *every* language feature can potentially interact with *any other* feature, and may lead to complex behaviors that might not be apparent just by looking at the individual features in isolation. If the language has N features, then we may need to understand $2^N$ possible interactions between them!

This leads to a fundamental tension of language design: we want *expressive* languages, but we also want *easily understandable* languages. This can be a very hard question for language designers. 


Fortunately, there's a simple trick that allows us to have the best of both worlds: say a language has both feature `X` and `Y`, and we know that `Y` can be realized by translating it to `X`. Then, we just need to study the language with feature `X`, and we can ignore `Y` completely, since any program that uses `Y` can be turned into an equivalent program that just uses `X`. In programming language theory, we call `Y` a *syntactic sugar*, and the process of turning `Y` into `X` is called *desugaring*. 

For example, you have probably learned that if a language has both for-loops and while-loops, then any program with for-loops can be translated into an equivalent one with *only* while-loops:

```Java
for (int i = 0; i < 10; i++) {
    for (int j = 0; j < 10; j++) {
        System.out.println(i + j);
    }
}

==[desugar]=>

int i = 0;
while (i < 10) {
    int j = 0;
    while (j < 10) {
        System.out.println(i + j);
        j++;
    }
    i++;
}
```
And we say that for-loops are just a syntactic sugar for while-loops.


Intuitively, syntactic sugars do not make a language more expressive, because they can be de-sugared away into the primitive features of the language. Thus, we can make the following observation:

*Syntactic sugars do not change the expressive power of a language.*

Based on this observation, a language designer can reduce the full language into a *core language* that is as expressive as the full language, but it will have a more compact set of *primitive* features that are easier to understand and analyze.

The process of encoding booleans and natural numbers into lambda calculus is the same deal: removing them from lambda calculus makes the language simpler, but the encoding shows that the smaller language retains the same expressive power as the full language. In fact, we shall see that in addition to booleans and natural numbers, we can Church-encode many other fancy data structures into lambda calculus, including
- `option`,
- products like `bool * nat`
- `list`,
- `tree` and ... 
- ... *wait for it* ...
- ... `expr` itself! 

That is, we can represent a lambda calculus AST as a lambda function!

In fact, we can further write the interpretation function `eval : expr -> expr` as a lambda function. That is, you didn't have to write the `eval` function in OCaml at all -- lambda calculus is so powerful that we can just write the interpreter for lambda calculus, *in lambda calculus*!

> **Universality**: If a language $L$ is expressive enough to encode and interpret itself, we say that $L$ is a *universal language*.

Universality is like a singularity point: once a language achieves universality, it can start to simulate any other language (universal or not). This is the ultimate reason we care so much about encoding things into lambda calculus, because we can eventually encode lambda calculus itself into lambda calculus, **proving that lambda calculus is a universal language and hence Turing-complete**!


Now, a response to the second question (whether Church encoding has any practical value) is that, we're going to show you a recipe by which we'll use to derive the Church encoding of various data structures. As it turns out, the recipe will reveal a *deep connection* between functional program and, surprisingly, **object-oriented programming**! If you think you need to use an object-oriented language like Python, Java, or C++ in the future, then learning about Church encoding will allow you to see those languages in a new light.


Anyway, we hope that's enough motivation to convince you that this part of the assignment will be worthy of your time. Although we'll just do Church encoding of `bool` and `option` in this assignment, in HW3, we'll show you how to apply the same recipe to derive an encoding of `nat` (the simplest recursive data structure) and subsequently to all kinds of crazy data structures like lists, trees, and the ASTs of lambda calculus itself. So you've also got something to look forward to in the meantime!

Let's get started!


### 4.2 Making Something vs Using Something

In HW1, we learned that for every type, there are two kinds of operations that we can do with it:
1. **Making** something of that type
2. **Using** something of that type

In programming languages and type theory, people sometimes call the first kind of operations the **introduction form** of the type, and the second kind of operations the **elimination form** of the type.

For example, we can **make**
- a boolean with `true` or `false`
- an `option` with `Some ..` or `None`
- a product with `( , )`
- a list with `[]` or `::`
- a tree with `Leaf` or `Node`
- an `expr` AST with `Num`, `Var`, `Binop`, `Lambda`, `App`, or `Let`

We say that `true` and `false` are the introduction form for `bool`, and `Some` and `None` are the introduction form for `option`, etc.


And we can **use**
- a boolean with `if` or `match`
- an `option` with `match`
- a product with `match`
- a list with `match`
- a tree with `match`
- an `expr` AST with `match`

We say that `if` (or `match`) is the elimination form for `bool`, and `match` is the elimination form for `option`, etc.


**Exercise** (📝): Consider the function type `t1 -> t2`. What is the introduction form and the elimination form for this type? I.e., how do you make a function of type `t1 -> t2`, and given you possess a function of type `t1 -> t2`, what can you do with it?

The important thing to notice is that, in OCaml, a type is *defined* by its introduction form (aka constructors). For example, `option` is defined as
```ocaml
type 'a option = Some of 'a | None
```
in which we simply enumerate the two possible ways we can *make* an `option`.

Once a type is defined in OCaml, we get its elimination form automatically, for free, using pattern match. For example, we never *defined* that `option` can be deconstructed with `match`. We just silently start to pattern-match on options as if it were built into the language.

> **Takeaway**: In OCaml, a type or a data structure is defined by its introduction form, and we get its elimination form for free.

Now, since we want to encode those fancy types and data structures into lambda calculus, we might want to first try to encode their introduction forms (i.e. constructors) as lambda expressions, right?

Well, unfortunately, this is not going to work, as lambda calculus doesn't have the feature of "data types" built in, like OCaml does, so we can't possibly say "a boolean is either true, or false", or "a product t1 * t2 is both t1 and t2" in lambda calculus.

But!

Note that introduction form is just one side of the story. We also have elimination form, which is in some sense *dual*, or *symmetrical*, to introduction form. Previously, we handed OCaml with the introduction form, and OCaml spits out the elimination form for free. Why don't we try the other direction? In other words, let's try **defining a data structure by its elimination form**, and see if we can get its introduction form for free. The hope is that, unlike introduction form, we might be able to encode elimination forms more easily into lambda calculus.


### 4.3 Eliminating Booleans

To get a feel for elimination form, let's consider the simple example of booleans. Given a `bool`, its elimination form specifies how we can **use** it. In OCaml, assuming that we we have a `bool`, we can use it by branching on whether it's true or false via `if` or `match`. For example, we can write
```ocaml
if b then 
    do something 
else 
    do something else
```
which is equivalent to
```ocaml
match b with
| true -> do something
| false -> do something else
```

The above is the elimination form for `bool`. Ultimately, we want to encode those things into functions (which is the only thing lambda calculus has, mind you). Luckily, OCaml has a copy of lambda calculus inside it (e.g., `lambda x. e` is written as `fun x -> e` in OCaml). So let's do some experiments in OCaml first. Once we're convinced we have a working solution, we'll translate it into lambda calculus.

Let's try to turn `if` expressions -- the elimination form of `bool` -- into an OCaml function. Intuitively, this function should at least take three arguments: the boolean `b` we're branching on, the "then" branch, and the "else" branch. So we can write
```ocaml
let if_as_a_function (b: bool) (then_case: 'a) (else_case: 'a) : 'a = 
    if b then
        then_case
    else
        else_case
```
This is a perfectly fine function, and it behaves the same as `if` expressions. That is, given any `if .. then .. else ..`, we could have replaced it with `if_as_a_function .. .. ..` and the program would still behave the same. (Small asterisk: the same most of the time, to be precise, but let's not worry about that now; we'll worry about this in the next homework. The slight difference has to do with evaluation order).

For example, if we have `if true then 1 else 2`, we can replace it with `if_as_a_function true 1 2`, and the program will behave the same.

Actually, we're extremely close to encoding `bool` into lambda calculus, since now we have a *function* that corresponds exactly to the elimination form of `bool`. The last thing to do is to observe the type of `if_as_a_function`, which is
```ocaml
val if_as_a_function : bool -> 'a -> 'a -> 'a
```
That is, `if_as_a_function` is a function that, given
- a boolean
- what to do in the "then" branch, which has type `'a`
- what to do in the "else" branch, which also has type `'a`

gives us back 
- a result depending on whether the boolean is `true` or `false`. The type of the result is the same as the type of the "then" branch and the "else" branch, so it's also an `'a`.

Now comes the brain-twister: this `if_as_a_function` assumes we already have `bool` as a previously defined type in our language; what we want to do instead is to encode `bool` in the first place, since lambda calculus doesn't have `bool`! So the magical move is to (pun intended) *move* `bool` from the argument list into the left-hand-side of an equation:
```ocaml
bool -> 'a -> 'a -> 'a
==>
bool_encoding = 'a -> 'a -> 'a
```
Simple as that! That is, we **define** the encoding of `bool` to be any function of this type. Effectively, we're saying that `bool` is basically the same as a function that, if we tell it what to do in the "then" branch and what to do in the "else" branch, it will pick one branch and tell us what the result is going to be.

This might seem paradoxical. We haven't even talked about how to make booleans -- all we said was that how to use them! But this is the magic of definition by elimination form: we define a type by how to use it, and after that we can derive the usual introduction form for free, which we do now.

Since the introduction forms for `bool` in OCaml are `true` and `false`, we need to encode each of them into something of type `'a -> 'a -> 'a`. So we want to define
```ocaml
val true_encoding : 'a -> 'a -> 'a
val false_encoding : 'a -> 'a -> 'a
```
The good thing is, there's no cleverness involved when we want to derive introduction form from elimination form, just as there wasn't any cleverness when OCaml derived the elimination from from the introduction form we provided! We can mechanically arrive at the definition of `true_encoding` just based from what we have. To see what `true_encoding` has to be, all we need to do is to call the elimination function on `true`:
```ocaml
if_as_a_function true then_case else_case
== if true then then_case else else_case
== then_case
```
To put it in another way, if we encode `true` into a function, it should behave the same as the function `if_as_a_function true`. This leads us to the following definition
```ocaml
let true_encoding (then_case: 'a) (else_case: 'a) : 'a =
    if_as_a_function true then_case else_case
```
which we saw was equivalent to
```ocaml
let true_encoding (then_case: 'a) (else_case: 'a) : 'a =
    then_case
```
The type of `true_encoding` is `'a -> 'a -> 'a`, which is what we want for the encoding of `bool` as functions :)

To recap what we just did:

1. We implemented the elimination form of `bool` as a function, whose type is `bool -> 'a -> 'a -> 'a`.

- Then, we changed `bool -> 'a -> 'a -> 'a` into `bool_encoding = 'a -> 'a -> 'a`. I.e., we said that an encoded `bool` is basically just a function of type `'a -> 'a -> 'a`, whose first argument is what to do in the "then" branch and whose second argument is what to do in the "else" branch. This function gives the result depending on which branch we are in.

- Finally, we derived the usual introduction from from the elimination form. Specifically, we naturally obtained the function `true_encoding` that behaves the same as `true`, by simply calling `if_as_a_function true`. According to this definition, `true_encoding` is a function that, given what to do in the "then" branch and what to do in the "else" branch, will always take the "then" branch and ignore the "else" branch.

**Problem 1** (📝): Follow the same recipe and derive `false_encoding` as an OCaml function of type `'a -> 'a -> 'a`.



### 4.4 Church Encoding of Booleans

Now that we know how to encode booleans into functions in OCaml, we can repeat the same steps, but in lambda calculus. So let's translate `true_encoding` and `false_encoding` into lambda expressions!

As an example, we defined `true_encoding` as
```ocaml
let true_encoding (then_case: 'a) (else_case: 'a) : 'a =
    then_case
```
This function definition is equivalent to a version that uses anonymous function syntax `fun x -> e`:
```ocaml
let true_encoding = 
    fun (then_case: 'a) (else_case: 'a) : 'a ->
        then_case
```
Using currying, the above can be seen as identical to:
```ocaml
let true_encoding = 
    fun (then_case: 'a) -> 
        fun (else_case: 'a) : 'a -> 
            then_case
```

Since lambda calculus doesn't have types (yet), we just erase them to get the lambda expression:
```math
\lambda \textsf{ThenCase}.\ \lambda \textsf{ElseCase}.\ \textsf{ThenCase}
```

where we simply replaced `fun` with $\lambda$, and `->` with `.`.

This is exactly what you saw in lectures, modulo alpha-renaming:

$$
\lambda x.\ \lambda y.\ x
$$


**Problem 2** (📝): Translate `false_encoding` into lambda calculus.


**Problem 3** (📝): We said the `if_as_a_function` is the elimination form for boolean. In fact, it is *the most general* elimination form, since any other boolean functions you can think of can be implemented in terms of `if_as_a_function`. For example, the negation function `neg : bool -> bool` can be defined as
```ocaml
let neg (b: bool) : bool = 
    if_as_a_function b false true
```

For this exercise, use `if_as_a_function` to define:
- AND $\wedge$ of type `bool -> bool -> bool`
- OR $\vee$ of type `bool -> bool -> bool`
- XOR $\oplus$ of type `bool -> bool -> bool`
- IMPLY $\Rightarrow$ of type `bool -> bool -> bool`

You should only use `if_as_a_function`, `true` and `false`. You may not use if expressions, or built-in boolean operators like `&&` or `||`.

**Problem 4** (⭐️bonus⭐️, 2 points): 
Based on our answers to the previous exercise, we can derive the lambda-calculus encodings of those boolean functions in a straightforward way. 

For example, `neg` was defined in OCaml as (equivalently) `fun b -> if_as_a_function b false true`. Note that any **encoded boolean** in lambda calculus does exactly what `if_as_a_function b` does: taking two branches and decide which branch to take. So we just erase `if_as_a_function` and get 
```math
\lambda b.\ b \ \textsf{False} \ \textsf{True}
```

where $\textsf{False}$ and $\textsf{True}$ are the lambda-calculus encodings of `false` and `true` which we already derived. So expanding everything out, we get the full encoding of the negation function
```math
\lambda b.\ b \ (\lambda x.\ \lambda y.\ y) \ (\lambda x.\ \lambda y.\ x)
```


Your task is do the same for the other boolean functions you have defined in the previous exercise. Afterwards, run the lambda calculus expressions you came up with on our $\lambda^+$ reference interpreter on CSIL or your own interpreter.

To test your encoding, we provided the test program `test/test_part4.lp`. You can define replace `bonus` with your solution, enable one of the commented-out tests, and run the program using an interpreter. We provided the `to_int` function to convert a Church-encoded boolean into an integer constant, so you can more easily see what the output of your boolean functions are.

Once you're done, copy and paste your solution into `lib/part4/*.lp`, and submit those files to gradescope.


> **Background note**: If you're familiar with object-oriented programming (say in Python), what we did to encode `bool` into lambda calculus was basically first defining the following `Bool` abstract class:
> ```python
> class Bool:
>   @abstractmethod
>   def if_then_else(self, thn, els):
>     pass
> ```
> Then we basically defined a subclass `True` that implements `if_then_else` by always spitting out the first branch:
> ```python
> class True(Bool):
>   def if_then_else(self, thn, els):
>     return thn
> ```
> Thus, a `True` object "knows" that when it's being **used**, it must always take the `then` branch. Similarly, we can define a `False` class, and any `False` object "knows" that when it is being used, it must always take the `else` branch.
> 
> If we allow ourselves to generalize a bit, we can say object-oriented programming makes it natural to **define the elimination forms of a type**, whereas functional programming makes it natural to define types by their introduction form. The two approaches are complimentary, and are in fact dual to each other. Sometimes working with one form might be easier than working with the other, so it's good to know both.
> 
> In fact, in the next assignment, we will see that the [*visitor design pattern*](https://en.wikipedia.org/wiki/Visitor_pattern) you may have seen in object-oriented programming is just the *elimination form of recursive data types*.



### 4.5 Encoding Options

Let's use the same recipe to derive the lambda calculus encoding of `option`, which will be quite similar to booleans.

The elimination form of `'a option` is 
```ocaml
match opt with
| None -> do something
| Some x -> do something else with x in mind
```

**Problem 5** (📝): Use pattern-match to define `elim_option` as an OCaml function:
```ocaml
let elim_option 
    (opt: 'a option) 
    (none_case: 'result) 
    (some_case: 'a -> 'result) : 'result = (* todo *)
```


The type of `elim_option` is `'a option -> 'result -> ('a -> 'result) -> 'result`. That is, `elim_option` is a function that, given
- an `'a option`
- what to return in the `None` case, which has type `'result`
- what to return in the `Some` case, which is a function that takes the `'a` wrapped in the `Some` constructor and outputs a `'result`

and gives us back a `'result` depending on whether the input option was `None` or `Some`.


**Problem 6** (📝): Re-implement `join2 : 'a option -> 'b option -> ('a * 'b) option` from Part 1 using `elim_option` **without using pattern-match on options**.


---

When encoding booleans, we had an elimination function `if_as_a_function: bool -> 'a -> 'a -> 'a`. We then moved `bool` to the left-hand-side of an equation, and declared that
```ocaml
bool_encoding = 'a -> 'a -> 'a
```

Similarly, since the type of `elim_option` is `'a option -> 'result -> ('a -> 'result) -> 'result`, we can move `'a option` to the left-hand-side of the equation, and declare that
```ocaml
option_encoding = 'result -> ('a -> 'result) -> 'result
```
That is, in OCaml/lambda calculus, an encoded option is basically a function that, given
- what to do in the `None` case, which has type `'result`
- what to do in the `Some` case, which takes some `'a` and gives us back a `'result`

gives us back a `'result` based on whether the option was `None` or `Some`.

**Problem 7** (📝): Define `none_encoding` as an OCaml function of type `'result -> ('a -> 'result) -> 'result`. *Hint*: don't overthink; just derive its definition by expanding `elim_option None`, like what we did for `true_encoding`.

**Problem 8** (📝): Since the `Some` constructor is kinda like a function `'a -> 'a option`, we can define `some_encoding` as an OCaml function with type 
```ocaml
'a -> ('a option_encoding)
```
Implement `some_encoding`. *Hint*: don't overthink; just derive its definition by expanding `elim_option (Some x)`.

**Problem 9** (⭐️bonus⭐️, 1 point): Translate `none_encoding` and `some_encoding` from OCaml to lambda calculus in `lib/part4/{none,some}.lp`. Once you're done, submit those files to gradescope.