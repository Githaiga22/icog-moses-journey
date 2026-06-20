# Week 3 — Classification, Logistic Regression & Regularization

Course: Machine Learning Specialization (Andrew Ng — Coursera)
Topics: Binary Classification, Logistic Regression, Decision Boundary,
        Cost Function, Gradient Descent, Overfitting, Regularization

---

## 1. Why Not Linear Regression for Classification?

Classification output y can only be 0 or 1.
Linear regression predicts any number — including negatives and values > 1.

Problem with using linear regression:

  Adding one outlier far to the right shifts the best-fit line
  → the decision boundary shifts → wrong classifications

  Price
  |     x  x  x  x | x  x           x  <-- outlier
  |                 |
  0=================1
        Decision boundary shifts right when outlier added

This is why we need a different algorithm: Logistic Regression.

---

## 2. Binary Classification

Only two possible output classes:

  Class 0 (Negative):  No, False, Not spam, Benign
  Class 1 (Positive):  Yes, True, Spam, Malignant

Examples:

  Problem              | Input x          | Output y
  ---------------------|------------------|------------------
  Email spam           | Email content    | 0=not spam, 1=spam
  Fraud detection      | Transaction data | 0=legit, 1=fraud
  Tumor classification | Tumor size, age  | 0=benign, 1=malignant

---

## 3. The Sigmoid Function

The sigmoid (logistic) function maps any number z to a value between 0 and 1.

Formula:
  g(z) = 1 / (1 + e^(-z))

Graph:
  g(z)
  1.0 |          __________
      |        /
  0.5 |-------*-----------   ← crosses at z=0
      |     /
  0.0 |___/
      +--+--+--+--+--+--+---> z
        -3 -2 -1  0  1  2  3

Key values:
  z → +infinity   →  g(z) → 1
  z → -infinity   →  g(z) → 0
  z = 0           →  g(z) = 0.5    (exactly)

Python:  g = 1 / (1 + np.exp(-z))   (works on scalars AND arrays)

---

## 4. Logistic Regression Model

Two-step process:

  Step 1: Compute z = w.x + b    (same as linear regression)
  Step 2: Apply sigmoid: f(x) = g(z) = 1 / (1 + e^(-(w.x + b)))

Full model:
  f(x) = g(w.x + b) = 1 / (1 + e^(-(w.x + b)))

Output interpretation:
  f(x) = probability that y = 1 given input x

  Example: f(x) = 0.7 means
    → 70% chance the tumor is malignant
    → 30% chance the tumor is benign  (because probabilities sum to 1)

Notation (you may see this in papers):
  f(x) = P(y=1 | x; w, b)

---

## 5. Decision Boundary

The line (or curve) where the model transitions from predicting y=0 to y=1.

Prediction rule:
  if f(x) >= 0.5  →  predict y = 1
  if f(x) < 0.5   →  predict y = 0

Since f = sigmoid(z):
  f >= 0.5  when  z >= 0
  f < 0.5   when  z < 0

So:
  predict y = 1  when  w.x + b >= 0
  predict y = 0  when  w.x + b < 0

### Linear Decision Boundary (2 features)

  f(x) = g(w1*x1 + w2*x2 + b)

  With w1=1, w2=1, b=-3:
  Decision boundary: x1 + x2 - 3 = 0  →  x1 + x2 = 3

    x2
    |   x  x  |  o  o
    |   x  x  |  o  o      ← line x1+x2=3 separates classes
    |   x  x  |
    +----------+-----> x1
    predicts 0  predicts 1

### Non-linear Decision Boundary (polynomial features)

  z = w1*x1^2 + w2*x2^2 + b
  With w1=1, w2=1, b=-1:
  Decision boundary: x1^2 + x2^2 = 1  →  a CIRCLE

    x2
    |    x x   o o
    |  x ( o o ) x        ← circle separates classes
    |  x ( o o ) x        inside circle: y=0, outside: y=1
    |    x x   o o
    +----------+-----> x1

  Higher-order polynomials → even more complex boundaries (ellipses, etc.)

---

## 6. Cost Function for Logistic Regression

### Why NOT squared error?

  Using J = (1/2m) * SUM (f(x^i) - y^i)^2 with sigmoid f
  → Non-convex cost surface → many local minima → gradient descent gets stuck

### The Logistic Loss Function

For a single training example:

  If y = 1:  loss = -log(f(x))
  If y = 0:  loss = -log(1 - f(x))

Why this makes sense:

  When y=1:
    f → 1  →  loss → 0       (correct prediction, low penalty)
    f → 0  →  loss → infinity (wrong prediction, huge penalty)

  When y=0:
    f → 0  →  loss → 0       (correct prediction, low penalty)
    f → 1  →  loss → infinity (wrong prediction, huge penalty)

  loss
  |  \
  |   \
  |    \
  |     \____
  +-----------> f(x) from 0 to 1
  (shape when y=1)

### Simplified Single-Line Loss Formula

Instead of two cases, one combined formula:

  loss = -y * log(f(x)) - (1 - y) * log(1 - f(x))

Verification:
  When y=1: first term = -log(f), second term = 0  → -log(f)  ✓
  When y=0: first term = 0, second term = -log(1-f) → -log(1-f)  ✓

### Full Cost Function for Logistic Regression

  J(w,b) = (1/m) * SUM_i [-y^i * log(f(x^i)) - (1-y^i) * log(1-f(x^i))]

Or equivalently written out:

  J(w,b) = -(1/m) * SUM_i [y^i * log(f(x^i)) + (1-y^i) * log(1-f(x^i))]

Properties:
  - This is a CONVEX function (bowl-shaped)
  - Gradient descent is guaranteed to find the global minimum
  - Derived from Maximum Likelihood Estimation (statistics)

---

## 7. Gradient Descent for Logistic Regression

Repeat until convergence:

  w_j := w_j - alpha * (1/m) * SUM_i (f(x^i) - y^i) * x^i_j
  b   := b   - alpha * (1/m) * SUM_i (f(x^i) - y^i)

LOOKS identical to linear regression — but f is now:
  f(x) = sigmoid(w.x + b)    NOT   f(x) = w.x + b

Key reminders:
  - Update w and b SIMULTANEOUSLY
  - Feature scaling helps gradient descent converge faster
  - Monitor J vs iterations (learning curve) to check convergence

---

## 8. Overfitting and Underfitting

### Three Cases

  UNDERFIT (High Bias):
    Model too simple, doesn't fit training data
    Straight line when data is curved

  JUST RIGHT:
    Fits training data well, generalizes to new data
    Quadratic curve for quadratic-looking data

  OVERFIT (High Variance):
    Fits training data perfectly but wiggles too much
    High-order polynomial that passes through every point

Visualization (regression):

  Price
  |      /   Underfit (straight line — too simple)
  |    /
  |  /
  +---------> Size

  Price
  |    *
  |  *   *   Just right (quadratic — fits well)
  |*       *
  +---------> Size

  Price
  |  *  * *
  |*  \/   *  Overfit (4th order — too wiggly)
  |*        *
  +---------> Size

### For Classification

  Underfit → straight decision boundary (misses real pattern)
  Just right → curved boundary that fits the data well
  Overfit → contorted boundary that memorizes training set

### Bias vs Variance

  High Bias = Underfit    → model assumptions too strong/simple
  High Variance = Overfit → model too sensitive to training data

---

## 9. Addressing Overfitting

### Option 1 — Collect More Training Data

  More data → algorithm learns more general pattern
  Best solution when available

### Option 2 — Feature Selection

  Use only the most relevant features
  Fewer features → less complex model → less overfitting
  Downside: some useful information may be thrown away

### Option 3 — Regularization (Most Common)

  Keep all features but shrink the parameter values
  Prevents any one feature from having too large an effect
  Works by adding a penalty term to the cost function

---

## 10. Regularization

### Core Idea

  Large parameters → complex wiggly functions → overfitting
  Small parameters → smoother simpler functions → less overfitting
  Regularization PENALIZES large w values without eliminating features

### Regularized Cost Function (Linear Regression)

  J(w,b) = (1/2m) * SUM_i (f(x^i) - y^i)^2  +  (lambda/2m) * SUM_j w_j^2

  First term:  mean squared error (fit the data well)
  Second term: regularization (keep parameters small)

  lambda = regularization parameter (you choose this)

  By convention: b is NOT regularized (only w values are penalized)

### Effect of Lambda

  lambda = 0      → no regularization → may overfit
  lambda = huge   → all w → 0 → f(x) = b → horizontal line → underfit
  lambda = right  → balanced fit, neither overfit nor underfit

  J(w,b)   lambda too small              lambda too large
           (overfit)                      (underfit)
           wiggly curve                   flat line

  Goal: find lambda that gives "just right" model

### Regularized Gradient Descent (Linear Regression)

  w_j := w_j - alpha * [(1/m) * SUM_i (f(x^i) - y^i) * x^i_j + (lambda/m) * w_j]
  b   := b   - alpha * (1/m) * SUM_i (f(x^i) - y^i)

Rewritten to show what's happening:
  w_j := w_j * (1 - alpha*lambda/m)  -  alpha * (1/m) * SUM_i (f(x^i) - y^i) * x^i_j

  The factor (1 - alpha*lambda/m) is slightly less than 1 (e.g. 0.9998)
  → Every iteration, w_j is multiplied by ~0.9998 → gradually shrinks
  → This is why regularization reduces parameter sizes

### Regularized Cost Function (Logistic Regression)

  J(w,b) = -(1/m) * SUM_i [y^i*log(f^i) + (1-y^i)*log(1-f^i)]
           + (lambda/2m) * SUM_j w_j^2

  Same regularization term added to logistic cost

### Regularized Gradient Descent (Logistic Regression)

  w_j := w_j - alpha * [(1/m) * SUM_i (f(x^i) - y^i) * x^i_j + (lambda/m) * w_j]
  b   := b   - alpha * (1/m) * SUM_i (f(x^i) - y^i)

  Where f(x) = sigmoid(w.x + b)   ← key difference from linear regression

---

## 11. Key Formulas Summary

Sigmoid function:
  g(z) = 1 / (1 + e^(-z))

Logistic regression model:
  f(x) = g(w.x + b) = 1 / (1 + e^(-(w.x+b)))

Prediction rule:
  y_hat = 1  if  f(x) >= 0.5  (equivalently, w.x+b >= 0)
  y_hat = 0  if  f(x) < 0.5   (equivalently, w.x+b < 0)

Logistic loss (single example):
  loss = -y*log(f) - (1-y)*log(1-f)

Logistic cost function:
  J(w,b) = -(1/m) * SUM_i [y^i*log(f^i) + (1-y^i)*log(1-f^i)]

Regularized logistic cost:
  J(w,b) = -(1/m) * SUM_i [y^i*log(f^i) + (1-y^i)*log(1-f^i)]
           + (lambda/2m) * SUM_j w_j^2

Gradient descent updates (logistic + regularization):
  w_j := w_j - alpha * [(1/m) * SUM_i (f^i - y^i)*x^i_j + (lambda/m)*w_j]
  b   := b   - alpha * (1/m) * SUM_i (f^i - y^i)

---

## 12. Concept Map

  Input x
      |
      v
  z = w.x + b            ← linear combination
      |
      v
  f = sigmoid(z)         ← squashes to (0,1)
      |
      v
  f >= 0.5?
  yes → predict 1
  no  → predict 0

  Training:
  Minimize J(w,b) using gradient descent
  With regularization: add (lambda/2m)*SUM(w_j^2) to cost

---

## 13. Vocabulary

| Term              | Meaning                                              |
|-------------------|------------------------------------------------------|
| Binary classification | Output is 0 or 1 only                           |
| Sigmoid function  | Maps z to (0,1) using 1/(1+e^-z)                    |
| Decision boundary | Line/curve where model switches from 0 to 1          |
| Logistic loss     | -y*log(f) - (1-y)*log(1-f) for one example          |
| Convex function   | Bowl-shaped — has one global minimum                 |
| Underfit/High bias| Model too simple, misses pattern in data             |
| Overfit/High variance | Model memorizes training data, fails on new data |
| Regularization    | Penalty on large weights to reduce overfitting       |
| Lambda (λ)        | Regularization parameter — controls penalty strength |
| Generalization    | Model performs well on new unseen examples           |

---

_Notes: Week 3 — Machine Learning Specialization — June 2026_
