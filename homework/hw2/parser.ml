
exception Error

let _eRR =
  Error


type _menhir_env = {
  _menhir_lexer: Lexing.lexbuf -> token;
  _menhir_lexbuf: Lexing.lexbuf;
  _menhir_token: token;
  mutable _menhir_error: bool
}

and _menhir_state = 
  | MenhirState12
  | MenhirState9
  | MenhirState7
  | MenhirState4
  | MenhirState1
  | MenhirState0

# 2 "parser.mly"
  
(*      open Exp;;*)

# 39 "parser.ml"

let rec _menhir_goto_expr : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_expr -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState4 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((('freshtv35 * _menhir_state) * (
# 10 "parser.mly"
               (char)
# 50 "parser.ml"
        ))) * _menhir_state * 'tv_expr) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | ID _v ->
            _menhir_run5 _menhir_env (Obj.magic _menhir_stack) MenhirState7 _v
        | LAMBDA ->
            _menhir_run2 _menhir_env (Obj.magic _menhir_stack) MenhirState7
        | LPAREN ->
            _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState7
        | EOL | RPAREN ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ((('freshtv33 * _menhir_state) * (
# 10 "parser.mly"
               (char)
# 66 "parser.ml"
            ))) * _menhir_state * 'tv_expr) = Obj.magic _menhir_stack in
            ((let (((_menhir_stack, _menhir_s), (_2 : (
# 10 "parser.mly"
               (char)
# 71 "parser.ml"
            ))), _, (_4 : 'tv_expr)) = _menhir_stack in
            let _3 = () in
            let _1 = () in
            let _v : 'tv_t = 
# 26 "parser.mly"
                              (Lam((String.make 1 _2), _4))
# 78 "parser.ml"
             in
            _menhir_goto_t _menhir_env _menhir_stack _menhir_s _v) : 'freshtv34)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState7) : 'freshtv36)
    | MenhirState1 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv41 * _menhir_state) * _menhir_state * 'tv_expr) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | ID _v ->
            _menhir_run5 _menhir_env (Obj.magic _menhir_stack) MenhirState9 _v
        | LAMBDA ->
            _menhir_run2 _menhir_env (Obj.magic _menhir_stack) MenhirState9
        | LPAREN ->
            _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState9
        | RPAREN ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv39 * _menhir_state) * _menhir_state * 'tv_expr) = Obj.magic _menhir_stack in
            let (_menhir_s : _menhir_state) = MenhirState9 in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv37 * _menhir_state) * _menhir_state * 'tv_expr) = Obj.magic _menhir_stack in
            let (_ : _menhir_state) = _menhir_s in
            ((let ((_menhir_stack, _menhir_s), _, (_2 : 'tv_expr)) = _menhir_stack in
            let _3 = () in
            let _1 = () in
            let _v : 'tv_t = 
# 27 "parser.mly"
                                            ( _2 )
# 111 "parser.ml"
             in
            _menhir_goto_t _menhir_env _menhir_stack _menhir_s _v) : 'freshtv38)) : 'freshtv40)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState9) : 'freshtv42)
    | MenhirState0 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv53 * _menhir_state * 'tv_expr) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | EOL ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv51 * _menhir_state * 'tv_expr) = Obj.magic _menhir_stack in
            let (_menhir_s : _menhir_state) = MenhirState12 in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv49 * _menhir_state * 'tv_expr) = Obj.magic _menhir_stack in
            let (_ : _menhir_state) = _menhir_s in
            ((let (_menhir_stack, _menhir_s, (_1 : 'tv_expr)) = _menhir_stack in
            let _2 = () in
            let _v : (
# 12 "parser.mly"
              (exp)
# 136 "parser.ml"
            ) = 
# 16 "parser.mly"
                                    ( _1 )
# 140 "parser.ml"
             in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv47) = _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let (_v : (
# 12 "parser.mly"
              (exp)
# 148 "parser.ml"
            )) = _v in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv45) = Obj.magic _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let (_v : (
# 12 "parser.mly"
              (exp)
# 156 "parser.ml"
            )) = _v in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv43) = Obj.magic _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let ((_1 : (
# 12 "parser.mly"
              (exp)
# 164 "parser.ml"
            )) : (
# 12 "parser.mly"
              (exp)
# 168 "parser.ml"
            )) = _v in
            (Obj.magic _1 : 'freshtv44)) : 'freshtv46)) : 'freshtv48)) : 'freshtv50)) : 'freshtv52)
        | ID _v ->
            _menhir_run5 _menhir_env (Obj.magic _menhir_stack) MenhirState12 _v
        | LAMBDA ->
            _menhir_run2 _menhir_env (Obj.magic _menhir_stack) MenhirState12
        | LPAREN ->
            _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState12
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState12) : 'freshtv54)
    | _ ->
        let (() : unit) = () in
        ((Printf.fprintf Pervasives.stderr "Internal failure -- please contact the parser generator's developers.\n%!";
        assert false) : 'freshtv55)

and _menhir_goto_t : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_t -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    match _menhir_s with
    | MenhirState0 | MenhirState1 | MenhirState4 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv27) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_t) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv25) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let ((_1 : 'tv_t) : 'tv_t) = _v in
        ((let _v : 'tv_expr = 
# 21 "parser.mly"
         (_1)
# 201 "parser.ml"
         in
        _menhir_goto_expr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv26)) : 'freshtv28)
    | MenhirState12 | MenhirState9 | MenhirState7 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv31 * _menhir_state * 'tv_expr) = Obj.magic _menhir_stack in
        let (_menhir_s : _menhir_state) = _menhir_s in
        let (_v : 'tv_t) = _v in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv29 * _menhir_state * 'tv_expr) = Obj.magic _menhir_stack in
        let (_ : _menhir_state) = _menhir_s in
        let ((_2 : 'tv_t) : 'tv_t) = _v in
        ((let (_menhir_stack, _menhir_s, (_1 : 'tv_expr)) = _menhir_stack in
        let _v : 'tv_expr = 
# 20 "parser.mly"
                      ( App (_1,_2) )
# 217 "parser.ml"
         in
        _menhir_goto_expr _menhir_env _menhir_stack _menhir_s _v) : 'freshtv30)) : 'freshtv32)

and _menhir_errorcase : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    match _menhir_s with
    | MenhirState12 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv13 * _menhir_state * 'tv_expr) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv14)
    | MenhirState9 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv15 * _menhir_state) * _menhir_state * 'tv_expr) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv16)
    | MenhirState7 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ((('freshtv17 * _menhir_state) * (
# 10 "parser.mly"
               (char)
# 239 "parser.ml"
        ))) * _menhir_state * 'tv_expr) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv18)
    | MenhirState4 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv19 * _menhir_state) * (
# 10 "parser.mly"
               (char)
# 248 "parser.ml"
        ))) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv20)
    | MenhirState1 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv21 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv22)
    | MenhirState0 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv23) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv24)

and _menhir_run1 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | ID _v ->
        _menhir_run5 _menhir_env (Obj.magic _menhir_stack) MenhirState1 _v
    | LAMBDA ->
        _menhir_run2 _menhir_env (Obj.magic _menhir_stack) MenhirState1
    | LPAREN ->
        _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState1
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState1

and _menhir_run2 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | ID _v ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv9 * _menhir_state) = Obj.magic _menhir_stack in
        let (_v : (
# 10 "parser.mly"
               (char)
# 291 "parser.ml"
        )) = _v in
        ((let _menhir_stack = (_menhir_stack, _v) in
        let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | DOT ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv5 * _menhir_state) * (
# 10 "parser.mly"
               (char)
# 302 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | ID _v ->
                _menhir_run5 _menhir_env (Obj.magic _menhir_stack) MenhirState4 _v
            | LAMBDA ->
                _menhir_run2 _menhir_env (Obj.magic _menhir_stack) MenhirState4
            | LPAREN ->
                _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState4
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState4) : 'freshtv6)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv7 * _menhir_state) * (
# 10 "parser.mly"
               (char)
# 324 "parser.ml"
            )) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv8)) : 'freshtv10)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv11 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv12)

and _menhir_run5 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 10 "parser.mly"
               (char)
# 339 "parser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv3) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let ((_1 : (
# 10 "parser.mly"
               (char)
# 349 "parser.ml"
    )) : (
# 10 "parser.mly"
               (char)
# 353 "parser.ml"
    )) = _v in
    ((let _v : 'tv_t = 
# 25 "parser.mly"
                      (Var (String.make 1 _1))
# 358 "parser.ml"
     in
    _menhir_goto_t _menhir_env _menhir_stack _menhir_s _v) : 'freshtv4)

and _menhir_discard : _menhir_env -> _menhir_env =
  fun _menhir_env ->
    let lexer = _menhir_env._menhir_lexer in
    let lexbuf = _menhir_env._menhir_lexbuf in
    let _tok = lexer lexbuf in
    {
      _menhir_lexer = lexer;
      _menhir_lexbuf = lexbuf;
      _menhir_token = _tok;
      _menhir_error = false;
    }

and main : (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (
# 12 "parser.mly"
              (exp)
# 377 "parser.ml"
) =
  fun lexer lexbuf ->
    let _menhir_env =
      let (lexer : Lexing.lexbuf -> token) = lexer in
      let (lexbuf : Lexing.lexbuf) = lexbuf in
      ((let _tok = Obj.magic () in
      {
        _menhir_lexer = lexer;
        _menhir_lexbuf = lexbuf;
        _menhir_token = _tok;
        _menhir_error = false;
      }) : _menhir_env)
    in
    Obj.magic (let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv1) = ((), _menhir_env._menhir_lexbuf.Lexing.lex_curr_p) in
    ((let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | ID _v ->
        _menhir_run5 _menhir_env (Obj.magic _menhir_stack) MenhirState0 _v
    | LAMBDA ->
        _menhir_run2 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | LPAREN ->
        _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState0) : 'freshtv2))

# 220 "/Users/anwar/homebrew/Cellar/menhir/20160526/share/menhir/standard.mly"
  


# 411 "parser.ml"
