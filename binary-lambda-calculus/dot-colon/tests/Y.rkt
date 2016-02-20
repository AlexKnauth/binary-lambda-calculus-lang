#lang binary-lambda-calculus/dot-colon
..                      ; (λ (f)
  .:                    ;   (#%app
    ..                  ;    (λ (g)
      .: :. :.          ;      (g g))
    ..                  ;    (λ (g)
      .:                ;      (#%app
        ::.             ;       f
        ..              ;       (λ (x)
          .:            ;         (#%app
            .: ::. ::.  ;          (g g)
            :.          ;          x))))))
