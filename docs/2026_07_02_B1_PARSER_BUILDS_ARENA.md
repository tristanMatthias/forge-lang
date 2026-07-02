# B1 — The Parser Builds the Arena Natively

**Status:** design for sign-off (worked through 2026-07-02)
**Parent:** `y5um` (L1 keystone increment B) · umbrella: `docs/2026_06_14_AST_SOURCE_OF_TRUTH_EPIC.md` (Layer 1, Decision E)
**Ticket:** `y5um.4` · **Successor:** `y5um.8` (B-final rep flip)

---

## 1. Goal

Today the parser builds the boxed `SExpr`/`SStmt` pointer tree, and `parse_or_fail`
**copies** it into the L1 arena (`ingest_program`), then serves the boxed tree
back (`program_from_store`). B1 makes the parser **allocate into the arena as it
parses** — every production returns a typed id — and deletes the copy step. The
arena stops being a mirror and becomes the producer.

**Byte-identical throughout** (diff-test + selfhost fixed point at every stage).

## 2. Non-goals (explicitly out of B1)

- **No enum/variant/field changes** to `Expr`/`Stmt`/`Pattern`/`ValueType` or the
  container structs (`MatchArm`, `FieldInit`, `ParamEntry`, …). Field-type flips
  are seed-gated and serialize through the seed train — that is B-final
  (`y5um.8`), batched per-variant with its consumers.
- **No span cleanup.** ~69 wrap sites encode load-bearing position quirks
  (post-child `current_line`, desugar-time positions in pipe, line-0 dummies).
  Diagnostics render these exact positions; B1 replicates every quirk verbatim.
  Precise per-production byte extents (the §14.2 residual) are a follow-up that
  intentionally advances the diff-test oracle — never a side effect.
- **No richer edges.** B1 records the same edge coverage the walker-driven
  ingest records today (match arms + field inits included; `ParamEntry`/
  `CompConfig`/… excluded). Recording more would desynchronize the
  `with_children`/reconstruct oracles — container children get their ids
  natively at B-final, as labeled id-fields (the settled industry rep).
- **No reconstruct on the compile path.** `reconstruct_program` is documented
  unfaithful (flattens nested `from_macro`, stamps `file=""`); it stays a
  test/probe tool.

## 3. Decisions

| # | Decision | Rationale |
|---|----------|-----------|
| 1 | **Full native alloc, boxed payloads retained** ("3a-boxed"). Productions return `Result<ExprId, string>` (resp. `StmtId`/`PatId`/`TypeId`); the arena keeps storing the boxed node per row (as `ExprArena.nodes: List<Expr>` already does). Parents embed the boxed child via `store.get(id)` (an array read) and record the child's edge id. | Chokepoint-alloc was evaluated and rejected: a boxed node doesn't carry its id, so any late-wrap chokepoint must re-ingest subtrees, build a pointer→id memo, or degenerate into `ingest_program` relocated — zero win. Returning ids is the only scheme where the parser's unique knowledge (child ids at construction time) is captured. |
| 2 | **The boxed view is the existing `program_from_store`** — unchanged, already proven byte-identical on the serve path. No new shim. | Reconstruct-from-edges is unfaithful and ~ingest-priced per compile. Boxed payloads make the faithful view free. |
| 3 | **Store scope = the entry file, threaded to template sub-parsers.** `parse_template_expr` sub-parsers share the outer store (their nodes are in today's ingested store, so parity requires it). Module sibling parses / `parse_body_source` merge *after* `parse_or_fail` and stay out (matches today's store contract, documented at the y5um.5 call sites). | Parity with today's store; avoids inventing a multi-store merge story before B2 needs one. |
| 4 | **Speculation truncates; rebuild shells may orphan.** `save_state`/`restore_state` additionally snapshot the four arena lengths and truncate on restore — truncation covers each arena's parallel id-keyed columns together (`nodes` + `edges` + `spans` are dense arrays indexed by the same id, so truncating all three to the saved length keeps them consistent; the provenance table records roots only, which speculation never reaches, and the `LineIndex` is immutable per source). Backtracked subtrees (e.g. `try_parse_generic_call` arg lists — which may contain quotes) therefore leave no rows. The five destructive-rebuild sites (assignment retarget, pipe desugar, EnumCtor promotion, lambda reinterpretation, ListComp unwrap) orphan only their discarded *shell* row (an `Ident`/`FieldAccess`/`Call` node — never a quote-bearing payload; children are re-parented by id). Orphan tolerance is documented on `NodeStore`; the quote presence-scan's over-approximation is provably impossible for shells and truncated away for speculation. | Keeps `store_has_quote`-class flat scans exact; keeps the invariant "rows ⊇ served tree" cheap to reason about. |
| 5 | **Error programs never reach consumers** (unchanged): `parse_or_fail` bails on `had_error` before serving. `synchronize()`-dropped partial stmts leave orphan rows only on paths that abort. | No new error-node machinery needed in B1. |
| 6 | **No seed cycle.** Ids are existing int newtypes; store ops are ordinary fns; `Parser` gaining `store` + `LineIndex` fields is a compiler-internal struct change (the seed-patch rules cover AST enum variants, not `Parser`). Confirm empirically at stage 1 by building from the pinned seed. | Verified against the seed rules; this is the key argument for keeping B1 separate from the seed-train-serialized B-final. |

## 4. The migration oracle (how byte-identity stays provable mid-flight)

**Contract: the parser-built store must be serve-path-equivalent to the
ingest-built store.** Concretely: `program_from_store(parser_store) ==
program_from_store(ingest_program(stmts))` under render-equality, plus
top-level span/linecol parity **and root `from_macro` (provenance) parity** —
render-equality cannot see `from_macro`, yet `parse_or_fail` relies on the
serve path preserving it, so provenance is asserted explicitly (positions are
recomputed from spans on serve).
Row-count equality is deliberately *not* required (orphans, Decision 4) —
equivalence is defined on what consumers can observe.

Mechanics:
1. **Dark launch.** The parser threads `store` and productions allocate, but
   `parse_or_fail` keeps `ingest_program` as the canonical producer. A gated
   differential probe (`AVRA_B1_PARITY=1`, spec-tested like the `AVRA_L1_INGEST`
   probe) builds both stores and asserts serve-path equivalence on real
   programs — the corpus, the selfhost source, and targeted fixtures for every
   hard case in §5. The probe also reports **arena stats** (rows per kind +
   orphan count = parser rows minus ingest rows), turning Decision 4 from an
   argument into a measurement: a runaway rebuild or a truncation bug shows up
   as an orphan-rate spike at the stage gate, not as a mystery later.
2. **Flip + delete.** When parity holds across the suite + selfhost,
   `parse_or_fail` serves from the parser store and the `ingest_program` call
   is deleted. The quote-scan (`y5um.5`) and resolver-roots (`y5um.1`)
   consumers switch source transparently (same `NodeStore` type).
3. Every stage lands under the standing M3 gates: full suite + selfhost fixed
   point + diff-test byte-identical.

## 5. The hard cases (enumerated, each with its handling)

The parser is not a pure builder; these sites inspect or discard built nodes:

| Case | Site | Handling under ids |
|---|---|---|
| Assignment retarget (`x = v` / `a.b = v`) | `parse/mod.av:803` | `get(left_id)`, match, build `Assign`/`FieldAssign` re-using the *children's* ids; shell orphans (Decision 4) |
| Pipe desugar (`\|>`) | `parse/mod.av:824–884` | Same: rebuild `Call` with LHS id prepended / substituted at the `_` placeholder (placeholder scan walks boxed via `get`) |
| EnumCtor promotion | `parse/mod.av:1300` | `get`, match `.Ident`, build `EnumCtor` with arg ids; Ident shell orphans |
| Lambda reinterpretation (`(x, y) -> …`) | `parse/mod.av:229` + `:1509` | Param names extracted from boxed view; the paren-expr rows orphan (names-only survive — no node children lost) |
| ListComp single-element unwrap | `parse/mod.av:1558` | `get(elements[0])`, re-parent the inner id |
| `it`-pronoun scan | `features/closures/parser.av:14` | Read-only recursive walk over `get(id)` boxed view — unchanged logic |
| Speculation (`try_parse_generic_call`) | `features/generics/parser.av:58` | Arena truncation on `restore_state` (Decision 4) |
| Template `${…}` sub-parsers | `parse/mod.av:326, 1617` | Sub-parser constructed with the outer store (Decision 3) |
| Quote-arm bare `Expr.None` subject | `parse/mod.av:2195` | Already-documented trap; allocated like any bare child |

## 6. Staging (the ~278-site mechanical change, reviewably)

Per-production-family stages, each dark-launched + parity-probed + diff-tested
(`PREBUILT=1` locally, hermetic in CI), respecting the stale-`bs2` cache bug
(force the CLI-cache clear on every parser edit — the known `pdme.1`/`6cks`
masking loop):

1. **Stage A — plumbing + primary/postfix expressions** (`Parser.store`,
   signatures for the primary chain, the parity probe itself).
2. **Stage B — binary/logical/pipe chains + the rebuild sites** (the hard
   cases live here; targeted parity fixtures per case).
3. **Stage C — statements + declarations** (`parse_statement_list` chokepoint,
   top-level span parity).
4. **Stage D — the 25 feature parsers** (mechanical; dispatch passes `self`,
   so no registry changes).
5. **Stage E — flip + delete ingest** (+ retire the parity probe to a spec).

Each stage is one PR on the standing process (prepare-pr ×3, CodeRabbit, merge
on green). Stages A–D ship dark (parser store built but unused): temporary
double-allocation ≈ the known ~5% ingest cost — acceptable because the stage
train is short; if it stalls, the store-build is flag-gated off in one line.

## 7. Perf expectation (honest)

≈ **Neutral at flip** (±1–2%): per-production pushes replace the ingest walk
(same node count); `get()` read-backs are array indexing; `build_line_index`
moves into `parser_new` for store-carrying entries only. The *wins* arrive at
B2/B-final when consumers read ids and the boxed tree shrinks — B1 is the
foundation move, priced accordingly. During dark-launch stages: temporary
~+5% (double alloc), removed at Stage E.

## 8. Risks

1. **Wrapper-position quirks** (top risk): parity probe asserts served
   linecol equality per top-level stmt + rendered-diagnostic fixtures for the
   quirky sites (pipe, arg lists, match arms).
2. **Orphan-row semantics drift**: Decision 4's invariants are spec-tested
   (a backtracked quote must NOT trip the presence scan; a rebuilt shell must).
3. **Store fragmentation** (templates/sub-parsers): Decision 3 + parity
   fixtures containing `${…}` interpolations.
4. **Walker/reconstruct symmetry**: edge coverage frozen at ingest-parity
   (Non-goal 3); the `wc_roundtrip` and `l1-reconstruct` oracles must stay
   green untouched.
5. **Masked dev loop at this scale**: every stage's checklist starts with the
   forced cache clear; diff-test PREBUILT=1 is mandatory per stage, hermetic in CI.

## 9. What this unblocks

`ps3t.3.4` (error/missing nodes — needs parser-on-arena), `ps3t.3.5`
(hash-consing — needs centralized alloc), per-production precise spans
(§14.2 residual), and B-final itself: once the parser allocates ids, flipping a
variant's fields to ids is a *local* change batched with its consumers through
the seed train, instead of a representation big-bang.
