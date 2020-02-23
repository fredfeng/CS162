#lang rosette
 
(require rosette/query/debug rosette/lib/render)
 
(define (poly x)
  (+ (* x x x x) (* 6 x x x) (* 11 x x) (* 6 x)))
 
(define/debug (factored x)       ; define/debug marks a procedure as part of
  (* x (+ x 1) (+ x 2) (+ x 2))) ; the code to be debugged
 
(define (same p f x)
  (assert (= (p x) (f x))))

(define ucore (debug [integer?] (same poly factored -6)))

(render ucore)