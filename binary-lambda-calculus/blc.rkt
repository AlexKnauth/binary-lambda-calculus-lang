#lang racket/base

(provide BLC-lambda BLC-var
         #%module-begin #%top-interaction #%app #%datum
         require only-in
         )

(require syntax/parse/define
         (only-in racket/base [#%module-begin rkt:module-begin])
         "blc-lambda.rkt"
         (for-syntax racket/base
                     syntax/parse
                     ))

(define-simple-macro (#%module-begin form:expr)
  #:with this:id (datum->syntax #'form 'this)
  (rkt:module-begin
   (define this form)
   this))

