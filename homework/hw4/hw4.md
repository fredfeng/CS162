# Programming Assignment #4


The overall objective of this assignment is for you to get a deep understanding on Hindley–Milner type inference. In particular, constraint generation using typing rules and constraint solving using unificaiton. All the functions require relatively little code ranging from 5 to 25 lines. If any function requires more than that, you can be sure that you need to rethink your solution. The file contains several core OCaml functions, with missing bodies, i.e. expressions, which currently contain the text failwith "to be written" . Your task is to replace the text in those files with the the appropriate OCaml code for each of those expressions.

Note: The assignment is in the files infer.ml and unify.ml. Please do NOT modify other files.

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

#### How to compile and execute the project?
```
make
./infer.exe

fun x -> x : 'a -> 'a
fun x -> fun y -> fun z -> x z (y z) : ('c -> 'e -> 'd) -> ('c -> 'e) -> 'c -> 'd
fun x -> fun y -> x : 'a -> 'b -> 'a
fun f -> fun g -> fun x -> f (g x) : ('e -> 'd) -> ('c -> 'e) -> 'c -> 'd
Fatal error: exception Failure("not unifiable: circularity")

```


You can use any built-in APIs from OCaml. 

#### Bonus: you will receive 50% extra scores for completing the functions that contains `BONUS`. If you don't want to work on the bonus points, please contact TA for the reference implementation.

Happy hacking!

Yu
