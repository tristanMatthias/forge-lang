# The Compiler as Components — every language feature is a `feature { }`

**Status:** design / exploration (2026-07-17)
**Horizon:** post-ps3t (this design *consumes* L1–L6; nothing here starts before
the layers it names have landed)
**Builds on:** spec Axis 26.1 (component-based registration + query-based
execution — the decision already made), `docs/spec_modular_compiler.md` (the
2025 Rust-era draft of this same idea — superseded here), Components V2
(`docs/2026_05_08_COMPONENTS_V2_DESIGN.md`), the L4 grammar DSL
(`docs/2026_06_14_GRAMMAR_DSL.md`, `ps3t.6`), the embedded-sublanguage note
(`docs/2026_07_16_GRAMMAR_DSL_AND_EMBEDDED_SUBLANGUAGES.md`), and the live
registry (`src/core/registry.av`).

---

## 0. TL;DR

Every language feature becomes **one declarative `feature { }` component** —
tokens, grammar, AST nodes, type rules, lowering, diagnostics, docs, and tests
in a single file — expanded at comptime by the same Components V2 machinery
users get. The compiler is the component system's first and biggest customer.

The punchline nobody should miss: **this construct is the same one that ships
embedded sublanguages.** `@std.sql`'s `sql { }` and the compiler's own
`match_expr` feature are instances of one mechanism. Building it for ourselves
builds it for every package author — bet #1 of the ps3t spine ("one system
serves compiler writers *and* users"), applied to the whole compiler.

And the honest scoping: this is **not** a new architecture, it's the *last
mile* of three existing ones. The registry already dispatches per-feature by
tag; ps3t L4 already derives parsers from grammars and walkers from node
schemas; L6 already makes every pass a keyed query. The `feature { }` component
is the declarative surface that generates what today is hand-wired — and its
migration is diff-test-gated byte-identical, like everything else.

---

## 1. Where we are (so the delta is visible)

Today a feature is a *directory convention* plus *manual wiring*:

- ~43 feature dirs in `src/features/`, each with hand-written `parser.av`,
  `codegen.av`, `tests/*_test.av`.
- A value-level `Feature` struct (`core/registry.av`) holding ~14 fn-pointer
  slots (parse_decl/stmt/expr, resolve_*, check_*, eval_*, emit_*), registered
  in `init_features` by constructing the struct and passing **sentinel dummy
  enum values** so the registry can derive dispatch tags.
- The AST variants live centrally in `core/ast.av`; the tokens centrally in
  `Tk`; the keyword map centrally in `p_keyword_kind`; F-codes centrally in
  the error system; docs in a separate `grammar.md` the checklist begs you to
  remember.

So one feature is smeared across **seven places**, and CLAUDE.md's Phase-3
checklist (AST → lexer → scanner → parser → codegen → resolver → typeck →
registry → renderer) exists precisely because the smear is manual. The 2025
`spec_modular_compiler.md` diagnosed this exactly and proposed `dyn Any`
tagged nodes — right goal, pre-self-hosting tools. Post-ps3t we have strictly
better primitives, so this doc supersedes its mechanism while keeping its goal
and its core/feature boundary table.

What ps3t hands us, layer by layer:

| ps3t layer | What the component design consumes |
|---|---|
| L1 node model | Nodes are arena rows behind interned kind-ids + field schemas — an **open** node space, no closed Rust-style enum to edit |
| L2 comptime JIT | `feature { }` expansion runs compiled, sandboxed, memoized — the interpreter's eval_* hooks **disappear from the Feature surface entirely** |
| L3 typed identity | A node kind's id is content-addressed from (feature, name, field schema) — registration IS declaration, sentinel values die |
| L4 derive + grammar DSL | Parsers derived from `grammar { }` rules; walkers/render/codec/Eq auto-extend to feature-declared nodes |
| L5 no-drift | "every registered kind has every required handler" — exhaustiveness becomes **registry completeness**, checked at comptime |
| L6 query engine | `check`/`lower` blocks lower to query handlers keyed by node kind; memoization + incrementality for free |

---

## 2. The target: one feature, one file

Before/after for a small real feature. Today `null_safety`'s `??` operator
touches `ast.av` (variant), `Tk` (token), parser (precedence + parse fn),
typeck arm, codegen file, registry line, `grammar.md`. The target:

```avra
// src/features/null_coalesce/feature.av — the ENTIRE feature
feature null_coalesce {
  status stable
  requires null_safety            // dependency, comptime-checked, feeds `avra features --graph`

  /// `a ?? b` — evaluate `b` only when `a` is null.
  /// (This doc comment IS the docs page and the generated grammar.md entry.)

  tokens {
    "??" -> QQ
  }

  nodes {
    Expr.Coalesce { lhs: ExprId, rhs: ExprId }
    // Registered as an interned, content-addressed kind. The L4 derive
    // framework reads this schema: Walk/Render/Codec/Eq/fmt extend
    // automatically. No walker edit, no renderer edit, no codec edit.
  }

  grammar {
    // Splices into the core grammar's named extension point. Precedence
    // is declared relative to existing tiers, not as a magic number.
    expr.infix  ??  @prec(below: or_expr, above: comparison)
                -> (l, r) => Coalesce(lhs: l, rhs: r)
  }

  check Coalesce(c) -> ValueType {
    let lt = type_of(c.lhs)              // a memoized L6 query
    let rt = type_of(c.rhs)
    let inner = lt.strip_nullable()
        else error F1021(at: c.lhs)      // declared below; typed, not stringly
    unify(inner, rt)
        else error F1000(at: c.rhs, expected: inner, got: rt)
    inner
  }

  lower Coalesce(c, ctx) -> EmitValue {
    // Lowering stays HAND-WRITTEN Avra (ps3t: codegen is bespoke logic;
    // only its dispatch is derived). Same Ctx builder API as today.
    let l = ctx.emit(c.lhs)
    let is_null = ctx.icmp_eq(ctx.tag_of(l), ctx.null_tag())
    ctx.if_value(is_null,
      then: () -> ctx.emit(c.rhs),
      else: () -> ctx.unwrap_nullable(l))
  }

  errors {
    F1021 "left side of `??` is not nullable" {
      note "`{lhs_type}` can never be null, so the right side is unreachable"
      help "remove the `??`, or make the left side `{lhs_type}?`"
    }
  }

  spec "coalesce picks fallback on null" {
    given { let x: int? = null }
    then  { (x ?? 5) == 5 }
  }
  spec "coalesce keeps value when present" {
    given { let x: int? = 3 }
    then  { (x ?? 5) == 3 }
  }
}
```

What the `@expand` macro generates from this (all of it inspectable via
`bs2 expand`, per Components V2's visibility principle): the token
registration, the node-kind interning + field schema (which the derive
framework consumes), a derived recursive-descent parse fn spliced into the
expression Pratt loop at the declared tier, a `type_of` query handler keyed on
the `Coalesce` kind, a lowering dispatch entry, the F1021 registration with
its render template (feeding `avra explain F1021`), the spec/given/then test
units, the `avra features` metadata row, and the docs entry. **Nine places,
one declaration.** Deleting the file deletes the feature — nothing dangles,
because nothing else ever mentioned it.

### Ergonomic details that make it *really* ergonomic

1. **Registration is declaration.** No `init_features` line, no sentinel
   dummy values (`register_feature(Expr.Coalesce(0,0), ...)` dies). The
   manifest globs `features/*/feature.av`; the kind-id derives from content
   (L3). Adding a feature = adding a file.
2. **Typed handler signatures.** Today's registry slots are `int` (fn pointers
   through untyped slots). `check Coalesce(c)` binds `c` as the typed node
   struct — wrong-field access is a compile error in the *compiler's own
   build*, not a runtime tag mismatch.
3. **Errors are values with templates.** F-codes declared next to the logic
   that raises them; uniqueness comptime-checked across all features; the
   `{lhs_type}` holes are typed parameters, so `avra explain` and the JSON
   diagnostic schema (ps3t.9) render from one source.
4. **Completeness instead of wildcards.** L5's rule reshaped for an open node
   space: *every registered node kind must have a handler for every required
   operation* (check, lower, render). A feature that declares a node and
   forgets `lower` fails the compiler's own build with "`null_coalesce`
   declares `Expr.Coalesce` but provides no `lower`" — the `-> {}` stub class
   and the "grep for empty arms" ritual become unrepresentable.
5. **Docs cannot drift.** `grammar.md` per feature is *generated* from the
   `grammar { }` block + doc comments. The Phase-5 checklist item deletes
   itself.
6. **The eval hooks vanish.** Post-L2 there is no interpreter, so the current
   `eval_expr`/`eval_stmt` slots don't migrate — comptime execution JIT-compiles
   through the same `lower`. The Feature surface shrinks by a third before we
   even start.
7. **LLM-native by construction.** An agent implementing a language feature
   edits exactly one file, and the completeness checker enumerates precisely
   what's missing. This is the ps3t "compiler as a tool an LLM drives" bet at
   feature granularity — the diff for "add a `unless` statement" is one
   self-contained component an agent can hold in a single context window.

---

## 3. The design decisions (the parts that need deciding, not just wanting)

### D1 — Open node space without losing exhaustiveness

The 2025 draft's central struggle (closed Rust enums → `dyn Any` tagged
nodes) evaporates post-L1: nodes are arena rows with interned kind-ids and
declared field schemas, so "adding a variant" is registering a kind — cheap,
typed, content-addressed. What must be *preserved* is what closed enums gave
us: exhaustive dispatch. Resolution:

- Core declares the node **classes** (`Expr`, `Stmt`, `Pattern`, `TypeExpr`)
  and their arena/side-table plumbing. Features declare **kinds** within a
  class.
- Every pass over a class is registered as an *operation* (check, lower,
  render, resolve-hook…). The comptime registry build verifies the
  (kind × required-operation) matrix is total — L5's exhaustiveness, lifted
  from match-statements to the registry. Missing cell = named build error.
- Cross-feature reads are allowed through the public schema (a feature may
  *inspect* another's nodes — `match_expr` looks through `Annotated`
  wrappers); cross-feature *ownership* is not: exactly one feature provides
  each required operation for a kind. Two claimants = comptime conflict error.

### D2 — Grammar composition via named extension points

The L4 grammar DSL generates a parser from rules; the composition question is
where feature rules attach. Core's grammar declares its extension points as
part of its own `grammar { }`:

- `decl.alt` — top-level declarations (`fn`, `type`, `enum`, … and every
  feature decl: `trait_decl`, `component_decl`)
- `stmt.alt` — statement openers (`defer`, `while`, `for`…)
- `expr.prefix` / `expr.infix` / `expr.postfix` — Pratt tiers; features
  declare precedence **relative to named tiers** (`@prec(below: or_expr)`),
  never numerically. The comptime build totally orders the tiers or errors on
  ambiguity (two features inserting incomparably between the same neighbors
  must state an order).
- `pattern.alt`, `type.alt` — same idea.
- Keyword claims are checked globally: two features claiming `when` is a
  build error naming both.

The **gnarly 5% stays core** (the L4 decision, restated): string
interpolation, newline sensitivity, `~` overloads, and `<` ambiguity live in
core lexer modes and `@hand(fn)` escape rules — feature grammars never grow
the notation. A feature whose syntax genuinely can't be expressed in the DSL
uses `@hand` and pays with a hand parser, exactly like today, minus the
dispatch wiring.

### D3 — Checks and lowers are query handlers (L6 native)

`check Kind(n)` lowers to a handler for the `type_of(node)` query, dispatched
by kind-id; `lower Kind(n, ctx)` to the codegen query (`ir_for`, cached
per-fn by body fingerprint). Consequences worth spelling out:

- **Memoization and incrementality are inherited**, not implemented. A
  feature author writes a pure(ish) function; the engine caches it.
- **Diagnostics ride the query result** (L6 tier-3 decision: a query's output
  is value + diagnostics) — so a feature's errors invalidate with its answers.
- The current fn-pointer indirection (`emit_expr: int` slots) is replaced by
  comptime-generated static dispatch tables — *faster* than today's registry,
  and typed.
- Resolution stays a **core** query (symbol identity is cross-cutting, §10.C
  of the spine); features contribute only local hooks (binding forms declare
  what they bind — `for` introduces its loop var — via a small declarative
  `binds` clause rather than a hand resolver function, where possible).

### D4 — What remains kernel (the never-components)

The rule stays CLAUDE.md's: core is infrastructure. Concretely the kernel is:
node classes + arenas + side tables (L1), the query engine (L6), the derive
framework + grammar executor + lexer modes (L4), the diagnostics renderer,
name resolution + module graph, the mono engine, `Ctx`/`resolve_layout`/LLVM
emission primitives + verifier gates, the seed/bootstrap machinery — **and the
component engine itself** (it cannot be a component; it's the base case).
Everything with a keyword, an operator, a node kind, or an intrinsic method
is a feature. Honest expectation from the old spec's numbers, updated: kernel
on the order of a few thousand lines, features everything else — same target,
now with the machinery to actually hold the line (a lint: no kind-specific
logic in kernel paths; the registry completeness check makes stubs loud).

### D5 — The bootstrap story (the part that keeps this honest)

The compiler's own source becomes ~45 comptime-expanded components on every
build. Three commitments make that viable, all already decided in ps3t:

1. **Comptime is JIT-compiled and memoized content-addressed** (L2): a
   feature component whose file didn't change replays its expansion from
   cache. Expansion cost is O(changed features), same as everything else
   under L6.
2. **The `feature` construct itself is one seed cycle.** The keyword + its
   expander land like any new surface syntax (Phase A/B, seed train). After
   that, migrating *individual* features is mostly **not** seed-gated — it's
   internal restructuring of the same semantics, which the pinned seed
   compiles fine. Exceptions: any feature whose migration introduces new
   surface syntax rides its own train cycle.
3. **HRN diff-test is the migration oracle.** Each feature migrates alone;
   old-vs-new must emit byte-identical IR. A migration that changes emitted
   IR is by definition not a pure migration — rejected or relabeled.

And one rule inherited from the S-program (systems doc §4): **component
expansion runs app-level, pure, sandboxed** — a feature's expander gets no
IO beyond the L2 allowlist and no `bare`. The compiler build must not be an
attack surface.

### D6 — Third-party features: the same construct, gated

The endgame the registry already hints at (`expr_keyword` = "the generic
registered `<keyword> { }` → package parser seam for embedded sublanguages"):
a *package* ships `feature sql { tokens…, grammar…, nodes…, check…, lower… }`
and `use @std.sql` makes `sql { select … }` typed surface syntax. Same
engine, two policies:

- **In-tree language features** may claim bare keywords and splice into any
  extension point (they *are* the language).
- **Package features** are namespaced by import, may claim only
  `<keyword> { }` / `<keyword>"…"` entry forms (the §12.4 brace-match
  handoff), and their nodes must lower to core IR or expand to core AST —
  no new codegen primitives. This keeps "the language" a curated set while
  making the ceiling for libraries extraordinary: SQL, HTML, regex, GPIO
  register maps, UI views — all instances of `feature { }`.

The compiler dogfooding the construct across 43 features **is** the QA
program for handing it to users. Every ergonomic paper cut we feel migrating
`match_expr` is a cut a package author won't.

---

## 4. Migration plan (each step shippable, diff-test-gated)

- **M0 — the adapter (can start the moment Components V2 + L2-JIT are
  usable, before full ps3t):** implement `feature { }` as a component whose
  expansion targets the *existing* registry — it generates exactly the
  `Feature { … }` struct + `register_feature` call that's hand-written today.
  Zero semantic change, byte-identical, proves the surface. Migrate 2–3 leaf
  features (`defer_stmt`, `is_keyword`, `with_expr`) as the pilot.
- **M1 — sweep the leaves:** migrate every feature whose parser/check/lower
  are self-contained onto the adapter. Kill `init_features` (manifest glob) and
  the sentinel-value registration. The registry's untyped `int` slots become
  typed at this point.
- **M2 — nodes move out of core** *(needs L1 landed + L3 content ids)*: the
  `nodes { }` block becomes real — `ast.av` shrinks to node classes; kinds
  live with their features; derive framework picks up schemas from the
  registry. This is the big unlock and the riskiest step; it goes variant
  cluster by cluster behind the L1 compat-shim discipline.
- **M3 — grammars replace hand parsers** *(needs ps3t.6.5 `grammar { }`
  surface + extension points)*: feature by feature, `@hand` for the genuinely
  gnarly. Parse-perf gate: cold build ≤ 1.0× (ps3t M2 metric applies).
- **M4 — checks/lowers become query handlers** *(needs L6 engine)*: mostly
  mechanical rewrap given M1's typed handlers were written query-shaped
  (pure, explicit inputs) — which M1 enforces from the start (§10.B of the
  spine, same discipline).
- **M5 — kernel diet + the gates become law:** completeness matrix as a CI
  gate, keyword/precedence conflict checks, docs generation replacing
  hand `grammar.md`s, `avra features` reading the registry. Measure kernel
  LOC; publish it.
- **M6 — open the gate to packages:** the D6 policy, `@std.sql` or
  `@hw`'s `register_map` as the first external customer (the S-program's
  t-bw95.23 wants exactly this).

Sequencing vs everything else in flight: M0/M1 are adapter-level and touch no
representation — they can overlap late-ps3t safely. M2 tracks L1's completion,
M3 tracks ps3t.6.5, M4 tracks ps3t.8. This program is deliberately the
*consumer* that arrives just behind each layer — it keeps ps3t honest the way
dogfooding always does, without gating it.

---

## 5. What we'll get attacked on (internally), answered

1. *"Comptime-expanding the whole compiler every build will be slow."* —
   Memoized, content-addressed expansion (L2/L6): unchanged feature = cache
   hit. The cold-build gate (ps3t M2, ≤1.0×) applies to every M-step; a step
   that regresses it doesn't land.
2. *"Generated parsers have worse errors."* — The L4 answer, already
   settled: generated *recursive descent* with `@expect`/`@recover` authored
   in the grammar. Error quality is a grammar-authoring surface, not a
   casualty. Features with truly bad fits use `@hand`.
3. *"Open node kinds will fragment the AST."* — The completeness matrix is
   stricter than today's wildcard-ridden matches, not looser. And kinds are
   content-addressed — tooling sees one coherent, serializable schema
   (ps3t.9's AST-as-data gets *richer*, since the schema now carries
   feature provenance).
4. *"Debugging a macro-generated compiler is hell."* — `bs2 expand` shows
   the post-expansion source (the P7/P8 visibility principle); provenance
   side-tables (L1) trace every generated node to its feature declaration;
   and the escape hatch is the same as Components V2's — hand-write what the
   component would have generated.
5. *"This is a rewrite of a rewrite."* — No: M0/M1 generate today's exact
   registry; M2–M4 each ride a ps3t layer that is landing anyway. The unique
   new engineering is the `feature` expander, extension-point grammar
   composition, and the completeness matrix — weeks-scale pieces, not the
   quarters-scale layers they sit on.

---

## 6. Open questions

1. **Intrinsics surface** — string/list built-in methods: a `intrinsics { }`
   block on features (the 2025 draft's registry) vs plain trait impls in
   `@std` now that self-hosting matured. Lean: trait impls where possible;
   the intrinsic block only for genuinely compiler-magic methods.
2. **Desugar ordering** — features that rewrite AST (pipe, list-comp,
   nested-fn→closure) need a declared phase/priority; is a total order per
   extension point enough, or do we need explicit before/after edges?
3. **`binds` clause expressiveness** — how much of the resolver's per-feature
   logic is declaratively capturable (loop vars, match-arm bindings, module
   decls) vs staying a hook fn? Audit the 43 resolve_* hooks to find out.
4. **Feature flags / editions** — `status wip` features compiled out of the
   language by default? Interaction with the seed (a seed built with a flag
   set must still compile src/). Needs its own note before M1.
5. **How far down does `feature` go?** — is `fn_decl` a feature? (Today it
   is one.) The kernel/feature line for the *structural* trio
   (fn/let/module) deserves an explicit decision rather than inertia.

---

## 7. Relationship to the other two programs

- **ps3t:** this is ps3t's consumer. It adds *zero* requirements to L1–L6 as
  designed (the extension points, completeness matrix, and expander are all
  built *on* the decided surfaces). It does add one early ask: keep the L4
  derive/grammar engines' *registration* APIs public-ish from the start —
  they'll be driven by generated code, not just hand code.
- **Systems program (t-bw95):** feature components are level-agnostic; the
  `bare`/`systems` gating (S0/S1) lands as ordinary features under this model
  eventually, and `register_map` (t-bw95.23) is the flagship D6 package
  feature. No coupling beyond that.
- **Components V2 (vez6):** this program is its biggest stress test and its
  strongest argument. Anything the compiler needs that the component surface
  can't express (typed handler blocks, extension-point splicing, comptime
  conflict checks) is a Components V2 feature request first — we never fork a
  private mechanism.
