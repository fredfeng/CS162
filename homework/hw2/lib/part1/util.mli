val map : ('a -> 'b) -> 'a list -> 'b list
val filter : ('a -> bool) -> 'a list -> 'a list
val fold : ('acc -> 'a -> 'acc) -> 'acc -> 'a list -> 'acc
