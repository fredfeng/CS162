(* DataTypes *)


type attrib =
  | Name    of string
  | Age     of int
  | DOB     of int * int * int
  | Address of string
  | Height  of float 
  | Alive   of bool
  | Email   of string
;;

let a1 = Name "Bob";;

let a2 = Height 5.83;;

let year = 1977 ;;

let a3 = DOB (9,8,year) ;;

let a_l = [a1;a2;a3];;






let a1 = (Alive false);;
let a1 = (Name "Bob");;
let a1 = (Age 11);;
match a1 with
| Name s -> 0
| Age i -> i
| _ -> 10;;




match (Name "Hi") with
| Name s -> (Printf.printf "Hello %s\n" s;0)
| Age i  -> (Printf.printf "%d years old\n" i;0)
| _ -> (Printf.printf "\n"; 0)
;;





match (Age 10) with
  | Age i when i < 10 -> Printf.sprintf "%d (young)" i
  | Age i -> Printf.sprintf "%d (older)" i
  | Email s -> Printf.sprintf "%s" s
  | _ -> ""
;;                


let to_str a = 
  match a with 
  | Name s -> s
  | Age i -> Printf.sprintf "%d" i
  | DOB (d,m,y) -> Printf.sprintf "%d / %d / %d" d m y 
  | Address addr -> Printf.sprintf "%s" addr
  | Height h -> Printf.sprintf "%f" h 
  | Alive b -> Printf.sprintf "%b" b
  | Email e -> Printf.sprintf "%s" e
;;



type nat = 
  | Z 
  | S of nat;;




Z;; (* represents 0 *)
S Z;; (* represents 1 *)
S S Z;; (* represents 2 *)
S (S Z);; (* represents 2 *)






let rec plus n m = 
  match n with
    | Z    -> m
    | S n' -> S (plus n' m);;



plus (S (S Z)) (S Z);;






type int_list = 
  | Nil 
  | Cons of (int * int_list) ;;


let l = Cons (10, Cons (10, Cons (10, Nil)));;


let rec length l = 
   match l with
   | Nil -> 0
   | Cons (i,t) -> 1 + length t;;

let rec length l =
   match l with
   | [] -> 0
   | h::t -> 1+length t;;


let max x y = if x > y then x else y;;




let rec list_max xs = 
  match xs with
    | Nil           -> 0
    | Cons (x, xs') -> max x (list_max xs');;

let rec list_max xs = 
  match xs with
    | []           -> 0
    | x::xs' -> max x (list_max xs');;