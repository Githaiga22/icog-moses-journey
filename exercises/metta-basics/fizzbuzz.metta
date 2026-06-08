;fizzbuzz challenge

(= (fizzbuzz $n)

(if (== (% $n 15) 0) "Fizzbuzz"
(if ( == (% $n 3) 0 ) "Fizz"
(if (== (% $n 5) 0) "Buzz"
$n
)
)
)
)
!(fizzbuzz 15)
!(fizzbuzz 7)
!(fizzbuzz 3)
!(fizzbuzz 5)

; Notes
;