#lang binary-lambda-calculus
000000 01 110 0101 1110 110 10  ; (λ (n) (λ (f x) (f (n f x))))

#|
  (require (only-in racket/base λ define add1))
  (define (rkt n)
    ((n add1) 0))
  (define zero (λ (f) (λ (x) x)))
  (rkt zero)
  (rkt (this zero))
  (rkt (this (this zero)))
  (rkt (this (this (this zero))))
|#
