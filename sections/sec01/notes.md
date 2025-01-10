# Section 1

## Variables & Bindings

In imperative languages, the mental model for variable assignments is that
- variables = memory cells
- assignments = overwrite the content of memory cells

For example, in Java `int x = 5`, creates a memory box called `x` and stores the value `5` in it:
```
  +---+
x | 5 |
  +---+
```
and an assignment like `x = 7` overwrites the value of `x`:
```
  +---+
x | 7 |
  +---+
```

However, in functional languages like OCaml, variables **don't vary**. Instead, they are just **names** for (immutable) values, aka bindings.

There are two ways to create bindings in OCaml, global and local.

### Global Bindings
Global bindings have the form `let <var_name> = <expr>`.

The way you should think about bindings is that each binding pushes a (variable, value) pair onto a stack. Each use of a variable name looks up the stack to find the *most recent* binding for that variable.

For example, consider the following code:
```ocaml
let x = 5;;
let y = false;;
let x = x + 2;;
```

Assuming nothing else is in the environment in the beginning (i.e., we start with an empty stack), after executing this first two lines, the stack looks like this:
``` 
    (stack top)
    | y -> false |
    | x -> 5     |
    -------------
      stack bot 
```
and after executing the second line, the stack looks like this:
``` 
    (stack top)
    | x -> 7     |
    | y -> false |
    | x -> 5     |
    -------------
      stack bot 
```

Global bindings also push things onto the stack, never popping them off. However, earlier bindings can be *shadowed* by later ones if they have the same name. For example, `x -> 5` will never be accessible for the rest of the program, since any reference to x will always visit `x -> 7` first before `x -> 5` since stacks are traversed from top to bottom.


### Local Bindings

Local bindings create temporary variables for a fixed duration, called a *scope*. After the scope ends, the variable is no longer accessible, i.e., the binding is popped off the stack.

Local bindings have the form `let <var_name> = <expr_1> in <expr_2>`. Here are the steps for evaluating local bindings:
1. Start with some initial environment (given by the surrounding context).
2. Evaluate `<expr_1>` in the initial environment to get a value `val_1`.
3. Push `(var_name, val_1)` onto the stack.
4. Evaluate `<expr_2>` in the new environment to get a value `val_2`.
5. Pop `(var_name, val_1)` off the stack.
6. Return `val_2`.

Consider the following two examples:

1. 
    ```ocaml
    let x = 2 in (let x = x + 3 in x * 5) + x;;
    ```

2. 
    ```ocaml
    let x = (let x = 2 in x + 3) in x * 5 + x;;
    ```

Pause and think about what the value will be returned for each of them. The important thing is that you never mutate any memory cell; instead, just push and pop bindings off the stack.


<details>
<summary>Answer for 1</summary>

```ocaml
let x = 2 in (let x = x + 3 in x * 5) + x;;
```

Let's evaluate the first expression step by step:

1. Assume with start with an empty stack.
2. The overall expression has the shape `let x = 2 in blah`, so we evaluate `2` in the empty environment to get `2`.
3. Then, we push `(x, 2)` onto the stack, which now looks like:
   ```
       (stack top)
       | x -> 2 |
       -------------
         stack bot 
   ```
4. Using this stack, we evaluate the inner expression `let x = x + 3 in x * 5`:
   1. We evaluate `x + 3` in the current environment to get `5`.
   2. We push `(x, 5)` onto the stack, which now looks like:
      ```
          (stack top)
          | x -> 5 |
          | x -> 2 |
          -------------
            stack bot 
      ```
    3. We evaluate `x * 5` in the current environment to get `25`.
    4. The inner let-binding ends, so we pop `(x, 5)` off the stack, which now looks like:
      ```
          (stack top)
          | x -> 2 |
          -------------
            stack bot 
      ```
5. We resume evaluating the outer expression `<inner_expr> + x` in the current environment. Now, the right-hand side `x` refers to the outer, original `x`, as evidenced by the stack, since only `x -> 2` the only binding for `x`. So, we evaluate `25 + 2` to get `27`.
6. Finally, the outer let-binding ends, so we pop `(x, 2)` off the stack, which now looks like:
   ```
       (stack top)
       -------------
         stack bot 
   ```
7. We return `27`.
</details>

<details>
<summary>Answer for 2</summary>

```ocaml
let x = (let x = 2 in x + 3) in x * 5 + x;;
```

Let's evaluate the second expression step by step:
1. Assume with start with an empty stack.
2. The overall expression has the shape `let x = <inner_expr> in blah`, so we evaluate the inner expression, which is `let x = 2 in x + 3`, under the current, empty environment.
   1. We evaluate `2` in the empty environment to get `2`.
   2. We push `(x, 2)` onto the stack, which now looks like:
      ```
          (stack top)
          | x -> 2 |
          -------------
            stack bot 
      ```
   3. We evaluate `x + 3` in the current environment to get `5`.
   4. The inner let-binding ends, so we pop `(x, 2)` off the stack, which now looks like:
      ```
          (stack top)
          -------------
            stack bot 
      ```
3. The inner expression returns 5, and the stack is empty. We now know what the outer `x` should be bound to:
    ```
        (stack top)
        | x -> 5 |
        -------------
          stack bot 
    ```
4. We evaluate the outer expression `x * 5 + x` in the current environment. Now, the right-hand side `x` refers to the outer, original `x`, as evidenced by the stack, since only `x -> 5` the only binding for `x`. So, we evaluate `5 * 5 + 5` to get `30`.
5. We return `30`.
</details>


## Functions

Defining functions are just like defining variables. The following defines a two-argument function `add` that adds its arguments:
```ocaml
let add x y = x + y;;
```
If you run this in a REPL like `utop`, you should see:
```
# let add x y = x + y;;
val add : int -> int -> int = <fun>
```
So the OCaml interpreter was able to figure out the exact type signature for `add`! This is called type inference, and a really cool feature of OCaml and many other functional languages. You'll learn a cool algorithm for type inference later in the course.

However, having said that, if you're new to statically typed languages with type inference (i.e., you're more comfortable with Java or C++), then it is generally a good idea to continue to annotate your functions with types. This is because it makes your code more readable, and allows the compiler to give you much better error messages if you make a mistake.

For example, we could have written the function as:
```ocaml
let add (x : int) (y : int) : int = x + y;;
```

Had we made a mistake, like using `^` (string concatenation) instead of `+` (integer addition), the compiler would have caught it:
```ocaml
# let add (x: int) (y: int) : int = x ^ y;;
Error: This expression has type int but an expression was expected of type string
```

This allows you localize the error to the function `add`. Had we omitted the type annotations, the error may appear somewhere else that calls this buggy `add` in a totally different, distant part of the codebase, and it would be harder to track down the source of the error.

## Defining New Data Structures with Types

OCaml doesn't have classes (technically, it does, but almost nobody uses them, and you'll never see them in this course). Instead, you define new data structures by **describing the shape of the data using types**. 

Although you might not have done this before, the good thing is that defining new types are really simple:
- There are only *2* ways to form new types in OCaml: products and enums.
- For each of these, you only need to understand *2* things: how to build data of that type, and how to use/consume data of that type.

I.e., if you know how to answer Q1-Q4 in the following matrix, you're golden for the rest of the course:

| Type    | How to build data | How to use data |
| ------- | ----------------- | --------------- |
| Product | Q1                | Q2              |
| Enum    | Q3                | Q4              |

Let's do each row in turn.

### Products

Given types A and B (each encoding some data structure), you can form a new type representing the following data structure:
```
+---+---+
| A | B |
+---+---+
```
This type is called `A * B` (the product of A and B). You've probably seen this in other languages in other forms:
- In Python, you'd call this a `tuple` with two elements.
- In Java, you'd call this a `class` with two fields.
- In C, you'd call this a `struct`.

This type is the essence of "logical AND": something of type `A*B` contains both an `A` **and** a `B`.

For example, a rational number can be represented as an enumerator **AND** a denominator:
```ocaml
type rational = int * int
```

Let's answer Q1 and Q2 for products.

#### Q1: How to build data of type `A * B`?
The only way to make a value of type `A * B` is when you already have a value of type `A` and a value of type `B`. Then, you can "pack them together" to form a value of type `A * B` using the following syntax:
```ocaml
let pair = (420, "sixty-something");;
```
creates a product of type `int * string`.

In the rational number example, you can create rational numbers like this:
```ocaml
let zero = (0, 1);;
let one = (1, 1);;
let half = (1, 2);;
```
to represent 0, 1, and 1/2, respectively.

#### Q2: How to use data of type `A * B`?
This is the scenario where somebody else has given you a value of type `A * B`. The only way to make use of it would be to extract the `A` and `B` components from it (i.e., "unpack" the product). This is done using the following syntax:
```ocaml
let (x, y) = pair in 
(* you can now use x to refer to integer 420 and
   use y to refer to the string "sixty-something".
   For example, you can print them out *)
print_endline (Int.to_string x ^ " " ^ y);;
```

In the rational number example, suppose we want to define the function `add` that adds two rational numbers. We can do this as follows:
```ocaml
let add (x: rational) (y: rational) : rational = 
    ???
```
What should we do in place of `???`?

Well, let's first work out how to do this on paper. Say we have a rational number x = a/b, and y = c/d. Then, x + y = (a*d + b*c) / (b*d). So the first thing we need to do is to extract `a`, `b`, `c`, and `d` from `x` and `y`. This can be done as follows:
```ocaml
...
let (a, b) = x in
let (c, d) = y in
???
```
Then you can fill in the `???` with the appropriate formula:

```ocaml
...
let (a, b) = x in
let (c, d) = y in
(a*d + b*c) / (b*d)
```

But wait!! If you do this, OCaml compiler will throw a type error. Pause and think why this is the case.

<details>
<summary>Answer</summary>
This is because we have annotated the return type of `add` to be `rational`, which are *represented* as a pair of integers. Thus, we need to return something of type `int * int`, not just an integer. So, we need to pack the numerator and denominator back into a pair:
```ocaml
...
let (a, b) = x in
let (c, d) = y in
(a*d + b*c, b*d)
```
</details>



### Enums

Given that products are the essence of "logical AND", you can probably guess that enums are the essence of "logical OR". Given types A and B, you can form a new type `C` representing the following data structure:
```
+--------+-----------+
| "TagA" |     A     |
+--------+-----------+
```
or 
```
+--------+-----------+
| "TagB" |     B     |
+--------+-----------+
```

That is, `C` can be either an `A` **or** a `B`. Whether it's an `A` or a `B` is indicated by a "tag". It doesn't matter what the tag is, as long as it's unique for each type in the enum.

In OCaml, this is done using the `type` keyword:
```ocaml
type c = 
    | Either of int
    | Or of string
```
if we take `A` to be `int` and `B` to be `string`. We use `Either` to tag integers, and `Or` to tag strings.

A very useful data structure uses this to capture the idea that ``a computation can either succeed with a value or fail with an error message'':
```ocaml
type result = Success of int | Failure of string
```
That is, a `result` can either be an integer tagged with `Success`, or a string tagged with `Failure`.

Another classic example is a network packet, which can contains a payload, tagged with which protocol it uses:
```
+--------+-----------+
| "TCP"  | <payload> |
+--------+-----------+
```
or 
```
+--------+-----------+
| "UDP"  | <payload> |
+--------+-----------+
```


#### Q3: How to build data of type `C`?

Let's say our `c` is:
```ocaml
type c = 
    | Either of int
    | Or of string
```

The only way to make a value of type `c` is:
- Either you already have integer, and you "tag" it with `Either`:
    ```ocaml
    let one_possibility = Either 420;;
    ```
- Or you already have a string, and you "tag" it with `Or`:
    ```ocaml
    let another_possibility = Or "sixty-something";;
    ```
Notice that you can never have both `Either` and `Or` in the same value of type `C`. It's either one or the other. Exclusive OR, if you will.


For example, let's try to build a `result` in a function that divides two numbers safely: if the denominator is zero, we should return a `Failure` with an error message, otherwise, we should return a `Success` with the result of the division:
```ocaml
type result = Success of int | Failure of string

let safe_divide (num: int) (denom: int) : result = 
    if denom = 0 then
        Failure "Div by zero, screw you"
    else
        (num / denom)
```

This function never throws an exception (which is great, because exceptions are really hard to reason about). Instead, it returns a `result` that can represent either a successful division or a failure.

However, the above code will throw a type error. Pause and think why this is the case.

<details>
<summary>Answer</summary>
This is because the function is supposed to return a `result`, which is an enum type. However, in the `else` branch, we're returning an integer, which is not a `result`. We need to wrap the integer in a `Success` tag:
```ocaml
...
else
    Success (num / denom)
```
A useful analogy is that the envelope is the `result`, and the integer is the letter inside the envelope. You can't just hand the post office (which expects an evelope) a bare letter. You need to put the letter in an envelope, and stamp it with the appropriate tag so that the post office can deliver it to the right place.
</details>


#### Q4: How to use data of type `C`?

Let's say our `c` is:
```ocaml
type c = 
    | Either of int
    | Or of string
```
Since `c` can be one of two things, any code that performs computation on `c` needs to be prepared to handle both cases. This is done using pattern matching in OCaml, which is basically if-else/switch/other kinds of branching constructs, but on steroids.
```ocaml
let handle (x: c) : unit = 
    match x with
    | Either n -> print "It's an integer: " ^ Int.to_string n
    | Or s -> print "It's a string: " ^ s
```
In the `Either` branch, the variable `n` will be bound to the integer content, and in the `Or` branch, the variable `s` will be bound to the string content.

For the `result` type, let's say we want to write a function that increments the content of a `result` by 1 if it's a `Success`, and does nothing if it's a `Failure`. We can do this as follows:
```ocaml
let increment (x: result) : result = 
    match x with
    | Success n -> Success (n + 1)
    | Failure s -> Failure s
```
Note that in the failure case, we return the same `Failure` value, so we don't really care about the exact error message. This can be written equivalently as:

```ocaml
let increment (x: result) : result = 
    match x with
    | Success n -> Success (n + 1)
    | Failure _ -> x
```
where `Failure _` means "any `Failure` value, I don't care about the exact error message".

### Summary

Understand the following table, and you're golden for the rest of the course:
| Type                                   | Logical interpretation | How to build data            | How to use data                               |
| -------------------------------------- | ---------------------- | ---------------------------- |
| Product A * B                          | AND                    | `(a, b)`                     | `let (x, y) = pair in ...`                    |
| Enum `type c = TagA of A \| TagB of B` | OR                     | Either `TagA a`, or `TagB b` | `match x with TagA x -> ... \| TagB y -> ...` |


## Useful Data Structures
Believe it or not, these two types are all you need to build (almost) any data structure you can think of. To define your favorite data structure, you can first give the data structure a logical interpretation, and then translate them by mapping AND to products and OR to enums.


For example, a singly linked list is **either** empty, **or** <it has **both** a head element and a tail, which is another singly linked list>. To map this to OCaml, observe that
- the outer structure is a logical OR, so we use one tag for the empty case, and another tag for the non-empty case. 
- the non-empty case is further an AND, so we use a product to package the head and tail together.
In OCaml, this is just:
```ocaml
type singly_linked_list = 
    | Empty
    | NonEmpty of int * singly_linked_list
```
assuming the list contains integers. (Next week we'll see how to make this definition generic, so that you can have lists of any type of element with a single definition.)

Since `singly_linked_list` is a type, we can ask:
1. How to build a `singly_linked_list`?
2. How to use a `singly_linked_list`?

To answer the first question, we can examine the type definition.
- First and foremost, a `singly_linked_list` is an enum type. To build an enum, we need to use one of the tags, i.e., either `Empty` or `NonEmpty`.
- In the `NonEmpty` case, we have the product `int * singly_linked_list`, so we need to provide an integer and another `singly_linked_list` to build the pair.

For example, below are some `singly_linked_list`s:
```ocaml
let empty = Empty;;
let one_element = NonEmpty (1, Empty);;
let two_elements = NonEmpty (1, NonEmpty (2, Empty));;
```

To answer the second question, since `singly_linked_list` is an enum type, we need to use pattern matching to figure out which case we're in, and extract the content in the envelope accordingly. For example, if we want to compute the length of a `singly_linked_list`, we can do this as follows:
```ocaml
let rec length (l: singly_linked_list) : int = 
    match l with
    | Empty -> 0
    | NonEmpty pair -> ??
```
In the base case, the length of an empty list is 0. Let's figure out what to do in the `NonEmpty` case. First, what is the type of `pair`? According to the type definition, it should be `int * singly_linked_list`. So, we can extract the head and tail of the list as follows:
```ocaml
let rec length (l: singly_linked_list) : int = 
    match l with
    | Empty -> 0
    | NonEmpty pair ->
        let (head, tail) = pair in
        ???
```
Then we can recursively compute the length of the tail, and add 1 to it. So `???` can be `1 + length tail`.

A useful syntactic sugar is that if a product is contained in a tag, you can immediately unpack the product in the `match` statement:
```ocaml
...
| NonEmpty (head, tail) -> 1 + length tail
```
instead of first naming the product, and then unpacking it.


