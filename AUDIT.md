# Validation

The Lean 4.33.0 port was checked on 2026-09-15 using the archive's
current environment.

`lax build . --replay` compiles both packages, rechecks the proof terms
in the kernel and inspects the archive annotations. The submission has
18 concepts, including 23 supporting statements, and 23 recorded proofs.

`node scripts/audit-proof-closure.mjs .` reports:

```text
lax-489179: 23/23 statements closed
```

Every recorded proof has an empty set of archive-statement assumptions.
The only external concept dependency is lax-808846 at commit
`9394e531cc51cb67a0214bca3f9264dfe97ba5c7`; it has no statement obligations.
The four hypotheses and their randomized variants are proposition
definitions. They are never installed as axioms, and the supporting
proofs establish no unrequested complexity lower bound.

During the original 2026-09-09 validation, the proof network was inspected
in the local Lax preview. All 23
statement indicators are proved and all 23 proofs are grounded. The
renderer groups the statements into five concept nodes; the network
contains 28 nodes and 23 conclusion edges. All 42 submission, concept
and proof pages were checked at desktop and mobile widths. Mathematical
rendering and internal links passed; there was no page overflow. Graph
tooltips, horizontal scrolling, expansion and closing with Escape worked.
The archive's external comments service produces CSP/CORS warnings on
localhost; these were recorded separately from submission rendering.

Lax-808846 is registered in the archive. Its immutable source is pinned,
and its definitions introduce no proof obligations.

The closure checker accepts both concept-package and proof-package
dependencies and resolves them to their common submission record. This
corrects a rejection of `Lax307052Proofs` in the workspace checker;
the correction is also included in this submission's copy. Regression
checks cover a closed dependency, an unproved premise reached through
a proof package, and a dependency cycle.

The workspace-mandated audit of the three older submissions also ran:

```text
lax-307052: 12/12 statements closed
lax-733996: 7/10 statements closed
lax-429075: 6/11 statements closed
```

Its remaining blockers are `Lax733996.CountMachine.implement`,
`Lax429075.CircuitMachine.compile` and
`Lax429075.VerifierTime.polynomial`. None is a dependency of this
submission. These existing failures remain outside the scope of the
four-hypothesis formalization.
