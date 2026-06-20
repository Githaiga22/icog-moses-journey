# Week 1 — Introduction to Machine Learning
Coursera ML Specialization | Andrew Ng
Date: June 2026

---

## What is Machine Learning?

Arthur Samuel (1950s) defined it as:
"The field of study that gives computers the ability to learn without being explicitly programmed."

The best example is his checkers program. He didn't teach it the rules of good play — he just let it play tens of thousands of games against itself. It watched which positions led to wins and which led to losses, and over time it got better and better. Eventually it beat Samuel himself.

My takeaway: the more data and practice you give a learning algorithm, the better it gets. Same as humans really.

---

## The Two Main Types

```
Machine Learning
├── Supervised Learning      ← most widely used, drives most economic value
│   ├── Regression           ← output is a NUMBER
│   └── Classification       ← output is a CATEGORY
├── Unsupervised Learning
│   ├── Clustering
│   ├── Anomaly Detection
│   └── Dimensionality Reduction
└── Reinforcement Learning   ← covered in Course 3
```

---

## Supervised Learning

You give the algorithm examples that already have the correct answers (labels).
It learns from those examples and then predicts on new ones it has never seen.

```
Training phase:   (x, y) pairs  →  algorithm learns the pattern
Prediction phase: new x alone   →  algorithm outputs ŷ
```

Real-world examples I found interesting:

| Input x               | Output y               | What it does          |
|-----------------------|------------------------|-----------------------|
| Email                 | Spam or Not Spam       | Spam filter           |
| Audio clip            | Text transcript        | Speech recognition    |
| English text          | Spanish text           | Translation           |
| Ad + user info        | Will they click?       | Online advertising    |
| Image + radar data    | Position of other cars | Self-driving car      |
| Photo of a phone      | Defect or no defect    | Visual inspection     |

---

### Regression — predicting a number

Output can be any value from a continuous range — like house prices.

```
Price ($k)
    |
400 |        x
    |     x     x
300 |  x           x
    |        x
200 |                   x  <-- where does a 1250 sqft house fall?
    |
100 |
    +--+--+--+--+--+--+---> Size (sq ft)
       500 1000 1500 2000
```

Fitting a straight line to this data lets you estimate price for any new house.
The output is not 0 or 1 — it's any number like 150,000 or 183,000. That's what makes it regression.

---

### Classification — predicting a category

Output is one of a small number of fixed categories.

```
Malignant (1) |  x  x     x    x
              |
Benign    (0) |     o  o     o     o
              +-------------------------> Tumor Size
```

With two input features (age + tumor size), the algorithm finds a boundary line:

```
Age
 |    o   o  |  x  x
 |  o    o   |    x
 |    o      |  x
 |  o        | x  x
 +-----------+-----------> Tumor Size
             ^
          decision boundary
```

Regression vs Classification at a glance:

| Feature          | Regression            | Classification         |
|------------------|-----------------------|------------------------|
| Output type      | Any number            | Fixed categories       |
| Example output   | 150k, 220k, 183k      | 0 or 1, cat or dog     |
| Possible values  | Infinite              | Finite (2, 3, 4...)    |
| Example          | House price           | Tumor diagnosis        |

---

## Unsupervised Learning

No labels. The algorithm has to find patterns or structure in the data on its own.

```
Supervised:    data has (x, y) labels    → find the mapping
Unsupervised:  data has (x) only         → find the structure
```

Three types I need to know:

**Clustering** — groups similar data together
- Google News groups related articles automatically (finds "panda", "twins", "zoo" articles together)
- DNA analysis: groups people by genetic patterns
- Customer segmentation: groups customers without being told what the groups are

**Anomaly Detection** — spots unusual data points
- Used in fraud detection — unusual transactions = possible fraud

**Dimensionality Reduction** — compresses big datasets into smaller ones
- Keeps as much useful information as possible while reducing size

---

## Linear Regression

The simplest supervised learning model. Fits a straight line to predict a number.

### Notation I need to remember

| Symbol     | Meaning                                  |
|------------|------------------------------------------|
| x          | Input feature (e.g. house size in sqft)  |
| y          | True target value (e.g. actual price)    |
| ŷ          | Model's prediction                       |
| m          | Number of training examples              |
| (x^i, y^i) | The i-th training example                |
| w          | Weight — controls the slope of the line  |
| b          | Bias — controls where line crosses y-axis|

### The model formula

```
f(x) = wx + b
```

What w and b actually do:
```
w=0, b=1.5  →  flat horizontal line at 1.5
w=0.5, b=0  →  line through origin, slope 0.5
w=0.5, b=1  →  line that starts at y=1, slope 0.5
```

```
y
|              /  w=0.5, b=1
|             /
|    --------    w=0, b=1.5
|           /
|          /    w=0.5, b=0
+-----------> x
```

This is called **univariate linear regression** — one input feature.

The full flow:

```
Training Set (x, y pairs)
        |
        v
  Learning Algorithm
        |
        v
   Function f(x) = wx + b
        |
   new input x
        |
        v
   Prediction ŷ
```

---

## Cost Function

I need a way to measure how badly (or well) my line fits the data.
That's the cost function.

### Error for one example
```
error = ŷ - y  =  f(x^i) - y^i
```

### The squared error cost function
```
         1
J(w,b) = ── · Σ (f(x^i) - y^i)²
         2m   i=1 to m
```

Why square the errors?
- Makes all errors positive (positive and negative errors don't cancel)
- Punishes large errors much more than small ones

Why divide by 2? — purely for cleaner math later (the 2 cancels with a derivative)

When J is small → line fits well
When J is large → line fits poorly
Goal: find w and b that minimize J

### What J looks like — 1 parameter (simplified)

```
J(w)
|
|  *                     *
|     *               *
|        *         *
|           *   *
|              *   ← minimum
+--+--+--+--+--+--+---> w
```

### With 2 parameters — J is a 3D bowl

```
         J(w,b)
           |  bowl shaped
        ___+___
      /         \
     /     *     \    ← minimum at center
    |      |      |
     \_____|_____/

  w (horizontal), b (depth), J (height)
```

Contour plot (top-down view):
```
b
|    (   (   (   )   )   )
|      (   ( * )   )       ← center = minimum
|    (   (   (   )   )   )
+-------------------------> w
```
Each oval = same cost value. Smallest oval's center = best w and b.

---

## Gradient Descent

The algorithm that automatically finds the w and b that minimize J.

Think of it like being on a hilly landscape and wanting to reach the lowest valley. At each step, look around 360 degrees, take a small step in the steepest downhill direction. Repeat until you're at the bottom.

### The update rule

Repeat until convergence:
```
w := w - α · (∂J/∂w)
b := b - α · (∂J/∂b)
```

CRITICAL: update w and b at the same time (simultaneous update)

```python
# Correct way:
temp_w = w - alpha * dJ_dw
temp_b = b - alpha * dJ_db
w = temp_w   # update together
b = temp_b

# Wrong way (don't do this):
w = w - alpha * dJ_dw   # w changes before b is computed
b = b - alpha * dJ_db   # b now uses the NEW w — wrong
```

### Learning rate α

| α too small | Works but painfully slow — tiny baby steps         |
|-------------|-----------------------------------------------------|
| α too large | Overshoots minimum, bounces around, may diverge    |
| α just right| Converges efficiently to global minimum             |

```
Far from minimum  → steep slope  → big step (naturally)
Near minimum      → flat slope   → small step (naturally)
At minimum        → slope = 0    → step = 0  (stays there)
```

The step size naturally shrinks as you approach the minimum even with fixed α.

### Derivatives for linear regression

```
∂J/∂w = (1/m) · Σ (f(x^i) - y^i) · x^i
∂J/∂b = (1/m) · Σ (f(x^i) - y^i)
```

Full update:
```
w := w - α · (1/m) · Σ (wx^i + b - y^i) · x^i
b := b - α · (1/m) · Σ (wx^i + b - y^i)
```

### Why linear regression always finds the global minimum

The squared error cost function is convex — bowl shaped. Only one minimum.
No local minima to get stuck in.

```
Convex (linear regression):   Non-convex (neural networks):
      J                              J
      |   bowl                       |  /\    /\
      |  / \                         | /  \  /  \
      | /   \                        |/    \/    \
      |/     \                       |  local minima
      +-------                      +-----------
      one minimum                   multiple minima
```

### Batch gradient descent

"Batch" means every update step uses ALL m training examples.
This is the standard version for linear regression.

---

## Putting it all together

```
1. Collect training data (x^i, y^i) pairs
2. Model: f(x) = wx + b
3. Start: w=0, b=0
4. Compute cost J(w,b)
5. Compute gradients ∂J/∂w and ∂J/∂b
6. Update: w := w - α·(∂J/∂w),  b := b - α·(∂J/∂b)
7. Repeat 4-6 until converged
8. Predict new data: ŷ = wx + b
```

---

## Formulas to memorize

```
Model:         f(x) = wx + b

Cost:          J(w,b) = (1/2m) · Σ (f(x^i) - y^i)²

Gradients:     ∂J/∂w = (1/m) · Σ (f(x^i) - y^i) · x^i
               ∂J/∂b = (1/m) · Σ (f(x^i) - y^i)

Updates:       w := w - α · ∂J/∂w
               b := b - α · ∂J/∂b

Goal:          minimize J(w,b)
```

---

*Week 1 done. Main concepts: supervised vs unsupervised, regression vs classification,
linear regression model, cost function, gradient descent. Moving to Week 2.*
