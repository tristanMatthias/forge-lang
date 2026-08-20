# Front-end standardization — design record

Tracker: epic **t-y2i7** with children **t-y2i7.1 .. t-y2i7.8** (P1..P8), chained
so `mcp__Agent_Tasks__ready` surfaces exactly the next slice. The tickets carry
the WHAT and the acceptance gates; THIS file carries the WHY. Keep them in sync:
a decision that changes here changes the ticket too.

Decisions from the 2026-08-19 design session. One line per decision, with the
reason it is not arbitrary. Layout contract lives at
`packages/std-avrac/src/features/WHY.md`; this file is the WHY behind it.

Status: DESIGN RATIFIED, NOT YET IMPLEMENTED. Nothing below is true of the tree
today unless marked LANDED.

## 0. The premise

Text -> AST is: read grammar rules, feed text, run builder functions that return
AST nodes. Everything in the front end that is not that is either engine
plumbing or debris from an earlier architecture. Most of it is debris.

## 1. There is ONE grammar. "Family" is not a thing.

`Language.full()` is every rule of the language. The four parse entries differ
only in which START RULE they name ("declaration", "statement", "expression",
"type_expr") — exactly like which function a hand parser calls first.

- **Delete `gram_family`.** A feature declares rules; the grammar is their union.
  Which rules serve statements is reachability from `statement` in the rule
  graph — follow the names. The engine spine's `statement = break_stmt |
  continue_stmt | ... | defer_stmt | ...` alternation ALREADY states membership;
  `gram_family` is the feature asserting it a second time.
- The filter that motivated it (`gram_family != ""`, to avoid double-counting a
  fragment reachable two ways) is obsolete: `compose_fragments` dedupes by
  `rule_identity` (#1239). Compose every feature fragment unconditionally.
- **Delete the two hand-maintained decl-fragment lists** (`avra_grammar.av:364`
  and `feature_decl_grammar_fragments`). Same 15 fragments, different orders,
  kept in lockstep by hand; already silently lost `parse_export_decl` once
  (t-kd4y.3.5.9). `decl` was the one family that never got a label — and
  labelling it would not have fixed this. Deriving it does.
- **Delete the three identical `feature_{stmt,expr,type}_grammar_fragments`.**
  Byte-identical but for a string literal.

## 2. Delete every grammar "view"

12 `avra_*_grammar()` functions are subsets of one rule set, assembled by
`compose_fragments` (concatenate + dedupe). They date from when each family
emitted its OWN static parser file and each needed a bag with the other
families' rules EXCLUDED (so the expression parser CALLED `parse_type_expr`
rather than re-emitting the type rules). One `gen_parser.av` from one grammar
means there is nothing left to exclude.

- **8 contain zero rules. Seven are pure plumbing; ONE is not — read before deleting.**
  `avra_type_grammar` has no rules but carries a real invariant: it hoists
  whichever fragment defines `type_expr` to the FRONT, because
  `compose_fragments` takes the FIRST fragment's start rule as the grammar's
  START SYMBOL, and `run_grammar_type` execs `rules[0]` as its entry. Spine-first
  led with the `@when(in_quote_body)`-gated `splice_type` and gated the whole
  view — `type_equivalence_test` went 0/8, with even `int` failing at the entry.
  Whatever replaces the views must preserve that hoist. The other seven:
  `avra_expr_grammar`, `avra_expr_dispatch_grammar`, `avra_expr_core`,
  `avra_stmt_flip_grammar`, `avra_stmt_dispatch_grammar`,
  `avra_decl_flip_grammar`, `avra_decl_dispatch_grammar`.
  `avra_expr_dispatch_grammar()` is the clearest fossil: its purpose was to
  DIFFER from `avra_expr_core()`, and its body is now `avra_expr_core()`.
- **5 contain real rules (~365 lines) — keep the RULES, drop the layering:**
  `avra_expr_spine_grammar` (217, the precedence ladder), `avra_decl_edge_grammar`
  (85), `avra_stmt_common_grammar` (37), `avra_type_spine_grammar` (20),
  `avra_program_grammar` (6). They become ONE engine-core spine fragment.
- The whole composition layer becomes:
  `compose_fragments([engine_spine()] + feature_fragments())`.

Watch for this shape elsewhere: each view was CORRECT when there were five
generated parser files. Nobody deleted them when five became one.

## 3. One seam, not four (five)

`parse_expression` / `parse_statement` / `parse_declaration` / `parse_type_expr`
are the same ~50 lines four times: read modes, `ensure_host`, `copy_cursor_from`,
`begin_delegate_item`, pick engine, run, merge bag, adopt state, resync.

Their drift is documented in the source: `begin_delegate_item()` existed only on
`parse_declaration` until PR #1221 review — the other three re-merged stale
diagnostics. That bug exists only because the code is written four times.

- **DELIVERED (P1), and NOT as originally specified.** The ceremony is extracted
  into three helpers — `seam_enter()`, `seam_merge_delegate()`,
  `replay_dsl_diags()` — and the seams call them. A single
  `parse_at(self, start: RuleName)` was ATTEMPTED and DECLINED: the four entries
  return different types (`StmtId` / `ExprId` / `TypeExpr`), and the type seam
  has no host delegate at all and resyncs token-by-token with `>>` splitting
  rather than by stop byte. One entry would have had to fake a uniformity that
  is not there. The duplication worth removing was the CEREMONY — three copies,
  one of them right, which is how #1221 happened — and that is now written once.
- **STILL OPEN, deferred out of P1:** the four `parse/static_*_entry.av` shims
  survive, and the forward-progress watermark is still `parse_declaration`-only
  (`item_start`). Both were listed here as P1 work and neither was done. They are
  small and real; they belong to whichever slice next touches this file. Do not
  read this section as describing the tree until they land.
- The watermark argument stands on its own merits: "an errored parse that
  consumed zero bytes must return `.Err` so the caller advances" is a property of
  any loop over a repeated rule, not of declarations. `declaration` is merely
  where the infinite loop was observed.

## 4. 100% grammar-generated lexer

`token_table.av` is already a declarative lexer DSL: `LitRule` (keywords),
`LitRule` (operators, maximal munch), `CharRun`, `DelimRun`, string-body modes
(escape / interp lead / close_rep / stop_nl), and a universal escape map. The
nasty cases (`${` as a TWO-byte lead, `"""` needing `close_rep: 3`, raw strings
stopping at LF) are FIELDS, not control flow — each was a bug fixed by becoming
data. So this is not "invent a byte-level DSL"; it is "move rows that exist into
the block that owns them".

- **Terminals declare in `grammar { }`.** Uppercase LHS = terminal. The grammar
  DSL is itself grammar-defined, so this is a rule addition.
- **`emit_lex.av` reads grammar terminals instead of `token_table.av`.** Same
  record shapes, different source.
- **Features own their rows.** ~60 keyword + ~80 operator rows redistribute to
  owning features. Do it WHILE standardizing the files, not as a second pass.

### scan vs build — the split the lexer never got

A **scanner** is a generated, allocation-free byte walker answering one question:
`classify_keyword` (byte trie), `match_operator` (maximal munch), `scan_hex`
(advance while hex-or-`_`), `scan_dq_body` (advance to unescaped `"` / `${` /
EOF). All already derived.

What is NOT derived is **assembly**: resolving `\n`, splitting `"a${x}b"` into
three pieces, stripping common indent from `"""..."""`, turning `0x1F_00` into
7936. Those are transformations on matched text, not matching.

That is the SAME split the parser has — a rule says what matches, a builder says
what to construct. The lexer has both halves; only the first was named. So:
**a terminal gets a derived scanner and a hand-written LOWERING**, living in the
owning feature's `lowering.av` next to its builders. The lexer stops being an
architectural special case.

## 5. `Tk.Keyword(KwId)` — generated, typed, exhaustive

A keyword lives in three places today: `Tk.KwDefer`, a `keyword_rules()` row, and
the `"defer"` literal in the feature's gram. Two are hand-edited per CLAUDE.md's
checklist.

Rejected: collapsing to `Tk.Keyword` + a spelling. Consumers (LSP, linter,
highlighter) would compare `tok.spelling == "defer"` — string-matching to detect
behaviour, which CLAUDE.md forbids. An interned id fixes speed, not typing; a set
of named ids IS an enum, reinvented worse and without exhaustiveness.

**Adopted:** `Tk.Keyword(id: KwId)` / `Tk.Op(id: OpId)`, with `KwId`/`OpId`
GENERATED from the terminal declarations.

- Adding a keyword = one line in a feature's grammar. `KwId`, `keyword_rules()`,
  and the scanner trie all regenerate. Three hand-edits become zero.
- Consumers gain: a highlighter matches `.Keyword` ONCE instead of testing
  membership in 59 variants; `.Keyword(.Defer)` is exhaustively checked.
- `Tk` drops 147 -> ~90 variants while GAINING the distinction.
- `maybe_split_shr` (`parse/mod.av`) becomes a property of the `>>` terminal's
  declaration, not a special case.
- Cost is small: of 257 `Tk.Kw*` refs, 120 are in `token_table.av` /
  `gen_keyword_scanner.av` (deleted or generated), 18 in `gen_parser.av`
  (generated), 3 in dead code. **Hand-written surface: ~50 refs, ~10 files.**

**No seed hazard.** `Tk` never crosses the metadata/comptime decode boundary, so
the pinned seed's baked matches only ever see tokens ITS OWN lexer produced — it
cannot receive a variant it does not know. This is NOT the
`ValueType`/`Expr`/`Stmt` case that needs `make seed-patch-traps`.

**SPIKED AND VERIFIED (2026-08-19)** against `build/bs2` — enum-in-enum payload,
bind-and-dispatch, nested literal pattern `.Keyword(.Defer)` in one arm, inner
`==`, and F9001 exhaustiveness all work today. No language work required.
Payload fields are NAMED: `Keyword(id: KwId)`, not `Keyword(KwId)`.

Grammar coherence replaces what enum exhaustiveness was doing for us: a terminal
no rule references is a startup error naming the feature — the same check
`builder_validation_error` already performs for builders. Strictly an addition.

## 6. A feature is a COMPONENT, not a trait

Considered and rejected: `trait Feature` + `impl Feature for Tuples` +
`List<dyn Feature>`. Avra traits do support default method bodies, so it was
viable. Rejected because:

1. A feature is DATA, not behaviour with identity. There is one tuples feature
   and it has no state; `dyn` would buy polymorphism over instances that do not
   exist — 70 singleton structs to hang methods off.
2. Dispatch is `tag -> hook` tables built at registry construction. Trait methods
   would be reified back into function values to fill them: a layer added, none
   removed.
3. `noop_*` defaults + `builder_validation_error` already give what default
   methods would, and the component `config` block is a schema the compiler
   validates.

Revisit only if features need per-feature STATE or dynamic third-party loading.

`LanguageFeature` keeps its 20 flat fields. Standardize WITHIN that shape; no
identity/syntax/passes split (considered, declined).

## 7. Kill the legacy `Feature` record

`core/registry.av`'s `Feature` duplicates `LanguageFeature`'s 13 hook fields, and
`register_lang` copies them one at a time. It types `emit_expr: int` /
`emit_stmt: int` — **function pointers stored as untyped ints**, a rule-16
violation sitting in `core/`. Collapse to one record; the nine `noop_*` in
`core/` die with it (the component's `config` defaults already cover them).

## 8. Derive, never declare

- **Feature registration.** `features/mod.av` carries 46 `use` lines plus a
  70-entry `language_features()` array on one line; adding a feature means
  editing two places. Derive from directory discovery + the `<name>_lang()`
  convention. Order becomes `sort_by(name)` — REPRODUCIBLE, not filesystem
  order. One-time `intended-ir-change` (emitted fn order is observable).
- **No hardcoded module paths.** `bind_rows("features.tuples.lowering", ...)`
  repeats the module's own path as a string 40 times, and that string drives
  generated-parser imports. Derive it.

## 9. Delete the dead front end (~1,180 lines, zero callers)

Retired hand parsers whose live namesakes are the GENERATED functions in
`gen_parser.av`:

- `features/component_decl/parser.av` (539), `features/fn_decl/parser.av` (113),
  `features/spec_test/parser.av` (82), `features/map_lit/parser.av` (57) — all
  self-referential islands.
- `parse/mod.av`'s `postfix_step` (214) has 0 callers;
  `features/generics/parser.av` (76) and `parse_arg_list_ids` /
  `parse_arg_list_ids_inner` are reachable ONLY through it.

Live and NOT parsers, so they move rather than die: `closures/parser.av`
(`expr_contains_it` / `wrap_in_it_lambda` — AST helpers -> `lowering.av`) and
`grammar/parser.av` (raw-brace capture for `grammar { }` -> moves with the engine).

Before deleting on the strength of any scan, re-read CLAUDE.md's dead-code-sweep
section: `bootstrap/tests/` is ~457 fixtures OUTSIDE `packages/`, `find -path
'*/build/*'` matches across slashes, and a name used as a VALUE has no `name(`.
Verification is a COLD full `bs2 test` (`rm -rf build/cache/fixture_stdout`
first), not build + lint + diff-test.

## 10. The engine moves out of `features/`

`features/grammar/` (14,575 lines) is the compiler-compiler, not a feature, and
is the largest thing in a directory of peers like `tuples`.

- Engine -> `src/grammar/`.
- The `grammar { }` SURFACE feature (`grammar_block_lang` + the raw-brace
  capture, ~120 lines) drops out as `features/grammar_block/`, like any other.

Cost is real: every `use features.grammar.{...}` including the GENERATED parser's
header and the `bind_rows(...)` path strings.

## 11. `lowering` stays a separate MODULE

Not a style choice. `parse/gen_parser.av` emits ~40 `use features.X.lowering.{...}`
lines so the generated parser's import closure is **grammar + core only**; a
feature's `mod.av` pulls `resolve` / `typeck` / `codegen` / `eval`, and widening
the parse closure to include them is the F4012 double-expand trap. This invariant
is what killed the `_gb_` wrapper layer — do not trade it for a flatter tree.

`dir_module.av` flattens siblings into one namespace, so a bare
`features/tuples/lowering.av` would surface as `features.tuples.*` and force the
generated parser to import the whole feature. Getting `lowering.av` as a FILE
therefore requires file-modules in the resolver (a file addressable as
`<dir>.<name>`, importing only its own closure). Until that lands, `lowering/mod.av`
stays — but it must be **present and identical in shape for every feature that
lowers**, which is the part that is not true today.

## 12. Errors — Axis 12 is HALF BUILT. Build the rest, minimally.

Verified 2026-08-19. The SYNTAX exists; the semantic layer does not:

| spec | built | note |
|---|---|---|
| `Result<T, E>`, `?` propagation | YES | |
| `catch { }` / `catch (e) { }` | YES | `catch_suffix = c:"catch" ( "(" b:IDENT ")" )? "{"` |
| union types `A \| B` | YES | `UnionAliasReg` (typeck) |
| `errdefer` | YES | 60 uses |
| **`trait Error`** | **NO** | does not exist anywhere in the tree |
| **`@derive Error`** | **NO** | `@derive` supports `eq` + `hash` ONLY |
| **error-union widening at `?`** (12.3) | **NO** | every `widen` site in typeck is NULLABLE widening |
| **typed catch** `catch (e: NetError)` (12.5) | **NO** | grammar captures `b:IDENT`, no type slot |
| auto `call_site()` / `trace()` | **NO** | nothing to accumulate into |

So `Result<T, string>` x325 is not laziness — there is no better E available.
Per CLAUDE.md *Build What You Need*, the missing half gets BUILT, not worked around.

**Scope for this program: THE MINIMUM ONLY. `trait Error` + `@derive(Error)`
were ratified as option B and then CUT (2026-08-19) — they are the only NEW
FEATURE work in an otherwise-cleanup program, the only slice a lint cannot
verify, and the front-end validators need none of it.**

What ships here, needing NO language work:

- A front-end error **enum** with structured variants — `feature`, `rule`,
  `build` as FIELDS, never interpolated prose.
- Validators return `Result<T, List<E>>` instead of a `""` ok-sentinel.
- `grammar_startup_fail`'s `avra_process_exit(99)` becomes
  collect-all-then-fail.
- One renderer.

That fixes the thing that matters. With 70 features and several new checks
(terminal-unreferenced, feature-layout, central-domain, ~60 keyword + ~80
operator rows), a string sentinel reports the FIRST broken feature and exits —
you cannot aggregate, group, or count. Structured variants + a list fix that
with zero new language surface.

**Deferred to its own program (write the enum so this is a widening, not a
rewrite — ~15 conversion sites):** `trait Error` in `@std` (`message()` /
`kind()` mandatory, rest defaulted), `@derive(Error)` as a third derive kind
beside `eq`/`hash` with `kind()` derived from the type name
(`IoError.not_found` -> `"io.not_found"`), error-union auto-widening at `?`
(invasive — typeck core inference), typed catch binding, and compiler
instrumentation for `call_site()` / `trace()`.

## 13. Stringly-typed enums — the same rule-16 bug as `emit_expr: int`

A closed set held as strings, checked at runtime by list membership, in a
language with enums and exhaustive matching.

- **`engine_build_kinds()`** — 21 strings (`"expr" "stmt" "arm" "warm" "sarm"
  "pat" "type" "tok" "toks" "pentry" "tparam" "field" "variant" "finit" "ccfg"
  "cpair" "cslot" "ccfgs" "cslots" "ann"`), with `BuilderBind.kind: string` and
  32 `== "stmt"`-style comparisons. -> `enum BuildKind`.
- **`emit.av`'s `kind_row` / `kind_coerce` / `kind_elem_type` / `kind_list_ctor`**
  — four functions keyed on that string. -> one `match` on the enum.
- **`Token = { kind: string, text: string, pos: int, tk: Tk }`** (grammar/lex.av)
  — `kind` and `tk` are the SAME information twice, one stringly-typed. Fixed as
  part of the `Tk.Keyword(KwId)` work (§5) or not at all.
- **`mode: string`** threaded through `parse/differential.av` + `parse/testkit.av`.
- `Quote(kind: string, body: ExprId)` (core/ast.av).
- `gram_family: string` — dies with §1.

## 14. Newtypes — 4 in use, and the string-typed identifiers want them

`core/ids.av` has `ExprId` / `StmtId` / `PatId` / `TypeId` as `type X = int`, and
that is the whole inventory. The identifiers that are still bare `string`:

- **module paths** — `bind_rows("features.tuples.lowering", ...)` x40 (§8).
- **build names** — `"MkTupleIndex"`, matched by string across two dispatchers.
- **rule names** — the start-rule parameter of the one seam (§3).
- **F-codes**.

`type ModulePath = string` makes a derived path un-typo-able where a bare string
never can be. This is the concrete form of "no hardcoded strings anywhere".

## 15. Two headline features have ONE real use each — the same line

```avra
// features/lang.av:61 — the only real pipe AND the only real comprehension
[t for t in grammar_literals(feature_gram(f)) if text_is_word(t)] |> list_dedup_str
```

Every other `|>` hit is the pipe feature's own implementation or a comment.
Meanwhile `mut out: List<X> = []` + `for` + `.push` runs to hundreds of sites —
`fold_builders`, `feature_*_fragments`, `list_avra_module_files`, and
`builder_validation_error` are all comprehensions written longhand.

NOT a gap, and deliberately not on the work list: `defer` (1 use). The codebase
threads state through every function, so there is rarely a scope-exit obligation
to defer. Adding it would be dogfooding for its own sake. The 60 `errdefer`s are
already in the places that own resources.

Healthy already: `with` (203), `table` (41), `dyn Trait` (25), trait impls (31),
`@comptime` (267), `quote` (183).


## 16. Execution plan

Ordering rationale: delete first (shrinks everything downstream), then unify,
then generate. The engine move is LATE — slices P1-P2 delete ~1,650 lines
INSIDE `features/grammar/`, so moving first renames code that is about to not
exist, and it is the one slice that conflicts with everything.

Collisions were resolved by MERGING slices, not parallelising them: the original
"delete dead code" and "one seam" both operate on `parse/mod.av` (`postfix_step`
sits at line 1282, BETWEEN `parse_expression` at 1150 and `parse_type_expr` at
1801), and the original "views" and "legacy Feature" both rewrite
`features/lang.av` + `features/mod.av`. Same file, same reviewer, one PR each.

| # | slice | sections | IR |
|---|---|---|---|
| P1 | `parse/mod.av`: delete dead hand parser; extract the shared seam ceremony (`parse_at` declined — see section 3) | 9, 3 | neutral |
| P2 | Delete the 8 rule-less views; merge the 5 rule-bearing into one spine; delete `gram_family`, the two decl lists, the 3 identical fragment fns; kill legacy `Feature` + `noop_*` + `emit_expr: int` | 1, 2, 7 | neutral* |
| P3 | `BuildKind` enum; newtypes for module paths / build names / rule names; front-end error enum + aggregation | 13, 14, 12 | neutral |
| P4 | Feature layout sweep — WHY.md contract across 60 dirs + `--check-feature-layout` | layout, 11 | neutral |
| P5 | Derived feature registration (`sort_by(name)`) | 8 | **intended-ir-change** |
| P6 | Engine -> `src/grammar/`; `features/grammar_block/` splits out | 10 | neutral, huge rename |
| P7 | `Tk.Keyword(KwId)` + `Token.kind` collapse | 5 | **intended-ir-change** |
| P8 | Terminals in `grammar { }`; `emit_lex` reads them; row lists -> `table` literals | 4, tables | **intended-ir-change** |

\* P2 is IR-neutral ONLY if composed rule ORDER is preserved. Emitted fn order
is observable (t-kd4y.3.5.9). Verify before assuming.

Deletions are IR-neutral against diff-test because the selfhost leg runs NEW
against **OLD's** source — compiler BEHAVIOUR is unchanged, so the oracle stays
green. Only P5 / P7 / P8 need the `intended-ir-change` label.

### Where fan-out pays

Not across branches — three hot files (`features/lang.av` 175,
`features/mod.av` 235, `parse/mod.av` 2066) are touched by nearly every slice.
The volume is INSIDE slices, where units are independent:

- **P4: 60 independent feature directories.** Nothing crosses a feature
  boundary; `--check-feature-layout` is the join.
- **P8:** ~140 keyword/operator rows redistributing to owning features.
- **P3:** 42 `bind_rows` sites.
- **P2:** `gram_family` removal, 39 files, one line each.

### The real bottleneck is gates, not edits

Cold strict suite ~1608s; diff-test ~5-7 min hermetic; a warm local run proves
NOTHING about a compiler change (`rm -rf build/cache/fixture_stdout` first).
Eight stacked PRs = eight sequential CI cycles plus seven rebases. Keep
IR-neutral slices as SIBLINGS off integration wherever they share no files —
siblings merge in any order and skip the rebase chain.

P6 must be alone in flight (it renames every `use features.grammar.{...}`,
including the generated parser's header). P7 must follow P6 or it rewrites the
same files twice.
