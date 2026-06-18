; duplicate

(= (duplicate $x) ($x $x))
!(duplicate A)
!(duplicate 0.5)


; swapping example
(= (swap (pair $x $y)) (pair $y $x))
!(swap (pair 10 20))

; swapping 3 var
(= (swap3 (pairs $a $b $c)) (pairs $b $c $a) )
!(swap3 (pairs 10 20 30))