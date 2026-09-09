import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { pathToFileURL } from 'node:url';

// Run after `lax build --replay`. The replay checks Lean proof terms; this
// checks that their recorded statement dependencies are transitively proved.
export function auditClosure(root, readDependency) {
  const submissions = new Map([[root.id, root]]);
  const pending = [root];
  for (let i = 0; i < pending.length; ++i) {
    const build = pending[i];
    for (const module of new Set([
      ...build.requiredByConcepts, ...build.requiredByProofs,
    ])) {
      const packageId = /^Lax([0-9]+)(?:Proofs)?$/.exec(module);
      if (!packageId) throw new Error(`Invalid dependency: ${module}`);
      const id = `lax-${packageId[1]}`;
      if (submissions.has(id)) continue;
      const dependency = readDependency(id);
      if (dependency.id !== id) throw new Error(`Wrong dependency file for ${id}`);
      submissions.set(id, dependency);
      pending.push(dependency);
    }
  }

  const statements = new Map();
  const proofs = [];
  for (const build of submissions.values()) {
    for (const concept of build.concepts) {
      for (const statement of concept.statements) {
        if (statements.has(statement.id)) throw new Error(`Duplicate statement: ${statement.id}`);
        statements.set(statement.id, {
          submission: build.id, type: concept.type, proofs: [],
        });
      }
    }
    proofs.push(...build.proofs);
  }
  for (const proof of proofs) {
    if (!Array.isArray(proof.assumptions)) throw new Error(`Missing assumptions: ${proof.id}`);
    for (const id of [proof.conclusion, ...proof.assumptions]) {
      if (!statements.has(id)) throw new Error(`Unknown statement ${id} in ${proof.id}`);
    }
    statements.get(proof.conclusion).proofs.push(proof);
  }

  // The least fixed point admits alternative proofs, but never circular ones.
  const closed = new Set();
  let changed;
  do {
    changed = false;
    for (const proof of proofs) {
      if (!closed.has(proof.conclusion) && proof.assumptions.every(id => closed.has(id))) {
        closed.add(proof.conclusion);
        changed = true;
      }
    }
  } while (changed);

  function blockers(id, seen = new Set()) {
    if (closed.has(id)) return [];
    if (seen.has(id)) return [`cycle at ${id}`];
    const alternatives = statements.get(id).proofs;
    if (alternatives.length === 0) return [id];
    const next = new Set(seen).add(id);
    return [...new Set(alternatives.flatMap(proof =>
      proof.assumptions.flatMap(assumption => blockers(assumption, next))))].sort();
  }

  const local = [...statements].filter(([, s]) => s.submission === root.id);
  const open = local.filter(([id]) => !closed.has(id)).map(([id, s]) => ({
    id, type: s.type, blockers: blockers(id),
  }));
  return { id: root.id, closed: local.length - open.length, total: local.length, open };
}

function main(args) {
  let database = path.join(os.homedir(), '.lax', 'lax-database');
  const roots = [];
  let json = false;
  for (let i = 0; i < args.length; ++i) {
    if (args[i] === '--database') {
      database = args[++i];
      if (!database) throw new Error('--database requires a directory');
    } else if (args[i] === '--json') {
      json = true;
    } else if (args[i].startsWith('--')) {
      throw new Error(`Unknown option: ${args[i]}`);
    } else {
      roots.push(args[i]);
    }
  }
  if (roots.length === 0) {
    throw new Error('Usage: node scripts/audit-proof-closure.mjs [--json] submission-directory ...');
  }
  const read = file => JSON.parse(fs.readFileSync(file, 'utf8'));
  const reports = roots.map(root => auditClosure(
    read(path.join(root, 'build-output.json')),
    id => read(path.join(database, id, 'build-output.json')),
  ));
  if (json) {
    console.log(JSON.stringify(reports, null, 2));
  } else {
    for (const report of reports) {
      console.log(`${report.id}: ${report.closed}/${report.total} statements closed`);
      for (const statement of report.open) {
        console.log(`  OPEN ${statement.id}`);
        console.log(`    depends on: ${statement.blockers.join(', ')}`);
      }
    }
  }
  process.exitCode = reports.some(report => report.open.length > 0) ? 1 : 0;
}

if (process.argv[1] && import.meta.url === pathToFileURL(path.resolve(process.argv[1])).href) {
  try {
    main(process.argv.slice(2));
  } catch (error) {
    console.error(error.message);
    process.exitCode = 2;
  }
}
