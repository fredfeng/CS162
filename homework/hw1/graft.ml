
type 'a tree = Leaf of 'a | Node of 'a * 'a tree * 'a tree

let rec graft (t: 'a tree) (t': 'a tree) : 'a tree =
  failwith "Your code here"
