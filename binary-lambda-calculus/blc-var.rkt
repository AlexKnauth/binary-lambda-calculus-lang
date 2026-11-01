#lang racket/base

(provide BLC-var)

(require (for-syntax racket/base))

(define-syntax BLC-var
  (lambda (stx)
    (raise-syntax-error #f "unbound identifier" stx)))
