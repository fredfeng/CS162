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

let test_equal_tree t1 t2 expected () =
  Alcotest.(check' bool)
    ~msg:"same bool" ~expected
    ~actual:(equal_tree Int.equal t1 t2)

let test_timestamp t expected () =
  Alcotest.(
    check'
      (testable
         (Tree.pp (Fmt.of_to_string [%derive.show: int * char]))
         (Tree.equal [%derive.eq: int * char])))
    ~msg:"same tree" ~expected ~actual:(timestamp t)

let equal_tree_tests =
  [
    test_equal_tree
      (* input trees 1 *)
      DSL.(node 1 leaf leaf)
      (* input tree 2 *)
      DSL.(node 1 leaf leaf)
      (* expected output *)
      true;
  ]

let timestamp_tests =
  [
    test_timestamp
      (* input tree *)
      DSL.(
        node 'o'
          (node 'm' (term 'c') (term 'a'))
          (node 'y' (term 'a') (term 'l')))
      (* expected output tree *)
      DSL.(
        node (0, 'o')
          (node (1, 'm') (term (2, 'c')) (term (3, 'a')))
          (node (4, 'y') (term (5, 'a')) (term (6, 'l'))));
  ]

let tests = [ ("equal_tree", equal_tree_tests); ("timestamp", timestamp_tests) ]
