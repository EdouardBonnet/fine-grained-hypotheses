import Lax489179.WordTime
import Lax489179.IntegerEncoding

/-!
---
title: The integer 3-SUM problem
type: definition
---
The input is an array of $n$ distinct integers in $[-n^3,n^3]$.
It is a yes-instance if three distinct entries sum to zero. The
order of the array is arbitrary. The machine must output exactly
one word: one for yes and zero for no. The raw input is the list of
signed integer codes; lax-808846 supplies its length through the input interface.

The cubic universe is the standard integer 3-SUM convention. Arithmetic
in the specification is over $\mathbb Z$, so the sum test is exact and
has no modular overflow. Machine arithmetic remains bounded-word
arithmetic as specified in `WordPrograms`.
-/

namespace Lax489179.ThreeSUM

def HasZeroSum (input : List ℤ) : Prop :=
  ∃ i j k : Fin input.length,
    i < j ∧ j < k ∧ input[i] + input[j] + input[k] = 0

def Valid (input : List ℤ) : Prop :=
  input.Nodup ∧ ∀ z ∈ input, z.natAbs ≤ input.length ^ 3

def Correct (input : List ℤ) (output : List ℕ) : Prop :=
  (output = [1] ∧ HasZeroSum input) ∨ (output = [0] ∧ ¬ HasZeroSum input)

def problem : WordTime.Problem where
  Input := List ℤ
  size := List.length
  encode := List.map IntegerEncoding.encodeInt
  valid := Valid
  correct := Correct

end Lax489179.ThreeSUM
