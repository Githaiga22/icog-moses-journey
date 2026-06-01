; Exercise 01 — Atoms and Symbols
; Topic: Defining facts and querying them with pattern matching
; Date: June 2, 2026
; Run: metta-py exercises/metta-basics/01-atoms-and-symbols.metta

; ── PART 1: Define facts (symbols and expressions stored in Atomspace) ──

; Domain: Animals
(isa cat mammal)
(isa dog mammal)
(isa eagle bird)
(isa salmon fish)
(isa frog amphibian)

(can cat  purr)
(can dog  bark)
(can eagle fly)
(can salmon swim)
(can frog jump)

; ── PART 2: Query facts using ! and pattern matching ──

; Q: What type is a cat?
!(match &self (isa cat $type) $type)

; Q: What can a dog do?
!(match &self (can dog $ability) $ability)

; Q: Which animals can fly?
!(match &self (can $animal fly) $animal)

; Q: Which animals are mammals?
!(match &self (isa $animal mammal) $animal)

; Q: What can each mammal do? (two-variable query)
!(match &self
    (isa $animal mammal)
    (match &self (can $animal $ability) ($animal $ability)))

; ── PART 3: Observations to fill in ──
; What did !(match &self (can $animal fly) $animal) return?
; →
; What happened when you queried a fact that doesn't exist?
; →
; What does &self refer to?
; → &self is the current Atomspace — the database of all stored atoms

; ── PART 4: Your own facts ──
; Add 3 facts about a domain you choose (cities, people, tech concepts...)
; Then write 2 queries against them.
