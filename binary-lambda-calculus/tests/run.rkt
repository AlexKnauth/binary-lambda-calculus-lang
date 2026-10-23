#lang binary-lambda-calculus
;; (Pairof a b) = ((a -> b -> c) -> c)
0101
  0000 ; [interp : (Term -> Env -> Value)] [parse : ((Streamof Bit) -> (Pairof Term (Streamof Bit)))]
    0000 ; [bits : (Streamof Bit)] [env : Env]
      0101
        11110       ; (Term -> Env -> Value)
        01
          01 1110 110 ; (Pairof Term (Streamof Bit))
          0000110       ; Term
        10              ; Env
                          ; Value
  ;; interp
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
  ;; parse
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
  (require binary-lambda-calculus/lc-utils/lc-utils
           binary-lambda-calculus/lc-utils/pair
           (only-in lazy define λ quote))
  ;((this (stream 1-bit 0-bit)) (stream 'hello))
|#
