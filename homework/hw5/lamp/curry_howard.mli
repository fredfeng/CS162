val types : (string * Ast.ty) list
val is_valid : unit -> (string * bool) list
val expressions : unit -> (string * Ast.expr option) list
val synthesize : Ast.ty -> Ast.expr option
