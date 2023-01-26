(* Provided functions *)
val hd : 'a inf -> 'a
val tl : 'a inf -> 'a inf
val cons: 'a -> 'a inf -> 'a inf
val from: int -> 'a inf
val map: ('a -> 'b) -> 'a inf -> 'b inf

(* Functions that you need to define *)
val repeat : 'a -> 'a inf
val fib : int inf
val firstn : int -> 'a inf -> 'a list
val interleave : 'a inf -> 'a inf -> 'a inf
val z : int inf
val product : 'a inf -> 'b inf -> ('a * 'b) inf inf
val corner : int -> 'a inf inf -> 'a list list
val diag: 'a inf inf -> 'a inf