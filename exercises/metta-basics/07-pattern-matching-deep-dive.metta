; ============================================================
; Exercise 07 — Pattern Matching Deep Dive
; Topic: The core mechanism of MeTTa — match EVERYTHING with patterns
; Run: metta-py exercises/metta-basics/07-pattern-matching-deep-dive.metta
; ============================================================


; ── WHAT IS PATTERN MATCHING? ──────────────────────────────
; Pattern matching is MeTTa's version of:
;   - if/else
;   - switch/case
;   - function overloading
;   - database queries
; ALL of the above are just pattern matching in MeTTa.
;
; The key operator is: match
; Syntax: (match &self <pattern> <result>)
;   &self = the current Atomspace (your knowledge database)
;   pattern = what you are looking for (can have $variables)
;   result = what to return when a match is found


; ── PART 1: Storing and querying facts ─────────────────────

; Store facts (no ! = store only, no output)
(color sky blue)
(color grass green)
(color sun yellow)
(color blood red)
(color snow white)

; Query: what color is the sky?
!(match &self (color sky $c) $c)             ; → blue

; Query: what is green?
!(match &self (color $thing green) $thing)   ; → grass

; Query: return ALL (thing, color) pairs
!(match &self (color $thing $c) ($thing $c))
; → (sky blue), (grass green), (sun yellow), (blood red), (snow white)


; ── PART 2: Multiple facts, multiple matches ────────────────

(lives-in Allan Nairobi)
(lives-in Kirubel Addis-Ababa)
(lives-in Ben-Goertzel Remote)

(works-at Allan iCog-Labs)
(works-at Kirubel iCog-Labs)
(works-at Ben-Goertzel SingularityNET)

; Who lives in Nairobi?
!(match &self (lives-in $person Nairobi) $person)   ; → Allan

; Who works at iCog-Labs?
!(match &self (works-at $person iCog-Labs) $person)  ; → Allan, Kirubel

; Join: who lives where AND works where?
!(match &self (lives-in $p $city)
   (match &self (works-at $p $org)
      ($p lives-in $city works-at $org)))
; → all people with both facts


; ── PART 3: Pattern matching in function rules ─────────────
; When you write (= (f $x) body), you are defining a pattern match rule
; The interpreter matches the call against all rules and picks the right one

; A function with 3 different patterns:
(= (classify 0)          "zero")
(= (classify 1)          "one")
(= (classify $n)         "many")   ; catches everything else

!(classify 0)     ; → "zero"
!(classify 1)     ; → "one"
!(classify 42)    ; → "many"


; ── PART 4: Matching on structure, not just values ─────────
; You can pattern match on the SHAPE of an expression

; Match a pair:
(= (first-of-pair ($a $b)) $a)
(= (second-of-pair ($a $b)) $b)

!(first-of-pair (hello world))    ; → hello
!(second-of-pair (10 20))         ; → 20

; Match nested structure:
(= (inner (outer $x)) $x)

!(inner (outer 42))     ; → 42
!(inner (outer hello))  ; → hello


; ── PART 5: Non-determinism — multiple results ─────────────
; MeTTa can return MULTIPLE results for one query
; This is called non-determinism — unlike Python where a function
; returns exactly one value

; Store multiple facts for the same key:
(team-member MOSES Allan)
(team-member MOSES Kirubel)
(team-member MOSES Yeabsira)

; Query — returns ALL matches at once:
!(match &self (team-member MOSES $person) $person)
; → Allan, Kirubel, Yeabsira  (all three)


; ── PART 6: The & operator — Atomspace reference ───────────
; &self means "the current Atomspace" — your local knowledge base
; You can also create new Atomspaces:

; (new-space)  creates an empty Atomspace
; This is advanced — for now, always use &self


; ── KEY INSIGHT: Why pattern matching matters for MOSES ────
; MOSES searches a space of PROGRAMS.
; Each candidate program is a tree of patterns.
; When MOSES evaluates a program on training data, it is doing
; pattern matching: "does this program pattern match this input?"
; The scoring function, the reduction engine, and the deme search
; all rely on structural pattern matching over program trees.
; Learning MeTTa pattern matching IS learning how MOSES thinks.
