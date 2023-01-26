#use "inf.ml";;

type cell = int
type state = Running of int | Halted
type tape = cell * cell inf * cell inf
type action = Left | Right | StayPut
type key = state * cell
type value = state * action
type transitions = (key * value) list

let move ((head, left, right): tape) (a: action) : tape =
  failwith "Your code here"

let step (tr: transitions) (s: state) (t: tape) : state * tape =
  failwith "Your code here"

let rec simulate (tr: transitions) (s: state) (t: tape) : tape =
  failwith "Your code here"

let empty_tape : tape = (0, repeat 0, repeat 0)