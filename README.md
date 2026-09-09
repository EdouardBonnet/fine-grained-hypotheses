# ETH, SETH, Weighted APSP, and 3SUM

Lax submission `lax-489179`, prepared with Lean 4.30.0 and the archive's
pinned mathlib. The four hypotheses are defined as propositions that can
be used as explicit assumptions in conditional theorems.

| Hypothesis | Deterministic proposition | Convention |
| --- | --- | --- |
| ETH | `Lax489179.ETH.Deterministic` | Some positive exponential rate is impossible for 3-SAT. |
| SETH | `Lax489179.SETH.Deterministic` | Every improvement below base two fails at some fixed clause width. |
| Weighted APSP | `Lax489179.APSPHypothesis.Deterministic` | For some fixed positive weight exponent, every truly subcubic bound fails. |
| 3-SUM | `Lax489179.ThreeSUMHypothesis.Deterministic` | Every truly subquadratic bound fails for distinct integers in `[-n³,n³]`. |

Replace `Deterministic` with `Randomized` for the bounded-error versions.
Each namespace also provides `Hypothesis mode` for uniform statements.

SAT uses a finite multitape Turing machine, counting elementary
transitions. Its bound is `C * (L + 1)^d * 2^(a*n)`, where `n` counts
variables and `L` is the full encoded formula length. Clause widths,
algorithms, constants and real exponents have explicit quantifiers.

APSP and 3-SUM use finite word-RAM programs built from the instructions
of [lax-67](https://laxarchive.org/lax-67/), with an additional fair-bit instruction
available in randomized mode. Word length is
`b * (Nat.log2 (n + 2) + 1)` for one fixed positive integer `b`.
The program and `b` are chosen before the input. The full input length
and every encoded input value must fit in a word. Input access, writes,
output and halting are charged by the execution semantics.

APSP takes directed graphs with signed integer edge weights of absolute
value at most `n^c` and no negative cycles. It outputs all distances,
including zero diagonal entries and infinity for unreachable pairs.
The weight exponent `c` precedes the improvement `ε` in the hypothesis.
The 3-SUM input is a duplicate-free array and the three indices must
be distinct. Both are integer hypotheses; real-RAM variants are outside
this submission's scope.

Randomized algorithms have a worst-case time bound on every random
tape and two-sided error at most `1/3` on each input. For APSP the entire
output matrix must be correct with that probability. Expected-time and
zero-error variants are not identified with this convention.

The supporting lemmas cover reversible integer encodings, distinct
3-SUM entries, distance uniqueness and diagonal values, matrix output
length, monotone time bounds, quantifier negations, and the implication
from each randomized hypothesis to its deterministic version. They also
prove that the probability-based semantics reduces to exact correctness
for deterministic programs. No machine implementation axiom is used.
No implication between different hypotheses is claimed.

The concepts depend only on mathlib and the pinned concept package of
lax-67, whose proof network has no statement obligations. The proof
package imports no foreign proofs. The supporting lemmas are the
submission's proof obligations; the hypothesis definitions have none.

From this directory:

```sh
lax build . --replay
node scripts/audit-proof-closure.mjs .
node --test scripts/audit-proof-closure.test.mjs
lax serve . --port 8127
```

Bibliographic sources are in `manifest.yaml`. The supplied concept pages
give the mathematical definitions alongside their Lean source.
