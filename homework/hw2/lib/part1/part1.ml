let todo () = failwith "TODO"
let singletons (xs : 'a list) : 'a list list = todo ()
let map2d (f : 'a -> 'b) (xss : 'a list list) : 'b list list = todo ()
let product (xs : 'a list) (ys : 'b list) : ('a * 'b) list list = todo ()
let power (xs : 'a list) : 'a list list = todo ()

let both : 'a option -> 'b option -> ('a * 'b) option =
 fun x -> match x with Some x -> todo () | None -> todo ()
