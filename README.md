binary-lambda-calculus-lang
===
A racket `#lang` for binary lambda-calculus, based on https://en.wikipedia.org/wiki/Binary_lambda_calculus#Lambda_encoding.

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

## Binary Lambda Calculus Cookbook

### `let`

A `let` expression like:
```racket
(let ([x a])
  b)
```

Can be expressed as an application of a `lambda` expression:
```racket
((lambda (x)
   b)
 a)
```

And written like this in BLC:
```racket
0100 ; declare x
  B ; b
A ; x = a
```

Where `B` can contain `10` to refer to `x`.

The generalization for multiple `let` bindings is

```racket
010101000000 ; declare x y z
  D ; d
A ; x = a
B ; y = b
C ; z = c
```

Where `B` can contain `10` to refer to `z`, `110` to refer to `y`, and `1110` to refer to `x`.

### recursion with `Y`

The standard Y combinator for a lazy lambda calculus is:
```racket
(lambda (f)
  ((lambda (g) (g g))
   (lambda (g) (f (g g)))))
```

Which can be written like this in BLC:
```racket
00               ; Y f =
  01             ;  (
    00           ;   (λ g.
      01 10 10   ;     g g)
    00           ;   (λ g.
      01 110     ;     f
        01 10 10 ;       (g g)))
```

And shortened to this without whitespace:
```racket
0001000110100001110011010 ; Y f = (λg.g g) (λg.f (g g))
```

You can combine the `let` pattern and the recursion with `Y` pattern to define a recursive function:
```racket
0100 ; declare Y
  01100000 ; f x =
    B      ; b
0001000110100001110011010 ; Y f = (λg.g g) (λg.f (g g))
```

Where `B` can contain `10` to refer to `x`, and `110` to refer to `f` for a recursive call.

Nest a multi-binding `let` pattern inside that to define multiple recursive functions:
```racket
0100 ; declare Y
  010101000000 ; delare f g h
    D ; d
  01100000 ; f x =
    A      ; a
  01100000 ; g x =
    B      ; b
  01100000 ; h x =
    C      ; c
0001000110100001110011010 ; Y f = (λg.g g) (λg.f (g g))
```

Where `D` can refer to `f`, `g`, and `h` as `1110`, `110`, and `10` respectively,
and `A` can refer to `x` as `10` and recur with `f` as `110`, and so on.

### Algebraic Data Types with Scott Encoding

An Algebraic Data Type like this:
```racket
data T
| A x y z
| B u v w
| C p q r

match v
| A x y z: ...
| B u v w: ...
| C p q r: ...
```

Can be expressed with a Scott encoding like this:
```racket
(define (A x y z) (λ (a b c) (a x y z)))
(define (B u v w) (λ (a b c) (b u v w)))
(define (C p q r) (λ (a b c) (b p q r)))

(v
  (λ (x y z) ...)
  (λ (u v w) ...)
  (λ (p q r) ...))
```

And expressed in BLC like this:
```racket
010101000000 ; declare A B C
  010101 V ; match v
    000000 ; | A x y z:
      ...  ;   ...
    000000 ; | B u v w:
      ...  ;   ...
    000000 ; | C p q r:
      ...  ;   ...
000000 000000 010101 1110 1111110 111110 11110  ; A x y z a b c = a x y z
000000 000000 010101 110 1111110 111110 11110   ; B u v w a b c = b u v w
000000 000000 010101 10 1111110 111110 11110    ; C p q r a b c = c p q r
```
