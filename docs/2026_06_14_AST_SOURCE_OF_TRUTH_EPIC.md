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

**Scope:** the AST **and** the codegen **IR** — both get the same data-oriented +
content-addressed + derive treatment, so *codegen* is incremental/cached too
(only changed functions re-emit; folds `re1b` + per-fn codegen). The spine is the
whole representation, front to back.

**Boundary — owns HOW, not WHAT.** This epic owns how the compiler *represents
and processes* code; it does NOT own what the language *means* or what the syntax
*is* (the foundation must never *preclude* those).
- **IN:** node model, IR, typed identity, derive framework, parser *mechanism*,
  type-checking-as-query, incrementality, the compiler's own memory/parallelism.
- **OUT** (separate epics; must-not-preclude): the language's runtime memory
  model (RC/Drop/arenas/escape *semantics*, Axis 9); concurrency (green
  threads/Task/channels, Axis 18); surface-syntax *design* (sibling); BEYOND-V1
  type *theory* (dependent/verified/cryptographic — `cxvp`). (`e5qo`/`wc5w`
  content-addressed *identity* are IN at Layer 3; only the broader theory is out.)
  Holds under stress: escape analysis is a *query* mechanically (IN) but its
  *semantics* are language design (OUT).

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
- **Error-tolerant by construction**: explicit *error/missing* node variants;
  the parser never bails — it yields a partial tree + *all* errors at once.
  Required for the IDE/LLM story (the daemon needs a tree even for broken code).
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

### Layer 2 — Compiled comptime: delete the interpreter *(decided)*
*End-state: `@comptime` is JIT-compiled and run — no interpreter, no `Value`.
First-class AST then comes free (compiled code holds real `AstNode`s). The
"interim" path below is superseded by the JIT but explains what's being deleted.*

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
- **Compiled comptime (JIT) — COMMITTED, not deferred.** A `@comptime` fn *is*
  an Avra fn; compile it and **run** it (JIT + sandbox) instead of tree-walking
  it. End-state: **no interpreter and no `Value` at all** — macros manipulate
  real, typed `AstNode`s at native speed, in the full language. Today's
  interpreter is a *second, partial copy of the language that drifts* — same
  disease as the hand-written walkers, bigger. (Zig's `comptime` model.)
- **Ripple:** committing to the JIT means we **delete `Value`**, not clean it up
  — so the "make `Value` a tidy enum" interim is *moot*, and Layer 3's
  *runtime*-value half disappears too (compiled comptime uses real types; only
  the compile-time **TypeId** interning, already done in `so07.7`, remains
  relevant). Don't polish what we're deleting — aim straight at the JIT.

**JIT specifics (decided).**
- **Mechanism:** in-process **LLVM ORC JIT** — compile the `@comptime` fn's IR to
  machine code in memory and call it directly (the target). A temp-`.so` +
  `dlopen` path is an acceptable bootstrap stage-1 if ORC bindings are fiddly.
- **Capability surface:** **pure by default + a tiny explicit read-only
  allowlist** (`@embed`-style file read for codegen-from-data) — no other IO,
  syscalls, or ambient access.
- **Enforcement:** a **static** comptime-purity check (reuse `@pure`) rejects
  banned calls *before* running; **runtime traps + resource limits** backstop the
  uncatchable cases (infinite loops, memory).
- **Migration:** the JIT replaces the interpreter, but the interpreter **stays as
  a fallback during cutover** so the compiler always works. Removal tracked in
  bead `g18a`.
- **Caching:** comptime results are **content-addressed, memoized queries** (same
  fn + same args → cached) — falls out of the #4 hash scheme + L6.

### Layer 3 — Typed identity *(decided)*
Replace **string tags** (`kind = "enum"`, `"@std::...::Stmt"`) with **interned
opaque IDs** — assign each type/variant a small integer once, compare integers
forever, keep the string only for printing. `so07.7` already did this for
compile-time *types*. (The *runtime*-value half is **mooted by Layer 2's JIT** —
compiled comptime uses real types — so Layer 3 is now compile-time **TypeId**
interning + content-addressing, mostly already seeded by `so07.7`/`wc5w`.)
- **Types are values too:** the type representation is itself hash-consed +
  content-addressed (type-equality = id compare), spanning nominal types,
  structural shapes, traits, and unions.
- **Discipline (hard rule):** IDs are **opaque handles** — only *compared* or
  *looked-up*, **never inspected**. This lets us start with simple interning and
  drop in **content-addressing** (`wc5w`) later with **zero call-site churn**.
- **Hard rule — nothing hardcoded.** Meaning is carried by the **type system**
  (enums + interned ids), never by string literals or special-cased names. No
  `if name == "Stmt"`, no magic strings on the hot path. Dispatch is structural
  / by-id, so the compiler is a no-brainer to extend: add a variant, and the
  type system points at every place that must change.
- **Hashing scheme (decided)** — a node/type's identity *is* the hash of its
  content; getting this right is what makes caches correct, not just fast:
  - **Structure only** — `variant + literal payloads + child-hashes`. **Excludes
    spans, provenance, analysis facts** (those are side-table data keyed by the
    id) — so reformatting never busts the cache.
  - **Cycles** broken by **nominal-by-name** references: a type refers to another
    by interned name/id, not recursive content. Trees hash bottom-up (acyclic).
  - **Deterministic** — canonical content, never addresses; canonical order for
    unordered fields. Same content → same hash everywhere (the distributed cache
    depends on it).
  - **Two tiers:** persistent/distributed = crypto-grade hash + version tag,
    cache namespaced by `(compiler-version, hash-version)` (an algo change is a
    clean miss, never a wrong hit); in-process hash-consing = fast hash with
    content-compare on collision.

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
- **The parser is derived too** *(decided — collapses a false dichotomy)*. The
  reflex "generated parsers have bad errors" is true only of LR/PEG, **not** of
  generated *recursive descent*. So we use a **small EBNF-style grammar DSL** —
  Crafting Interpreters' notation (Ch5 §5.1.2–3) plus *captures* + *build* + the
  `@expect`/`@recover` error annotations — lowered to an **error-tolerant
  recursive-descent** parser via the Ch6 grammar→RD correspondence. From one
  source of truth: world-class errors (authored in the grammar), **partial-tree
  recovery** (the `@recover` points *are* Layer 1's error-nodes), **incremental
  reparse** (Layer 6, tree-sitter-style), and **grammar-as-data** (LLM/tooling).
  - **Small *notation*, big *grammar*.** The DSL is ~9 constructs / a ~200-line
    hand-written seed parser; the *Avra grammar* written in it can be as large as
    Avra needs (a tiny EBNF defines C/Java the same way). No bootstrap
    circularity — the seed parser is hand-written once, like yacc/tree-sitter.
  - **The gnarly 5% stays OUT of the DSL** (this is what keeps it lightweight):
    string interpolation, newline-sensitivity, the `~` context-overload, and the
    `<` generic-vs-less-than ambiguity live in the **lexer** (modes) or a
    **hand-written escape-hatch rule** — they never grow the grammar notation.
  - Worked proof slice (the expression grammar end-to-end): see
    `docs/2026_06_14_GRAMMAR_DSL.md`. Precedent: tree-sitter, ANTLR, Menhir.

**Grammar DSL — concrete shape.** The notation is *Crafting Interpreters*'
grammar metasyntax (Ch5 §5.1.2–3) made executable; lowering follows Nystrom's
grammar→recursive-descent correspondence (Ch6: terminal → match/consume,
nonterminal → call its fn, `|` → if/switch, `*`/`+` → loop, `?` → if), with
panic-mode recovery (his `synchronize()`) lifted into `@recover`:

```avra
grammar Expr {
    expression = equality
    equality   = l:comparison ( op:("!=" | "==") r:comparison )*        -> fold_binary(l, op, r)
    comparison = l:term       ( op:("<"|"<="|">"|">=") r:term )*        -> fold_binary(l, op, r)
    term       = l:factor     ( op:("+" | "-")  r:factor )*             -> fold_binary(l, op, r)
    factor     = l:unary      ( op:("*" | "/")  r:unary )*              -> fold_binary(l, op, r)
    unary      = op:("!" | "-") operand:unary                          -> Unary(op, operand)
               | primary
    primary    = NUMBER | STRING | "true" | "false"
               | "(" e:expression ")" @expect(")", "expected ')'") @recover(sync_to: ")")  -> e
}
```
(`l:`/`op:`/`r:` are **captures**; `-> …` is the **build** that constructs the
AST node from them. `fold_binary` left-folds the repeated `(op rhs)*` into a
left-associative `Expr.Binary` chain.)

Each rule lowers mechanically — the macro `quote`s out one function per rule,
straight from the correspondence table. `factor` becomes:

```avra
fn parse_factor(p: Parser) -> ExprId {        // a rule → a function
    mut left = parse_unary(p)                 //   nonterminal ref → call its fn
    while p.match("*", "/") {                 //   ( ... )* → while loop
        let op = p.previous()
        let right = parse_unary(p)
        left = p.node(Expr.Binary(left, op, right))
    }
    left                                       //   builds the node it's typed to
}
```

This is the recursive-descent idea verbatim — the only difference from the book
is that the by-hand translation (and by-hand `synchronize()`) is automated.

### Layer 5 — No-drift discipline *(decided)*
A `_ ->` over a **declared enum** is an **error** — *except* a deliberate
catch-all via an explicit, greppable keyword (e.g. `rest ->`): "forgot a case"
is banned, "handle the remainder" is allowed and *visible*. **Migration:
ratchet** — warning now, flip to error per-module as cleaned; Layer 4 erases
most for free (derived code is exhaustive by construction), so `vndt`'s 2700+
warnings shrink on their own. *Own epic — maps to existing `vndt`.*

### Layer 6 — Compiler-as-query *(decided)*
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

**Passes never mutate (decided) — the immutable-pass model.** No pass writes on a
node. **Analysis** passes (resolver, typeck) record facts in **side-tables keyed
by node-id** (the tree is read-only; notes live in a separate notebook).
**Transform** passes (desugar, mono, rewrites) **produce a new immutable tree**,
sharing unchanged subtrees via hash-consing, with each new node carrying
**provenance** (L1) back to source so spans/diagnostics survive the rewrite. Both
are memoized queries. This is what makes hash-consing, early-cutoff, and
lock-free parallelism actually hold — and it restructures every existing
(mutating) pass into either a side-table-producer or a tree-rewriter. (Cost is
real; the differential-test harness is what makes the restructuring safe.)

**Type-checking as a query (decided).** Type-checking is a per-item query;
**inference is local to an item** — it reads the *signatures* of referenced
items, never their *bodies* — which mandates **explicit signatures at item
boundaries** (params + return types annotated). That rule keeps incremental
type-checking tractable (a body edit can't silently change an item's type) and
doubles as **LLM-friendliness** (no hidden cross-item inference to track). Avra
already mostly requires it (spec line 430 / P9: signatures are contracts).

*Error types conform:* declared explicitly at the boundary as **union error
types** (`Result<T, IoError | ParseError>`, spec Axis 12.3) — *not* the inferred
`Result<T, _>` form, which the spec weighed (option d) and **rejected** for
option (c) for these same reasons. `?` **auto-widens** a narrower error *into*
the declared union — coercion into a declared type, not inference of it — so the
boundary stays explicit; a body error outside the union is a *local* error, not
a silent signature change. The `Error` trait's `trace()`/`context()`
**auto-accumulate via `?`** as errors propagate — errors bubble *and* gather
context with zero boilerplate while keeping their declared type. (Validated
against the foundational design session `33229b45` / Axis 12.3: "the genuinely
novel part… as easy as exceptions but preserves the type information.")

**Interface fingerprints (decided) — the incremental linchpin.** Each item
carries **two** content-hashes: a **signature fingerprint** (name, param/return
types incl. declared error union, generic bounds, visibility, effects —
*body-independent*) driving *type-check* early-cutoff, and a **body
fingerprint** driving *codegen + comptime* early-cutoff (inlining and
compile-time calls depend on the body). Most edits bump only the body
fingerprint → callers' type-checking is reused; only the edited item re-emits.
(Rust HIR-vs-MIR / Salsa durability tiers.)

**Generics (decided): mono default, `dyn` explicit, instances content-addressed.**
Policy settled in design `86388`/`86308` — monomorphize by default for speed,
explicit `dyn Trait` for heterogeneous, no auto mono-vs-dyn inference. New here:
each mono instance is a **content-addressed cache unit** keyed by `(generic body
fingerprint, type-arg fingerprints)` — a type change re-monomorphizes only the
instances that *use* it, and identical-IR instances **collapse to one artifact**
(IR-level hash-consing). That dedup is the explosion control.

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
- **Nondeterminism** — output must not depend on thread scheduling or machine,
  or the caches lie.
- **Unsandboxed comptime** — the JIT enforces resource limits + no ambient IO.

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

**Migration stance: go hard.** Aggressive/big-bang rewrite is acceptable — no
mandated strangler-fig ceremony, minimal migration scaffolding. The only hard
floor is **bootstrap**: the compiler must still build itself at integration
points (it's self-hosting).

**Verification (the net that makes go-hard safe) — three gating guards:**
1. **Differential testing — the old compiler is the oracle.** Old vs. new over
   the corpus; outputs must match (byte-identical IR where applicable). Lets us
   rip the foundation out and instantly catch behaviour drift, with no migration
   scaffolding.
2. **Selfhost fixed point** `bs2 == bs3` (already enforced).
3. **Property tests on the derive framework** (shape-matrix / `decode(encode(x))
   == x`) — drift *fails a test* by construction.

## 9. North stars & deferred work (decided)

- **Interpreter elimination — COMMITTED (Layer 2 goal, its own epic).** Build
  the JIT + sandbox, delete the interpreter + `Value`; `@comptime` becomes
  compile-and-run. Sequenced within this program, not deferred. Mootes the
  `Value`-cleanup interim and Layer 3's runtime-value half.
- **`quote{}`:** rework its lowering onto Layer 2 native boxing — keep the
  feature, delete its private encoder. *Rework, not retire.*
- **LLM-friendly *surface syntax*** — a **separate sibling epic**, not this
  internals program. Carry these principles there: maximal regularity, low
  ambiguity, few special cases, one obvious way to say a thing.
