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
;  FizzBuzz is a classic programming challenge — it goes like this:

; - Count from 1 to 100
; - If a number divides evenly by 3 → say "Fizz"
;  - If a number divides evenly by 5 → say "Buzz"
;  - If a number divides evenly by both 3 and 5 → say "FizzBuzz"
;  - Otherwise → just say the number
;Example output: 1, 2, Fizz, 4, Buzz, Fizz, 7, 8, Fizz, Buzz, 11, Fizz, 13, 14, FizzBuzz, 16...

; Code structure definitions
; $n - input variable, replaceable value
; % - modulp operator which gives the remainder after dividing two numbers (% $n 15) - (15 % 15) == 0 -- "FizzBuzz"
; == - equality check which retuns "True" or "False"

; if - the decision maker, works like this :  

;(if <condition> <value-if-true> <value-if-false>)
; Three parts always: condition, what to return if true, what to return if false. Example:
; (if True  "yes" "no")   ; → "yes"
; (if False "yes" "no")   ; → "no"

