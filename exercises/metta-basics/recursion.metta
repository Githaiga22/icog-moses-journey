
  ; Count down and print each number
  ; (= (count 0) (println! "Liftoff!"))
  ; (= (count $n) (let $_ (println! $n) (count (- $n 1))))

(= (count $n)
(if (== $n  0)
(println! ("Hello there"))
(let $x (- $n 1)
(count $x)
)
)
)

  !(count 5)

  ; Find the maximum of two numbers
  (= (max $a $b) (if (> $a $b) $a $b))

  ; !(max 42 17)
  ; !(max 3 300)