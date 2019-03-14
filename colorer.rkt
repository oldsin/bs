#lang racket/base
(require brag/support syntax-color/racket-lexer)

(define bs-lexer
  (lexer
   [(eof) (values lexeme 'eof #f #f #f)]

   [(:seq "OP_"
          (:+ (:or (char-range #\0 #\9)
                   (char-range #\A #\Z)
                   (char-range #\a #\z))))
    (values lexeme 'symbol #f
            (pos lexeme-start) (pos lexeme-end))]

   [(:+ (char-range #\0 #\9))
    (values lexeme 'constant #f
            (pos lexeme-start) (pos lexeme-end))]

   [(:seq "0x" (:+ (:or (char-range #\0 #\9)
                        (char-range #\A #\F)
                        (char-range #\a #\f))))
    (values lexeme 'constant #f
            (pos lexeme-start) (pos lexeme-end))]

   ["0x"
    (values lexeme 'error #f
            (pos lexeme-start) (pos lexeme-end))]

   [(from/to "#" "\n")
    (values lexeme 'comment #f
            (pos lexeme-start) (pos lexeme-end))]

   [(from/to "<" ">")
    (values lexeme 'comment
            (if (equal? lexeme "<")
                '|(|
                '|)|)
            (pos lexeme-start) (pos lexeme-end))]
   
   [any-char
    (values lexeme 'symbol #f
            (pos lexeme-start) (pos lexeme-end))]))

(define (color-bs port offset racket-coloring-mode?)
  (define-values (str cat paren start end)
    (bs-lexer port))
  (values str cat paren start end 0 #f))

(provide color-bs)