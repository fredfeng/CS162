open Base

type t = Set.M(String).t

let pp : t Fmt.t =
  Fmt.using Set.to_list Fmt.(braces @@ list ~sep:(any ", ") string)

let show = Fmt.to_to_string pp
let equal = Set.equal
let compare = Set.compare_direct
let empty = Set.empty (module String)
let diff = Set.diff
let singleton = Set.singleton (module String)
let add s v = Set.add v s
let union = Set.union
let mem s v = Set.mem v s
let of_list = Set.of_list (module String)
let to_list = Set.to_list
let size = Set.length
