
type 'a tree = Leaf of 'a | Node of 'a * 'a tree * 'a tree

let rec paths (t: 'a tree) : 'a list list =
  failwith "Your code here"