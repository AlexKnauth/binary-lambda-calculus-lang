binary-lambda-calculus-lang
===
A racket `#lang` for binary lambda-calculus.

Example:

```racket
#lang binary-lambda-calculus
00                      ; (λ (f)
  01                    ;   (#%app
    00                  ;    (λ (g)
      01 10 10          ;      (g g))
    00                  ;    (λ (g)
      01                ;      (#%app
        110             ;       f
        00              ;       (λ (x)
          01            ;         (#%app
            01 110 110  ;          (g g)
            10          ;          x))))))
```
