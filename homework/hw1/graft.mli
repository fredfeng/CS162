type 'a tree = Leaf of 'a | Node of 'a * 'a tree * 'a tree

val graft: 'a tree -> 'a tree -> 'a tree
