open Ast
open Base

exception Error of string

(** Decoder functions *)
let decodings =
  [
    (* decode boolean encoding into native boolean *)
    ("dec_bool", "lambda b. b true false");
    (* decode boolean encoding into native int *)
    ("dec_nat", "lambda n. n 0 (lambda _,r. r+1)");
    (* decode list encoding into native list *)
    ("dec_list", "lambda xs. xs Nil (lambda x,_,r. x::r)");
    (* decode tree encoding into native list *)
    ("dec_tree", "lambda t. t Nil (lambda x,_,_,l,r. x::(l::r))");
    (* decode the encoding of product *)
    ("dec_prod", "lambda p. p (lambda x,y. {x,y})");
  ]
  |> List.map ~f:(fun (x, e) -> (x, Parse_util.parse e))

(** Definitional interpreter you wrote in OCaml *)
let eval_def = Eval.eval

(** Load the expressions defined in the meta-circular interpreter *)
let meta_expr = Parse_util.parse Meta_lp.lp |> eval_def

(** Navigate to the i-th element of the list of meta functions *)
let rec navi i e =
  match e with
  | ListCons (e1, e2) -> if i = 0 then e1 else navi (i - 1) e2
  | _ -> raise (Error "[navi] index out of bounds")

(** Functions defined in the meta-circular interpreter *)
let runtime () =
  [
    ("var_enc", navi 0 meta_expr);
    ("lam_enc", navi 1 meta_expr);
    ("app_enc", navi 2 meta_expr);
    ("subst", navi 3 meta_expr);
    ("eval", navi 4 meta_expr);
    ("dec_ast", navi 5 meta_expr);
  ]

(** Get the definition of a runtime function *)
let get (s : string) : expr =
  match List.Assoc.find (runtime ()) ~equal:String.equal s with
  | Some e -> e
  | None -> raise (Error Fmt.(str "Function %s not found" s))

(** fold over AST *)
let rec fold (f : expr -> expr) (e : expr) : expr =
  match e with
  | Var _ | Num _ | True | False | ListNil -> f e
  | Lambda (Scope (x, e)) -> f (Lambda (Scope (x, fold f e)))
  | App (e1, e2) -> f (App (fold f e1, fold f e2))
  | Let (e1, Scope (x, e2)) -> f (Let (fold f e1, Scope (x, fold f e2)))
  | Binop (op, e1, e2) -> f (Binop (op, fold f e1, fold f e2))
  | Comp (op, e1, e2) -> f (Comp (op, fold f e1, fold f e2))
  | IfThenElse (e1, e2, e3) -> f (IfThenElse (fold f e1, fold f e2, fold f e3))
  | ListCons (e1, e2) -> f (ListCons (fold f e1, fold f e2))
  | ListMatch (e1, e2, Scope (x, Scope (y, e3))) ->
      f (ListMatch (fold f e1, fold f e2, Scope (x, Scope (y, fold f e3))))
  | Fix (Scope (x, e)) -> f (Fix (Scope (x, fold f e)))
  | Pair (e1, e2) -> f (Pair (fold f e1, fold f e2))
  | Fst e -> f (Fst (fold f e))
  | Snd e -> f (Snd (fold f e))
  | _ -> raise (Error Fmt.(str "[fold] Malformed: %a" Ast.Pretty.pp_expr e))

module Desugar = struct
  let get (s : string) : expr =
    match List.Assoc.find Encodings.encodings ~equal:String.equal s with
    | Some e -> e
    | None -> raise (Error Fmt.(str "Function %s not found" s))

  let bool = function
    | True -> get "tt"
    | False -> get "ff"
    | IfThenElse (e1, e2, e3) -> App (App (e1, e2), e3)
    | e -> e

  let rec nat_lit = function
    | Num 0 -> get "zero"
    | Num n when n > 0 -> App (get "succ", nat_lit (Num (n - 1)))
    | Num _ -> raise (Error "Negative number not supported")
    | e -> e

  let nat = function
    | Num _ as e -> nat_lit e
    | Binop (op, e1, e2) -> (
        match op with
        | Add -> App (App (get "add", e1), e2)
        | Sub -> App (App (get "sub", e1), e2)
        | Mul -> App (App (get "mul", e1), e2))
    | Comp (op, e1, e2) -> (
        match op with
        | Lt -> App (App (get "lt", e1), e2)
        | Eq -> App (App (get "eq", e1), e2)
        | Gt -> App (App (get "gt", e1), e2))
    | e -> e

  let rec list = function
    | ListNil -> get "nil"
    | ListCons (e1, e2) -> App (App (get "cons", e1), e2)
    | ListMatch (e1, e2, Scope (x, Scope (y, e3))) ->
        App
          ( App (e1, e2),
            Lambda (Scope (x, Lambda (Scope (y, Lambda (Scope ("_", e3)))))) )
    | e -> e

  let fix = function
    | Fix (Scope (x, e)) -> App (get "fix_z", Lambda (Scope (x, e)))
    | e -> e

  let product = function
    | Pair (e1, e2) -> App (App (get "pair", e1), e2)
    | Fst e -> App (get "fst_enc", e)
    | Snd e -> App (get "snd_enc", e)
    | e -> e

  let go (e : expr) : expr =
    List.fold_right
      ~f:(fun f e -> fold f e)
      ~init:e
      [ bool; nat; list; fix; product ]

  let with_encodings e =
    List.fold_right
      ~f:(fun (x, def) e -> Eval.subst x def e)
      ~init:e Encodings.encodings
end

(** Normalize binders in a lambda-calculus expression to use unique names *)
let normalize (e : expr) : expr =
  let counter = ref 0 in
  let fresh_id () : int =
    let v = !counter in
    counter := !counter + 1;
    v
  in
  let rec helper env e =
    match e with
    | Var x -> (
        match List.Assoc.find env ~equal:String.equal x with
        | Some n -> Var (Int.to_string n)
        | None -> raise (Error Fmt.(str "Unbound variable: %s" x)))
    | Lambda (Scope (x, e')) ->
        let n = fresh_id () in
        Lambda (Scope (Int.to_string n, helper ((x, n) :: env) e'))
    | App (f, a) ->
        let f' = helper env f in
        let a' = helper env a in
        App (f', a')
    | Let (e1, Scope (x, e2)) -> helper env (App (Lambda (Scope (x, e2)), e1))
    | _ ->
        raise
          (Error Fmt.(str "[normalize] Unsupported: %a" Ast.Pretty.pp_expr e))
  in
  helper [] e

(** Encode a lambda-calculus expression into lambda-plus *)
let rec encode (e : expr) : expr =
  match e with
  | Var x -> App (get "var_enc", Num (Int.of_string x))
  | Lambda (Scope (x, e')) ->
      App (App (get "lam_enc", Num (Int.of_string x)), encode e')
  | App (f, a) -> App (App (get "app_enc", encode f), encode a)
  | _ -> raise (Error Fmt.(str "[encode] Unsupported: %a" Ast.Pretty.pp_expr e))

(** Decode a lambda-calculus expression *)
let decode (e : expr) : expr =
  let rec decode_list e =
    match e with
    | ListCons (Num 0, Num i) -> Var (Int.to_string i)
    | ListCons (Num 1, ListCons (Num i, e')) ->
        let x = Int.to_string i in
        let e'' = decode_list e' in
        Lambda (Scope (x, e''))
    | ListCons (Num 2, ListCons (e1, e2)) -> App (decode_list e1, decode_list e2)
    | _ ->
        raise (Error Fmt.(str "[decode] Unsupported: %a" Ast.Pretty.pp_expr e))
  in
  (* convert an encoded lambda-calculus expression to the list representation *)
  let e_as_list = eval_def (App (get "dec_ast", e)) in
  (* convert the list representation to actual AST *)
  decode_list e_as_list

let rec prepend_name (x : string) (e : expr) : expr =
  match e with
  | Var y -> Var (x ^ y)
  | Lambda (Scope (y, e)) -> Lambda (Scope (x ^ y, prepend_name x e))
  | App (e1, e2) -> App (prepend_name x e1, prepend_name x e2)
  | _ ->
      raise
        (Error Fmt.(str "[prepend_name] Unsupported: %a" Ast.Pretty.pp_expr e))

(** populate the runtime environment with meta functions *)
let with_runtime e =
  List.fold_right
    ~f:(fun (x, def) e -> Let (def, Scope (x, e)))
    ~init:e (runtime ())

let pp_large : expr Fmt.t =
 fun ppf e ->
  let size = ref 0 in

  let rec helper e =
    if !size > 100 then true
    else
      match e with
      | Var _ ->
          size := !size + 1;
          false
      | App (e1, e2) ->
          size := !size + 1;
          helper e1 || helper e2
      | Lambda (Scope (_, e)) ->
          size := !size + 1;
          helper e
      | _ -> failwith "impossible"
  in
  if helper e then Fmt.string ppf "<huge-expr>" else Ast.Pretty.pp_expr ppf e

let finalize e = e |> normalize |> prepend_name "_"

(** Run the meta-circular interpreter *)
let eval (e : expr) : expr =
  (* encode e *)
  e |> Desugar.go |> Desugar.with_encodings |> normalize |> encode
  (* apply the meta-level eval function *)
  |> (fun e' -> App (Var "eval", e'))
  (* provide meta-level runtime functions *)
  |> with_runtime
  (* run the meta-circular interpreter *)
  |> eval_def
  (* decode result into plain lambda-plus AST *)
  |> decode
  |> finalize
