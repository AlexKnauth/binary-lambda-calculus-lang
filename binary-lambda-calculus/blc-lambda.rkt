#lang racket/base

(provide define-blc-lambda
         BLC-var
         )

(require "blc-var.rkt"
         (for-syntax racket/base
                     racket/syntax
                     syntax/parse))
(module+ test
  (require rackunit))

(begin-for-syntax
  (struct blc-lambda-transformer [lambda-id]
    #:property prop:procedure
    (lambda (self stx)
      (define lambda-id (blc-lambda-transformer-lambda-id self))
      (syntax-parse stx
        [(BLC-lambda body:expr)
         #:with x* (generate-temporary)
         #:with x (syntax-property
                   (datum->syntax #'x* (syntax-e #'x*) #'BLC-lambda #'BLC-lambda)
                   'original-for-check-syntax #t)
         (quasisyntax/loc stx
           (#,lambda-id
            (x)
            #,(subst 1 #'x #'body)))])))

  (define-syntax-class blc-lambda-id
    [pattern {~var x (static blc-lambda-transformer? "blc-lambda")}])

  (define (subst n arg-id body)
    (syntax-parse body #:literals (BLC-var)
      [(BLC-var i:nat)
       (cond
         [(= (syntax-e #'i) n)
          (datum->syntax arg-id (syntax-e arg-id) body arg-id)]
         [else
          body])]
      [(blc-lambda:blc-lambda-id b:expr)
       (datum->syntax body
         (list #'blc-lambda
               (subst (add1 n) arg-id #'b))
         body
         body)]
      [(f:expr arg:expr)
       (datum->syntax body
         (list (subst n arg-id #'f)
               (subst n arg-id #'arg))
         body
         body)]
      [id:id #'id])))

(define-syntax define-blc-lambda
  (lambda (stx)
    (syntax-parse stx
      [(define-BLC-lambda x:id lam:id)
       #'(define-syntax x (blc-lambda-transformer #'lam))])))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(module+ test
  (define-blc-lambda BLC-lambda lambda)

  (define identity
    (BLC-lambda (BLC-var 1)))

  (check-equal? (identity 27) 27)
  
  (define fst
    (BLC-lambda (BLC-lambda (BLC-var 2))))
  (define snd
    (BLC-lambda (BLC-lambda (BLC-var 1))))
  
  (define pair
    (BLC-lambda (BLC-lambda (BLC-lambda (((BLC-var 1) (BLC-var 3)) (BLC-var 2))))))
  
  (check-equal? (((pair 1) 2) fst) 1)
  (check-equal? (((pair 1) 2) snd) 2)
  )
