import Lax489179.TimeProperties
import Mathlib.Tactic

namespace Lax489179Proofs

open Lax489179 Algorithms Satisfiability

/--
---
conclusion: Lax489179.TimeProperties.sat_exponent_mono
---
-/
theorem sat_exponent_mono (mode : Mode) (k : ℕ) (a b : ℝ) (hab : a ≤ b)
    (h : SATTime.Solvable mode k a) : SATTime.Solvable mode k b := by
  rcases h with ⟨M, C, d, hC, hM, h⟩
  refine ⟨M, C, d, hC, hM, fun F hF => ?_⟩
  rcases h F hF with ⟨t, ht, hrun⟩
  refine ⟨t, ht.trans ?_, hrun⟩
  apply mul_le_mul_of_nonneg_left
  · exact Real.rpow_le_rpow_of_exponent_le (by norm_num)
      (mul_le_mul_of_nonneg_right hab (Nat.cast_nonneg F.numVars))
  · positivity

/--
---
conclusion: Lax489179.TimeProperties.sat_width_mono
---
-/
theorem sat_width_mono (mode : Mode) (k l : ℕ) (a : ℝ) (hkl : k ≤ l)
    (h : SATTime.Solvable mode l a) : SATTime.Solvable mode k a := by
  rcases h with ⟨M, C, d, hC, hM, h⟩
  exact ⟨M, C, d, hC, hM, fun F hF => h F (fun clause hc => (hF clause hc).trans hkl)⟩

/--
---
conclusion: Lax489179.TimeProperties.word_exponent_mono
---
-/
theorem word_exponent_mono (mode : Mode) (P : WordTime.Problem) (a b : ℝ) (hab : a ≤ b)
    (h : WordTime.Solvable mode P a) : WordTime.Solvable mode P b := by
  rcases h with ⟨p, d, C, hd, hC, hp, h⟩
  refine ⟨p, d, C, hd, hC, hp, fun x hx => ?_⟩
  rcases h x hx with ⟨hfit, t, ht, hrun⟩
  refine ⟨hfit, t, ht.trans ?_, hrun⟩
  exact mul_le_mul_of_nonneg_left
    (Real.rpow_le_rpow_of_exponent_le (by have := Nat.cast_nonneg (α := ℝ) (P.size x); linarith) hab)
    hC.le

/--
---
conclusion: Lax489179.TimeProperties.sat_randomized
---
-/
theorem sat_randomized (k : ℕ) (a : ℝ) (h : SATTime.Solvable .deterministic k a) :
    SATTime.Solvable .randomized k a := by
  rcases h with ⟨M, C, d, hC, _, h⟩
  exact ⟨M, C, d, hC, by simp [Allowed], h⟩

/--
---
conclusion: Lax489179.TimeProperties.word_randomized
---
-/
theorem word_randomized (P : WordTime.Problem) (a : ℝ)
    (h : WordTime.Solvable .deterministic P a) : WordTime.Solvable .randomized P a := by
  rcases h with ⟨p, b, C, hb, hC, _, h⟩
  exact ⟨p, b, C, hb, hC, by simp [Allowed], h⟩

end Lax489179Proofs
