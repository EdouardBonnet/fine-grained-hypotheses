import Lax489179.SATTime
import Lax489179.WordTime

/-!
---
title: Monotonicity of running-time bounds
type: lemma
---
Increasing a time exponent preserves solvability. A solver for width
at most $k$ also solves every smaller SAT width. A deterministic solver
is an admissible randomized solver with the same time bound.
-/

namespace Lax489179.TimeProperties

open Algorithms

axiom sat_exponent_mono (mode : Mode) (k : ℕ) (a b : ℝ) (hab : a ≤ b)
    (h : SATTime.Solvable mode k a) : SATTime.Solvable mode k b

axiom sat_width_mono (mode : Mode) (k l : ℕ) (a : ℝ) (hkl : k ≤ l)
    (h : SATTime.Solvable mode l a) : SATTime.Solvable mode k a

axiom word_exponent_mono (mode : Mode) (P : WordTime.Problem) (a b : ℝ) (hab : a ≤ b)
    (h : WordTime.Solvable mode P a) : WordTime.Solvable mode P b

axiom sat_randomized (k : ℕ) (a : ℝ) (h : SATTime.Solvable .deterministic k a) :
    SATTime.Solvable .randomized k a

axiom word_randomized (P : WordTime.Problem) (a : ℝ)
    (h : WordTime.Solvable .deterministic P a) : WordTime.Solvable .randomized P a

end Lax489179.TimeProperties
