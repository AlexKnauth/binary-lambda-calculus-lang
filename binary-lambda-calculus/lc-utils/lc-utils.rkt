#lang lazy

(provide 0-bit
         1-bit
         if
         number->rkt:number
         )

(define 0-bit (λ (a) (λ (b) a)))
(define 1-bit (λ (a) (λ (b) b)))

(define (if a b c)
  ((a b) c))

(define (number->rkt:number num)
  ((num add1) 0))
