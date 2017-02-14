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
                (when verboze (format t "At pos ~a: ~a <-> ~a~%" (1+ position) x y))
                (incf distance))))
     (cons (+ distance diff) positions)))

(defun test ()
  (let* ((str1 "ghsdkgughrghsdasd   fasdfasdfasdasdfasdfasdf")
         (str2 "shsDKheghd5234532asdfasdfasdfasdasfasdfasdfasrt3434")
         (result (hamming-distance str1 str2)))
    (format t "~%Hamming distance = ~a~%~%" (car result))
    (write-line str1)
    (write-line str2)
    (write-line (cdr result))))
(test)