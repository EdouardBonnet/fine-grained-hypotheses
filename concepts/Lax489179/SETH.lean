import Lax489179.SATTime

/-!
---
title: The Strong Exponential Time Hypothesis (SETH)
type: definition
---
For every $0<\varepsilon<1$, there is a width $k\geq 3$ such that
$k$-CNF satisfiability has no deterministic
$O^*(2^{(1-\varepsilon)n})$ algorithm. The width may depend on
$\varepsilon$. This is the exponential-rate formulation of SETH;
it expresses the absence of a fixed improvement below base two across
all fixed clause widths, even when each width has its own algorithm.

`RandomizedSETH` excludes bounded-error randomized algorithms instead.
The polynomial factor in the full formula length is explicit in
`SATTime.Solvable`. These are propositions, not axioms.
-/

namespace Lax489179.SETH

def Hypothesis (mode : Algorithms.Mode) : Prop :=
  ∀ ε : ℝ, 0 < ε → ε < 1 →
    ∃ k : ℕ, 3 ≤ k ∧ ¬ SATTime.Solvable mode k (1 - ε)

def SETH : Prop := Hypothesis .deterministic

def RandomizedSETH : Prop := Hypothesis .randomized

end Lax489179.SETH
