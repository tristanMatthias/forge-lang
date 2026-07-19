# L6 — Compiler-as-Query: detailed design (`ps3t.8.1`)

> Productionizes **Layer 6** of the AST-as-single-source-of-truth spine
> (`docs/2026_06_14_AST_SOURCE_OF_TRUTH_EPIC.md` §4 Layer 6, §10.B/C/D/E/F,
> §13 metrics) into concrete, buildable increments — the same role §14 plays
> for L1 (`ps3t.3.1`) and §15 for L3 (`ps3t.4.1`). Everything here *productionizes
> decisions that are already locked* in the spine; where the spine deferred a
> number (§13 M4), this doc pins it. Decomposition into impl tickets is §12.

## 0. What L6 is, in one paragraph

The compiler stops being an assembly line (parse → resolve → typeck → codegen
over the whole program, every time) and becomes a **spreadsheet**: a graph of
*queries* that each remember their answer. Edit one function → discard only the
answers that transitively depended on it, recompute only those, and stop the
moment a recomputed answer equals its old answer (**early cutoff**). The result
is **O(what-changed)** builds instead of O(program), the same engine serving the
batch compiler, the LSP daemon, and LLM agents. The named prior art is **Salsa**
(the engine under rust-analyzer). L6 is the *payoff* layer: it falls out of L1's
data-oriented immutable substrate (arenas, typed ids, hash-consing, content-hash)
and L3's content-addressed identity — both already built.

This design is **not** a rewrite of those layers; it is the memoization engine
that *wraps* passes already restructured to be pure, plus the fingerprint and
cache machinery that makes per-item reuse correct.

## 1. Non-negotiable invariants (inherited)

These are load-bearing preconditions L6 depends on; all are already true or
enforced in tree, and L6 must not regress them:

- **Immutable AST, append-only arenas** (L1 §14.1/§14.4; guarded by
  `ps3t.3.5`'s arena invariant specs). No pass mutates a node. This is what
  makes memoization sound — a memoized value can never be invalidated by a
  mutation the engine didn't see.
- **Content-addressed identity** (L3 §15.3; `content_id_for`, `type_content_hash`,
  node content-hash). Stable across process/build. This is the *key space* for
  every per-item query and every fingerprint.
- **No mutable globals** (ABSOLUTE RULE 17). The query database is threaded as an
  explicit `QueryCtx`/`Db` value (a struct, exactly like today's `Ctx`), never a
  process static. This is what lets the scheduler run queries on parallel fibers
  without locks.
- **Differential-test oracle** (HRN). The engine's correctness proof is:
  **incremental result == from-scratch result**, byte-identical IR. Every phase
  lands under `make diff-test` + the selfhost fixed point, exactly as today.

## 2. The query model

A **query** is a pure function `Q: Key → (Value, Diagnostics)`. Nothing a query
does is observable except its return value and the queries it reads. Two kinds:

- **Input queries** (graph leaves): `source(file)`, `compiler_flags()`. Set
  explicitly by the driver; assigning a new value bumps the global revision.
  Inputs have no `deps`.
- **Derived queries**: computed by reading other queries — `ast(file)`,
  `item_tree(file)`, `resolve(ref)`, `sig(item)`, `typeck(item)`,
  `mono_instance(key)`, `codegen(item)`. Their `deps` are discovered by
  execution, never declared.

### 2.1 The database

```
Db {
  current_rev: Revision            // monotonic counter; bumped on every input change
  memo: Map<QueryKey, MemoEntry>   // the spreadsheet cells
}

MemoEntry {
  value_hash: Hash          // content-hash of the memoized answer (early-cutoff signal)
  value: <per-query type>   // the answer itself (opaque to the engine)
  deps: List<QueryKey>      // queries read during the last computation of this cell
  changed_at: Revision      // revision at which `value` last actually CHANGED (red)
  verified_at: Revision     // revision at which `value` was last CONFIRMED current (green)
  diagnostics: DiagList     // (value + diagnostics) memoize and invalidate together
}
```

Invariant maintained at all times: `changed_at ≤ verified_at ≤ current_rev`.

`QueryKey` = `(QueryTag, content-addressed argument key)`. The argument key is an
L3 content id for per-item queries (`ItemId`, `TypeId`), a file id for per-file
queries. **Never per-node** — bookkeeping would exceed savings (§4 decided).

## 3. The red-green algorithm (the heart)

`fetch(q)`:

1. **No entry** → *compute*: run `q`'s pure fn under a fresh dep-tracking frame;
   store `value`, `value_hash`, `deps`, `changed_at = verified_at = current_rev`.
   Return.
2. **`entry.verified_at == current_rev`** → return cached. (Already proven current
   this revision — the hot path; most queries hit here after the first fetch of a
   revision.)
3. **Otherwise run `maybe_changed(q)`:**
   a. For each `d` in `entry.deps`: recursively `fetch`/verify `d`, then test
      `memo[d].changed_at > entry.verified_at`.
   b. **No dep newer than `verified_at`** → `q` is still valid *without recompute*
      (**green**): set `entry.verified_at = current_rev`, return cached. This is
      the deep win — a whole subtree can be re-validated by comparing revisions,
      touching no query bodies.
   c. **Some dep changed** → **recompute** `q` under a fresh dep frame, then
      compare the new answer's hash to `entry.value_hash`:
      - **Different** (**red**): `value`/`value_hash` ← new; `changed_at = current_rev`.
      - **Same** (**early cutoff**): keep `value`; **do not** bump `changed_at`.
        The change-wave dies here — every dependent's step 3a test
        (`changed_at > their verified_at`) is false, so they never recompute.
      In both sub-cases `deps` ← newly-tracked deps and `verified_at = current_rev`.

The correctness statement: *`q` recomputes iff some transitive input changed since
`q` was last verified; a dependent skips iff `q`'s `changed_at` did not advance.*
That is precisely Salsa's red-green / durability rule, and the differential-test
oracle (incremental == scratch) is what proves our implementation of it.

### 3.1 Dependency tracking

Computing a query pushes a **dep frame**; every `db.fetch(x)` issued from inside
records `x` into the active frame. On completion the frame's set becomes the new
`deps`. The active frame is carried on the `QueryCtx` (a parameter/fiber-local),
**not** a mutable global — so parallel query execution needs no lock and no
save/restore hazard (rule 17).

### 3.2 Cycles

A query that transitively requests itself is an **error by default** — a new
diagnostic `F3900 query cycle` (with the cycle path in secondary spans).
Genuinely recursive queries (fixpoint inference, mutual type recursion) **opt in**
to fixpoint iteration: they declare a bottom value and a convergence predicate,
and the engine iterates the strongly-connected component to a fixed point instead
of erroring (§10.B decided). Opt-in keeps the common case honest (accidental
cycles surface loudly) while supporting the few queries that need it.

## 4. Query-shaped passes — the seam

L6 memoizes passes that are already **pure** (the immutable-pass model, §4):

- **Analysis** passes (resolve, typeck) never write on a node; they record facts
  in **side-tables keyed by node-id**. As queries they return those facts.
- **Transform** passes (desugar, mono, rewrites) **produce a new immutable tree**,
  sharing unchanged subtrees via hash-consing, each new node carrying
  **provenance** back to source. As queries they return the new subtree's id.

**Migration is staged and differential-tested** (§10.A: staged, never broken):

- **Step A — coarse wrap.** Wrap each existing pass as a *single whole-program
  query* (`typeck_all(program)`, `resolve_all(program)`). No incrementality yet;
  purely a refactor that proves the pass is side-effect-free. Oracle: byte-identical.
- **Step B — split.** Break each coarse query into **per-item** queries as the
  pass is proven to read only what it declares. This is where incrementality
  actually appears. Each split is its own diff-tested increment.

The compat shim (L1 §14.6) is available as risk-management but is **optional** —
L6 is an internal refactor, not seed-gated (§10.A / §10 Tier-3).

## 5. Granularity (decided: per-item, content-addressed)

| Query | Key | Cost class |
|---|---|---|
| `source(file)` | file id | input |
| `ast(file)` | file id | per-file (cheap parse) |
| `item_tree(file)` | file id | per-file (item signatures only) |
| `sym(path)` / `resolve(ref)` | content id of path / ref site | per-symbol / per-ref |
| `sig(item)` | `ItemId` (content id) | per-item |
| `typeck(item)` | `ItemId` | per-item |
| `mono_instance(body_fp, arg_fps)` | content-addressed tuple | per-instance |
| `codegen(item)` | `ItemId` (keyed by `body_fp`) | per-item |

Expensive queries (typeck, codegen) are per-item so an item keeps its cache
across edits to *other* items; cheap parsing stays per-file; nothing is per-node.
Fine granularity is *unlocked by* L1+L3's stable identities.

## 6. Name resolution as a query + symbol model

- **Symbol identity is its definition site, not its name** (§10.C). Two `foo`s in
  different scopes are different symbols. Concretely: **`sym_id = content-hash(
  qualified-path + kind)`** — reuses L3 `content_id_for`, so it is stable across
  processes/builds and needs no counter.
- **`resolve(ref)`** is a query keyed by `(scope chain, visible imports)` at the
  reference site. It returns a `sym_id` (or an unresolved diagnostic).
- **A module's exported surface = the set of its public items' *signature*
  fingerprints** (§7). Therefore editing a module's **private** internals leaves
  its exported surface unchanged → importers' `resolve`/`sig` queries early-cutoff
  → importers are **not** invalidated. Visibility is folded into the fingerprint,
  so a `pub`→private change *does* invalidate (correctly).

This dissolves the old mutating-annotation resolver: resolution facts live in
memoized query results, not in nodes.

## 7. Interface fingerprints — the incremental linchpin

Each item carries **two** content-hashes (§4 decided):

- **Signature fingerprint** `sig_fp(item)` = hash of (name, parameter types,
  return type *including the declared error union*, generic bounds, visibility,
  effects). **Body-independent.** Drives **type-check early-cutoff**: a body edit
  cannot change `sig_fp`, so every caller's `typeck` is reused.
- **Body fingerprint** `body_fp(item)` = structure-only, span-excluded hash of the
  item's body AST. Drives **codegen + comptime early-cutoff** (inlining and
  compile-time evaluation depend on the body, so they key on it).

**Computation reuses the L1/L3 content-hash family** already in tree — node
content-hash (`ps3t.3.5` Inc 1: `E:`/`S:`/`P:` per-arena, span-excluded) for
bodies, `type_content_hash` (`ps3t.4.3` Inc 1) for the types inside signatures.
No new hashing primitive is invented; L6 *composes* them into the two item-level
fingerprints.

**This is the consumer that unblocks the parked L3 identity work.** The fingerprint
is the on-disk cache key, so:

- **`ps3t.4.3`** (two-tier hashing) lands its *persistent crypto-grade tier +
  version-tag + cache namespacing* **here** — that tier was explicitly gated on
  "an actual on-disk hash-consed-cache consumer", which is exactly `body_fp`/
  `sig_fp` keying the L6 memo cache.
- **`sh48`** (structure-content-addressed / Merkle `TypeId`) is the *first slice*
  of `sig_fp`: a type's id changes iff its structure changes, so signature
  fingerprints invalidate per-affected-type instead of on the coarse
  compiler-binary hash. `sh48` builds **with** this ticket's fingerprint cache,
  per its own recorded sequencing note.

`sig_fp` also requires **explicit signatures at item boundaries** (params + return
types annotated) — Avra already mandates this (spec P9; enforced by the layout
totality / §4.2a work in `ps3t.4.5`/`ps3t.4.9`), so inference stays local to an
item and a body edit can never silently change an item's type.

## 8. Generics, codegen, and the abstract cache unit

- **Mono instances are content-addressed cache units** keyed by
  `(body_fp of the generic, type-arg fingerprints)`. A type change
  re-monomorphizes only the instances that *use* it; identical-IR instances
  **collapse to one artifact** (IR-level hash-consing) — the explosion control.
- **Codegen is cached, not derived** (§4). Lowering stays hand-written
  per-variant; only its *dispatch* is exhaustive-by-construction (L5). What L6
  adds is **per-function content-addressed caching keyed by `body_fp`**:
  - **Now (a):** cache **LLVM bitcode per function** behind an **abstract cache
    unit** interface, so the next backend slots in without re-plumbing.
  - **Deferred (b):** an own mid-level IR (MIR) as a stable, compact,
    content-addressed cache unit — booked as epic `1n1v`, out of L6 scope.

### 8.1 As-built (`ps3t.8.6.1`, delivered 2026-07-19)

**Architecture chosen: Option A — the per-fn CGU (codegen unit).** Each fn
lowers into its **own** LLVM module (unit-local anonymous `@.str.N` numbering →
a self-contained, position-independent artifact), compiles to its **own object
file** (the cache unit), and the objects link into the binary. Option B
(content-addressed `@.str.N` renaming inside one shared module) was rejected —
it's a workaround around LLVM's module-wide global numbering rather than the
CGU-native answer the daemon/parallel-emission path (`re1b`) also wants.

Delivered as five increments, each diff-tested so the **default whole-program
path (`codegen_program` / `build_binary`) stays byte-identical** — the CGU is
the opt-in incremental path, not the default:

1. Cache root threaded from the build driver into codegen; the write side is
   always-on off the project cache root (no `AVRA_FN_CACHE` flag — deleted).
   Gated on a real metadata package build (`ctx.lib_pkg_roots` non-empty) so a
   throwaway standalone compile never leaks a per-fn store.
2. Per-fn module machinery: `build_declared_ctx` (the reusable declare pass —
   externs, named types, globals-as-external, all-fns-declared, `__release_*`,
   top-level wrapper) + `emit_one_fn_body` (defines exactly the target fn) +
   `emit_one_fn_module` (declare-everything, define-one → a standalone `.ll`
   that `llc` compiles). No CLI surface — `build_fn_module` is an internal
   library seam sharing `frontend_to_mono` with `build_binary`.
3. `build_binary_cgu`: N per-fn objects + one **wrapper unit**
   (`emit_wrapper_module` = codegen minus fn bodies; owns the top-level entry,
   the `__init_<mod>` chain, and the single `__release_*` definitions — per-fn
   modules DECLARE the release fns via `define_release=false` and resolve them
   at link). User-`main` is a per-fn unit; its `__bs_top_level` call-injection
   moves into that unit. Run-equivalent across no-main / user-main / RC-typed.
4. **The incrementality.** Each fn's object is cached under the `fncgu`
   namespace keyed on its content fingerprint (`item_sig_fp ⊕ item_body_fp ⊕
   type_table_fp ⊕ mono_erased ⊕ modes ⊕ toolchain`). A hit reuses the stored
   `.o` and skips emission; a one-fn body edit re-lowers **exactly one**
   function.

**Oracle:** run-equivalence (CGU binary == whole-program binary output, 7
shapes: no-main, user-main, RC-typed, generics, enum+match, closures,
zero-user-fns) + a one-fn blast-radius spec (cold→warm publishes zero new objects;
editing one fn publishes exactly one). The default path is diff-test
byte-identical and the selfhost fixed point holds throughout.

**Deliberately out of scope here** (would break the "default stays
byte-identical" acceptance criterion, or is a follow-on optimization):
- Flipping the *default* build to CGU. One-fn-per-CGU maximizes incremental
  granularity but pays N `llc` process spawns on a cold build (~4000 for the
  selfhost) — the production flip wants **bounded-K CGU partitioning** (the
  Rust model), a separate perf-shaped design. The byte-identical whole-program
  path stays the default; CGU is the opt-in incremental path.
- Mono-key decomposition (`fn_unit_key_mono`: generic base ⊕ type-arg fps
  stamped at `specialize_fn`). The current key uses the *substituted* body's
  `item_body_fp` — **correct**, just not decomposed into (base, args).
- ThinLTO to recover the cross-fn inlining a single module gets for free.

### 8.2 As-built (`ps3t.8.6.2`, the default-flip + bounded-K + library-CGU)

The flip landed. The binary-linking default (`build_binary`, whose sole
production caller is the `bs2 test` path) now routes a non-coverage build
through `build_binary_cgu`; coverage falls back to the whole-program
instrumented path (per-unit objects are uninstrumented). **`compile_program`
(the `bs2 compile → single .ll` path) stays whole-program by seed-train
necessity** — the seed is one self-contained `.ll`, so the selfhost fixed
point and diff-test (both `compile_program`) remain byte-identical; the flip
is verified run-equivalent (full suite + the 7 CGU shapes).

- **Bounded-K partitioning.** `partition_targets` groups fns into ≤ `CGU_COUNT`
  (16, Rust's non-incremental default) units by a stable name-hash
  (`content_id_for(name) mod k`) — name-only so a body edit never moves a fn's
  bucket (the incrementality guarantee). This bounds the repeated declare-pass
  cost at k·program (object emission is in-process `avra_llvm_emit_object`, so
  the cold cost is the declare pass, not `llc` spawns). One object per unit,
  cache-keyed by `fn_unit_key_cgu` (every member's `sig_fp`/`body_fp`/erased ⊕
  type table ⊕ modes ⊕ toolchain); a one-fn edit re-emits exactly its unit. A
  content-keyed link cache skips the re-link when all objects are unchanged.
- **Library-ownership filter** (the `collect_fn_targets` gap CodeRabbit flagged
  on PR #862). Factored the ownership rule into the pure
  `fn_name_belongs_to_roots(name, roots)`; `collect_fn_targets` applies it so
  target collection matches `emit_function_bodies`' skip set — a not-owned fn
  is never collected (and so never handed to an emitter that would `Err`).
- **Cross-unit symbol hygiene.** Splitting one module into N objects meant
  every strong symbol had to be defined in exactly one object. Three hazards,
  each fixed on the CGU path only (whole-program byte-identical): module
  `let`/`mut` globals define once in the wrapper + declare-external in units
  (`define_shared`, the `__release_*` rule); lambda names carry a per-unit tag
  (`Ctx.cgu_unit_tag` → `__lambda_b<i>_N` / `__lambda_w_N`) so the
  emission-order/cache-sensitive lambda-id counter can't collide across units;
  and the float-trait `__vtable_wrap` becomes `linkonce_odr` in CGU mode.
  Guard: `cgu_cross_unit_symbols_test` (the general no-strong-dup invariant +
  the unit-tag invariant + the float-trait wrapper).

**Still open** (not gating the flip, `ps3t.8.6.2` stays open for them): mono-key
decomposition and ThinLTO (see §8.1's out-of-scope list — the substituted-body
key is already correct, so decomposition is a principled-key refactor with no
functional cache-hit gain; both carry whole-program byte-identity risk).

## 9. Persistence: in-process → on-disk → daemon

**Daemon-ready design, in-process first** (§4 decided): the three persistence
tiers land in order, each usable on its own.

### 9.1 In-process memo (lands first)

An in-memory `Db`; a single `bs2 build` reuses answers within the run. Lands
first — incremental speed early, lowest risk.

### 9.2 On-disk content-addressed cache

Memo entries keyed by content-hash serialize to disk. Because L1 nodes are
**flat plain-data arrays**, a cached build **`mmap`s straight off disk — no
parse, no deserialize, no copy** (impossible with a pointer tree; trivial with
the array model). Cache is **namespaced by `(compiler-version, hash-version)`**
(the `ps3t.4.3` requirement) so a compiler or hash-scheme change can never serve
a stale answer. Because entries are content-addressed, the cache is also
**location-independent** — the same bytes can be fetched from a shared/remote
tier (`jg5z.3`) with no key changes.

### 9.3 Warm daemon + LSP (later)

Keeps the query graph live in memory; **is** the LSP server
(errors/type-at-cursor/go-to-def/find-refs are queries the compiler already
answers), and the same structured surface an LLM agent drives. Folds
`qvfb`/`4apk`'s daemon work. **M1** (≤200 ms warm incremental) gates here.

### 9.4 M4 — warm-daemon memory ceiling (pinned here; §13 deferred it to `ps3t.8.1`)

Cold memo entries (those whose `verified_at` lags `current_rev` by more than a
tunable horizon) are **LRU-evicted**; evicting a derived answer is always safe —
it is recomputed on demand. **Ceiling metric:** *resident memo bytes ≤ K × the
on-disk serialized AST size of the working set*, with **K pinned at 4** for the
first daemon (AST + side-tables + memoized derived answers for a fully-checked
working set, before eviction pressure). K is revisited once the daemon's real
resident shape is measured; the point is a *bounded* ceiling with a concrete
eviction policy, not an unbounded cache. Inputs and the current revision's
live-set are never evicted; only cold derived answers are.

## 10. Diagnostics & parallelism

- **Diagnostics ride with values.** A query's answer is `(value, diagnostics)`;
  they memoize and invalidate **together**, so error quality is identical
  incremental vs from-scratch (§10 Tier-3). The diagnostic schema is the decided
  `{code, severity, primary/secondary spans, message, help, fixes}` (§10.F).
- **Parallelism is free.** Pure queries over immutable data → the scheduler
  parallelizes the dependency DAG with work-stealing; no locks, no shared mutable
  state (rule 17). Specifics (scheduler tuning) deferred; the *model* permits it
  from day one.

## 11. Phasing (build order)

Each phase is independently diff-tested (incremental == scratch, byte-identical
IR) and lands as its own PR under the bootstrap-window + seed-train discipline.

- **P0 — passes query-shaped (pure).** Coarse whole-program wrap; proves purity.
- **P1 — red-green memo core (in-process).** §2–§3. The engine + its differential
  oracle. *This is the runtime the parked L3 tickets are gated on.*
- **P2 — name-resolution-as-query + symbol model.** §6.
- **P3 — interface fingerprints (sig + body).** §7. Folds `sh48` + `ps3t.4.3`
  persistent tier. Unblocks the L3 identity lane.
- **P4 — per-item typeck query + early cutoff.** §5, §7. First real incrementality.
- **P5 — per-fn codegen cache + on-disk `mmap` cache.** §8, §9.2.
- **P6 — warm daemon + LSP** (later). §9.3–9.4. Folds `qvfb`/`4apk`; M1/M4 gate.

## 12. Decomposition into impl tickets

The seven `ps3t.8.*` children already partition L6 along exactly these axes, so
this design **decomposes into them** — it does not file parallel tickets. Each
phase (§11) maps to an existing ticket; the design section is its concrete spec.

| Phase | Design § | Ticket | Ticket title (existing) |
|---|---|---|---|
| P0 | §4 | `ps3t.8.3` | make passes query-shaped (pure, explicit inputs) |
| P1 | §2–§3, §3.2 | `ps3t.8.2` | query engine runtime core (memo + red-green invalidation) |
| P2 | §6 | `ps3t.8.4` | name-resolution-as-query + symbol model |
| P3 | §7 | `ps3t.8.5` | interface fingerprints (two-level) |
| P4 | §5, §7 | *(no new ticket)* | per-item typeck early-cutoff = `ps3t.8.3` (pure typeck) ∘ `ps3t.8.5` (fps) ∘ `ps3t.8.2` (engine) |
| P5a | §8 | `ps3t.8.6` | per-function codegen cache (LLVM bitcode, abstract unit) |
| P5b | §9.2 | **`ps3t.8.8`** *(new — the gap)* | on-disk content-addressed memo cache (`mmap` warm-start) |
| — (oracle) | §1, §11 | `ps3t.8.7` | differential test — incremental == from-scratch |
| P6 | §9.3 | `qvfb` L2/L5 + `jg5z.1` | warm daemon + LSP (later; M1/M4 gate) |

**Ordering.** `ps3t.8.2`–`.7` each already `blocks`-depend on `ps3t.8.1` (this
design) and have no cross-edges, so they *can* fan out in parallel once this
lands. The design nonetheless recommends the **P0 → P1 → {P2, P3} → P4 → P5**
build order: query-shaping (`.8.3`) and the engine core (`.8.2`) are the
substrate everything else memoizes through; name-res (`.8.4`) and fingerprints
(`.8.5`) are independent of each other and can run concurrently after the core;
the codegen/on-disk caches (`.8.6`/`.8.8`) come last because they key on the
fingerprints. `ps3t.8.7` (the differential harness) is built *first alongside*
`.8.2` — it is the engine's correctness oracle, not a trailing test.

### 12.1 The gap ticket — `ps3t.8.8` (on-disk content-addressed memo cache)

The seven existing children cover the in-process engine but not **persistence**.
The canonical on-disk-cache design lives in `qvfb` Layer 4 ("content-addressed
persistent cache", `~/.cache/avra/queries/<hash>.bin`, GC, remote protocol) —
now marked *superseded by ps3t.8* and awaiting a home. This design gives it one:
a new `ps3t.8.8` under `ps3t.8`, spec'd by §9.2 (serialize memo entries keyed by
content-hash; `mmap` the flat L1 arrays zero-copy; namespace by
`(compiler-version, hash-version)`). It **blocks-depends-on `ps3t.8.5`** (it keys
on the fingerprints) and folds `qvfb` L4 + the interim `pdme` hashing lessons.

### 12.2 Folded-epic reconciliation (dedupe targets, not parallel work)

- **`ggkh`** — CLOSED / moot; the memoized-decoder-as-salsa-query pattern *is*
  this engine. No action.
- **`qvfb`** — the original 6-layer ladder; its own notes say it is "largely
  superseded by the L6 query engine". Mapping: qvfb L3 (Salsa demand-driven DB) →
  `ps3t.8.2`; qvfb L4 (content-addressed on-disk cache) → `ps3t.8.8`; qvfb L2/L5
  (daemon + LSP) → P6. Keep `qvfb` open only as the daemon/distributed-cache
  umbrella; its engine/cache layers are dupes of `ps3t.8.*`.
- **`pdme`** — the *interim* per-package build cache (most children closed);
  its transitive-dep-fingerprint + validate-on-read + toolchain-hash lessons are
  **direct input to `ps3t.8.8`'s hashing scheme** (§9.2). Not superseded work —
  the correctness discipline carries forward verbatim.
- **`jg5z`** — DX epic: `jg5z.1` (daemon/watch) → P6; `jg5z.2` (per-file IR
  cache) is a coarser-grained sibling subsumed by `ps3t.8.6`/`.8.8`; `jg5z.3`
  (distributed/shared cache) is the *distributed tier* of `ps3t.8.8`
  (content-addressed results are location-independent by construction).
- **`re1b`** — parallel per-fn body emission. **Sibling, not dupe**, of
  `ps3t.8.6`: `.8.6` *caches* per-fn codegen, `re1b` *parallelizes* it; both are
  unlocked by the immutable substrate and compose (cache-miss fns emit in
  parallel). Stays independent.

### 12.3 Unblocks (the L3 identity lane)

Landing `ps3t.8.5` (fingerprints) and `ps3t.8.8` (on-disk cache) supplies the
"actual on-disk hash-consed-cache consumer" that two L3 tickets were parked on:

- **`ps3t.4.3`** (two-tier hashing) lands its persistent crypto-grade tier +
  version-tag + namespacing as `ps3t.8.8`'s cache key machinery.
- **`sh48`** (Merkle `TypeId`) is the **first slice of `ps3t.8.5`'s `sig_fp`** —
  built with the fingerprint, per its own recorded sequencing.

Both are already `blocks`-blocked by `ps3t.8`; their precise consumer is now
identified (`ps3t.8.5`/`.8.8`).

## 13. What this design explicitly does NOT do

- It does not delete the interpreter or change comptime (that is L2 / `ps3t.5`).
- It does not build the derive framework; `@query` ergonomics ride on L4
  (`ps3t.6`) and are hand-wrapped until then (§10.B decided) — L6 never blocks on L4.
- It does not introduce MIR (`1n1v`, deferred b).
- It does not change the language surface or the seed — L6 is an internal
  compiler refactor (§10.A: not seed-gated).
