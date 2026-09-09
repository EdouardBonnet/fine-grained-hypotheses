import Lax489179.WeightedAPSP

/-!
---
title: The weighted APSP complexity assumption
type: definition
---
For some fixed positive integer $c$, no $O(n^{3-\varepsilon})$
word-RAM algorithm computes all-pairs shortest-path distances, for any
constant $\varepsilon>0$, on $n$-vertex directed graphs with integer
edge weights of absolute value at most $n^c$ and no negative cycles.
Words have $O(\log n)$ bits. The exponent $c$ is chosen before
$\varepsilon$; it is one fixed polynomial weight range.

`Deterministic` is the deterministic version.
`Randomized` also excludes randomized algorithms
with two-sided error at most $1/3$ and a worst-case running-time bound.
Success means that the entire distance matrix is correct. No
equivalence with an expected-time or zero-error variant is asserted.
Both assumptions are propositions, not axioms.
-/

namespace Lax489179.APSPHypothesis

def HypothesisAt (mode : Algorithms.Mode) (c : ℕ) : Prop :=
  ∀ ε : ℝ, 0 < ε → ¬ WordTime.Solvable mode (WeightedAPSP.problem c) (3 - ε)

def Hypothesis (mode : Algorithms.Mode) : Prop :=
  ∃ c : ℕ, 0 < c ∧ HypothesisAt mode c

def Deterministic : Prop := Hypothesis .deterministic

def Randomized : Prop := Hypothesis .randomized

end Lax489179.APSPHypothesis
