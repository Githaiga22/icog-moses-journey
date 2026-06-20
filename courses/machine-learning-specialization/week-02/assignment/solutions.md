# Week 2 Programming Assignment — Linear Regression Solutions

Assignment: Practice Lab — Linear Regression with one variable
Goal: Predict restaurant profits from city population

---

## Exercise 1 — compute_cost


```python
for i in range(m):
    f_wb = w * x[i] + b
    cost_i = (f_wb - y[i]) ** 2
    total_cost += cost_i

total_cost = total_cost / (2 * m)
```

Full function:

```python
def compute_cost(x, y, w, b):
    m = x.shape[0]
    total_cost = 0

    for i in range(m):
        f_wb = w * x[i] + b
        cost_i = (f_wb - y[i]) ** 2
        total_cost += cost_i

    total_cost = total_cost / (2 * m)
    return total_cost
```

Expected output: Cost at initial w: 75.203

---

How it works step by step:

Step 1 — m = x.shape[0]
  Gets the number of training examples (97 cities in this dataset)

Step 2 — for i in range(m)
  Loops through every training example one by one

Step 3 — f_wb = w * x[i] + b
  Computes the model prediction for city i
  This is the line equation: f = wx + b

Step 4 — cost_i = (f_wb - y[i]) ** 2
  Computes the squared error for city i
  (prediction - actual profit) squared

Step 5 — total_cost += cost_i
  Accumulates the squared error

Step 6 — total_cost = total_cost / (2 * m)
  Divides by 2m to get the average squared error
  (the 2 in the denominator cancels nicely with the derivative later)

---

## Exercise 2 — compute_gradient



```python
for i in range(m):
    f_wb = w * x[i] + b
    dj_dw_i = (f_wb - y[i]) * x[i]
    dj_db_i = f_wb - y[i]
    dj_dw += dj_dw_i
    dj_db += dj_db_i

dj_dw = dj_dw / m
dj_db = dj_db / m
```

Full function:

```python
def compute_gradient(x, y, w, b):
    m = x.shape[0]
    dj_dw = 0
    dj_db = 0

    for i in range(m):
        f_wb = w * x[i] + b
        dj_dw_i = (f_wb - y[i]) * x[i]
        dj_db_i = f_wb - y[i]
        dj_dw += dj_dw_i
        dj_db += dj_db_i

    dj_dw = dj_dw / m
    dj_db = dj_db / m

    return dj_dw, dj_db
```

Expected output: Gradient at test w    -47.41610118 -4.007175051546391

---

How it works step by step:

Step 1 — m = x.shape[0]
  Number of training examples

Step 2 — for i in range(m)
  Loop through every example

Step 3 — f_wb = w * x[i] + b
  Prediction for example i (same as in cost function)

Step 4 — dj_dw_i = (f_wb - y[i]) * x[i]
  Gradient contribution for w from example i
  Formula: (prediction - actual) * feature_value

Step 5 — dj_db_i = f_wb - y[i]
  Gradient contribution for b from example i
  Formula: (prediction - actual)   [no x[i] because b has no feature]

Step 6 — Accumulate: dj_dw += dj_dw_i  and  dj_db += dj_db_i

Step 7 — Divide by m to get the average:
  dj_dw = dj_dw / m
  dj_db = dj_db / m

---

## Why these formulas?

From the math:

  J(w,b) = (1/2m) * SUM (f(x^i) - y^i)^2

Taking the derivative with respect to w:
  dJ/dw = (1/m) * SUM (f(x^i) - y^i) * x^i

Taking the derivative with respect to b:
  dJ/db = (1/m) * SUM (f(x^i) - y^i)

The code implements exactly these two formulas, summing over all m examples
and dividing by m at the end.

---

