#lang lazy

(provide empty
         cons
         empty?
         first
         rest
         )

(require "lc-utils.rkt"
         "choice/trit.rkt")

;; Dynamic dispatch.
;; A (Finite-Listof a) is a type that supports these operations:
;;  - empty? : (Finite-Listof a) -> Boolean
;;  - first  : (Finite-Listof a) -> a
;;  - rest   : (Finite-Listof a) -> (Finite-Listof a)

;; A (Finite-Listof a) is represented by
;; a function that takes a Trit and dispatches:
;;  0-trit -> Boolean, true if empty, false if non-empty
;;  1-trit -> a, error if empty, the first element if non-empty
;;  2-trit -> (Finite-Listof a), error if empty, the rest if non-empty

(define empty
  (λ (trit)
    (trit-case trit
               true
               (error 'first "expected a non-empty list")
               (error 'rest "expected a non-empty list"))))

(define (cons a b)
  (λ (trit)
    (trit-case trit
               false
               a
               b)))

(define (empty? lst)
  (lst 0-trit))

(define (first lst)
  (lst 1-trit))

(define (rest lst)
  (lst 2-trit))
