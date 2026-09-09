import Lax489179.HypothesisProperties
import Lax489179Proofs.Time

namespace Lax489179Proofs

open Lax489179

/--
---
conclusion: Lax489179.HypothesisProperties.not_eth
---
-/
theorem not_eth (mode : Algorithms.Mode) :
    ¬ ETH.Hypothesis mode ↔ ∀ a : ℝ, 0 < a → SATTime.Solvable mode 3 a := by
  simp [ETH.Hypothesis]

/--
---
conclusion: Lax489179.HypothesisProperties.not_seth
---
-/
theorem not_seth (mode : Algorithms.Mode) :
    ¬ SETH.Hypothesis mode ↔ ∃ ε : ℝ, 0 < ε ∧ ε < 1 ∧
      ∀ k : ℕ, 3 ≤ k → SATTime.Solvable mode k (1 - ε) := by
  simp [SETH.Hypothesis]

/--
---
conclusion: Lax489179.HypothesisProperties.not_three_sum
---
-/
theorem not_three_sum (mode : Algorithms.Mode) :
    ¬ ThreeSUMHypothesis.Hypothesis mode ↔ ∃ ε : ℝ, 0 < ε ∧
      WordTime.Solvable mode ThreeSUM.problem (2 - ε) := by
  simp [ThreeSUMHypothesis.Hypothesis]

/--
---
conclusion: Lax489179.HypothesisProperties.not_apsp
---
-/
theorem not_apsp (mode : Algorithms.Mode) :
    ¬ APSPHypothesis.Hypothesis mode ↔ ∀ c : ℕ, 0 < c →
      ∃ ε : ℝ, 0 < ε ∧ WordTime.Solvable mode (WeightedAPSP.problem c) (3 - ε) := by
  simp [APSPHypothesis.Hypothesis, APSPHypothesis.HypothesisAt]

/--
---
conclusion: Lax489179.HypothesisProperties.randomized_eth
---
-/
theorem randomized_eth : ETH.Randomized → ETH.Deterministic := by
  rintro ⟨a, ha, h⟩
  exact ⟨a, ha, fun hs => h (sat_randomized 3 a hs)⟩

/--
---
conclusion: Lax489179.HypothesisProperties.randomized_seth
---
-/
theorem randomized_seth : SETH.Randomized → SETH.Deterministic := by
  intro h ε hε hε1
  rcases h ε hε hε1 with ⟨k, hk, h⟩
  exact ⟨k, hk, fun hs => h (sat_randomized k (1 - ε) hs)⟩

/--
---
conclusion: Lax489179.HypothesisProperties.randomized_three_sum
---
-/
theorem randomized_three_sum : ThreeSUMHypothesis.Randomized → ThreeSUMHypothesis.Deterministic := by
  intro h ε hε hs
  exact h ε hε (word_randomized ThreeSUM.problem (2 - ε) hs)

/--
---
conclusion: Lax489179.HypothesisProperties.randomized_apsp
---
-/
theorem randomized_apsp : APSPHypothesis.Randomized → APSPHypothesis.Deterministic := by
  rintro ⟨c, hc, h⟩
  exact ⟨c, hc, fun ε hε hs => h ε hε (word_randomized (WeightedAPSP.problem c) (3 - ε) hs)⟩

end Lax489179Proofs
