# B-final: the rep flip — nodes hold typed ids, SExpr/SStmt die

**Ticket:** y5um.8 (parent y5um, spine §14.1/§14.6). **Status:** staged design, DECIDED.
**Predecessor:** B1 (docs/2026_07_02_B1_PARSER_BUILDS_ARENA.md, complete): the parser
builds the L1 arena natively and `parse_or_fail` serves from it. B2 (y5um.5/.6/.7):
quote-scan, resolver roots/deep-walks, typeck item-walk read the arena.

## 1. Goal

`Expr`/`Stmt`/`Pattern` variant payloads hold `ExprId`/`StmtId`/`PatId`/`TypeId`
instead of boxed children; container structs hold id fields; `SExpr`/`SStmt` are
deleted (line/col/file/from_macro live only in arena side-tables); passes read
children via `store.<arena>.get(id)`. All transitional machinery dies: the
`program_from_store` boxed-view serving, `reconstruct_program`, the
`wc_run`/`with_children` inverse-walker round-trip, `struct_list_helpers`, and
`ingest_program` (+ the parity battery it oracles, which loses its subject).

## 2. Measured surface (2026-07-03 survey)

- `SExpr`/`SStmt`: 1,375 occurrences / ~81 prod files. Heaviest: core machinery
  (169), modules resolver (89), typeck (85), quote lower (84), build metadata (75),
  comptime (71), mono (69), component_decl (66), walker derive (64), codegen (54/9
  files), resolve (51), parse (48), desugar (47), marshal (47).
- Constructor sites concentrate in metaprogramming (walker 136+37, marshal 97+34,
  quote 78, comptime 25, component_decl 55+20), parser (97+10), desugar (42+15),
  mono (31+11). Codegen/typeck are almost pure consumers (Expr. ×3/×5).
- **Boxed-only islands (zero arena reads today): desugar/mod.av, generics/mono.av,
  all of codegen/.** Core + native parsers are already id-native; resolve and
  quote each have one arena touch-point.
- Containers: `TypeParamEntry` has **no node fields — excluded from the flip**.
  Localized: `CompConfig` (component_decl+core), `SelectArm`, `WhenArm`,
  `Annotation`. Wide: `FieldInit`, `MatchArm`, `ParamEntry` (~30 buckets,
  including all of typeck/codegen/closures — the largest blast radius).
- Deletion gates: `ingest_program` + `wc_roundtrip_*` are test-only already;
  `program_from_store` (main.av) serves the production boxed view until passes
  take ids; `wc_run`/`with_children`/`struct_list_helpers` are derive-emitted
  runtime machinery that falls out when children are id-typed. (Two
  `with_children` local-variable false positives: component_decl/expand.av,
  comptime/rewrite.av.)

## 3. Design decisions (primary-designer calls)

1. **Store-threading precedes everything (F0).** Every transform/consumer pass
   signature (desugar, component expand, marshal derive, hygiene, mono, typeck,
   codegen, eval, build metadata) gains the `NodeStore`. No behavior change —
   byte-identical trivially. This is the single enabling move: container and
   variant flips only need local edits afterwards.
   **F0 also establishes the single-store invariant**: the compile pipeline
   MERGES trees parsed by other parsers (module-file resolution, sibling-file
   loading, test-runner reparse) — today those sub-parses build their own
   stores, which is why `lower_quotes_via_store` keeps a boxed fallback for
   `--module_path`. F0 threads the ENTRY store into every sub-parse (exactly
   as B1's template sub-parsers already share the outer store, Decision 3),
   so one store covers the whole merged program. Corollary: the boxed
   quote-scan fallback dissolves; a store scan is valid unconditionally.
   Arena ids are per-store indices, so store MERGING (id rebasing) is
   rejected — sharing one store from the start is the only sound shape.
2. **Transforms become allocators via the parser's own helpers.** When a flipped
   field forces a synthesis site (desugar/mono/quote/comptime/walker/marshal) to
   produce an id, it allocates through shared `core/arena.av` alloc helpers (the
   parser's `alloc_*` family generalized onto `NodeStore`) — never per-pass
   duplicates (ABSOLUTE rule 8).
3. **Containers flip before variants**, localized → wide: the mechanics get
   exercised on small blast radii, and each container flip retires a
   walker-opaque edge-model debt from B1. Order: CompConfig+SelectArm+WhenArm+
   Annotation → FieldInit → MatchArm → ParamEntry.
   **F1 ships DUAL fields (the B1 `wrapped`+`ids` pattern), not a hard flip:**
   a hard field-type change would force store-threading through every
   store-less consumer at once — `render_*`, the derive-generated walkers,
   eval — exactly the big-bang the staging exists to avoid. Instead each F1
   stage ADDS the id field(s) beside the boxed ones; parsers populate them
   natively (ids are already in hand); a parity spec pins id ⇔ boxed
   agreement via `store.get`; consumers stay on the boxed halves (dark,
   byte-identical trivially) and migrate read-by-read afterwards. The boxed
   halves die at F4 with the wrappers — the duals are staging scaffolding
   with a scheduled demolition, not a second source of truth left standing.
   **Dual id fields are NULLABLE**: null = "no arena row yet" — a transform
   rebuilt the container and its pass hasn't migrated to allocating; readers
   fall back to the boxed half. The parser always populates real ids.
   (Discovered en route: struct literals with missing fields silently
   zero-fill — spec violation, filed + gate implemented as F1005 on
   claude/typeck-missing-fields; its cleanup train runs beside the F stages
   and, once enforced, makes every transform site declare its nulls
   explicitly.)
4. **Variant payloads flip by kind, smallest first: Pattern → Stmt → Expr.**
   Pattern is the pilot (~33 constructor sites). Within one kind, all
   construct/match sites flip together — the type checker enumerates the
   worklist as F1000s, which is exactly the no-drift property the epic wants.
5. **Mono re-allocates what it rewrites, shares what it doesn't.** Ids make the
   tree a DAG; monomorphization allocates new rows only for nodes it changes.
   (The arena already carries one deliberate DAG edge — if_stmt cond reuse.)
   Hash-consing (ps3t.3.5) later turns this sharing into systematic dedup.
6. **Not seed-gated, confirmed per phase.** Field-type changes and threading
   params introduce no new surface syntax, so the pinned seed parses every
   phase's source (parent-design expectation; the bootstrap-window gate proves
   it empirically on every push — any surprise fails gate 2, not the train).
7. **Spans/provenance:** wrappers die only at F4, after every consumer reads
   line/col via `stmt_linecol`/side-tables. Until then mixed rep is normal:
   a boxed node can hold id-children and vice versa — the store is always
   present (F0), so `get(id)` is available everywhere.

## 4. Stages (each M3-gated: diff-test byte-identical + full suite + fixed point)

- **F0 (y5um.8.1)** — thread `NodeStore` through all passes; add the shared
  transform-alloc helpers to core/arena.av. Zero behavior change.
  **DONE** — the single-store invariant is live (module/package/sibling and
  test-runner sub-parses allocate into the entry or bundle store via
  `parse_program_source_shared`; the boxed quote-scan fallback under
  `--module_path` is deleted); all twelve pass entries + the or-fail
  wrappers carry the store; the test-bundle path threads one bundle-wide
  `CompileTarget.store`. Diff-test byte-identical; suite 3699/3699 + fixed
  point; the invariant is spec-pinned (`shared_store_test`,
  mutation-verified).
- **F1a (y5um.8.2)** — flip localized containers: `CompConfig`, `SelectArm`,
  `WhenArm`, `Annotation` → id fields; consumers read via store; parsers record
  real container children (retires their walker-opaque status).
- **F1b (y5um.8.3)** — flip `FieldInit.value` → `ExprId`.
- **F1c (y5um.8.4)** — flip `MatchArm` → `{pattern: PatId, guard: ExprId?, body: ExprId}`.
- **F1d (y5um.8.5)** — flip `ParamEntry.vtype` → `TypeId` (the wide sweep:
  typeck/codegen/closures/resolve/mono).
- **F2 (y5um.8.6)** — `Pattern` variant payloads → `PatId` (pilot kind).
- **F3a (y5um.8.7)** — `Stmt` variant payloads → ids.
- **F3b (y5um.8.8)** — `Expr` variant payloads → ids (largest; may split by
  variant family if a single PR gets unwieldy — precedent: B1 Stage D tiers).
- **F4 (y5um.8.9)** — delete `SExpr`/`SStmt`; passes take `(roots, store)`;
  delete `program_from_store` serving + `reconstruct_program` +
  `wc_run`/`with_children`/`struct_list_helpers` + `ingest_program` and retire
  the B1 parity battery (its oracle is gone; the HRN diff-test and the walker
  faithfulness specs remain the invariants).

Every stage is one PR on the standing process (prepare-pr ×3, CodeRabbit, merge
on green). The HRN diff-test is the oracle at every step — internal-structure
change only, byte-identical output required end to end.

## 5. Risks

1. **Mono tree rewriting** (deepest change): re-alloc vs share decisions per
   rewrite site; the diff-test catches any drift byte-for-byte.
2. **Metaprogramming producers** (quote/comptime/walker/marshal) construct
   trees at compile-time AND runtime-of-generated-code; their generated code
   must target the alloc helpers, not raw constructors.
3. **Eval/interpreter** holds boxed nodes as `Value`s; F3 must keep the eval
   path reading via ids without the L2 (compiled-comptime) rework — scope
   fence: eval mirrors consumers, no eval redesign here.
4. **Perf**: expect neutral-to-better per stage (id reads are array indexing);
   budget ±2% per stage, measured interleaved, net win expected at F4 when the
   boxed tree and its allocation vanish.

## 6. What this unblocks

ps3t.3.4 (error/missing nodes), ps3t.3.5 (hash-consing over centralized alloc),
703y.1 (uniform spans — subsumed by F4), and the L2/L4/L6 layers that block on
L1 completion.
