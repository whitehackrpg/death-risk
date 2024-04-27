(defstruct sit 
  av           ; attacker's attack value 
  (avkind 0)   ; 0 = regular roll, 1 = double+, -1 = double-
  df           ; defender's defense value
  hp           ; defendier's harm points
  (dammod 0)   ; modification to the damage die
  save         ; save value, highest of defender's SV and Tgh
  (savekind 0) ; 0 = regular roll, 1 = double+, -1 = double-
  (boss 0))    ; 0 = no bossfight, 1 = bossfight

(defun success (target defense dieroll)
  (cond ((= target dieroll) 2)
	((< defense dieroll (1+ target)) 1)
	(t 0)))

(defun roll (target defense kind)
  (if (zerop kind)
      (success target defense (d 20))
      (funcall (if (minusp kind)
		   #'min 
		   #'max) 
	       (success target defense (d 20))
	       (success target defense (d 20)))))

(defun damage (sit damdie)
  (let ((mult (roll (sit-av sit) (sit-df sit) (sit-avkind sit))))
    (unless (zerop mult)
      (let ((crittable (if (and (= mult 2)
				(<= damdie (+ 1 (sit-boss sit))))
			   (d 20)
			   0))
	    (raw (+ damdie (sit-dammod sit))))
      (values (+ (if (plusp raw)
		     (* raw mult)
		     mult)
		 (if (= crittable 14)
		     (d 6)
		     0))
	      crittable)))))

(defun d (n) (1+ (random n)))

(defun result (sit damdie no-save)
  (multiple-value-bind (damage crittable) (damage sit damdie)
    (cond ((null damage) 100)
	  ((= crittable 20) -100)
	  ((= crittable 19) -1)
	  ((= crittable 18) 0)
	  (t (let ((rem-hp (+ (- (sit-hp sit) damage)
			      (if (or no-save 
				      (zerop (roll (sit-save sit)
						   0
						   (sit-savekind sit))))
				  0
				  (d 6)))))
	       (cond ((<= rem-hp -10) -100)
		     ((<= rem-hp -2)
		      (if (zerop (roll (sit-save sit)
					 0
					 (sit-savekind sit)))
			  -100
			  (if (zerop (sit-boss sit))
			      rem-hp
			      1)))
		     (t rem-hp)))))))
		   
(defun death-risk (sit &key (times 10000000) (damsides 6) (no-save))
  (let ((live 0)
	(die 0)
	(knocked-out 0)
	(injured 0))
    (loop repeat times do
      (let ((outcome (result sit (d damsides) no-save)))
	(cond ((plusp outcome) (incf live))
	      ((= outcome -100) (incf die))
	      ((= outcome 0) (incf knocked-out))
	      (t (incf injured)))))
    (flet ((rep (effect value)
	     (list effect (/ (round (* 10000 (float (/ value times))))
			     100.0))))
      (values (rep 'still-in-action live)
	      (rep 'knocked-out knocked-out)
	      (rep 'injured injured)
	      (rep 'dead die)))))
	  
