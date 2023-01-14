type 'a tree = Leaf of 'a | Node of 'a * 'a tree * 'a tree

let rec relabel (t: 'a tree) : int tree =
  failwith "Your code here"