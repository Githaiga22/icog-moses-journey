# MeTTa

MeTTa (Meta Type Talk) is a purely functional, symbolic programming language developed by SingularityNET for the Hyperon framework.

## Syntax

- Expressions are written in a Lisp-like prefix notation
- Everything is an atom: symbols, variables, expressions
- Variables are prefixed with `$`

## Pattern Matching

MeTTa operates through pattern matching and rewriting rules:

```metta
(= (greet $name) (Hello $name))
```

## Functions / Rules

Rules are defined with `=` and matched left-to-right:

```metta
(= (add $x $y) (+ $x $y))
```

## Recursion

```metta
(= (factorial 0) 1)
(= (factorial $n) (* $n (factorial (- $n 1))))
```

## Knowledge Representation

Facts and rules share the same syntax — data and logic are unified:

```metta
(isa cat animal)
(isa dog animal)
(= (is-animal $x) (isa $x animal))
```

---

## Key Resources

| Resource | Link |
|----------|------|
| Hyperon Experimental (MeTTa interpreter) | https://github.com/trueagi-io/hyperon-experimental |
| MeTTa Language Specification | https://trueagi-io.github.io/hyperon-experimental/metta/ |
| Minimal MeTTa Guide | https://github.com/trueagi-io/hyperon-experimental/blob/main/docs/minimal-metta.md |
| Hyperon Tutorials (ReadTheDocs) | https://hyperon-tutorials.readthedocs.io/en/latest/index.html |
| Hyperon Tutorials GitHub | https://github.com/TownesZhou/hyperon-tutorials |
| Install via PyPI | https://pypi.org/project/hyperon/ |
| OpenCog Hyperon | https://hyperon.opencog.org/ |

---

_Notes added: June 1, 2026_

---

## Foundational Concepts (from Minimal MeTTa Guide + Language Spec)

### What is an Atom?
An **Atom** is the fundamental unit in MeTTa. Everything is an atom — data and code share the same representation. There are 4 types:

| Atom Type | Description | Example |
|-----------|-------------|---------|
| **Symbol** | A named identifier — represents a concept or value | `cat`, `True`, `+` |
| **Variable** | A placeholder for pattern matching, prefixed with `$` | `$x`, `$name`, `$result` |
| **Expression** | A parenthesized sequence of atoms — represents a function call or compound structure | `(+ 1 2)`, `(isa cat animal)` |
| **Grounded Atom** | An atom backed by a host-language value (Python/Rust) — numbers, strings, built-in ops | `42`, `"hello"`, `+` (arithmetic) |

### What is a Symbol?
A Symbol is a bare identifier — it starts with an alphanumeric character and has no special evaluation by itself. Symbols represent concepts, names, or constants:
```metta
cat       ; a symbol — just a name
True      ; a symbol — boolean constant
animal    ; a symbol — concept
```
Symbols are **data** unless used as the head of an expression being evaluated.

### What is a Variable?
A Variable is prefixed with `$` and acts as a wildcard in pattern matching. When a pattern containing a variable is matched against an atom, the variable binds to whatever the atom contains:
```metta
$x        ; matches anything, binds to it
$name     ; descriptive variable name
```
Variables have no value on their own — they only gain meaning during pattern matching.

### The `!` prefix
- Atoms written without `!` are **added to the Atomspace** (stored as facts)
- Atoms prefixed with `!` are **evaluated and returned** to the user

```metta
(isa cat animal)       ; stores the fact — no output
!(isa cat animal)      ; evaluates and returns it → (isa cat animal)
!(+ 1 2)               ; evaluates arithmetic → 3
```

### Evaluation Model (Non-Deterministic)
MeTTa uses **non-deterministic evaluation** — an expression can return multiple results simultaneously. This is fundamental to how MOSES searches a program space.

The interpreter maintains an "interpretation plan" — a list of `(atom, bindings)` pairs processed in parallel.

Special result atoms:
- `(Error ...)` — evaluation failed
- `Empty` — no result from this branch
- `NotReducible` — cannot be reduced further

### The `=` operator — Rewrite Rules (not assignment)
In MeTTa, `=` defines a **rewrite rule**, not an assignment:
```metta
(= (add $x $y) (+ $x $y))
```
This means: "whenever you see `(add $x $y)`, rewrite it to `(+ $x $y)`"

This is fundamentally different from Python's `def` — there is no function body, only pattern → replacement.

### Type Declarations with `:`
```metta
(: cat Animal)           ; cat is of type Animal
(: factorial (-> Number Number))  ; factorial takes Number, returns Number
```

### Key Design Insight
In MeTTa, **there is no separation between code and data**. A fact `(isa cat animal)` and a rule `(= (is-animal $x) (isa $x animal))` are both just atoms in the Atomspace. This unification is what makes symbolic reasoning and program synthesis possible in the same language.

---

## Environment Setup (June 1)

```bash
# Track A — MeTTa learning (WORKING)
source ~/metta-env/bin/activate
metta-py your-file.metta

# Verified working:
# echo "!(+ 1 2)" → [3]  (verified)
# hyperon 0.2.10 installed
# Python 3.9.6, venv at ~/metta-env

# Track B — metta-moses project
# Repos cloned to ~/Documents/icog-labs/
#   metta-moses/  → https://github.com/iCog-Labs-Dev/metta-moses
#   metta-moses/PeTTa/  → https://github.com/trueagi-io/PeTTa
# SWI-Prolog: installing via brew (in progress)
```
