import Lax489179.TuringMachine
import Lax489179.WordPrograms

/-!
---
title: Exact correctness of deterministic computations
type: lemma
---
For a deterministic program the bounded-error specification is
equivalent to exact correctness on the all-zero random tape. Thus
the common probability-based definition gives ordinary deterministic
decision and computation when randomness is forbidden.
-/

namespace Lax489179.DeterministicSemantics

axiom turing_exact (M : TuringMachine.Machine) (h : TuringMachine.Deterministic M)
    (input : List Bool) (answer : Prop) (t : ℕ) :
    TuringMachine.DecidesWithin M input answer t ↔
      ∃ b, (TuringMachine.run M t (fun _ => false) (TuringMachine.init M input)).answer =
        some b ∧ (b = true ↔ answer)

axiom word_exact (w : ℕ) (p : WordPrograms.Program) (h : WordPrograms.Deterministic p)
    (input : List ℕ) (correct : List ℕ → Prop) (t : ℕ) :
    WordPrograms.ComputesWithin w p input correct t ↔
      ∃ y, WordPrograms.output (WordPrograms.run w p t (fun _ => false)
        (WordPrograms.init input)) = some y ∧ correct y

end Lax489179.DeterministicSemantics
