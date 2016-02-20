#lang binary-lambda-calculus
;; This is a parser for binary-lambda-calculus, written in binary-lambda-calculus.
;; It groups the terms into a tree structure.
;; It returns a pair, where the car is the tree structure,
;; and the cdr is the rest of the bit stream
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
;; cons = 0000000101101110110
01
;; the Y combinator
000100011010000111000010111011010
00 00
  ;; if the next bit is a 0,
  0101 01 10 0000110
    ;; then if the next next bit is a 0,
    0101 0101 10 000010 0000110
      ;; it's a lambda expression
      0100 ; let x = recursive-call
        0101 0000000101101110110
          0101 0000000101101110110
            0000110
            0101 0000000101101110110
              0000110
              ;; (x car)
              01 10 0000110
          ;; (x cdr)
          01 10 000010
        ;; this is the body, a recursive call
        01 110
          0101 10 000010 000010
      ;; otherwise it's a function application
      10
    ;; otherwise it's a 1, parse it as a number
    0100 ; let n = parsed-number
      0101 0000000101101110110
        10
        ;; (rest (bits (n rest)))
        01 01 110 01 10 000010 000010
      ;; the parsed number
      01
        ;; from parse-unary-number.rkt
        01 000100011010000111000010111011010
           000001010110000011000001001000000011100101111011010011100110000010
        10

#|
  (require (only-in lazy λ define add1))
  (define 0-bit (λ (a) (λ (b) a)))
  (define 1-bit (λ (a) (λ (b) b)))
  (define (if a b c)
    ((a b) c))
  (define (cons fst rst)
    (λ (sel) (if sel fst rst)))
  (define car 0-bit)
  (define cdr 1-bit)
  (define parse-tree-identity
    ((this (cons
            0-bit
            (cons
             0-bit
             (cons
              1-bit
              (cons
               0-bit
               43)))))
     car))
  (if (parse-tree-identity car) 0 1) ; 0
  (if ((parse-tree cdr) car) 0 1)    ; 0
  ((((parse-tree cdr) cdr) add1) 0)  ; 2
|#
