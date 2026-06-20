# Week 2 — Multiple Features, Vectorization & Feature Scaling
Coursera ML Specialization | Andrew Ng
Date: June 2026

---

## Multiple Features

So far we only used one feature x (house size) to predict price.
Now we can use multiple features — size, number of bedrooms, floors, age of house, etc.
This is way more realistic.

### New notation I need to track

| Symbol      | Meaning                                               |
|-------------|-------------------------------------------------------|
| x_j         | Feature number j                                      |
| n           | Total number of features                              |
| x^(i)       | All features of training example i (a vector)         |
| x^(i)_j     | Feature j of training example i                       |

Example — second training example with 4 features:
```
x^(2) = [1416, 3, 2, 40]

x^(2)_1 = 1416  (size in sqft)
x^(2)_2 = 3     (bedrooms)
x^(2)_3 = 2     (floors)
x^(2)_4 = 40    (age in years)
```

---

### The model with multiple features

Before (one feature):
```
f(x) = wx + b
```

Now (n features):
```
f(x) = w_1*x_1 + w_2*x_2 + w_3*x_3 + w_4*x_4 + b
```

Concrete house price example:
```
f(x) = 0.1*x_1 + 4*x_2 + 10*x_3 - 2*x_4 + 80
```

Reading the parameters:
- b = 80 → base price starts at $80k
- w_1 = 0.1 → +$100 per extra square foot
- w_2 = 4 → +$4,000 per extra bedroom
- w_3 = 10 → +$10,000 per extra floor
- w_4 = -2 → -$2,000 per year older (house gets cheaper as it ages)

### Compact vector notation

Instead of writing out all w_1 through w_n:
```
w = [w_1, w_2, ..., w_n]   (vector of weights)
x = [x_1, x_2, ..., x_n]   (vector of features)

f(x) = w.x + b   ← dot product
```

Dot product means: multiply each pair and add them all up
```
w.x = w_1*x_1 + w_2*x_2 + ... + w_n*x_n
```

This is called **Multiple Linear Regression**.

---

## Vectorization

This is one of the most practically important things in this week.

Three ways to compute the same prediction:

**Way 1 — Typing it all out (terrible for large n):**
```python
f = w[0]*x[0] + w[1]*x[1] + w[2]*x[2]
```

**Way 2 — For loop (okay but slow):**
```python
f = 0
for j in range(n):
    f += w[j] * x[j]
f += b
```

**Way 3 — NumPy vectorization (fast and short):**
```python
import numpy as np
f = np.dot(w, x) + b
```

### Why the speed difference matters

For loop runs operations ONE BY ONE:
```
Time 0: w[0] * x[0]
Time 1: w[1] * x[1]
Time 2: w[2] * x[2]
...
Time n: w[n] * x[n]
Then add them up one by one
```

NumPy runs them ALL AT ONCE in parallel hardware:
```
Time 0: ALL multiplications happen simultaneously
Then: one fast hardware sum
Done
```

Speed test with 10 million elements:
```
np.dot()  →  ~1 ms
for loop  →  ~300 ms
```

300x faster. On real datasets this matters a lot — difference between 1 minute and 5 hours.

### Vectorized parameter update

For 16 parameters, without vectorization:
```python
w[0] = w[0] - 0.1 * d[0]
w[1] = w[1] - 0.1 * d[1]
# ... 14 more lines
```

With vectorization:
```python
w = w - 0.1 * d   # all 16 updated in one line
```

---

## Gradient Descent for Multiple Features

Same idea as before, just with n weights to update:

```
w_j := w_j - alpha * (1/m) * SUM_i (f(x^i) - y^i) * x^i_j    (for each j)
b   := b   - alpha * (1/m) * SUM_i (f(x^i) - y^i)
```

Where f(x^i) = w.x^i + b  (the dot product version)

### Normal Equation — just know what it is

There's another way to find w and b for linear regression called the Normal Equation.
It uses linear algebra to solve directly without iterating.
BUT: it's slow for large n and doesn't work for other algorithms like logistic regression.
Just know the term exists. Use gradient descent.

---

## Feature Scaling

This tripped me up at first but makes sense once you see it visually.

### The problem

When features have very different ranges, gradient descent runs slowly.

```
x_1 = house size  →  300 to 2,000 sqft    (large range)
x_2 = bedrooms    →  0 to 5               (small range)
```

The contour plot of J becomes a tall skinny oval:
```
w_2 (bedrooms)
|   (  (  (  )  )  )
|     (  ( * )  )    ← gradient bounces left/right before finding minimum
|   (  (  (  )  )  )
+----------------------> w_1 (size)
```

After scaling, it becomes circular and gradient descent goes straight to minimum:
```
w_2
|      ( ( * ) )
+----------------------> w_1
```

### Three ways to scale features

**Divide by max:**
```
x_scaled = x / max(x)
House size: 300-2000  →  0.15 to 1.0
```

**Mean normalization:**
```
x_norm = (x - mean) / (max - min)
mean=600, max=2000, min=300
x_1_norm = (x_1 - 600) / 1700   →  range: -0.18 to 0.82
```

**Z-score normalization:**
```
x_zscore = (x - mean) / std_deviation
mean=600, std=450
x_1_zscore = (x_1 - 600) / 450  →  range: -0.67 to 3.1
```

### What range to aim for after scaling

```
Good:  -1 to +1
Okay:  -3 to +3   or   -0.3 to +0.3
Bad:   -100 to +100     →  rescale this
Bad:   -0.001 to +0.001 →  rescale this
```

When in doubt, just rescale. There's almost never a downside.

---

## Checking if Gradient Descent is Working

Plot J against the number of iterations — this is called the **learning curve**.

```
J (cost)
|
|  *
|    *
|      *
|        * *
|            * * * *___  ← flattening means converged
+--+--+--+--+--+--+---> iterations
   100 200 300 400 500
```

Rules:
- J should go DOWN every single iteration
- J goes UP → either alpha is too large or there's a bug
- Curve flattens → gradient descent converged

Automatic convergence test: if J decreases by less than 0.001 in one step, done.
But I find just eyeballing the curve is usually more reliable.

---

## Choosing Alpha (Learning Rate)

Try a range of values, roughly 3x bigger each time:
```
0.001 → 0.003 → 0.01 → 0.03 → 0.1 → 0.3 → 1
```

Pick the largest one that still decreases J consistently every iteration.

Debugging trick: if gradient descent seems broken, set alpha = 0.0000001
If J still increases → there's a bug in the code, not the learning rate.

---

## Feature Engineering

Creating new features from existing ones using intuition about the problem.

Example:
```
Original features: x_1 = frontage (width), x_2 = depth

New feature:  x_3 = x_1 * x_2 = AREA

Model: f(x) = w_1*x_1 + w_2*x_2 + w_3*x_3 + b
```

Now the algorithm can figure out whether frontage, depth, or area matters most.
This is genuinely useful in practice — sometimes the most predictive features
are combinations of raw inputs, not the raw inputs themselves.

---

## Polynomial Regression

Sometimes data isn't linear. We can add polynomial features to fit curves.

```
Quadratic:  f(x) = w_1*x + w_2*x^2 + b
Cubic:      f(x) = w_1*x + w_2*x^2 + w_3*x^3 + b
Sq root:    f(x) = w_1*x + w_2*sqrt(x) + b
```

The square root version is nice because it keeps growing but never curves back down —
useful for things like house prices where bigger always means more expensive.

Important: with polynomial features, MUST scale because:
```
x:   1 to 1,000
x^2: 1 to 1,000,000       ← massively different scale
x^3: 1 to 1,000,000,000   ← completely unworkable without scaling
```

---

## NumPy — things I keep using

Creating arrays:
```python
np.zeros(4)              # [0. 0. 0. 0.]
np.arange(4)             # [0 1 2 3]
np.array([1,2,3,4])      # manual
np.random.rand(4)        # random 0-1
```

Indexing (starts at 0, not 1):
```python
a[2]       # 3rd element
a[-1]      # last element
a[2:7:1]   # elements index 2 through 6
a[3:]      # from index 3 to end
a[:3]      # first 3 elements
```

Operations:
```python
a + b           # element-wise
a * 5           # scalar multiply
np.sum(a)       # sum
np.mean(a)      # average
np.dot(a, b)    # dot product — USE THIS instead of loops
```

Matrices (2D):
```python
a[1, 2]   # row 1, col 2
a[1, :]   # entire row 1
a[:, 2]   # entire column 2
```

---

## Formulas for this week

```
Model:
  f(x) = w.x + b  =  w_1*x_1 + w_2*x_2 + ... + w_n*x_n + b

Cost:
  J(w,b) = (1/2m) * SUM (f(x^i) - y^i)^2

Gradient updates:
  w_j := w_j - alpha * (1/m) * SUM (f(x^i) - y^i) * x^i_j
  b   := b   - alpha * (1/m) * SUM (f(x^i) - y^i)

Z-score normalization:
  x_norm = (x - mean) / std_deviation

Python:
  f = np.dot(w, x) + b         # prediction
  w = w - alpha * dj_dw        # update w
  b = b - alpha * dj_db        # update b
```

---

*Finished Week 2. The vectorization section was really interesting —
the speed difference between np.dot and a for loop is massive.
Also feature scaling was the part that finally clicked why gradient descent
was sometimes slow — it's the oval vs circle contour thing.*
