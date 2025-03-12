# Solutions to HW1 Exercises


## Part 1

### Problem 2
1. Say we have `n : int`. Then `Some n : int option`.
2. `None : int option`
3. Yes. Say we have `x : t`. Then `Some x : t option`. Or `None: t option`.
4. Yes. `None : t option`.
5. Not always. We can get a `t` out of a `t option` if and only if `t option` is the case of `Some x`, in which case we can extract `x : t`. If you want to define a function of type `t option -> t`, you'd also have to provide a "default" value in case `t option` is `None`, so you would end up defining `t -> t option -> t`. In fact, the generic function `'a option -> 'a` is not definable as `'a` can be anything, and there is no way to provide a default value for any `'a`.


### Problem 3
1. Say we have `n : int`, `b : bool`, and `s : string`, then `(n, b, s) : int * bool * string`.
2. Say we have `x : t1` and `y : t2`:
   1. Yes, with `(x, y) : t1 * t2`.
   2. Yes, with `(y, x) : t2 * t1`.
   3. Yes, with `(y, x, x, y, x) : t2 * t1 * t1 * t2 * t1`.
3. Yes. Say `p : t1 * t2`. You can pattern match on `p` as in `match p with (x, y) -> ...` or `let (x, y) = p in ...`.
       ```
## Part 4

### Problem 0
1. With x = 1,
    ```ocaml
       (3 * (4 + x); 1 + x + 5) * 2;  100 * x
    == (3 * (4 + 1); 1 + x + 5) * 2;  100 * x
    == (3 * 5;       1 + x + 5) * 2;  100 * x
    == (15;          1 + x + 5) * 2;  100 * x
    == (             1 + 15 + 5) * 2; 100 * x
    ==                        21 * 2; 100 * x
    ==                            42; 100 * x
    ==                                4200
    ```
2. Here's one possible parse:
    ```
    Compose(
        Mul(
            Compose(
                Add(
                    Mul(Const 3, Const 4),
                    X
                ),
                Add(
                    Add(
                        Const 1,
                        X
                    ),
                    Const 5
                )
            ),
            Const 2
        ),
        Mul(
            Const 100,
            X
        )
    )
    ```

3. Potential sources of ambiguity:
   - `*` has higher precedence than `+`
   - It's not clear whether `*` and `+` are left-associative or right-associative
   - It is not clear what is the precedence of `;`.

