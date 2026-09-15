import Lax808846.Ram
import Lax489179.Algorithms

/-!
---
title: Word-RAM programs with optional fair coins
type: definition
---
We use the finite word-RAM instruction set of lax-808846 and add one
instruction writing a fresh fair bit to a specified cell. In deterministic
mode this instruction is forbidden. All arithmetic, indirect addressing,
input access and output use lax-808846's word semantics. Input is a read-only
array, writable memory starts at zero, and output is append-only.

Each fetched instruction costs one step, including a coin or a halt.
Detecting an out-of-range program counter also costs one step in this
wrapper. Halted configurations are unchanged by further padding steps.
The bound thus includes the full output and termination. A random word
can be assembled from fair bits using the ordinary instructions.
The probability space is the uniform distribution on the finite bit
strings supplied to these transitions; it does not provide random advice.
-/

namespace Lax489179.WordPrograms

open Lax808846.Ram

inductive Instruction
  | ordinary (instruction : Instr)
  | coin (destination : ℕ)

abbrev Program := List Instruction

structure Config where
  state : State
  halted : Bool

def init (input : List ℕ) : Config := ⟨initState input, false⟩

def step (w : ℕ) (p : Program) (bit : Bool) (c : Config) : Config :=
  if c.halted then c else
    match p[c.state.pc]? with
    | none => { c with halted := true }
    | some (.ordinary instruction) =>
      match instruction.effect w c.state with
      | none => { c with halted := true }
      | some s => ⟨s, false⟩
    | some (.coin a) =>
      ⟨{ c.state with
          pc := c.state.pc + 1
          mem := setCell w c.state.mem a bit.toNat }, false⟩

def run (w : ℕ) (p : Program) : (t : ℕ) → (Fin t → Bool) → Config → Config
  | 0, _, c => c
  | t + 1, r, c => run w p t (fun i => r i.succ) (step w p (r 0) c)

def output (c : Config) : Option (List ℕ) :=
  if c.halted then some c.state.out else none

def Deterministic (p : Program) : Prop :=
  ∀ a, Instruction.coin a ∉ p

def ComputesWithin (w : ℕ) (p : Program) (input : List ℕ)
    (correct : List ℕ → Prop) (t : ℕ) : Prop :=
  Algorithms.CorrectWithin t (fun r => output (run w p t r (init input))) correct

end Lax489179.WordPrograms
