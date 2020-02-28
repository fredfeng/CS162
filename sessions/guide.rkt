#lang racket

(define (read-my-list-0 x)
  (match x
    [`(my-list ,a ...) a]
    [_ (error "syntax error")]))

(define (read-my-list-1 x)
  (match x
    [`(my-list ,a ...) (for/list ([i a]) (read-my-list-1 i))]
    [b (eval b)]))

(define (fancy-says x)
  (match x
    [`(,who ,what) (printf (string-append (symbol->string who) " says " what ".\n"))]
    [_ (error "syntax error")]))

(define (find-max l)
  (match l
    [(list head tail ...)
     (let ([r (find-max tail)])
       (if (integer? r) (max head r) head))]
    [_ #f]))

(define (rev3 l)
  (match l
    [(list a b c) (list c b a)]
    [_ (error "list is not of length 3")]))

(define (rev l)
  (match l
    [(list ) (list )]
    [(list head tail ...) (append (rev tail) (list head))]
    [_ (error "not a list")]))