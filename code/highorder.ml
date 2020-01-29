let max x y = if x < y then y else x;; 

(* return max element of list l *) 
let list_max l =
   let rec l_max l = 
      match l with 
        [] -> 0
       | h::t -> max h (l_max t) 	
   in
      l_max l;;


let list_max2 l =
   let rec helper cur l = 
      match l with 
        [] -> cur
       | h::t -> helper (max cur h) t 	
   in
      helper 0 l;;


(* concatenate all strings in a list *) 
let concat l = 
   let rec helper cur l = 
      match l with 
        [] -> cur 
       | h::t -> helper (cur ^ h) t
   in 
      helper "" l;;

(* fold, the coolest function! *) 
let rec fold f cur l = 
   match l with 
     [] -> cur 
     | h::t -> fold f (f cur h) t;;

let list_max = fold max 0 [1;2;3];;

let concat = fold (^) "" ["a";"b";"c"];;


let rec map f l = 
    match l with
    [] -> []
    | h::t -> (f h)::(map f t);;


let incr x = x+1;;

let map_incr = map incr;;

map_incr [1;2;3];;

let compose f1 f2 = fun x -> (f1 (f2 x));; 

let map_incr_2 = compose map_incr map_incr;;
map_incr_2 [1;2;3];;

let map_incr_3 = compose map_incr map_incr_2;;
map_incr_3 [1;2;3];;
