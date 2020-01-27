# Programming Assignment #3


The overall objective of this assignment is for you to gain some hands-on experience with OCaml. All the problems require relatively little code ranging from 2 to 15 lines. If any function requires more than that, you can be sure that you need to rethink your solution. The assignment is in the file hw3.ml that you need to download. The file contains several skeleton OCaml functions, with missing bodies, i.e. expressions, which currently contain the text failwith "to be written" . Your task is to replace the text in those files with the the appropriate OCaml code for each of those expressions.

Note: All the solutions can be done using the purely functional fragment of OCaml, using constructs covered in class, and most require the use of recursion. Solutions using imperative features such as references, while loops will receive no credit.

It is a good idea to start this assignment early.

1. Problem #1 (5 points): Now write an OCaml function interval : int int -> list that takes two integers i and j, and returns a list that contains the integers i through j inclusive. Once you have implemented the function, you should get the following behavior at the OCaml prompt:
```
# interval 3 2;;
- : int list = []
# interval 1 4;;
- : int list = [1;2;3;4]
```
2. Problem #2 (5 points): Use *tail-recursion* to write an OCaml function length : list -> int that computes the number of elements in the list:
```
# length [];;
- : int = 0
# length [1;2;3;4];;
- : int = 4
```

3. Problem #3 (10 points): 
Without using any built-in OCaml functions, write an OCaml function 
compress : 'a list -> 'a list that eliminates consecutive duplicates of list elements:
```
# compress ["a";"a";"a";"a";"b";"c";"c";"a";"a";"d";"e";"e";"e";"e"];;
- : string list = ["a"; "b"; "c"; "a"; "d"; "e"]
```


4. Problem #4 (10 points):
Goldbach's conjecture says that every positive even number greater than 2 is the sum of two prime numbers. Example: 28 = 5 + 23. It is one of the most famous facts in number theory that has not been proved to be correct in the general case. It has been numerically confirmed up to very large numbers. Write a function to find the two prime numbers that sum up to a given even integer (you can assume the input number is valid. I.e., even number greater than 2.):
```
# goldbach 28;;
- : int * int = (5, 23)
goldbach 10;;
- : int * int = (3, 7)
```

Tip: You may use the auxilirary function 'is_prime'.

5. Problem #5 (10 points)
A binary tree is either empty or it is composed of a root element and two successors, which are binary trees themselves.
```
# type 'a binary_tree =
    | Empty
    | Node of 'a * 'a binary_tree * 'a binary_tree;;
type 'a binary_tree = Empty | Node of 'a * 'a binary_tree * 'a binary_tree
```
Let us call a binary tree symmetric if you can draw a vertical line through the root node and then the right subtree is the mirror image of the left subtree. Write a function is_symmetric to check whether a given binary tree is symmetric.

Hint: We are only interested in the structure, not in the contents of the nodes.
```
let t1 =
    Node('b', Node('d', Node('e', Empty, Empty), Empty), Node('e', Empty, Empty));;
               
let t2 =
    Node('b', Node('d', Empty, Empty), Node('e', Empty, Empty));;
         
is_symmetric t1;;
- : bool = false

is_symmetric t2;;
- : bool = true
```

6. Problem #6 (10 points)
N-Queen Problem: Return *all solutions* of an N-Queen problem. This is a classical problem in computer science. The objective is to place N queens on an N * N chessboard so that no two queens are attacking each other; i.e., no two queens are in the same row, the same column, or on the same diagonal.

Hint: Represent the positions of the queens as a list of numbers 1..N. Example: [4;2;7;3;6;8;5;1] means that the queen in the first column is in row 4, the queen in the second column is in row 2, etc. 
```
# queens_positions 4;;
- : int list list = [[3; 1; 4; 2]; [2; 4; 1; 3]]
# List.length (queens_positions 8);;
- : int = 92
```
