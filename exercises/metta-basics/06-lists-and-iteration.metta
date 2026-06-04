; ============================================================
; Exercise 06 — Lists & Iteration
; Topic: How to build lists, walk through them, and process them
; Run: metta-py exercises/metta-basics/06-lists-and-iteration.metta
; ============================================================


; ── LISTS IN MeTTa ─────────────────────────────────────────
; MeTTa does not have a built-in list like Python's [1, 2, 3]
; Instead, lists are built using two constructors:
;
;   Cons head tail  — a node with a head value and a tail (rest of list)
;   Nil             — the empty list (end of list)
;
; (Cons 1 (Cons 2 (Cons 3 Nil)))  is equivalent to Python's [1, 2, 3]
; This is the same as Lisp's linked list structure.
;
; Think of it like a chain:
;   1 → 2 → 3 → END


; ── BUILDING LISTS ─────────────────────────────────────────

; An empty list
(= (empty-list) Nil)

; A list with one element: [42]
(= (single) (Cons 42 Nil))

; A list with three elements: [1, 2, 3]
(= (numbers) (Cons 1 (Cons 2 (Cons 3 Nil))))

; A list of names: [Allan, Kirubel, Moses]
(= (names) (Cons Allan (Cons Kirubel (Cons Moses Nil))))

!(numbers)   ; → (Cons 1 (Cons 2 (Cons 3 Nil)))
!(names)     ; → (Cons Allan (Cons Kirubel (Cons Moses Nil)))


; ── GET THE HEAD (first element) ───────────────────────────

(= (head (Cons $h $t)) $h)
(= (head Nil) (Error "empty list has no head"))

!(head (Cons 10 (Cons 20 (Cons 30 Nil))))  ; → 10
!(head (numbers))                           ; → 1


; ── GET THE TAIL (everything except the first) ─────────────

(= (tail (Cons $h $t)) $t)
(= (tail Nil) Nil)

!(tail (Cons 10 (Cons 20 (Cons 30 Nil))))  ; → (Cons 20 (Cons 30 Nil))
!(tail (numbers))                           ; → (Cons 2 (Cons 3 Nil))


; ── LENGTH OF A LIST ───────────────────────────────────────
; Base case: empty list has length 0
; Recursive case: 1 + length of tail

(= (length Nil) 0)
(= (length (Cons $h $t)) (+ 1 (length $t)))

!(length Nil)                                     ; → 0
!(length (Cons 42 Nil))                           ; → 1
!(length (Cons 1 (Cons 2 (Cons 3 Nil))))          ; → 3
!(length (names))                                 ; → 3


; ── SUM ALL ELEMENTS IN A LIST ─────────────────────────────

(= (list-sum Nil) 0)
(= (list-sum (Cons $h $t)) (+ $h (list-sum $t)))

!(list-sum (Cons 1 (Cons 2 (Cons 3 (Cons 4 (Cons 5 Nil))))))  ; → 15


; ── CHECK IF AN ELEMENT IS IN A LIST ───────────────────────

(= (contains Nil $x)         False)
(= (contains (Cons $h $t) $x)
   (if (== $h $x) True (contains $t $x)))

!(contains (Cons 1 (Cons 2 (Cons 3 Nil))) 2)   ; → True
!(contains (Cons 1 (Cons 2 (Cons 3 Nil))) 9)   ; → False


; ── REVERSE A LIST ─────────────────────────────────────────
; Helper: append one list to another

(= (append Nil $ys) $ys)
(= (append (Cons $h $t) $ys) (Cons $h (append $t $ys)))

(= (reverse Nil) Nil)
(= (reverse (Cons $h $t)) (append (reverse $t) (Cons $h Nil)))

!(reverse (Cons 1 (Cons 2 (Cons 3 Nil))))    ; → (Cons 3 (Cons 2 (Cons 1 Nil)))


; ── SUPERPOSE — MeTTa's multi-value iteration ──────────────
; superpose takes a tuple and returns ALL values as separate results
; This is the closest thing to "iterate over a collection"

!(superpose (1 2 3 4 5))        ; → returns 1, 2, 3, 4, 5 as separate results

; Apply a function to each item using superpose:
!(square (superpose (1 2 3 4 5)))   ; → 1, 4, 9, 16, 25


; ── CONNECTION TO MOSES ────────────────────────────────────
; Lists and trees are closely related structures.
; MOSES represents candidate programs as TREES (combo_trees).
; Walking a list with head/tail is the same mental model as
; walking a program tree node by node.
; The list-processing patterns here — map, filter, fold —
; appear directly in how MOSES processes candidate programs.
