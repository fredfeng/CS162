# Homework Assignment 3


**Due Monday, Feb 24th at 11:59PM (Pacific Time)**


## Overview

In this assignment, we will continue to augment $\lambda^+$. This time, we will add booleans, lists, and recursion.

Outline:
- Part 1 gives you lots of practice with the syntax and the operational semantics of the augmented $\lambda^+$ language.
- Part 2 is where you will implement the language extensions for the $\lambda^+$ interpreter.
- Part 3 contains extra-credit problems where you will infer the semantics of two mystery language features by playing with the reference $\lambda^+$ interpreter.


## Instructions

0. Make sure you download the latest version of the reference manual [using this link](https://github.com/fredfeng/CS162/blob/master/homework/lamp.pdf).
1. Download a zip of the starter code using [this link](https://download-directory.github.io/?url=https%3A%2F%2Fgithub.com%2Ffredfeng%2FCS162%2Ftree%2Fmaster%2Fhomework%2Fhw3).
2. Run `opam install . --deps-only` in the root directory of this homework to install the necessary dependencies. **You need to run this command again even if you did so for HW2**, since this assignment has new dependencies that were not used in HW2.
3. You will be modifying `lamp/eval.ml` by replacing the placeholders denoted by `todo` with your own code.
4. You must not change the type signatures of the original functions. Otherwise, your program will not compile on gradescope. If you accidentally change the type signatures, you can refer to the corresponding `.mli` file to see what the expected type signatures are.
5. Once you're done, submit `lamp/eval.ml` to gradescope.



Please post your questions in the `#hw3` Slack channel or come to office hours.



## Testing

We have provided one unit test for each programming problem. To run all unit tests, simply run 
```bash
dune runtest
```
in the root directory of this homework. This will compile your programs and report tests that fail. You do not need to recompile your code after each change; `dune runtest` will do that for you.

We highly encourage you to add your own tests, since the autograder won't show you what the official test cases are (only the identifiers of passed/failed cases will be shown). You can locate the provided test cases in `test/test_lamp.ml`.



## Part 1: Language Extensions to HW2

### 1.1 Concrete Syntax

Let's augment $\lambda^+$ with booleans, lists, and the fixed-point operator (to express recursive definitions). Please see the [Overview](https://github.com/fredfeng/CS162/blob/master/homework/lamp.pdf) section of the language reference manual for an informal discussion of the meaning and the concrete syntax of those language extensions. The new syntactic forms should be quite similar to OCaml. 

Several things to note:
1. Recursive function definitions are de-sugared into a combination of `let`, `lambda`, and `fix`. For example, the following recursive definition
   ```ocaml
   fun rec fact with n = 
       if n = 0 then 1
       else n * fact (n-1) in
   fact 5
   ```
   will be de-sugared into
   ```ocaml
   let fact = fix fact is lambda n. 
       if n = 0 then 1
       else n * fact (n-1) in
   fact 5
   ```
   The de-sugaring procedure works as follows:
   1. First, we ignore the `rec` keyword, and de-sugar the function definition as if it were non-recursive into a combination of `let` and `lambda`. That is, we de-sugar
       ```ocaml
       fun fact with n = 
            if n = 0 then 1
            else n * fact (n-1)
       in ...
       ```
       into
       ```ocaml
       let fact = lambda n. if n = 0 then 1 else n * fact (n-1)
       in ...
       ```
   2. Then, we wrap the lambda function with `fix f is ...`. For the example above, we replace `lambda n. if n = 0 then 1 else n * fact (n-1)` with a wrapped version using `fix fact is ...`, which gives us
       ```ocaml
       let fact = fix fact is lambda n. if n = 0 then 1 else n * fact(n-1)
       in ...
        ```

2. Pattern-match on lists must end with the `end` keyword, unlike in OCaml.
3. Equality comparisons in $\lambda^+$ are between integers. Boolean and list equality can easily be implemented with custom functions, so we don't include them as built-in features to make the core language as compact as possible.


### 1.2 Abstract Syntax

We will augment the AST of $\lambda^+$ as follows:
```ocaml
type 'a binder = string * 'a
type expr =
  (* as before *)
  | ... 
  (* booleans *)
  | True
  | False
  | IfThenElse of expr * expr * expr
  | Comp of relop * expr * expr
  (* lists *)
  | Nil
  | Cons of expr * expr
  | Match of expr * expr * expr binder binder
  (* recursion *)
  | Fix of expr binder
```

- For booleans, 
  - `True` and `False` represent the boolean constants "true" and "false" respectively
  - `IfThenElse(e1, e2, e3)` represents the if-then-else expression `if e1 then e2 else e3`
  - `Comp(op, e1, e2)` represents the comparison `e1 op e2`, where `op` is a comparison operator. The comparison operators are `Eq`, `Lt`, and `Gt`.

- For lists, 
  - `Nil` represents the empty list
  - `Cons(e1, e2)` represents the cons cell `e1 :: e2`, i.e., making a new list whose head is `e1` and whose tail is `e2`
  - `Match(e1, e2, ("x", ("xs", e3)))` represents list pattern-matching as in `match e1 with Nil -> e2 | x::xs -> e3 end`. Note that the second branch of the match involves binding: the head of the list is bound to name "x" and the tail bound to "xs". Therefore, the third argument of the `Match` constructor will always have type `expr binder binder`, which by definition is `(string * (string * expr))`. For example, the concrete syntax `match e1 with Nil -> e2 | x::xs -> e3 end` is represented abstractly as
    ```ocaml
    Match(e1, e2, ("x", ("xs", e3)))
    ```
- For recursion, the `Fix` constructor represents the fixed-point operator. `Fix` also has a binding structure: it declares the name of the recursive function to be in-scope in the function definition. This is why the `Fix` constructor takes an `expr binder` as its argument. For example, `fix f is lambda x. f x` is represented abstract as `Fix ("f", Lambda ("x", App (Var "f", Var "x")))`

**Problem (📝)**: Manually parse the following expressions in concrete syntax into ASTs. Use the reference interpreter on CSIL (`~junrui/lamp`) to check your answers.
1. `if if 3=10 then Nil else false then if true then lambda x.x else false else 1`
2. `1::(Nil::true)::lambda x.x`
3. `fun rec length with xs = match xs with Nil -> 0 | _::xs' -> 1 + length xs' end in length (1::2::3::Nil)`



### 1.3 What if ...?

Programming languages and their operational semantics are designed by humans. As such, the human designer will always face a load of design choices that may lead to systems with different theoretical properties and practical trade-offs.


In this part, we will explore some of the "road not taken" in the design of $\lambda^+$, and explore their consequences. This will also help you gain a deeper understanding of why $\lambda^+$ is designed the way it is. Finally, similar questions may appear on the midterm, so it's good to get some practice.


**Problem (📝)**: $\lambda^+$ has the following `App` rule :
```
    e1 ↓↓ \lambda x.e1' 
    e2 ↓↓ v   
    e1'[x |-> v] ↓↓ v'
------------------------ (App)
    (e1 e2) ↓↓ v'
```
An alternative is to have the following `App` rule:
```
    e1 = \lambda x.e1' 
    e2 ↓↓ v   
    e1'[x |-> v] ↓↓ v'
------------------------ (App-Alt1)
    (e1 e2) ↓↓ v'
```
where we simply changed the first premise to an equality instead of an evaluation relation.

Let us denote the original evaluation relation as $\Downarrow$ and the alternative evaluation relation in which `App` is replaced by `App-Alt1` as $\Downarrow_1$.

Exhibit an expression $e$ such that $\exists v.\ e \Downarrow v$ but $\neg\exists v.\ e \Downarrow_1 v$, i.e., the evaluation of $e$ works fine with the original rule but gets stuck/doesn't terminate with the alternative rule.s

*Hint*: Consider the application of "multi-argument" functions.


**Problem (📝)**: Another alternative to the `App` rule is to have the following rule:
```
    e1 ↓↓ \lambda x.e1'   
    e1'[x |-> e2] ↓↓ v
-------------------------- (App-Alt2)
    (e1 e2) ↓↓ v
```

Let us denote the original evaluation relation as $\Downarrow$ and the alternative evaluation relation in which `App` is replaced by `App-Alt2` as $\Downarrow_2$.

Exhibit an expression $e$ such that $\neg\exists v.\ e \Downarrow v$ but $\exists v.\ e \Downarrow_2 v$, i.e., the evaluation of $e$ gets stuck/doesn't terminate with the original rule but works fine with the alternative rule.

*Hint*: What is call-by-value, and what is call-by-name?



## Part 2. Augmenting the Interpreter


**Problem (🧑‍💻, 40 points)** Augment the interpreter you wrote for HW2 to support booleans, lists, and recursion according to the operational semantics specified in the [language reference manual](https://github.com/fredfeng/CS162/blob/master/homework/lamp.pdf). Specifically, for the `free_vars`, `subst` and `eval` functions:
- Copy and paste the code you wrote in the previous assignment for `free_vars`, `subst` and `eval` into `lamp/eval.ml`.
- Replace `todo ()` with your own code. *Hint*: the new cases of `free_vars` and `subst` should be trivial based on what you wrote in HW2.

There are two ways to test your interpreter:

1. We included some unit tests as well as a couple of realistic $\lambda^+$ programs in [test/examples/](./test/examples/) that you can use to test your interpreter. Simply run `dune runtest`.

2. You can also run the interpreter interactively (REPL) or in file mode as described in the previous assignments. For file mode, do `dune exec bin/repl.exe -- <filename>`. For REPL, simply run the following command:
   ```bash
   dune exec bin/repl.exe
   ```

   We added some convenience commands to the REPL:
   - `<expr>` triggers your interpreter to evaluate the expression, as usual.
   - CTRL-C interrupts the REPL and initiate a new prompt. This is useful if your interpreter enters an infinite loop, or you simply want to throw away the current input expression and start anew.
   - CTRL-D quits the REPL.
   - `#let <var> = <expr>` evaluates the right-hand-side expression and adds the binding to the environment. Subsequent expressions can refer to this binding. For example
       ```
       > #let x = 10
       x = 10

       > x + 1
       <== x + 1
       [eval] ==> 11

       > #let x = 20
       x = 20

       > x + 1
       <== x + 1
       [eval] ==> 21
       ```
      Note that 
        1. This syntax is only available in the REPL mode. Do not confuse it with `let`-expressions in the language itself, which you implemented in HW2.
        2. Later bindings may shadow earlier ones, just like in OCaml.
   - `#print` shows the current binding environment.
   - `#clear` resets the binding environment.
   - `#save <filename>` saves the current history of commands to a file
   - `#load <filename>` loads a file containing a list of commands and replays them. Binding commands are also replayed, so you can create a file that contains a sequence of `#let` commands and replay them to set up a particular environment. You can load multiple files by doing multiple `#load` commands.


## Part 3. Reverse-Engineering Language Semantics
<details>
<summary>Click here to show extra-credit problems for Part 3</summary>


In this part of the homework, you will be **inferring** the semantics of two mystery language features by playing with the reference $\lambda^+$ interpreter.


### External Choice (⭐️bonus⭐️, 2 points)

The first mystery language feature is called *external choice*.

Concretely, there are two ways in which an external choice can be made between two things: `$1 e` makes the first choice, while `$2 e` makes the second choice. Given an already-made choice `e`, the only thing we can do about it is to analyze it and branch accordingly, and we don't get to influence the choice in any way (hence the word "external"):
```
match e with
| $1 x -> e1
| $2 y -> e2
end
```

In the AST,
- `$1 e` and `$2 e` are represented as `E1 of expr` and `E2 of expr` respectively.
- The case analysis is represented as `Either of expr * expr binder * expr binder`. For example, `match e with $1 x -> e1 | $2 y -> e2 end` is represented as `Either(e, ("x", e1), ("y", e2))`.

Your task is to implement `E1`, `E2`, and `Either` cases of your `eval` function. You will be scored based on whether the semantics you infer is identical to the semantics of external choice implemented by the reference interpreter. The autograder output will be hidden until the submission portal is closed, so you will not be able to see how many autograder tests you passed.

*Hint:* [This example](./test/examples/max_ext.lp) solves the max problem from HW1 using external choice.



### Internal Choice (⭐️bonus⭐️, 2 points)

The second language extension is internal choice, which is dual to external choice. Previously, when *given* an unknown external choice, we don't get to choose or influence the choice. In contrast, when *given* an internal choice expression `e`, we get to decide which choice to make, using the syntax `e.1` or `e.2`. To construct an internal choice object for someone else, we must present both choices to them, using the syntax `(e1, e2)` where `e1` and `e2` are expressions. In the AST, these syntactic forms are represented as `I1 of expr`, `I2 of expr`, and `Both of expr * expr`. As evident from the type, none of those constructors has any binding structure.

The reference interpreter on CSIL (located at `~junrui/lamp`) implements internal choice. You will reverse-engineer their operational semantics by experimenting with different example expressions and observing the behavior of the interpreter.

Your task is to implement `Both`, `I1`, and `I2` cases of your `eval` function. You will be scored based on whether the semantics you infer is identical to the semantics of internal choice implemented by the reference interpreter. The autograder output will be hidden until the submission portal is closed, so you will not be able to see how many autograder tests you passed.


</details>