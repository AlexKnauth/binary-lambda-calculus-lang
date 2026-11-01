#lang binary-lambda-calculus/lazy
010101000000 ; declare Y add1 cons
  01010000 ; declare + <
    01010000 ; declare ints-from diff
      0100 ; declare sieve
        0110                            ; sieve
          01011110                      ;   (ints-from
            011111111001111111100000110 ;     2
            01111111100000110           ;     1)
      01111111100000 ; sieve l =
        010110       ; match l
          0000110    ; | empty: empty
          0000       ; | cons lf lr:
            01011111111110110           ; cons lf
              0111110                   ;   (sieve
                010111111010            ;     (diff lr
                  01011111110           ;       (ints-from
                    0101111111110110110 ;         (+ lf lf)
                    110                 ;         lf)))
    01111110000000        ; ints-from i d =
      01011111110110      ; cons i
        01011110          ;   (ints-from
          010111111010110 ;     (+ d i)
          10              ;     d)
    01111110000000 ; diff a b =
      0101110      ; match a
        0000110    ; | empty: empty
        0000       ; | cons af ar:
          01011110  ;   match b
            0000110 ;   | empty: empty
            0000    ;   | cons bf br:
              0101010111111111011110110   ; if (< af bf)
                01011111111111011110      ; | cons af
                  0101111111101110111110  ;     (diff ar b)
                0101010111111111011011110 ; | if (< bf af)
                  010111111110111111010   ;   | diff a br
                  010111111110111010      ;   | diff ar br
  011110000000 ; + a b =
    0101110    ; match a
      10       ; | 0: b
      00       ; | add1 am1:
        01011111010011111110110 ; + am1 (add1 b)
  011110000000    ; < a b =
    010110        ; match b
      000010      ; | 0: false
      00          ; | add1 bm1:
        01011110  ;   match a
          0000110 ;   | 0: true
          00      ;   | add1 am1:
            010111111010110 ; < am1 bm1
0001000110100001110011010 ; Y f = (λg.g g) (λg.f (g g))
00000001101110 ; add1 n z s = s n
00000000010110111101110 ; cons f r e c = c f r

#|
(require (only-in lazy define λ take !! quote) (prefix-in rkt: lazy))
(define (((iterate n) z) s)
  ((n z) (λ (m) (s (((iterate m) z) s)))))
(define (nat->rkt n) (((iterate n) 0) rkt:add1))
(define ((list->rkt elem->rkt) l)
  ((l '()) (λ (lf) (λ (lr) (rkt:cons (elem->rkt lf) ((list->rkt elem->rkt) lr))))))
(!! (take 25 ((list->rkt nat->rkt) this)))
|#
