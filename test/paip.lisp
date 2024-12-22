(defpackage #:paip/test/paip
  (:use #:cl #:fiveam #:paip))
(in-package #:paip/test/paip)

(def-suite :paip)
(in-suite :paip)

(test fib-test
  (is (fib 10) 55))

(test pat-match1
      (is (pat-match '(?x (?or < = >) ?y) '(3 < 4))
          '((?Y . 4) (?X . 3))))
