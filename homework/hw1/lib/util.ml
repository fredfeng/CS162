open Base

let todo () = failwith "TODO"
let bonus () = failwith "Bonus"

let show_list (show : 'a -> string) (xs : 'a list) : string =
  Fmt.to_to_string (Fmt.list (Fmt.of_to_string show)) xs

let show_option (show : 'a -> string) (x : 'a option) : string =
  match x with None -> "None" | Some x -> "Some " ^ show x
