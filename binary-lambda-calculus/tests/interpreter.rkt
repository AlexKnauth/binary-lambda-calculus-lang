#lang binary-lambda-calculus
;; This is an interpreter for binary-lambda-calculus, written in binary-lambda-calculus.
;; It takes a parsed term and an env, and returns the lambda that it should produce.
;; A Bit is one of:
;;  - 0000110 ; (λ (a b) a), representing 0
;;  - 000010  ; (λ (a b) b), representing 1
;; A lambda term is an improper list where
;;   the car is the 0-bit,
;;   the cadr is the 0-bit, and
;;   the cddr is the body.
;; A function application term is an improper list where
;;   the car is the 0-bit,
;;   the cadr is the 1-bit,
;;   the caddr is the function, and
;;   the cdddr is the argument.
;; A number term is a pair where
;;   the car is the 1-bit, and
;;   the cdr is the number.
;; An Env is a (Listof Value), with the position in the list representing the index.
;; cons = 0000000101101110110
01
;; the Y combinator
000100011010000111000010111011010
00 0000
  ;; if the next bit is a 0,
  0101 01 110 0000110
    ;; then if the next next bit is a 0,
    0101 0101 110 000010 0000110
      ;; it's a lambda expression
      00
        0101 11110
          ;; ((expr cdr) cdr)
          0101 1110 000010 000010
          ;; (cons x env)
          0101 0000000101101110110
            10
            110
      ;; otherwise it's a function application
      01
        ;; the function, interpreted
        0101 1110
          010101 110 000010 000010 0000110
          10
        ;; the argument, interpreted
        0101 1110
          010101 110 000010 000010 000010
          10
    ;; otherwise it's a number, interpreted as an identifier
    0101
      ;; ((expr cdr) rest)
      ;; (n rest)
      01 01 110 000010
        0001 10 000010
      0101 0000000101101110110
        0010
        10
      0000110

#|
  (require binary-lambda-calculus/lc-utils/lc-utils
           binary-lambda-calculus/lc-utils/pair
           (only-in lazy λ define quote))
  (define 1-term
    (cons 1-bit (λ (f) (λ (x) (f x)))))
  (define 2-term
    (cons 1-bit (λ (f) (λ (x) (f (f x))))))
  ((this 1-term) (stream 'hello))        ; 'hello
  ((this 2-term) (stream 'hello 'world)) ; 'world
  
  (define id
    ((this (cons 0-bit (cons 0-bit (cons 1-bit (λ (f) (λ (x) (f x))))))) 'empty))
|#
