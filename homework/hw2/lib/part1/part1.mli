val singletons : 'a list -> 'a list list
val map2d : ('a -> 'b) -> 'a list list -> 'b list list
val product : 'a list -> 'b list -> ('a * 'b) list list
val power : 'a list -> 'a list list
val solve : 'result -> ('a -> 'result -> 'result) -> 'a list -> 'result
val join2 : 'a option -> 'b option -> ('a * 'b) option
