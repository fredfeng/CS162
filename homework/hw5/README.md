# Homework Assignment 5

**Due Monday, March 18th, 11:59PM (pacific time)**

**LAST LATE DAY: Friday, March 22th, 11:59PM (pacific time)**

In this assignment, you will implement an extremely powerful type inference algorithm for λ<sup>+</sup>, which will allow you to type check not only programs containing no type annotation whatsoever, but also *polymorphic* programs that are generic over all possible types.


## Instructions

0. Make sure you download the latest version of the reference manual [using this link](https://github.com/fredfeng/CS162/blob/master/homework/lamp.pdf). You will need to refer to the chapter on type inference in the language reference manual.
1. Either clone this directory, or download the zipped directory using [this link](https://download-directory.github.io/?url=https%3A%2F%2Fgithub.com%2Ffredfeng%2FCS162%2Ftree%2Fmaster%2Fhomework%2Fhw5).
2. Run `opam install . --deps-only` to install a new dependency. This should only take a couple of seconds.
3. The files required for this assignment are located in this folder. In
  particular, the functions you need to implement are in 
  [lib/lamp/typeinfer.ml](./lib/lamp/typeinfer.ml) and (for bonus) [lib/lamp/curry_howard.ml](./lib/lamp/curry_howard.ml).
1. You must not change the type signatures of the original functions. Otherwise, your program will not compile. If you accidentally change the type signatures, you can refer to the corresponding `.mli` file to see what the expected type signatures are.
2. Once you're done, run `make`, which will create an archive called `submission.zip` containing `lib/lamp/{typeinfer.ml,curry_howard.ml}`. Submit the zip file to Gradescope. You do not need to submit any other file, including any `.mli` file or test code. The autograder will automatically compile your code together with our testing infrastructure and run the tests.
3. If your program contains print statements, **please remove them before submitting**. 


## Important Notes
* Problems marked with `📝` are ungraded exercises.
* Problems marked with `🧑‍💻` are programming tasks, and will be autograded on Gradescope. In solving those problems:
  * You are **allowed** to use all OCaml library functions from [the `List` module](https://ocaml.org/p/base/v0.16.3/doc/Base/List/index.html), [the `Map` module](https://ocaml.org/p/base/v0.16.3/doc/Base/Map/index.html), and [the `Set` module](https://ocaml.org/p/base/v0.16.3/doc/Base/Set/index.html). You can click these links to see the documentation for the modules. You may **not** use any library functions that are not documented in these three modules.
  * Note that some of the library functions use an OCaml feature called *labelled argument*, which simply means that, when you call the function, you need to explicitly provide the name of the argument. For example, you need to call `List.map ~f:(fun x -> ...) ...` instead of `List.map (fun x -> ...) ...`.
* Problems marked with `⭐️bonus⭐️` are optional. You will receive extra credit by solving them.
* This assignment will be more challenging than the previous one, although the actual programming problems were designed so that you won't need to write more than 200 lines of code in total. However, they do require a solid grasp of the concepts covered in lectures and in sections.
* If you are struggling, please do not hesitate to ask questions in the `#hw5` Slack channel or come to office hours.




## Part 0: 📝 Exercises

### 0.1 Mutable references in OCaml

You have been using the *pure* subset of OCaml. However, OCaml also supports imperative features, such as mutable states, which are called *reference cells* in OCaml.

If `t` is an OCaml type, then a reference cell that holds a value of type `t` has type `t ref`. The `ref` type is a built-in type in OCaml. There are only three operations on reference cells:
1. **Creating a reference cell**: `ref 0` creates a fresh reference cell that initially holds the value `0`. The type of this reference cell is `int ref`, **not `int`**.
2. **Reading from a reference cell**: `!r` reads the value from the reference cell `r`. If `r` has type `t ref`, then `!r` has type `t`. You can only read from a value of type `ref t`. For example, you cannot read from a value of type `int`.
3. **Writing to a reference cell**: `r := e` writes the result of evaluating expression `e` to the reference cell `r`. The type of this expression is `unit`. You can only write to a value of type `ref t`. For example, you cannot write to a value of type `int`.

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

Note the use of `;`: given two expressions `e1` and `e2`, if `e1` has type `unit`, then `e1; e2` first evaluates `e1`, discards the result, and then evaluates `e2`. This is useful for sequencing side effects. In the example above, the `;` operator is used to sequence the updates to `a` and `b`. However, `;` is just a syntactic sugar for `let () = e1 in e2`.


**Exercise (📝)** Re-implement the [timestamp function from hw1](https://github.com/fredfeng/CS162/tree/master/homework/hw1#problem-2--5-points-1) using reference cells.


> **OCaml Tip**: In later parts of the assignment, you may find it helpful to `;` to sequence effectful computation, such as writing to reference cells or print statements. For example,
> ```ocaml
> Fmt.pr "[abstract_eval] e = %a\n%!" Pretty.pp_expr e;
> Fmt.pr "[abstract_eval] t = %a\n%!" Pretty.pp_ty t;
> ...
> Fmt.pr "[unify] constraint = %a\n%!" Pretty.pp_cons c;
> ...
> ```




---

### 0.2 Practice with constraint generation and solving

**Exercise**: On a piece of paper, for each of the following expressions $e$, simulate the constraint generation process using the type inference rules. Which expressions will get stuck during constraint generation?

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
23. `2 @ Bool`


**Exercise**: For each of the expressions above, solve the corresponding constraints using the unification algorithm, and think about the following:
1. Which constraint systems have a solution? 
2. Which constraint systems do not have any solution? What does this tell you about the original expression?
3. Which constraint systems have multiple solutions? What does this tell you about the original expression?

## Part 1: Constraint Generation (🧑‍💻)

> Part 1 & Part 2 are collectively worth 40 points.

### 1.1 Updated syntax for types

**Abstract syntax** Since we must introduce type variables, we have augmented `ty` with a new constructor called `TVar` that represents type variables using strings. For polymorphic types, we define the following type:
  
  ```ocaml
  type pty = 
    | Mono of ty
    | Scheme of Vars.t * ty
  ```
  where the first case represents a monomorphic (i.e. non-polymorphic) type, and the second case represents a polymorphic type scheme, with the set of type variables quantified over and the type itself.

**Concrete syntax** The parser has also been updated to parse type variables. A type variable has the form `'<ID>`, i.e., a single quote followed by an identifier. For example, `'a` is a type variable. Type schemes do not have a concrete syntax, since they're purely an internal by-product of type inference.

Please see the [test/examples](./test/examples/) folder for examples of the new syntax.

> **WARNING**: Do not confuse variables in the expression language (represented by `Var`), with type variables in the type language (represented by `TVar`). They are two different things. An expression variable can only be substituted with a value during *runtime/evaluation*, while a type variable can only be substituted with another type during *type inference*. For example, in the following $\lambda^+$ expression:
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
> References to `x`, `xs`, `y`, and `ys` are done using program variables, while `'a` and `'b` are type variables. During runtime, `x` and `xs` will be substituted with the head and the tail of list `l`. During type inference, `'a` and `'b` will be substituted with, for example, `int`, if the `map` function is called with `List[Int]` as the type of the input list and `int -> int` as the type of the function `f`.




### 1.2 Constraint generation 

**Problem**: Your task is to complete the `abstract_eval` function in the `Infer` module of `typeinfer.ml`. This function will be used to generate typing constraints. You should refer to the (non-polymorphic) type inference rules as presented in Section 6.4 - Figure 8 of the reference manual. 

**Important notes**:

1. Your `abstract_eval` must take type annotations into account. For example, you should use type annotations if they are provided (e.g. such as in `lambda x:Int. x`), or generate fresh type variables if they are not.
2. You should replace placeholders marked with `part1 ()` with your own code. For example:
      ```ocaml
      | Var x -> (
         if Flag.polymorphic then
           part4 ()
         else
           part1 ()
      )
      ```
      Do not worry about other kinds of placeholders.
3. As in HW4, the `abstract_eval` function has type `gamma -> expr -> ty`. Unlike HW4, in anticipation of Part 4 of this assignment, the typing environment has been defined to be
      ```ocaml
      type gamma = (string * pty) list
      ```
      That is, the typing environment maps variables to (potentially) polymorphic types. **However, for this part of the assignment, you can assume that the types in the typing environment are always monomorphic**:
      - If you want to add a binding `x: t` to the typing environment `gamma`, you can call
        ```ocaml
        add gamma x (Mono t)
        ```
        which adds the monomorphic type `t` to the typing environment `gamma` under the name `x`.

      - When you look up the type associated with a variable `x` in the typing environment `gamma`, you can assume that, if `x` is indeed in `gamma`, then the type associated with `x` is always a monomorphic type. That is, you can write 
        ```ocaml
        match find gamma x with
        | Some (Mono t) -> <do something about type t>
        | Some (Scheme _) -> <impossible: we can assume there are no type schemes until part 4>
        | None -> <error: unbound variable>
        ```
    This assumption will be relaxed in Part 4.

4. We have provided a bunch of helper functions to help you with this task.

   - The `cons` type represents a type equality constraint between two expressions, and a pretty-printer `pp_cons` to format a constraint in a human-readable format.
   - The `(===) : ty -> ty -> unit` function records a constraint between two types. Note that this function can be called using infix notation. For example, if you want to constrain `t1` to be equal to the integer type, and `t2` to be equal to `t1` you can call 
       ```ocaml
       t1 === int; 
       t2 === t1;
       <more code>
       ```
      Note the use of `;` to sequence expressions of `unit` type. 
   - **If you want to add a constraint, always do so by calling `===`.** Do NOT attempt to modify the accumulator variable `_cs` yourself. Also, you should never need to remove any constraint in this part of the assignment.
   - The `curr_cons_list : unit -> cons list` function returns the list of constraints generated so far. You should not need to call this function until Part 4, unless you want to print out all the constraints generated so far for debugging purposes.
   - We have defined the `fresh_var : unit -> ty` function to generate a fresh type variable. Call this function using `fresh_var ()`, which will return some `TVar str` where `str` is an automatically generated string that is guaranteed to be unique from all previous calls to `fresh_var`.

5. You should not need to define any other helper function yourself. But if you choose to do so, please define them before the `abstract_eval` function.

6. The structure of your `abstract_eval` should be extremely close to what you had in HW4. The only difference is that, when you checked type equality using `equal_ty` in HW4, you will now instead generate an equality constraint using the `===` operator, and generate fresh variables as needed using `fresh_var ()`, both of which are provided to you.


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
> Notice that you do not need to write `rec` after `and`; the above syntax is enough to inform OCaml that `even` and `odd` are mutually recursive. 
> 
> In Part 4 of this assignment, constraint generation and constraint solving will be mutually recursive. Thus, be careful not to accidentally break the mutual recursion by removing `and` or `rec`, or inserting other functions in between the mutually recursive functions.


## Part 2: Constraint solving using unification (🧑‍💻)

> Part 1 & Part 2 are collectively worth 40 points.

First, you need to complete the `free_vars` function (in the `Utils` module) that collects all type variables in a `ty`. *Hint*: Since monomorphic types do not have binding structures (unlike expressions), you will never need to take something out of a set of variables. As before, use the functions in the `Vars` module to perform set operations.

Next, in the `Utils` module, implement the `subst` function which replaces all occurrences of a type variable in a type with another type.

In later parts of your code, to call `free_vars` and `subst`, you need to qualify the function names with the module name like `Utils.free_vars` and `Utils.subst`.

Finally, the `solve` function takes a list of constraints, and returns a solution to the constraints in the form of a substitution from type variables to types. The solve function is defined as follows:
```ocaml
...
and solve (cs : cons list) : sigma = 
  let sigma = unify empty cs in
  backward sigma
```
where `sigma` is the following type
```ocaml
type sigma = (string * ty) list
```
which represents a substitution of type variables with types. We have defined the `empty` variable to represent the empty substitution using the empty list, and the `compose` function:
```ocaml
let compose (x : string) (t : ty) (s : sigma) : sigma = 
  (x, t) :: s
```
that composes a substitution `s` with a new substitution that maps type variable `x` to type `t`.

You should first implement the unification algorithm in the `unify` function, which has the type `unify : sigma -> cons list -> sigma`. That is, the `unify` function takes an initial substitution and a list of constraints, and solves the constraints by composing the initial substitution with the substitution implied by the input constraints. The `unify` function should raise an error using the `ty_err` function if the constraints are unsatisfiable. You can find the unification algorithm in Section 6.5 of the reference manual, or in Chapter 22 of _Types and Programming Languages_.

Although the `sigma` returned by `solve` does NOT need to ensure that all type variables are concrete, you *do* need to ensure that all type variables are "fully substituted" by implementing backward substitution in the `backward` function, as described in the reference manual. For example, if `unify` is provided the following set of constraints:

```plain
X0 === List[X1]
X2 === Int
```

then after `backward`, the following solution is acceptable as an answer because `X1` is legitimately a "free variable" in the RHS of the equations:

```plain
X0 |-> List[X1]
X2 |-> Int
```
(In terms of OCaml, `sigma` will be represented as:)
```ocaml
[
  ( "X0", TList (TVar "X1) );
  ( "X2", TList TInt );
]
```

However, if the input constraints are:

```plain
X0 === List[X1]
X0 === List[X2]
X3 === X1 -> X4
```

then the output of `backward` should be:
```
X3 |-> X1 -> X4
X2 |-> X1
X0 |-> List[X1]

OR

X3 |-> X2 -> X4
X1 |-> X2
X0 |-> List[X2]
```

but not:

```
X3 |-> X1 -> X4
X2 |-> X1
X0 |-> List[X2]
```

because the type variable `X2` that appears on the right-hand-side of `X0 |-> List[X2]` should have been substituted away, which should give `X0 |-> List[X1]`, since the substitution already said that `X2` should be substituted with `X1`. You need to handle this in your `backward` function by performing backward substitution on `sigma`.

*Hint*: You may find both `List.map` and `List.fold_right` helpful when defining `backward`.



## Part 3: Type Inference for Products (🧑‍💻)

> Total: 10 points

Recall that in HW3, you designed the [operational semantics for products](https://github.com/fredfeng/CS162/tree/master/homework/hw3#products). 

Now, your task is to implement type inference for products, including both constraint generation and solving. The reference interpreter on CSIL  (located at `~junrui/lamp`)  implements type inference for products. Your goal is to ensure that the reference interpreter infers type `t` for expression `e` if and only if your own type inference algorithm infers `t` for `e`. This implies that the reference interpreter thinks `e` is ill-typed if and only if your type inference algorithm also thinks `e` is ill-typed.

Specifically, in `abstract_eval`, implement the cases for for `Fst`, `Snd`, and `Pair`, and in `unify`, handle the unification of product types in `unify`.

Unlike the operational semantics of products, there will be no "surprises" in the type inference algorithm for products. Thus, you can use your intuition to guide your implementation, and confirm with the reference interpreter by coming up with some examples on your own. Although it may help to do so, you do not need to formalize the actual rules for products on paper.



## Part 4: Let-Polymorphism (🧑‍💻)

> Total: 10 points

In this part, you will implement let-polymorphism as described in Section 6.6 of the reference manual. You will need to implement/modify the following function:

1. In `abstract_eval`, replace place-holders marked with `part4 ()` to handle let-polymorphism, as described by the `CT-Var*` and `CT-Let*` rules in the reference manual.

2. Implement the `generalization` function, which takes a typing environment and a monomorphic type, and returns a type scheme.

3. Implement the `instantiate` function, which takes a polymorphic type scheme and returns a monomorphic type by replacing the universally quantified type variables with fresh type variables.


You may find it helpful to define several helper functions that apply a substitution `sigma` to
- a type scheme 
- a typing environment
- a list of type constraints

You may find `List.map` especially handy in some of these cases.





## Testing your code

* You should construct your own test cases and run your own tests locally (although we will not be grading your testing).
* You can find unit test helpers in `test/test_typing.ml` (to test the overall type inference algorithm), and `test/test_solving.ml` (to test the constraint solver indepdently). You can execute unit tests with `dune runtest`. For convenience, we have provided a `DSL` module in `ast.ml` that will help you concisely construct test cases, should you choose to use it.
* **Make sure you test your constraint generation and your constraint solver separately.** If you generate incorrect constraints, your unification will not produce the correct answers ("garbage in, garbage out"). Likewise, if your unification is incorrect, you will obviously get the wrong answers.
* We **highly recommend** that you write unit tests for each helper function you defined.
* Afterwards, you should test your constraint generation and unification together, so that you can get a sense of how well they do as an actual type inference procedure (which is the goal of this assignment).
* Be careful when implementing unification; it is easy to end up with infinite recursion. In particular, you *must* implement the occurs check *correctly* or you will hang the autograder and get a score of zero.
* The reference interpreter also now includes type inference. If you would like to locally run the interpreter with your own type inference implementation, use `dune exec bin/repl.exe --`.
* By default, the interpreter (both your own and the reference interpreter) will automatically enable type inference mode, **without let-polymorphism**. If you wish to enable let-polymorphism, you can run the interpreter with the `-poly` flag, as in `dune exec bin/repl.exe -- -poly`.
* Some good sources of test cases are:
  * Exercise 0.2.
  * Bonus Problem 5.1.
  * HW1 OCaml problems (you can rewrite some of them in $\lambda^+$).
  * Programs that involve higher-order functions, such as `map`, `fold`, `filter`, etc.
  * Example programs in [test/examples](./test/examples) that you can use to stress-test your type inference engine. 




## Part 5: ⭐️Bonus⭐️

> **Total**: 10 ⭐️bonus⭐️ points
> 
> **Important notes**:
> 1. The only file you need to modify for this part is `lib/lamp/curry_howard.ml`.
> 2. You need to make sure that your type inference engine is working correctly before attempting this part.

**Problem 5.1 (⭐️bonus⭐️, 2 points)** For each of the following type `t`, write down a terminating $\lambda^+$ expression `e` such that the type inference algorithm assigns `t` to `e` (the inferred type doesn't need to be exactly the same as `t`, as long as you can rename the free type variables and obtain `t` as a result). 

1. `everything: 'p`
2. `always_true: Int`
3. `everything_implies_truth: 'p -> Int`
4. `truth_implies_everything: Int -> 'q`
5. `something_implies_everything: 'p -> 'q`
6. `everything_implies_itself: 'p -> 'p`
7. `modus_ponens: 'p -> ('p -> 'q) -> 'q`
8.  `both_true_implies_true: 'p * 'q -> 'p`
9.  `true_implies_both_true: 'p -> 'p * 'q`
10. `conjunction_is_commutative: 'p * 'q -> 'q * 'p`
11. `conjunction_is_associative: 'p * ('q * 'r) -> ('p * 'q) * 'r`
12. `conjunction_distributes_over_implication: ('p * ('q -> 'r)) -> (('p * 'q) -> ('p * 'r))`
13. `conjunction_distributes_over_implication_hmm: (('p * 'q) -> ('p * 'r)) -> ('p * ('q -> 'r))`
14. `implication_distributes_over_conjunction: ('p -> ('q * 'r)) -> (('p -> 'q) * ('p -> 'r))`
15. `implication_distributes_over_conjunction_hmm: (('p -> 'q) * ('p -> 'r)) -> ('p -> ('q * 'r))`
16. `implication_weakening: ('p -> 'q) -> ('p -> 'a -> 'q)`
17. `implication_contraction: ('p -> 'a -> 'a -> 'q) -> ('p -> 'a -> 'q)`
18. `implication_exchange: ('p -> 'q -> 'r) -> ('q -> 'p -> 'r)`
19. `curry: ('p * 'q -> 'r) -> ('p -> 'q -> 'r)`
20. `curry_hmm: ('p -> 'q -> 'r) -> ('p * 'q -> 'r)`

Provide your solutions in the `Examples` module of `curry_howard.ml`. If an expression `e` exists, put `Some <e>` in the right-hand-side of the corresponding variable, where `<e>` is a string which is the concrete syntax of the expression. If you think no such expression exists, simply put `None`.

When you're done, use your type inference engine to check if the type of each expression is indeed `t`. You can simply type your solutions into the REPL, and check if the inferred type is the same as the expected type (modulo consistent renaming of type variables).


### Propositional Logic 

**Problem 5.2 (⭐️bonus⭐️, 0.5 points)** A boolean proposition (aka propositional logic formula) can be defined by the following language:
```plain
b ::= true | X | b /\ b | b -> b | ...
```
where `X` is called a propositional variable, and `/\` and `->` are logical conjunction and implication, respectively. We can model boolean propositions using the following OCaml type:
```ocaml
type prop = 
  | True
  | Var of string
  | And of prop * prop
  | Imply of prop * prop
```
(Disjunction and other operators are omitted for simplicity.)

Given any $\lambda^+$ type, implement the `curry_howard` function that converts a $\lambda^+$ type to a boolean proposition by mapping:
1. each type variable to a propositional variable of the same name, 
2. the product type to logical conjunction,
3. the function type to logical implication, and 
4. base types `Int` and `Bool` to the truth value `True`.

For example, the type `'a -> 'b * Int` (or in abstract syntax, `TFun (TVar "a", TProd (TVar "b", TInt))`) should be translated to the proposition `Imply(Var "a", And(Var "b", True))`. You can ignore list types for this problem.

---

**Problem 5.3 (⭐️bonus⭐️, 0.5 points)**  A boolean proposition can evaluate to true or false, depending on what truth values are assigned to its variables. For example, the proposition `P /\ Q` evaluates to true if and only if both `P` and `Q` are true.

However, some propositions are special: they are always true, regardless of which assignment is used to evaluate the proposition. For example, one such proposition is `P \/ ~P` (where `~` denotes logical negation). If `P` is true, the first disjunct is true, so the whole disjunction is true. If `P` is false, then the second disjunct is true, so the whole disjunction is still true.

For this problem, for each of the types in Problem 5.1, run your `curry_howard` function to convert the type into a boolean proposition (or manually do the conversion on paper or in your brain), and guess whether the proposition obtained from each of the types is always valid. Use an  [online truth table generator](https://web.stanford.edu/class/cs103/tools/truth-table-tool/) to verify your solution.

- If the proposition corresponding to the type is valid, put a `true` in the corresponding entry in the `validity` list.
- Otherwise, put a `false`.

Then think about the following questions:

- If you were able to come up with a terminating $\lambda^+$ expression that has the given type, then is the proposition valid?
- Conversely, if you weren't able to come up with a terminating $\lambda^+$ expression that has the given type, then is the proposition invalid, i.e. the proposition evaluates to false in some cases?




### The Curry-Howard Correspondence

The `curry_howard` function embodies an extremely profound phenomenon in logic, computer science, and math, called the [Curry-Howard correspondence](https://en.wikipedia.org/wiki/Curry%E2%80%93Howard_correspondence). It states that, whenever you write a program that has a certain type, you are also implicitly proving a certain logical proposition is true. This is a very deep and beautiful idea, and it is one of the reasons why type systems are so important in programming languages.

Recall that the type system of $\lambda^+$ was originally designed to predict the question: 
> Will the evaluation of a $\lambda^+$ expression get stuck? 

Even with this simple question and our simple language, we can already see a deep connection between the type system and boolean propositional logic. This is just the tip of the iceberg. What if we design our type system to design to answer more sophisticated questions? What kind of logic will we get?

As we expand the power of our type system, the Curry-Howard correspondence becomes increasingly more powerful:
- **Program Verification** We can write a computer program P whose *type* expresses the fact that another program Q (think aviation software) will always terminate, never crash, or sort a list correctly in increasing order. Then if program P is well-typed using a type checker, then we have a mechanical *proof* that program Q will always terminate, never crash, or sorts a list correctly in increasing order, where the type checking rules are the proof rules.
- **Theorem Proving** We can write a computer program whose *type* corresponds to the statement of a mathematical theorem, say the [four-color theorem](https://en.wikipedia.org/wiki/Four_color_theorem). If the computer program is well-typed, then [the program simultaneously becomes a valid *proof* of the mathematical theorem](https://www.ams.org/notices/200811/tx081101382p.pdf).

Hope this has whetted your appetite. To learn more, go watch [this wonderful YouTube video](https://www.youtube.com/watch?v=IOiZatlZtGU) on the Curry-Howard correspondence.


### Program Synthesis (⭐️bonus⭐️, 7 points)

In some sense, the type of a program is a proposition that predicts the behavior of the program. In type checking and type inference, we're given the program, and asked to predict its behavior. What about the reverse direction? What if we're given a description about the intended behavior of the program, and asked to invent the program itself?

This question lies at the heart of the field of *program synthesis*. It aims to enable programmers to simply say what the intended behavior of a program should be, and have an algorithm to automatically generate a desired program that is guaranteed to satisfy the specification. For example, you can specify that you want a program that takes a list of integers and returns the maximum element, and the program synthesis tool will automatically generate a program that does exactly that.

One form of specification is simply natural language. In fact, if you ask ChatGPT to help you write a program that does something, then ChatGPT is effectively acting as a program synthesis tool, by taking in the natural-language specification, and spitting out a program that has the specified behavior. Unfortunately, there is zero guarantee that the program generated by ChatGPT actually satisfies the specification.

This is where types come to rescue. Types are, in fact, a form of specification, but much more precise than natural language. Powerful type systems allow you to say things like "this program returns the input list in sorted order" in a precise way, and a program synthesis tool can ingest this type and generate a program that is guaranteed to have this behavior, thanks to the type system which can determine whether the program has the specified type.


**Problem (⭐️bonus⭐️, 7 points)** This problem is intended to give you a taste of program synthesis. Your task is to implement the `synthesize` function that, given an arbitrary $\lambda^+$ type, synthesizes a *terminating* $\lambda^+$ expression, such that the type inference algorithm will indeed assign the specified type to the expression. Your program can do anything as long as it always terminates and has the correct type.

Provide your code in the function called `helper`, which takes an environment mapping type `t` to some known expression `e` that has type `t`, and input type `t0`. If an expression of type `t0` can be synthesized, then `helper` should return `Some e0`, where `e0` is the synthesized expression. Otherwise, `helper` should return `None`.

This is a challenging problem, as suggested by the high point value. You are not expected to solve this problem perfectly. Fortunately, the difficulty of this problem can vary greatly, depending how ambitious you want to be.  The autograder will award points based on the percentage of types for which you can synthesize a program. A simple algorithm will be enough to solve a non-trivial portion, if not all, of the test cases. You will be given a 1-second timeout per test case. You may ignore list types for this problem.

To help you debug your implementation interactively, we have added a `#synth <ty>` command to the REPL interpreter. For example,
```
#synth 'a -> 'a
```
will run your synthesis function. Hopefully, this will return
```
[synthesis] ==> lambda x. x
<-- inferred type: 't1 -> 't1
```
and the REPL will also run your type inference algorithm on the synthesized program so that you can check whether the synthesized program has the correct type. In this case, the synthesized program `lambda x. x` indeed has the type `'t1 -> 't1`, which is basically the same as `'a -> 'a`. Hopefully, this is also the answer you gave for `everything_implies_itself` in Problem 5.1.

As a challenge, try synthesizing programs for the types mentioned in Problem 5.1.

---

> **Ad**: If you find this bonus section interesting, please do not hesitate to reach out to Prof. Yu Feng. His lab does research on program synthesis (inventing programs given specification), and program verification (proving programs correct), using all of the cool ideas you have learned in this class. He would be happy to chat with you about these topics, and may even offer you to work on a research project on a paid research assistantship.