> **SUPERSEDED 2026-07-27.** The plan of record for t-47hc is
> [`docs/2026_07_27_GRAMMAR_FRONTEND_ROADMAP.md`](../../docs/2026_07_27_GRAMMAR_FRONTEND_ROADMAP.md)
> — it carries the slice list, the measured hours-per-slice, and the gate order.
> This doc is retained for its ENGINE CO-DESIGN reasoning (why zero-`@hand` is the
> goal and what each leaf costs); its sequencing and estimates are out of date.
> Do not plan from this file.

# Zero-`@hand`: the first-principles plan to retire the hand front end

**Epic:** t-47hc (Grammar-Defined Front End). **Status of this doc:** the resolved
engine co-design — the decision the epic was parked at (see t-47hc comments
"DESIGN GATE REACHED" 2026-07-23 and "FIRST-PRINCIPLES ZERO-@hand PLAN" 2026-07-24).

## The goal, stated exactly

Parser B (the grammar-generated front end) is **done** when **two** things are
true: **zero `@hand` leaves** in the grammar, and **Parser A (the hand recursive
descent + hand lexer) deleted**. Every slice moves exactly one of them. `@hand`
is the escape hatch that routes a grammar position to a hand-written parse
function; leaving it in forever is the timid strategy the language designer
rejected ("define things in the grammar, don't just route to another function").

## Why `@hand` exists — the audit (not guesses)

A full audit of `features/grammar/avra_grammar.av` + the `record_pos` side-table
in `parse/mod.av` shows the ~21 distinct `@hand` delegates are **not arbitrary**.
They reduce to exactly **three engine gaps**:

| Gap | Root cause | `@hand` leaves it owns |
|---|---|---|
| **1. SrcPos side-table** | Grammar actions (`mk_block`/`mk_if`/`mk_while`/`mk_for_loop`) don't write the per-statement position side-table the hand parser writes via `parse_statement_list_ids` → `store.stmts.record_pos(sid, SrcPos{line,col,file})`. A DSL-native statement rebuild drops those positions → **diverges on diagnostics**. | `stmt_hand` (block/if/while/for/match/defer/errdefer), `return_stmt`, `let_stmt`, `decl_hand` bodies, **and** the statement-containing expr primaries (`match`/`if`/`when`/`spawn`/`channel`/`isolated`/`quote`) — the largest cluster |
| **2. Mode-state** | The stateless token-grammar can't thread the hand parser's modes (`allow_struct_lit`, `allow_dot_postfix`, `allow_it_sugar`, `quote_depth`) or newline-sensitivity. | the postfix chain (`postfix_suffix`/`with_suffix`/`pipe_rhs`) + `paren`/`brace`/`list`/`ident`/`qualified`/`template` primaries |
| **3. Bounded speculation with a build** | 2-token-lookahead disambiguation. | component-instantiation-vs-expr-statement (`decl_hand` bare IDENT), paren-vs-tuple-vs-lambda, `f<T>` vs `f < T`, list-vs-comprehension |

## The load-bearing rule: opt-in primitives, never executor mutation

The grammar **executor** (`features/grammar/executor.av`, `exec_rule`/`exec_repeat`/
`exec_node`/…) is **also the live production parser** for the type family
(`type_flip` → `run_dsl_type_at_shared`). So **any behavioural change to `exec_*`
changes real emitted IR → non-byte-identical by construction.** This is not a
theory — it is why PR #976 (t-47hc.10), which auto-inserted per-repetition
backtracking into `exec_repeat`, was abandoned: it changed how existing
separator-led loops parse and could never be byte-identical.

**Therefore every capability is added as an OPT-IN primitive** — a new
annotation / field / side-table write that is **dormant until a grammar uses
it**, with a two-sided **executor ↔ emit lockstep**. This is exactly how `@when`
(#954) and `@try` (#955) landed byte-identical. The capability is *spent* only at
a leaf-migration site, where the oracle proves byte-identity against the hand
parser.

## The three parked forks — resolved

1. **Backtracking approach (fork 2).** The parked gate recommended *compiler-
   inserted* bounded mark/restore derived from FIRST/FOLLOW. **Resolved: WRONG for
   the migration.** Compiler-inserted-automatic backtracking changes existing
   loop behaviour → non-byte-identical by construction (proven by #976). During a
   byte-identical migration, backtracking **must be opt-in** (`@try` extended to
   carry `-> build`), added only at a migration site where diff-test proves
   parity. Compiler-inserted-automatic is a legitimate *post-migration* internal
   choice (once Parser A is gone there is nothing to be byte-identical against) —
   never a migration tool.
2. **`sameline` lexer property (fork 3).** **Resolved: yes, do it, first.** Move
   newline-sensitivity to a token property (the byte-based lexer already knows
   line numbers → additive, byte-identical), so the CFG becomes context-free and
   the mode gap shrinks before any leaf moves.
3. **Emitter form: comptime-lowering vs checked-in-text (fork 1 / t-47hc.9).**
   **Resolved: off the critical path.** It governs *how* generation happens, not
   *whether* leaves are `@hand`. The checked-in-text emitter already produces
   byte-identical parsers; comptime-lowering is the Phase 5/6 north star, not a
   zero-`@hand` blocker. Do not let it gate leaf migration.

## The sequence

Capability slices ADD a dormant primitive; leaf slices SPEND it and DELETE the
`@hand`. Each is one reviewable PR, CI-authoritative (this box can't be trusted
for local diff-test — warm caches give false passes), heavy runs watchdog-guarded
(`make guarded`).

1. **`sameline` lexer property** — additive, byte-identical (diff-test-gated).
2. **SrcPos side-table capability** — the highest-leverage unblock. Executor+emit
   lockstep write `record_pos` entries byte-identical to `parse_statement_list_ids`.
   Gate: the **recovery-tree differential + targeted negative tests**
   (`error_recovery_differential_test.av`) — NOT diff-test, which does not cover
   diagnostics of valid programs' positions the way it covers IR.
3. **Spend SrcPos on control-flow leaves** — migrate `while` first
   (`"while" expr block` — no else/newline traps), delete `parse_while_stmt`; then
   `block`/`for`/`if`.
4. **`@try`-with-builds** — extend bounded speculation to carry `-> build`; spend
   on paren/tuple/lambda, list, component-vs-expr.
5. **Finish mode-threading** (`@when` over the remaining modes) — spend on the
   postfix chain + remaining primaries.
6. **Phase 4 (t-47hc.5)** — delete Parser A (hand RD driver + `advance_token`),
   keep only as a differential-oracle build.

## On closing t-47hc.2 (the lexer)

Correct and **orthogonal** to `@hand`. The lexer has zero `@hand` (`@hand` is a
parser mechanism). Phase-1 generation is genuinely complete; the lone residual
(delete `advance_token`) is real Phase-4 work coupled to Parser A's deletion, not
a frozen `@hand`. Closing t-47hc.2 freezes nothing.

## The one number to watch

`@hand` leaves remaining → 0, and Parser A deleted. Nothing else is the finish
line.

**Read it with `bash scripts/diagnose.sh --hand-leaves`, not by grepping.**
`avra_grammar.av` holds the production grammars AND the family-ISOLATED §2 views the
equivalence tests use (`avra_program_grammar`, `avra_stmt_grammar`, …). A leaf that
appears only in an isolated view is not on the compiler's path and is not remaining
work — `let_stmt` is exactly that, and it inflated the reported count by one until the
mode existed. The honest source is the checked-in generated parsers: whatever they call
through `run_hand_stmt`/`run_hand_expr` is, by construction, what production routes to.

Not every leaf at 0 is reachable by nativisation, and pretending otherwise would be
dishonest bookkeeping:
- `match_table` — the rows of `match e table { … }` must supply exactly as many values
  as the header row declared. Data-dependent, so not a grammar rule at ANY level of DSL
  power. This one is retired by deleting the CONSTRUCT or by accepting a hand leaf, not
  by a better grammar.
- `primary_base` / `postfix_suffix` — the bridge into Parser A. They die WITH Parser A
  in Phase 4, not before.

## `@cut` landed; the residual `*_edge` leaves need ABORT, not commit (t-47hc.21)

`@cut` (the PEG commit point, #1018) resolves half of why `@hand(*_edge)` leaves
survive: a `@try` branch could not carry an `@expect`, because reporting the
message *is* the rollback signal. Past a `@cut` the branch is committed and owns
its diagnostics.

**It is not enough for `for_stmt_edge` / `match_stmt_edge`.** Measured, not
guessed: dropping the `@try` + `@hand` tail from `avra_stmt_dispatch_for_grammar`
(making it identical to the already-hand-free interpreter grammar) regresses the
recovery oracle on `impl for Foo { }` — hand yields `F0001 F0001 F0013` /
`(error)`, the static parser yields `F0001 F0040` and a runaway
`(for-in Foo (map ()) (block …))` that **swallows the following declaration**.

Root cause: both engines are error-TOLERANT. A failed required token reports and
**continues**, building a partial node. The hand parser instead `return .Err`s —
it **aborts** the rule and lets the statement-list loop synchronise. `@expect` is
report-and-continue, so it cannot express that; the `@hand` leaf exists purely to
own the abort.

**The missing primitive is `@require`** — the dual of `@cut`: a bare marker on a
terminal that, on failure, reports and aborts the rule instead of running the rest
of the sequence. It carries no message of its own; the diagnostic still comes from
the sequence's `@expect(tok, msg)`, so control flow and diagnostics stay separate
seams. Sketch:

- **emit** — natural: `if <guard> { advance } else { st.report(msg); return <error node> }`
  (the same error node emit already uses for "no branch matched", so no rule-kind
  threading is needed).
- **executor** — an `abort` flag on `CapEnv` (the `cut` precedent), checked by
  `exec_seq` after each item.
- **composition with `@try`** — an abort *before* a cut must degrade to a
  rollback (it reports, so the commit guard already fails); *after* a cut it must
  propagate. The emit side is the hard part: an early `return` inside a
  speculative branch bypasses the rollback, so the abort has to become a flag the
  branch tests rather than a raw `return`.

With `@require` + `@cut`, `for_stmt` splits cleanly into range and collection
branches, each owning its own missing-brace message (`expected `{` after for
range` vs `expected `{` or `..` after for expression`) — the exact reason
`for_stmt_edge` still exists.

### `@require` has landed; the `for_stmt` spend is one resync away

`@require` is implemented and specced (`require_abort_test.av`), and it FIXES the
runaway: with it, `for Foo { }` aborts on the missing `in` instead of parsing
`{ … }` as the collection and eating the next declaration. It is NOT spent yet,
because one recovery case still diverges.

On `impl for Foo { }` the hand oracle emits `F0001 F0001 F0013` and TWO nodes —
it resyncs past the bad `impl` header and re-parses `Foo { }` as a struct-literal
expression statement. The abort emits `F0001` and one node. So the residual gap is
not the abort itself but **where the caller resumes afterwards**: the hand
parser's `synchronize()` leaves the cursor somewhere the grammar path does not.
Closing it means matching that resync (very likely a `@recover(sync_to:)` on the
`for` branches), then re-running the recovery oracle. That is the whole remaining
distance to deleting `for_stmt_edge`, and `match_stmt_edge` follows the same
shape.
