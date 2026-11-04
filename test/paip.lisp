(defpackage #:paip/test/paip
  (:use #:cl #:fiveam #:paip))
(in-package #:paip/test/paip)

(def-suite :paip)
(in-suite :paip)

(test fib-test
  (is (= (fib 10) 55)))

(test pat-match1
  (is (equal (pat-match '(?x = 1) '(1 = 1))
             '((?x . 1))))

  (is (equal (pat-match '(?x (?or < = >) ?y) '(3 < 4))
             '((?y . 4) (?x . 3)))))

(test pat-match-segment
  (is (equal (pat-match '((?* ?p) need (?* ?x))
                        '(mr hulot and i need a vacation))
             '((?x a vacation) (?p mr hulot and i))))

  (is (null (pat-match '(?x is ?x) '(2 is 3)))))
