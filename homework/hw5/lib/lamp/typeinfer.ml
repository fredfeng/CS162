open Base
open Ast

exception Type_error of string

(** Raise a type error with the given message *)
let ty_err msg = raise (Type_error msg)

(* Placeholders *)
let part1 () = failwith "TODO: Part 1"
let part2 () = failwith "TODO: Part 2"
let part3 () = failwith "TODO: Part 3"
let parts2and3 () = failwith "TODO: Parts 2 and 3"
let part4 () = failwith "TODO: Part 4"

(**********************************************
  *         Typing Environment (Gamma)        *
  *********************************************)
type gamma = (string * pty) list [@@deriving eq, ord, show]
(** Gamma is the type environment that maps variables to types *)

let uncurry f (x, y) = f x y

(** Pretty-printer for gamma *)
let pp_gamma : gamma Fmt.t =
  let open Fmt in
  let pp_pair = hbox (pair ~sep:(any " : ") string Pretty.pp_pty) in
  vbox
  @@ iter_bindings ~sep:comma (fun f l -> List.iter ~f:(uncurry f) l) pp_pair

let show_gamma : gamma -> string = Fmt.to_to_string pp_gamma

(** Find the type of a variable in gamma *)
let find : gamma -> string -> pty option = List.Assoc.find ~equal:String.equal

(** Add a (var, type) pair to gamma *)
let add : gamma -> string -> pty -> gamma = List.Assoc.add ~equal:String.equal

(*******************************************
 *         Type Equality Constraints       *
 *******************************************)
type cons = ty * ty [@@deriving eq, ord, show]
(** A constraint is a pair (t1,t2) that asserts t1 = t2 *)

(** Pretty-printer for cons *)
let pp_cons : cons Fmt.t =
 fun ppf (t1, t2) -> Fmt.pf ppf "%a == %a" Pretty.pp_ty t1 Pretty.pp_ty t2

(*******************************************
 *         Type Substitution (Sigma)       *
 *******************************************)
type sigma = (string * ty) list [@@deriving eq, ord, show]
(** The solution to a list of type equations is 
   * a substitution [sigma] from type variables to types *)

(** Pretty-printer for sigma *)
let pp_sigma : sigma Fmt.t =
  let open Fmt in
  let pp_pair = hbox (pair ~sep:(any " |-> ") string Pretty.pp_ty) in
  iter_bindings (fun f l -> List.iter ~f:(uncurry f) l) pp_pair

let show_sigma : sigma -> string = Fmt.to_to_string pp_sigma

(** The empty solution *)
let empty : sigma = []

(** Compose the substitution [x |-> t] to the given [sigma] *)
let compose (x : string) (t : ty) (s : sigma) : sigma = (x, t) :: s

(*******************************************
 *         Type Inference Utils            *
 *******************************************)
module Utils = struct
  (** Substitute type variable [x] with type [t] in [ty] context [c] *)
  let rec subst (x : string) (t : ty) (c : ty) : ty = part2 ()

  (** Compute the free variable set of an [ty] *)
  let rec free_vars (t : ty) : Vars.t = part2 ()

  (** Apply a sigma [s] to type [t] by performing all substitutions in [s] *)
  let apply_sigma (s : sigma) (t : ty) : ty = part2 ()

  (** Relabel bound type variables in increasing (or decreasing) order *)
  let normalize (pass : bool) (t : ty) : ty =
    let xs = free_vars t in
    let s =
      List.mapi
        (Vars.to_list xs |> List.sort ~compare:String.compare)
        ~f:(fun i x ->
          let y = "'t" ^ Int.to_string (if pass then -i - 1 else i + 1) in
          (x, TVar y))
    in
    apply_sigma s t

  let normalize p = p |> normalize true |> normalize false
end

(*******************************************
 *        Type Inference Engine            *  
 *******************************************)
module Infer (Flag : sig
  val polymorphic : bool
  (** flag that enables let-polymorphism *)
end) =
struct
  (***************************************************
   *         Constraint Accumulation Helpers         *
   ***************************************************)
  (** The list of accumulated constraints *)
  let _cs : cons list ref = ref []

  (** Add a constraint to the accumulator. Call it with [t1 === t2]. *)
  let ( === ) (t1 : ty) (t2 : ty) : unit =
    (* If you prefer the "printf" school of debugging, uncomment the following line,
       BUT DON'T FORGET TO REMOVE IT BEFORE YOU SUBMIT *)
    (* Fmt.epr "[constraint] %a\n%!" pp_cons (t1, t2); *)
    _cs := (t1, t2) :: !_cs

  (** Return the current list of constraints *)
  let curr_cons_list () : cons list = !_cs

  (******************************************
   *         Fresh Variable Helpers         *
   ******************************************)

  (** Counter to produce fresh variables *)
  let var_counter = ref 1

  (** Type string *)
  let ty_str_of_int (i : int) : string = "'X" ^ Int.to_string i

  (** Return the current var counter and increment it  *)
  let incr () =
    let v = !var_counter in
    var_counter := v + 1;
    v

  (** Generate a fresh string. For internal use only. *)
  let fresh_var_str () : string = ty_str_of_int (incr ())

  (** Generate a fresh [ty] type variable. Call it using [fresh_var ()]. *)
  let fresh_var () : ty = TVar (fresh_var_str ())

  (**************************************************
   *         Generalization/Instantiation           *
   **************************************************)

  (** Generalize a monomorphic type to a polymorphic type *)
  let generalize (gamma : gamma) (t : ty) : pty = part4 ()

  (** Instantiate a polymorphic type by replacing
  * quantified type variables with fresh type variables *)
  let instantiate (t : pty) : ty = part4 ()

  (*******************************************
   *         Constraint Generation           *
   *******************************************)

  (** Abstractly evaluate an expression to a type.
    * This function also generates constraints and accumulates them into 
    * the list [cs] whenever you call [t1 === t2]. *)
  let rec abstract_eval (gamma : gamma) (e : expr) : ty =
    (* The following line loads functions in DSL module, allowing you to write
       [int -> (bool * ??"'X")] instead of [TFun (TInt, TProd (TBool, TVar "'X"))].
       However, you don't have to use the DSL functions, and you can just
       call the appropriate [ty] constructors. *)
    let open DSL in
    (* If you prefer the "printf" school of debugging, uncomment the following line,
       BUT DON'T FORGET TO COMMENT IT OUT BEFORE YOU SUBMIT *)
    (* Fmt.epr "[abstract_eval] %a\n%!" Ast.Pretty.pp_expr e; *)
    (* Fmt.epr "[abstract_eval] Gamma:\n%!  %a\n%!" pp_gamma gamma; *)
    try
      match e with
      | Num _ -> TInt
      | True | False -> TBool
      | Var x -> if Flag.polymorphic then part4 () else part1 ()
      | Binop (_, e1, e2) ->
          let t1 = abstract_eval gamma e1 in
          let t2 = abstract_eval gamma e2 in
          (* constrain both t1 and t2 to be int type *)
          t1 === TInt;
          t2 === TInt;
          (* return int as the type of the overal binop expression *)
          TInt
      | Comp (_, e1, e2) -> part1 ()
      | IfThenElse (e1, e2, e3) -> part1 ()
      | Let (e1, Scope (x, e2)) ->
          if Flag.polymorphic then part4 () else part1 ()
      | Lambda (topt, Scope (x, e')) -> part1 ()
      | App (e1, e2) -> part1 ()
      | ListNil topt -> part1 ()
      | ListCons (e1, e2) -> part1 ()
      | ListMatch (e1, e2, Scope (x, Scope (y, e3))) -> part1 ()
      | Fix (topt, Scope (f, e1)) -> part1 ()
      | Annot (e, t_expected) ->
          let t_actual = abstract_eval gamma e in
          (* constrain t_actual to be equal to t_expected *)
          t_actual === t_expected;
          t_expected
      | Pair (e1, e2) -> part3 ()
      | Fst e' -> part3 ()
      | Snd e' -> part3 ()
      | _ -> ty_err ("[abstract_eval] ill-formed: " ^ show_expr e)
    with Type_error msg -> ty_err (msg ^ "\nin expression " ^ show_expr e)

  (*******************************************
   *           Constraint Solving            *
   *******************************************)

  (** Constraint solver = unification/forward substitution from the empty solution, then backward substitution *)
  and solve (cs : cons list) : sigma =
    let sigma = unify empty cs in
    backward sigma

  (** Unification (aka forward substitution) phase of the constraint solver *)
  and unify (s : sigma) (cs : cons list) : sigma =
    match cs with [] -> s | (t1, t2) :: cs' -> parts2and3 ()

  (** Backward substitution phase of the constraint solver *)
  and backward (s : sigma) : sigma = part2 ()
end

(*******************************************
 *             Type inference              *
 *******************************************)

(** Infer the type of expression [e] in the environment [g].
  * The flag [p] optionally enables polymorphic type inference *)
let infer_with_gamma ~(gamma : gamma) ~(p : bool) (e : expr) : ty =
  let module I = Infer (struct
    let polymorphic = p
  end) in
  let open I in
  let t = abstract_eval gamma e in
  let s = solve (I.curr_cons_list ()) in
  Utils.apply_sigma s t |> Utils.normalize

(** Infer the type of expression [e]. 
  * The flag [p] optionally enables polymorphic type inference *)
let infer ~(p : bool) (e : expr) : ty = infer_with_gamma ~gamma:[] ~p e
