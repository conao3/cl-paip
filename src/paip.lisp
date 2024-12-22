(defpackage #:paip/src/paip
  (:nicknames #:paip)
  (:use #:cl)
  (:export #:main #:fib))
(in-package #:paip)

(defun fib (n)
  (if (<= n 2)
    1
    (+ (fib (- n 2)) (fib (- n 1)))))

(defun main ()
  (let ((args uiop:*command-line-arguments*))
    (format t "args: ~{~a~^ ~}~%" args)
    (let ((n (parse-integer (first args))))
      (format t "fib(~a) = ~a~%" n (fib n))
      (uiop:quit 0))))
