open Ast

exception Type_error = Typecheck.Type_error ;;
let ty_err = Typecheck.ty_err ;;

(** Type AST used for type inference *)
type ityp =
  | (* Integer type *)
    IInt
  | (* Function type *)
    IFun of ityp * ityp
  | (* List type *)
    IList of ityp
  | (* Type variable *)
    IVar of int

(** Converts a typ into an ityp *)
let rec ityp_of_typ = function
  | TInt -> IInt
  | TFun (t1, t2) -> IFun (ityp_of_typ t1, ityp_of_typ t2)
  | TList t -> IList (ityp_of_typ t)

(** Converts an ityp to a string *)
let rec string_of_ityp : ityp -> string =
  let is_complex = function
    | IFun _ -> true
    | _ -> false
  in
  let pp_nested t =
    let s = string_of_ityp t in if is_complex t then "(" ^ s ^ ")" else s
  in
  function
  | IVar i -> Format.sprintf "X%d" i
  | IInt -> "Int"
  | IFun (t1, t2) -> pp_nested t1 ^ " -> " ^ string_of_ityp t2
  | IList t -> Format.sprintf "List[%s]" (pp_nested t)

(** Typing environment module *)
module Env = Map.Make (String) ;;
type env = ityp Env.t

(** Type inference context. Tracks the typing environment, the generated
   constraints, and a counter for fresh variables.*)
module Context = struct
  type t = Context of env * (ityp * ityp) list * int

  (** The empty type inference context *)
  let empty = Context (Env.empty, [], 0)

  (** Returns the typing environment *)
  let env (Context (e, _, _)) = e

  (** Returns the list of constraints *)
  let cons (Context (_, c, _)) = c

  (** Return the next fresh variable (number) and the updated context *)
  let mk_fresh_var (Context (e, c, i)) = (i, Context (e, c, i + 1))

  (** Modify the environment with the given function, returning the updated context *)
  let modify_env f (Context (e, c, i)) = Context (f e, c, i)

  (** Add the equation t1 = t2 to the context, returning the updated context *)
  let add_eqn t1 t2 (Context (e, c, i)) = Context (e, (t1, t2) :: c, i)
end

(** Generate constraints for type inference. Returns the type (or type variable) *)
let rec gen_cons (ctx : Context.t) (e : expr) : ityp * Context.t =
  try
    match e with
    | (* CT-Int *)
      NumLit _ -> (IInt, ctx)
    | (* CT-Var *)
      Var x -> begin match Env.find_opt x (Context.env ctx) with
        | Some t -> (t, ctx)
        | None -> ty_err ("Unbound variable " ^ x)
      end
    | (* CT-Arith, CT-Ineq *)
      Binop (e1, (Add | Sub | Mul | Gt | Lt | And | Or), e2) ->
      let (t1, ctx1) = gen_cons ctx e1 in
      let (t2, ctx2) = gen_cons ctx1 e2 in
      let ctx3 = ctx2 |> Context.add_eqn t1 IInt
                 |> Context.add_eqn t2 IInt
      in
      (IInt, ctx3)
    | _ -> failwith "TODO: hw5"
  with
  | Type_error msg -> ty_err (msg ^ "\nin expression " ^ string_of_expr e)

(** Module for type variable substitution *)
module Sub = Map.Make (Int)
type sub = ityp Sub.t

(** Module for set of integers *)
module IntSet = Set.Make (Int)

(** Find free type variables in a given type *)
let rec free_vars = function
  | IVar i -> IntSet.singleton i
  | IInt -> IntSet.empty
  | IList t -> free_vars t
  | IFun (t1, t2) -> IntSet.union (free_vars t1) (free_vars t2)

(** Apply the type substitution to the given type. *)
let rec sub_ityp sub = function
  | IInt -> IInt
  | IVar i -> begin match Sub.find_opt i sub with
      | None -> IVar i
      | Some t -> t
    end
  | IList t' -> IList (sub_ityp sub t')
  | IFun (t1, t2) -> IFun (sub_ityp sub t1, sub_ityp sub t2)

(** Apply the type substitution to each constraint in the given list of
   constraints. *)
let sub_cons sub cons =
  List.map (fun (t1, t2) -> (sub_ityp sub t1, sub_ityp sub t2)) cons

(** Unification algorithm that computes a type substitution that solves the
   constraints, or raises a Type_error if there is no solution. *)
let rec unify (cons : (ityp * ityp) list) : sub = failwith "TODO: hw5"

(** Hindley-Milner type inference *)
let type_infer (e : expr) : ityp * sub =
  let (ty, ctx) = gen_cons Context.empty e in
  (*
  Format.printf "Generated constraints:\n%!";
  List.iter (fun (t1, t2) -> Format.printf "%s = %s\n%!" (string_of_ityp t1) (string_of_ityp t2))
    (Context.cons ctx) ;
  *)
  let sub = unify (Context.cons ctx) in
  (*
  Format.printf "Computed substitution:\n%!";
  List.iter (fun (i, t) -> Format.printf "%d => %s\n%!" i (string_of_ityp t))
    (Sub.bindings sub) ;
  *)
  let bound_vars = List.map fst (Sub.bindings sub) in
  (* Replaces all type variables in the inferred type with concrete types,
     allowing only "free" type variables. This works by substituting type
     variables until a fixed point is reached (which is guaranteed since the
     occurs check ensures that the solution graph is a DAG). *)
  let rec apply_sub ty' =
    let ty_vars = free_vars ty' in
    if IntSet.is_empty (IntSet.inter ty_vars (IntSet.of_list bound_vars))
    then ty'
    else apply_sub (sub_ityp sub ty')
  in
  (apply_sub ty, sub)
