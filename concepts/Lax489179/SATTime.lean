import Lax489179.TuringMachine
import Lax489179.Satisfiability
import Mathlib.Analysis.SpecialFunctions.Pow.Real

/-!
---
title: Exponential running time for bounded-width SAT
type: definition
---
For a fixed width $k$ and real exponent $a$, `Solvable mode k a`
means that one finite multitape machine decides $k$-CNF satisfiability
in time $C(L+1)^d 2^{an}$, where $L$ is the encoded formula length,
$n$ is the number of variables, and $C>0$ and $d$ are fixed constants.
This is the meaning of $O^*(2^{an})$ used here. The same machine and
constants serve every formula of width at most $k$.

The mode distinguishes exact deterministic decision from randomized
decision with two-sided error at most $1/3$. In either mode the step
bound holds on every input and, in randomized mode, every random tape.
Constants and the machine may depend on $k$ and $a$.
-/

namespace Lax489179.SATTime

open Algorithms Satisfiability TuringMachine

def Solvable (mode : Mode) (k : ℕ) (a : ℝ) : Prop :=
  ∃ (M : Machine) (C : ℝ) (d : ℕ), 0 < C ∧ Allowed mode (Deterministic M) ∧
    ∀ F : Formula, WidthAtMost k F →
      ∃ t : ℕ, (t : ℝ) ≤ C * ((encode F).length + 1 : ℝ) ^ d *
        Real.rpow 2 (a * F.numVars) ∧
        DecidesWithin M (encode F) (Satisfiable F) t

end Lax489179.SATTime
