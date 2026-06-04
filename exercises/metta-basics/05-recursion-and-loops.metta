; ============================================================
; Exercise 05 — Recursion & Loops
; Topic: MeTTa has NO loops. Recursion IS the loop.
; Run: metta-py exercises/metta-basics/05-recursion-and-loops.metta
; ============================================================


; ── WHY NO LOOPS? ──────────────────────────────────────────
; MeTTa is a purely functional language.
; There is no for, while, or do-while.
; Instead, you write a function that calls ITSELF with a smaller problem.
; This is called RECURSION.
;
; Every recursive function needs exactly two parts:
;   1. BASE CASE   — the stopping condition (so it doesn't run forever)
;   2. RECURSIVE CASE — where the function calls itself
;
; Always define the BASE CASE first.


; ── EXAMPLE 1: Countdown (simulating a for loop) ───────────
; In Python you would write: for i in range(5, 0, -1): print(i)
; In MeTTa:

(= (countdown 0) (println! "Done!"))        ; base case: stop at 0
(= (countdown $n) (let $_ (println! $n)    ; print current number
                       (countdown (- $n 1)))) ; then recurse with n-1

!(countdown 5)
; prints: 5, 4, 3, 2, 1, Done!


; ── EXAMPLE 2: Factorial ───────────────────────────────────
; 5! = 5 * 4 * 3 * 2 * 1 = 120
; Pattern: factorial(n) = n * factorial(n-1)
;          factorial(0) = 1  ← base case

(= (factorial 0) 1)                          ; base case
(= (factorial $n) (* $n (factorial (- $n 1)))) ; recursive case

!(factorial 0)    ; → 1
!(factorial 1)    ; → 1
!(factorial 5)    ; → 120
!(factorial 7)    ; → 5040


; ── EXAMPLE 3: Fibonacci ───────────────────────────────────
; 0, 1, 1, 2, 3, 5, 8, 13, 21...
; fib(0) = 0, fib(1) = 1, fib(n) = fib(n-1) + fib(n-2)

(= (fib 0) 0)                                        ; base case 1
(= (fib 1) 1)                                        ; base case 2
(= (fib $n) (+ (fib (- $n 1)) (fib (- $n 2))))      ; recursive case

!(fib 0)    ; → 0
!(fib 1)    ; → 1
!(fib 6)    ; → 8
!(fib 9)    ; → 34


; ── EXAMPLE 4: Sum from 1 to N (simulating a for loop sum) ─
; In Python: sum(range(1, n+1))
; In MeTTa:

(= (sum-to 0) 0)
(= (sum-to $n) (+ $n (sum-to (- $n 1))))

!(sum-to 5)     ; → 1+2+3+4+5 = 15
!(sum-to 10)    ; → 55
!(sum-to 100)   ; → 5050


; ── EXAMPLE 5: Power (base ^ exponent) ─────────────────────

(= (power $b 0) 1)                                   ; anything^0 = 1
(= (power $b $e) (* $b (power $b (- $e 1))))

!(power 2 10)   ; → 1024
!(power 3 4)    ; → 81
!(power 5 3)    ; → 125


; ── EXAMPLE 6: GCD (Euclidean algorithm) ───────────────────

(= (gcd $a 0) $a)
(= (gcd $a $b) (gcd $b (% $a $b)))

!(gcd 48 18)    ; → 6
!(gcd 100 75)   ; → 25


; ── HOW TO READ A RECURSIVE FUNCTION ───────────────────────
; Take factorial as an example. Trace !(factorial 3) step by step:
;
;   factorial(3)
;   = 3 * factorial(2)
;   = 3 * (2 * factorial(1))
;   = 3 * (2 * (1 * factorial(0)))
;   = 3 * (2 * (1 * 1))           ← hit the base case
;   = 3 * (2 * 1)
;   = 3 * 2
;   = 6
;
; The function "unwinds" back up once it hits the base case.


; ── CONNECTION TO MOSES ────────────────────────────────────
; MOSES evolves programs represented as trees.
; Recursive functions ARE trees — the function call structure
; forms a tree that MOSES can search, mutate, and optimize.
; Understanding recursion is essential to understanding how
; MOSES builds and manipulates program representations.
