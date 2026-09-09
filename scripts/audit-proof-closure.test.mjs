import assert from 'node:assert/strict';
import test from 'node:test';
import { auditClosure } from './audit-proof-closure.mjs';

const build = (id, statements, proofs, concepts = [], proofPackages = []) => ({
  id,
  requiredByConcepts: concepts,
  requiredByProofs: proofPackages,
  concepts: [{ type: 'lemma', statements: statements.map(id => ({ id })) }],
  proofs,
});
const proof = (conclusion, assumptions = []) => ({
  id: `proof-of-${conclusion}`, conclusion, assumptions,
});

test('concept and proof requirements share a dependency record', () => {
  const root = build('lax-1', ['A'], [proof('A', ['B'])], ['Lax2'], ['Lax2Proofs']);
  let reads = 0;
  const report = auditClosure(root, id => {
    assert.equal(id, 'lax-2');
    reads++;
    return build('lax-2', ['B'], [proof('B')]);
  });
  assert.equal(reads, 1);
  assert.equal(report.closed, 1);
  assert.deepEqual(report.open, []);
});

test('a proof-package dependency cannot hide an unproved premise', () => {
  const root = build('lax-1', ['A'], [proof('A', ['B'])], [], ['Lax2Proofs']);
  const report = auditClosure(root, id => {
    assert.equal(id, 'lax-2');
    return build('lax-2', ['B'], []);
  });
  assert.equal(report.closed, 0);
  assert.deepEqual(report.open[0].blockers, ['B']);
});

test('cyclic proofs remain open across proof-package dependencies', () => {
  const root = build('lax-1', ['A'], [proof('A', ['B'])], [], ['Lax2Proofs']);
  const report = auditClosure(root, () =>
    build('lax-2', ['B'], [proof('B', ['A'])], [], ['Lax1Proofs']));
  assert.equal(report.closed, 0);
  assert.deepEqual(report.open[0].blockers, ['cycle at A']);
});
