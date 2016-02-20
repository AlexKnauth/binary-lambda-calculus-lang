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
      0100 ; let f = the-function
        0100 ; let a = the-argument
          0101 0000000101101110110
            0101 0000000101101110110
              0000110
              0101 0000000101101110110
                000010
                0101 0000000101101110110
                  ;; (f car)
                  01 110 0000110
                  ;; (a car)
                  01 10 0000110
            ;; (a cdr)
            01 10 000010
          ;; this is the argument, another recursive call
          01 1110
            ;; (f cdr)
            01 10 000010
        ;; this is the function, a recursive call
        01 110
          ;; ((bits cdr) cdr)
          0101 10 000010 000010
    ;; otherwise it's a 1, parse it as a number
    0100 ; let n = parsed-number
      0101 0000000101101110110
        0101 0000000101101110110
          000010
          10
        ;; (((n rest) bits) cdr)
        0101
          ;; (n rest)
          01 10 0001 10 000010
          110
          000010
      ;; the parsed number
      01
        ;; from parse-unary-number.rkt
        01 000100011010000111000010111011010
           000001010110000011000001001000000011100101111011010011100110000010
        10

#|
  (require (only-in lazy λ define quasiquote unquote !!)
           binary-lambda-calculus/lc-utils/lc-utils)
  (define (parse-tree->s-expr parse-tree)
    `dummy)
  (define (parse-tree->s-expr parse-tree)
    (if (if (parse-tree car) 0-bit 1-bit)
        (if ((parse-tree cdr) car)
            `(λ ,(parse-tree->s-expr ((parse-tree cdr) cdr)))
            `(,(parse-tree->s-expr (((parse-tree cdr) cdr) car))
              ,(parse-tree->s-expr (((parse-tree cdr) cdr) cdr))))
        (number->rkt:number (parse-tree cdr))))

  (define (parse->s-expr bits)
    (!! (parse-tree->s-expr ((this bits) car))))
  (parse->s-expr (stream 1-bit 0-bit))       ; 1
  (parse->s-expr (stream 1-bit 1-bit 0-bit)) ; 2

  (parse->s-expr (stream 0-bit 0-bit 1-bit 0-bit))
  ; '(λ 1)
  (parse->s-expr (stream 0-bit
                         0-bit
                         0-bit
                         0-bit
                         1-bit
                         1-bit
                         0-bit))
  ; '(λ (λ 2))
  (parse->s-expr (stream 0-bit
                         0-bit
                         0-bit
                         0-bit
                         1-bit
                         0-bit))
  ; '(λ (λ 1))
  (parse->s-expr (stream 0-bit
                         0-bit
                         0-bit
                         0-bit
                         0-bit
                         1-bit
                         1-bit
                         1-bit
                         0-bit
                         1-bit
                         0-bit))
  ; '(λ (λ (2 1)))
|#
