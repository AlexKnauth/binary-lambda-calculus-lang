#lang racket

(provide make-BLC-readtable
         make-wrapper1
         )

(require syntax/readerr
         syntax/parse
         syntax/strip-context
         "blc-lambda.rkt")
(module+ test
  (require rackunit))

;; A BLC-Expr is one of:
;;  - 00<BLC-Expr_0>, parsed as (BLC-lambda BLC-Expr_0)
;;  - 01<BLC-Expr_0><BLC-Expr_1>, parsed as (BLC-Expr_0 BLC-Expr_1)
;;  - <BLC-Var_0>, parsed as (BLC-var BLC-var_0)
;; A BLC-Var is one of:
;;  - 10, parsed as 1
;;  - 1<BLC-Var_0>, parsed as the value of (add1 BLC-Var_0)

(define (make-BLC-readtable 0-char 1-char)
  (make-readtable
   #f
   0-char 'terminating-macro (make-0-proc 0-char 1-char)
   1-char 'terminating-macro (make-1-proc 0-char 1-char)))

(define ((make-wrap-reader 0-char 1-char) rd)
  (lambda args
    (parameterize ([current-readtable (make-BLC-readtable 0-char 1-char)])
      (strip-context (apply rd args)))))

(define ((make-wrapper1 0-char 1-char) thunk)
  (((make-wrap-reader 0-char 1-char) thunk)))

(define (read-next src in)
  (define stx (read-syntax/recursive src in))
  (cond [(eof-object? stx)
         (define-values [line col pos]
           (port-next-location in))
         (raise-read-eof-error "expected a next expression"
                               src line col pos 1)]
        [(special-comment? stx)
         (read-next src in)]
        [else
         stx]))

(define ((make-0-proc 0-char 1-char) c in src line col pos)
  (define c2 (read-char in))
  (cond [(eof-object? c2)
         (raise-read-eof-error
          (format "expected either a `~a` or a `~a`"
                  0-char 1-char)
          src line col pos 1)]
        [(char=? c2 0-char)
         (with-syntax ([blc-lambda (datum->syntax #'BLC-lambda 'BLC-lambda (list src line col pos 2))])
           #`(blc-lambda #,(read-next src in)))]
        [(char=? c2 1-char)
         #`(#,(read-next src in)
            #,(read-next src in))]
        [else
         (raise-read-error (format "expected either a `~a` or a `~a`"
                                   0-char 1-char)
                           src line col pos 1)]))

(define (make-1-proc 0-char 1-char)
  (define (1-proc c in src line col pos)
    (define c2 (read-char in))
    (cond [(eof-object? c2)
           (raise-read-eof-error
            (format "expected either a `~a` or a `~a`"
                    0-char 1-char)
            src line col pos 1)]
          [(char=? c2 0-char)
           (syntax/loc (datum->syntax #f #f (list src line col pos 2))
             (BLC-var 1))]
          [(char=? c2 1-char)
           (define stx (read-syntax/recursive src in c2))
           (syntax-parse stx #:literals (BLC-var)
             [(BLC-var n-1-stx:nat)
              (define n-1
                (syntax-e #'n-1-stx))
              (datum->syntax stx (list #'BLC-var (add1 n-1))
                             (list src line col pos (+ 1 (syntax-span stx))))])]
          [else
           (raise-read-error (format "expected either a `~a` or a `~a`"
                                     0-char 1-char)
                             src line col pos 1)]))
  1-proc)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(module+ test
  (define wrap-reader (make-wrap-reader #\0 #\1))
  (define (rd str)
    ((wrap-reader read) (open-input-string str)))
  (check-equal? (rd "10") '(BLC-var 1))
  (check-equal? (rd "110") '(BLC-var 2))
  (check-equal? (rd "1110") '(BLC-var 3))
  (check-equal? (rd "0010") '(BLC-lambda (BLC-var 1)))
  )
