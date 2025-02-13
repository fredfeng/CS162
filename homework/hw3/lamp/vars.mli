(** Signature for variable set module *)

type t [@@deriving equal, compare, show]
(** type of variable set *)

val empty : t
(** empty set *)

val mem : string -> t -> bool
(** [mem x s] is true iff [x] is in [s] *)

val diff : t -> t -> t
(** [diff s1 s2] is the set of elements in [s1] but not in [s2] *)

val singleton : string -> t
(** [singleton x] is the singleton set containing [x] *)

val add : string -> t -> t
(** [add x s] is the set [s] with [x] added to it *)

val union : t -> t -> t
(** [union s1 s2] is the union of [s1] and [s2] *)

val of_list : string list -> t
(** [of_list l] converts a list [l] into a set *)

val to_list : t -> string list
(** [to_list x] converts a set [s] into a list *)

val size : t -> int
(** Return the size of a set *)
