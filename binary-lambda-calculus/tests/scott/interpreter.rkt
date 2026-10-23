#lang binary-lambda-calculus
;; A Val is a [Val -> Val] function
;; A Nat is a Church Numeral
;; Zero = 000010                   ; (λ (s z) z)
;; Add1 = 000000011100101111011010 ; (λ (n s z) (s (n s z)))
;; An Expr is one of:
;;  - (Idx Nat)
;;  - (Lam Expr)
;;  - (App Expr Expr)
;; An Env is one of:
;;  - EmptyEnv
;;  - (EnvCons Val Env)
;; EmptyEnv = 0000110
;; EnvCons = 00000000010110111101110
;; EnvFirst = 0001011000100000110
;; EnvRest =  0001011010000010
01
  000100011010000111000010111011010 ; Y
  00 ; λ interp
    0000 ; λ expr env
      010101 110 ; match expr
        00 ; (Idx n)
          01
            0001011000100000110 ; EnvFirst
            0101
              10 ; n times:
              0001011010000010 ; EnvRest
              110 ; env
        00 ; (Lam body)
          00 ; λ a
          0101
            111110 ; interp
            110 ; body
            0101
              00000000010110111101110 ; EnvCons
              10 ; a
              1110 ; env
        0000 ; (App f a)
          01
            0101 111110 ; interp
              110 ; f
              1110 ; env
            0101 111110 ; interp
              10 ; a
              1110 ; env

#|
  (require (only-in racket/base λ #%app define))
  (define ((Zero s) z) z)
  (define (((Add1 n) s) z) (s ((n s) z)))
  (define ((((Idx n) idx) lam) app) (idx n))
  (define ((((Lam body) idx) lam) app) (lam body))
  (define (((((App f) a) idx) lam) app) ((app f) a))
  (define ((EmptyEnv mt) cns) mt)
  (define interp-id
    ((this
      (Lam (Idx Zero)))
     EmptyEnv))
  (interp-id 5)
  (define interp-true
    ((this
      (Lam (Lam (Idx (Add1 Zero)))))
     EmptyEnv))
  (define interp-false
    ((this
      (Lam (Lam (Idx Zero))))
     EmptyEnv))
  ((interp-true 5) 6)
  ((interp-false 5) 6)
|#
