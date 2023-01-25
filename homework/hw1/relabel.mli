type 'a tree = Leaf of 'a | Node of 'a * 'a tree * 'a tree

val relabel : 'a tree -> int tree