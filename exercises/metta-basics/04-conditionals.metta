; ============================================================
; Exercise 04 — Conditionals (if/else & pattern-based branching)
; Topic: How MeTTa handles conditions and branching
; Run: metta-py exercises/metta-basics/04-conditionals.metta
; ============================================================


; ── BOOLEANS IN MeTTa ──────────────────────────────────────
; MeTTa has True and False as built-in symbols
; Boolean operations:

!(and True True)     ; → True
!(and True False)    ; → False
!(or  True False)    ; → True
!(or  False False)   ; → False
!(not True)          ; → False
!(not False)         ; → True


; ── COMPARISON ─────────────────────────────────────────────
; == checks equality, returns True or False

!(== 1 1)            ; → True
!(== 1 2)            ; → False
!(== hello hello)    ; → True
!(== hello world)    ; → False

; Numeric comparisons
!(> 5 3)             ; → True
!(< 5 3)             ; → False


; ── METHOD 1: if built-in ──────────────────────────────────
; Syntax: (if condition then-branch else-branch)
; This is the closest thing to an if/else statement

!(if True  "yes" "no")    ; → "yes"
!(if False "yes" "no")    ; → "no"

; With a comparison:
!(if (== 5 5) "equal" "not equal")     ; → "equal"
!(if (== 5 9) "equal" "not equal")     ; → "not equal"

; With arithmetic comparison:
!(if (> 10 3) "ten is bigger" "three is bigger")   ; → "ten is bigger"


; ── EXAMPLE: Grade classifier ──────────────────────────────

(= (grade $score)
   (if (> $score 89) "A"
   (if (> $score 79) "B"
   (if (> $score 69) "C"
   (if (> $score 59) "D"
                     "F")))))

!(grade 95)   ; → "A"
!(grade 82)   ; → "B"
!(grade 71)   ; → "C"
!(grade 60)   ; → "D"
!(grade 40)   ; → "F"


; ── METHOD 2: Pattern-based branching (the MeTTa way) ──────
; Instead of if/else, define MULTIPLE RULES for the same function
; Each rule handles a different case by matching a specific value
; The interpreter tries each rule in order and uses the one that matches

; Describe zero vs other numbers:
(= (describe 0) "zero")
(= (describe $n) "nonzero")    ; $n matches anything that is not 0

!(describe 0)     ; → "zero"   (matches first rule)
!(describe 5)     ; → "nonzero" (matches second rule)
!(describe 100)   ; → "nonzero"


; ── EXAMPLE: Absolute value ────────────────────────────────
; (no built-in abs, so we build one with if)

(= (absolute $n)
   (if (< $n 0) (* -1 $n) $n))

!(absolute 5)     ; → 5
!(absolute -8)    ; → 8
!(absolute 0)     ; → 0


; ── EXAMPLE: Even or odd ───────────────────────────────────

(= (even-or-odd $n)
   (if (== (% $n 2) 0) "even" "odd"))

!(even-or-odd 4)    ; → "even"
!(even-or-odd 7)    ; → "odd"
!(even-or-odd 0)    ; → "even"


; ── KEY INSIGHT ────────────────────────────────────────────
; MeTTa programmers prefer pattern-based branching over if/else
; because it is more readable and connects naturally to
; how MOSES represents programs as pattern-rewriting trees.
; Think of each rule as one branch of a decision tree.
