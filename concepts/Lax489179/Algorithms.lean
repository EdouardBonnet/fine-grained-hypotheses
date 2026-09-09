import Mathlib.SetTheory.Cardinal.Finite
import Mathlib.Data.Fintype.Pi

/-!
---
title: Deterministic and bounded-error algorithms
type: definition
---
We distinguish deterministic algorithms from randomized algorithms with
two-sided error at most $1/3$ and a worst-case running-time bound.
For a computation of at most $t$ steps, all $2^t$ strings of independent
fair bits are equally likely. Every string must lead to termination;
at least two thirds must give a correct answer. Unused bits are ignored.

Both machine models below have finite programs. In deterministic mode
the program cannot use randomness. The hypotheses themselves are
propositions, available as explicit premises in later theorems.
-/

namespace Lax489179.Algorithms

inductive Mode
  | deterministic
  | randomized
  deriving DecidableEq

/-- Deterministic mode restricts the program; randomized mode allows it. -/
def Allowed (mode : Mode) (isDeterministic : Prop) : Prop :=
  mode = .deterministic → isDeterministic

/-- Every random tape terminates, and at least two thirds return a
correct result. `none` means that the computation has not terminated. -/
def CorrectWithin {α : Type} (t : ℕ)
    (result : (Fin t → Bool) → Option α) (correct : α → Prop) : Prop :=
  (∀ r, (result r).isSome = true) ∧
  2 * 2 ^ t ≤ 3 * Nat.card {r : Fin t → Bool //
    ∃ y, result r = some y ∧ correct y}

end Lax489179.Algorithms
