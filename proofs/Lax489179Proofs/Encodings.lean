import Lax489179.EncodingProperties
import Lax489179.DistanceProperties
import Mathlib.Tactic

namespace Lax489179Proofs

open Lax489179 IntegerEncoding WeightedAPSP

/--
---
conclusion: Lax489179.EncodingProperties.decode_encode_int
---
-/
theorem decode_encode_int (z : ℤ) : decodeInt (encodeInt z) = z := by
  cases z <;> simp [encodeInt, decodeInt, Nat.add_div]

/--
---
conclusion: Lax489179.EncodingProperties.decode_encode_option
---
-/
theorem decode_encode_option (z : Option ℤ) : decodeOption (encodeOption z) = z := by
  cases z <;> simp [encodeOption, decodeOption, decode_encode_int]

/--
---
conclusion: Lax489179.EncodingProperties.encode_int_injective
---
-/
theorem encode_int_injective : Function.Injective encodeInt :=
  Function.LeftInverse.injective decode_encode_int

/--
---
conclusion: Lax489179.EncodingProperties.encode_option_injective
---
-/
theorem encode_option_injective : Function.Injective encodeOption :=
  Function.LeftInverse.injective decode_encode_option

/--
---
conclusion: Lax489179.EncodingProperties.three_entries
---
-/
theorem three_entries (input : List ℤ) (h : ThreeSUM.HasZeroSum input) :
    3 ≤ input.length := by
  rcases h with ⟨i, j, k, hij, hjk, _⟩
  have hi := i.isLt
  have hj := j.isLt
  have hk := k.isLt
  change i.val < j.val at hij
  change j.val < k.val at hjk
  omega

/--
---
conclusion: Lax489179.DistanceProperties.distance_unique
---
-/
theorem distance_unique (G : Graph) (u v : Fin G.vertices) (a b : Option ℤ)
    (ha : Distance G u v a) (hb : Distance G u v b) : a = b := by
  cases a with
  | none =>
    cases b with
    | none => rfl
    | some b => exact False.elim (ha ⟨b, hb.1⟩)
  | some a =>
    cases b with
    | none => exact False.elim (hb ⟨a, ha.1⟩)
    | some b => exact congrArg some (le_antisymm (ha.2 b hb.1) (hb.2 a ha.1))

/--
---
conclusion: Lax489179.DistanceProperties.diagonal_zero
---
-/
theorem diagonal_zero (G : Graph) (h : NoNegativeCycle G) (v : Fin G.vertices) :
    Distance G v v (some 0) :=
  ⟨Walk.nil v, h v⟩

/--
---
conclusion: Lax489179.DistanceProperties.matrix_length
---
-/
theorem matrix_length (n : ℕ) (matrix : Fin n → Fin n → Option ℤ) :
    (encodeMatrix n matrix).length = n * n := by
  simp [encodeMatrix, List.length_flatMap]

end Lax489179Proofs
