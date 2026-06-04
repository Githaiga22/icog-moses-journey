; ============================================================
; Exercise 03 — Variables & Functions (Rules)
; Topic: How to define functions, use variables, call functions
; Run: metta-py exercises/metta-basics/03-variables-and-functions.metta
; ============================================================


; ── VARIABLES ──────────────────────────────────────────────
; Variables in MeTTa are prefixed with $
; They are ONLY meaningful during pattern matching
; A variable matches ANYTHING and binds to it

; $x    — a variable named x
; $name — a variable named name
; $n    — a variable named n

; Variables have no standalone value — you will never just write:
;   !(println! $x)    ← this does nothing useful on its own


; ── FUNCTIONS (called RULES in MeTTa) ──────────────────────
; MeTTa does not have "def" like Python or "func" like Go
; Instead you write REWRITE RULES using =
;
; Syntax:
;   (= (function-name arg1 arg2 ...) result)
;
; Read it as: "whenever you see (function-name arg1 arg2), rewrite it to result"
; This is NOT assignment — it is a transformation rule


; ── EXAMPLE 1: Simple greeting ─────────────────────────────

(= (greet $name) (Hello $name))

; Call it:
!(greet Allan)        ; → (Hello Allan)
!(greet Kirubel)      ; → (Hello Kirubel)
!(greet MeTTa)        ; → (Hello MeTTa)


; ── EXAMPLE 2: Arithmetic function ─────────────────────────

(= (square $x) (* $x $x))
(= (double $x) (* 2 $x))
(= (add $x $y) (+ $x $y))

!(square 5)           ; → 25
!(square 12)          ; → 144
!(double 7)           ; → 14
!(add 3 4)            ; → 7
!(add (square 3) (double 4))  ; → 9 + 8 = 17


; ── EXAMPLE 3: Multiple arguments ──────────────────────────

(= (full-name $first $last) ($first $last))
(= (rectangle-area $w $h) (* $w $h))

!(full-name Allan Robinson)   ; → (Allan Robinson)
!(rectangle-area 5 8)        ; → 40


; ── EXAMPLE 4: Functions calling other functions ────────────

(= (cube $x) (* $x (square $x)))    ; cube uses square defined above

!(cube 3)   ; → 3 * 9 = 27
!(cube 4)   ; → 4 * 16 = 64


; ── KEY INSIGHT ────────────────────────────────────────────
; In MeTTa, EVERYTHING is pattern matching
; When you call !(square 5), the interpreter looks through all rules
; and finds (= (square $x) (* $x $x))
; It matches $x = 5, then evaluates (* 5 5) = 25
; There is no "function call stack" in the traditional sense
; It is purely: pattern → replacement → evaluate
