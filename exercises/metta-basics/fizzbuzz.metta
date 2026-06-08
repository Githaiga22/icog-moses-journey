; fizzbuzz for one number

(= (fizzbuzz $n)
     (if (== (% $n 15) 0) "FizzBuzz"
     (if (== (% $n 3) 0)  "Fizz"
     (if (== (% $n 5) 0)  "Buzz"
                           $n))))

  !(fizzbuzz 15)
  !(fizzbuzz 9)
  !(fizzbuzz 10)
  !(fizzbuzz 7)