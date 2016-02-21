#lang plai-typed

(define-type BLC-Expr
  [BLC-lambda (body : BLC-Expr)]
  [BLC-app    (function : BLC-Expr) (argument : BLC-Expr)]
  [BLC-var    (index : number)]) ;; Positive-Integer

(define-type BLC-Value
  [BLC-closure (body : BLC-Expr) (env : Env)])

;; Env is a type that supports these values and operations:
;;  - env-empty : Env
;;  - env-lookup-var : Env Positive-Integer -> BLC-Value
;;  - env-extend : Env BLC-Value -> Env

(define-type-alias Env (listof BLC-Value))

(define env-empty (list))

(define (env-lookup-var env n)
  (list-ref env (sub1 n)))

(define (env-extend env v)
  (cons v env))

(define (interp expr env)
  (type-case BLC-Expr expr
    [BLC-var (n) (env-lookup-var env n)]
    [BLC-lambda (body) (BLC-closure body env)]
    [BLC-app (f a) (app (interp f env) (interp a env))]))

(define (app f a)
  (type-case BLC-Value f
    [BLC-closure (body env) (interp body (env-extend env a))]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(module+ test
  (define identity
    (interp (BLC-lambda
             (BLC-var 1))
            env-empty))

  (define true-value
    (interp (BLC-lambda
             (BLC-lambda
              (BLC-var 2)))
            env-empty))
  (define false-value
    (interp (BLC-lambda
             (BLC-lambda
              (BLC-var 1)))
            env-empty))

  (define if
    (interp (BLC-lambda
             (BLC-lambda
              (BLC-lambda
               (BLC-app (BLC-app (BLC-var 3) (BLC-var 2)) (BLC-var 1)))))
            env-empty))

  (test identity    (BLC-closure (BLC-var 1) env-empty))
  (test true-value  (BLC-closure (BLC-lambda (BLC-var 2)) env-empty))
  (test false-value (BLC-closure (BLC-lambda (BLC-var 1)) env-empty))

  (test (interp (BLC-var 1) (env-extend env-empty true-value)) true-value)
  (test (app identity false-value) false-value)
  (test (app (app (app if true-value) identity) false-value) identity)
  (test (app (app (app if false-value) identity) true-value) true-value)

  (define pair
    (interp (BLC-lambda
             (BLC-lambda
              (BLC-lambda
               (BLC-app (BLC-app (BLC-var 1) (BLC-var 3)) (BLC-var 2)))))
            env-empty))
  (define fst true-value)
  (define snd false-value)

  (test (app (app (app pair identity) true-value) fst) identity)
  (test (app (app (app pair identity) true-value) snd) true-value)
  )
