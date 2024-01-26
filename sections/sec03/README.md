# Section 3

The core of lambda calculus is **variable binding and substitution** -- these concepts are not only fundamental to nearly all programming languages, but also a profound linguistic phenomenon that is ubiquitous in natural languages and mathematical discourse. Substitution is also extremely powerful -- a language with just binding and substitution is already Turing-complete, and can be used to simulate the execution of any computer program in any programming language.

In this section, you will see that the strange-sounding terminology you learned about lambda calculus, such as alpha-renaming, beta-reduction, and capture-avoiding substitution, are actually very natural and intuitive concepts that you have been using all along in your previous programming experience, math classes, and even daily life.


### Names and Bindings

A *binding* is an association of a name with an entity. Syntactically, there are two operations you can do about a binding:
- *declaration*, which introduces a name and (optionally) associates the name with an entity. This construct is also called a *binder*.
- *reference*, which uses a name to retrieve to the entity associated with the name.

Semantically, the meaning of a binding is given by **substitution**: when you use a name to retrieve the entity associated with it, you are essentially replacing the reference with the entity itself. Thus, to interpret the meaning of something that has a binder in it, simply replace all references to name `X` with the entity associated with `X`.


#### Example 1: variable binding in functional languages

In programming languages, the most common example of binding is variable binding. For example, consider the following OCaml program:
```ocaml
let x = 2 in 
let y = x + 1 in
x * y
```
The following binding syntax is used:
1. The first `let` is a *declaration/binder* that declares the name `x`, and associates it with the OCaml value `2`
2. On the right-hand-side of the second `let`, we use the name `x` to *refer* to the value associated with `x`. Then, we declare a new name `y` and associate it with the value of `x + 1`.
3. Finally, the last line uses the names `x` and `y` to retrieve the values associated with them.

To see what the binding structure of this program means, we can perform substitution to replace all references with the entities that they refer to. First, we replace all references to `x` with `2`:
```ocaml
let y = 2 + 1 in
2 * y
```
Next, we replace all references to `y` with `2 + 1`:
```ocaml
2 * (2 + 1)
```
Thus, the meaning of the original OCaml program is the same as the meaning of `2 * (2 + 1)`. Although we can give further meaning to `2 * (2 + 1)` by defining what `+` and `*` mean, those are orthogonal to the meaning of bindings. You will learn about how to give meaning to those kinds of non-binding expressions when we talk about *operational semantics* later in this course.



#### Example 2: variable assignment in imperative languages

The entities associated with names do not necessarily have to be immutable values as in OCaml. In your previous programming adventures, you mostly likely encountered mutable variables, as illustrates by the following Java/C program:
```java
int x = 2;
x = x + 1
```
Surprisingly, this is also an instance of binding, except that a name is now associated with a *mutable memory box* that can be initialized, read, and updated:

1. With `int x = 2`, we create a binder by declaring a new name `x`, and associate it with a fresh memory box initialized with the value `2`. 
   <!-- If we represent this program in some imaginary "abstract syntax", it might look like this:
    ```ocaml
    Sequence(
        Decl("x"),
        Assoc("x", AllocMemoryBox(Int 2))
   )
   ```
   where `Decl(x)` abstractly represents the operation of declaring a new name `x`, and `Assoc(x, e)` represents the operation of associating a name with an entity. Note that declaration and association is disjoint, since in Java/C it is legal to create a variable without initializing it, e.g. `int x;`, which might be represented by `Decl("x")` without `Assoc("x", _)`. 
    > **Looking ahead**: You will later see important cases in which declaration and association are completely disjoint: we will declare names and immediately refer to them without associating them with any entity first. 
    > 
    > This might sound paradoxical and unsafe: how can you refer to something that doesn't seem to exist? However, we will see that this is the essence of procedural abstraction (functions, methods, procedures, etc.), and hence the lambda calculus. -->
2. In `x = x + 1`, 
   - on the right-hand-side of `=`, we use the name `x` to retrieve the memory box associated with `x`, and read the value stored in the memory box 
   - on the left-hand-side of `=`, we retrieve the memory box associated with the name `x` again, but this time we update the memory box by storing the value of `x + 1` in it. 

    <!-- If we represent `x = x + 1` in some imaginary "abstract syntax" that uses `Ref x` to retrieve the entity associated with a name, then it  might be represented by
   ```ocaml
    Write(
        Ref "x", 
        Add(
            Read(Ref "x"), 
            Int 1))
    ```
    > **Background**: Note that the meaning of "x" is different depending on whether it is on the left-hand-side or the right-hand-side of `=`! This is the origin of the concept of *l-value* and *r-value* in C-like languages.  -->
    
> As you can see, in an imperative language, a variable actually de-sugars into a whole bunch of binding-related operations plus non-binding-related operations, depending on where that variable appears:
> 1. If a variable appears in `int x`, then it de-sugars into
>       - **declaring** of a name `x`, 
>       - allocating some memory box, and 
>       - **associating** the name with the memory box.
> 2. If a variable appears on the left-hand-side of `=`, then it means
>       - **retrieving** the memory box associated with the name, and
>       - updating the memory box with the value on the right-hand-side of `=`.
> 3. If a variable appears on the right-hand-side of `=`, then it means
>       - **retrieving** the memory box associated with the name, and
>       - reading the value stored in the memory box.
>
> Notice that only half of the operations (which are **bold-faced**) are actually about binding! The other operations are about memory allocation and mutation, whose semantics are completely orthogonal to binding. If you still recall the very first time you learned about variables in your first programming class and you recall being confused at that time, this complexity might explain the confusion.

As before, the meaning of the binding structure in
```java
int x = 2;
x = x + 1
```
can be given in terms of substitution. Say we're using heap allocated memory, and we allocated address `0x1234` for the memory box associated with `x`. Then, after substituting `x` with `0x1234` and some de-sugaring, we get
```java
store (0x1234, 2);
store (0x1234, load(0x1234) + 1)
```
The remaining operations like `store` and `load` can be further interpreted, but the meaning of the binding structure has been completely specified.



The takeaway is that even for imperative languages, "mutable variables" are just *an instance of binding*, which simply associates names to some kind of entity. In the case of functional programming, we saw the entities were immutable values; in the case of imperative programming, the entities are mutable memory boxes, or some stack- or heap-allocated memory.


### Scope

A *scope* of a binding is the duration for which the association between a name and an entity exists. In programming languages, dereferencing a name outside of its scope results in compiler errors like "variable not found" or "variable out-of-scope".

#### Example: variable scope in OCaml

Consider the following OCaml program:
```ocaml
let y = (let x = e1 in e2) in e3
```

You can use `x` as a reference in `e2`, but not in `e1` or `e3`. This is because OCaml stipulates that the scope of a let-bound variable is the expression that follows the `in` keyword. Similarly, the only place you can use `y` as a reference in in `e3`.


#### Example: variable scope in imperative for-loops

**Exercise**: Consider the following Java program:
```java
<P>
for (int i = 0; i < 10; i++) {
    System.out.println(i);
}
<Q>
```
where `<P>` and `<Q>` are arbitrary Java programs.

1. Find all the places where some name is 
   - declared, 
   - used as a reference, or
   - associated with an entity (what kind? memory box or immutable value?).

2. What is the scope of the loop index variable `i`? (Hint: there is more than one place where `i` is in scope.)

**Exercise (Skip if you aren't familiar with Python)**: Consider the following Python program:
```python
<P>
for i in range(10):
    print(i)
<Q>
```
1. Find all the places where some name is 
   - declared, 
   - used as a reference, or
   - associated with an entity (what kind? memory box or immutable value?).
2. What is the scope of the loop index variable `i`? (Hint: there is more than one place where `i` is in scope.)


#### Example: bindings in math

A declared name does not need to be immediately associated with an entity. You can just declare a name, and use it as a reference. Later, you might want to go back and do the association. 

A prime example is when you are defining a mathematical function. You might write something like this:
```math
f(x, y) = xy + 1
```
Here, on the left-hand-side of $=$, both $x$ and $y$ are declaration of names. The $x$ and $y$ on the right-hand-side are references.

**Exercise**: What is the scope of $x$ in the above equation?

Note that the name $x$ (as well as $y$) is only declared, but not associated with any entity. This is because we are defining a function, so we don't know what the input $x$ is yet. The act of associating $x$ with an entity happens when the function is evaluated with an input, and is achieved by substituting all references to a name with the entity.

For example, the meaning of $f(2,3)$ is given by replacing all $x$ with $2$ and $y$ with 3:
```math
f(2,3) = 2 \times 3 + 1
```

Besides function notation, bindings are quite ubiquitous in math and logic. Here are some more examples:
1. In integral calculus, you might write something like this:
   
   <img src="https://raw.githubusercontent.com/fredfeng/CS162/master/sections/sec03/res/int.png" alt="drawing" style="width:200px;"/>

    **Exercise**:
    1. Identify all the places where some name is declared, or referenced.
    2. What are the scopes of $x$ and $y$ in the above integral?
    3. When do you substitute the variables with numerical entities? How many times does substitution happen?


3. In first-order logic, you might have encountered formulas like this:
   
   <img src="https://raw.githubusercontent.com/fredfeng/CS162/master/sections/sec03/res/fol.png" alt="drawing" style="width:300px;"/>
   
    **Exercise**:
    1. Identify all the places where some name is declared or referenced.
    2. What is the scope of $x$ and $y$ in the above equation?


**Open-Ended Exercise**: Identify an OCaml language feature -- besides `let` and functions -- that makes use of binding in some way. (Hint: You used this feature *a lot* in HW1.) Then, think about the following questions:
1. Where and how do you declare a name to be in scope?
2. What is the scope of a declared name?
3. How do you reference a name?
4. When do you associate the name with an entity?


**Open-Ended Question**: Repeat the previous exercise, but replace "OCaml" with "your favorite programming language". If your favorite programming language [happens to be OCaml](https://www.youtube.com/shorts/pd-L6YVTUv8), then replace "OCaml" with "your favorite programming language that isn't a functional language".



### Free and Bound References

A referenced name is *free* in an expression if it is not declared to be in scope. A referenced name is *bound* if it is not free, i.e., it has been declared to be in scope. Note that **freeness and bound-ness are properties of references**, not of declarations, since a name declaration is a "binder" and can be vacuously considered "bound".

#### Example: bindings in natural languages

In natural languages, we also use names to refer to entities. Here's an except of the [terms of use for OpenAI ChatGPT](https://web.archive.org/web/20240110034600/https://openai.com/policies/terms-of-use):
> You may provide input to the *Services* ("**Input**"), and receive output from the *Services* based on the *Input* ("**Output**"). *Input* and *Output* are collectively "**Content**." 
> 
>  If you do not want us to use your *Content* to train our models, you can opt out by following the instructions in this Help Center article. Please note that in some cases this may limit the ability of our *Services* to better address your specific use case.

Declarations/binders are **bold-faced**, while references are *italicized*.

Note that this excerpt contains both bound and free references:
- The names `Input`, `Output`, `Content` are declared in the first paragraph. Their scope implicitly extends to the end of the excerpt, and hence subsequent references to `Input`, `Output`, `Content` are *bound*.
- The name `Services` is referenced a couple of times, but it is not declared in this excerpt. Thus, we say that the "Services" references are *free* in this excerpt.

#### Example: equations in maths

Here's a system of math equations which you have probably learned how to solve:
```math
\begin{cases}
3x + 5y = 2 \\
x + 2y = 1
\end{cases}
```
This system of equations contains references to names $x$ and $y$. Yet those two names are not declared anywhere in the equation. Thus, we say that the names $x$ and $y$ are *free* in this system of equations. 

The consequence of being a free reference is that it can be substituted with *anything* by a surrounding context. For example, the context
```math
\textsf{let}\ x = 2\ \textsf{in}\
\textsf{let}\ y = 1\ \textsf{in}\
\ldots
```
plugs in the values $2$ and $1$ for $x$ and $y$, respectively, and results in the following system of equations that contains no more free variables:
```math
\begin{cases}
3 \cdot 2 + 5 \cdot 1 = 2 \\
2 + 2 \cdot 1 = 1
\end{cases}
```




#### Example 5: lambda calculus

In lectures, you saw that the lambda calculus is defined by the following grammar:
```math
\begin{array}{rcll}
e & ::= & x & \text{variable} \\
& \mid & \lambda x. e & \text{abstraction} \\
& \mid & e\ e & \text{application}
\end{array} 
```

This language quite minimal. In fact, it seems that the first two of the two cases are just there to model the two kinds of binding syntax that we have seen:
- The first case corresponds to a *reference* to some name $x$.
- The second case corresponds to a *declaration/binder* of a name $x$ whose scope extends to the expression $e$ but not beyond. That is, $\lambda x. e$ is the roughly same as `bind x in e`, or `declare x in e`, if you use a more readable syntax.

The third case may be a bit more mysterious. But you have seen in lectures that the meaning of application is given *substitution*, which associates a name with an entity by replacing all references to the name with the entity. Thus, application is nothing more than the association operation, which gives meaning to binding via substitution.

<!-- > The only difference between lambda calculus and, say, a let-expression is that in a let-expression, an association is made immediately after the declaration, whereas in lambda calculus, during declaration, the association is delayed, and is made only when the function is applied to an argument. This gives the programmer to *control when substitution happens*.
> 
> To summarize,
> - $\lambda x. e$  = delayed association/substitution
> - application = actually making the association/substitution -->

The upshot is that **lambda calculus is just a language for manipulating bindings**.


**Exercise**: For each of the following expressions, determine
- all the places where some variable is declared
- the scope of each variable
- all the places where some variable is referenced
- which variable references are free in which parts of the expression
- which variable references are bound in which parts of the expression

1. $(\lambda y. (\lambda x. x + y)\ y)$
2. $(\lambda f. \lambda x. f\ x) (\lambda x. x + 1)\ 1$
3. $(\lambda f. (\lambda x. f\ x\ y))\ f$



### Alpha-Renaming and Alpha-Equivalence

Since the only purpose of names is to refer to the associated entities, the particular choice of names when we declare them should not matter. This also captures our programming intuition that the particular names of variables or function parameters don't matter. If you consistently replaced the name of variables or functional parameters with something else, the resulting program should mean the same thing.

This notion of "sameness-under-renaming" is captured by *alpha-renaming* and *alpha-equivalence*:

- Let $p$ and $q$ be arbitrary expressions in some language. An *alpha-renaming* of $p$ into $q$ is a substitution of all declared names and their bound references in $p$ into declared names and their bound references in $q$. 
  - We write $p \to_\alpha q$ to denote that $p$ can be alpha-renamed into $q$.

- Furthermore, $p$ and $q$ are said to be *alpha-equivalent* if $p \to_\alpha q$ and $q \to_\alpha p$. That is, you can replace all bound names in $p$ to get $q$, and symmetrically you can replace all bound names in $q$ to get $p$. 
  - We write $p =_\alpha q$ to denote that $p$ and $q$ are alpha-equivalent.

An important point is that **an alpha-renaming does not touch the free references in $p$**. This is because a free reference in $p$ or $q$ may have been given a particular association in the surrounding context, and we don't want to break that association. Since surrounding context can be arbitrary, we can't possibly know what the association is, so we better not touch the free references. We will see some examples to illustrate this and the bad things that can happen if we don't respect this rule.


#### Example: alpha-renaming in OCaml
Recall the following OCaml program:
```ocaml
let x = 2 in
let y = x + 1 in
x * y
```
This program is "essentially the same" as the following program:
```ocaml
let hello = 2 in
let world = hello + 1 in
hello * world
```
This "essential-sameness" is captured by the following pair of alpha-renaming:
- `x -> hello, y -> world` turns the first program into the second program
- `hello -> x, world -> y` turns the second program into the first program

You can verify that both programs mean the same thing by performing substitution. Both become `2 * (2 + 1)`.

Here are some programs that are not alpha-equivalent to the first program.
1. Consider
   ```ocaml
   let hello = 2 in
   let world = hello + 1 in
   x * world
   ```
   We can't possibly exhibit a renaming from the original program to this one. This is because any renaming must map `x` to `hello` according to the first line, `y` into `world` according to the second line, but the third line forces us to map `x` into `x`. So there's a conflict as to what `x` should be mapped to.

2. Consider
    ```ocaml
    let hello = 2 in 
    let hello = hello + 1 in
    hello * hello
    ```
    To alpha-rename the original program into this one, we map both `x` and `y` into `hello`. But no alpha-renaming exists in the other direction, since we can't map `hello` into both `x` and `y` at the same time!
    

    We can see this more clearly that these two programs are not the same if we perform substitution. The original program becomes
    ```ocaml
    2 * (2 + 1)
    ```
    while the other program becomes
    ```ocaml
    (2 + 1) * (2 + 1)
    ```
    
#### Example: alpha-renaming in OCaml (bad)

To see why alpha-renaming only renames bound references and respects the free references, consider the following OCaml program:
```ocaml
let x = 2 in
print_int(x + y)
```

Let's say we "renamed" it into
```ocaml
let y = 2 in
print_int(y + y)
```

This is problematic because `y` was a free variable reference inside `print_int` in the original program, but it becomes a bound variable in the renamed program. In doing so, we actually changed the meaning of this program! Suppose there's a preceding context
```ocaml
let y = 100 in 
...
```

Then, the context plus the original program will print `102`, but the context plus the other program will print `4`.

The technical term to describe this phenomenon, where a free reference becomes bound after substitution, is that a free reference is *captured*. This is a very bad thing, because the meaning of a program has been altered.

**Exercise**: For each of the pair (P1, P2) of expressions below, determine whether they are alpha-equivalent.
- If they are, give a pair of alpha-renaming that witnesses the alpha-equivalence. 
- If they are not, explain why not, and come up with a third expression P3 that is alpha-equivalent to the first expression P1.

1. Consider P1 = 
    ```ocaml
    let x = 2 in 
    let y = (x + 1 in x) in 
    x * y
    ```
    and P2 =
    ```ocaml
    let y = 2 in
    let x = (y + 1 in y) in
    y * x
    ```
2. Consider the previous P1, and P2 = 
    ```ocaml
    let y = 2 in
    let x = (y + 1 in y) in
    x * y
    ```

3. Consider P1 = 
   ```math
   \int_0^1 \int_1^{y+1} 3x^2 + 4y\ dx\ dy
   ```
   and P2 = 
    ```math
    \int_1^{x+1} \int_0^1 3y^2 + 4x\ dy\ dx
    ```

4. Consider P1 = 
   > You may provide input to the *Services* ("**Input**"), and receive output from the *Services* based on the *Input* ("**Output**"). *Input* and *Output* are collectively "**Content**." 
   > 
   >  If you do not want us to use your *Content* to train our models, you can opt out by following the instructions in this Help Center article. Please note that in some cases this may limit the ability of our *Services* to better address your specific use case.

   and P2 =    
   > You may provide input to the *ChatGPTButIHaveNoIdeaHowItWorks* ("**YourPrivacy**"), and receive output from the *ChatGPTButIHaveNoIdeaHowItWorks* based on the *YourPrivacy* ("**NotPrivateAnymore**"). *YourPrivacy* and *NotPrivateAnymore* are collectively "**Stuff**."
   > 
   >  If you do not want us to use your *Stuff* to train our models, you can opt out by following the instructions in this Help Center article. Please note that in some cases this may limit the ability of our *ChatGPTButIHaveNoIdeaHowItWorks* to better address your specific use case.
   
   (Disclaimer: The second excerpt is just designed for practice and is in no way representative the author's view of ChatGPT, or LLMs in general.)


**Exercise**: Is $=_\alpha$ an equivalence relation? That is, is it reflexive, symmetric, and transitive? If so, informally argue why each property is satisfied. If not, give a counterexample for a property that is not satisfied.

**Exercise**: If you think $=_\alpha$ is an equivalence relation, can you come up with a plausible canonical form such that all terms that are alpha-equivalent have the same representation?



### Capture-Avoiding Substitution

A substitution replaces all references to a name in an expression with some entity. This operation is usually written as $c[x \mapsto e]$, which means substituting all references to $x$ with entity $e$ in the context expression $c$. In lambda-calculus, when a substitution is triggered by evaluating an application expression, the substitution is called a *beta-reduction*.

If someone proposes an implementation of substitution to you, a natural question you can interrogate about their implementation is: 

> If I have two programs that are essentially the same, and if I perform exactly the same substitution, do they remain essentially the same, as they should?

This property can be states more concisely as *substitution should preserve alpha-equivalence*: 

> if $c_1 =_\alpha c_2$, then $c_1[x \mapsto e] =_\alpha c_2[x \mapsto e]$ for any $x$ and $e$. 

A substitution that enjoys this property is said to be *capture-avoiding*. Capture-avoiding substitution is extremely important because it does not alter the meaning of a program in unexpected ways, and is an integral part of many optimizing compilers, interpreters, and proof assistants.

Capture-avoiding substitution is best illustrated in terms of pictures. First, fix some background language: programming language, mathematical notation, or natural language, whatever. Consider the space of all possible expressions in this language:

<img src="https://raw.githubusercontent.com/fredfeng/CS162/master/sections/sec03/res/programs.001.png" alt="drawing" style="width:400px;"/>

Then alpha-equivalence partitions the space of all expressions in this language into non-overlapping groups (aka equivalence classes), where all expressions in the same group are alpha-equivalent to each other:


<img src="https://raw.githubusercontent.com/fredfeng/CS162/master/sections/sec03/res/programs.002.png" alt="drawing" style="width:400px;"/>


A substitution can be visualized as an arrow that takes one expression to another expression:


<img src="https://raw.githubusercontent.com/fredfeng/CS162/master/sections/sec03/res/programs.003.png" alt="drawing" style="width:400px;"/>


A capture-avoiding substitution preserves alpha-equivalence. This means that if we initiate this arrow from two expressions in the same group, then it must land them into the another group at the same time:


<img src="https://raw.githubusercontent.com/fredfeng/CS162/master/sections/sec03/res/programs.004.png" alt="drawing" style="width:400px;"/>


The red edge between the starting points of the arrows denotes that the two input expressions are alpha-equivalent. There is another red edge between the ending points of the arrows, which denotes that the two output expressions are still alpha-equivalent.

A non-capture-avoiding substitution can land two expressions into different groups, which means the output expressions are no longer alpha-equivalent:


<img src=https://raw.githubusercontent.com/fredfeng/CS162/master/sections/sec03/res/programs.005.png alt="drawing" style="width:400px;"/>

<!-- This is important property for any alpha-renaming is that it does not capture any free variables after the renaming. In fact, this is a must-have property for any substitution in order to not inadvertently alter the meaning of a program. -->

Despite its importance, implementing capture-avoiding substitution correctly is usually a very subtle yet intellectually unrewarding coding gymnastic. Hence, unlike previous quarters, we won't ask you implement capture-avoiding substitution in homework this time; but **do understand the concept**, as it may appear on the midterm.

The heart of the difficulty of implementing capture-avoiding substitution boils down to correctly handling the case of `c [ x |-> e ]` such that the context `c` is a binder like `bind y in e2` which binds `y` in scope `e2`. Examples of this kind of context includes all kinds of binders that we talked about (and a few more that we will introduce in the next assignment):
- `lambda x. e`: `x` is bound in scope `e`
- `let x = e1 in e2`: `x` is bound in scope `e2`
- $\forall x. P$: $x$ is bound in scope $P$
- $f(x) = \square$: $x$ is bound in scope $\square$

Let's use the second case (`lambda x. e`) to illustrate the subtlety. Let's say we are naive, and simply recursively do substitution $x \mapsto e$ in the body of $\lambda x. e_1$. The body is $e_1$, but we are doing the substitution under the context of $\lambda x. \square$. Under this context, any reference using $x$ has to be in-scope. A corner case is, what if $e$ contains $x$ as a free reference? Then, after substitution, $e$ will live inside the context $\lambda x. \square$, and the free reference $x$ will point to the $x$ declared in-scope by the context. This makes a previously free reference no longer free! This is exactly the meaning-altering problem of variable-capture that we want to avoid.

#### Example

Say we're doing the substitution $(\lambda x. y)[ y \mapsto x]$. If we recursively substitute in the body, we get $\lambda x. x$. Let's keep the result in mind.

Now, since alpha-renaming shouldn't change the meaning of a program, if we do the same substitution on an alpha-equivalent term, the new result should be alpha-equivalent to our previous result, right? 

Well, since $\lambda x. y =_\alpha \lambda z. y$, if we do the same substitution on $\lambda z. y$, we should get an equivalent result. Let's do $(\lambda z. y)[y \mapsto x]$. Again, we recursively substitute, giving us $\lambda z. x$. But immediately, $\lambda z. x\ {\not=}_\alpha\ \lambda x. x$! The free reference $x$ is not captured in $\lambda z. x$, but it is captured in $\lambda x. x$. This shows that implementing substitution naively very rarely gives you a capture-avoiding substitution.

The reason the second input doesn't lead to a capture is because in $\lambda z. y$, the choice of using $z$ as the parameter is lucky, as it doesn't appear as free reference in the expression $x$. In contrast, in $\lambda x. x$, the choice of using $x$ as the parameter is unlucky, because the name $x$ is used as a free reference in expression $x$.

To fix our naive substitution implementation, we need to do exactly what we did above: first, **alpha-rename** the context expression $c$ into another equivalent one $c'$, such that no capturing is possible for the particular $e$ that we're substituting with.
Then we go ahead and do the naive substitution for $c'$. This time we won't run into any capture.

But, there's another subtlety: alpha-renaming $c$ into $c'$ is itself another substitution! So this substitution has to be capture-avoiding too, and in order to be capture-avoiding, we may need to alpha-rename again. That is, an alpha-renaming can trigger another alpha-renaming... This is where the implementation can get messy.

**Exercise:** On a piece of paper, perform the following substitution in a capture-avoiding manner. If you need to alpha-rename, follow the following convention:
- Rename `x` into `x0`, `x1`, `x2`, etc.
- Rename `y` into `y0`, `y1`, `y2`, etc.
- Rename `y0` into `y00`, `y01`, `y02`, etc.

Perform the following substitutions:
1. `(lambda y. x y) [x |-> lambda x. y]`
2. `(lambda y. x y y0) [x |-> lambda x. y]`
3. `(lambda y. let y0 = 5 in y) [f |-> lambda x. y]`
4. `(lambda y. let x = 5 in z) [z |-> lambda y. x]`

In one of the cases, an alpha-renaming will trigger another alpha-renaming. Which case is it?


**Exercise:** As mentioned, the capture-avoiding property can be broken in a substitution `c[x |-> e]` exactly when:
- c is some kind of binder that would make certain free reference in `e` become bound, and
- we are naive and forget about alpha-renaming `c`.

However, what if we are allowed to assume that `e` is a *closed expression* (meaning that `e` contains no free references, aka a *combinator* in lambda calculus)? Is it still possible for the naive substitution to exhibit variable-capture, even if we don't ever alpha-rename `c` or any of its sub-expression? If so, give an example. If not, argue informally why this is impossible.