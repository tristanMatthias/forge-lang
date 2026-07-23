# Collapsing `@hand`: a compiled, memo-free, backtracking grammar engine

**Status:** PROPOSAL — open decisions at the end are the human's call before build.
**Context:** t-47hc (Grammar-Defined Front End). Motivated by the observation that the
"family flips" keep *wrapping* the hand parser (`@hand(hand_unary)`, `@hand(decl_hand)`,
`@hand(list_expr)`, …) instead of expressing the grammar. This doc is the design for
retiring `@hand` wholesale rather than one primary at a time.

---

## 1. Why `@hand` proliferates (the actual root cause)

The executor is **predictive LL(1)**: FIRST-set dispatch, *no backtracking* in sequences
or repetitions (`executor.av` "predictive LL, no backtracking"). The only escape valves are
**author-placed** `@try` (branch-level bounded speculation, #955) and `@hand` (delegate to
a hand method). So every construct a stateless LL(1) FIRST-check can't disambiguate lands
in `@hand`:

- **Trailing commas** — `[a, b,]`. `( "," e )*` in our engine commits the `,` then chokes on
  `]`, because the repetition can't un-consume a partial iteration.
- **`f<T>()` vs `f < T`** — needs to *try* a generic call and rewind if it doesn't close.
  Hand code does exactly this with `save_state`/`restore_state` (generics/parser.av).
- **`( … )` grouping vs tuple vs lambda** — decided only by a later `->` / trailing `,`.
- **list vs comprehension** — `[e, …]` vs `[e for v in c]`, decided after the first element.
- **mode-sensitive forms** — struct-lit-in-header (`allow_struct_lit`), it-sugar (`is_method`).
- **newline sensitivity** — `.method` on a new line is a *new statement*.

Every one of these is a *solved* problem in the parser literature. We are reaching for
`@hand` because the **engine** is too weak, not because the leaf is un-grammar-able.

## 2. The solution space, and the axis that decides it

| Approach | Gnarly-case mechanism | Cost | Fits "compile to straight-line native, no runtime table"? |
|---|---|---|---|
| **Packrat PEG** (Peggy, Ohm) | ordered choice + unlimited backtracking, memoize (rule×pos) → linear | O(n×rules) **memo table**; ambiguity hidden; LR needs an extension | ✗ the memo table *is* the runtime table we rejected |
| **ALL(\*)** (ANTLR4) | runtime DFA simulation over alternatives for unbounded lookahead | runtime prediction machinery | ✗ prediction is a runtime algorithm, not emitted branches |
| **GLR** (tree-sitter) | fork parse stacks, run alternatives in parallel, merge | runtime stack forking | ✗ (but the right shape for Phase 6 *incremental* reparse) |
| **Parser combinators** (parsec, nom) | predictive, commit-by-default, backtracking **opt-in** via `try` | memo-free + fast; but author sprinkles `try` → DX wart | ◐ this is our `@try` today |
| **Predictive LL(1)** (current) | FIRST-set dispatch, no backtracking | can't express the ambiguous leaf → `@hand` | ✓ straight-line, but too weak |
| **Hand-written RD** (our oracle) | predictive + *localized* save/restore at the ambiguous spots, arena AST | none beyond cursor + arena | ✓✓ **the target** ("generated == hand") |

**Deciding axis:** Avra's philosophy — *compile the grammar to straight-line native, emit
branches not a runtime table, generated code == hand code* — rules out packrat's memo table
and ALL(\*)'s runtime prediction. The fastest, cleanest thing in the room is **our own hand
parser**: predictive everywhere, a few surgical backtracks, no memo. Packrat is *more*
machinery and *slower* than the target. So the answer is the parser-combinator / hand-parser
point — with one fix to its only flaw (the author-placed `try`).

## 3. The reconciliation: the compiler places the `try`, not the author

We already shipped the analysis that removes the DX wart: **FIRST/FOLLOW + ambiguity
detection** (Phase 2, #951). Use it to make backtracking a *compiler* decision:

> The author writes plain ordered choice and plain repetition. The compiler runs
> FIRST/FOLLOW, finds the spots where alternatives conflict or a `*` separator can
> partially match, and **emits bounded `mark`/`restore` itself** — straight-line, memo-free.
> `@try` becomes a compiler-internal mechanism, not grammar syntax. `@hand` shrinks to ~zero.

Four moves:

1. **Backtracking is a codegen pattern, not a data structure.** A speculative alternative
   compiles to `let m = st.mark(); …attempt…; on fail: st.restore(m); …next…`. `mark` = save
   `(cursor:int, arena-highwater:int)`; `restore` = reset cursor + `truncate_to_mark`. This is
   *exactly* the hand parser's `save_state`/`restore_state`. **The machinery already exists**
   (`st.mark`, `NodeStore.truncate_to_mark`, the `@try` speculative arm in `exec_node`/emit) —
   today it's only wired to author-placed `@try`.

2. **Backtracking `*`/`+`.** A repetition iteration takes a cheap mark; on a *partial* failure
   (consumed some, not all) it restores to the iteration start and stops. That single change
   makes `( "," e )* ","?` and list-vs-comprehension "just work" — the trailing-comma paradox
   dissolves. Cost: one int-pair save per iteration, restore only at the boundary (rare).

3. **Compiler-inserted, from FIRST/FOLLOW.** Non-conflicting choices stay pure predictive
   switches (zero overhead — the ~90% case). Only real conflicts (`genericCall / ident`,
   `lambda / tuple / grouping`, list/comp) get a backtrack. The author never annotates it.

4. **`@when` stays; newline moves to the lexer.** Semantic predicates (`@when`, #954) are the
   right, clean tool for mode gates — keep them. Newline-sensitivity belongs in the **DFA lexer**
   (Phase 1): emit a `sameline`/newline property on the token stream (Python/Go/tree-sitter's
   external scanner) so the CFG never sees columns.

### How each paradox collapses

- **backtracking vs performance** → bounded, localized, *compiled*, memo-free; amortized ≈ the
  hand parser (the oracle), i.e. *faster* than packrat, not slower.
- **expressiveness vs "no runtime table"** → backtracking is emitted branches (mark/restore),
  never a memo table. Philosophy intact.
- **ambiguity silently hidden (PEG's sin)** → we *catch it at compile time* via FIRST/FOLLOW
  conflict warnings. Ordered choice becomes a deliberate, warned decision. Strictly better
  than packrat, which never tells you.
- **clean DX** → the grammar reads like the language reference:
  `list <- "[" ( expr ( "," expr )* ","? )? "]"`, `primary <- genericCall / ident / …`.
  No `@try`, no `@hand`, no hand-threaded spans.

## 4. What exists vs. the gap

**Exists** (Phase 2): `st.mark` + `NodeStore.truncate_to_mark`; the `@try` speculative
snapshot/rollback arm in `exec_node` + its emit twin; `@when` zero-width predicates over
`ExprModes`; FIRST/FOLLOW + ambiguity analysis (#951).

**Gap** (this proposal, ~Phase 2.5): (a) repetitions/sequences don't backtrack a partial
match; (b) `@try` is author-placed, not derived from a FIRST/FOLLOW conflict; (c) newline is
still a hand gate, not a lexer token property.

## 5. Open decisions (the forks — human's call)

1. **Unbounded backtrack depth (`f<T>`).** `f < g < h < i` can force a deep speculative
   descent. (a) bound the window + *compile-time warn* when a rule can exceed it (keeps
   everything memo-free, forces "sane" grammars); (b) auto-memoize *only* the rules the
   analysis proves can backtrack super-linearly (tiny targeted memo, not full packrat).
   **Recommendation: (a), with (b) as a compiler-applied escape hatch.**

2. **Rollback vs hash-consing.** SoA arena truncation on `restore` is O(1), but hash-consed
   nodes live in an intern table that doesn't truncate cleanly. (a) rollback abandons the
   speculative node-ids and leaves dead intern entries (harmless, bounded by shallow
   backtracking); (b) generational mark/release on the intern table.
   **Recommendation: (a).**

3. **How hard to push `@hand` to zero.** Keep a *principled* `@hand` for genuine embedded
   sub-languages (string-interp `"{expr}"`, quote/splice `~`) — which Phase 6 wants anyway —
   or chase literal zero? **Recommendation: principled-`@hand`-for-sublanguages only.**

4. **Sequencing.** Land the executor+emit capability (compiler-inserted bounded backtracking
   + backtracking `*`) as Phase 2.5 *before* resuming Phase-3 leaf migration, so list literal
   / paren-lambda / `f<T>` fall out as plain grammar with the hand methods retired — instead
   of hand-crafting `@try` per primary. **Recommendation: capability first.**

## 6. Build plan (if the recommendations stand)

Each slice byte-identical (build-quick + emit-gen-check + diff-test + recovery-tree oracle +
callgrind), no `@hand` regressions:

- **2.5a — backtracking `*`/`+`:** emit a per-iteration mark + partial-failure restore in the
  repetition codegen; guard on the FIRST/FOLLOW-detected "separator can partially match" case
  so non-ambiguous loops stay overhead-free. Unblocks trailing commas.
- **2.5b — compiler-inserted choice backtracking:** where FIRST-sets of two ordered
  alternatives overlap, emit the `mark`/attempt/`restore`/next chain automatically (retiring
  author `@try` for those). Prove the emitted code == the hand `save_state`/`restore_state`.
- **2.5c — depth bound + super-linear warning** (fork 1a); optional targeted memo (1b).
- **1.x — lexer `sameline`/newline token property** (fork 4 dependency for the postfix chain).
- **Then Phase 3 leaves** fall out: `list_expr`, `paren_expr` (grouping/tuple/lambda),
  `f<T>` generic-call, comprehension — as plain grammar, hand methods proven unreachable.

The perf claim to hold the line on: **hand-parser-quality constant factors, memo-free**, i.e.
strictly faster than a packrat PEG while being as expressive — because generated code == the
hand parser's own predictive-plus-localized-backtrack shape.
