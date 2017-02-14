#lang racket

(define (hamming-distance str1 str2 [verboze #f])
  (let* ((distance 0)
         (l1 (string-length str1))
         (l2 (string-length str2))
         (maxlen (max l1 l2))
         (minlen (min l1 l2))
         (diff   (- maxlen minlen))
         (positions (make-string maxlen #\^)))
     (for ((position (in-naturals))
           (x str1) (y str2))
       (if (char=? x y)
           (string-set! positions position #\ )
           (begin
             (when verboze
                   (printf "At pos ~a: ~a <-> ~a~%" (add1 position) x y))
             (set! distance (add1 distance)))))
     (cons (+ distance diff) positions)))

(define strlen 50)
(define change-probability 0.1)

(define (test)
  (define str1 (make-string strlen))
  (define str2 (make-string strlen))
  (define (generate-random-char)
    (integer->char (+ 33 (random (- 127 33)))))
  (for ((i (in-range strlen)))
    (let* ((c (generate-random-char))
           (r (random 100))
           (n (if (< r (* change-probability 100))
                  (generate-random-char)
                  c)))
      (string-set! str1 i c)
      (string-set! str2 i n)))
  (displayln "Test #1 verboze off")
  (let ((result (hamming-distance str1 str2)))
    (printf "~%Hamming distance = ~a~%~%~a~%~a~%~a~%~%"
            (car result) str1 str2 (cdr result)))
  (displayln "Test #2 verboze on")
  (let ((result (hamming-distance str1 str2 #t)))
    (printf "~%Hamming distance = ~a~%~%~a~%~a~%~a~%"
            (car result) str1 str2 (cdr result))))
