open Base
open Ast

(** Boolean formulas *)
type prop =
  | Var of string  (** Propositional variable *)
  | True  (** True *)
  | And of prop * prop  (** Conjunction *)
  | Imply of prop * prop  (** Implication *)

(** Pretty-printing of propositions *)
let rec pp_prop : prop Fmt.t =
 fun ppf -> function
  | Var x -> Fmt.string ppf x
  | True -> Fmt.string ppf "true"
  | And (p, q) -> Fmt.pf ppf "(%a /\\ %a)" pp_prop p pp_prop q
  | Imply (p, q) -> Fmt.pf ppf "(%a => %a)" pp_prop p pp_prop q

(** Convert a type to a boolean proposition *)
let rec curry_howard (t : ty) : prop =
  let todo () = failwith "TODO" in
  match t with
  | TInt | TBool -> True
  | TVar x -> todo ()
  | TProd (t1, t2) -> todo ()
  | TFun (t1, t2) -> todo ()
  | TList _ -> failwith "curry_howard: list type not supported"

module Examples = struct
  let todo = Some "todo"

  (* On the right-hand-sides, write down lambda-plus expressions in concrete syntax
     that have the specified types. You do not need to include type annotation.
     If the no expression has that type, write `None`.

     Example:
       (* 0. `duplicate: 'a -> 'a * 'a` *)
       let duplicate = Some "lambda x. {x, x}"
  *)

  (* 1. `everything: 'p` *)
  let everything = todo

  (* 2. `always_true: Int` *)
  let always_true = todo

  (* 3. `everything_implies_truth: 'p -> Int` *)
  let everything_implies_truth = todo

  (* 4. `truth_implies_everything: Int -> 'q` *)
  let truth_implies_everything = todo

  (* 5. `something_implies_everything: 'p -> 'q` *)
  let something_implies_everything = todo

  (* 6. `everything_implies_itself: 'p -> 'p` *)
  let everything_implies_itself = todo

  (* 7. `modus_ponens: 'p -> ('p -> 'q) -> 'q` *)
  let modus_ponens = todo

  (* 8.  `both_true_implies_true: 'p * 'q -> 'p` *)
  let both_true_implies_true = todo

  (* 9.  `true_implies_both_true: 'p -> 'p * 'q` *)
  let true_implies_both_true = todo

  (* 10. `conjunction_is_commutative: 'p * 'q -> 'q * 'p` *)
  let conjunction_is_commutative = todo

  (* 11. `conjunction_is_associative: 'p * ('q * 'r) -> ('p * 'q) * 'r` *)
  let conjunction_is_associative = todo

  (* 12. `conjunction_distributes_over_implication: ('p * ('q -> 'r)) -> (('p * 'q) -> ('p * 'r))` *)
  let conjunction_distributes_over_implication = todo

  (* 13. `conjunction_distributes_over_implication_hmm: (('p * 'q) -> ('p * 'r)) -> ('p * ('q -> 'r))` *)
  let conjunction_distributes_over_implication_hmm = todo

  (* 14. `implication_distributes_over_conjunction: ('p -> ('q * 'r)) -> (('p -> 'q) * ('p -> 'r))` *)
  let implication_distributes_over_conjunction = todo

  (* 15. `implication_distributes_over_conjunction_hmm: (('p -> 'q) * ('p -> 'r)) -> ('p -> ('q * 'r))` *)
  let implication_distributes_over_conjunction_hmm = todo

  (* 16. `implication_weakening: ('p -> 'q) -> ('p -> 'a -> 'q)` *)
  let implication_weakening = todo

  (* 17. `implication_contraction: ('p -> 'a -> 'a -> 'q) -> ('p -> 'a -> 'q)` *)
  let implication_contraction = todo

  (* 18. `implication_exchange: ('p -> 'q -> 'r) -> ('q -> 'p -> 'r)` *)
  let implication_exchange = todo

  (* 19. `curry: ('p * 'q -> 'r) -> ('p -> 'q -> 'r)` *)
  let curry = todo

  (* 20. `curry_hmm: ('p -> 'q -> 'r) -> ('p * 'q -> 'r)` *)
  let curry_hmm = todo
end

module Validity = struct
  let todo = false

  (* On the right-hand-sides, determine whether the propositions that are valid.
     If a proposition is valid, write `true` as the second component of the pair.
     Otherwise, write `false`.

     Example:
        (* 0. `duplicate: 'a -> 'a * 'a` *)
        (* The boolean formula [A => (A /\ A)] is valid. *)

        ("duplicate", true)
  *)
  let list () =
    [
      ("duplicate", true);
      ("everything", todo);
      ("always_true", todo);
      ("everything_implies_truth", todo);
      ("truth_implies_everything", todo);
      ("something_implies_everything", todo);
      ("everything_implies_itself", todo);
      ("modus_ponens", todo);
      ("both_true_implies_true", todo);
      ("true_implies_both_true", todo);
      ("conjunction_is_commutative", todo);
      ("conjunction_is_associative", todo);
      ("conjunction_distributes_over_implication", todo);
      ("conjunction_distributes_over_implication_hmm", todo);
      ("implication_distributes_over_conjunction", todo);
      ("implication_distributes_over_conjunction_hmm", todo);
      ("implication_weakening", todo);
      ("implication_contraction", todo);
      ("implication_exchange", todo);
      ("curry", todo);
      ("curry_hmm", todo);
    ]
end

module Synthesis () = struct
  let counter = ref 0

  (** Return a fresh variable string *)
  let fresh () =
    counter := !counter + 1;
    "_x" ^ Int.to_string !counter

  module Ty = struct
    module T = struct
      type t = ty [@@deriving eq, ord, sexp]
    end

    include T
    include Comparable.Make (T)
  end

  type env = expr Map.M(Ty).t
  (** An [env] is a mapping from type [t] to an expression [e] that has type [t] *)

  (** Pretty-printing of environments *)
  let pp_env : env Fmt.t =
   fun ppf env ->
    Fmt.(
      vbox
      @@ iter_bindings
           (fun f env -> List.iter ~f:(fun (t, e) -> f t e) env)
           (pair ~sep:(any " : ") Pretty.pp_ty Pretty.pp_expr))
      ppf (Map.to_alist env)

  (** An empty environment *)
  let empty : env = Map.empty (module Ty)

  (** Find an expression of type [t] in the environment *)
  let find : env -> ty -> expr option = Map.find

  (** Add (overwrite) an expression of type [t] to the environment *)
  let add (env : env) (t : ty) (e : expr) : env =
    if Map.mem env t then env else Map.add_exn env ~key:t ~data:e

  (** Add a list of (type, expression) pairs to the environment *)
  let add_list (env : env) (te : (ty * expr) list) : env =
    List.fold te ~init:env ~f:(fun env (t, e) -> add env t e)

  let todo () = failwith "TODO"

  (** Helper function that, given a type and an environment that maps
      types to expressions, return an expression that has the input type *)
  let rec helper (env : env) (t : ty) : expr option =
    (* Fmt.epr "[synthesis] goal: %a\n%!" Pretty.pp_ty t; *)
    (* Fmt.epr "[synthesis] environment:\n%!  %a\n%!" pp_env env; *)
    match find env t with
    | Some e ->
        (* if we already have an [e] of type [t], simply return [e] *)
        Some e
    | None -> (
        match t with
        | TVar x -> todo ()
        | TInt -> todo ()
        | TBool -> Some True (* either True or False is fine *)
        | TFun (t1, t2) -> todo ()
        | TProd (t1, t2) -> todo ()
        | TList _ -> failwith "helper: list type not supported")

  let synthesize_program_of_ty (t : ty) : expr option = helper empty t
end

(** The main synthesis function that returns an expression that has the 
    given type *)
let synthesize (t : ty) : expr option =
  let module S = Synthesis () in
  S.synthesize_program_of_ty t
