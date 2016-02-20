#lang lazy

(provide 0-bit
         1-bit
         if
         cons
         car
         cdr
         stream
         number->rkt:number
         )

(define 0-bit (λ (a) (λ (b) a)))
(define 1-bit (λ (a) (λ (b) b)))

(define (if a b c)
  ((a b) c))

(define (cons fst rst)
  (λ (sel) (if sel fst rst)))

(define car 0-bit)
(define cdr 1-bit)

(define (stream . lst)
  (foldr cons `end-of-list lst))

(define (number->rkt:number num)
  ((num add1) 0))
