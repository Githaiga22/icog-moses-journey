# Week 3 Programming Assignment — Logistic Regression Solutions

Assignment: Practice Lab — Logistic Regression
Goal: Predict university admissions and classify microchip QA test results

---

## Exercise 1 — sigmoid function



    g = 1 / (1 + np.exp(-z))

Full function:

    def sigmoid(z):
        g = 1 / (1 + np.exp(-z))
        return g

Expected outputs:
  sigmoid(0)              = 0.5
  sigmoid([-1, 0, 1, 2]) = [0.26894142 0.5 0.73105858 0.88079708]

How it works:
  The formula is g(z) = 1 / (1 + e^(-z))
  np.exp(-z) computes e^(-z) and works on scalars AND arrays automatically.
  When z is large positive → e^(-z) → 0 → g → 1
  When z is large negative → e^(-z) → large → g → 0
  When z = 0 → e^0 = 1 → g = 1/2 = 0.5

---

## Exercise 2 — compute_cost (logistic regression)

PASTE BETWEEN ### START CODE HERE ### and ### END CODE HERE ###:

    total_cost = 0
    for i in range(m):
        z_wb = np.dot(X[i], w) + b
        f_wb = sigmoid(z_wb)
        loss = -y[i] * np.log(f_wb) - (1 - y[i]) * np.log(1 - f_wb)
        total_cost += loss
    total_cost = total_cost / m

Expected outputs:
  Cost at initial w and b (zeros):      0.693
  Cost at test w and b (non-zeros):     0.218

How it works step by step:
  Step 1 — np.dot(X[i], w) + b
    Computes z = w.x + b for training example i (dot product + bias)

  Step 2 — sigmoid(z_wb)
    Passes z through sigmoid to get the probability prediction f (between 0 and 1)

  Step 3 — loss formula
    -y * log(f) - (1-y) * log(1-f)
    When y=1: loss = -log(f)       → penalizes if f is small (missed positive)
    When y=0: loss = -log(1-f)     → penalizes if f is large (missed negative)

  Step 4 — divide total by m to get average cost

---

## Exercise 3 — compute_gradient (logistic regression)


    for i in range(m):
        z_wb = 0
        for j in range(n):
            z_wb += X[i][j] * w[j]
        z_wb += b
        f_wb = sigmoid(z_wb)

        dj_db_i = f_wb - y[i]
        dj_db += dj_db_i

        for j in range(n):
            dj_dw[j] += dj_db_i * X[i][j]

    dj_dw = dj_dw / m
    dj_db = dj_db / m

Expected outputs:
  dj_db at initial w and b (zeros):  -0.1
  dj_dw at initial w and b (zeros):  [-12.00921658929115, -11.262842205513591]

How it works step by step:
  Step 1 — build z_wb manually using inner loop
    z_wb starts at 0, then adds each w[j] * X[i][j], then adds b

  Step 2 — f_wb = sigmoid(z_wb)
    The prediction probability for example i

  Step 3 — dj_db_i = f_wb - y[i]
    The error for example i (prediction minus actual label)

  Step 4 — dj_db += dj_db_i
    Accumulates the error for the bias gradient

  Step 5 — dj_dw[j] += dj_db_i * X[i][j]
    Accumulates error * feature for each weight gradient

  Step 6 — divide both by m to get the average gradients

---

## Exercise 4 — predict


    for i in range(m):
        z_wb = 0
        for j in range(n):
            z_wb += X[i][j] * w[j]
        z_wb += b
        f_wb = sigmoid(z_wb)
        p[i] = 1 if f_wb >= 0.5 else 0

Expected output:
  Output of predict: shape (4,), value [0. 1. 1. 1.]

How it works:
  For each training example, compute z = w.x + b, apply sigmoid to get
  probability f. If f >= 0.5, predict class 1. Otherwise predict class 0.
  The threshold 0.5 corresponds to z=0 (decision boundary).

---

## Exercise 5 — compute_cost_reg (regularized cost)


    reg_cost = 0
    for j in range(n):
        reg_cost += w[j] ** 2
    reg_cost = (lambda_ / (2 * m)) * reg_cost

Expected output:
  Regularized cost: 0.6618252552483948

How it works:
  The regularization term is: (lambda / 2m) * SUM(w_j^2)
  It penalizes large weights to prevent overfitting.
  Note: b is NOT regularized (only w values are penalized).
  The starter code adds this reg_cost to the base cost automatically.

---

## Exercise 6 — compute_gradient_reg (regularized gradient)


    for j in range(n):
        dj_dw[j] = dj_dw[j] + (lambda_ / m) * w[j]

Expected output:
  dj_db: 0.07138288792343
  First few elements of regularized dj_dw:
  [[-0.010386028450548], [0.011409852883280], [0.0536273463274], [0.003140278267313]]

How it works:
  The regularized gradient adds (lambda/m) * w_j to each weight gradient.
  dj_db is NOT changed (b is not regularized).
  The starter code already calls compute_gradient to get the base gradients,
  so you only need to add the regularization term on top.

---
