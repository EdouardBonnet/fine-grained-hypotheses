import Mathlib.Data.List.Basic
import Mathlib.Data.Fin.Basic

/-!
---
title: Bounded-width CNF satisfiability and its encoding
type: definition
---
A CNF formula has $n$ indexed Boolean variables. A literal is a variable
and a polarity; a clause is a disjunction of literals and a formula is
a conjunction of clauses. Width at most $k$ means at most $k$ literals
in each clause. The empty conjunction is true and an empty clause is false.

The binary encoding gives $n$, the number of clauses, each clause length,
and each literal's index and sign, in that order. Natural numbers use
unary followed by a zero. This self-delimiting encoding has polynomial
length in $n$ and the usual explicit formula size. Polynomial factors
in its full length are retained in the SAT running-time bounds; the
exponential parameter is $n$, not the number of clauses or encoded bits.
Unused indexed variables, repeated literals and repeated clauses are allowed.
-/

namespace Lax489179.Satisfiability

abbrev Literal (n : ℕ) := Fin n × Bool
abbrev Clause (n : ℕ) := List (Literal n)

structure Formula where
  numVars : ℕ
  clauses : List (Clause numVars)

def Satisfiable (F : Formula) : Prop :=
  ∃ assignment : Fin F.numVars → Bool,
    ∀ clause ∈ F.clauses, ∃ literal ∈ clause, assignment literal.1 = literal.2

def WidthAtMost (k : ℕ) (F : Formula) : Prop :=
  ∀ clause ∈ F.clauses, clause.length ≤ k

def encodeNat (n : ℕ) : List Bool := List.replicate n true ++ [false]

def encodeLiteral {n : ℕ} (literal : Literal n) : List Bool :=
  encodeNat literal.1.val ++ [literal.2]

def encodeClause {n : ℕ} (clause : Clause n) : List Bool :=
  encodeNat clause.length ++ clause.flatMap encodeLiteral

def encode (F : Formula) : List Bool :=
  encodeNat F.numVars ++ encodeNat F.clauses.length ++ F.clauses.flatMap encodeClause

end Lax489179.Satisfiability
