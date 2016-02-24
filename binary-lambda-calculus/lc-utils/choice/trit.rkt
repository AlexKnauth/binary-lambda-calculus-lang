#lang lazy

(provide 0-trit 1-trit 2-trit trit-case)

;; A Trit is one of:
(define 0-trit (λ (a) (λ (b) (λ (c) a))))
(define 1-trit (λ (a) (λ (b) (λ (c) b))))
(define 2-trit (λ (a) (λ (b) (λ (c) c))))

(define (trit-case trit a b c)
  (((trit a) b) c))

