(format t "Ex.1.3~%")
(defun square (a)
  (* a a))
(defun f1.3 (a b c)
  (defun f.1.3 (a b)
    (+ (square a) (square b)))
  (cond ((= (min a b c) a) (+ (f.1.3 b c)))
        ((= (min a b c) b) (+ (f.1.3 a c)))
        (else (+ (f.1.3 b a)))))
(format t "~d~%" (f1.3 1 2 3))
