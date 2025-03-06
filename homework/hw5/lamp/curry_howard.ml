open Base
open Ast

let todo () = failwith "TODO"

(** These types can be interpreted as propositions *)
let types : (string * ty) list =
  List.map
    ~f:(fun (p, s) -> (p, Parser.Ty.parse_string s))
    [
      ("always_true", "()");
      ("always_false", "!");
      ("everything", "'p");
      ("everything_implies_truth", "'p -> ()");
      ("falsehood_implies_everything", "! -> 'q");
      ("everything_implies_itself", "'p -> 'p");
      ("modus_ponens", "'p * ('p -> 'q) -> 'q");
      ("both_true_implies_left_true", "'p * 'q -> 'p");
      ("either_true_implies_left_true", "'p + 'q -> 'p");
      ("conjunction_is_commutative", "'p * 'q -> 'q * 'p");
      ("disjunction_is_commutative", "'p + 'q -> 'q + 'p");
      ( "conjunction_distributes_over_disjunction",
        "'p * ('q + 'r) -> ('p * 'q) + ('p * 'r)" );
      ( "disjunction_distributes_over_conjunction",
        "'p + ('q * 'r) -> ('p + 'q) * ('p + 'r)" );
      ("curry", "('p * 'q -> 'r) -> ('p -> ('q -> 'r))");
      ("uncurry", "('p -> ('q -> 'r)) -> ('p * 'q -> 'r)");
    ]

(** For each proposition, determine whether it is valid (i.e. the truth table is always T) *)
let is_valid () : (string * bool) list =
  [
    ("always_true", todo ());
    ("everything", todo ());
    ("everything_implies_truth", todo ());
    ("falsehood_implies_everything", todo ());
    ("everything_implies_itself", todo ());
    ("modus_ponens", todo ());
    ("both_true_implies_left_true", todo ());
    ("either_true_implies_left_true", todo ());
    ("conjunction_is_commutative", todo ());
    ("disjunction_is_commutative", todo ());
    ("conjunction_distributes_over_disjunction", todo ());
    ("disjunction_distributes_over_conjunction", todo ());
    ("curry", todo ());
    ("uncurry", todo ());
  ]

(** For each type, give a lambda-plus expression that can be inferred to have said type.
  If there're no such expressions, simply put a [None]. Otherwise, put [Some <str>] where
  <str> is the expression in concrete syntax. *)
let expressions () : (string * expr option) list =
  List.map
    ~f:(fun (p, s) -> (p, Option.map ~f:Parser.Expr.parse_string s))
    [
      ("always_true", Some "()");
      ("everything", None);
      ("everything_implies_truth", todo ());
      ("falsehood_implies_everything", todo ());
      ("everything_implies_itself", todo ());
      ("modus_ponens", todo ());
      ("both_true_implies_left_true", todo ());
      ("either_true_implies_left_true", todo ());
      ("conjunction_is_commutative", todo ());
      ("disjunction_is_commutative", todo ());
      ("conjunction_distributes_over_disjunction", todo ());
      ("disjunction_distributes_over_conjunction", todo ());
      ("curry", todo ());
      ("uncurry", todo ());
    ]

let synthesize (t : ty) : expr option = todo ()
