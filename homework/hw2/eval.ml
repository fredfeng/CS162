(*
type var = string

type exp =
    Var of var
  | Lam of var * exp
  | App of exp * exp
 *)
(*open Exp;;*)

     
(* generates a fresh variable name *)
let newvar =
  let x = ref 0 in
  fun () -> 
    let c = !x in
    incr x;
    "v"^(string_of_int c)

(* computes the free (non-bound) variables in e *)
let rec fvs e =
(* to be written *)


(* substitution: subst e y m means 
  "substitute occurrences of variable y with m in the expression e" *)
let rec subst e y m =
(* to be written *)



(* beta reduction. *)
let rec reduce e =
(* to be written *)



(* pretty printing *)

open Format;;

let ident = print_string;;
let kwd = print_string;;

let rec print_exp0 = function
  | Var s ->  ident s
  | lam -> open_hovbox 1; kwd "("; print_lambda lam; kwd ")"; close_box ()

and print_app = function
  | e -> open_hovbox 2; print_other_applications e; close_box ()

and print_other_applications f =
  match f with
  | App (f, arg) -> print_app f; print_space (); print_exp0 arg
  | f -> print_exp0 f

and print_lambda = function
  | Lam (s, lam) ->
      open_hovbox 1;
      kwd "\\"; ident s; kwd "."; print_space(); print_lambda lam;
      close_box()
      
  | e -> print_app e;;


let rec lambda_exp_2_str e =
  match e with
      Var x ->"Var "^x 
    | App (e1,e2) -> "App(" ^ lambda_exp_2_str e1 ^ "," ^ lambda_exp_2_str e2 ^ ")"
    | Lam (x,e) ->"Lam(" ^ x ^  "," ^ lambda_exp_2_str e ^ ")"
;;

        
let next =
  let count = ref 0  in
  function () ->
    count := !count +1; !count
;;

(* Fix-point computation. *)
let rec evaluate x  =
  let old1 = x in
  let new1 = reduce x  in
  if old1 = new1 then old1 else (evaluate new1)
;;
