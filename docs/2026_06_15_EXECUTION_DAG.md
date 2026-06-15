# Execution DAG — `ps3t` (AST as the single source of truth)

**Status:** execution plan (2026-06-15). Spine doc: `2026_06_14_AST_SOURCE_OF_TRUTH_EPIC.md`.
Purpose: refactor the beads DAG so `bd ready` shows *exactly* the right work, in
dependency order, with parallel tracks marked. 241 non-closed issues triaged
below: **spine** (re-parented into the layers) vs **out** (stays put).

---

## 1. Target tree (under `ps3t`)

```
ps3t  AST as the single source of truth
├── L0   Tracer bullet — thin end-to-end slice (grammar→arena→query→cached codegen)   [GATE]
├── HRN  Differential-test harness (old compiler = oracle)                            [GATE]
├── L1   Node model — data-oriented arenas, typed ids, hash-cons, spans, error-tol
│        └─ 703y.1 (uniform spans, IN FLIGHT) + new: arenas/typed-ids/hash-cons/SoA
├── L3   Typed identity — interned + content-addressed
│        └─ wc5w, e5qo, (so07.7 done)
├── L2   Compiled comptime / JIT — delete interpreter + Value
│        └─ so07 / so07.8, g18a, + new: ORC JIT, sandbox, Value-audit
├── L4   Derive framework + grammar-DSL parser
│        └─ y9y4, s80z(+epkx/sl6c/cyxs/jw6v/x7be), 93k3(SUPERSEDED), + new: framework, grammar-DSL
├── L5   No-drift — exhaustiveness
│        └─ vndt (+ vndt.1, vndt.2)
├── L6   Compiler-as-query — engine, name-res, daemon/LSP, codegen cache
│        └─ 4apk, qvfb, ggkh, re1b, pdme(.1/.2), jg5z(.1/.2/.3/.4/.6), + new: query engine, name-res
├── LLM  Diagnostics schema, --fix, AST-as-data
│        └─ jg5z.7, + new: diagnostic schema, --fix, AST-as-data
└── 1n1v MIR (deferred)
```

Each layer epic's **first child is a design-doc ticket** (Definition-of-Ready gate).

## 2. The dependency DAG (drives `bd ready`)

```
L0 ──▶ HRN ──▶ ┌ L1 ┐
               └ L3 ┘ ──▶ L2 ──▶ L4 ──▶ L5
                    L1 ──────────▶ L6
                    L3, L4 ──────▶ LLM
                    L4, L6 ──────▶ 1n1v
```

- **Gates (serial):** `L0 → HRN → {everything}`.
- **Parallel after HRN:** **L1 ∥ L3**. Then after L1: **L6-engine**; after L1+L3:
  **L2 ∥ L4**. L5 / LLM / MIR trail.
- `bd ready` therefore surfaces: **L0 only** → then **HRN** → then **L1 + L3** →
  fan-out. Nothing downstream shows until its blocker closes.

## 3. New tickets to create (from §10 subsystem decisions + de-risking)

| Under | Ticket | Why |
|---|---|---|
| L0 | Tracer-bullet slice + success-metric baseline | validate integration before farming |
| HRN | Differential-test harness (old vs new, byte-IR compare) | the go-hard safety net |
| L1 | Arena + typed-id node store; hash-consing; SoA-later; design doc | the data-oriented core |
| L2 | ORC JIT; comptime sandbox (pure + `@embed`); static-purity check; design doc | the JIT |
| L3 | Extend interning to runtime ids; hashing scheme (§4) impl; design doc | identity |
| L4 | Derive framework engine; grammar-DSL + seed parser; `@query`/`@derive`; design doc | the toolkit |
| L6 | Query engine (red-green core); name-resolution-as-query; interface fingerprints; design doc | incremental |
| LLM | Diagnostic schema + `--fix` + AST-as-data format | LLM-native |
| ps3t | Success-metrics block (incremental latency, cold-build budget, selfhost identical) | acceptance gates |

## 4. Out of spine (stay under their own epics — NOT pulled in)

These are real, separate concerns; pulling them in would pollute `bd ready` for
this program. Counts approximate.

- **Nullability / Option** (`xm2g.*` + null bugs): ~18 → stays `xm2g`.
- **RC memory** (`rcsf.*`): ~5 → stays `rcsf`. *(Note: `rcsf.4` "phase arenas for
  the AST" is an **input** to L1 — cross-link, don't move.)*
- **Test-runner / build-cache tooling** (`uzs9.*`, `pdme.*`, `i7gw`, `05yc`,
  `ylye`, `cx22`, `g6i7`, `x2hu`, …): ~30 → stays `uzs9`/`4apk`. *(The
  content-addressed cache bits inform L6; cross-link the relevant 2–3.)*
- **Components V2** (`vez6.*`): ~16 → stays `vez6`. *Feeds* L4 (the macro/
  declarative layer) but is its own in-flight CLI/component rewrite.
- **Language features** (`6wt3, eo0p, p1o5, ryvy, c080, 6d57, dkln, yg34, ei38,
  25x4, qvui, de06, 3uy9`): ~14 → stay individual.
- **General bugs** (codegen/typeck/parser/lexer — `2px2, pmo3, pxqy, cpvo, pyly,
  ntcb, ogx0, mfmq, u4my, xr3x, …`): ~40 → stay individual.
- **CLI extract** (`y4n1.*`): ~4 → stays `y4n1`. *(`y4n1.8` module-graph name-res
  is an **input** to L6-name-resolution; cross-link.)*
- **isolated / channels** (`nce6.*`, `8gbf`): ~5 → stays `nce6`.
- **bd / infra** (`8nza` sync-noop [hit this session], `87al` ready-gating,
  `jd7y`, `fog4`): ~4 → stay individual. *(`8nza` is the auto-sync bug we tripped
  over — already filed.)*

## 5. Refactor operations (what I execute against beads)

1. Create the 8 missing track-epics (L0, HRN, L1, L2, L3, L4, L6, LLM) under `ps3t`;
   `1n1v` already exists.
2. Re-parent spine epics into their layer: `703y.1→L1`, `wc5w/e5qo→L3`,
   `so07→L2`, `y9y4/s80z→L4`, `vndt→L5`, `4apk/qvfb/ggkh/re1b/pdme/jg5z→L6`.
   (Children follow their parent automatically.)
3. Wire the §2 dep edges (layer → layer) so `bd ready` is accurate.
4. Create the §3 new tickets (incl. a design-doc ticket per layer = Def-of-Ready).
5. Mark `93k3` superseded by L4; cross-link the §4 "inputs" (`rcsf.4`, `y4n1.8`,
   cache bits) without moving them.
6. The old super-umbrellas (`703y`, `cxvp`) thin out as children move; leave them
   as thematic labels (they retain non-spine children).

## 6. "How" beyond the DAG
- **Def-of-Ready** = a layer's design-doc ticket is closed (an agent can't start
  a layer without its spec).
- **Seed-gating tag** on tickets that dogfood new surface in compiler `src/`
  (§10.A) — the only truly-serialized work; most isn't gated.
- **Ticket sizing** = agent-sized (≈1 PR), explicit acceptance criteria.
- **Success metrics** attached as acceptance on L1/L2/L6.
- **Owner/assignee left open** for farming; the DAG decides what's pickable.
