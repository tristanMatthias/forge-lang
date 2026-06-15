# L0 Tracer Bullet — Go / No-Go

**Ticket:** `ps3t.1.1` (epic `ps3t` — "AST as the single source of truth — derive
every operation, kill drift"). This is the L0 GATE: prove the L1→L6 architecture
integrates end-to-end **and** that the perf story holds **before** we farm out the
layer epics.

**Artifact:** `bootstrap/scratch/tracer_bullet.av` — throwaway scaffolding, NOT
wired into the real pipeline. It is a self-asserting program (exits non-zero on
regression). Re-run the gate any time with:

```
cd bootstrap && bash scripts/diagnose.sh --run scratch/tracer_bullet.av
```

**Verdict: GO.** The layers compose cleanly, the slice produces correct output,
the incremental rerun is consistently >10× cheaper than a cold codegen (the
order-of-magnitude win the architecture is predicated on), and every behavior it
exercises matches a decision in the spine doc — see "Validation" below.

---

## What the slice does

It compiles ONE tiny construct — an integer arithmetic expression
(`1 + 2 * 3 - 4`) — straight through a vertical slice of every proposed layer:

| Layer | What the tracer exercises |
|-------|---------------------------|
| **L1** Node model | Data-oriented **per-type arena** (structure-of-arrays columns indexed by a typed `ExprId`) + a **byte-offset span side-table** (`span_lo`/`span_hi` keyed by the same id — spans live beside node data, not smeared on an `SExpr` wrapper). |
| **L3** Typed identity | `ExprId` row indices; **content fingerprints** (a local-content hash for the input layer, a structural/Merkle hash for the codegen key) — the hash-consing / content-addressing preview. |
| **L4** Grammar-DSL | A tiny **grammar-DSL-style recursive-descent parser**, one method per production (`expr → term → factor`), tracking byte offsets. |
| **L6** Compiler-as-query | A minimal **red-green (Salsa-style) memo store** for ONE query (`type_of node N`) with revision tracking + **early cutoff**, plus a **codegen cache keyed by the body fingerprint**. |

It then runs four scenarios against ONE persistent incremental DB and asserts the
behavior via instrumentation counters (the counters are the proof of reuse):

1. **Cold build** — `type_of` runs once per node (7); codegen emits once; `eval`
   confirms the answer is `3`; valid LLVM IR is produced (with SSA temps and
   correct `*`-before-`+/-` precedence).
2. **No-op edit** (re-parse identical source) — the input layer detects every
   node's fingerprint is unchanged, so **the query body never re-runs** (early
   cutoff) and **codegen is served from cache** (a hit, zero re-emit).
3. **Value edit** (`3 → 5`) — exactly the one edited leaf's input changes; its
   type is still `Int` so its value-`changed_at` does not move and **ancestor
   type queries early-cut-off** (only +1 query exec total), while the structural
   fingerprint of the root changes so **codegen correctly invalidates and
   re-emits**. `eval` confirms the new answer is `7`.
4. **Differential oracle** (spine doc §10.B: *"incremental result MUST equal
   from-scratch result — the engine's correctness oracle"*) — the incrementally
   maintained DB (carried across all three revisions) and a fresh from-scratch
   DB on the edited source produce **identical** `type_of(root)` **and identical
   emitted IR**.

All 12 assertions pass.

## Perf baseline

Average over 60,000 iterations, `CLOCK_MONOTONIC` ms. The shared build container
is noisy, so absolute ns/iter drifts run-to-run; the **ratio** is the stable
signal:

| Phase | ns / iter (observed range) |
|-------|-----------|
| parse | ~2,200–4,600 |
| typeck (cold: fresh DB + ingest + query) | ~1,700–7,100 |
| codegen (cold: emit IR, no cache) | ~11,000–34,000 |
| **incremental rerun (query + codegen reused)** | **~880 (stable)** |

**Reading:** the incremental rerun stays ~0.9µs while cold codegen ranges
11–34µs, so the incremental path is consistently **>10× cheaper** (13–38×
observed) and cheaper than even a cold parse or typeck. The incremental number is
near the measurement floor — its bookkeeping does not eat the win. (Cold codegen
dominates because it builds the IR string; the cache skips exactly that work on
the hot path.)

## Validation against the spine doc (`2026_06_14_AST_SOURCE_OF_TRUTH_EPIC.md`)

Checked the slice against the now-merged spine doc, decision by decision. The
architecture it validates is the one the doc decided — no contradictions:

| Doc decision | Tracer | Match |
|---|---|---|
| **§10.E** per-type arenas with typed IDs (`ExprId` = index); array-of-nodes now, SoA later | per-type `Expr` arena, `ExprId` row index; went straight to SoA columns | ✓ (ahead — validates the SoA end-state) |
| **§4 L1 / Dec.1** byte-offset spans in side-tables keyed by node-id | `span_lo`/`span_hi` byte-offset side-table columns | ✓ |
| **§4 L3** content hash = *structure only* (variant + literal payloads + child-hashes), **excludes spans** | `struct_fp` = Merkle hash of op + literals + child fps; spans never hashed | ✓ |
| **§4 L6** red-green early cutoff: stamp *last-changed* vs *last-verified*; recompute only on input-change-since-verified, bump only verified on matching recompute | exactly this (`changed_at`/`verified_at` per query + per input) | ✓ |
| **§4 L6 "Codegen: cached, not derived"** per-function cache keyed by the **body fingerprint** | codegen cache keyed by the root's structural (body) fingerprint | ✓ (same term) |
| **§10.B** "incremental result MUST equal from-scratch result" | scenario 4 asserts it for type + IR | ✓ |
| **§4 L4 / GRAMMAR_DSL.md** RD parser, one fn per production, precedence by stratification, left-fold | hand-written RD in that exact shape (`expr→term→factor`) | ✓ (the doc's §4 *lowered* form) |
| **§10.A** internal refactors are *not* seed-gated; build in current Avra | scratch program, current Avra, no seed touch | ✓ |

**Deliberate divergences (all are the tracer scoping down, not disagreeing):**

- **Granularity.** The bead scoped the query to *"type of node N"*, so the tracer
  memoizes **per-node**. The doc's decided production grain (§4 L6 "Granularity")
  is **per-item** (typeck/codegen) / **per-file** (parse) and explicitly *"never
  per-node (bookkeeping exceeds savings)"*. The *mechanism* is identical at any
  grain; only the key changes. Not a conflict — but the production engine keys on
  items, not nodes.
- **Hash-consing / immutability.** Dec.1 commits to an **immutable + hash-consed**
  node model; the tracer's arena is build-time-mutable and re-parsed fresh each
  edit (no interning). This is exactly why the tracer needs shape-stable dense ids
  (finding #2 below) — hash-consing (§4 L1 "going further") is the doc's answer to
  that, and the tracer does not yet exercise it.
- **Two fingerprints.** The tracer splits *node-local* vs *structural* fp; the
  doc's §4 L6 split is **signature fp** (body-independent, drives type-check
  cutoff) vs **body fp** (drives codegen cutoff) at *item* grain — a different
  axis the toy can't express (it has no functions-with-signatures).
- **Single-tier hash, no collision handling.** §4 L3 wants two tiers (crypto-grade
  persistent; fast in-process **with content-compare on collision**). The tracer
  uses one fast djb2-style hash and assumes no collisions.

## Integration findings

- **The layers compose with no impedance mismatch.** Arena ids flow as memo keys
  and as the input-layer key space; the structural fingerprint flows as the
  codegen key; the parser populates the span side-table for free. Nothing fought
  anything else.
- **Two fingerprints, two jobs — and it matters.** The input layer must key on a
  node's *local* content (op + child **ids**), while the codegen cache keys on the
  *structural/Merkle* hash. This split is what gives the clean behavior in
  scenario 3: type-level early cutoff *and* correct codegen invalidation from a
  single leaf edit. L3/L6 must keep these distinct.
- **Early cutoff needs the revision tetrad.** `(value, verified_at, changed_at)`
  per query + `changed_at` per input is the minimum that makes both "nothing
  changed" and "input changed but value didn't" cut off correctly. L6 should
  build on exactly this shape.
- **The language expressed it comfortably.** Structure-of-arrays arenas, by-pointer
  struct mutation (the parser cursor, the DB), and recursion over ids were all
  natural. No missing primitive forced a workaround.

## What the tracer deliberately did NOT exercise (de-risk these in the epics)

1. **Dynamic dependency collection.** The tracer *derives* `type_of`'s deps from
   node structure (a Binary depends on its two children) instead of *recording*
   what each query actually read. Production L6 (`ps3t.8`) needs the recorded-deps
   engine — the general "what did this query touch" graph the doc's spreadsheet
   model (§4 L6) assumes. This is the single biggest remaining integration risk
   and should be the first thing L6 proves.
2. **Hash-consing / id-stability under shape-changing edits.** Both edits preserve
   the tree shape, so re-parsed dense ids stay aligned and memo-by-id "just
   works". Real edits change shape. The doc already names the fix: **hash-consing**
   (§4 L1 "going further" + Dec.1 "immutable + hash-consed") gives unchanged
   subtrees a stable content-addressed id automatically. L1 (`ps3t.3`) must land
   that, and L6 must key on those content-addressed ids — not a dense index.
3. **Per-item granularity at scale.** `type_of` is Int-valued, per-node, over a
   three-production grammar. The doc's decided grain is per-item/per-file (§4 L6),
   with the **signature-vs-body fingerprint** split driving caller-vs-self cutoff.
   Scale (many node types, real types, multiple interdependent queries, item-level
   keys) is what L4 (`ps3t.6`) and L1 (`ps3t.3`) carry — the *shape* validated
   here is the one they extend.
4. **Error-*tolerance*.** The parser now *hard-rejects* malformed input (a factor
   requires ≥1 digit; the whole input must be consumed — scenario 5), so it no
   longer silently fabricates `IntLit(0)` or ignores trailing garbage. But that is
   fail-fast validation, **not** the error-*tolerance* the doc makes a Layer-1
   *requirement* (§4 L1: explicit error/missing nodes; the parser never bails —
   yields a partial tree + *all* errors at once, needed for the daemon/LLM story),
   with the recovery points folded into the grammar DSL (`@expect`/`@recover`).
   Partial-tree recovery is unexercised here; L1/L4 must build it in from the start.

## Recommendation

**GO** — proceed to farm the layer epics per the doc's wave order (§12): metrics
(`ps3t.10`) + the differential-test harness (`ps3t.2`), then L1 ∥ L3, then the
fan-out. Sequence so that L6's dynamic dependency-tracking engine (finding #1) and
L1's hash-consing / content-addressed ids (finding #2) are proven early, since
everything else rides on them. The success metrics in `ps3t.10` (incremental
rebuild latency, byte-identical selfhost) are consistent with what this slice
measured. Nothing in the slice contradicts a decision in the spine doc.
