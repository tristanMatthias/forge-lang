# L4 — Derive Framework + Grammar-DSL Parser — Design

**Status:** design (2026-07-15) · ticket `ps3t.6.1`
**Epic:** `ps3t.6` — `[L4] Derive framework + grammar-DSL parser`
**Spine:** `docs/2026_06_14_AST_SOURCE_OF_TRUTH_EPIC.md` (Layer 4, §10.D)
**Proof slice:** `docs/2026_06_14_GRAMMAR_DSL.md`

This is the Definition-of-Ready design for the L4 epic. It decomposes the two
halves of L4 — the **unified derive engine** and the **grammar-DSL parser** —
into the concrete impl tickets `ps3t.6.2`–`.7`, specifying the module layout,
data types, algorithms, pipeline slot, and test strategy for each so every
downstream ticket has an explicit, agent-sized contract.

---

## 0. What exists today (the starting point)

Two independent, hand-rolled "derive" mechanisms already ship, plus a
hand-written recursive-descent parser:

- **`features/walker/derive.av`** (~1230 lines) — a 2-arg `@comptime` macro
  `derive_walker(target: AnnotatedDecl, ctx)` that reads an `EnumDecl` and emits
  `Type__children / __map / __visit / __any / __find / __all_children_spanned`.
  It carries a mature **field classifier** (`FieldKind`: `Scalar`, `DirectSelf`,
  `ListOfSelf`, `WrapperListOfSelf(w)`, `OptionalDirectSelf`, `WrapperOfSelf`,
  `OptionalWrapperOfSelf`, `StructListOfSelf(s)`) plus a **cross-type** classifier
  (`classify_field_crosstype`) used by `all_children_spanned`. Dogfooded on
  `Pattern`, `ValueType`, `Stmt`, `Expr` (`@expand(derive_walker)` in
  `core/ast.av`).
- **`features/marshal/derive.av`** (~870 lines) — a `List<StmtId>` pass
  `derive_marshal` that reads `@marshal type T { ... }` structs and synthesises
  an `impl T { to_bytes; from_bytes }` block. Runs pre-resolve in the pipeline
  (`build/compile.av`).
- **`parse/mod.av`** (~2916 lines) + **`parse/lexer.av`** (~850 lines) — the
  hand-written lexer + recursive-descent parser producing the `Expr`/`Stmt`/…
  arena nodes.

Two more generator-shaped dispatchers exist as codec debt (`s80z` epic):
`construct_stmt`/`construct_expr` (encoder, `quote_expr/lower.av`) and
`enum_value_to_stmt`/`enum_value_to_expr`/`enum_value_to_value_type` (decoder,
`comptime/eval.av`) — two ~400-line hand-written dispatchers that must mirror
each other. (Per the 2026-06-15 plan reconcile, L2's JIT is what ultimately
deletes these — see §7 — not `@codec` replacing them; `@codec` survives for
disk/cache serialization and is a client of the same engine.)

**The L4 thesis:** all four generators (walk / codec / render / dispatch) are the
*same* traversal over the *same* enum/struct decls with different per-field
emit rules. Build the traversal + classifier **once**; make the emit rules
**pluggable**. And the parser is itself derivable: a small EBNF grammar DSL
lowers mechanically to the recursive-descent functions we hand-write today.

---

## 1. Part A — The unified derive engine (`ps3t.6.2`)

### 1.1 Goal

One engine reads an enum **or** struct decl, classifies every field once, and
drives **pluggable emitters** that produce per-variant / per-field code. Reimplement
`derive_walker` (and, as a client, `@codec`) on top of it with **no duplicated
generator logic**. Acceptance (`ps3t.6.2`): "One engine reads an enum/struct decl,
classifies fields, emits per-variant code via pluggable emitters
(walk/codec/render/dispatch); derive_walker + @codec reimplemented on it; no
duplicated generator logic."

### 1.2 Module layout

```text
features/derive/
  mod.av          — public entry: derive_engine(decl, plan) -> ResolvedDecls
  classify.av     — the field classifier (generalized FieldKind + FieldShape)
  shape.av        — DeclView / VariantView / FieldView — a decl reader normalizing
                    enum variants AND struct fields to one shape
  emit.av         — the Emitter interface + the traversal driver that walks
                    (variant, field, FieldShape) and calls emitter hooks
  emitters/
    walk.av       — children/map/visit/any/find/fold (derive_walker, re-homed)
    codec.av      — encode/decode (the @codec client; disk/cache serialization)
    render.av     — render_* (the `render_expr`/`render_stmt` catamorphism)
    eq.av         — structural equality (a small proof that a 3rd emitter is cheap)
  tests/*.av
```

`walker/derive.av` becomes a thin shim: `derive_walker` reads the enum and calls
`derive_engine(view, walk_plan())`. The mature classification currently inside
`walker/derive.av` **moves down** into `classify.av` unchanged in behaviour
(diff-test byte-identical), and grows a struct-field arm.

### 1.3 The classifier — one `FieldShape`, structural not Self-relative

Today's `FieldKind` is *Self-relative* (classifies a field only against the
parent enum's own name — everything else is `Scalar`). A general engine needs a
**structural** classification that a per-emitter *policy* then interprets:

```avra
enum FieldShape {
    Leaf(ty: ValueType)                       // scalar: int/bool/string/… — no recursion
    Node(target: string)                      // a direct AST-node ref (Expr, Stmt, …)
    NodeList(target: string)                  // List<Node>
    Optional(inner: FieldShape)               // T?  (wraps any of the below)
    Wrapper(target: string, hop: string)      // 1-hop wrapper (SExpr → .node)
    WrapperList(target: string, hop: string)  // List<SExpr> → each .node
    StructField(struct: string)               // field is a struct carrying nodes
    StructList(struct: string)                // List<MatchArm> etc.
}
```

- **Self-ness is a policy, not a shape.** `derive_walker`'s "is this field a
  child?" is `shape.target == parent_name`. The engine reports the *target type*;
  the walk emitter keeps only same-type targets (preserving today's homogeneous
  behaviour and byte-identical output), while a future cross-type emitter (the
  `y9y4.18` heterogeneous visitor) keeps all of them. This is exactly the
  `classify_field_kind` vs `classify_field_crosstype` split, unified.
- The wrapper/`hop` table (`SExpr→node`, `FieldInit→value.node`,
  `MatchArm→body`, …) moves verbatim from the walker into `classify.av` as the
  single source; both the walk emitter and the render emitter read it.

### 1.4 The emitter interface

An emitter is a record of pure builder hooks. The **driver** owns the traversal
(iterate decl → variants → fields, classify each, thread accumulators); the
emitter owns *what code each classified position produces*.

```avra
type Emitter = {
    name: string,
    // one method signature the engine emits per decl (e.g. "children")
    methods: List<EmitMethod>,
}
type EmitMethod = {
    method_name: string,                       // "children", "map", "encode", …
    ret: ValueType,
    // per-variant arm body from the classified fields
    arm: (VariantView, List<Classified>) -> ExprId,
    // structs: per-decl body from classified fields (no variant dispatch)
    struct_body: (List<Classified>) -> ExprId,
}
```

`Classified = { field: FieldView, shape: FieldShape, binding: string }`.
The driver builds the `match self { … }` (enum) or straight-line body (struct),
registers the mangled `Type__method` DeclSymbols + `MacroProvenance`, and returns
`ResolvedDecls` — reusing the existing `walker/derive.av` splice plumbing so the
resolver/typeck integration is unchanged.

The walk plan is six `EmitMethod`s whose `arm` closures are today's
`build_children_arms` / `build_map_arms` bodies, verbatim. This is the **proof
that the abstraction is real**: derive_walker's output is byte-identical
(diff-test gate), but the traversal + classification is now shared code a second
emitter reuses for free.

### 1.5 Deliverable + acceptance (`ps3t.6.2`)

- `features/derive/` engine with classifier + emitter driver.
- `derive_walker` reimplemented as a walk-emitter client; **diff-test
  byte-identical** on the selfhost + corpus (the six AST enums are dogfooded, so
  the selfhost pass exercises it fully).
- A **second emitter** (`eq` — structural equality on a test enum) proving the
  interface carries a distinct generator with zero new traversal code.
- `@codec` (encode/decode for disk/cache) is filed as the `s80z`-family client
  (`sl6c`/`epkx`) built on the same engine; the engine lands here, the codec
  emitter + dogfood land under `s80z` after the seed advances.
- Tests: `features/derive/tests/*` — classifier unit tests per `FieldShape`,
  engine emits-correct-arms tests, and the walk/eq emitter behaviour tests.

**As-built (the ps3t.6.2 PR):** the landed engine follows this section with
these deviations:
- **Flat module layout** — `features/derive/{shape,classify,emit,walk,eq}.av`
  instead of an `emitters/` subdir (no feature uses nested source dirs; the
  emitter files sit beside the engine).
- **`FieldShape` is flat**, not `Optional(inner)`-nested: the optional forms
  are their own variants (`OptionalNode` / `OptionalWrapper`), matching the
  walker's proven classification set exactly and keeping unrepresentable
  combinations (`Optional(Leaf)`, `Optional(Optional(…))`) out of the type.
- **The emitter interface** splits methods into `PerVariant` (per-variant
  match arms via `signature`/`bind`/`arm_body` hooks) and `WholeFn` (the
  recursive visit/any/find, whose fixed bodies never iterate variants) —
  §1.4's single `EmitMethod` sketch didn't distinguish them. Hooks receive a
  `DeclCtx { parent, is_struct }` instead of a `VariantView`.
- **Struct support** works by projection: the driver emits
  `let <binding> = self.<field>` lets and runs the SAME `arm_body` hook
  straight-line, so an emitter gains struct coverage without a separate
  `struct_body` hook.
- **Generic decls failsafe** (untouched decl, no methods): derives don't
  parameterize their emitted methods yet.
- **Seed gating:** hook invocations go through locals
  (`let hook = m.bind; hook(…)`) until the seed train passes this PR's UAP
  fn-field return-typing fix — tracked as `ps3t.6.8`.
- The **render emitter** (the `render_expr`/`render_stmt` catamorphism from
  §1.2's sketch) was not part of the `ps3t.6.2` acceptance and lands with a
  later client, exactly like `@codec` (`s80z`).

---

## 2. Part B — The grammar DSL (`ps3t.6.3`–`.5`, `.7`)

Per `GRAMMAR_DSL.md`: a ~9-construct EBNF notation (Crafting Interpreters Ch5
metasyntax + captures + build + `@expect`/`@recover`) lowered mechanically to an
error-tolerant recursive-descent parser (Ch6 correspondence).

### 2.1 The grammar-AST (shared by seed parser + generator)

```avra
type Grammar = { name: string, rules: List<Rule> }
type Rule    = { name: string, body: Alt }
enum Node {                        // the grammar body tree
    Alt(branches: List<Seq>)                    // a | b | c
    // Seq is a struct, not a Node, so build/annot attach at seq granularity
}
type Seq   = { items: List<Labeled>, build: Build?, annots: List<Annot> }
type Labeled = { label: string, item: Postfix }   // label "" == uncaptured
enum Postfix { One(Prim), Star(Prim), Plus(Prim), Opt(Prim) }
enum Prim { Ref(name: string), Lit(text: string), Named(tok: string), Group(Alt) }
enum Build { None, Ctor(name: string, args: List<string>), Helper(name, args), Passthru }
enum Annot { Expect(tok: string, msg: string), Recover(sync_to: string) }
```

This lives in `features/grammar/ast.av` — the contract between `.3` (parser
produces it) and `.4` (generator consumes it).

**As-built (this PR):** the landed types use the `G`-prefixed names
(`GNode`/`GSeq`/`GItem`/`GPrim`/`GRep`/`GBuild`/`GAnnot`), repetition is a
separate `GRep` field on `GItem` (not `Postfix` variants), `GBuild` is
`None | Var(name) | Call(name, args)` (the `Call` covers both ctors and helpers;
pass-through is `None`/`Var`), and — beyond this sketch — `GPrim` carries a
**`Hand(fn_name)`** variant for the `@hand(fn)` escape-hatch (`ps3t.6.7`). See
`features/grammar/ast.av` for the authoritative definitions.

### 2.2 `ps3t.6.3` — the seed parser (~200-line hand-written RD)

A small, stable, hand-written recursive-descent parser for the **grammar-of-
grammars** (`GRAMMAR_DSL.md §6`). The landed parser also accepts the
`grammar Name { … }` **wrapper** around the rules (required-to-close, rejects
empty/trailing) and a `@hand(fn)` primary:

```text
grammar  = "grammar" NAME "{" rule+ "}"
rule     = NAME "=" alt
alt      = seq ( "|" seq )*
seq      = labeled+ ( "->" build | annot )*
labeled  = ( NAME ":" )? postfix
postfix  = primary ( "*" | "+" | "?" )?
primary  = NAME | STRING | "(" alt ")" | "@hand" "(" NAME ")"
annot    = "@expect" "(" STRING "," STRING ")" | "@recover" "(" "sync_to" ":" STRING ")"
```

- **Input:** grammar text as a `string` (read from a `quote`/string literal in
  the test, or from a `.grammar` file). Building it against a *string* means
  **no new Avra surface syntax** — so `ps3t.6.3` + `.4` build and test on-branch
  with **no seed cycle** (bootstrap-window clean). The `grammar Foo { … }` block
  *as Avra surface syntax* is a later concern, folded into `.5`/`.6`.
- **Tokeniser:** a tiny purpose-built scanner over the DSL's ~12 token kinds
  (`NAME`, `STRING`, `=`, `|`, `(`, `)`, `*`, `+`, `?`, `->`, `:`, `@`). It does
  **not** reuse Avra's lexer — the grammar-of-grammars is deliberately its own
  fixed micro-language (yacc-has-a-parser-for-yacc; it never churns).
- **Output:** a `Grammar` value (§2.1).
- **Deliverable:** `features/grammar/seed_parser.av` + tests parsing the §2 Avra
  expression grammar into the expected `Grammar` AST. Acceptance (`.3`): reads
  rules/seq/alt/group/`*+?`/captures/build/`@expect`/`@recover`; bounded + stable;
  tested on the expression grammar.

### 2.3 `ps3t.6.4` — the generator (grammar-AST → RD parser fns)

Lowers a `Grammar` to a `List<Stmt>` of parser functions, one per rule, by
Nystrom's correspondence (`GRAMMAR_DSL.md §4`, §7):

| Grammar construct | Emitted RD code |
|---|---|
| rule `name = …` | `fn parse_name(p: Parser) -> RetTy { … }` |
| nonterminal ref `foo` | `parse_foo(p)` |
| terminal `"+"` / `NUMBER` | `p.match("+")` / `p.match(NUMBER)` |
| `a b c` (seq) | statements in order, captures → `let` bindings |
| `a \| b` (alt) | `if p.match(first_of(a)) { … } else …` |
| `( … )*` | `while p.match(first_of(…)) { … }` |
| `( … )+` | do-while shape |
| `( … )?` | `if p.match(first_of(…)) { … }` |
| capture `x:foo` | `let x = parse_foo(p)` (list-accumulate inside `*`) |
| build `-> Ctor(a,b)` | `p.node(RetEnum.Ctor(a, b))` |
| build `-> helper(...)` | fixed helper set: `fold_binary`, `collect` |
| no `->` | pass-through of the single sub-result |
| `@expect(tok,msg)` | `p.expect(tok, msg, recover_to: …)` |
| `@recover(sync_to)` | panic-mode `synchronize()` target |

- The generator **emits Avra AST** (`Stmt.Function` nodes into the NodeStore),
  the same medium the derive engine emits — so the same splice/resolve/typeck
  path validates it. It does **not** emit source text.
- **Error tolerance** (Layer-1 requirement): unmatched required positions call
  `p.error_node(msg)` and `@recover` lowers to `synchronize()`, yielding a
  partial tree + diagnostics rather than a hard bail.
- **Deliverable:** `features/grammar/generator.av` + tests: generate the
  expression parser fns, run them over real token streams, assert the produced
  `Expr` AST matches the hand-written parser's, and assert partial-tree recovery
  on malformed input (`(1 +`). Acceptance (`.4`): correct AST + partial-tree
  recovery on the expression slice; `@recover` → panic-mode synchronize.

### 2.4 `ps3t.6.7` — lexer modes + the escape-hatch (the gnarly 5%)

The four context-sensitive constructs stay **out** of the grammar notation
(`GRAMMAR_DSL.md §5`), keeping the DSL at ~9 constructs:

| Construct | Mechanism | Where |
|---|---|---|
| `"…{expr}…"` interpolation | **lexer mode** — enter/exit an interp sub-mode on `{`/`}` inside a string, emitting `STR_CHUNK`/`INTERP_START`/`INTERP_END` | `parse/lexer.av` |
| newline-sensitivity (no `;`) | **lexer** emits `NEWLINE`; a mode flag suppresses it inside `(`/`[`/`<` bracket depth | `parse/lexer.av` |
| `~` splice vs bitnot | **lexer/escape-hatch** — context flag set by `quote {` | lexer + hand rule |
| `<T>` generic vs `<` less-than | **escape-hatch rule** — a hand-written disambiguation rule the grammar *calls* by name (`@hand(parse_generic_args)`) | `parse/` hand rule |

- The DSL grows **one** construct to reach hand-written rules: `@hand(fn_name)`
  — a grammar rule body that is a call to a hand-written escape-hatch function.
  This is the yacc `%{ … %}` equivalent, scoped to whole-rule granularity (no
  inline semantic actions — the `GRAMMAR_DSL.md §1` hard line holds).
- The lexer already carries most of this (interpolation, newline handling);
  `.7` **formalises** it as explicit named modes with a mode stack, so the
  grammar can assume a clean token stream.
- **Deliverable:** lexer-mode formalisation + tests (interp nesting, newline
  suppression inside brackets), the `@hand` escape-hatch construct in the seed
  parser + generator, and the two disambiguation rules (`~`, `<`). Acceptance
  (`.7`): interp + newline via lexer modes; `~` + `<` via hand-written
  escape-hatch; DSL stays minimal.

### 2.5 `ps3t.6.5` — migrate Avra's parser to the DSL

The large integration step. Express Avra's full grammar in the DSL, generate the
parser, and replace the hand-written one behind the **HRN differential test**:

- **Strategy:** rule-family by rule-family (expressions first — the proof slice,
  then patterns, types, statements, declarations), each family diff-tested
  (same AST + same errors) before the next. The generated fns replace the
  hand-written ones incrementally; the gnarly 5% stays in the lexer/escape-hatch.
- **Seed-gating:** the `grammar { … }` surface syntax in compiler `src/` is
  seed-gated (§10.A) — land the generator + a `grammar`-block parser, cycle the
  seed, *then* dogfood the Avra grammar into `src/`. Until then the grammar can
  live as a data table / string the generator consumes.
- Acceptance (`.5`): full grammar in the DSL (gnarly 5% in lexer/escape-hatch);
  generated parser replaces hand-written; diff-test same AST + errors; selfhost
  green. **This is a multi-stage ticket** — tracked with per-family sub-progress.

---

## 3. Part C — `@derive`/`@query` surface + pipeline (`ps3t.6.6`)

### 3.1 Surface

`@derive(Walk, Codec, Render, Eq, Json, …)` on any enum/struct (compiler AST
*and* user types) selects one-or-more emitters from a **registry** keyed by
capability name. `@query fn …` marks a pass as a memoized query (the ergonomic
layer over the L6 engine — hand-wrapped until L6, §10.B). `@derive` supersedes
the per-macro `@expand(derive_walker)` / `@marshal` annotations, which become
`@derive(Walk)` / `@derive(Marshal)` aliases (kept working through a shim).

### 3.2 Pipeline slot (§10.D — decided)

- Runs **post-resolve, pre-typecheck** (Rust proc-macro timing, today's
  `@expand` slot in `build/compile.av`).
- **Via the JIT** (L2 / `ps3t.5`), with the tree-walking interpreter as the
  bootstrap fallback — which is exactly how `derive_walker` runs today, so L4's
  surface works before L2's JIT lands and gets faster when it does.
- Generated AST is **re-resolved + type-checked** — never trusted.
- Expansion is a **memoized query run to a bounded, cycle-detected fixpoint**: a
  derive that (transitively) emits itself is an **error**, not a hang. The bound
  + cycle set is the deliverable's teeth.

### 3.3 Deliverable + acceptance (`ps3t.6.6`)

- `@derive(...)` / `@query` parsing + a capability registry (emitter name →
  engine plan) in `features/derive/`.
- Pipeline integration: one `derive_program` pass replacing the separate
  `derive_marshal` + `@expand(derive_walker)` splice points, driven by the
  bounded fixpoint driver with cycle detection.
- Re-resolve + re-typecheck of generated decls (already the `@expand` contract).
- Tests: `@derive` on a user struct + a user enum; the self-emitting-derive
  cycle error; memoization (same decl expanded once); AST + user-type parity.
- Acceptance (`.6`): `@derive/@query` on AST + user types; post-resolve/pre-
  typecheck via JIT; generated code re-resolved+typechecked; memoized bounded/
  cycle-detected fixpoint.

---

## 4. Sequencing + bootstrap-window discipline

```text
6.1 design (this doc) ─┬─▶ 6.2 derive engine ──────────────▶ 6.6 @derive surface + pipeline
                       ├─▶ 6.3 seed parser ─▶ 6.4 generator ─┬─▶ 6.7 lexer modes/escape-hatch
                       │                                     └─▶ 6.5 migrate parser
                       └─▶ (s80z/@codec client rides on 6.2's engine post-seed)
```

- `6.2`, `6.3`, `6.4` build + test **on-branch with no seed cycle** — they add
  new modules using existing syntax and read grammars from strings, not new
  surface syntax. This keeps the bootstrap window (`sdmg.2`) clean.
- The **seed-gated** work is the *dogfood* steps: `@derive(...)` replacing
  `@expand(derive_walker)` in `core/ast.av` (`6.6`), the `grammar { … }` block +
  Avra-grammar migration in `src/` (`6.5`), and the `@codec` dogfood (`s80z`
  `x7be`). Order for each: land feature + tests → cycle seed → dogfood.
- Every step is HRN diff-tested (byte-identical IR) + selfhost fixed-point.

## 5. Non-goals (this epic)

- The L6 query **engine** (red-green invalidation, incremental) is `ps3t.8` —
  `@query` here is only the surface + hand-wrapped memo, per §10.B.
- Deleting `construct_stmt`/`enum_value_to_stmt` is **driven by L2's JIT**
  (`ps3t.5` + `jw6v`), not by this epic — `@codec` covers disk/cache only (§7 of
  the spine, and the `s80z` plan-reconcile notes).
- `1n1v` MIR is out of spine.
