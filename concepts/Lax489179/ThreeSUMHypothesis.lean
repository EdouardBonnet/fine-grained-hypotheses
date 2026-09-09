import Lax489179.ThreeSUM

/-!
---
title: The 3-SUM Hypothesis
type: definition
---
The integer 3-SUM Hypothesis excludes an $O(n^{2-\varepsilon})$
word-RAM algorithm for every constant $\varepsilon>0$, on arrays of
$n$ distinct integers in $[-n^3,n^3]$. Words have $O(\log n)$ bits.

`Deterministic` uses deterministic algorithms;
`Randomized` also excludes randomized algorithms with
two-sided error at most $1/3$ and a worst-case time bound. The latter
is the randomized convention supplied by this submission. We do not
identify it here with an expected-time or a zero-error formulation.

These are propositions. The bound concerns a fixed improvement in the
exponent; it permits savings by logarithmic or other subpolynomial factors.
-/

namespace Lax489179.ThreeSUMHypothesis

def Hypothesis (mode : Algorithms.Mode) : Prop :=
  ∀ ε : ℝ, 0 < ε → ¬ WordTime.Solvable mode ThreeSUM.problem (2 - ε)

def Deterministic : Prop := Hypothesis .deterministic

def Randomized : Prop := Hypothesis .randomized

end Lax489179.ThreeSUMHypothesis
