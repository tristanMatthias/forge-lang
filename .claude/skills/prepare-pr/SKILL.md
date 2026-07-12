---
name: prepare-pr
description: Exhaustive, multi-round checklist to take a feature branch from "tests pass" to "genuinely PR-ready" for the Avra bootstrap compiler. Use before opening or finalizing a pull request — it runs aggressive red-team rounds over tests AND logic, multiple DRY/centralize passes, a beauty review, a deep "use the language" review, a ticket-reference scrub, diff hygiene, docs, and the hard final gates (full suite + selfhost fixed point). Invoke when the user says "prepare a PR", "is this PR-ready", "clean this up for review", or after a feature lands and before it ships.
---

# Prepare PR

Getting tests to pass is ~30% of the work. This skill is the other 70%: the
disciplined, *iterative* passes that turn working code into code that reads
like the language was designed for it, has no hacks, no ticket cruft, and
cannot regress silently.

## Operating principles (read first)

- **Multiple rounds, not one pass.** Each section below says "round 1 / round 2 / …" for a reason. One sweep finds the obvious stuff; the third sweep finds the bugs and the duplication that hide behind the obvious stuff. Do not collapse rounds.
- **Zero tolerance for "good enough."** Every CLAUDE.md ABSOLUTE RULE applies here: no hack survives a commit (rule 14), no workaround (rule 4), no "known limitation" for a bug (rule 2), fix the foundation not the symptom (rule 16).
- **No workarounds, no building on sand.** This is the load-bearing principle and it gets its own gate (Phase 1). If the layer beneath you is wrong, you fix *it* before building on top — you never route around it, special-case past it, or pile a second layer on a broken first one. A PR that ships a feature by stepping around a foundational gap is not ready, no matter how green the tests are.
- **Fix-or-file, never skip.** Anything you find and don't fix in this PR becomes an Agent Tasks ticket *now*, with a real priority. "I'll come back to it" is banned.
- **Commit each pass separately.** Perf fixes, DRY consolidations, and red-team fixes each land as their own commit so a reviewer can verify them independently.
- **The diff is the deliverable.** A reviewer reads the diff, not your intent. Every line must justify itself.

This skill drives toward a hard terminal state (Phase 9). You are done when every box is checked, the full suite + selfhost are green, and the branch is pushed and clean.

---

## Phase 0 — Scope & baseline

1. **Pin the diff.** Establish the review surface against the real base branch:
   ```bash
   BASE=$(git merge-base HEAD origin/feat/crafting-intepreters)
   git diff --stat $BASE..HEAD
   ```
   Everything below operates on *this* diff. Skim it once end-to-end before touching anything — you cannot clean what you haven't read.
2. **Confirm the ticket is 100% done** (CLAUDE.md rule 19). Re-read every Agent Tasks ticket this PR claims to address. If any described work is partial, it is NOT ready — finish it or split the ticket. "Partially done" is not done.
3. **Confirm the branch is rebased on fresh upstream.** A stale base hides conflicts and review noise:
   ```bash
   git fetch origin && git log --oneline origin/feat/crafting-intepreters..HEAD
   ```
   Only your commits should appear. If upstream moved, rebase first.
4. **Capture a GREEN baseline** before you start changing things, so any breakage during cleanup is attributable:
   ```bash
   cd bootstrap && make test   # spec suite + selfhost fixed point
   ```
   Record the pass count and that the fixed point holds. This is your regression oracle.

---

## Phase 1 — Foundation & workaround audit, then correctness

This is the gate that outranks all the others. A beautiful, well-tested, DRY
feature built on top of a workaround is still a workaround. Do this before
polishing anything.

### 1a — No workarounds, no building on bad architecture

Interrogate the diff with the assumption that you took a shortcut somewhere
and have to find it. For **every** change, ask:

- **Did I route around a problem instead of fixing it?** A special-case to dodge a failing path, a second code path that duplicates a broken first one, a value massaged into shape downstream because the upstream producer is wrong — all workarounds. Fix the producer.
- **Did I build on a foundation I know is wrong?** Extending a string-typed registry, an `i64` fallback, an untyped/`Unknown`-typed slot, a stringly-matched dispatch, or any layer CLAUDE.md already calls debt (rule 16) — that is building on sand. If you leaned on a broken foundation, stop and fix the foundation *in this PR* (or, if genuinely out of scope, in a prerequisite PR that lands first — never "later").
- **When I hit a missing feature mid-task, what did I do?** The rule (CLAUDE.md "Build What You Need", rule 16) is: STOP and implement the missing piece first. If instead you deferred, stubbed, or hacked a substitute, that substitute is the bug. (The canonical *good* example: hitting a quote-splice gap and fixing the splice foundation before writing the macro — not generating source strings to dodge it.)
- **Did I add a C-side shim to bypass a codegen bug?** Banned (rule 6). Fix the codegen.

Grep the diff for the tells, and treat each as guilty until proven innocent:
```bash
git diff $BASE..HEAD | grep -nEi 'hack|workaround|for now|temporar|kludge|bypass|good enough|figure (this|that) out|revisit|come back|hard-?cod'
```
Also hunt the structural tells (no keyword to grep — you have to read for them):
- A `?? <default>` or `catch { … }` that masks a real failure instead of handling a real case.
- An empty arm `_ -> {}` / `-> {}` silently swallowing behavior.
- A name- or string-match heuristic standing in for a real type/structural check (rule: no brittle heuristics).
- A new parameter / flag added solely to thread around an abstraction that should have been changed.
- Duplicated logic created *because* the shared path was inconvenient to fix.

**For each finding: fix the root cause now, or — only if truly out of scope — file an Agent Tasks ticket AND make sure this PR does not silently depend on the unfixed gap.** "It works around it for now" is not an acceptable end state (rule 14: no hack survives a commit).

### 1b — Correctness (the logic itself)

Re-derive from the spec (`docs/2026_04_18_FULL_SPEC.md`) what the code should do, and verify it does. Then hunt the project's documented **silent failure modes** (CLAUDE.md "Silent Failure Modes") across the diff:
- **Wrong return type** — `return r` returning the inner value instead of the `Result`/wrapper. Grep every `return` in refactored files.
- **Dropped generic args** — parser consumed `<...>` without parsing inside. Render the AST and verify.
- **Monomorphizer "first match wins"** ambiguity when multiple instantiations exist.
- **-O0 works, -O2 crashes** — alignment/LLVM-type inconsistency.
- **Empty match arms** `-> {}` silently swallowing behavior — grep the diff for `-> {}`.
- **Seed contamination** — `git diff seed/seed.ll` must be clean unless you intentionally cycled it.
- **New mutable globals** — `export mut` is banned (rule 17). Thread state through `Ctx`/params.
- **Raw errors** — no `eprintln` for errors; everything through `CompileError` with a specific F-code in the right range (no `Other`).
- **Memory** — rc leaks (cycle analysis on Tuple/Union/List element types), escape analysis, Drop/defer/errdefer LIFO ordering.

For each issue: fix now, or file an Agent Tasks ticket with repro.

---

## Phase 2 — Test red-team (MULTIPLE ROUNDS)

The bar is not "tests pass." The bar is "these tests would *catch* the bug if it came back." Every test lives in `tests/*_test.av` as `spec`/`given`/`then`.

- **Round 1 — coverage exists & asserts.** Every new code path has a test that asserts something *specific* (not a smoke test). No path ships untested.
- **Round 2 — edge battery.** One test each: empty (`[]`, `""`, empty body, no annotations), single-element (off-by-one), deeply nested (recursion depth), boundary (`0`, `-1`, INT_MAX), `null` / nullable, reserved-keyword collisions, non-ASCII / quoted / escaped strings.
- **Round 3 — combinatorial matrix.** Exercise the feature crossed with: closures, `match`, nullable, if-expr, structs, enums, loops, `|>`, templates, lists, maps, `with`, `defer`, generics, `dyn Trait`, and nested combinations. The combinatorial cases find the real bugs.
- **Round 4 — negative / error-path tests.** Compile-error tests via `avra_shell_exec("./build/bs2 compile …")` from a `spec` block, asserting the exact F-code in the captured output. Failure is a feature; test it.
- **Round 5 — mutation check.** For each new test, briefly break the implementation and confirm the test FAILS, then revert. A test that passes against broken code is not a test.
- **Round 6 — isolation & determinism.** Run each new test file alone (`./build/bs2 test <file>`) AND in the bundled suite. If a result differs, you have an ordering / global-state leak — fix the leak (do not paper over it). No flakes; flakes are bugs.
- **Round 7 — stress & guards.** A program exercising the feature 1000+ times still compiles in reasonable time with correct output. Any path that runs user-supplied code (comptime fns, macro expansion) has a depth/iteration guard — test it triggers cleanly.

---

## Phase 3 — Perf pass (MULTIPLE ROUNDS)

Run the full performance contract from
`.claude/skills/cleanup-epic-children/cleanup_pass_1.md` over every new code
path (complexity audit, allocation audit, hot-path fast-paths, empty-input
short-circuits, pre-built state, bypass abstraction overhead, mature
compiler techniques). Do not restate it — that file IS the bar.

PR-specific additions:
- **Measure before/after** (test count, build wall-time, output IR line count, allocation count where observable). Numbers in the commit message.
- **No quadratic surprises** in the diff: string concat in a loop, linear scan that should be a `Map`, re-resolving already-resolved data through a generic interface.
- **No unbounded recursion on linked lists** (`StmtList`/`ExprList` walkers) — deep inputs must not stack-overflow.

---

## Phase 4 — DRY / centralize (MULTIPLE ROUNDS)

Run the full DRY + readability contract from
`.claude/skills/cleanup-epic-children/cleanup_pass_2.md` (duplication audit,
use-the-language, beauty, centralize, missed-abstraction audit, consolidate
similar APIs, eliminate redundant types, doc accuracy, API surface). That
file IS the bar.

**Do the consolidation in this PR — never file a DRY ticket to defer it.** The
only exception is a consolidation the bootstrap genuinely blocks now (e.g.
seed-gated: it needs a fix that isn't in the seed yet); say so in the PR body
and do it the moment the seed advances — don't open a ticket.

- **Round 1 — intra-file** duplication → extract local helpers.
- **Round 2 — cross-file / cross-module** near-duplicates → extract the shared helper now (don't file it for later).
- **Round 3 — API consolidation** — `has_X` / `find_X` / `count_X` share one underlying walker (wrappers fine).
- **Round 4 — redundant types** — collapse near-duplicate structs/enums; name collisions confuse both the resolver and the reader.
- **Round 5 — constants** — no magic strings/numbers; centralize. F-codes, mangling separators, sentinels live in one place.
- **Round 6 — duplicate pipeline paths** — the project has known twin paths (e.g. `emit_statement` exists in both the feature path and the inline path). If you touched one, the other must stay in sync.

---

## Phase 5 — Beauty assessment

Code is read 10× more than written, and this project explicitly wants it
*clean and declarative — not terse, not ugly, not functional-duct-tape*.

- **Names tell a story.** A reader skimming function names understands the file. Kill `do_thing_2`, `helper3`, `process`, `inner`, `tmp`.
- **One screen per function** (~30 lines). Past that, extract named sub-pieces.
- **Top-to-bottom readability** — early returns for edge cases, variables introduced near use, no mental rewinding, no deep nesting.
- **Declarative over imperative-soup AND over fp-soup.** Neither a pyramid of mutation nor a chain of `.map().filter().fold()` threading state by hand. Prefer the construct that names the intent.
- **Match the surrounding style.** Iterative-vs-recursive, naming, comment density — be locally consistent.
- **Naming conventions** (spec Axis 28): PascalCase types, snake_case fns/vars, SCREAMING_SNAKE constants. Check `bs2 build` warnings for `F9003`.
- **Comments explain WHY, not WHAT.** Every new file has a WHY header. Prune any stale comment — a comment that lies is worse than none.

After this pass, re-read each changed function and ask: *would I be proud to show this on a screen in a review?* If not, rework it.

---

## Phase 6 — Use the Avra language (DEEP)

For every helper in the diff, ask: *did the language already give me this tool?*
Functional-duct-tape (helpers threading state through recursion) is the canonical
thing to replace. Walk the whole inventory — do not stop at the first hit:

- `match` (exhaustive) instead of `if`/`else` chains; guards, or-patterns, nested patterns, destructuring, subjectless `match`/`when`.
- **Remove wildcards** `_ ->` in exhaustive-enum matches (epic `vndt`) — name every variant so new variants force a compile error.
- Nullable `T?` with `?.` optional chain, `??` null-coalesce, `?` propagation — instead of hand-rolled null checks.
- `Result<T, E>` with `?` and `catch { default }` — instead of manual error threading and sentinel returns.
- `|>` pipe; `with` struct update; `is` type check; `in` membership.
- List comprehensions; closures `(x) -> …` with the `it` pronoun.
- **Enums / union types** instead of stringly-typed dispatch (the canonical anti-pattern).
- **Traits / generics / `dyn Trait`** instead of duplicated near-identical code.
- `defer` / `errdefer` for cleanup (LIFO); `Drop` for resource types.
- **Newtype wrappers** (`type UserId = UUID`) for nominal type safety where a bare primitive is passed around.
- String interpolation `"{expr}"`, multiline `"""…"""`, raw `r"…"`.
- **Components / declarative blocks** and **`@derive` / `@expand` macros** for boilerplate that's currently hand-written.

**Dogfood (CLAUDE.md Phase 6).** If this PR adds a *new* language feature or helper, grep the bootstrap source for existing code that should now use it, and refactor at least the clearest sites (update seed if needed, re-run `make test`).

---

## Phase 7 — Ticket-reference scrub

Code, comments, and tests must read as evergreen — a contributor six months
from now has no access to today's ticket context.

```bash
git diff $BASE..HEAD | grep -nE 'forge-crafting-intepreters|vez6|swgx|qa6i|fwyx|TODO\(|FIXME|XXX|Phase [0-9]|ticket' 
```
For each hit in **code / comments / test names / docstrings**:
- Rewrite it as a durable explanation of the *reason* (the WHY the ticket captured), or delete it.
- Bad: `// vez6.4.4: splice the name`. Good: `// Inside a quote, ~ident defers the name to expansion time.`
- **Keep** stable identifiers: F-codes (spec contract), spec axis references, RFC/standard names.
- **Commit messages and the PR body MAY cite tickets** — that's their job. The *source tree* must not depend on them.

Also scrub:
- The configured **model identifier** must appear in **no** artifact (commit, PR body, comment, code) — chat only.
- No author names, machine paths, or `/tmp/...` fixture paths baked into committed code.

---

## Phase 8 — Diff hygiene

Read the **entire** diff line by line one more time:
- **No debug instrumentation:** `eprintln` traces, `avra_trace_*`, `avra_cg_trace_*`, `AVRA_*` debug env toggles left on, stray `println` debugging.
- **No commented-out code, no dead code, no orphaned helpers** (search for now-unreferenced fns you left behind).
- **No unrelated/accidental changes** — every hunk maps to the PR's purpose. Revert drive-by edits or split them out.
- **No build artifacts or junk:** `build/`, `*.ll`, `*.meta.bin`, cache dirs, editor files, `/tmp` fixtures. Confirm `.gitignore` covers them.
- **Unused imports** (`F9002`) and **unused vars** (`F0801`) cleared — check `bs2 build` output.
- **Task state** recorded in Agent Tasks (`mcp__Agent_Tasks__*`) if any ticket changed.
- **Seed** (`seed/seed.ll`) only changed if you intentionally cycled it, with the cycle documented.

---

## Phase 9 — Docs & final gates (the hard bar)

**Docs:**
- `///` docstring on every exported fn/type; the header WHY comment on every new file is accurate to current behavior.
- New language feature → `src/features/<name>/grammar.md`.
- Completed a ticket → update `docs/TRD_V1.md`.
- Changed a workflow/gotcha → update `CLAUDE.md`.
- Every error this PR can emit is actionable, cites a source location, and suggests a fix (compare to existing F-coded errors).

**Gates (all must hold):**
```bash
cd bootstrap && make test        # spec suite green AND selfhost fixed point byte-identical
```
- Warning count did not regress (`bs2 build` / `make build`).
- Agent Tasks tickets: close only what is 100% done (rule 19); never close a parent over open children (rule 20); cleanup children addressed or filed.
- Commits are conventional and clear (`feat:` / `fix:` / `chore:`), each cleanup pass its own commit, messages end with the required session link.
- Branch rebased on fresh base, **pushed**, and `git status` shows "up to date with origin" with a clean tree.
- PR body (only when the user explicitly asks for a PR): what + why, linked issues, test evidence/output, no model identifier.

---

## Phase 10 — Adversarial self-review

Final step: stop being the author, become a hostile reviewer.
- Where would you attack this PR? What is the weakest test, the ugliest function, the path most likely to regress?
- Would a brand-new contributor understand each changed file *without* the ticket?
- Is there ANY hack, workaround, or "good enough" left? (rule 14 — none may survive the commit.)
- Did you file a ticket for every smell you found and didn't fix? (rule 19 — the third smell you skipped must be tracked.)

If any answer is uncomfortable, you are not done. Loop back to the relevant phase.

---

## Anti-patterns this skill exists to prevent

- Shipping the happy path and calling it done (Phase 2 exists because 90% of bugs live in the other 90% of inputs).
- Cumulative duplication ("I'll DRY it when there's a third user" — the third never comes).
- Ticket-ID cruft calcifying into the permanent source tree.
- Functional-duct-tape where a trait / enum / component / macro was the right tool.
- Closing a ticket with a passing test but an un-dogfooded, un-cleaned, un-documented implementation.
- Treating "tests pass" as the finish line instead of the starting line for this checklist.
