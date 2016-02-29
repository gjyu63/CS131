(define helper-constant
  (lambda (x y)
    (cond
     [(equal? x y) x]
     [(and (equal? x #t) (eqv? y #f)) 'TCP]
     [(and (equal? x #f) (eqv? y #t)) '(not TCP)]
     [else (helper-cons4
	    'if 'TCP x y)])))

(define helper-quote
  (lambda (x y)
    (helper-constant x y)))

(define helper-lambda
  (lambda (x y)
    (cond
     [(equal? (cadr x) (cadr y))
      (helper-list x y)]
     [else (helper-constant x y)])))

(define helper-let
  (lambda (x y)
    (cond
     [(helper-bind-variabless (cadr x) (cadr y))
      (helper-list x y)]
     [else (helper-constant x y)])))

(define helper-list
  (lambda (x y)
    (cond
     [(null? x) '()]
     [(null? y) '()]
     [else
      (cons (compare-expr (car x) (car y))
	    (helper-list (cdr x) (cdr y)))])))

(define helper-bind-variabless
  (lambda (x y)
    (cond
     [(and (null? x) (null? y))]
     [(equal? (caar x) (caar y))
      (helper-bind-variabless (cdr x) (cdr y))]
     [else #f])))

(define helper-lateral
  (lambda (x y)
    (cond
     [(or (equal? (car x) 'if)
	  (equal? (car y) 'if)) #t]
     [(or (equal? (car x) 'quote)
	  (equal? (car y) 'quote)) #t]
     [(or (equal? (car x) 'lambda)
	  (equal? (car y) 'lambda)) #t]
     [(or (equal? (car x) 'let)
	  (equal? (car y) 'let)) #t]
     [else #f])))

(define compare-expr
  (lambda (x y)
    (if (and (list? x) (list? y))
	(if (equal? (length x) (length y))
	    (if (equal? (car x) (car y))
		(case (car x)
		  ('quote (helper-quote x y))
		  ('let (helper-let x y))
		  ('lambda (helper-lambda x y))
		  (else (helper-list x y)))
		(if (helper-lateral x y)
		    (helper-constant x y)
		    (helper-list x y)))
	    (helper-constant x y))
	(helper-constant x y))))

(define helper-cons4
  (lambda (a b c d)
    (cons a (cons b (cons c (cons d '()))))))

(define TCP-binding
  (lambda (x bool)
    (if (equal? bool #t)
	(cons 'let (cons '((TCP #t)) (cons x '())))
	(cons 'let (cons '((TCP #f)) (cons x '()))))))

(define test-compare-expr
  (lambda (x y)
    (if (and (equal? (eval (TCP-binding (compare-expr x y) #t)) (eval x))
	     (equal? (eval (TCP-binding (compare-expr x y) #f)) (eval y)))
	#t
	#f)))

(define test-x
  '(if #t 
       (let ([a 1] [b 0]) 
	 ((lambda (a b)
	    (cdr (cons (cons (* a b) (+ a b)) a)))
	  a b))
       (let ([c 3] [d 5]) 
	 ((lambda (c d)
	    (+ (+ (+ c d) (+ c d)) (+ (+ c d) (+ c d))))
	  c d))))

(define test-y
  '(if #f
       (let ([a 2] [b 10]) 
	 ((lambda (a b)
	    (cdr (cons (cons (/ a b) (- a b)) a)))
	  a b))
       (let ([c 3] [d 5]) 
	 ((lambda (c d)
	    (- (- (- c d) (- c d)) (- (- c d) (- c d))))
	  c d))))

(test-compare-expr test-x test-y)

;; ;; specification tests
;; (compare-expr 12 12)  ; √	 ===>  12 
;; (compare-expr 12 20)  ; √	 ===>  (if TCP 12 20)
;; (compare-expr #t #t)  ; √	 ===>  #t
;; (compare-expr #f #f)  ; √	 ===>  #f
;; (compare-expr #t #f)  ; √	 ===>  TCP
;; (compare-expr #f #t)  ; √	 ===>  (not TCP)
;; (compare-expr 'a '(cons a b))  ; ===>  (if TCP a (cons a b))
;; (compare-expr '(cons a b) '(cons a b))
;; 	; ===>  (cons a b) √
;; (compare-expr '(cons a b) '(cons a c))
;; 	; ===>  (cons a (if TCP b c))
;; (compare-expr
;;  '(cons (cons a b) (cons b c))
;;  '(cons (cons a c) (cons a c)))
;; 	; ===> (cons (cons a (if TCP b c)) (cons (if TCP b a) c))
;; (compare-expr '(cons a b) '(list a b))
;; 	; ===>  ((if TCP cons list) a b)
;; (compare-expr '(list) '(list a))
;; 	; ===>  (if TCP (list) (list a))
;; (compare-expr ''(a b) ''(a c))
;; 	; ===>  (if TCP '(a b) '(a c))
;; (compare-expr ''(a b) ''(a c))
;; 	; ===>  (if TCP '(a b) '(a c))
;; (compare-expr '(quote (a b)) '(quote (a c)))
;; 	; ===>  (if TCP '(a b) '(a c))
;; (compare-expr '(quoth (a b)) '(quoth (a c)))
;; 	; ===>  (quoth (a (if TCP b c)))
;; (compare-expr '(if x y z) '(if x z z))
;; 	; ===>  (if x (if TCP y z) z)
;; (compare-expr '(if x y z) '(g x y z))
;; 	; ===> (if TCP (if x y z) (g x y z))
;; (compare-expr '(let ((a 1)) (f a)) '(let ((a 2)) (g a)))
;; 	; ===> (let ((a (if TCP 1 2))) ((if TCP f g) a))
;; (compare-expr '(+ #f (let ((a 1) (b 2)) (f a b)))
;;               '(+ #t (let ((a 1) (c 2)) (f a c))))
;; 	; ===> (+
;; 		; (not TCP)
;; 		; (if TCP
;; 			; (let ((a 1) (b 2)) (f a b))
;; 			; (let ((a 1) (c 2)) (f a c))))
;; (compare-expr '((lambda (a) (f a)) 1) '((lambda (a) (g a)) 2))
;; 	;  ===> ((lambda (a) ((if TCP f g) a)) (if TCP 1 2))
;; (compare-expr '((lambda (a b) (f a b)) 1 2)
;;               '((lambda (a b) (f b a)) 1 2))
;;   ;; ===> ((lambda (a b) (f (if TCP a b) (if TCP b a))) 1 2)
;; (compare-expr '((lambda (a b) (f a b)) 1 2)
;;               '((lambda (a c) (f c a)) 1 2))
;;   ;; ===> ((if TCP (lambda (a b) (f a b))
;;   ;; 		(lambda (a c) (f c a)))
;;   ;; 	1 2)
