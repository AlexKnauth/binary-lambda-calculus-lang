#lang binary-lambda-calculus
00                ; (λ (f)
  01              ;   (#%app
    00            ;    (λ (g)
      01 10 10    ;      (g g))
    00            ;    (λ (g)
      01          ;      (#%app
        110       ;       f
        01 10 10  ;       (g g)))))

#|
  (require (only-in lazy define λ if zero? * sub1))
  (define factorial
    (this (λ (fact)
            (λ (n)
              (if (zero? n)
                  1
                  (* n (fact (sub1 n))))))))
  (factorial 0)
  (factorial 1)
  (factorial 2)
  (factorial 3)
  (factorial 4)
  (factorial 5)
  (factorial 6)
|#
