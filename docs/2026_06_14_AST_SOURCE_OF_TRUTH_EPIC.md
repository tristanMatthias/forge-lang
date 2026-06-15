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

**Scope:** the AST **and** the codegen **IR** — front to back. The AST gets the
full data-oriented + content-addressed + **derive** treatment. The codegen IR
gets **content-addressed per-function caching + exhaustive dispatch** — but *not*
derivation: lowering is bespoke per-variant *logic* (emitting a `Binary` ≠ a
`Call`), so it stays hand-written; only its *dispatch* is exhaustive-by-
construction (L5) and its *output* is cached. One fn edit → only that fn re-emits
(folds `re1b` + per-fn codegen).

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

### Layer 1 — Node model *(decided · epic `ps3t.3`; folds `703y.1`)*
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

### Layer 2 — Compiled comptime: delete the interpreter *(decided · epic `ps3t.5`; folds `so07`, `g18a`)*
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

### Layer 3 — Typed identity *(decided · epic `ps3t.4`; folds `wc5w`, `e5qo`)*
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

### Layer 4 — The derive framework *(decided · epic `ps3t.6`; folds `y9y4`, `s80z`, `93k3`†)*
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

### Layer 5 — No-drift discipline *(decided · epic `ps3t.7`; folds `vndt`)*
A `_ ->` over a **declared enum** is an **error** — *except* a deliberate
catch-all via an explicit, greppable keyword (e.g. `rest ->`): "forgot a case"
is banned, "handle the remainder" is allowed and *visible*. **Migration:
ratchet** — warning now, flip to error per-module as cleaned; Layer 4 erases
most for free (derived code is exhaustive by construction), so `vndt`'s 2700+
warnings shrink on their own. *Own epic — maps to existing `vndt`.*

### Layer 6 — Compiler-as-query *(decided · epic `ps3t.8`; folds `4apk`, `qvfb`, `ggkh`, `re1b`, `pdme`, `jg5z`)*
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

**Codegen (decided): cached, not derived.** Lowering is **bespoke per-variant
logic** (emitting a `Binary` ≠ emitting a `Call`) — *not* mechanical, so it stays
**hand-written**; only its dispatch is exhaustive-by-construction (L5). What it
gets from this program: **per-function, content-addressed caching** keyed by the
body fingerprint (edit one fn → only it re-emits).
- **Now (a):** cache **LLVM bitcode per function** behind an *abstract* cache
  unit (so the next item can slot in without re-plumbing).
- **Deferred (b):** an **own mid-level IR (MIR)** between AST and LLVM — a stable,
  compact, content-addressed cache unit + a home for language-level analysis/opt
  + backend independence. Booked as epic `1n1v`.

### Cross-cutting — LLM-native *(decided · epic `ps3t.9`; folds `jg5z.7`)*
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

## 10. Subsystem decisions (red-team pass 2)

Genuinely deliberated — alternatives argued, then decided. **Two moved under
scrutiny (A, B);** the rest held but sharpened.

### A. Bootstrap of the rewrite *(decided — revised)*
*The fork:* big-bang (rebuild new compiler with old seed) vs staged-with-shim vs
"it's mostly not a bootstrap problem at all."
*The argument:* big-bang dies instantly — the old seed can't parse/run new
compiler *syntax*. **But** the staged-shim framing (my first pass) *over-stated*
the constraint. Decisive insight: **the L1 node model — and most of this program
— is an *internal data-structure refactor of the compiler*, written in *current*
Avra (arrays, structs, int ids). The building compiler (old seed → bs2) compiles
it fine; no new language feature → NO seed jump.** A seed jump is needed *only*
where the compiler's **own source dogfoods new syntax/semantics** the building
compiler lacks (the existing bootstrap-window cases): the parser written *in the
grammar DSL*, `@derive`/`@query` used *in compiler `src/`*, new enum variants /
L5 exhaustiveness-as-error in `src/`.
*Decision — split the migration:*
- **Internal refactors + new-capabilities-for-user-code** (L1 arenas, the JIT
  *for user comptime*, the query *engine*, codegen caching): **not seed-gated** —
  always buildable in current Avra, so **"go hard" fully applies here.** A compat
  shim for L1 is *optional risk-management*, **not** a bootstrap necessity.
- **Compiler self-dogfooding of new surface** (grammar-DSL parser, `@derive`/
  `@query` in `src/`, L5 gating, new variants): **seed-gated** by the existing
  bootstrap-window discipline (feature+tests → seed advance → dogfood).
*Net:* the bootstrap floor is real but **narrow** — it constrains only the
dogfooding, not the bulk. (Also relaxes the pass-1 "seed train serializes
everything" worry: most work isn't seed-gated.)

### B. The query engine *(decided — revised)*
*The fork:* full framework up front vs defer incrementality vs core+derive.
*The argument:* deferring risks the "eager-only" anti-goal; building the full
framework up front *couples* the engine to L4 (the `@query` derive needs the
derive framework first). Resolve by **decoupling**: write every pass
query-shaped — a pure fn with explicit inputs — from day one (cheap, *and* it's
the anti-goal fix), so the engine can wrap them whenever it lands.
*Decision:* **(1)** passes pure/query-shaped from the start; **(2)** a **bounded
runtime core** (red-green invalidation + content-addressed memo store, §4) added
as a phase, **heavily differential-tested — incremental result MUST equal
from-scratch result** (the engine's correctness oracle); **(3)** a **`@query`
derive** (L4) as the *ergonomic* layer once L4 exists — hand-wrapped until then,
so the engine never blocks on the derive framework. Query **cycles error** by
default; recursive queries opt into fixpoint.

### C. Name resolution / symbol model *(decided)*
*Argument:* the only competitor (mutating annotation pass) is killed by #3
(immutable). Subtlety that survived scrutiny: a symbol's identity is its
**definition site**, not its name (two `foo`s in different scopes differ).
*Decision:* **symbol id = content-hash of (qualified path + kind)** (unique,
stable); **resolution is a query** keyed by scope chain + imports; a module's
**exported surface = its public items' signature-fingerprints** (§4) → changing a
module's *private* internals doesn't invalidate importers; visibility is in the
fingerprint. Falls out of the foundation.

### D. Derive framework — pipeline integration *(decided)*
*Argument:* alternative slots fail — post-typecheck leaves generated code
unchecked (unsafe); pre-resolve lacks enum info. Post-resolve/pre-typecheck is
the sweet spot (Rust proc-macro timing, today's `@expand`). Risk found:
non-terminating expansion (a derive that emits itself).
*Decision:* runs **post-resolve, pre-typecheck**, **via the JIT** (interpreter
fallback during bootstrap, `g18a`); generated AST is **re-resolved +
type-checked** (never trusted); expansion is a **memoized query run to a
*bounded, cycle-detected* fixpoint** (a non-terminating derive errors).

### E. Node / arena layout *(decided)*
*The fork:* one unified arena (uniform `NodeId`, simpler "any node", worse cache
+ weaker typing) vs per-type arenas (SoA-friendly, typed, but "any node" needs
typed-id handling).
*The argument:* our priorities are performance + type-safety + per-type derived
code → per-type wins; the "any node" case (provenance, generic traversal) is
already handled by the derive framework's cross-type code (Fork B) + typed ids.
*Decision:* **per-type arenas with typed IDs** (`ExprId` = index into the `Expr`
arena; cross-type refs are typed ids). **Array-of-nodes now; SoA-per-field is a
transparent later optimization** (the id stays an index). Hash-consing +
side-tables per-arena.

### F. Diagnostic schema + `--fix` *(decided)*
*Argument:* a minimal `{code,msg,span}` is killed by the spec's mandated rich
errors. Refinement under scrutiny: fixes aren't all safe to auto-apply.
*Decision:* `{ code, severity, primary span, secondary spans, message, help,
fixes }`; **Fix** = `{ description, applicability, edits: [{span, replacement}] }`
with **`applicability` = machine-applicable | needs-confirmation** (rustc's
model); `--fix` applies **only machine-applicable** ones (non-overlapping;
conflicts reported). One value renders to human text **or** JSON; the JSON schema
is a **versioned public contract**. LSP/rustc-shaped → familiar to LLMs.

### Tier-3 resolutions
- **L1 staging:** the compat shim is *optional* (revised A — L1 isn't
  seed-gated); use it as risk-management to migrate passes incrementally.
- **Parallelism:** pure queries over immutable data → the query scheduler
  parallelizes the DAG (work-stealing); specifics deferred.
- **Diagnostics in the query model:** a query's output is *(value + diagnostics)*
  → they memoize + invalidate together; quality preserved.
- **Daemon memory:** LRU eviction of cold memoized results; specifics deferred.
- **`Value`-deletion ripple:** audit std/user exposure of `Value` before L2
  deletes it (tracked under `g18a`).

## 11. Execution DAG (beads structure)

The beads refactor that makes `bd ready` show *exactly* the right work. 241
non-closed issues triaged: **spine** (re-parented into the layer epics) vs **out**
(stays under its own epic).

### Track-epics under `ps3t`
| Epic | Track | Folds in |
|---|---|---|
| `ps3t.1` | **L0** Tracer bullet *(gate)* | — |
| `ps3t.2` | **HRN** Differential-test harness *(gate)* | — |
| `ps3t.3` | **L1** Node model | `703y.1` (uniform spans, *in flight*) |
| `ps3t.4` | **L3** Typed identity | `wc5w`, `e5qo` (`so07.7` done) |
| `ps3t.5` | **L2** Compiled comptime / JIT | `so07`/`so07.8`, `g18a` |
| `ps3t.6` | **L4** Derive framework + grammar DSL | `y9y4`, `s80z` (+`epkx`/`sl6c`/`cyxs`/`jw6v`/`x7be`), `93k3`† |
| `ps3t.7` | **L5** No-drift | `vndt` (+`.1`/`.2`) |
| `ps3t.8` | **L6** Compiler-as-query | `4apk`, `qvfb`, `ggkh`, `re1b`, `pdme`, `jg5z` |
| `ps3t.9` | **LLM** native | `jg5z.7` + new |
| `1n1v` | MIR *(deferred)* | — |

† `93k3` superseded by L4.

### Dependency DAG (drives `bd ready`)
```
L0 ──▶ HRN ──▶ ┌ L1 ┐
               └ L3 ┘ ──▶ L2 ──▶ L4 ──▶ L5
                    L1 ──────────▶ L6
                    L3, L4 ──────▶ LLM
                    L4, L6 ──────▶ MIR
```
Gates serial (`L0 → HRN → all`); then **L1 ∥ L3**; then **L2 ∥ L4** + L6-engine;
L5 / LLM / MIR trail. `bd ready` surfaces L0 → HRN → L1+L3 → fan-out.

### New tickets (from §10 + de-risking)
Each layer's **first child is a design-doc ticket** (Definition-of-Ready). Plus:
L0 tracer slice + metric baseline; HRN harness; L1 arena/typed-id/hash-cons; L2
ORC JIT/sandbox/purity-check; L3 interning + hashing; L4 derive engine +
grammar-DSL + seed parser; L6 query engine + name-res + fingerprints; LLM
diagnostic schema/`--fix`/AST-as-data; `ps3t` success-metrics.

### Out of spine (stay under their own epics — not pulled in)
Nullability (`xm2g.*` ~18), RC memory (`rcsf.*` ~5), test-runner/cache
(`uzs9`/`pdme`/… ~30), Components V2 (`vez6.*` ~16, *feeds* L4), language features
(~14), general bugs (~40), CLI (`y4n1.*` ~4), isolated/channels (`nce6.*` ~5),
bd/infra (`8nza`, `87al`, … ~4). **Cross-linked inputs (not moved):** `rcsf.4`
(AST phase arenas) → L1; `y4n1.8` (module-graph name-res) → L6; content-addressed
cache bits → L6.

### "How" beyond the DAG
Def-of-Ready = a layer's design-doc ticket is closed. **Seed-gating tag** on the
tickets that dogfood new surface in compiler `src/` (§10.A) — the only
serialized work; most isn't gated. Agent-sized tickets w/ explicit acceptance.
Success metrics (§13) gate L1/L2/L6. Assignees left open for farming; the DAG decides
what's pickable.

## 12. Working the program (for agents)

How an agent picks up and executes `ps3t` work.

**Every session:** `bd ready` → claim (`bd update <id> --claim`) → read the
ticket's **acceptance criteria** + the spine-doc sections it references. The DAG
decides what's pickable — don't touch blocked work.

**Wave order (the DAG enforces it):**
1. **L0** tracer (`ps3t.1.1`) — *one* agent; validates the architecture. GATE.
2. **Metrics** (`ps3t.10`) + **HRN** harness (`ps3t.2.1`) — set targets + build
   the old-vs-new oracle.
3. **Layer design docs** (`ps3t.N.1`) — each layer's Definition-of-Ready; *can*
   parallelize. They decompose/refine that layer's impl tickets.
4. **Impl fan-out** — L1 ∥ L3, then L2 ∥ L4 ∥ L6-engine; L5/LLM/MIR trail.

**Hard rules (from the spec):**
- **Design-doc-first:** a layer's impl tickets depend on its design-doc ticket —
  write/read it before implementing.
- **Differential-test gate (HRN):** every change keeps old-vs-new output
  identical (or selfhost byte-identical). It's the merge gate — run before push.
- **Bootstrap window is *narrow* (§10.A):** internal refactors (arenas, engine,
  caches) are **not** seed-gated and build normally; only **dogfooding new
  syntax/macros in compiler `src/`** needs a seed advance. Don't over-serialize.
- **Staged, never broken (§10.A):** big changes (esp. L1) use the compat shim so
  the tree always builds; "go hard" *within* a buildable step.
- **Parallel coordination:** branch/worktree per agent (`bd worktree`); the
  seed-train is serialized (one advance at a time); the harness catches conflicts.
- **No destructive git** (`checkout --` / `reset --hard` / `clean`); commit +
  push per change; beads auto-syncs — **requires `bash scripts/bootstrap.sh` at
  container start (NOT `sh`)**.
- **Close a ticket only at 100%** of its acceptance criteria (CLAUDE.md rule 19);
  if a premise looks stale, check the ticket's PLAN-RECONCILE note first.

## 13. Success metrics — the numbers that gate L1/L2/L6 *(ps3t.10, agreed 2026-06-15)*

The program is justified by **O(what-changed) incrementality** (§3 bet 2, §4
Layer 6). These are the concrete numbers that decide whether the rewrite
delivered; a layer is "done" only when its gate metric holds *and* M3 does.

**Baseline — current compiler (measured 2026-06-15):** a 1-line change triggers
a *full* ~33s recompile (no function-level incrementality); cold/clean build
~390s; `bs2 == bs3` selfhost byte-identical (enforced via `make selfhost` +
`make diff-test`). Today a one-character edit costs ~33 seconds — the number the
program exists to demolish.

| # | Metric | Target | Gates |
|---|---|---|---|
| **M1** | Incremental rebuild: edit→artifact for a **1-line body change in a large module** (warm daemon) | **≤ 200 ms** (~165× vs today) | L6 (`ps3t.8`) |
| **M2** | Cold (from-scratch) build | **≤ 1.0× the pre-rewrite compiler** (no regression) | L1 (`ps3t.3`), L2 (`ps3t.5`) |
| **M3** | Selfhost byte-identical (`bs2 == bs3`) **and** HRN diff-test green | holds at **every** layer landing | all |
| **M4** | Warm-daemon memory ceiling | **deferred** — define in `ps3t.8.1` when the daemon's shape + on-disk AST size are known | L6 |

- **M1 (≤ 200 ms, aggressive)** effectively requires the in-memory daemon (§4
  Layer 6 "warm question-graph") to clear the bar — deliberate: "instant" is
  what makes the compiler a live tool (LSP, LLM-driven `--fix`). The
  query/codegen portion should be ~sub-100ms; the budget leaves room for the
  incremental link.
- **M2 (no regression)** banks on SoA cache-efficiency, columnar passes, and
  lock-free parallelism (§4 Layer 6 "four wildly fast levers") offsetting the new
  arena / hash-cons / query overhead. The incremental win cannot be bought with a
  slower from-scratch build.
- **M3** is the merge gate, already enforced in CI (`diff-test.yml` +
  `bootstrap-window.yml`, `make selfhost`).
- **Measurement:** M2 = `time make` from clean vs the baseline above, re-checked
  at each layer landing; M1 needs L6's query engine + warm daemon to exist (until
  then it is the target the `ps3t.8.1` design builds toward, not a live gate); M3
  runs every PR. Revisit a target only on a hard architectural constraint —
  record the revision here.

## 14. L1 node model — detailed design *(ps3t.3.1)*

Productionizes the Layer 1 decisions (§4 Layer 1, §10.E) — **validated
end-to-end by the L0 tracer** (`ps3t.1.1`, `bootstrap/scratch/tracer_bullet.av`):
per-type SoA arena + typed `ExprId` + byte-offset span side-table + content
fingerprints already ran and produced byte-identical, correctly-cached output.
L1 is "build that for real" over the live AST: **43 `Expr` + 38 `Stmt` + 9
`Pattern` variants**, replacing the `SExpr`/`SStmt` wrappers and the **558
`.node` / 138 `.line` / 112 `.col`** access sites. Migrate behind a compat shim,
HRN-diff-test byte-identical (M3) at every step.

*Spec basis (`docs/2026_04_18_FULL_SPEC.md`):* the immutable + hash-consed,
append-only model is underwritten by the spec's **immutability-by-default**; and
the spec's design — *"the compiler itself is a queryable service via LSP/MCP… it
asks the compiler (which has the AST)"* — is precisely what this node model (with
L6) makes possible. No conflict with the language spec; L1 is a compiler-internal
representation, expressible in current Avra (the tracer proved it compiles).

### 14.1 Per-type arena store + typed-id newtypes *(ps3t.3.2)*
- One arena per level: `ExprArena`, `StmtArena`, `PatArena`. Each is an
  append-only store indexed by a **typed-id newtype** (`ExprId`/`StmtId`/`PatId`,
  newtypes over `int`) — the opaque-handle rule (§4 Layer 3) applied to nodes, so
  `ExprId`↔`StmtId` mixups are a compile error. (Newtypes already exist —
  `ValueType.Newtype`, typeck-distinct — so this needs no new language feature.)
- Nodes lose their boxed children: `Binary(left: Expr, op, right: Expr)` becomes
  `Binary(left: ExprId, op, right: ExprId)`. Recursion + cross-type refs are
  **typed ids into an arena**, never owned sub-nodes. Lists become `List<ExprId>`.
- **Array-of-nodes now; SoA-per-field later** (§10.E) — a transparent
  optimization, the id stays an index (the tracer used SoA columns to prove the
  layout). Accessor `arena.get(id) -> node` is the one ergonomic tax we pay.
  Compact (e.g. `u32`) id packing is a further storage optimization for *after*
  sized ints land — the spec permits `u32`, today's value model is `int`/i64.

### 14.2 Byte-offset span side-table *(ps3t.3.3 — folds `703y.1`)*
- Spans move **off the node** into a dense side-table keyed by id: parallel
  `span_lo`/`span_hi` byte-offset arrays (every node has a span). `line`/`col` are
  computed on demand from a per-file line-start index, **only when printing a
  diagnostic** — retiring the 138 `.line` / 112 `.col` reads behind `span(id)` +
  `to_linecol`. This *is* `703y.1` (uniform spans), now via the side-table rather
  than a fat wrapper.

### 14.3 Side-table infrastructure — dense vs sparse *(ps3t.3.6)*
- Generic, id-keyed: `DenseTable<Id,V>` (array — facts most nodes have: span,
  resolved type) and `SparseTable<Id,V>` (map — sparse facts: provenance,
  name-resolution overrides). Analysis passes **write facts here**, never mutate
  the node (the immutable-pass model, §4 Layer 6). `SExpr.ty` becomes a
  `DenseTable<ExprId, ValueType>` owned by typeck; `SStmt.from_macro` →
  `SparseTable<StmtId, Provenance>`.

### 14.4 Hash-consing — intern whole nodes by content *(ps3t.3.5)*
- `arena.alloc(node)` interns by content: a `content→id` map returns the existing
  id for identical content (shared subtree). **Content = variant + literal
  payloads + child ids** (the tracer's structural fingerprint; the §4 Layer 3
  hashing scheme) — **excludes spans/provenance/analysis** (all side-table, keyed
  by id), so reformatting or re-spanning never busts sharing. Buys O(1)
  structural equality (compare ids) + automatic incremental (changed subtree → new
  id; unchanged → same id) — the substrate L6 consumes. Immutable: transforms
  append new nodes sharing unchanged children.

### 14.5 Error/missing node variants + error-tolerant parse *(ps3t.3.4)*
- Add explicit `Expr.Error`/`Stmt.Error` (+ `Missing` for required-but-absent
  slots). On a syntax error the parser emits an error-node + diagnostic and
  **resyncs** (panic-mode at the grammar-DSL `@recover` points, §4 Layer 4)
  instead of bailing — a **partial tree + all errors at once**, required for the
  daemon/LSP/LLM story (a tree even for broken code). The error node's diagnostic
  + bad-span live in side-tables.

### 14.6 Compat-shim migration order *(ps3t.3.7 — staged, never broken §10.A)*
The keystone refactor touches every pass; migrate incrementally so the tree
always builds and HRN stays byte-identical:
1. Land arena + typed ids + side-table infra (`.3.2`, `.3.3`, `.3.6`) **alongside**
   `SExpr`/`SStmt`; a shim converts at pass boundaries — zero behavior change.
2. Migrate passes one at a time (parse → resolve → typeck → desugar → mono →
   codegen) onto the arena + side-tables; the shim bridges the un-migrated rest.
3. Add error-nodes (`.3.4`) once the parser is on the arena.
4. Add hash-consing (`.3.5`) once allocation is centralized in `alloc`.
5. Delete `SExpr`/`SStmt` + the shim when the last pass is migrated.

Each step gated by **M3** (diff-test + selfhost byte-identical) and **M2** (cold
build ≤ 1.0×). Foundation tickets (`.3.2`/`.3.3`/`.3.6`) are not seed-gated
(internal refactor, §10.A); they land first, then the pass migration, then
`.3.4`/`.3.5`, then shim deletion.
