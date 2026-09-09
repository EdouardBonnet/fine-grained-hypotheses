import Lax489179.ETH
import Lax489179.SETH
import Lax489179.APSPHypothesis
import Lax489179.ThreeSUMHypothesis

/-!
---
title: Negations and algorithm conventions for the four hypotheses
type: lemma
---
Negating ETH allows a separate 3-SAT algorithm for each positive
exponent. Negating SETH gives one positive exponent improvement that
works for every fixed clause width, with the algorithm allowed to
depend on the width. Negating the 3-SUM Hypothesis gives a truly
subquadratic solver. Negating the APSP assumption gives, for each
fixed weight exponent, some truly subcubic solver; its improvement
may depend on that weight exponent.

For each hypothesis, its randomized version implies its deterministic
version. These are logical consequences of the specified algorithm
classes; all four hypotheses themselves remain explicit premises.
-/

namespace Lax489179.HypothesisProperties

axiom not_eth (mode : Algorithms.Mode) :
    ¬ ETH.Hypothesis mode ↔ ∀ a : ℝ, 0 < a → SATTime.Solvable mode 3 a

axiom not_seth (mode : Algorithms.Mode) :
    ¬ SETH.Hypothesis mode ↔ ∃ ε : ℝ, 0 < ε ∧ ε < 1 ∧
      ∀ k : ℕ, 3 ≤ k → SATTime.Solvable mode k (1 - ε)

axiom not_three_sum (mode : Algorithms.Mode) :
    ¬ ThreeSUMHypothesis.Hypothesis mode ↔ ∃ ε : ℝ, 0 < ε ∧
      WordTime.Solvable mode ThreeSUM.problem (2 - ε)

axiom not_apsp (mode : Algorithms.Mode) :
    ¬ APSPHypothesis.Hypothesis mode ↔ ∀ c : ℕ, 0 < c →
      ∃ ε : ℝ, 0 < ε ∧ WordTime.Solvable mode (WeightedAPSP.problem c) (3 - ε)

axiom randomized_eth : ETH.Randomized → ETH.Deterministic

axiom randomized_seth : SETH.Randomized → SETH.Deterministic

axiom randomized_three_sum : ThreeSUMHypothesis.Randomized → ThreeSUMHypothesis.Deterministic

axiom randomized_apsp : APSPHypothesis.Randomized → APSPHypothesis.Deterministic

end Lax489179.HypothesisProperties
