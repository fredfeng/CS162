open Base
open Util

type 'a tree = Leaf | Node of 'a * 'a tree * 'a tree [@@deriving show]

let rec equal_tree (equal : 'a -> 'a -> bool) (t1 : 'a tree) (t2 : 'a tree) :
    bool =
  todo ()

let timestamp (t : 'a tree) : (int * 'a) tree = todo ()
