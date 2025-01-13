open Base
open Util

let rec compress (equal : 'a -> 'a -> bool) (xs : 'a list) : 'a list = todo ()
let max (xs : int list) : int option = todo ()
let rec join (xs : 'a option list) : 'a list option = todo ()

let insert (key : 'k) (value : 'v) (dict : ('k * 'v) list) : ('k * 'v) list =
  (key, value) :: dict

let rec lookup (equal : 'k -> 'k -> bool) (key : 'k) (dict : ('k * 'v) list) :
    'v option =
  todo ()
