#lang binary-lambda-calculus
000000
  01 1110 01 110 10

#|
  (require (only-in lazy number->string string->symbol))
  (((this string->symbol) number->string) 5)
  ; '|5|
|#
