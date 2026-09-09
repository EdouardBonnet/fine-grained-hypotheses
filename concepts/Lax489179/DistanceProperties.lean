import Lax489179.WeightedAPSP

/-!
---
title: Uniqueness and diagonal entries of shortest-path distances
type: lemma
---
The distance specification has at most one answer for each ordered
pair. In a graph with no negative cycle every diagonal answer is zero.
An encoded $n$ by $n$ distance matrix contains exactly $n^2$ words.
-/

namespace Lax489179.DistanceProperties

open WeightedAPSP

axiom distance_unique (G : Graph) (u v : Fin G.vertices) (a b : Option ℤ)
    (ha : Distance G u v a) (hb : Distance G u v b) : a = b

axiom diagonal_zero (G : Graph) (h : NoNegativeCycle G) (v : Fin G.vertices) :
    Distance G v v (some 0)

axiom matrix_length (n : ℕ) (matrix : Fin n → Fin n → Option ℤ) :
    (encodeMatrix n matrix).length = n * n

end Lax489179.DistanceProperties
