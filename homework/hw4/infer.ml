(******************************************
 * Type inference for simple lambda terms *
 ******************************************)

open Ast

let code = ref (Char.code 'a')

let reset_type_vars() = code := Char.code 'a'

let next_type_var() : typ =
  let c = !code in
  if c > Char.code 'z' then failwith "too many type variables";
  incr code;
  TVar (String.make 1 (Char.chr c))

let type_of (ae : aexpr) : typ =
  match ae with
    AVar (_, a) -> a
  | AFun (_, _, a) -> a
  | AApp (_, _, a) -> a
  
(* annotate all subexpressions with types *)
(* bv = stack of bound variables for which current expression is in scope *)
(* fv = hashtable of known free variables *)
let annotate (e : expr) : aexpr =
(* to be written BONUS! *)

(* collect constraints for unification *)
let rec collect (aexprs : aexpr list) (u : (typ * typ) list) : (typ * typ) list =
(* to be written BONUS! *)

(* top-level entry of HM algorithm *)
let infer (e : expr) : typ =
  reset_type_vars();
(* to be written *)
