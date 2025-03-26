#lang racket

(define (format1dp n)
  (number->string (/ (round (* n 10)) 10.0)))

(define ns (make-base-namespace))

(displayln "Hesap Makinesi Yorumlayıcısına Hoşgeldiniz!")
(displayln "Çıkmak için 'exit' yazınız!")

(let loop ()
  (display "> ")
  (flush-output)
  (define input (read-line))
  (if (or (equal? input "exit") (eof-object? input))
      (begin
        (displayln "Çıkılıyor...")
        (void))
      (begin
        (with-handlers ([exn:fail?
                          (lambda (exn)
                            (displayln (exn-message exn)))])
          (if (regexp-match #px"^\\s*([a-z][a-z0-9]*)\\s*=\\s*(.+)$" input)
              (let* ([match (regexp-match #px"^\\s*([a-z][a-z0-9]*)\\s*=\\s*(.+)$" input)]
                     [var (list-ref match 1)]
                     [expr-str (list-ref match 2)]
                     [expr (read (open-input-string expr-str))])
                (parameterize ([current-namespace ns])
                  (eval `(define ,(string->symbol var) ,expr)))
                (displayln (string-append var " tanımlandı.")))
              (parameterize ([current-namespace ns])
                (let ([result (eval (read (open-input-string input)))])
                  (displayln (string-append "Sonuç: " (format1dp (exact->inexact result)))))))
        (loop)))))
