# MOSES

MOSES (Meta-Optimizing Semantic Evolutionary Search) is an evolutionary program synthesis algorithm.
It performs supervised learning: given a scoring function or training data, it searches for a
compact, readable program that solves the problem.

Source: MOSES Quick Guide (Janicic, revised Vepstas, 2008/2012)

---

## Simple Explanation

**In one sentence:**
MOSES is a machine that automatically writes programs, tests them, throws away bad ones, improves good ones, and repeats — until it finds a program that correctly solves your problem.

---

### The Real-World Analogy

Think of MOSES like a chef trying to find the perfect cake recipe, without knowing it in advance:

1. Start with a rough guess — flour, sugar, eggs
2. Taste it — give it a score
3. Tweak small things — more sugar, less butter
4. Taste again — better or worse?
5. Keep the better version, throw away the worse one
6. Repeat until the cake is perfect

MOSES does exactly this — but instead of cake recipes, it evolves computer programs.

---

### A Concrete Low-Level Example

Problem given to MOSES:
"Find a program that takes two True/False inputs and returns True only when BOTH are True."

That is the AND logic gate. You know the answer. MOSES does not — it has to discover it.

**Step 1 — Start with a guess (the Exemplar)**

MOSES begins with the simplest possible program:
```
#1
```
Just return input 1. Ignore input 2. This is the exemplar — the starting point.

**Step 2 — Attach knobs (build the Representation)**

MOSES attaches adjustable dials called knobs to the exemplar:
```
[knob_A: AND or OR or NOT] (#1, #2)
```
knob_A can be set to AND, OR, or NOT — giving 3 programs to try.
Exemplar + knobs = Representation.

**Step 3 — Try all settings, score each one (Optimization inside a Deme)**

Training data:
```
(True,  True)  → expected: True
(True,  False) → expected: False
(False, True)  → expected: False
(False, False) → expected: False
```

| Knob setting | Program    | Score |
|---|---|---|
| OR           | #1 OR #2   | -2 (wrong on 2 rows) |
| NOT          | NOT #1     | -3 (wrong on 3 rows) |
| AND          | #1 AND #2  | 0  (perfect!) |

All these scored attempts together = the Deme.

**Step 4 — Keep the best, simplify, merge (Close the Deme)**

The best result (AND, score 0) is converted back into a clean program, simplified to remove
any redundancy (normalization), and added to the Metapopulation — the master collection of
all best programs found so far.

**Step 5 — Repeat**

MOSES picks the best program from the metapopulation, uses it as the new exemplar,
builds a new representation with new knobs, opens a new deme, optimizes again.
Stops when score is perfect or evaluation limit is reached.

---

### Key Terms in Plain English

```
Program        -> the thing MOSES is writing (a tree of logic)
Exemplar       -> the current best guess, used as starting point
Knob           -> one adjustable dial on the program
Representation -> exemplar + all its knobs attached
Instance       -> one specific knob setting = one candidate program
Deme           -> a bucket of scored instances (one round of experiments)
Metapopulation -> the master collection of all best programs across all rounds
Score          -> how correct a program is (0 = perfect, negative = wrong)
Domination     -> program A dominates B if A is better on every single test row
Normalization  -> simplifying a program to remove redundant or bloated parts
```

---

### The Core Chain to Remember

```
Exemplar -> Representation -> Knobs -> Deme -> Score -> Metapopulation -> Repeat
```

---

## Overview

MOSES is not like a neural network. It does not produce a vector of weights.
It produces a small, human-readable program written in a Lisp-like mini-language called Combo.

MOSES works by:
1. Maintaining a population of candidate programs
2. Exploring neighborhoods of modified programs
3. Evaluating fitness of each candidate
4. Keeping the fittest programs, discarding dominated ones
5. Repeating until a perfect solution is found or evaluation limit is hit

Key advantages over standard genetic programming:
- Avoids "spaghetti code" via normalization (reduction to elegant normal form)
- Uses probabilistic modeling (Bayesian networks) to find dependencies between program parts
- Produces compact, human-readable, fast-to-execute programs

---

## Complete Terminology Reference

### Program
A Combo program — a tree of operators, variables, and values.
Arguments are written as #1, #2, ..., #n.

Example:
```
(0 < (0.5 * #1)) OR #2
```
This takes a float #1 and a boolean #2. Multiplies #1 by 0.5, checks if > 0, then ORs with #2.

Programs can be propositional formulae, arithmetic expressions, actions, or predicate logic.

---

### Exemplar
The current best-known program. The "champion" at any point in the search.
MOSES always builds from the exemplar — it never starts from scratch each iteration.

---

### Representation
The exemplar with "knobs" (tunable parameters) attached at various points in its tree.
A representation defines a region of program space centered on the exemplar.

```
exemplar + knobs = representation
```

A representation together with a specific set of knob settings equals a specific program.

---

### Knob
A single adjustable parameter attached to a specific location in a representation tree.
Two types:

**Discrete knob** — a fixed number of settings (multiplicity).
Example: a knob of multiplicity 4 on input #2:
- Setting 0: always true
- Setting 1: invert (#2 becomes NOT #2)
- Setting 2: don't invert (keep #2 as is)
- Setting 3: always false

Example: a knob of multiplicity 3 on the OR operator:
- Setting 0: OR (v)
- Setting 1: AND (^)
- Setting 2: XOR

**Continuous knob** — varies a numeric constant in steps (e.g. changing 0.5 to 0.7 in `0.5 * #1`).

Knobs are defined in `representation/knobs.h` in the C++ implementation.
Key knob types: `logical_subtree_knob` (present/absent/negated), `contin_knob` (continuous).

---

### Instance
One specific combination of knob settings, packed into a bit-string (array of unsigned ints).
Each knob occupies a field in the bit-string.

```
representation + specific knob settings = instance = specific program
```

Many different instances can share the same representation (same field_set, same knob_mapper).

---

### Field Set
The schema that describes how bits in an instance map to knob settings.
It records: how many bits each knob needs, and where in the bit-string each knob lives.
Does not know anything about the combo_tree itself — purely a layout description.

Four field types: continuous, discrete, term (tree algebra), single-bit boolean.

---

### Knob Mapping
The bridge between the field_set (bit-string layout) and the actual knobs in the combo_tree.
Tells you: "field #3 in the bit-string corresponds to the OR-operator knob at position X in the tree."

---

### Neighborhood
The set of instances that differ from a given instance by exactly 1 knob setting = distance-1 neighborhood.
Distance-2 neighborhood = differ by 2 knob settings. And so on (Hamming distance).
The optimizer searches the neighborhood to find better programs.

---

### Deme
A population of instances (knob settings) all built around ONE single representation.
All instances in a deme share the same field_set and knob_mapper.

In practice a deme = a set of scored instances.
The optimizer (hill-climbing, simulated annealing, BOA) works within a deme to find
the best possible knob settings for that representation.

---

### Metapopulation
The collection of ALL demes — the outer world where demes compete.
Stored as a sorted set of scored combo trees (bscored_combo_tree).

Fitter demes survive. Dominated demes are discarded.
The metapopulation drives the outer loop of MOSES.

---

### Scoring Function
The judge. Takes a candidate program and returns a number: how good is it?
- Perfect score = 0
- Worse scores are negative numbers
- Fitter programs have higher (less negative) scores

For supervised learning: score = how many training rows the program predicts correctly.
For demo problems: standard toy benchmarks (parity, one-max, santa-fe-trail, etc.).

Multiple score types exist in the C++ implementation:
- `score_t` (float) — raw fitness score
- `behavioral_score` (vector of scores) — one score per training row
- `complexity_t` (int) — penalizes program complexity
- `composite_score` — fitness + complexity combined
- `composite_behavioral_score` — behavioral vector + composite score

---

### Domination
Program A dominates Program B if A has a better score on EVERY SINGLE test row.

If A wins some rows and B wins others: neither dominates. MOSES keeps BOTH.
Programs that are completely dominated are discarded from the metapopulation.

---

### Normalization / Reduction
After finding a good instance, MOSES converts it back to a program tree and simplifies it.
Uses algebraic rewriting rules to remove redundant or vacuous parts.

Examples of reductions:
- `#3 OR False` → `#3` (OR with false changes nothing)
- `0 < 0.5 * #6` → `0 < #6` (multiplying by positive constant does not change sign)
- `if (x = x) then y` → `y` (condition is always true)

MOSES uses "elegant normal form" (Holman) — alternating layers of linear and non-linear operators.
This is more compact than boolean disjunctive or conjunctive normal form.

Benefits:
- Eliminates code bloat
- Makes programs faster to execute
- Makes programs human-readable
- Allows smaller populations (faster convergence)

---

## The MOSES Algorithm — 5 Steps

MOSES has two nested loops:
- **Outer loop**: manages the metapopulation (global search)
- **Inner loop**: explores variations within one deme (local search)

### Step 1 — Selection
Pick the best exemplar from the metapopulation that has NOT been explored before.
(No point re-exploring an already-searched neighborhood.)
Implemented by `metapopulation::select_exemplar()`.

### Step 2 — Representation-building
Take the exemplar and attach knobs at various locations.
Build a field_set and knob_mapper.
Create an initial instance (default knob settings = bit-string of zeros).

This step is domain-specific:
- Propositional formulae (boolean programs) — use `logical_subtree_knob`
- Arithmetic — use `contin_knob`
- Actions (robot planning) — use `simple_action_subtree_knob`

### Step 3 — Optimization (inner loop)
Given the representation, field_set, and initial instance, run the inner optimizer.

Steps inside the inner loop:
1. Score the initial instance
2. Generate new instances (neighbors — differ by a few knob settings)
3. Score each new instance
4. Maintain a deme of the best-scored instances
5. Terminate when: no improvement, evaluation limit exceeded, or neighborhood fully explored

Optimization algorithms available:
- Hill-climbing (iterative_hillclimbing)
- Simulated annealing
- Bayesian Optimization Algorithm (BOA/hBOA) — uses a Bayesian network to model
  dependencies between knobs, then samples likely-good instances from that model

The generic optimizer template (`eda/optimize.h`) takes pluggable policies:
- SelectionPolicy — how to pick individuals for modeling
- StructureLearningPolicy — how to learn relationships between variables (e.g. univariate = no dependencies, BOA = full Bayesian network)
- ProbsLearningPolicy — learn probability distributions
- ReplacementPolicy — how to replace old instances with new ones (replace_the_worst, rtr_replacement)
- TerminationPolicy — when to stop (terminate_if_gte, terminate_if_gte_or_no_improv)
- ScoringPolicy — must be thread-safe

### Step 4 — Close the deme
Take the best instances from the deme.
Convert each back into a combo_tree (fix knob settings, remove knobs).
Normalize/reduce each to elegant normal form.
Merge into metapopulation, ranked by score.
Discard dominated programs.

### Step 5 — Repeat
Go to Step 1.
Stop when: perfect score reached, or maximum number of evaluations exceeded.

---

## Metaoptimization
The main outer loop is `metapopulation::expand()`:
```
expand() = create_deme() + optimize_deme() + close_deme()
```
optimize_deme() calls one of: `univariate_optimization()`, `simulated_annealing()`,
or `iterative_hillclimbing()`.

---

## Representation-building in Detail
Conceptually:
1. Take exemplar (a combo_tree)
2. Add knobs at various positions in the tree ("festoon with knobs")
3. The exemplar + knobs = representation (class `representation` in `representation/representation.h`)
4. Build field_set (describes bit-string layout)
5. Build knob_mapper (maps field_set entries to actual knob locations in combo_tree)
6. Create initial instance (all knobs at default/zero)

The representation class stores:
- A copy of the exemplar
- The collection of knobs
- The knob mapping

It provides methods:
- `transform(instance)` — apply knob settings to produce a new combo_tree
- `clear_exemplar()` — reset all knobs to default
- `get_clean_exemplar()` — get the reduced, simplified exemplar

---

## Source Code Structure (C++ reference)
Relevant for understanding what metta-moses is porting:

| Folder | Purpose |
|--------|---------|
| `eda/` | Estimation of distribution algorithms, low-level optimizer support |
| `representation/` | Knobs, field_set, knob_mapper, representation class |
| `moses/` | Core types, metapopulation, scoring types |
| `optimization/` | Main optimization algorithms |
| `example-progs/` | Example scoring functions and MOSES usage demos |
| `example-ant/` | Robot ant problem demo |
| `example-data/` | Example datasets for regression |
| `main/` | The moses executable |

Key files:
- `comboreduct/combo/vertex.h` — defines the vertex type (nodes in combo_tree)
- `representation/knobs.h` — knob base class + discrete_knob + contin_knob
- `representation/field_set.h` — field_set class
- `representation/representation.h` — representation class
- `eda/optimize.h` — generic optimize() template (inner loop)
- `eda/scoring.h` — scored_instance
- `representation/instance_set.h` — instance_set (collection of scored instances = deme)
- `moses/metapopulation.h` — metapopulation class
- `moses/types.h` — score_t, behavioral_score, composite_score, bscored_combo_tree
- `moses/moses.h` — main moses() method

---

## Key Relationships (Mental Model)

```
combo_tree (program)
    |
    + knobs attached
    |
    v
representation
    |
    + specific knob settings = instance (bit-string)
    |
    v
scored_instance
    |
    collection of scored_instances = deme
    |
    v
metapopulation (collection of demes, sorted by score)
```

---

## What metta-moses Is Porting

The C++ implementation above is being rewritten in MeTTa.
Current focus: boolean domain (propositional formulae).
Key components being ported:
- Combo program representation in MeTTa atoms
- Knob system (discrete knobs for boolean operators)
- Scoring function for boolean problems
- Deme management
- Metapopulation
- Reduction/normalization for boolean expressions

---

## Key Resources

| Resource | Link |
|----------|------|
| MOSES Algorithm (OpenCog Wiki) | https://wiki.opencog.org/w/MOSES_algorithm |
| MOSES Quick Guide PDF | https://wiki.opencog.org/w/File:MOSES-QuickGuide.pdf |
| MOSES Tutorial (OpenCog Wiki) | https://wiki.opencog.org/w/MOSES_Tutorial |
| OpenCog Classic MOSES Repo (C++) | https://github.com/opencog/moses |
| MeTTa-MOSES Repo (iCog Labs) | https://github.com/iCog-Labs-Dev/metta-moses |
| Moshe Looks PhD Dissertation (2006) | Competent Program Evolution — request from mentor |

---

_Notes added: June 3, 2026 — from MOSES Quick Guide PDF (Janicic/Vepstas)_
