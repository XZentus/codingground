(defun hamming-distance (str1 str2 &optional verboze)
  (let* ((distance 0)
         (l1 (length str1))
         (l2 (length str2))
         (maxlen (max l1 l2))
         (minlen (min l1 l2))
         (diff   (- maxlen minlen))
         (positions (make-string maxlen :initial-element #\^)))
     (loop for position from 0
           for x across str1
           for y across str2
       do (if (eq x y)
              (setf (aref positions position) #\ )
              (progn
                (when verboze (format t "Pos ~a: ~a <-> ~a~%" (1+ position) x y))
                (incf distance))))
     (cons (+ distance diff) positions)))

(defparameter strlen 30)
(defparameter change-probability 0.1)

(defun test ()
  (defparameter str1 (make-string strlen))
  (defparameter str2 (make-string strlen))
  (defun generate-random-char (from to)
    (code-char (+ from (random (- to from)))))
  (setf *random-state* (make-random-state t))
  (dotimes (i strlen)
    (let* ((c (generate-random-char 33 127))
           (r (random 1.0))
	   (n (if (< r change-probability)
	          (generate-random-char 33 127)
                  c)))
      (setf (aref str1 i) c)
      (setf (aref str2 i) n)))
  (write-line "Test #1 verboze off")
  (let ((result (hamming-distance str1 str2)))
    (format t "~%Hamming distance = ~a~%~%~a~%~a~%~a~%~%"
            (car result) str1 str2 (cdr result)))
  (write-line "Test #2 verboze on")
  (let ((result (hamming-distance str1 str2 t)))
    (format t "~%Hamming distance = ~a~%~%~a~%~a~%~a~%"
            (car result) str1 str2 (cdr result))))
