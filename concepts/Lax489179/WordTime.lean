import Lax489179.WordPrograms
import Mathlib.Data.Nat.Log
import Mathlib.Analysis.SpecialFunctions.Pow.Real

/-!
---
title: Polynomial running time on logarithmic words
type: definition
---
An encoded problem specifies its instances, size parameter $n$, input
array, admissibility promise and correct outputs. It is solvable with
exponent $a$ if one finite word-RAM program solves every admissible
instance within $C(n+2)^a$ instructions, for a constant $C>0$.

The word length is $b(1+\lfloor\log_2(n+2)\rfloor)$ for one fixed
positive integer $b$. Thus words have $\Theta(\log(n+2))$ bits and
the program is uniform in $n$. Both $b$ and the program are chosen
before the input. Every encoded input entry and the full input length
must fit in a word. These fitting conditions are requirements on the
algorithm, so a choice of small words cannot discard difficult inputs.

The size parameter counts vertices for APSP and integers for 3-SUM.
There is no arbitrary polynomial factor in these time bounds. The
additive two makes the same constant bound meaningful at small sizes.
-/

namespace Lax489179.WordTime

structure Problem where
  Input : Type
  size : Input → ℕ
  encode : Input → List ℕ
  valid : Input → Prop
  correct : Input → List ℕ → Prop

def wordLength (b n : ℕ) : ℕ := b * (Nat.log2 (n + 2) + 1)

def Fits (w : ℕ) (input : List ℕ) : Prop :=
  input.length < 2 ^ w ∧ ∀ x ∈ input, x < 2 ^ w

def Solvable (mode : Algorithms.Mode) (P : Problem) (a : ℝ) : Prop :=
  ∃ (p : WordPrograms.Program) (b : ℕ) (C : ℝ),
    0 < b ∧ 0 < C ∧ Algorithms.Allowed mode (WordPrograms.Deterministic p) ∧
    ∀ x : P.Input, P.valid x →
      Fits (wordLength b (P.size x)) (P.encode x) ∧
      ∃ t : ℕ, (t : ℝ) ≤ C * Real.rpow (P.size x + 2 : ℝ) a ∧
        WordPrograms.ComputesWithin (wordLength b (P.size x)) p
          (P.encode x) (P.correct x) t

end Lax489179.WordTime
