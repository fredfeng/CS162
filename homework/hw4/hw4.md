# Programming Assignment #4


The overall objective of this assignment is for you to get a deep understanding on [Hindley–Milner type inference](https://en.wikipedia.org/wiki/Hindley%E2%80%93Milner_type_system). In particular, constraint generation using typing rules and constraint solving using unificaiton. All the functions require relatively little code ranging from 5 to 25 lines. If any function requires more than that, you can be sure that you need to rethink your solution. The file contains several core OCaml functions, with missing bodies, i.e. expressions, which currently contain the text failwith "to be written" . Your task is to replace the text in those files with the the appropriate OCaml code for each of those expressions.

Note: The assignment is in the files `infer.ml`(bonus point) and `unify.ml`(basic point). The entry point is `repl.ml`. Please do NOT modify other files.

It is a good idea to start this assignment early.


#### `unify`: unify a list of constraints 
```
unify (s : (typ * typ) list) : substitution =
(* to be written *)
```


#### `annotate`: annotate all subexpressions with types.
```
let annotate (e : expr) : aexpr =
(* to be written BONUS! *)
```

#### `collect`: collect constraints for unification
```
let rec collect (aexprs : aexpr list) (u : (typ * typ) list) : (typ * typ) list =
(* to be written BONUS! *)
```

#### `infer`: top-level entry of HM algorithm
```
let infer (e : expr) : typ =
  reset_type_vars();
(* to be written *)
```

#### Bonus: you will receive a 50% extra score for completing the functions that contains `BONUS`. If you don't want to work on the bonus points, you can just fill in the functions in `hw4_basic`.

#### How to compile and execute the project?

To start with the basic points, enter the `hw4_basic` folder, implement the missing functions, and issue the following command to compile and run:

```
make
./repl.o
```

If you are shooting for the bonus points, enter the `hw4_bonus` folder instead and implement the missing functions (you can reuse your implementation in the `hw4_basic` folder). Then issue the same command to compile and run. 

If your implementation is correct, you shall see the following output (one line for each test case; see `repl.ml` for input and output for each test case):

```
fun x -> x : 'a -> 'a
fun x -> fun y -> fun z -> x z (y z) : ('c -> 'e -> 'd) -> ('c -> 'e) -> 'c -> 'd
fun x -> fun y -> x : 'a -> 'b -> 'a
fun f -> fun g -> fun x -> f (g x) : ('e -> 'd) -> ('c -> 'e) -> 'c -> 'd
(fun x -> x) y : 'b
x : 'a
(fun x -> x) (fun y -> y) : 'b -> 'b
(fun x -> x) (fun x -> x) : 'b -> 'b
fun x -> (fun x -> x) x : 'a -> 'a
fun x -> fun y -> (fun x -> x) y : 'a -> 'b -> 'b
fun x -> fun x -> fun x -> x : 'a -> 'b -> 'c -> 'c
(fun x -> fun x -> fun x -> x) x y z : 'b
x (fun x -> x) : 'a
x (fun x -> (fun y -> y) x) : 'a
Fatal error: exception Failure("not unifiable: circularity")
```

You can use any built-in APIs from OCaml. Also, a quick start guide can be found [here](https://github.com/fredfeng/CS162/blob/master/sessions/CS162_Section_6.pdf)

Happy hacking!

Yu
