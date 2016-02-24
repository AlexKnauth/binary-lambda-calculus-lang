#lang lazy

(provide 0-bit 1-bit bit-case)

;; A Bit is one of:
(define 0-bit (λ (a) (λ (b) a)))
(define 1-bit (λ (a) (λ (b) b)))

(define (bit-case bit a b)
  ((bit a) b))

