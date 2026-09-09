import Lax489179.Algorithms
import Mathlib.Data.Int.Basic

/-!
---
title: Finite multitape Turing machines
type: definition
---
A machine has a fixed finite number of tapes, symbols and control states.
Each transition reads the scanned symbols, writes one symbol per tape,
and moves each head by at most one cell. Halting returns one Boolean.
Tapes are indexed by integers. Initially all heads are at zero; tape zero
contains the binary input in its original order and every other cell is
blank. Blank, false and true are distinct symbols.

A randomized transition may also inspect one fresh fair bit. A
deterministic machine has the same transition for both values of that
bit. One transition, including the transition returning an answer,
costs one step. The finite transition table is chosen before the input.
This elementary multitape model avoids any uncharged computation inside
a transition and is used for the SAT hypotheses.
-/

namespace Lax489179.TuringMachine

inductive Move
  | left
  | stay
  | right

def Move.offset : Move → ℤ
  | .left => -1
  | .stay => 0
  | .right => 1

inductive Instruction (tapes symbols states : ℕ)
  | halt (answer : Bool)
  | next (state : Fin states) (write : Fin tapes → Fin symbols)
      (move : Fin tapes → Move)

/-- The added constants ensure a nonempty control and tape set and
three distinct input/blank symbols. -/
structure Machine where
  tapes : ℕ
  symbols : ℕ
  states : ℕ
  transition : Fin (states + 1) → (Fin (tapes + 1) → Fin (symbols + 3)) →
    Bool → Instruction (tapes + 1) (symbols + 3) (states + 1)

structure Config (M : Machine) where
  state : Fin (M.states + 1)
  head : Fin (M.tapes + 1) → ℤ
  tape : Fin (M.tapes + 1) → ℤ → Fin (M.symbols + 3)
  answer : Option Bool

def init (M : Machine) (input : List Bool) : Config M where
  state := 0
  head := fun _ => 0
  tape := fun j z =>
    if j = 0 ∧ 0 ≤ z then
      match input[z.toNat]? with
      | none => 0
      | some false => 1
      | some true => 2
    else 0
  answer := none

/-- A halted configuration is unchanged, allowing a run to be padded. -/
def step (M : Machine) (coin : Bool) (c : Config M) : Config M :=
  match c.answer with
  | some _ => c
  | none =>
    match M.transition c.state (fun j => c.tape j (c.head j)) coin with
    | .halt b => { c with answer := some b }
    | .next q write move =>
      { state := q
        head := fun j => c.head j + (move j).offset
        tape := fun j z => if z = c.head j then write j else c.tape j z
        answer := none }

def run (M : Machine) : (t : ℕ) → (Fin t → Bool) → Config M → Config M
  | 0, _, c => c
  | t + 1, r, c => run M t (fun i => r i.succ) (step M (r 0) c)

def Deterministic (M : Machine) : Prop :=
  ∀ q scanned, M.transition q scanned false = M.transition q scanned true

def DecidesWithin (M : Machine) (input : List Bool) (answer : Prop) (t : ℕ) : Prop :=
  Algorithms.CorrectWithin t (fun r => (run M t r (init M input)).answer)
    (fun b => b = true ↔ answer)

end Lax489179.TuringMachine
