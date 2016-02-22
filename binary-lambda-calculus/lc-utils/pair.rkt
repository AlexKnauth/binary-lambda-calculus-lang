#lang lazy

(provide cons car cdr stream)

(require "lc-utils.rkt")

(define (cons fst rst)
  (λ (sel) (if sel fst rst)))

(define car 0-bit)
(define cdr 1-bit)

(define (stream . lst)
  (foldr cons `end-of-list lst))

