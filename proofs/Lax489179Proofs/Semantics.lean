import Lax489179.DeterministicSemantics
import Mathlib.Tactic

namespace Lax489179Proofs

open Lax489179

theorem correctWithin_constant {α : Type} (t : ℕ) (value : Option α) (correct : α → Prop) :
    Algorithms.CorrectWithin t (fun _ => value) correct ↔
      ∃ y, value = some y ∧ correct y := by
  classical
  cases value with
  | none => simp [Algorithms.CorrectWithin]
  | some y =>
    by_cases hy : correct y
    · simp [Algorithms.CorrectWithin, hy, Nat.card_eq_fintype_card]
    · simp [Algorithms.CorrectWithin, hy, Nat.card_eq_fintype_card]

theorem turing_step_coin (M : TuringMachine.Machine) (h : TuringMachine.Deterministic M)
    (b b' : Bool) (c : TuringMachine.Config M) :
    TuringMachine.step M b c = TuringMachine.step M b' c := by
  have heq := h c.state (fun j => c.tape j (c.head j))
  cases b <;> cases b' <;> simp [TuringMachine.step, heq]

theorem turing_run_coin (M : TuringMachine.Machine) (h : TuringMachine.Deterministic M)
    (t : ℕ) (r r' : Fin t → Bool) (c : TuringMachine.Config M) :
    TuringMachine.run M t r c = TuringMachine.run M t r' c := by
  induction t generalizing c with
  | zero => rfl
  | succ t ih =>
    simp only [TuringMachine.run]
    rw [turing_step_coin M h (r 0) (r' 0) c]
    exact ih _ _ _

theorem word_step_coin (w : ℕ) (p : WordPrograms.Program) (h : WordPrograms.Deterministic p)
    (b b' : Bool) (c : WordPrograms.Config) :
    WordPrograms.step w p b c = WordPrograms.step w p b' c := by
  unfold WordPrograms.step
  by_cases hc : c.halted = true
  · simp [hc]
  · simp only [hc, Bool.false_eq_true, ↓reduceIte]
    cases hi : p[c.state.pc]? with
    | none => rfl
    | some i =>
      cases i with
      | ordinary i => rfl
      | coin a => exact False.elim (h a (List.mem_of_getElem? hi))

theorem word_run_coin (w : ℕ) (p : WordPrograms.Program) (h : WordPrograms.Deterministic p)
    (t : ℕ) (r r' : Fin t → Bool) (c : WordPrograms.Config) :
    WordPrograms.run w p t r c = WordPrograms.run w p t r' c := by
  induction t generalizing c with
  | zero => rfl
  | succ t ih =>
    simp only [WordPrograms.run]
    rw [word_step_coin w p h (r 0) (r' 0) c]
    exact ih _ _ _

/--
---
conclusion: Lax489179.DeterministicSemantics.turing_exact
---
-/
theorem turing_exact (M : TuringMachine.Machine) (h : TuringMachine.Deterministic M)
    (input : List Bool) (answer : Prop) (t : ℕ) :
    TuringMachine.DecidesWithin M input answer t ↔
      ∃ b, (TuringMachine.run M t (fun _ => false) (TuringMachine.init M input)).answer =
        some b ∧ (b = true ↔ answer) := by
  unfold TuringMachine.DecidesWithin
  simp_rw [turing_run_coin M h t _ (fun _ => false)]
  exact correctWithin_constant _ _ _

/--
---
conclusion: Lax489179.DeterministicSemantics.word_exact
---
-/
theorem word_exact (w : ℕ) (p : WordPrograms.Program) (h : WordPrograms.Deterministic p)
    (input : List ℕ) (correct : List ℕ → Prop) (t : ℕ) :
    WordPrograms.ComputesWithin w p input correct t ↔
      ∃ y, WordPrograms.output (WordPrograms.run w p t (fun _ => false)
        (WordPrograms.init input)) = some y ∧ correct y := by
  unfold WordPrograms.ComputesWithin
  simp_rw [word_run_coin w p h t _ (fun _ => false)]
  exact correctWithin_constant _ _ _

end Lax489179Proofs
