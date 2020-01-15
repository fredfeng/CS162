# Programming Assignment #1


The overall objective of this assignment is for you to gain some hands-on experience with OCaml. All the problems require relatively little code ranging from 2 to 15 lines. If any function requires more than that, you can be sure that you need to rethink your solution. The assignment is in the files numOps.ml, and listOps.ml that you need to download. The file contains several skeleton OCaml functions, with missing bodies, i.e. expressions, which currently contain the text failwith "to be written" . Your task is to replace the text in those files with the the appropriate OCaml code for each of those expressions.

Note: All the solutions can be done using the purely functional fragment of OCaml, using constructs covered in class, and most require the use of recursion. Solutions using imperative features such as references, while loops or library functions will receive no credit.

It is a good idea to start this assignment early.

## Problem #1: Digital Roots and Additive Persistence (numOps.ml)
(a) 10 points
Now write an OCaml function sumList : int list -> int that takes an integer list l and returns the sum of the elements of l . Once you have implemented the function, you should get the following behavior at the OCaml prompt:
```
# sumList [];;
- : int = 0
# sumList [1;2;3;4];;
- : int = 10
# sumList [1;-2;3;5];;
- : int = 7
# sumList [1;3;5;7;9;11];;
- : int = 36
```
(b) 10 points
Write an OCaml function fibonacci : int -> int that takes an integer n as an argument and returns the fibonacci number of n:
```
# fibonacci 10;;
- : int = 55
# fibonacci 8;;
- : int = 21
```

## Problem #2: List manipulation (listOps.ml)
(a) 10 points
Without using any built-in OCaml functions, write an OCaml function Duplicate the elements of a list. (easy)
Duplicate : 'a list -> 'a list that duplicates the elements of a list l. Once you have implemented the function, you should get the following behavior at the OCaml prompt:
```
# duplicate ["a";"b";"c";"c";"d"];;
- : string list = ["a"; "a"; "b"; "b"; "c"; "c"; "c"; "c"; "d"; "d"];;
```


(b) 10 points
A palindrome is a word that reads the same from left-to-right and right-to-left. Write an OCaml function palindrome : string -> bool that takes a string w and returns true if the string is a palindrome and false otherwise. Your function should be case sensitie. You may want to use the OCaml function explode . (Hint: You may call your listReverse function from your palindrome function.) Once you have implemented the function, you should get the following behavior at the OCaml prompt:
```
# palindrome "malayalam";;
- : bool = true
# palindrome "Malayalam";;
- : bool = false
# palindrome "myxomatosis";;
- : bool = false
# palindrome "";;
- : bool = true
```

Tip: To solve this problem, you might first want to write a function listReverse : 'a list -> 'a list that takes a list l as an argument and returns a list of the elements of l in the reversed order:
```
# listReverse [];;
- : int list = []
# listReverse [1;2;3;4];;
- : int list = [4;3;2;1]
# listReverse ["a";"b";"c";"d"];;
- : string list = ["d";"c";"b";"a"]
```
