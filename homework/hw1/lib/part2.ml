open Base
open Util

let rec compress (equal : 'a -> 'a -> bool) (xs : 'a list) : 'a list = todo ()
let max (xs : int list) : int option = todo ()
let rec join (xs : 'a option list) : 'a list option = todo ()
let insert (k : 'k) (v : 'v) (d : ('k * 'v) list) : ('k * 'v) list = (k, v) :: d

let rec lookup (equal : 'k -> 'k -> bool) (k : 'k) (d : ('k * 'v) list) :
    'v option =
  todo ()
