#lang racket/gui

(define log '())

(define (str->path x) (string->path (string-trim x)))

(define (parse commands)
  (define from (string->path "."))
  (define to   (string->path "."))
  (do ((iterator commands (cdr iterator)))
    ((null? iterator))
    (let ((elem (car iterator)))
    (cond
      ((equal? elem "from")       
       (set! iterator (cdr iterator))
       (set! from (str->path (car iterator))))
      ((equal? elem "to")
       (set! iterator (cdr iterator))
       (set! to (str->path (car iterator))))
      ((non-empty-string? elem)
       (define from-path (build-path from (str->path elem)))
       (define to-path   (build-path to   (str->path elem)))
       (cond
         ((file-exists? from-path)
          (copy-file from-path to-path #t)
          (set! log (cons (format "Скопирован: ~A -> ~A~%" from-path to-path) log)))
         (else
          (set! log (cons (format "Не существует: ~A~%" from-path) log)))))))))

(define (main)
  (set! log '())
  (define command-line (current-command-line-arguments))
  (define ini-path (str->path
                    (if (= (vector-length command-line) 1)
                        (vector-ref command-line 1)
                        "bak.ini")))
                    
  (define commands (file->lines ini-path))
  (parse commands)
  (message-box "Backup"
               (apply string-append log)
               #f
               '(ok no-icon)))