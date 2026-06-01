# Environment Setup

Two tracks. Start with Track A (learning), then move to Track B (project).

## Status (June 1, 2026) — BOTH WORKING

| Track | Status | Notes |
|-------|--------|-------|
| Track A — hyperon | Working | hyperon 0.2.10, ~/metta-env, verified `!(+ 1 2)` → `[3]` |
| Track B — SWI-Prolog | Installed | SWI-Prolog 10.0.2 via brew |
| Track B — metta-moses | Cloned | ~/Documents/icog-labs/metta-moses/ |
| Track B — PeTTa | Cloned | ~/Documents/icog-labs/metta-moses/PeTTa/ |
| Track B — MeTTaLog | Pending | Install when needed for metta-moses runs |

### Activate Track A environment
```bash
source ~/metta-env/bin/activate
metta-py your-file.metta
```

---

## Track A — MeTTa Learning Environment

The fastest way to write and run MeTTa programs locally.

**Requirement:** Python 3.8+

```bash
# Create a virtual environment (recommended)
python3 -m venv metta-env
source metta-env/bin/activate

# Install hyperon (the Python MeTTa interpreter)
pip install hyperon
```

**Verify:**
```bash
metta-py
```

You should get an interactive MeTTa REPL. Type `!(+ 1 2)` and press Enter — it should return `3`.

**Write and run a .metta file:**
```bash
metta-py your-file.metta
```

This is your environment for all `exercises/` work.

---

## Track B — metta-moses Project Environment

Required to run the actual MOSES implementation.

### Step 1 — Install SWI-Prolog (9.3+)

```bash
brew install swi-prolog
```

Verify:
```bash
swipl --version
```

### Step 2 — Clone PeTTa (Prolog-based MeTTa runtime)

PeTTa is the MeTTa interpreter that metta-moses uses internally.

```bash
git clone https://github.com/trueagi-io/PeTTa
cd PeTTa
```

Follow the setup in PeTTa's own README. For basic use, no build step is required.

### Step 3 — Install MeTTaLog

MeTTaLog is required by metta-moses. Follow install instructions at the MeTTaLog repo linked from the PeTTa README.

### Step 4 — Clone metta-moses

```bash
git clone https://github.com/iCog-Labs-Dev/metta-moses
```

### Step 5 — Run the test entry point

```bash
cd metta-moses
./PeTTa/run.sh deme/tests/expand-demes-test.metta
```

---

## Quick Reference

| Tool | Purpose | Install |
|------|---------|---------|
| `hyperon` (PyPI) | MeTTa REPL + exercises | `pip install hyperon` |
| SWI-Prolog | PeTTa runtime dependency | `brew install swi-prolog` |
| PeTTa | MeTTa interpreter for metta-moses | clone from GitHub |
| MeTTaLog | Required by metta-moses | see PeTTa README |

---

## Resources

- Hyperon on PyPI: https://pypi.org/project/hyperon/
- Hyperon GitHub: https://github.com/trueagi-io/hyperon-experimental
- PeTTa GitHub: https://github.com/trueagi-io/PeTTa
- metta-moses: https://github.com/iCog-Labs-Dev/metta-moses
