# Solutions to HW1 Written Exercises


## Part 1

### Problem 2
1. Say we have `n : int`. Then `Some n : int option`.
2. `None : int option`
3. Yes. Say we have `x : t`. Then `Some x : t option`.
4. Yes. `None : t option`.
5. Not always. We can get a `t` out of a `t option` if and only if `t option` is the case of `Some x`, in which case we can extract `x : t`. If you want to define a function of type `t option -> t`, you'd also have to provide a "default" value in case `t option` is `None`, so you would end up defining `t -> t option -> t`. In fact, the generic function `'a option -> 'a` is not definable as `'a` can be anything, and there is no way to provide a default value for any `'a`.


### Problem 3
1. Say we have `n : int`, `b : bool`, and `s : string`, then `(n, b, s) : int * bool * string`.
2. Say we have `x : t1` and `y : t2`:
   1. Yes, with `(x, y) : t1 * t2`.
   2. Yes, with `(y, x) : t2 * t1`.
   3. Yes, with `(y, x, x, y, x) : t2 * t1 * t1 * t2 * t1`.
3. Yes. Say `p : t1 * t2`. There are at least two ways:
   1. Pattern match:
      ```ocaml
      match p with
      | (x, y) -> do something about x and y
      ```
    2. Use pair destructors `fst` and `snd`:
       ```ocaml
       let x = fst p in
       let y = snd p in
       do something about x and y
       ```
4. Neither `f p` nor `f q` will type-check. This is because `(t1 * t2) * t3`, `t1 * (t2 * t3)` and `t1 * t2 * t3` are different types in OCaml:
    1. The first type is a pair, whose first compoenent is a pair
    2. The second type is a pair, whose second component is a pair
    3. The third type is a 3-tuple.
   
   However, those types are essentially the same ("isomorphic"), by the next sub-problem.
5. We show i=2,j=3 and i=3,j=2 as an example.
    ```ocaml
    let f23 (x,(y,z)) = ((x,y),z)
    let f32 ((x,y),z) = (x,(y,z))
    ```
    To see that `f23` composed with `f32` is the identity, we can just apply it to an arbitrary value:
    ```ocaml
    f23 (f32 ((x,y),z)) 
    == f23 (x,(y,z)) 
    == ((x,y),z)
    ```
    Similarly, you can show that `f32` composed with `f23` is the identity function.
    All the other cases are similar. This shows that for any two types in `(t1 * t2) * t3`, `t1 * (t2 * t3)` and `t1 * t2 * t3`, there is a pair of functions that are inverses of each other. So all three types are "essentially the same".


## Part 4

### Problem 0
1. With x = 1,
    ```ocaml
    (3 * (4 + x); 1 + x + 5) * 2; 100 * x
    == (3 * (4 + 1); 1 + x + 5) * 2; 100 * x
    == (3 * 5;       1 + x + 5) * 2; 100 * x
    == (15;          1 + x + 5) * 2; 100 * x
    == (             1 + 15 + 5) * 2; 100 * x
    ==                        21 * 2; 100 * x
    ==                            42; 100 * x
    ==                                142
    ```
2. The concrete syntax is ambiguous for two reasons:
   1. The alien civilization may not know that `+` is left-associative, or right-associative. For example, `1 + 2 + 3` could be parsed as
      ```
          +
         / \
         +   3
        / \
       1   2
      ```
      or 
        ```
             +
            / \
            1  +
              / \
             2   3
        ```
    2. The alien civilization may not know whether `;` has higher precedence than `*`, or lower precedence than `*`. For example, `.. ; 100 * x` could be parsed as
        ```
        ( ; has lower precedence )
             ;
            / \
           ..  *
              / \
             100 x
        ```
        or
        ```
        ( ; has higher precedence )
             *
            / \
           ;   x
          / \
         ..  100
        ```
3. Here is one possible parse:
    ```ocaml
    Compose(
        Mul(
            Compose(
                Mul(
                    Const 3,
                    Add(
                        Const 4,
                        Var "x"
                    )
                ),
                Add(
                    Add(
                        Const 1,
                        Var "x"
                    ),
                    Const 5
                )
            ),
            Const 2
        ),
        Mul(
            Const 100,
            Var "x"
        )
    )
    ```

### Problem 3
```ocaml
let rec equal_expr (e1: expr) (e2: expr) : bool =
    match (e1, e2) with
    | (Const n1, Const n2) -> n1 = n2
    | (X, X) -> true
    | (Add (e11, e12), Add (e21, e22)) -> 
        equal_expr e11 e21 && equal_expr e12 e22
    | (Mul (e11, e12), Mul (e21, e22)) -> 
        equal_expr e11 e21 && equal_expr e12 e22
    | (Compose (e11, e12), Compose (e21, e22)) -> 
        equal_expr e11 e21 && equal_expr e12 e22
    | _ -> false
```

Indeed, `equal_expr` defines an equivalence relation.
This fact can be proven by [structural induction](https://en.wikipedia.org/wiki/Structural_induction).


### Problem 4
Here's one possible solution:
```ocaml
let degree (p: poly) : int option =
    let rec len (p: poly) : int = 
        match p with
        | [] -> 0
        | _::t -> 1 + len t in
    match p with
    | [] -> None
    | _ -> len p - 1
```