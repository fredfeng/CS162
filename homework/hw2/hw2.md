# Programming Assignment #2


The overall objective of this assignment is for you to get a deep understanding on lambda calculus. In particular, alpha-renaming and beta-reduction. All the functions require relatively little code ranging from 5 to 25 lines. If any function requires more than that, you can be sure that you need to rethink your solution. The file contains several core OCaml functions, with missing bodies, i.e. expressions, which currently contain the text failwith "to be written" . Your task is to replace the text in those files with the the appropriate OCaml code for each of those expressions.

Note: The assignment is in the file eval.ml and please do NOT modify other files.

It is a good idea to start this assignment early.


#### `fvs`: computes the free (non-bound) variables in e.
```
let rec fvs e =
(* to be written *)
```

#### `subst`: substitution: subst e y m means 
"substitute occurrences of variable y with m in the expression e"
```
let rec subst e y m =
(* to be written *)
```


#### `reduce`: beta reduction.
```
let rec reduce e =
(* to be written *)
```

Happy hacking!

Yu
