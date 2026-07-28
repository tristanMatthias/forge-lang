# t-47hc Roadmap — retiring the hand front end

**Status: 2026-07-27. This is the ONE authoritative plan for t-47hc.** It supersedes the
planning content in every other doc listed under "Doc consolidation" below. If a claim
here disagrees with a ticket comment or a `.md`, this wins.

Estimates are in **slices**, not dates, with a measured hours-per-slice. Dates depend on
how many hours per day get spent; slices don't.

---

## 1. What "done" means

Phase 4's acceptance, unchanged:

> The generated parser is the sole production path; the hand RD parser and hand lexer
> exist only as an oracle build; `parse/mod.av`'s production surface shrinks by ~2,456
> lines.

The tracking metric is **`bash scripts/diagnose.sh --hand-leaves`** — currently **8**.
`wc -l parse/mod.av` does NOT move until the last leaf lands, because the leaves are
mutually recursive through the shared core. That is measured, not assumed:

| leaves removed | methods freed | lines freed |
|---|---|---|
| any ONE | 0–1 | 0–9 |
| **all EIGHT** | **81** | **2,456** |

Do not read a flat line count as lack of progress before the final slice.

---

## 2. Measured cost per slice

From four slices completed 2026-07-27 (#1032, #1033, the splice flip, and one failed
attempt), wall-clock including gates and one review round:

| slice type | measured | notes |
|---|---|---|
| capability, landed dormant | **1.0–1.5 h** | #1033 was 1.0h; #1032 was 1.5h with 3 review bugs |
| production flip | **1.5–2.5 h** | splice flip was 2.5h *including* a failed attempt + diagnosis + revert |
| gates alone, per slice | **~40 min** | build-quick 8m, emit-gen-check 13m, diff-test 12m, targeted tests 5m |

**The gates are ~40 minutes of the cost and are not optional.** Three separate incidents
this session shipped green through `build-quick` + `--emit-gen-check` + `diff-test` while
being broken, because none of those cover the comptime path.

**Assume 1 failed attempt per 3 flips.** That is the observed rate, and it is priced in
below rather than treated as bad luck.

---

## 3. The plan

Each leaf needs a capability (landed dormant, byte-identical) then a flip (spends it,
deletes the `@hand`). Some share capabilities. Order is forced by dependencies, not
preference.

| # | slice | capability needed | leaves after | est. |
|---|---|---|---|---|
| ✅ | `x{#cap}` bounded repetition (#1032) | — | 8 | done |
| ✅ | `@when(in_quote_body)` + predicate validation (#1033) | — | 8 | done |
| ✅ | `@peek(ident_lbrace)` | — | 8 | done |
| ✅ | **splice goes native** | spends `in_quote_body` | 8 | done |
| 1 | `@when` over the postfix BASE (t-47hc.30) | new — reads `st.postfix_base` | 8 | 1.5h |
| 2 | **`postfix_suffix` flip** | spends #1 | **7** | 2.5h |
| 3 | scoped COUNTER mode (`@on`/`@off` on an int) | new | 7 | 1.5h |
| 4 | **`quote_expr` flip** | spends #3 | **6** | 2.5h |
| 5 | gensym counter on PState | new | 6 | 1h |
| 6 | **`if_expr` / if-let flip** (t-47hc.26) | spends #5 | **5** | 2h |
| 7 | feature-parser SEAM: fn over parse state, not `impl Parser` | new — architectural | 5 | 3h |
| 8 | **`ident_primary` flip** (t-47hc.27) | spends #7 | **4** | 2.5h |
| 9 | fragment REGISTRY for decl keywords | spends #7 | 4 | 2h |
| 10 | **`decl_hand` flip** | spends #9 | **3** | 2.5h |
| 11 | **`match_table` flip** (t-47hc.29) | spends `x{#cap}` + #12's cells | **2** | 2.5h |
| 12 | **`match_expr` table form** | spends #11 | **1** | 1.5h |
| 13 | **`primary_base` deletion** — the alternation's TAIL, so it goes LAST | none (see below) | **0** | 2h |
| 14 | **delete the hand core** — driver + lexer to an oracle-only build | — | 0 | 3h |

**Subtotal: ~32 h.** Plus the observed 1-in-3 failure rate on flips (7 flips remain →
~2 extra attempts at ~1.5h) = **~35 hours of engineering.**

At the hourly routine's rate — roughly one slice per 2 firings, allowing for container
restarts and review rounds — that is **3–4 focused working days**, or about **2 weeks
of background grinding** at the current cadence.

### The commitment

- **Slice 2 drops the count to 7.** The first visible movement is one capability + one
  flip, ~4 h — the count does not move on slice 1, which is a dormant capability.
- **Slices 1–6 (≈12 h) get to 5 leaves.**
- **Slices 1–13 (≈29 h) get to 0 leaves.**
- **Slice 14 (3 h) is the payoff**: the ~2,456 lines delete in one commit.

### What could break the estimate

Named honestly, because two earlier estimates on this ticket were both wrong in the same
direction:

1. **Slice 10 (the seam) is the one real design step**, not a mechanical edit. It is the
   only line item where 3h could become 8h. Everything else is a known shape.
2. **The TAIL-ROLE constraint (measured 2026-07-28, and it set the order above).**
   A rule's LAST `@hand` branch is emitted **unguarded** — deliberately: it owns error
   recovery for every token no earlier branch matched (`emit.av` ~585, and the comment
   there says guarding it "would divert a stray token (e.g. `* 5`) to a DSL error
   instead of the hand parser's recovery — the recovery-tree oracle's exact catch").
   That role is **positional, not intrinsic**: deleting the current tail silently
   promotes whichever branch is now last into a job it was not written for. Measured on
   `unary` — removing `@hand(primary_base)` promotes `@hand(ident_primary)`, and
   `* 5` becomes `undefined variable *` (F3000); recovery goes 41/41 → **26/41**.
   Consequence: **within an alternation, the tail leaf is deleted LAST.** Once every
   other `@hand` in that group is gone the last branch is native, emit's FIRST-guarded
   + existing no-match-error path applies, and no new capability is needed. Per-slice
   check: after any deletion, read the regenerated rule's tail and confirm no other
   `@hand` got promoted — one grep.
3. **The comptime path has no differential oracle.** Every flip touching quote/splice/
   macro-adjacent code risks a `value_to_expr_node` shape mismatch that only the
   `features/quote_expr/tests` and `std-cli/cmdgen` suites catch.

---

## 4. Per-slice gate list — MANDATORY, in order

```shell
make build-quick
bash scripts/diagnose.sh --emit-regen-{expr,stmt,decl,pat,type}   # and READ the diff
bash scripts/diagnose.sh --emit-gen-check                          # GENPASS, ~13 min
cd packages/std-avrac && AVRA_USE_METADATA=1 AVRA_LIB_PKG_ROOT='@std::avrac' \
  ../../build/bs2 compile --emit_metadata --module_path='@std::avrac' src/avrac.av
./build/bs2 test packages/std-avrac/src/features/grammar/tests/grammar_ambiguity_guard_test.av
./build/bs2 test packages/std-avrac/src/features/grammar/tests/error_recovery_differential_test.av
./build/bs2 test packages/std-avrac/src/features/quote_expr/tests/          # if quote-adjacent
make guarded CMD="make diff-test PREBUILT=1" FLOOR=5500
```

**Never run `make test` / `make sweep` / `--rc-strict-suite`** — they OOM the ~15 GB box
and kill the container.

**Regenerating is part of the flip, not an afterthought.** A grammar edit alone changes
only the interpreter oracle; production compiles the checked-in generated parser. A
diff-test run before `--emit-regen-*` is measuring the OLD production path and will say
byte-identical when nothing has actually flipped. This bit once already.

---

## 5. Doc consolidation

The planning content is scattered across too many files. **This doc is the plan.** The
others keep only their non-overlapping role:

| file | keep for | planning content |
|---|---|---|
| `docs/2026_06_14_GRAMMAR_DSL.md` | the DSL's syntax + semantics reference | superseded |
| `docs/2026_06_14_AST_SOURCE_OF_TRUTH_EPIC.md` | the original vision + rationale | superseded |
| `bootstrap/docs/2026_07_24_ZERO_HAND_PLAN.md` | — | **fully superseded by this doc** |
| `features/grammar/README.md` | how to validate a leaf migration (the gate order) | keep, it is operational |
| `features/grammar/GNARLY_CATALOGUE.md` | the catalogue of hard parses | keep, it is reference |
| ticket `t-47hc.5` comments | the decision log / archaeology | keep, but this doc is the plan |

Rule going forward: **plans live here, decisions live in ticket comments, reference lives
next to the code.** No new planning `.md` files for this epic.

---

## 6. Decisions already settled — do not relitigate

- **"Invert the recursion"** (leaf calls back into the generated parser) was tried as
  Slice 5.1 and reverted: it left 18 orphan `Stmt.Error` nodes for one 2-deep nested
  error, because each nesting level got its own diagnostic bag and re-parsed the
  malformed subtree. The bag is the hard part, not the recursion.
- **"Phase 4 is structurally impossible"** was wrong. It rested on attributing
  `parse_table_literal`'s row-width check to the `match_table` leaf, which has no such
  check — its cell loop is `while i < value_count`, a bound. `x{#cap}` expresses it.
- **One big PR** is not on the table. The splice flip broke quote lowering in a path
  `diff-test` cannot see; it was found in two minutes because the diff was three lines.
  Batched with six other leaf migrations it would have been unattributable.
- **Merging**: when CI is green and CodeRabbit has approved (every review THREAD
  resolved — check `get_review_comments`, not the pre-merge summary), merge without
  asking. Standing user directive, 2026-07-27.
