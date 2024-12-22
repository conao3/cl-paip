(defpackage #:paip/test/paip
  (:use #:cl #:fiveam #:paip))
(in-package #:paip/test/paip)

(def-suite :paip)
(in-suite :paip)

(test fib-test
  (is (= (fib 10) 55)))

(test pat-match1
  (is (equal (pat-match '(?x = 1) '(1 = 1))
             '((paip::?X . 1))))

  (is (equal (pat-match '(?x (?or < = >) ?y) '(3 < 4))
             '((paip::?Y . 4) (paip::?X . 3)))))
