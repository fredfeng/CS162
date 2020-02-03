let x = 1;; 
let f y = x + y;; 
let x = 2;; 
let y = 3;; 
f (x + y);;



let x = 1;; 
let f y = 
  let x = 2 in 
  fun z -> x + y + z 
;; 

let x = 100;; 
let g = (f 4);; 
let y = 100;; 
(g 1);;
