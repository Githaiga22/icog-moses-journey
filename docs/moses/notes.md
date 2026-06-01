# MOSES

MOSES (Meta-Optimizing Semantic Evolutionary Search) is an evolutionary program synthesis algorithm.

## Core Concepts

- Searches a space of programs to find one that best fits given data
- Avoids "spaghetti code" via program decomposition
- Uses a representation building block to keep candidates well-structured

## Search Space

- Programs are represented in a combo language (boolean expressions, arithmetic, etc.)
- The search space is explored using evolutionary operators

## Fitness Functions

- Evaluate how well a candidate program fits training examples
- Boolean problems use accuracy or F-score

## Representation Building (Deme)

- A deme is a subpopulation centered around a promising candidate
- Local search is applied within each deme before global recombination

## Reduction Engine

- Simplifies candidate programs to avoid bloat
- Ensures semantic equivalence is preserved after reduction

---

## Key Resources

| Resource | Link |
|----------|------|
| MOSES Algorithm (OpenCog Wiki) | https://wiki.opencog.org/w/MOSES_algorithm |
| MOSES Quick Guide PDF | https://wiki.opencog.org/w/File:MOSES-QuickGuide.pdf |
| MOSES Tutorial (OpenCog Wiki) | https://wiki.opencog.org/w/MOSES_Tutorial |
| OpenCog Classic MOSES Repo (C++) | https://github.com/opencog/moses |
| MeTTa-MOSES Repo (iCog Labs) | https://github.com/iCog-Labs-Dev/metta-moses |

---

_Notes added:_
