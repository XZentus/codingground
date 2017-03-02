(asdf:load-system 'cl-fad)
(asdf:load-system 'cffi)

(cffi:load-foreign-library "user32.dll")

(defparameter +file-ini+ "backup.ini")

(defun trim-return (str)
  (string-trim (string #\return) str))

(defvar logs)
(defvar *from*)
(defvar *to*)
(defvar files)

(defun read-params (ini)
  (with-open-file (params ini :direction :input)
    (setf *from* (trim-return (read-line params nil)))
    (setf *to*   (trim-return (read-line params nil)))
    (setf files  (loop for     file = (read-line params nil)
                               while   file
                               collect (trim-return file)))))

(defun main ()
  (read-params +file-ini+)
  (setf logs (list (format nil "Copying из ~a в ~a~%" *from* *to*)))
  (loop for x in files do
    (let ((from (concatenate 'string *from* x))
          (to   (concatenate 'string *to*   x)))
      (cond
        ((cl-fad:file-exists-p from)
          (setf logs (nconc logs (list
            (format nil "~a ~a~%" x
                                  (if (cl-fad:file-exists-p to)
                                      "rewritten"
                                      "copied")))))
          (cl-fad:copy-file from to :overwrite t))
        (t
          (setf logs (nconc logs (list (format nil "~a doesn't exist, ignored~%" x))))))))
  (cffi:foreign-funcall "MessageBoxW"
    :pointer (cffi:null-pointer)
    (:string :encoding :utf-16le) (format nil "~{~A~}" logs)
    (:string :encoding :utf-16le) "Backup"
    :int #x40
    :boolean))
