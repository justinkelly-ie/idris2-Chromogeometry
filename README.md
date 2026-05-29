# idris2-Chromogeometry

**A pure, non-linear discrete 3-metric Chromogeometry engine for [Idris 2](https://github.com/idris-lang/Idris2).**

[![Idris2](https://img.shields.io/badge/Idris2-Geometry-blue.svg)](https://github.com/idris-lang/Idris2)
[![Metrics](https://img.shields.io/badge/Metrics-RGB_3_Metric-red.svg)]()
[![Precision](https://img.shields.io/badge/Precision-Exact_Integer-green.svg)]()

---

## Overview

`idris2-Chromogeometry` provides the geometric foundation for the [Nat-Science](https://github.com/justinkelly-ie/Nat-Science) discrete physics ecosystem, implementing Norman Wildberger's **Rational Chromogeometry**. 

Traditional geometry relies on continuous floating-point fields, square roots, and decimal approximations that introduce calculation drift and precision loss. 

In contrast, **Rational Chromogeometry** represents distance and angle entirely through non-linear integer relations (**Quadrance** and **Spread**) over Natural Numbers. Calculations are performed using cross-multiplied integer numerators and denominators, guaranteeing exact mathematical verification without dropping single bits of precision.

---

## The Three RGB Metrics

Space is mapped across three interlocked geometric metrics simultaneously. Every pixel coordinate $(x,y)$ has three distinct quadrances:

| Metric | Physical Realm | Formula | Role |
|---|---|---|---|
| 🔵 **Blue** | Euclidean Matter | $x^2 + y^2$ | Stable particle localization and structural boundary locks. |
| 🔴 **Red** | Minkowski Space | $x^2 - y^2$ | Light cones, photon paths, relativistic null-separations. |
| 🟢 **Green** | Toroidal Tension | $2xy$ | Background grid tension and color confinement. |

---

## Key Modules

*   **`Math.Chromogeometry`**: The core geometry engine. Exposes the three metrics and provides cross-multiplied quadrance and spread functions (such as `quadranceNL` and `spreadNL`) to prove exact geometric theorems.

---

## Installation & Pack Integration

Resolve locally via `pack.toml`:

```toml
[custom.all.idris2-chromogeometry]
type = "local"
path = "../idris2-Chromogeometry"
ipkg = "idris2-chromogeometry.ipkg"
```

Then add to your `.ipkg` file's `depends` list:

```idris
depends = base, contrib, idris2-chromogeometry
```

---

© Justin Kelly. All rights reserved.
