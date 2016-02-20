#lang racket/base

(provide BLC-lambda
         BLC-var
         )

(require (for-syntax racket/base
                     racket/syntax
                     syntax/parse))
(module+ test
  (require rackunit))

(begin-for-syntax
  (define (subst n arg-id body)
    (syntax-parse body #:literals (BLC-var BLC-lambda)
      [(BLC-var i:nat)
       (cond
         [(= (syntax-e #'i) n)
          (datum->syntax arg-id (syntax-e arg-id) body arg-id)]
         [else
          body])]
      [(blc-lambda:BLC-lambda b:expr)
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

(define-syntax BLC-lambda
  (lambda (stx)
    (syntax-parse stx
      [(BLC-lambda body:expr)
       #:with x* (generate-temporary)
       #:with x (syntax-property
                 (datum->syntax #'x* (syntax-e #'x*) #'BLC-lambda #'BLC-lambda)
                 'original-for-check-syntax #t)
       (quasisyntax/loc stx
         (lambda (x)
           #,(subst 1 #'x #'body)))])))

(define-syntax BLC-var
  (lambda (stx)
    (raise-syntax-error #f "unbound identifier" stx)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(module+ test
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
