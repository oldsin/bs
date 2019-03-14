#lang racket/base
(require parser-tools/lex
         "lexer.rkt")

(provide color-lexer)

(define (color-lexer in offset mode)
  ;; Get next token:
  (define tok (lex in))
  ;; Package classification with srcloc:
  (define (ret mode paren [eof? #f])
    (values (if eof?
                eof
                (token->string (position-token-token tok)
                               (token-value (position-token-token tok))))
            mode 
            paren
            (position-offset (position-token-start-pos tok))
            (position-offset (position-token-end-pos tok))
            0 
            #f))
  ;; Convert token to classification:
  (case (token-name (position-token-token tok))
    [(EOF) (ret 'eof #f #t)]
    [(WHITESPACE) (ret 'white-space #f)]
    [(OPPUSHDATA) (ret 'keyword #f)]
    [(OPCODE) (ret 'keyword #f)]
    [(HEX) (ret 'string #f)]
    [(DEC) (ret 'string #f)]
    [(COMMENT) (ret 'comment #f)]
    [(ERROR) (ret 'error #f)]
    [else (ret 'other #f)]))
