# Solutions to HW1 Written Exercises


## Part 1

### Problem 1
```ocaml
fun (x: int) (y: int) : int -> x + y
```

### Problem 2
1. Informal descriptions:
   1. `map` takes a function `f` and a list `l` and applies `f` to each element of `l`.
   2. `filter` takes a boolean predicate `p` and a list `l` and returns a list of elements of `l` that satisfy `p`.
   3. `fold` takes a binary function `f`, an initial value `acc`, and a list [x1; x2; ...; xn] and returns `f(...(f(f(acc, x1), x2), ...), xn)`.
2. Types:
   1. `map` has type `('a -> 'b) -> 'a list -> 'b list`.
   2. `filter` has type `('a -> bool) -> 'a list -> 'a list`.
   3. `fold` has type `('a -> 'b -> 'a) -> 'a -> 'b list -> 'a`.
3. See [lecture 4](../../lectures/lecture4.pdf).

### Problem 6:
1. 
    ```ocaml
    let compress (equal: 'a -> 'a -> bool) (xs: 'a list) : 'a list =
        solve 
            []
            (fun x r -> 
                match r with
                | [] -> [x]
                | y :: ys -> if equal x y then r else x :: r)
            xs
    ```
2. 
    ```ocaml
    let max (xs: int list) : int option = 
        solve 
            None
            (fun x r -> 
                match r with
                | None -> Some x
                | Some y -> Some (if x > y then x else y))
            xs
    ```
3. 
    ```ocaml
    let join (xs: 'a option list) : 'a list option =
        solve 
            (Some [])
            (fun x r -> 
                match x, r with
                | _, None -> None
                | None, _ -> None
                | Some x, Some r -> Some (x :: r))

4. 
    ```ocaml
    let map (f: 'a -> 'b) (xs: 'a list) : 'b list =
        solve 
            []
            (fun x r -> f x :: r)
            xs
    ```
5. 
    ```ocaml
    let filter (p: 'a -> bool) (xs: 'a list) : 'a list =
        solve 
            []
            (fun x r -> if p x then x :: r else r)
            xs
    ```

## Part 2

See [section 3](../../sections/sec03/).


## Part 3


### Problem 1

1. `let x = 2 in let y = x * x in x + y`:
    ```ocaml
    Let(
        Num 2,
        Scope ("x",
            Let(
                Binop (Mul, Var "x", Var "x"),
                Scope ("y",
                    Binop (Add, Var "x", Var "y")
                )
            )
        )
    )
    ```

2. `(lambda x, y. let z = x + y in z * z) 2 3`
   ```ocaml
   App (
    App (
        Lambda (Scope (
            "x",
            Lambda (Scope (
                "y",
                Let (
                    Binop (Add, Var "x", Var "y"),
                    Scope (
                        "z",
                        Binop (Mul, Var "z", Var "z")
                    )
                )
            ))
        )),
        Num 2),
    Num 3)
   ```

3. `fun f with x = let x = x + 1 in x in f f`
    ```ocaml
    Let (
        Lambda (Scope (
            "x",
            Let (
                Binop (Add, Var "x", Num 1),
                Scope ("x", Var "x")
            )
        )),
        Scope ("f", App (Var "f", Var "f"))
    )
    ```


### Problem 2

```ocaml

let rec wf (vs: string list) (e: expr) : bool =
    let mem (x: string) (ys: string list) : bool =
        solve false (fun y r -> String.(x = y) || r) ys in
    match e with
    | Num _ -> true
    | Binop (_, Scope _, Scope _) -> 
        (* binop doesn't bind anything *)
        false
    | Binop (_, e1, e2) -> wf vs e1 && wf vs e2
    | Var y -> mem y vs
    | Scope _ -> 
         (* a binder by itself is ill-formed;  it must be part of 
            another language construct that uses it *)
         false
    | Lambda (Scope (x, body)) -> wf (x::vs) body
    | Lambda _ -> false
    | Let (e1, Scope(x, e2)) -> 
        wf vs e1 && wf (x::vs) e2
    | Let _ -> false
```

### Problem 3

1. Examples of `e` for which `wf ["x"] e = false`
   - `Binop (Add, Var "x", Var "y")`
   - `Let (Var "x", Num 1)`
2. Example for which `wf ["x"] e = true`
   - `Let (Var "x", Scope ("x", Var "x"))`