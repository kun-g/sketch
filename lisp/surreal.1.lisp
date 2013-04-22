(defvar *numbers* nil)

(defun sets-not-over-or-equal (leftSet rightSet)
  (not (remove-if-not #'(lambda (iter-right) ; rightSet中小于等于leftSet的集合
                 (remove-if-not #'(lambda (iter-left) ; leftSet中不小于iter-right的集合
                                (less-than-or-equal-to iter-left iter-right))
                            leftSet))
             rightSet)))

; Rule #1
; 数有左右集，凡左集之数，无出右集者
(defun rule-one (left right)
  (sets-not-over-or-equal right left))

; Rule #2
; 一数小于等于另一数
; 一数的左集无大于另一数者
; 另一数右集无小于等于一数者
(defun less-than-or-equal-to (x y)
  (and (sets-not-over-or-equal (car x) (list y)) ; x.left not over or equal to y
       (sets-not-over-or-equal (list x) (car (cdr y))))) ; x not over or equal to y.right

; Generate a new number
(defun new-number (left right)
  (if (rule-one left right)
    (push (list left right) *numbers*)))

(defun show-me-the-numbers ()
  (format t "====== Numbers ======~%")
  (format t "~a~%" *numbers*))

; Day 1
(new-number () ())


(show-me-the-numbers)









(defun test-case-generator (result answer)
  (if (eq result answer)
    (format t "Success~%")
    (format t "~a not equal to ~a~%" result answer)
    ))
(format t "====== Run test cases ======~%")
(test-case-generator (sets-not-over-or-equal () ()) t)
(test-case-generator (rule-one () ()) t)
(test-case-generator (less-than-or-equal-to 
                       (list () ())
                       (list () ()))
                       t)
