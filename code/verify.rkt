#lang rosette
(require rosette/lib/match rosette/lib/angelic)

(define (poly x)
 (+ (* x x x x) (* 6 x x x) (* 11 x x) (* 6 x)))

;; z3 -smt2 xxx.smt2
(output-smt #t)
 
(define (factored x)
 (* x (+ x 1) (+ x 2) (+ x 2)))
 
(define (same p f x)
 (assert (= (p x) (f x))))


;;; (same poly factored 0)
;;; (same poly factored -1)
;;; (same poly factored -2)

(define-symbolic i integer?)

(define cex (verify (same poly factored i)))
(evaluate i cex)

(poly -6)

(factored -6)

(same poly factored -6)