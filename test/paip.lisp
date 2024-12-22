(defpackage #:paip/test/paip
  (:use #:cl #:fiveam #:paip))
(in-package #:paip/test/paip)

(def-suite :paip)
(in-suite :paip)

(test fib-test
  (is (fib 10) 55))
