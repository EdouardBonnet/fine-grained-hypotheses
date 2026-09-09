import Lax489179.WordTime
import Lax489179.IntegerEncoding
import Mathlib.Data.List.FinRange

/-!
---
title: Weighted all-pairs shortest paths
type: definition
---
An input is a directed graph on vertices $0,\ldots,n-1$ with optional
integer edge weights. A walk may repeat vertices and its weight is the
sum of its edge weights. We promise that every closed walk has
nonnegative weight, and that each edge weight has absolute value at
most $n^c$, for a fixed positive integer $c$.

For each ordered vertex pair the output is its minimum walk weight,
or infinity exactly when there is no walk. An empty walk has weight
zero, so every diagonal distance is zero under the promise. The
specification uses all finite walks, not a bounded or approximate
surrogate for shortest paths. Negative weights and disconnected graphs
are both included.

The input array is the vertex count followed by the $n^2$ adjacency
entries in row-major order. The output consists of all $n^2$ distances
in the same order, without a header. Optional-integer encoding separates
missing edges and infinite distances from finite zero. Producing the
entire matrix is charged by the word-RAM execution semantics.
-/

namespace Lax489179.WeightedAPSP

structure Graph where
  vertices : ℕ
  edge : Fin vertices → Fin vertices → Option ℤ

inductive Walk (G : Graph) : Fin G.vertices → Fin G.vertices → ℤ → Prop
  | nil (v : Fin G.vertices) : Walk G v v 0
  | cons {u v z : Fin G.vertices} {a b : ℤ}
      (edge : G.edge u v = some a) (tail : Walk G v z b) : Walk G u z (a + b)

def NoNegativeCycle (G : Graph) : Prop :=
  ∀ v d, Walk G v v d → 0 ≤ d

def BoundedWeights (c : ℕ) (G : Graph) : Prop :=
  ∀ u v z, G.edge u v = some z → z.natAbs ≤ G.vertices ^ c

def Distance (G : Graph) (u v : Fin G.vertices) : Option ℤ → Prop
  | none => ¬ ∃ d, Walk G u v d
  | some d => Walk G u v d ∧ ∀ d', Walk G u v d' → d ≤ d'

def encodeMatrix (n : ℕ) (matrix : Fin n → Fin n → Option ℤ) : List ℕ :=
  (List.finRange n).flatMap fun i =>
    (List.finRange n).map fun j => IntegerEncoding.encodeOption (matrix i j)

def encode (G : Graph) : List ℕ := G.vertices :: encodeMatrix G.vertices G.edge

def Correct (G : Graph) (output : List ℕ) : Prop :=
  ∃ matrix : Fin G.vertices → Fin G.vertices → Option ℤ,
    output = encodeMatrix G.vertices matrix ∧ ∀ u v, Distance G u v (matrix u v)

def problem (c : ℕ) : WordTime.Problem where
  Input := Graph
  size := Graph.vertices
  encode := encode
  valid := fun G => BoundedWeights c G ∧ NoNegativeCycle G
  correct := Correct

end Lax489179.WeightedAPSP
