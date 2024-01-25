open Base

let map f xs = List.map ~f xs
let filter f xs = List.filter ~f xs
let fold f init xs = List.fold_left ~f ~init xs
