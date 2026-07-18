# L6 Codegen Cache & the Incremental-Codegen Frontier

**Status:** design record. The *write side* (below) is implemented; the
*read-side architecture* is a recorded recommendation with the decision
deliberately deferred. **This document does not gate any work** — the landed
write side stands on its own, and the read side is tracked separately
(`ps3t.8.6.1`). It captures a first-principles design exploration plus the
empirical probe that grounds it, so the eventual read-side decision rests on
numbers rather than conviction.

Companion to `docs/2026_07_16_L6_QUERY_ENGINE_DESIGN.md` §8 (per-function
codegen cache). Where that section sketched "cache LLVM bitcode per function
behind an abstract cache unit," this doc reasons from the success metric
backward and finds that framing under-scopes the win — and re-derives what
the artifact and the architecture should actually be.

---

## 1. Problem & the forcing function

The pipeline: parse → resolve → typecheck → monomorphize → **codegen (AST→IR)**
→ **opt (LLVM passes)** → **llc (IR→object)** → link.

The goal (ps3t.8.6): edit one function, and reuse already-compiled output for
the unchanged functions instead of recompiling everything — the substrate of a
fast incremental compiler, daemon, and LSP.

**First-principles correction to the §8 framing.** §8 says cache *bitcode*.
But bitcode is the output of codegen — caching it only lets you skip the
**AST→IR** step, which in an LLVM pipeline is the *cheap* half. The expensive
half is **opt + llc** (the backend); the whole-module `.ll` we lower is ~746k
lines. So bitcode-caching alone banks the smaller cost. To actually get fast,
the cached artifact must be the **object** (post-llc).

**The forcing function.** The success metric (ps3t.10) is **≤200ms for a
one-line body change, warm daemon.** Working backward:

- Re-lowering the whole module through `llc` = seconds → **fails**. The backend
  *must* operate on per-function (or small-group) units. This is not a
  preference; the metric requires it.
- Re-linking thousands of objects from scratch may also blow 200ms → you need
  incremental/in-memory linking, or to skip the linker.

So "per-function codegen cache" means **per-function separate backend
compilation units**. Every architectural constraint below follows from that.

---

## 2. Prior art (honest)

| Language | Granularity | Recombination | Cache key | Note |
|---|---|---|---|---|
| **Rust** | CGU (a *group* of fns; 256 units incremental) | separate objects + ThinLTO | revision + fingerprint | frontend is query-based (Salsa-like) |
| **Swift** | **file** | separate objects | file dep-graph (`.swiftdeps`) | coarse; a big file recompiles wholesale |
| **Go** | **package** | separate objects | **content-addressed** (`$GOCACHE`) + export-data early cutoff | famously *doesn't* balloon |
| **Zig** | **function** | **in-place binary patching** (no linker) | own backend | wrote custom x86/arm backends *specifically* to patch one fn in place |
| **ccache/sccache/Bazel** | translation unit / action | content-addressed memo, remote-shareable | hash(inputs, cmd) | caches, doesn't change granularity |

Lessons:

- **Why Rust balloons** (the common complaint): not the per-fn IR. It's that
  the incremental cache serializes a *huge* amount of intermediate query state
  (MIR, type tables) keyed per-revision; CGU objects proliferate × many crates;
  debug info; and monomorphization redundancy (`Vec<T>::push` gets a fresh copy
  per `T`; cross-crate dedup via `share-generics` is limited and per-crate).
  Rust groups fns into CGUs rather than per-fn *precisely* to bound unit count
  — so "Rust CGU" is already a compromise away from the per-function ideal, made
  for the object-proliferation reason.
- **Go is the model for the *cache itself***, not the granularity:
  content-addressed keys + early cutoff on interface (export-data) hashes,
  aggressive and well-behaved, rarely needs a manual wipe. Avra's L6 already has
  this shape (content-addressed `body_fp`/`sig_fp`, red-green early cutoff). We
  are closer to Go's discipline than Rust's.
- **Zig is the frontier**: true per-function incrementality with *no object
  proliferation and no linker* — but only by abandoning LLVM for a custom
  backend that patches a function's machine code in place.

---

## 3. Design axes (the knobs)

1. **Granularity**: program → package → file → CGU → **function** → basic block.
   Finer = more precise invalidation and more dedup, but more units and lost
   cross-unit inlining.
2. **Recombination**: link separate objects (Rust/Swift/Go) · **in-place patch**
   (Zig) · re-merge into one module (defeats backend caching — only saves the
   frontend).
3. **Key**: content-addressed (Go, Bazel) vs revision (Rust). Content-addressed
   wins — position-independent, shareable, no false invalidation. Avra already
   chose this at the frontend.
4. **Inlining tradeoff**: fine granularity kills cross-function inlining *unless*
   you add a ThinLTO-style summary-based relink. This is the one real cost of
   going fine, and ThinLTO is the known escape hatch.

---

## 4. The world-class synthesis (near-to-mid term)

The individual techniques above are all known. Avra's advantage is a foundation
nobody else had when they built their incremental story: **a content-addressed
query engine with two-level fingerprints already driving the frontend.** That
enables a synthesis not assembled in one production language:

**A. One fingerprint, frontend to object.** The same `body_fp` that keys the
typeck query keys the codegen artifact keys the object. Most compilers bolt an
incremental *backend* cache onto a frontend that predates it — there is a seam.
Avra can have a single content-addressed dep graph from AST to `.o`.

**B. Global content-addressed dedup of monomorphizations.** In a monomorphizing
language, identical instantiations that lower to identical machine code can
collapse to one compile + one stored artifact across the whole program, across
rebuilds, and across a team via a shared cache. *(See §6 — the empirical probe
demotes this from headline to footnote; keep it as a bonus, not a pillar.)*

**C. Two backends for two jobs, one substrate.** The 200ms metric lives in the
*dev loop* (`bs2 test`/`run`/LSP under the daemon), not release builds:

- **Dev/daemon → LLVM ORC JIT with per-function re-JIT.** ORC supports
  redefining a single symbol in a warm image. This gives Zig's in-place-patch
  *experience* (no linker, no object proliferation, sub-100ms per-fn swap) while
  keeping LLVM — no custom backend to write. This is where the metric is won.
- **Release build → content-addressed per-fn object cache + ThinLTO.** Fine
  incrementality for speed; ThinLTO summaries recover the cross-function
  inlining that fine granularity would otherwise cost.

Both modes consume one thing: content-addressed per-fn units keyed by the L6
fingerprint. That shared substrate is the foundation; JIT and object+ThinLTO
are two consumers.

---

## 5. The frontier (long term) — compiler as a self-adjusting database

Push past the incremental-cache framing entirely. Every system in §2 treats
three things as separate: the *compiler* (a batch function `source → binary`),
the *incremental engine* (memoization bolted on), and the *cache* (storage on
the side). The frontier move is to see they are the same object.

> The compiler stops being a function and becomes a **persistent,
> content-addressed, self-adjusting database.** Its queryable views are
> {types, IR, machine code, binary}. "Compiling" is *querying a view*.
> "Incremental" is the database's *structural sharing*. "The build cache" *is*
> the database. "Distributed cache" is *replicating* it. Reproducible builds,
> time-travel, and cheap branch-compilation all fall out of the same substrate.

You don't build five features; you build one substrate and they are
consequences. Four moves, each derived from a theoretical limit:

**Move 1 — content-address *below* the function (space floor).** Store the
program as a Merkle-DAG: program → functions → basic blocks → canonical
instruction sequences, each node identified by the content hash of its
*canonical form* (SSA/registers alpha-renamed, offsets abstracted, relocations
symbolic). Identical fragments are stored once. *Prior art:* Unison
(content-addressed *definitions*, interpreted, not sub-function native).
*Hard part:* the canonicalize ↔ re-specialize boundary. **Demoted by §6.**

**Move 2 — codegen as self-adjusting computation (compute floor).** Express
lowering as a self-adjusting computation (Acar SAC / differential dataflow) over
the DAG, so an edit re-derives only the nodes whose content hash actually
changes, with early cutoff at every level. And take *edit operations* from the
editor (LSP) directly rather than diffing saved files — parsing/diffing/"save"
leave the incremental path. Work ∝ semantic delta, and the delta is handed to
you. *No one has applied SAC to a native code generator.* A red-green query
engine (Avra's L6) is a coarse, hand-rolled SAC; this makes it fine-grained.

**Move 3 — delete the linker (speed floor).** Make every block
position-independent and self-relocating, with cross-block calls routed through
a content-addressed indirection table. A running image is *assembled by
memory-mapping* reachable blocks; an incremental rebuild updates the table
entries whose target hash changed (O(changed calls), not O(link)). Producing a
distributable binary = serialize the reachable DAG slice + freeze the table;
that freeze (collapsing indirections, inlining hot cross-block calls) *is* the
ThinLTO analog, run only for release. Zig patches in place; this never places.

**Move 4 — speculative compilation (latency floor → 0).** Spend idle daemon
cycles precompiling the edit you're about to make (the fn under the cursor, both
branches of a half-typed `if`). With content-addressing, wrong guesses aren't
wasted and right guesses make save-to-result latency zero.

**The unification.** Because identity = content hash at every level, these all
become "sharing nodes in the DAG": incremental build = structural sharing
between versions; cross-program/mono dedup = two programs referencing one node;
distributed cache = replicating nodes (and the hash *is* the correspondence
proof, so a shared cache is zero-trust — self-certifying, un-poisonable);
time-travel/branch-compile = two roots sharing ~all nodes; reproducible build =
the root hash is the build identity. One substrate; every `jg5z` DX deliverable
is a corollary.

**Honest accounting.** The ingredients exist in research isolation — Unison,
SAC/differential dataflow, Souper (content-addressable superoptimization), Zig
(native in-place patching), Nix (coarse content-addressed builds). *What no one
has built is the unification:* content-addressed sub-function Merkle-DAG +
self-adjusting native codegen + link-free mapped execution, as one compiler.
That is the unexplored frontier, hard in three specific places: the
canonicalize/re-specialize boundary (Move 1), the SAC trace overhead (Move 2),
and indirection cost before the release freeze (Move 3).

**Why Avra can reach it.** L6 already builds ~60% of the substrate: immutable
structurally-shared AST; content-addressed two-level fingerprints; a red-green
demand-driven query engine with early cutoff; and the landed write side (§7)
already content-addresses and dedups function artifacts. The frontier is *L6
pushed down two levels* (function → basic block) and *out one level* (IR →
mapped native), with the query engine's early-cutoff promoted into SAC
propagation. Evolutionary path, revolutionary end-state.

---

## 6. The empirical probe (grounding — this is why the doc exists)

Before investing in the frontier's *space* thesis (Move 1), measure it. A
canonical-dedup analysis was run over the write side's per-fn IR artifacts from
a full **selfhost** compile (the compiler compiling itself: 4,130 functions,
46,987 basic blocks, 31.8 MB of IR, extracted via `AVRA_FN_CACHE`).

| Level | Canonical dedup | Reality |
|---|---|---|
| **Function** | **1.05×** (95.4% distinct) | Negligible. The "global mono-collapse is the big win" claim is **not supported** on the compiler corpus. |
| **Basic block** | 1.65× headline, **~11% recoverable bytes** | 27% of blocks are ≤2-line control-flow stubs (`if_else`, `sc_short`, `forin.cond`, `errdefer_path` — Avra's own feature-lowering skeletons) where a per-block hash reference roughly cancels the block. Only **328** distinct blocks are ≥4 lines *and* repeat ≥4×. |

**Conclusion: deduplication is not the win — at least not on the compiler.**
(Caveat: the compiler is light on monomorphization redundancy; a generics-heavy
*user* application could show higher function-level collapse. Unproven, and not
the load-bearing case.)

The value of *both* the pragmatic object-cache and the futuristic frontier is
**incrementality + latency** — precisely the ps3t.10 metric — which is
**independent of the dedup ratio**. Neither direction ever rested on it. So the
probe invalidates the *space* story and leaves the *speed* story intact — and
dropping the dedup pillar *simplifies* the architecture, removing Move 1's
sub-function canonicalization machinery (the hardest, riskiest part).

*Method note:* canonicalization abstracted SSA-local numbering, the function's
own name, and (aggressive variant) position-numbered anonymous data globals;
call targets to other symbols were kept literal to avoid overstating. Probe was
a throwaway analysis, not committed.

---

## 7. Recommendation & what is landed

**Sell the work as "work proportional to the semantic delta of your edit," never
as "a smaller cache."**

**Landed (write side — `ps3t.8.6`, opt-in, byte-identical, does not touch the
default path):**

- `build/fncache.av` — the abstract cache-unit store: two-level content-addressed
  layout (`key/<keyhash>` pointers over a deduped `art/<arthash>.unit` store),
  path-only artifact handling (binary-safe), atomic publish, completeness-validated
  reads that demote damage to honest misses.
- `avra_llvm_fn_print_to_file` — per-function IR extraction (atomic; text IR is
  the v1 artifact format, bitcode/object slot in behind the same seam).
- `codegen/fnunits.av` — write-side publish walk after `emit_function_bodies`,
  gated on `AVRA_FN_CACHE`, mirroring emission's skip conditions; the pass never
  touches the module, so cache-on and cache-off emission are byte-identical.
- Keys fold the mangled symbol name (the printed IR embeds it — identically-bodied
  fns must not cross-replay), plus `type_table_fp` (a registration-order snapshot
  of the type environment), the `@mono_erased` regime, and the toolchain fp.

**Recommended read side (`ps3t.8.6.1`, decision deferred):** **object-cache-first.**
Per-fn LLVM *modules* (unit-local anonymous numbering — which incidentally
dissolves the `@.str.N` insertion-order obstacle below) → objects, cached and
skipped on edit, ThinLTO for inlining. It continues the landed work, delivers
the concrete skip-recompile win, and composes with parallel per-fn emission
(`re1b`) and the daemon. The SAC / link-free-mapped / speculative frontier (§5)
layers on the same substrate afterward. The default (cache-off) path stays
byte-identical to the integration compiler; the cached path's oracle is
**run-equivalence** (cold vs warm cache produce a binary that runs identically)
plus a one-fn blast-radius spec.

**The `@.str.N` obstacle (why the read side is its own effort).** Body emission
lazily creates module-header globals (`ctx.global_str` → `LLVMBuildGlobalStringPtr`),
and LLVM numbers anonymous globals by *module-wide insertion order* (proven:
`fn a{println("alpha")}`→`@.str`, `fn b{println("beta")}`→`@.str.1`). A cached
per-fn IR fragment embeds position-numbered global refs, so naive text-splice
into a shared module cannot be byte-identical. Per-fn *modules* (either backend
path) make numbering unit-local and the problem vanishes — which is another
reason the object/module route, not text-splicing, is the answer.

---

## 8. Staging & non-blocking note

1. **Write side** — landed (`ps3t.8.6`). Foundation, direction-independent.
2. **Object-cache read side** — `ps3t.8.6.1`, recommended, decision open. The
   concrete 200ms lever.
3. **ORC-JIT dev loop** — layers on the same substrate; where the interactive
   metric is actually won.
4. **Frontier (SAC / link-free mapped / speculative)** — the long game;
   `ps3t.8` epic territory, evolved from L6, not a rewrite.

This document is a **record and a direction, not a gate.** The write side is
mergeable as-is; the read-side architecture can be chosen when convenient
without stalling it; and the frontier is captured so it is not re-derived from
scratch later. Nothing here blocks continued ps3t.8.6 work.
