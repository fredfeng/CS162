# Programming Assignment #5

You have to implement all solutions in Racket.

## Flatten a list (5 points)

Write a function to flatten the nesting in an arbitrary list of values.
Your program should work on the equivalent of this list:
```
  [[1], 2, [[3, 4], 5], [[[]]], [[[6]]], 7, 8, []]
```

Where the correct result would be the list:

```
   [1, 2, 3, 4, 5, 6, 7, 8]
```

## Cartesian product of two lists (5 points)

Write a function that generates the Cartesian product of two arbitrary lists in Racket.
Demonstrate that your function/method correctly returns:

```
{1, 2} × {3, 4} = {(1, 3), (1, 4), (2, 3), (2, 4)}
```

and, in contrast:

```
{3, 4} × {1, 2} = {(3, 1), (3, 2), (4, 1), (4, 2)}
```

Also demonstrate, using your function/method, that the product of an empty list with any other list is empty.

```
{1, 2} × {} = {}
{} × {1, 2} = {}
```

## Zig-zag matrix (5 points)


A zig-zag array is a square arrangement of the first N^2 natural numbers, where the numbers increase sequentially as you zig-zag along the array's [anti-diagonals](https://en.wiktionary.org/wiki/antidiagonal).
For example, given 5, produce this array:

```
 0  1  5  6 14
 2  4  7 13 15
 3  8 12 16 21
 9 11 17 20 22
10 18 19 23 24
```

## Caesar cipher (5 points)

Implement a [Caesar cipher](https://en.wikipedia.org/wiki/Caesar_cipher), both encoding and decoding.
The key is an integer from 1 to 25.

This cipher rotates the letters of the alphabet (A to Z).

The encoding replaces each letter with the 1st to 25th next letter in the alphabet (wrapping Z to A).
So key 2 encrypts "HI" to "JK", but key 20 encrypts "HI" to "BC".


```
> (define s (encrypt 1 "The five boxing wizards jump quickly."))
> s
"Uif gjwf cpyjoh xjabset kvnq rvjdlmz."
> (decrypt 1 s)
"The five boxing wizards jump quickly."
```

## A verifier for superoptimization (25 points)

- Install [Racket](http://racket-lang.org) and [Rosette](https://github.com/emina/rosette#installing-rosette).

- Check out the problem description in [here](verify.pdf).

- The `bvv` directory contains the solution skeleton for this problem:
  - See [examples.rkt](bvv/examples.rkt) for a quick tour of the types and procedures to use in your implementation.
  - See [tests.rkt](bvv/tests.rkt) for a suite of initial tests for your verifier. We will also test your code on additional benchmarks that are not included here.  To make sure that your verifier works correctly, you will need to write your own tests, eespecially for corner cases.
  - Your implementation must be **entirely contained** in your copy of [verifier.rkt](bvv/verifier.rkt).  This is the only file that you are going to submit.  You may not change any of the interfaces or the supporting code that we provide.  In particular, we must be able to run your code simply by placing your [verifier.rkt](bvv/verifier.rkt) file into our copy of the `hw/hw5/bvv` directory.

  
## Automated verification of systems code with Serval

- This is an extra question with 15 bonus points

- Read the Serval [paper](https://unsat.cs.washington.edu/papers/nelson-serval.pdf) at SOSP'19

- Go over Serval [tutorial](https://github.com/uw-unsat/serval-tutorial-sosp19)

- Install Serval from source and reproduce the result in Figure 11 in the original paper.



