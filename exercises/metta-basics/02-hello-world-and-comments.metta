; ============================================================
; Exercise 02 — Hello World & Comments
; Topic: How to write output, how comments work, basic syntax
; Run: metta-py exercises/metta-basics/02-hello-world-and-comments.metta
; ============================================================


; ── COMMENTS ──────────────────────────────────────────────
; In MeTTa, a comment starts with a semicolon (;)
; Everything after ; on that line is ignored by the interpreter
; There are no multi-line block comments — use ; on each line

; This is a comment
; This is also a comment


; ── THE EXCLAMATION MARK ! ─────────────────────────────────
; This is the most important rule to understand first:
;
;   Without ! → the expression is STORED in the Atomspace (like saving a fact)
;   With    ! → the expression is EVALUATED and the result is shown to you
;
; Think of ! as "run this now and show me the result"


; ── HELLO WORLD ────────────────────────────────────────────

; println! prints a value to the terminal and returns ()
!(println! "Hello, World!")

; You can print any atom — not just strings
!(println! Hello)

; Print a number
!(println! 42)

; Print an expression result
!(println! (+ 10 20))


; ── STRINGS ────────────────────────────────────────────────

; Strings use double quotes
!(println! "My name is Allan Robinson")
!(println! "I am learning MeTTa")

; Concatenate strings using str-concat (if supported) or just print separately
!(println! "iCog Labs")
!(println! "Hyperion MOSES Team")


; ── BASIC ARITHMETIC OUTPUT ────────────────────────────────

; MeTTa can evaluate arithmetic directly
!(+ 5 3)       ; → 8
!(- 10 4)      ; → 6
!(* 3 3)       ; → 9
!(/ 20 4)      ; → 5

; Nested arithmetic — prefix notation, innermost first
!(+ (* 2 3) (- 10 4))   ; (2*3) + (10-4) = 6 + 6 = 12


; ── WHAT YOU OBSERVE ───────────────────────────────────────
; Each !(expression) produces one line of output
; Expressions without ! produce no output — they are silent storage
; The order of output matches the order of ! statements in the file
