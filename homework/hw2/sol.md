# Solutions to HW2 Exercises


## Part 1

### Problem 1.1
```ocaml
fun (x: int) (y: int) (z: int): int -> x + y + z
```

### Problem 1.2
See [lecture 4](../../lectures/lecture4.pdf).

### Problem 1.6:
See the [library implementation](https://github.com/ocaml/ocaml/blob/c82ce40504f0875969bf86b22e4d6ec7e26b3153/stdlib/list.ml#L125).

### Problem 1.7

```ocaml
List.fold_left (fun acc (k,v) ->
    match acc with
    | None -> if equal k key then Some v else None
    | Some _ -> acc) None dict
```

### Problem 1.8
1. `compress`
    - Using `fold_right`:
        ```ocaml
        List.fold_right (fun x acc ->
            match acc with
            | [] -> [x]
            | y::ys -> if equal x y then acc else x::acc) lst []
        ```
    - `compress` can't be implemented with just `fold_left` alone, but if you have `List.rev` available, you can do:
        ```ocaml
        List.rev (List.fold_left (fun acc x ->
            match acc with
            | [] -> [x]
            | y::ys -> if equal x y then acc else x::acc) [] xs)
        ```
    Altneratively, if you have `last_opt: 'a list -> 'a option` that returns the last element of a list (and `None` if the list is empty), you can do:
        
        ```ocaml
        List.fold_left (fun acc x ->
            match last_opt acc with
            | None -> [x]
            | Some y -> if equal x y then acc else acc @ [x])
            [] xs
        ```

2. `max`:
   - Using `fold_right`:
        ```ocaml
        match xs with
        | [] -> None
        | x::xs -> Some (List.fold_right (fun x acc -> if x > acc then x else acc) xs x)
        ```
    - Using `fold_left`:
        ```ocaml
        match xs with
        | [] -> None
        | x::xs -> Some (List.fold_left (fun acc x -> if x > acc then x else acc) x xs)
        ```
3. `join`:
    - Using `fold_right`:
        ```ocaml
        List.fold_right (fun x acc ->
            match x, acc with
            | Some x, Some acc -> Some (x::acc)
            | _ -> None) xs (Some [])
        ```
    - Using `fold_left`: 
        ```ocaml
        List.fold_left (fun acc x ->
            match x, acc with
            | Some x, Some acc -> Some (acc @ [x])
            | _ -> None) (Some []) xs
        ``` 
4. It suffices to observe that `map` itself can be implemented using `fold_right` as:
    ```ocaml
    List.fold_right (fun x acc -> f x :: acc) xs []
    ```
    or using `fold_left` as:
    ```ocaml
    List.fold_left (fun acc x -> acc @ [f x]) [] xs
    ```
5. See above.
6. `filter`:
    - Using `fold_right`:
        ```ocaml
        List.fold_right (fun x acc ->
            if p x then x::acc else acc) xs []
        ```
    - Using `fold_left`:
        ```ocaml
        List.fold_left (fun acc x ->
            if p x then acc @ [x] else acc) [] xs
        ```
7. `length`:
    - Using `fold_right`:
        ```ocaml
        List.fold_right (fun _ acc -> acc + 1) xs 0
        ```
    - Using `fold_left`:
        ```ocaml
        List.fold_left (fun acc _ -> acc + 1) 0 xs
        ```
8. `id`:
    - Using `fold_right`:    
        ```ocaml
        List.fold_right (fun x acc -> x::acc) xs []
        ```
    - Using `fold_left`:
        ```ocaml
        List.fold_left (fun acc x -> acc @ [x]) [] xs
        ```
9. `rev` (note the symmetry with the previous problem):
   - Using `fold_right`:
        ```ocaml
        List.fold_right (fun x acc -> acc @ [x]) xs []
        ```
    - Using `fold_left`:
        ```ocaml
        List.fold_left (fun acc x -> x::acc) [] xs
        ```
10. `append`:
    - Using `fold_right`:
        ```ocaml
        let append xs ys = 
            List.fold_right (fun x acc -> x::acc) xs ys
        ```
    - Not possible using `fold_left` if `@` isn't allowed.
11. `flatten`:
    - Using `fold_right`:
        ```ocaml
        List.fold_right (fun x acc -> x @ acc) xs []
        ```
    - Using `fold_left`:
        ```ocaml
        List.fold_left (fun acc x -> acc @ x) [] xs
        ```
12. `concat_map`:
    - Using `fold_right`:
        ```ocaml
        List.fold_right (fun x acc -> f x @ acc) xs []
        ```
    - Using `fold_left`:
        ```ocaml
        List.fold_left (fun acc x -> acc @ f x) [] xs
        ```
    Note that `concat_map` is just `map` followed by flatten.





## Part 2

### Problem 2.0

1. `let x = 2 in let y = x * x in x + y`:
    ```ocaml
    Let(
        Num 2,
        ("x",
            Let(
                Binop (Mul, Var "x", Var "x"),
                ("y",
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
        Lambda (
            "x",
            Lambda (
                "y",
                Let (
                    Binop (Add, Var "x", Var "y"),
                    (
                        "z",
                        Binop (Mul, Var "z", Var "z")
                    )
                )
            )
        ),
        Num 2),
    Num 3)
   ```
   Note that application is left-associative.

3. `fun f with x = let x = x + 1 in x in f f`. First, `fun F with X,Y,.. = E1 in E2` is desugared into `let F = lambda X, Y,.. . E1 in E2`. The AST is thus
    ```ocaml
    Let (
        Lambda (
            "x",
            Let (
                Binop (Add, Var "x", Num 1),
                ("x", Var "x")
            )
        ),
        ("f", App (Var "f", Var "f"))
    )
    ```
