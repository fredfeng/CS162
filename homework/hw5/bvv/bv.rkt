#lang racket

(require
  (prefix-in @
   (only-in rosette
    bv bitvector->integer
    bveq bvule bvult bvuge bvugt bvsle bvslt bvsge bvsgt  
    bvsdiv  bvsrem  bvshl  bvlshr  bvashr  bvsub bvneg bvnot 
    bvor bvand bvxor bvadd bvmul)))

(provide define-fragment fragment? fragment-ast
         = bvule bvult bvuge bvugt bvsle bvslt bvsge bvsgt  
         bvneg bvadd bvsub bvmul bvsdiv bvsrem  bvshl  bvlshr  bvashr  
         bvnot bvor bvand bvxor)

; This module defines the syntax and semantics of the BV language.
; For the sake of brevity, the implementation does not enforce the 
; well-formedness constraints specified in HW2.  We'll just make sure 
; not to construct ill-formed programs.

; A fragment object consists of an abstract syntax tree (AST) for a 
; BV program, represented as a nested list of symbols (an s-expression), 
; as well as a procedure corresponding to that AST.  Applying a fragment 
; to inputs has the same effect as applying its procedure to those inputs.
(struct fragment (ast proc)
  #:transparent
  #:property prop:procedure
  [struct-field-index proc])

(define-syntax (define-fragment stx)
  (syntax-case stx (define-fragment return)
    [(define-fragment (id in ...)
       stmt ...
       (return expr))
     (quasisyntax/loc stx 
       (define id
         (fragment 
          '#,stx
          (procedure-rename
           (lambda (in ...)
            stmt ...
            expr)
           'id))))]))

(define (bv32 c) (@bv c 32))
                 
(define (operator . xs)
  (apply values @bitvector->integer (map bv32 xs)))

(define (predicate . xs)
  (apply values (map bv32 xs)))

(define-syntax-rule
  (define-impersonators wrapper [id impl] ...)
  (define-values
    (id ...)
    (values (impersonate-procedure impl wrapper) ...)))

(define-impersonators predicate 
  [= @bveq]
  [bvule @bvule] [bvult @bvult]
  [bvuge @bvuge] [bvugt @bvugt]
  [bvsle @bvsle] [bvslt @bvslt]
  [bvsge @bvsge] [bvsgt @bvsgt])

(define-impersonators operator
  [bvneg @bvneg] [bvadd @bvadd] [bvsub @bvsub] [bvmul @bvmul]
  [bvsdiv @bvsdiv] [bvsrem @bvsrem]
  [bvshl @bvshl] [bvlshr @bvlshr] [bvashr @bvashr]
  [bvnot @bvnot] [bvor @bvor] [bvand @bvand] [bvxor @bvxor])
  
