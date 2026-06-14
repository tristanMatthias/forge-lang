# AST as the Single Source of Truth — Umbrella Epic

**Status:** design / proposal (worked through 2026-06-14)
**Supersedes the scattering of:** `703y.1`, `y9y4`, `s80z`, `93k3`, `y9y4.18`,
`vndt`, `e5qo`, `wc5w`, and the incremental epics `4apk`/`qvfb` — see §7 for how
each folds in. This doc is the spine they hang on.

---

## 1. North star

> The AST is **defined once** (the enum declarations). Every mechanical
> operation over it — traversal, transform, serialization, rendering,
> dispatch — is **derived** from that structure, never hand-written. Adding a
> variant either auto-extends every operation or is a **compile error** at each
> site that must handle it. **Drift becomes unrepresentable.**

The payoff is the project's three goals at once:

- **World-class DX for compiler writers** (us): define a node, get all its
  machinery free.
- **Dramatically less boilerplate**: the ~12 hand-rolled AST walkers, the two
  ~1000-line encode/decode mirrors, the render passes — all collapse.
- **A killer language feature for users**: the very same machinery is
  `@derive(Json/Eq/Debug/...)` on *their* types (see §3, bet 1).

## 2. Why now — the problem

Today every operation over the AST is hand-written, one branch per variant, and
the branches silently mirror each other. The symptoms are everywhere:

- `construct_stmt` (encoder) and `enum_value_to_stmt` (decoder) are two
  ~1000-line dispatchers that must match perfectly; the `so07.8` history logs
  **four** production drift bugs ("added to one side, forgot the other").
- The CLAUDE.md rule *"periodically grep for `-> {}` to find stubs"* exists
  **because** of this drift. It treats the symptom.
- `derive_walker` already proves the cure (generate the walker from the enum) —
  but it only covers same-type enums, and lives beside `@codec`, `quote`, and
  templates as *separate* half-overlapping mechanisms.

The ideas are mostly right; they're just scattered and quietly in tension. This
epic consolidates them into one coherent program.

## 3. What "killer" looks like — the four bets

1. **One system serves compiler writers *and* users.** The machinery that kills
   our boilerplate is, nearly unchanged, the user-facing `@derive(...)`. Rust's
   `derive` is one of its most-loved features; ours is stronger — bidirectional,
   with a compiler-proven `decode(encode(x)) == x`. We build it **once**.
2. **The compiler becomes a query database.** With nodes in a flat numbered
   array + side-table "notebooks" (Layer 1), every fact ("type of node #57?")
   is a **memoized query**. That single shape gives near-instant incremental
   builds *and* a language server (IDE autocomplete/live errors) almost free.
3. **LLM-native, end to end.** Because we can *serialize the AST* (derive!), a
   program is **structured data an LLM can read and rewrite safely**. Pair that
   with machine-readable, *actionable* diagnostics + a `--fix` mode and the
   compiler becomes a tool an LLM **drives**, not just emits text at. Regular,
   low-special-case syntax is exactly what makes an LLM generate correct code
   first try. No mainstream language is designed for this.
4. **Stable identity → trustworthy caches + reproducible builds.** When a
   type/node's identity is a **hash of its structure** (*content-addressing*),
   caches are portable across machines and builds are reproducible.

## 4. The architecture — six-layer spine (foundation up)

### Layer 1 — Node model *(decided)*
Collapse the `Expr`/`SExpr` and `Stmt`/`SStmt` two-type split into **one node
type per level**, each carrying its own location. Aim at the **data-oriented**
design: nodes live in a flat **numbered array**; per-node facts (span, resolved
type, resolved name) live in **side-tables keyed by node-ID**, not as fat fields
on the node.
- **Spans compact**: store byte-offsets (`start..end`), convert to line/col only
  when printing an error.
- **No fat nodes**: small variants stop paying for the biggest variant
  (today every `Stmt` is padded to 112 bytes).
- *Why it's the keystone*: every derived operation walks the tree; a uniform
  tree makes the derived code clean. It also **is** the substrate bet 2 needs.

**Going further (designed-for, staged):**
- **Struct-of-arrays (SoA):** split each *field* into its own dense array (all
  tags together, all left-children together). Max cache efficiency — the trick
  Zig credits for major compile-speed wins.
- **Hash-consing (highest leverage):** intern *whole nodes* by content —
  identical subtrees stored once and shared. Buys, in one mechanism: memory
  savings, **O(1) structural equality** (compare ids, not deep-walk), and
  **automatic incremental** (changed subtree → new id; unchanged → same id).
  Locks arm-in-arm with content-addressing (bet 4) and feeds Layer 6.
- **Typed IDs:** wrap the integer as distinct `ExprId`/`StmtId` so the compiler
  catches wrong-arena mixups (the Layer-3 opaque-handle rule, applied to nodes).
- **Provenance:** every node records where it came from — incl. "generated by
  macro X from line Y" — so errors/tooling trace synthetic code to real source.

**Honest cost:** a big, invasive refactor, and an everyday ergonomic tax
(`arena[node.left]` not `node.left`) paid on every node access forever. Right
trade for a compiler (build-once, traverse-many, wants speed); we pay it
deliberately. Mitigated by good accessors + typed IDs.

- **Side-tables:** dense fact (most nodes have it) → array; sparse fact → map.
- The "node can't stand alone" limit (macro fragments, cross-file refs, daemon
  edits) is *why* we commit to **immutable + hash-consed** — never mutate, only
  append-and-share. The constraint confirms the better design, not fights it.

### Layer 2 — First-class AST in the interpreter *(decided)*
The compile-time interpreter ("eval") currently shuttles a generic `Value` box
and **converts** it to/from native AST nodes (`construct_stmt` /
`enum_value_to_stmt`). Make the AST **first-class**: a `Value` holds a real
native node directly, and matching reads it natively. The everyday round-trip
**vanishes at the root** — there was nothing to convert. This is the finish of
`so07.8`; it shrinks `@codec` to *serialization-for-disk/cache only*, not the
macro pipeline.

- **`Value` isn't the smell — the *string-struct* version of it is.** An
  interpreter genuinely needs one "any runtime value" type. Today's `Value` is a
  fat struct with a `kind: "enum"` **string** + a dozen half-used payload fields.
  Its clean form is a plain enum: `enum Value { Int, Str, Bool, Node(AstNode),
  List, ... }` — tag = the (interned) variant, no strings, no nullable soup.
- **North star — delete the interpreter entirely.** A `@comptime` fn *is* an
  Avra fn; compile it and **run** it (JIT) instead of tree-walking it. Then
  there is **no interpreter and no `Value`** — macros manipulate real, typed
  `AstNode`s at native speed, in the full language. Today's interpreter is a
  *second, partial copy of the language that drifts* — the same disease as the
  hand-written walkers, just bigger. Needs JIT + sandbox infra, so: **design
  toward it, don't block it.** (Zig's `comptime` model.)

### Layer 3 — Typed identity *(decided)*
Replace **string tags** (`kind = "enum"`, `"@std::...::Stmt"`) with **interned
opaque IDs** — assign each type/variant a small integer once, compare integers
forever, keep the string only for printing. `so07.7` already did this for
compile-time *types*; extend it to the runtime *value* model.
- **Discipline (hard rule):** IDs are **opaque handles** — only *compared* or
  *looked-up*, **never inspected**. This lets us start with simple interning and
  drop in **content-addressing** (`wc5w`) later with **zero call-site churn**.
- **Hard rule — nothing hardcoded.** Meaning is carried by the **type system**
  (enums + interned ids), never by string literals or special-cased names. No
  `if name == "Stmt"`, no magic strings on the hot path. Dispatch is structural
  / by-id, so the compiler is a no-brainer to extend: add a variant, and the
  type system points at every place that must change.

### Layer 4 — The derive framework *(decided)*
**One** toolkit, reading the enum decls, emitting per-variant code for
**traverse / transform / serialize / render / dispatch** — replacing
`derive_walker`, `@codec`, and the hand-written walkers with a single engine.
- **User-facing**: `@derive(Walk, Codec, Render, Eq, Json, ...)` works on
  compiler AST *and* user types. We do **not** build it twice.
- **Whole-AST**: handles **structs** (`MatchArm { pattern, body }`) and
  **cross-type recursion** (`Stmt` ⟷ `Expr`) from the start. This **absorbs**
  `y9y4.18`/`93k3` — they are requirements of Layer 4, not separate gates.
- **Bidirectional + proven**: codecs ship with the compile-time
  `decode(encode(x)) == x` guarantee.

### Layer 5 — No-drift discipline *(decided)*
A `_ ->` over a **declared enum** is an **error** — *except* a deliberate
catch-all via an explicit, greppable keyword (e.g. `rest ->`): "forgot a case"
is banned, "handle the remainder" is allowed and *visible*. **Migration:
ratchet** — warning now, flip to error per-module as cleaned; Layer 4 erases
most for free (derived code is exhaustive by construction), so `vndt`'s 2700+
warnings shrink on their own. *Own epic — maps to existing `vndt`.*

### Layer 6 — Compiler-as-query *(open — §9)*
Make every derived fact a **memoized, incrementally-invalidated query** keyed by
node-ID. Delivers incremental builds + LSP. Falls out of Layer 1's
data-oriented substrate. This is `4apk`/`qvfb`.

**Mental model — the compiler is a *spreadsheet*, not an assembly line.** Not
parse→resolve→typeck→codegen over the whole program every time, but a graph of
*questions* ("queries") that each **remember their answer**: "AST of file X?",
"what does `foo` resolve to?", "type of `bar`?". Questions are built from other
questions, forming a dependency graph (like spreadsheet cells referencing cells).
Edit one fn → discard *only* the answers that depended on it, recompute *only*
those; the other 10,000 fns keep their cached answers. = **O(what changed)**. The
named framework is **Salsa** (the engine under rust-analyzer).

**Early cutoff — the change-wave dies the moment it stops mattering.** When a
recomputed query's *new answer equals its old answer*, recomputation **stops** —
dependents aren't touched. Edit a fn's whitespace → its AST query reruns, but
"type of fn?" returns the same type and the wave halts there; the 500 callers
never recompute. (Mechanism: each answer stamps "last-changed" vs "last-verified";
recompute only when an input changed since you verified, and on a matching
recompute bump only "verified" — the *red-green* algorithm.) Most edits touch
surface detail, not meaning, so the wave usually dies in a step or two. This is
what turns *fast* into *instant*.

**The four "wildly fast" levers — each a direct payoff of Layers 1+3:**
1. **O(what changed), not O(program).** Demand-driven queries + content-addressed
   memoization: edit one fn, re-check *that* fn. (The rust-analyzer secret.)
2. **Zero-copy `mmap`'d caches.** The AST is flat plain-data arrays, so a cached
   build maps straight off disk — no parse, no deserialize, no copy. Near-instant
   warm starts. (Impossible with a pointer-tree; trivial with our array model.)
3. **Lock-free parallelism.** Immutable + data-oriented = no shared mutable state
   = no locks → saturate every core (~N× on N cores).
4. **Distributed / remote cache.** Content-addressed results shared across
   machines/CI — "CI built this exact fn yesterday? download the result." (The
   Bazel/Buck dream, for a compiler.)

Bonus (pure data-oriented payoff): **columnar passes** — SoA lets a pass stream
one dense field-array (branch-predictor-friendly, SIMD-able), so *passes* get
fast, not just storage.

**Where it lives, and the IDE for free.** Answers must survive between compiles:
either an on-disk content-addressed cache (simple) or a long-running **daemon**
that keeps the question-graph warm in memory (instant). The daemon *is* an IDE
language server — squiggles, autocomplete, go-to-def, find-refs are just queries
("errors here?", "type at cursor?") the compiler already answers. So **one query
engine = batch compiler + IDE**, no second drifting implementation (the
rust-analyzer insight; the same "one system, not two" as Layer 4). And because
LSP is a structured, machine-driven interface, it's also the natural surface an
**LLM agent** drives — one daemon serves human editors and LLM agents alike.

**Granularity (decided): per-item, content-addressed.** A "question" is sized
*per-query by cost*: expensive queries (typeck, codegen) are **per-item**
(function/type), keyed by **content-addressed identity** so an item keeps its
cache across edits to *other* items; cheap parsing stays **per-file**; never
per-node (bookkeeping exceeds savings). Fine granularity is *unlocked by* Layer
1+3's stable identities — the foundation is what makes the top layer fast.

**Build-order (decided): daemon-ready design, in-process first.** Designed
daemon-ready from day one (no per-process global state; persistent
content-addressed cache), but the first implementation is in-process + on-disk
cache (incremental speed early, low risk); grow into the warm daemon + LSP when
justified.

### Cross-cutting — LLM-native *(decided)*
Rides on Layers 3 (stable IDs) + 4 (serialization).
1. **Structured + actionable diagnostics** — every error emits a machine form
   (code, span, message) + a suggested fix as a structured edit, beside the
   human text. (Cheap: errors already funnel through one renderer.)
2. **`--fix`** — auto-apply those structured fixes.
3. **AST-as-data** — exposed as a *documented, versioned* (content-addressed
   schema) serializable format so external tools/LLMs read **and rewrite** code
   as data. Public-but-versioned, not frozen.

## 5. Decisions locked

| # | Decision | Rationale |
|---|----------|-----------|
| 1 | Collapse to one node type; data-oriented (SoA-capable) array + side-tables; byte-offset spans; **immutable + hash-consed**; typed IDs | Uniform tree ⇒ clean derivation; immutable+hash-consed ⇒ O(1) equality, free incremental, lock-free parallel, mmap caches |
| 2 | AST first-class in the interpreter; everyday encode/decode vanishes | Strongest form of "no boilerplate": it was never converted |
| 3 | Interned **opaque** IDs replace string tags; strings only for printing | Speed + kills the bare-vs-FQN drift class; content-addressing drops in later |
| 4 | One **user-facing**, **whole-AST** `@derive` framework | Build once; absorbs `y9y4.18`/`93k3`; becomes a headline feature |

## 6. Enforced rules — the regrets we refuse to bake in

*These are **hard rules**, gated in CI/lint wherever mechanically checkable —
not aspirations.*

- **Stringly-typed tags** anywhere on the hot path (Layer 3 kills these).
- **Eager-only design** — architect for on-demand/incremental even if we
  implement simply first (Layer 6).
- **Unversioned serialization** — content-address it (bet 4) so cross-version
  caches don't rot.
- **One-off passes that bypass the framework** — a *rule*: AST passes go through
  Layer 4, or they reintroduce drift.
- **Mutable globals** (already forbidden) — they break parallelism + incremental.

## 7. How the existing epics fold in

| Existing epic | Folds into | Note |
|---------------|-----------|------|
| `703y.1` Uniform spans | **Layer 1** | expand scope to data-oriented |
| `so07` Structural foundations | **Layers 2 + 3** seed | mostly done; `so07.8 #6` (delete construct_stmt/enum_value_to_stmt) becomes a **natural consequence** of Layer 2, not a separate `@codec` task |
| `so07.7` Interned TypeId | **Layer 3** | done — extend to runtime values |
| `y9y4` derive_walker | **Layer 4** (traverse) | the proven seed of the framework |
| `s80z` @codec | **Layer 4** (serialize) | **downsized** — Layer 2 removes the macro-pipeline round-trip; codec is for disk/cache only |
| `93k3`, `y9y4.18` | **Layer 4** | absorbed; mark `93k3` superseded |
| `vndt` remove wildcards | **Layer 5** | mostly automatic post-Layer-4 |
| `e5qo` dependent `Value<T>` | **Layer 3** | the typed end-state |
| `wc5w` content-addressed TypeId | **Layer 3** upgrade | drops in behind the opaque-handle rule |
| `4apk`, `qvfb`, `ggkh` | **Layer 6** | enabled by Layer 1; `ggkh`'s "memoized decoder" partly moot once Layer 2 removes the decoder |

## 8. Proposed sequencing

Foundation-up, each layer shipping value on its own. Every step honors the
**bootstrap-window** discipline (feature + tests land first; dogfood into
compiler `src/` only after the seed train advances).

1. **Layer 1** (node model) — the keystone refactor.
2. **Layer 3** (typed identity, runtime side) — can parallel Layer 1; partly
   done via `so07.7`.
3. **Layer 2** (first-class AST) — finish `so07.8`; deletes the encode/decode
   mirror. Depends on 1 + 3.
4. **Layer 4** (derive framework) — unify `y9y4 ∪ s80z ∪ 93k3 ∪ y9y4.18`,
   user-facing. Depends on 1–3.
5. **Layer 5** (no-drift) — `vndt` cleanup; mostly falls out of Layer 4.
6. **Layer 6** (query/incremental) — `4apk`/`qvfb`, enabled by Layer 1.

This is a multi-quarter program; the value is front-loaded — Layers 1–3 alone
delete the largest boilerplate/drift surface in the compiler.

## 9. Open decisions (still to work through)

- **Interpreter elimination (Layer 2 north star):** is "compile-and-run
  `@comptime` (JIT), delete the interpreter + `Value`" a committed (later) epic,
  or a design-toward-don't-block aspiration?
- **`quote{}`'s future:** rework its lowering onto Layer 2 native boxing (keep
  the feature, delete its private encoder). *Decided: rework, not retire.*
