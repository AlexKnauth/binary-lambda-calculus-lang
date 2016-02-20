#lang binary-lambda-calculus
;; A (Streamof a) is a function such that
;;  - (stream first) = the first element, of type a
;;  - (stream rest)  = the rest of the stream, of type (Streamof a)
;; where:
;;   first = 0000110 ; (λ (fst rst) fst)
;;   rest  = 000010  ; (λ (fst rst) rst)
;; A Bit is one of:
;;  - 0000110 ; (λ (a b) a), representing 0
;;  - 000010  ; (λ (a b) b), representing 1
;; A Number is one of:
;;  - 000010  ; (λ (f x) x), representing 0
;;  - 01<add1><Number>
;; add1 = 000000011100101111011010     ; (λ (n) (λ (f x) (f (n f x))))
01
;; the strict Y combinator with the extra lambda
000100011010000111000010111011010
;; takes f and a (Streamof Bit)
00 00
  ;; if the first of the stream of bits is a 0,
  0101 01 10 0000110
    ;; then return the number 0
    000010
    ;; otherwise it's a 1, so add1 to a recursive call on the rest
    01 000000011100101111011010
      01 110
        01 10 000010
#|
  (require (only-in lazy λ define add1))
  (define 0-bit (λ (a) (λ (b) a)))
  (define 1-bit (λ (a) (λ (b) b)))
  (define (stream-cons fst rst)
    (λ (sel) ((sel fst) rst)))
  (define n
    (this (stream-cons
           1-bit
           (stream-cons
            1-bit
            (stream-cons
             1-bit
             (stream-cons
              0-bit
              42))))))
  ((n add1) 0)
  ;; should return 3
|#
