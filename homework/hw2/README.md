# Homework Assignment 2

**Due Friday, Feb 7th at 11:59PM (Pacific Time)**

## Overview

In this assignment, you will augment the simple arithmetic language in the last assignment with lambda calculus. The resulting language is called $\lambda^+$. This language is so powerful that it can simulate the execution of any Turing machine, and thus any computer program in any programming language: C++, Python, Java, or your favorite programming language.

This assignment consists of two parts:
- Part 1 gives you some practice with higher-order functions in OCaml.
- Part 2 implements an interpreter for $\lambda^+$ in OCaml.


## Instructions

1. Either clone this directory, or download the zipped directory using [this link](https://download-directory.github.io/?url=https%3A%2F%2Fgithub.com%2Ffredfeng%2FCS162%2Ftree%2Fmaster%2Fhomework%2Fhw2).
2. Run `opam install . --deps-only` in the root directory of this homework to install the necessary dependencies. **You need to run this command again even if you did so for hw1**, since this assignment has new dependencies that were not used in HW1.
3. Complete `lib/part1/part1.ml` and `lib/part2/eval.ml` by replacing the placeholders denoted by `todo` or `bonus` with your own code. You must not change the type signatures of the original functions. Otherwise, your program will not compile. If you accidentally change the type signatures, you can refer to the corresponding `.mli` file to see what the expected type signatures are.
4. Once you're done, run `make zip`, which will create a zip file containing `lib/part1/part1.ml` and `lib/part2/eval.ml`. Please upload this file to Gradescope. If your program contains print statements, please remove them before submitting. You do not need to submit any other file, including any `.mli` file or test code. The autograder will automatically compile your code together with our testing infrastructure and run the tests.


**Important notes**:
* Problems marked with `📝` are pencil-and-paper problems, and are ungraded. You do not need to submit your solution. The goal is to review concepts that will help you solve subsequent problems, and/or to give you some practice with the kinds of questions that will appear on the final. Solutions to these problems will be released by the TAs and discussed in sections.
* Problems marked with `🧑‍💻` are programming tasks, and will be autograded on Gradescope. There are 8 of them in total. In solving those problems:
  * You are **not** allowed to use in built-in OCaml library functions in your solutions unless explicitly permitted. If you do, you will not be awarded any points. Note that language features like pattern-matching do not count as library functions. You may use library functions like `Format.printf` and `Int.equal` to test your code, but you must remove them before submitting.
  * You are **not** allowed to use any kind of imperative features, including mutable state (e.g. references and arrays), loops, etc. If you do, you will not be awarded any points.
* Problems marked with `⭐️bonus⭐️` are optional. You will receive extra credit by solving them. You will not be tested on them in the midterm *unless we explicitly say so*.
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
    ([ 6; 7; 3 ], [ [ 6 ]; [ 7 ]; [ 3 ] ] );
  ]
```
which is a list of (input, expected output) pairs. You can add your own test cases by adding more elements to the list.


## Part 1. Higher-Order Functions in OCaml

> **Important notes**: 
> 1. You may **not** use recursion (i.e., the `rec` keyword) to solve problems in this part. If you do, you will not be awarded any points. Instead, use higher-order functions like `List.map`, `List.filter`, and `List.fold_left`. These are already defined in the standard library, and you find the documentation for these functions [here](https://ocaml.org/manual/5.3/api/List.html).
> 2. You only need to modify `lib/part1/part1.ml`.

In OCaml, functions can take other functions as input, and return other functions as output. This is a very powerful feature that allows us to write very concise code. You have seen simple instances of higher-order function in HW1. For example, your `compress` has type `('a -> 'a -> bool) -> 'a list -> 'a list`, so it's a function whose first argument is another *function* of type `'a -> 'a -> bool` which is used to compare two elements of type `'a`.

#### Problem 1.1 (📝)

In OCaml, a function can be defined using `let`, in which case the function has a name. However, sometimes we just want to make a one-off function on-the-fly, without giving it a name. These functions are called *anonymous functions*, or *lambda functions*, and can be defined using the syntax 
```ocaml
fun <arg1> <arg2> ... <argn> -> <body>
```
Using this syntax, write down a function of type `int -> int -> int -> int` that takes three integers and returns their sum.


#### Problem 1.2 (📝)

Without looking at the lecture slides:
- Informally describe what each of `map`, `filter` and `fold` does, and give an example of how to use each of them.
- Write down the type signature of each of them. Check your solution against TODO. It's ok to reorder some of the arguments.
- Try writing down the implementation of each of them. Then compare what you wrote with the implementation in the lecture slides.


#### Problem 1.3 (🧑‍💻, 1 point)

Using `List.map`, complete the implementation of
```ocaml
let singletons (xs : 'a list) : 'a list list = 
    map <your code here> xs
```
which takes a list and returns a list of singleton lists, each containing one element from the original list. For example, `singletons [6; 7; 3]` will evaluate to `[[6]; [7]; [3]]`.

You may not use recursion or pattern matching in your solution. If you do, you will not be awarded any points.


#### Problem 1.4 (🧑‍💻, 2 points)
Using `List.map`, define the function `map2d : ('a -> 'b) -> 'a list list -> 'b list list` that applies a function to every element in a 2d list. Example:
```ocaml
map2d (fun x -> x + 1) [[1; 2]; [3; 4]] = [[2; 3]; [4; 5]]
```
You may not use recursion or pattern matching in your solution. If you do, you will not be awarded any points.

*Hint*: Use `List.map` twice.


#### Problem 1.5 (🧑‍💻, 3 points)

Using `List.map` and anonymous functions, define the function `product : 'a list -> 'b list -> ('a * 'b) list list` that computes the cartesian product of two lists. For example, `product [1; 2] [true; false]` will evaluate to
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

*Hint*: Use `List.map` twice.



#### Problem 1.6 (📝)
The `fold` function you saw in lectures is called `List.fold_left` in the OCaml standard library, since it folds the list from left to right. It has the following type signature:
```ocaml
val fold_left : ('acc -> 'a -> 'acc) -> 'acc -> 'a list -> 'acc
```

There's a symmetric function called `List.fold_right` that folds the list from right to left, whose type signature is:
```ocaml
val fold_right : ('a -> 'acc -> 'acc) -> 'a list -> 'acc -> 'acc
```

On a piece of paper, write down a recursive implementation of `fold_right`. Once you're done, compare your solution with the implementation in the OCaml standard library. You can find the implementation [here](https://github.com/ocaml/ocaml/blob/c82ce40504f0875969bf86b22e4d6ec7e26b3153/stdlib/list.ml#L125).


#### Problem 1.7 (📝)

Most recursive functions on list can be instead implemented using `List.fold_left` or `List.fold_right` without using recursion.

As an example, recall the [`lookup` function from HW1](https://github.com/fredfeng/CS162/tree/master/homework/hw1#problem-4--5-points). We can re-implement it without recursion by using `List.fold_right`:
```ocaml
let lookup (equal: 'k -> 'k -> bool) (key: 'k) (dict: ('k * 'v) list) : 'v option =
    List.fold_right 
        (fun (key', value) result -> if equal key key' then Some value else result)
        dict
        None
```

Thought experiment: Can you define an equivalent `lookup` using only `List.fold_left`? If so, how? What input function would you pass to `List.fold_left`?



#### Problem 1.8 (📝)
Re-implement the following functions using **both** `List.fold_left` **and** `List.fold_right` **without** writing explicit recursion, like what we did in Problem 7. You may find `@` and `::` helpful in some of the problems. Note: there are problems can only be solved using either `List.fold_left` or `List.fold_right` but not both.
1. `compress` from HW1
2. `max` from HW1
3. `join` from HW1
4.  Problems 3-5 from this part of the assignment.
5. `map`
6. `filter`
7. `length: 'a list -> int` that returns the length of a list
8. `id: 'a list -> 'a list` that returns the input list unchanged. You must call `List.fold_left` or `List.fold_right` in your solution. Don't define the function `id` as `let id x = x`.
9. `rev: 'a list -> 'a list` that reverses a list
10. `append: 'a list -> 'a list -> 'a list` that appends two lists. Note that this is the same function as `@`, so don't use `@` in your solution for this problem specifically.
11. `flatten: 'a list list -> 'a list` that flattens a list of lists into a single list. For example, `flatten [[1; 2]; []; [3; 4]; [5]]` will evaluate to `[1; 2; 3; 4; 5]`.
12. `concat_map: ('a -> 'b list) -> 'a list -> 'b list` that maps a function over a list and concatenates (flattens) the results. For example, `concat_map (fun x -> [x; x + 1]) [1; 3]` will evaluate to `[1; 2; 3; 4]`.



#### Problem 1.9 (🧑‍💻, 5 points)

Implement the function `power : 'a list -> 'a list list` that will take a list representing a set, and return a list representing the *power set* of the input set. The power set of set $S$ is the set of all subsets of $S$. For example, `power [1; 2; 3]` will evaluate to
```ocaml
[ []; [ 1 ]; [ 2 ]; [ 3 ]; [ 1; 2 ]; [ 1; 3 ]; [ 2; 3 ]; [ 1; 2; 3 ] ]
```
Neither the order of the elements in each subset nor the order of the subsets matters for the purpose of grading.

You may *not* use recursion or pattern matching in your solution, or define helper functions that use recursion or pattern-matching. If you do, you will not be awarded any points. However, you can use the following higher-order functions: `List.map`, `List.filter`, `List.fold_left`, and `List.fold_right`. You may also use `@`. (Note that `::` and `[]` are not functions; they are just constructors/tags, so you can freely use them.)

*Hints*:
1. You need to use two higher-order functions, one nested inside the other.
2. Don't skip Problem 8, which will give you lots of practice with higher-order functions.
3. You can try solving this problem recursively first, and then pattern-match your code with the recursive definition of the various higher-order functions to see what's common and what differs. The common parts will be abstracted out into higher-order functions, and the differing parts will be passed as arguments to these functions.



---
#### Problem 1.10 (🧑‍💻, 1 point)

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


Consider the function `both`:
```ocaml
let both (x: 'a option) (y: 'b option) : ('a * 'b) option =
    match x, y with
    | Some x, Some y -> Some (x, y)
    | _ -> None
```
The `both` function takes two options, and if both are `Some`, it returns a `Some` that contains a pair of the two values. Otherwise, it returns `None`. This is similar to the `join` function you implemented in HW1, but for products instead of lists.

You task is to re-implement `both` as an explicitly one-argument function that returns another function as its output:
```ocaml
let both : 'a option -> ('b option -> ('a * 'b) option) =
    fun x ->
       match x with
       | Some x -> (* todo *)
       | None -> (* todo *)
```



## Part 2. Lambda Calculus

> You only need to modify `lib/part2/eval.ml`.

In this part, we will augment the simple arithmetic expression language defined in the previous assignment with lambda calculus. We'll call resulting language is $\lambda^+$. 

Since this is not a toy language anymore, the language will have a well-defined syntax and semantics. We wrote a parser that turns concrete syntax into abstract syntax for you, so you can focus on building the interpreter that consumes abstract syntax trees as input. But it helps to understand the concrete syntax since it may be easier for you to write test programs using the concrete syntax.



### Notes on Concrete Syntax and Informal Semantics

You can read about the informal semantics and the concrete syntax of $\lambda^+$ in the Overview section of the $\lambda^+$ [language reference manual](https://github.com/fredfeng/CS162/blob/master/homework/lamp.pdf). **Only sections up to and including Section 2.3 (Named Function Definitions) are relevant for this assignment.** The remaining language constructs will be the focus of the next assignment.You're encouraged to quickly scan through the reference manual first without worrying about the details. You can revisit it later when you're working on the problems in this part.

The language itself is basically the arithmetic expression language you implemented in HW1, augmented with lambda calculus, and it largely resembles OCaml modulo some syntactic differences. There are, however, a few things that are worth pointing out:


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
    So in the type definition of the AST, you will only see binary function applications being represented.

4. Named function definitions like `fun f with x = e1 in e2` is just a syntactic sugar for `let f = lambda x. e1 in e2`. The parser will de-sugar them for you. So in the AST, you won't see function definitions being explicitly represented as one of the cases in the type definition of the AST.



### Notes on Abstract Syntax

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

Although this representation is conceptually simple, working with it would unfortunately result in a lot of code duplication. The reason is that both the `Lambda` and `Let` cases are both binders: they *declare* a variable name to be in scope in some body expression. Thus, if we want to define substitution for `Lambda` and `Let`, then we would end up repeating a lot of code in the two cases. Furthermore, since the next assignment will augment $\lambda^+$ with more features that involve binding, any code duplication would only be multiplied, if we don't prevent it now.

Thus, we will factor out the common pattern of binding into separate constructors:

```ocaml
type binop = Add | Sub | Mul
type 'a binder = string * 'a
type expr = 
          (* arithmetic *)
          | Num of int
          | Binop of binop * expr * expr
          (* variable *)
          | Var of string
          (* lambda calculus *)
          | Lambda of expr binder
          | App of expr * expr
          (* let expression *)
          | Let of expr * expr binder
```

In this representation, we use the `binder` type to represent a variable binding operation. Specifically, `'a binder` is a pair whose first component is the name of the variable being bound, and the second component is the scope of the variable. For this assignmnet, the scope will always be `expr`, so this generic type will always be instantiated to `expr binder`, which is just `(string * expr)`. 

The previous example `(lambda f. f 0) (lambda x. let y = x + 1 in y)` will be now parsed into the following `expr`:
```ocaml
App (
    Lambda ("f", App (Var "f", Num 0)), 
    Lambda ("x", 
        Let (
            Add (Var "x", Num 1), 
            ("y", Var "y"))))
```

Note that for `Let`, the expression whose value will be bound to the variable is the **first** argument to the `Let` constructor, and the second argument is the binder pair. For example, the following is the wrong representation of `let y = x + 1 in y`:
```ocaml
Let (
    ("y", Add (Var "x", Num 1)),
    Var "y")
```
because `y` should *not* be in scope in the expression `x + 1`.


#### Problem 2.0 (📝)
Pretend you are the parser. For the following programs in concrete syntax, write down the abstract syntax tree as a value of type `expr`.
1. `let x = 2 in let y = x * x in x + y`
2. `(lambda x, y. let z = x + y in z * z) 2 3`
3. `fun f with x = let x = x + 1 in x in f f`



---
### Problems

#### Problem 2.1 (🧑‍💻, 5 points)

Implement the free variable function `free_vars: expr -> Vars.t` that computes the set of free variable references in an expression. The `Vars` module provides a type (`Vars.t`) to represent a set of strings, and functions that operate on such sets, e.g.:
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
Please refer to `vars.mli` for the full list of functions in the `Vars` module. In your code, you can call these functions as `Vars.empty`, `Vars.add`, etc.

You can use `String.equal : string -> string -> bool` to compare strings for equality.

*Hints*:
1. Define a helper function to handle binders.
2. The only interesting cases are `Var` and binders.



#### Problem 2.2 (🧑‍💻, 15 points)
Finish the implementation of the substitution function 
```ocaml
let rec subst (x: string) (e: expr) (c: expr) : expr = 
    match c with
    ...
```
Here, `subst x e c` denotes the substitution `c[x |-> e]`, i.e., substituting all free occurrences of `x` in context expression `c` with expression `e`.

For this problem, you can also assume that `e` contains no free variables. As a corollary, you don't need to implement capture-avoiding substitution, or do any kind of alpha-renaming. Note, however, that `c` may (and will almost always) contain free variables. 

You can use `String.equal : string -> string -> bool` to compare strings for equality.

*Hint*: The only interesting cases are `Var` and binders.



#### Problem 2.3 (🧑‍💻, 15 points)
Finish the implementation of the interpreter
```ocaml
let rec eval (e: expr) : expr = 
    match e with
    ...
```
The `eval` function will "run" your program by performing binary operations, evaluating function arguments, applying arguments to functions using `subst`, etc. You might want to refer to Section 4 (Operational Semantics) of the [language reference manual](https://github.com/fredfeng/CS162/blob/master/homework/lamp.pdf) for the precise meaning of each language construct. If no evaluation rule applies, then your interpreter should call `im_stuck` to signal that the interpreter is stuck.

You can assume that the input expression has no free variables.

---
Now you have a working interpreter for a Turing-complete programming language! Since we've also written a parser for you, you can run your interpreter interactively like you run `utop`, or use it to run program files. To run it interactively, simply run
```bash
dune exec bin/repl.exe
```
After which you should see a welcome message, and a prompt `>` after which you can type in expressions to evaluate. For example:
```
Welcome to lambda+! Built on: Fri Jan 24 12:54:56 PST 2025
> 1 + 1
<== 1 + 1
==> 2
```
Use the ⬆️/⬇️ arrow keys to navigate the history of commands you typed in. 

You can also run your interpreter on a program file with
```bash
dune exec bin/repl.exe -- <path-to-file>
```
We provided some example programs in `lib/part2/examples`.

We also wrote a reference interpreter located on CSIL at `~junrui/lamp` which you can use to compare the output of your interpreter. 
To run the reference interpreter, simply run `~junrui/lamp` (interactive mode) or `~junrui/lamp <path-to-file>` (file mode). 

> If you discovered any bug in the reference interpreter, please let us know!


## Extra-Credit Problems for Part 2
<details>
<summary>Click here to show/hide extra-credit problems</summary>


**Problem 2.4** (⭐️bonus⭐️, 1 point): In Problem 2.2, you defined a function that performs a single substitution in a context expression. We can generalize this function to perform multiple substitutions at once.

```ocaml
type sigma = (string * expr) list
let rec subst_multi (s: sigma) (c: expr) : expr = 
    ...
```
We define a `sigma` to be a list of pairs of strings and expressions. For example, `subst_multi [("x", Num 1); ("y", Num 2)] (x + y)` should return to `1 + 2`. You can assume that none of the expressions in `sigma` has free variables.

*Hint*: You may find `List.filter` helpful.


**Problem 2.5** (⭐️bonus⭐️, 3 points): An expression `e1` is alpha-equivalent to `e2` if `e1` can be transformed into `e2` by alpha-renaming (i.e., consistently renaming *bound* variables). For example, `(lambda x. lambda y. x + y * x)` is alpha-equivalent to `(lambda y. lambda x. y + x * y)` (by renaming `x` into `y` and `y` into `x`), and `let x = 5 in x + x` is alpha-equivalent to `let y = 5 in y + y`. Alpha-renaming should not change the semantics of a program. Note that alpha-renaming does *not* rename free variables, since the meaning of expression `x+1` is different from `y+1`: we don't know what `x` and `y` are, and they could be different, so we can't just blindly rename `x` to `y`. However, bound variables don't suffer from this problem, so alpha-renaming can touch them. You can check that alpha-equivalence is indeed an equivalence relation, i.e., it is reflexive, symmetric, and transitive.

For this problem, implement the function `alpha_equiv: expr -> expr -> bool` that checks if two expressions are alpha-equivalent. For this problem, the input expressions *may* contain free variables.

*Hint*: Following the strategy of the extra-credit part of HW1:
1. Design a normal form for alpha-equivalence, so that alpha-equivalent expressions have the same normal form. If you need hints about possible designs, come to TA's office hours.
2. Implement a function that converts an expression to its normal form.
3. Check if two expressions are alpha-equivalent by checking if their normal forms are syntactically equal.


</details>