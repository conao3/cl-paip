(defpackage #:paip/src/paip
  (:nicknames #:paip)
  (:use #:cl)
  (:export #:main #:fib #:pat-match #:no-bindings
           #:?is #:?or #:?and #:?not #:?* #:?+ #:?? #:?if))
(in-package #:paip)

(defun fib (n)
  (if (<= n 2)
    1
    (+ (fib (- n 2)) (fib (- n 1)))))

(defun hello ()
  (print "asdf"))

(defconstant fail nil)

(defvar no-bindings '((t . t)))

(defun variable-p (x)
  (and (symbolp x) (equal (elt (symbol-name x) 0) #\?)))

(defun get-binding (var bindings)
  (assoc var bindings))

(defun binding-val (binding)
  (cdr binding))

(defun lookup (var bindings)
  (binding-val (get-binding var bindings)))

(defun extend-bindings (var val bindings)
  (cons (cons var val)
        (if (eq bindings no-bindings)
            nil
            bindings)))

(defun match-variable (var input bindings)
  (let ((binding (get-binding var bindings)))
    (cond ((not binding) (extend-bindings var input bindings))
          ((equal input (binding-val binding)) bindings)
          (t fail))))

(setf (get '?is 'single-match) 'match-is)
(setf (get '?or 'single-match) 'match-or)
(setf (get '?and 'single-match) 'match-and)
(setf (get '?not 'single-match) 'match-not)

(setf (get '?* 'segment-match) 'segment-match)
(setf (get '?+ 'segment-match) 'segment-match+)
(setf (get '?? 'segment-match) 'segment-match?)
(setf (get '?if 'segment-match) 'match-if)

(defun segment-pattern-p (pattern)
  (and (consp pattern) (consp (first pattern))
       (symbolp (first (first pattern)))
       (segment-match-fn (first (first pattern)))))

(defun single-pattern-p (pattern)
  (and (consp pattern)
       (single-match-fn (first pattern))))

(defun segment-matcher (pattern input bindings)
  (funcall (segment-match-fn (first (first pattern)))
           pattern input bindings))

(defun single-matcher (pattern input bindings)
  (funcall (single-match-fn (first pattern))
           (rest pattern) input bindings))

(defun segment-match-fn (x)
  (when (symbolp x) (get x 'segment-match)))

(defun single-match-fn (x)
  (when (symbolp x) (get x 'single-match)))

(defun match-is (var-and-pred input bindings)
  (let* ((var (first var-and-pred))
         (pred (second var-and-pred))
         (new-bindings (pat-match var input bindings)))
    (if (or (eq new-bindings fail)
            (not (funcall pred input)))
        fail
        new-bindings)))

(defun match-and (patterns input bindings)
  (cond ((eq bindings fail) fail)
        ((null patterns) bindings)
        (t (match-and (rest patterns) input
                      (pat-match (first patterns) input bindings)))))

(defun match-or (patterns input bindings)
  (if (null patterns)
      fail
      (let ((new-bindings (pat-match (first patterns) input bindings)))
        (if (eq new-bindings fail)
            (match-or (rest patterns) input bindings)
            new-bindings))))

(defun match-not (patterns input bindings)
  (if (match-or patterns input bindings)
      fail
      bindings))

(defun first-match-pos (pat1 input start)
  (cond ((and (atom pat1) (not (variable-p pat1)))
         (position pat1 input :start start :test #'equal))
        ((<= start (length input)) start)
        (t nil)))

(defun segment-match (pattern input bindings &optional (start 0))
  (let ((var (second (first pattern)))
        (pat (rest pattern)))
    (if (null pat)
        (match-variable var input bindings)
        (let ((pos (first-match-pos (first pat) input start)))
          (if (null pos)
              fail
              (let ((b2 (pat-match pat (subseq input pos)
                                   (match-variable var (subseq input 0 pos)
                                                   bindings))))
                (if (eq b2 fail)
                    (segment-match pattern input bindings (+ pos 1))
                    b2)))))))

(defun segment-match+ (pattern input bindings)
  (segment-match pattern input bindings 1))

(defun segment-match? (pattern input bindings)
  (let ((var (second (first pattern)))
        (pat (rest pattern)))
    (or (pat-match (cons var pat) input bindings)
        (pat-match pat input bindings))))

(defun match-if (pattern input bindings)
  (and (progv (mapcar #'car bindings)
           (mapcar #'cdr bindings)
         (eval (second (first pattern))))
       (pat-match (rest pattern) input bindings)))

(defun pat-match (pattern input &optional (bindings no-bindings))
  (cond ((eq bindings fail) fail)
        ((variable-p pattern)
         (match-variable pattern input bindings))
        ((eql pattern input) bindings)
        ((segment-pattern-p pattern)
         (segment-matcher pattern input bindings))
        ((single-pattern-p pattern)
         (single-matcher pattern input bindings))
        ((and (consp pattern) (consp input))
         (pat-match (rest pattern) (rest input)
                    (pat-match (first pattern) (first input)
                               bindings)))
        (t fail)))

(defun main ()
  (let ((args uiop:*command-line-arguments*))
    (format t "args: ~{~a~^ ~}~%" args)
    (let ((n (parse-integer (first args))))
      (format t "fib(~a) = ~a~%" n (fib n))
      (uiop:quit 0))))
