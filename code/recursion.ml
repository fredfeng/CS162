type tree = 
  Leaf of int 
| Node of tree*tree;;


Node(Node(Leaf 1, Leaf 2), Leaf 3);;


let rec sum_leaf t = 
    match t with 
    | Leaf n -> n 
    | Node(t1,t2) -> (sum_leaf t1) + (sum_leaf t2);;


sum_leaf (Node(Node(Leaf 1, Leaf 2), Leaf 3));;

let rec fact n = 
    if n<=0
    then 1 
    else n * fact (n-1);;

fact 3;;

let fact2 x = 
  let rec helper x curr =                                                       
     if x <= 0 
     then curr 
     else helper (x - 1) (x * curr) 
  in 
     helper x 1;;

fact2 3;;


