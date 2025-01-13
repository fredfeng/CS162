open Base
open Hw1.Part3

module Tree = struct
  type 'a t = [%import: 'a Hw1.Part3.tree] [@@deriving eq]

  (* A cleaner pretty-print function *)
  let rec pp ppf_a ppf = function
    | Leaf -> Fmt.pf ppf "Leaf"
    | Node (x, l, r) ->
        Fmt.pf ppf "Node (@[<hv>%a,@;%a,@;%a@])" ppf_a x (pp ppf_a) l (pp ppf_a)
          r
end

(** Wrapper functions for constructing trees. 
    You can either use plain constructors to build an tree, or
    call the functions in this module. *)
module DSL = struct
  (** Build a leaf node *)
  let leaf = Leaf

  (** Build a node with some data, a left subtree and a right subtree *)
  let node x l r = Node (x, l, r)

  (** Build a terminal node with some data (no subtrees) *)
  let term x = node x leaf leaf
end

let test_equal_tree =
  Utils.test_io Alcotest.bool "same bool" (Utils.uncurry (equal_tree Int.equal))

let test_timestamp =
  let t =
    Alcotest.(
      testable
        (Tree.pp (Fmt.of_to_string [%derive.show: int * char]))
        (Tree.equal [%derive.eq: int * char]))
  in
  Utils.test_io t "same tree" timestamp

(** A list of ((input tree * input tree) * expected output) tests *)
let equal_tree_tests =
  [ (DSL.(node 1 leaf leaf, node 1 leaf leaf), true) (* add your tests here *) ]

(** A list of (input tree * output tree) tests *)
let timestamp_tests =
  [
    DSL.
      ( node 'o'
          (node 'm' (term 'c') (term 'a'))
          (node 'y' (term 'a') (term 'l')),
        node (0, 'o')
          (node (1, 'm') (term (2, 'c')) (term (3, 'a')))
          (node (4, 'y') (term (5, 'a')) (term (6, 'l'))) );
    (* add your tests here *)
  ]

let tests =
  [
    ("equal_tree", List.map ~f:test_equal_tree equal_tree_tests);
    ("timestamp", List.map ~f:test_timestamp timestamp_tests);
  ]
