import Lax489179.SATTime

/-!
---
title: The Exponential Time Hypothesis (ETH)
type: definition
---
The Exponential Time Hypothesis asserts that there exists a constant
$a>0$ such that 3-CNF satisfiability has no deterministic
$O^*(2^{an})$ algorithm, where $n$ counts variables. This is the
positive-exponent formulation of ETH. In its negation, for each
positive exponent there may be a different algorithm.

`Randomized` is the stronger version excluding bounded-error
randomized algorithms. Both are defined as propositions; neither is
asserted as an axiom or claimed as a proved theorem.
-/

namespace Lax489179.ETH

def Hypothesis (mode : Algorithms.Mode) : Prop :=
  ∃ a : ℝ, 0 < a ∧ ¬ SATTime.Solvable mode 3 a

def Deterministic : Prop := Hypothesis .deterministic

def Randomized : Prop := Hypothesis .randomized

end Lax489179.ETH
