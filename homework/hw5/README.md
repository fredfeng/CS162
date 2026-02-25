# Homework Assignment 5

**Due Friday, March 21th, 11:59PM (Pacific Time)**

> Note: March 21th is the last day of the quarter, so this will be the absolute last day to submit this assignment. No late submissions will be accepted.


## Instructions

1. Make sure you download the latest version of the reference manual [using this link](https://github.com/fredfeng/CS162/blob/master/homework/lamp.pdf). You will need to refer to the chapter on type inference in the language reference manual.
2. Either clone this directory, or download the zipped directory using [this link](https://download-directory.github.io/?url=https%3A%2F%2Fgithub.com%2Ffredfeng%2FCS162%2Ftree%2Fmaster%2Fhomework%2Fhw5).
3. The files required for this assignment are located in this folder. In particular, the functions you need to implement are in  [lamp/typeinfer.ml](./lamp/typeinfer.ml) and (for extra credits) [lamp/curry_howard.ml](./lamp/curry_howard.ml).
4. You must not change the type signatures of the original functions. Otherwise, your program will not compile. If you accidentally change the type signatures, you can refer to the corresponding `.mli` file to see what the expected type signatures are.
5. Once you're done, run `make`, which will create an archive called `submission.zip` containing `lamp/{typeinfer.ml,curry_howard.ml}`. Submit the zip file to Gradescope. You do not need to submit any other file, including any `.mli` file or test code. The autograder will automatically compile your code together with our testing infrastructure and run the tests.
6. If your program contains print statements, **please remove them before submitting**. 


---

In this assignment, you will implement an extremely powerful type inference algorithm for λ<sup>+</sup>, which will allow you to type check not only programs containing no type annotation whatsoever. Before we start, however, let's introduce an OCaml feature that we will use in this assignment. Although you won't be graded on this part, it is important to make sure you understand it before proceeding to the main part of the assignment.


### Part 0: Mutable references in OCaml

You have been using the *pure* subset of OCaml. However, OCaml also supports imperative features, such as mutable states, which are called *reference cells* in OCaml. 

If `t` is an OCaml type, then a reference cell that holds a value of type `t` has type `t ref`. The `ref` type is a built-in type in OCaml. There are only three operations on reference cells:
1. **Creating a reference cell**: For example, `ref 0` creates a fresh reference cell that initially holds the value `0`. The type of this reference cell is `int ref`, **not `int`**.
2. **Reading from a reference cell**: `!r` reads the value from the reference cell `r`. If `r` has type `t ref`, then `!r` has type `t`. You can only read from a value of type `ref t`. For example, you cannot read from a value of type `int`.
3. **Writing to a reference cell**: `r := e` writes the result of evaluating expression `e` to the reference cell `r`. The type of the overall expression `r := e` is `unit`, which is simply a dummy value that represents the result of performing some side-effect without returning a value. You can sequence multiple expressions of type `unit` with the `;` operator. For example, `r := 1; r := 2` first writes `1` to the reference cell `r`, and then writes `2` to the reference cell `r`. (This also works for printing: `print_endline "Hello"; print_endline "World"` will print "Hello" and then "World".)

> If you're familiar with C or C++, reference cells are exactly analogous to pointers:
> 1. `int ref` in OCaml is like an `int*` in C
> 2. `ref v` in OCaml is like `malloc` followed by initialization with value `v`.
> 3. `!r` in OCaml is like `*r` in C
> 4. `r := e` in OCaml is like `*r = e` in C
> But reference cells are much nicer to work with than pointers. In particular:
> - There's no manual memory management via `free`. OCaml automatically garbage collects reference cells when they are no longer needed.
> - There's no such thing as a `null` pointer. Every reference cell of type `t ref` is guaranteed to hold a value of type `t`.

As an example, here's an efficient implementation of the Fibonacci function using reference cells:

```ocaml
let fib (n: int) = 
  let a = ref 0 in
  let b = ref 1 in
  let rec go (n: int) = 
    if n = 0 then !a
    else
      (
        let a_prev = !a in
        a := !b;
        b := a_prev + !b;
        go (n - 1)
      )
  in go n
```

Note the use of `;`: given two expressions `e1` and `e2`, if `e1` has type `unit`, then `e1; e2` first evaluates `e1`, discards the result, and then evaluates `e2`. This is useful for sequencing side effects. In the example above, the `;` operator is used to sequence the updates to `a` and `b`.


**Exercise (📝)** Re-implement the [timestamp function from hw1](https://github.com/fredfeng/CS162/tree/master/homework/hw1#problem-2--5-points-1) using reference cells.


> **OCaml Tip**: In later parts of the assignment, you may find it helpful to `;` to sequence effectful computation, such as writing to reference cells or print statements. For example,
> ```ocaml
> Fmt.pr "[abstract_eval] e = %a\n%!" Pretty.pp_expr e;
> Fmt.pr "[abstract_eval] t = %a\n%!" Pretty.pp_ty t;
> ...
> Fmt.pr "[unify] constraint = %a\n%!" Pretty.pp_cons c;
> ...
> ```



## Part 1: Constraint Generation (🧑‍💻)


### 1.0 Practice with constraint generation and solving

**Exercise**: On a piece of paper, for each of the following expressions $e$, simulate the constraint generation process using the *type inference rules* in the reference manual. Which expressions will get stuck during constraint generation?

*Hint*: Feel free to use these expressions as test cases when you're implementing your constraint generation algorithm.

1. `lambda x. x + 2 * x`
2. `x`
3. `(lambda x. x + 2 * y) 3`
4. `10 < 10`
5. `1::2::3+4::Nil`
6. `(lambda x.x) :: (lambda x. x::Nil) :: Nil`
7. `(lambda x.x) :: (lambda x. x+1) :: Nil`
8. `if true then false else true`
9. `match Nil with Nil -> Nil | _::_ -> Nil end`
10. `(if 3>4 then 5 else 7+10*3) = 10`.
11. `let f = lambda x. if x then false else true in f (10 > 0)`
12. `1 :: 10 :: Nil :: Nil`
13. `(1::10::Nil) :: Nil :: Nil`
14. `(Nil :: Nil) :: Nil :: Nil`
15. `match 1::Nil with Nil -> 0 | hd::_ -> hd end`
16. `match 1::Nil with Nil -> 0 | _::tl -> tl end`
17. `match 1::2 with Nil -> 3 | x::y -> x+y end`
18. `(fix recur is lambda n. if n < 1 then 1 else recur (n-1) + recur (n-2)) 2`.
19. `(fix recur is lambda xs: List['a]. match xs with Nil -> 0 | _::ys -> 1 + recur ys end) (false::true::Nil[Int])`
20. `(fix recur is lambda xs: List['a]. match xs with Nil -> 0 | _::ys -> 1 + recur ys end) Nil`
21. `(fix recur is lambda n. recur (n-1)) 10`
22. `(fix recur is lambda n: Int. n-1) 10`
23. `if true then 2 else false : Bool`


**Exercise**: For each of the expressions above, solve the corresponding constraints using the unification algorithm, and think about the following:
1. Which constraint systems have a solution? 
2. Which constraint systems do not have any solution? What does this tell you about the original expression?
3. Which constraint systems have multiple solutions? What does this tell you about the original expression?

---
### 1.1 Updated syntax for types

**Abstract syntax:** Since we must introduce type variables, we have augmented `ty` with a new constructor called `TVar` that represents type variables using strings:
```diff
type ty =
+ | TVar of string  (** Type variable *)
  | TInt
  | TBool
  | TFun of ty * ty
  | TList of ty
  ...
```


**Concrete syntax** The parser has also been updated to parse type variables. A type variable has the form `'<ID>`, i.e., a single quote followed by an identifier. For example, `'a` is a type variable. Please see the [test/examples](./test/examples/) folder for examples of the new syntax.

> **WARNING**: Do not confuse expression variables(represented by `Var` in the `expr` type), with type variables (represented by `TVar` in the `ty` type). They are two different things. An expression variable can only be substituted with a value during *runtime/evaluation*, while a type variable can only be substituted with another type during *type inference*. For example, in the following $\lambda^+$ expression:
>
> ```ocaml
> fun rec map: List['b] with f: 'a -> 'b, l: List['a] =
>   match l with
>   | Nil -> Nil
>   | x::xs ->
>     let y = f x in
>     let ys = map f xs in
>     y::ys
>     end
> in ...
> ```
> `x`, `xs`, `y`, and `ys` are expression variables, while `'a` and `'b` are type variables. During runtime, `x` and `xs` will be substituted with the head and the tail of list `l`. During type inference, `'a` and `'b` will be substituted with, for example, `int` if the `map` function is called with `List[Int]` as the type of the input list and `int -> int` as the type of the function `f`.




### 1.2 Constraint generation 

**Problem**: Your task is to complete the `abstract_eval` function in the `Infer` module of `typeinfer.ml`. This function will be used to generate typing constraints. You should refer to the type inference rules as presented in Section 6.4 - Figure 8 of the reference manual. 

**Important notes**:


1. Constraint generation works by traversing the AST expression and collecting the typing constraints into a global store. We will represent a constraint between two types as a pair:
   ```ocaml
   type cons = ty * ty
   ```
   and the function `pp_cons` formats a constraint in a human-readable format.

   The global constraint store is implemented using a reference cell:
   ```ocaml
   let _cs : cons list ref = ref []
   ```
   However, you don't need to modify `_cs` directly. We have provided the `(===) : ty -> ty -> unit` function which adds a constraint between two types to the global store. Note that this function can be called using infix notation. For example, if you want to constrain `t1` to be equal to the integer type, and `t2` to be equal to `t1` you can call:
    ```ocaml
    t1 === int; 
    t2 === t1;
    <more code>
    ```
   Note the use of `;` to sequence expressions of `unit` type. Do NOT attempt to modify the accumulator variable `_cs` yourself. Also, you should never need to remove any constraint in this part of the assignment.

   We also provided some helper functions:
   - The `curr_cons_list : unit -> cons list` function returns the list of constraints collected so far. You should not need to call this function until Part 3, unless you want to print out all the constraints generated so far for debugging purposes.
   - We have defined the `fresh_var : unit -> ty` function to generate a fresh type variable. Call this function using `fresh_var ()`, which will return some `TVar str` where `str` is an automatically generated string that is guaranteed to be unique from all previous calls to `fresh_var`.


1. As in HW4, the `abstract_eval` function has type `gamma -> expr -> ty`. Unlike HW4, in anticipation of Part 3 of this assignment, the typing environment has been defined to be
      ```ocaml
      type gamma = (string * ty) list
      ```
      That is, the typing environment maps *expression variables* to actual types (that may contain *type variables*). 

2. The structure of your `abstract_eval` should be extremely close to what you had in HW4. The only difference is that, when you checked type equality using `equal_ty` in HW4, you will now instead generate an equality constraint using the `===` operator, and generate fresh variables as needed using `fresh_var ()`, both of which are provided to you.

3. Your `abstract_eval` must take type annotations into account. For example, you should use type annotations if they are provided (e.g. such as in `lambda x:Int. x`), or generate fresh type variables if they are absent.


> **OCaml Tip**: Mutually recursive functions are defined using a combination of `let rec` and `and`. For example, the following code defines two mutually recursive functions `even` and `odd`:
> ```ocaml
> let rec even (n: int) : bool =
>   if n = 0 then true
>   else odd (n - 1)
> 
> and odd (n: int) : bool =
>   if n = 0 then false
>   else even (n - 1)
> ```
> Notice that you do not need to write `rec` after `and`.
> 
> In Part 3 of this assignment, constraint generation and constraint solving will be mutually recursive. Thus, be careful not to accidentally break the mutual recursion by removing `and` or `rec`, or inserting other functions in between the mutually recursive functions.


## Part 2: Constraint solving using unification

We're now ready to implement the unification-based constraint solver, `solve : cons list -> soln`, which takes a list of constraints collected so far, and returns a solution to the constraints. The `soln` type is defined as an association list of type variables to types:
```ocaml
type soln = (string * ty) list
```
Alternative, you can think of `soln` as representing a substitution that maps type variables to types.

<!-- You should maintain the invariant that **a `soln` is topologically sorted by variable dependencies**. In a `soln`, a variable "x" is dependent on another variable "y" if
- some entry `("x", t)` is in the `soln`, and `y` is a free variable in `t`, or
- "x" depends on "y" transitively through other variables.

For example, in `[("y", TVar "z"); ("x", TList (TVar "y"))]`,
- "y" depends on "z" because "z" is a free variable in the type component of the first entry (`TVar "z"`),
- "x" depends on "y" because "y" is a free variable in the type component of the second entry (`TList (TVar "y")`),
- "x" also depends on "z" because "x" depends on "y" and "y" depends on "z" (transitive dependency).
 -->



The `solve` function first pattern-matches on the list of constraints `cs`:
```ocaml
...
and solve (cs : cons list) : soln = 
  match cs with
  | [] -> []
  | (t1, t2)::cs ->
    match t1, t2 with
    | _, _ -> part2 ()
```
- If the list is empty, then there are no constraints to solve, and the solution is the empty substitution, represented by the empty list `[]`.
- If the list is non-empty, where `(t1, t2)` is the first constraint, then we will pattern-match on `t1` and `t2` to determine how to proceed.

Please refer to **Section 6.5** of the manual for a detailed description of the unification algorithm. The `unify` function should raise an error using the `ty_err` function if the constraints are unsatisfiable.

Before you proceed, let's first define some helper functions in the `Utils` module. Later, when you need to call the above helper functions, you need to qualify the function names with the module name, as in `Utils.free_vars`, `Utils.subst`, and `Utils.apply_soln`. There will no be autograde tests for these helper functions, but it is crucial that you implement them correctly and test them thoroughly.

### Task 2.1
Complete the `free_vars` function that collects all *type variables* in a `ty` into a set.

<details>
<summary>Hint</summary>
Since monomorphic types do not have binding structures, you just need to `union` a bunch of things together.
</details>

### Task 2.2
In the `Utils` module, implement the `subst` function which replaces all occurrences of a *type variable string* with another type `ty`.

### Task 2.3

Using the higher-order function `map`, define a function `subst_cs: string -> ty -> cons list -> cons list` that substitutes a type variable with a type in a list of constraints.

### Task 2.4

Define a function `apply_soln: soln -> ty -> ty` that applies a solution `s` to a type `t` by substituting all type variables in `t` with their solved types given by `s`.

<details>
<summary>Hint</summary>
1. Combine `subst` from Task 2.2 with either `fold_left` or `fold_right`.
2. If you did the extra-credit `subst_multi` from HW2, don't confuse that with this function. This function is *much* simpler. (In fact it might be the "incorrect solution" for `subst_multi` that many of you came up with first.)
</details>


## Testing your code

* You can find unit test helpers in `test/test_typing.ml` (to test the overall type inference algorithm), and `test/test_solving.ml` (to test the constraint solver indepdently). You can execute unit tests with `dune runtest`. For convenience, we have provided two modules called `Expr` and `Ty` in `ast.ml` that will make it easier to manually construct expressions and types for testing.
* We **highly recommend** that you write unit tests for each helper function you defined.
* Make sure you test your constraint generation and your constraint solver **separately**. If you generate incorrect constraints, your unification will not produce the correct answers ("garbage in, garbage out").
* Afterwards, you should test your constraint generation and unification together, so that you can get a sense of how well they do as an actual type inference procedure (which is the goal of this assignment).
* Be careful when implementing unification; it is easy to end up with infinite recursion. In particular, you *must* implement the "occurs check" *correctly* or you will hang the autograder and get a score of zero.
* The reference interpreter on CSIL (`~junrui/lamp`) also implements type inference.
* If you would like to run the interpreter with your own type inference implementation locally, use `dune exec bin/repl.exe` or `dune exec bin/repl.exe -- <filename>`.
* Some good sources of test cases are:
  * Exercise 1.0 in this document.
  * OCaml exercises from HW1 & HW2 -- you can rewrite some of them in $\lambda^+$.
  * Programs that involve higher-order functions, such as `map`, `fold`, `filter`, etc.
  * Example programs in [test/examples](./test/examples) that you can use to stress-test your type inference engine. 





<details>
<summary>Click here to show extra credit problems</summary>

## Part 3: The Curry-Howard Correspondence

### Problem 1 (1 point)
Reverse engineering type inference for unit (`()`), void (`!`), product (`*`), and sum (`+`) types by playing with the reference interpreter.

### Problem 2 (1 point)

The unit, void, product, sum, and function types in $\lambda^+$ are extremely expressive, allowing you to write a lot of interesting programs concisely. It is a miracle that we can also interpret these types as *logical propositions*:
1. The unit type `()` corresponds to the logical proposition `True`.
2. The void type `!` corresponds to the logical proposition `False`.
3. The product type `*` corresponds to logical conjunction `/\`.
4. The sum type `+` corresponds to logical disjunction `\/`.
5. The function type `->` corresponds to logical implication `->`.

For each of the following $\lambda^+$ types `t`:
- Convert it to a logical proposition using the scheme above. Use the precedence rule that `*` binds more tightly than `+`, and `+` binds more tightly than `->`.  For associativity, assume `*` and `+` are left-associative, and `->` is right-associative (as in OCaml), meaning that `A -> B -> C` is parsed as `A -> (B -> C)`.
- Determine if the proposition is always true (valid), sometimes true (satisfiable), or always false (unsatisfiable). Use an [online truth table generator](https://web.stanford.edu/class/cs103/tools/truth-table-tool/) to verify your answer.
- Try to come up with a $\lambda^+$ expression `e` for which the type inference algorithm assigns `t` to `e` (the inferred type doesn't need to be exactly the same as `t`, as long as you can alpha-rename the type variables to get `t`). Don't use the `fix` operator for this problem.
- If the proposition is valid, are you able to come up with a corresponding expression?
- If you are able to come up with a corresponding expression, is the proposition valid?

1. `always_true: ()`
2. `always_false: !`
3. `everything: 'p`
4. `everything_implies_truth: 'p -> ()`
5. `falsehood_implies_everything: ! -> 'q`
6. `everything_implies_itself: 'p -> 'p`
7. `modus_ponens: 'p * ('p -> 'q) -> 'q`
8. `both_true_implies_left_true: 'p * 'q -> 'p`
9. `either_true_implies_left_true: 'p + 'q -> 'p`
10. `conjunction_is_commutative: 'p * 'q -> 'q * 'p`
11. `disjunction_is_commutative: 'p + 'q -> 'q + 'p`
12. `conjunction_distributes_over_disjunction: 'p * ('q + 'r) -> ('p * 'q) + ('p * 'r)`
13. `disjunction_distributes_over_conjunction: 'p + ('q * 'r) -> ('p + 'q) * ('p + 'r)`
14. `curry: ('p * 'q -> 'r) -> ('p -> ('q -> 'r))`
    - Intuitively, this type says that any two-argument function can be converted into an equivalent higher-order function that takes the first argument and returns a *function* that takes the second argument.
15. `uncurry: ('p -> ('q -> 'r)) -> ('p * 'q -> 'r)`

Provide your solution in `Problem2` module of `curry_howard.ml`.


### Problem 3 (8 points)

The miracle that we just witnessed is just a tip of an iceberg. It embodies a profound phenomenon in logic, computer science, and math, called the [Curry-Howard correspondence](https://en.wikipedia.org/wiki/Curry%E2%80%93Howard_correspondence). It states that, whenever you write a functional program that has a certain type, you are also implicitly proving that a mathematical theorem holds. 


Different type systems allow you to express and prove different sorts of math theorems. The simple type system of $\lambda^+$ -- which was originally designed to answer the naive question "will my program get stuck during evaluation" -- already gives rise to a version of boolean logic that we just saw. 

As we extend the power of the type system, the Curry-Howard correspondence can give us some really cool applications:

- Polymorphism (generics in OOP languages) corresponds to universal quantification ($\forall$). Data abstraction -- which hides the internal implementation of some function from the clients -- corresponds to existential quantification ($\exists$).

- Mathematical induction becomes just annother recursive higher-order function that takes some value representing the base case and a function representing the inductive step. For example, induction on `list` is exactly `List.fold_right`.

- Once you throw in "dependent types", which allow you to talk about expressions in types and vice versa, you can do **theorem proving** just as functional programming! We can phrase an arbitrarily complicated math theorem, say the [four-color theorem](https://en.wikipedia.org/wiki/Four_color_theorem), as the type of a functional program. Proving the theorem amounts to writing down some (really long) program and asking the type checker to certify that the program indeed has the right type. In this way, [the program becomes a *proof* of the theorem](https://www.ams.org/notices/200811/tx081101382p.pdf). Moreover, 
  - since the proof is just a another program, and proving is just coding, we can [leverage LLMs or other AI techniques to help us write the proof](https://www.youtube.com/watch?v=5ZIIGLiQWNM)!
  - Importantly, the program/proof is *always* validated by a type checker, so we can have an extremely high degree of confidence that the proof is correct, regardless of whether the proof is written by a human or hallucinated by LLMs.

- **Program Verification** It is important for programs in security-critical systems to be categorically free of any sort of bugs. For example, you do not want aviation software to have integer overflow or dereferences null pointers. We can again phrase these properties as types, and write a machine-checked proof that the program of interest indeed has the desired property.


> If this sounds interesting at all, you may want to contact Prof. Yu Feng, whose lab does research on these topics. 

In this problem, we'll give you a taste of an exciting area research called *program synthesis*, which aims to automatically generating programs that are *guaranteed* to meet some user specification. Contrast this with LLM-based code generation, which always has the possibility of spitting out nonsense -- I don't know about you, but I personally don't feel safe riding an airplane if I learn that the software was LLM-generated.

We'll take programs to be $\lambda^+$ expressions, and the specification to be a $\lambda^+$ type. Your task is to implement a function called `synthesize: ty -> expr option` that, given a type as specification, finds a $\lambda^+$ expression that has the specified type. If no such expression exists, then the function should return `None`. In implementing this function:
- You should not use `Fix` in your synthesized programs.
- You can ignore `TList`.

Note that this is a challenging problem, as suggested by the high point value. You are not expected to solve this problem perfectly. The autograder will award points based on the percentage of types for which you can synthesize a program. A simple algorithm will be enough to solve a non-trivial portion, if not all, of the test cases. You will be given a 10-second timeout per test case.

To help you debug your implementation interactively, we have added a `#synth <ty>` command to the REPL interpreter. For example,
```
#synth 'a -> 'a
```
will run your synthesis function. Hopefully, this will return
```
[synthesis] ==> lambda x. x
inferred type ==> 't1 -> 't1
```
and the REPL will also run your type inference algorithm on the synthesized program so that you can check whether the synthesized program has the correct type. In this case, the synthesized program `lambda x. x` indeed has the type `'t1 -> 't1`, which is alpha-equivalent to `'a -> 'a`. Hopefully, this is also the answer you gave for `everything_implies_itself` in Problem 5.1.



<details>
1. You don't need to solve everything at once. Instead, you can focus on certain subsets of types first, and then gradually expand your synthesis algorithm to handle more types. Here's one possible progression:
    - [ ] Start with the simplest types, namely `()`, `!`, `Int`, and `Bool`.
    - [ ] Move on to function types with type variables.
    - [ ] Add support for product types.
    - [ ] Add support for sum types.
2. You can use the types in Problem 2 as test cases for this problem.

**Junrui TODO**:
Set up starter code for this part

</details>