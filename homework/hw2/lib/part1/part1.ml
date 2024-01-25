open Base
open Util

let todo () = failwith "TODO"
let singletons (xs : 'a list) : 'a list list = todo ()
let map2d (f : 'a -> 'b) (xss : 'a list list) : 'b list list = todo ()
let product (xs : 'a list) (ys : 'b list) : ('a * 'b) list list = todo ()

let rec solve (base_case : 'result) (combine : 'a -> 'result -> 'result)
    (xs : 'a list) : 'result =
  match xs with
  | [] -> base_case
  | x :: xs' ->
      let r = solve base_case combine xs' in
      combine x r

let power (xs : 'a list) : 'a list list = todo ()

let join2 : 'a option -> 'b option -> ('a * 'b) option =
 fun x -> match x with Some x -> todo () | None -> todo ()
