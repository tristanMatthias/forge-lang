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
and the incremental rerun is ~13× cheaper than a cold codegen — the order-of-
magnitude win the architecture is predicated on.

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

It then runs three revisions against ONE persistent incremental DB and asserts the
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

All 8 assertions pass.

## Perf baseline

Average over 60,000 iterations, `CLOCK_MONOTONIC` ms, on the build container
(numbers stable across runs):

| Phase | ns / iter |
|-------|-----------|
| parse | ~2,200 |
| typeck (cold: fresh DB + ingest + query) | ~1,700–2,400 |
| codegen (cold: emit IR, no cache) | ~11,000–12,000 |
| **incremental rerun (query + codegen reused)** | **~880** |

**Reading:** the incremental rerun is ~13× cheaper than a cold codegen and
cheaper than even a cold parse or typeck. The expected incremental win is real
and large; the memo/cache machinery is not eaten by its own bookkeeping.
(Cold codegen dominates because it builds the IR string; the cache skips exactly
that work on the hot path.)

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
   what each query actually read. Production L6 needs the recorded-deps engine
   (the general "what did this query touch" tracking). This is the single biggest
   remaining integration risk and should be the first thing L6 (`ps3t.8`) proves.
2. **Shape-changing edits.** Both edits here preserve the tree shape, so arena
   ids stay aligned across revisions and memo-by-id "just works". Real edits
   change shape; L1/L6 need an id-stability story (stable/interned ids, or
   re-keying memo entries on node identity rather than dense index).
3. **One trivial query over one construct.** `type_of` is Int-valued and the
   grammar is three productions. Scale (many node types, real types, multiple
   interdependent queries) is what L4's derive framework (`ps3t.6`) and the full
   node model (`ps3t.3`) must carry — but the *shape* validated here is the one
   they extend.

## Recommendation

**GO** — proceed to farm the layer epics (`ps3t.3`–`ps3t.9`). Sequence so that
L6's dynamic dependency-tracking engine (finding #1) and L1's id-stability story
(finding #2) are proven early, since everything else rides on them. The success
metrics in `ps3t.10` (incremental rebuild latency, byte-identical selfhost) are
consistent with what this slice measured.
