#lang lazy

(provide 0-bit
         1-bit
         true
         false
         if
         number->rkt:number
         )

(require "choice/bit.rkt")

(define true  0-bit)
(define false 1-bit)

(define (if a b c)
  (bit-case a b c))

(define (number->rkt:number num)
  ((num add1) 0))
