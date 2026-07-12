# Retro — xm2g Phase 2 (F1202 `?`-split) finalize + prepare-pr ×3 + error-handling design

**Date:** 2026-06-08
**Scope:** finishing `xm2g.3` (Phase 2 of the Nullability/Option epic), shipping it
via PR #16, three prepare-pr passes, and a long error-handling design session that
produced `docs/2026_06_08_ERROR_HANDLING_EPIC.md`.
**Audience:** the next session (likely `xm2g.4`+). Read this before you start.

---

## 0. TL;DR — the five things that cost the most time

1. **Container reclaim silently reverted the working tree** (twice — once to Phase 0,
   once to a stale `slice/xm2g.2`), and **deleted an uncommitted design doc**. The single
   biggest time sink and the only *irreversible* one (had to rebuild the doc from chat).
2. **LLVM 18-vs-20 toolchain mismatch** — cold builds failed cryptically; I misdiagnosed it
   for several cycles before the real cause surfaced (`diagnose.sh` falls back to llvm-18 on
   Linux; llvm-18 rejects the `nuw` GEP flag the compiler emits). Filed `3jcq`.
3. **`make test` is 360–414s warm, >600s cold, and OOM-flaky** (one run jetsam-killed 76
   shards and retried). Every quality gate was a 5–7 min stall.
4. **(Resolved) Issue-tracker export churn** — the tracker's JSONL export kept getting
   swept into PR diffs. Since fixed: task tracking moved to the Agent Tasks MCP.
5. **The stale-`bs2` trap + build-cache false failures** — a "regression" that was a cache
   artifact, and a build that silently re-linked the old binary. Documented in CLAUDE.md, but
   still cost a stash/clear/rebuild dance to prove innocence.

Net: the *actual code work* (a DRY consolidation, a test, a null→none sweep, two design docs)
was maybe 20% of wall-clock. The other 80% was environment, toolchain, test latency, and
bead/git bookkeeping.

---

## 1. Environment & infrastructure — the biggest pain

### 1.1 Container reclaim wipes uncommitted work (CRITICAL)
- The tree reverted to old checkpoints mid-session at least twice with no warning. Once it
  reverted to a Phase-0 commit; once to `slice/xm2g.2` (and a stash of "reset-container cruft").
- **It deleted `docs/2026_06_08_ERROR_HANDLING_EPIC.md`** — a ~790-line doc that existed only
  in the working tree because the user had said "forget git for now." I'd *explicitly flagged*
  that risk multiple times and still lost it; had to reconstruct from conversation history.
- The pushed compiler work (`slice/xm2g.3`) was always safe on origin — only the working tree
  and local-only branches were affected.
- **Lesson / rule for next time:** treat the working tree as volatile across turns. Commit any
  valuable artifact (design docs, notes) to a branch *immediately*, even mid-discussion. "Don't
  nag me about git" is about the PR cruft, not about losing a doc — persist real artifacts
  proactively and say so.
- **What would fix it at the platform level:** snapshot uncommitted changes before reclaim, or
  a loud pre-reclaim warning, or auto-stash-to-a-ref. Right now reclaim is silent and lossy.

### 1.2 LLVM toolchain detection is broken on Linux (filed `3jcq`, P1)
- `scripts/diagnose.sh` hardcodes macOS Homebrew paths (`/opt/homebrew/Cellar/llvm/20.1.5`,
  `/opt/homebrew/opt/llvm`). On the Linux container neither exists, so it falls through to
  `command -v llc` → `/usr/bin/llc` → **llvm-18**.
- The compiler emits LLVM-19+ IR (`getelementptr inbounds nuw …`); **llvm-18's `llc` rejects
  the `nuw` GEP flag** with a misleading `error: expected type`. Cold-cache `make build-quick`
  fails; warm builds that reuse cached `.ll`/objects "work," which masks it.
- **I misdiagnosed it badly:** chased an unsanitized `<Sym>` in a quoted type name (red herring
  — quoted `<…>` is legal), then finally did a 4-line minimal `llc` repro that isolated `nuw`,
  then the user told me "you should be using llvm 20."
- **Workaround used everywhere after:** prefix every build/test with
  `LLC=/usr/bin/llc-20 LLC_PREFIX=/usr/lib/llvm-20 LLVM_PREFIX=/usr/lib/llvm-20`. Verbose and
  easy to forget; forgetting reintroduces the failure.
- **Lesson:** **do the minimal toolchain repro FIRST** when a build fails in a way that smells
  like codegen but touches unrelated files. And in the next session, **export the LLC env once
  at the top** (or fix `3jcq`) before any build.

### 1.3 Stop-hook nags every turn about uncommitted changes
- The reverted-container cruft kept the tree dirty, so the git-check stop-hook fired on nearly
  every turn. It created steady pressure to commit things that *shouldn't* be committed (stale
  reverts), which is the opposite of helpful. I held the line, but it's noise.

### 1.4 Commits show as "Unverified"
- The SSH signing key is a 0-byte placeholder, so every commit is unsigned/unverified on GitHub.
  Cosmetic, but worth knowing it's the environment, not fixable from here.

---

## 2. Build / test loop — the second biggest

### 2.1 Full `make test` latency dominates iteration
- 360–414s warm; **>600s cold** (killed at timeout repeatedly). Each gate = one coffee.
- Under memory pressure the parallel shard runner **jetsam/OOM-killed shards** (one run reported
  "retrying 76 jetsam-killed shard(s)"). It recovers via retry but adds minutes and noise.
- The seed cycle (`make update-seed`) is another ~60–90s, required for any change that alters
  emitted IR.
- **Practical loop that worked:** isolate with `./build/bs2 test <one_file>` (≈15s), use
  `FILTER=<substr> SKIP_SELFHOST=1` for a feature area, and run the full gate **once** at the
  end. Never re-run the bundled suite "to see if it flaked."

### 2.2 The stale-`bs2` trap (documented, still bit me)
- Editing a non-entry source file can re-link the *previous* `bs2` (compile cache keys on the
  entry file). Behavior silently doesn't change. The force-rebuild incantation
  `rm -rf packages/cli/src/build/cache && rm -f build/bs2 && make build-quick` is mandatory after
  editing `parse/`, `codegen/`, etc. Tickets `pdme.1`/`6cks` track the root cause.

### 2.3 Build-cache false failures
- After a cleanup pass a test "failed," I stashed → it passed → unstashed + cleared all caches →
  it passed again. The failure was a **cache artifact from killed cold-cache runs**, not a
  regression. Cost a full diagnostic detour. **Lesson:** when a failure appears right after
  cache-clearing churn, suspect the cache before the code.

### 2.4 `bs2 run` ≠ native execution
- `./build/bs2 run x.av` uses the **eval interpreter** and printed `null` for `println("hello")`
  — it does not run the compiled native program. Native run is `bash scripts/diagnose.sh --run
  x.av` (which compiles + links + executes, but rebuilds `bs2` each time). I burned a couple of
  cycles before finding this. There is **no fast, obvious, native single-snippet runner.**

### 2.5 "Does my edit need a reseed?" is manual reasoning
- A codegen-logic change → reseed (IR changed). A comment scrub or `null`→`none` swap → **no
  reseed** (identical AST/IR). I had to reason this out each time and verify with a clean seed
  diff. A tool that says "this edit is IR-neutral" would remove a recurring judgment call.

---

## 3. Issue-tracking (resolved)

The old tracker's JSONL export churned PR diffs and created a dual source of truth
(DB vs committed export) — a constant manual fight to keep PR diffs clean.
**Resolved:** task tracking has since moved to the Agent Tasks MCP — no committed
export, no diff churn.

---

## 4. Compiler / codebase architectural limitations (the deep ones)

### 4.1 No bidirectional type propagation into literals (filed `uyao`, P1) — the real bug
- `emit_list_lit` infers element type **bottom-up from the first element** and pushes elements
  raw; it never receives the *expected* element type. So `let xs: List<int?> = [0]` does **not**
  box the `0`, and `Some(0)` aliases `none` inside collections (`xs[0] == none` is wrongly true).
- The spec wants **local + bidirectional** typing (Axis 1), but codegen's `ctx.emit` is purely
  bottom-up — the expected type isn't threaded down. This blocks correct collections-of-optionals
  and is a whole *class* of coercion gaps, not a one-off.
- A localized "widen across elements" patch would be a brittle heuristic (fixes `[0, null]` but
  not annotated `[0]`), so I filed it instead of hacking. **A proper fix = thread expected types
  into literal/expression codegen.** Whoever does Phase 4 gating will likely need this.

### 4.2 Map `[]`-read ICEs for any value type
- `Map<K,V>["k"]` raises `F9999` "indexing on non-string/list value" — codegen only implements
  `[]` read for string/list. Pre-existing, unrelated to optionals, but it means map-of-optional
  can't even be exercised. Worth a ticket if Phase 3/4 touches maps.

### 4.3 The parser's two-channel error design
- Migrated parsers return `Result<_, string>` where the string is a meaningless `"parse error"`
  sentinel; the *real* diagnostic goes out-of-band into a `DiagnosticBag` via `consume`/`set_error`.
- It works and reporting is good, **but the coupling is convention-only**: a bare
  `return .Err("parse error")` with no preceding `set_error` would be a *silent* failure. ~169
  hand-paired sites. The "record-and-abort helper" (`self.expect(tk, msg)?`) idea in the
  error-handling spec exists to make this safe; worth doing.

### 4.4 Monomorphizer ordering sensitivity
- CLAUDE.md documents "first match wins" mono ambiguity. My import reshuffle in the DRY pass
  perturbed compilation/instantiation order enough that the failure surfaced differently across
  builds — a reminder that mono order is load-bearing and fragile.

### 4.5 Self-hosting friction is inherent but real
- Any codegen change → 60–90s reseed + the bs2≡bs3 fixed-point dance. New keywords need a
  two-phase (types-only, then impl) bootstrap + `seed-patch-traps`. It's correct and necessary,
  but it makes the inner loop heavy; budget for it.

### 4.6 The `null`/`none` migration is half-done by design
- `none` is canonical; `null` is a deprecated alias kept through Phases 1–4 and removed wholesale
  in Phase 5 (`xm2g.6`). So the tree is in a **mixed state**: converting individual new lines
  creates local inconsistency (I hit this — converting one guard in a `null`-saturated function
  reads worse than leaving it). I converted only *this PR's* additions and left one site (`expand_macro`)
  matching its null-saturated function. **Phase 6 should do the wholesale grep-clean in one commit.**

---

## 5. My own process mistakes (honest)

1. **Rewrote the authoritative spec without sign-off.** During cleanup I noticed the April spec
   (Axis 10.5) still described the *old* unified-`?` and "fixed" it to match shipped F1202. The
   user pushed back ("you changed the spec?"). The spec update is explicitly **Phase 5 (xm2g.6)**
   work, not Phase 2. I reverted fully. **Lesson:** don't touch the authoritative spec on my own
   judgment, and don't pull a later phase's work into an earlier PR.
2. **Lost the design doc by deferring persistence.** I knew reclaim was a risk (said so repeatedly)
   and still left a 790-line doc uncommitted because of "forget git." Should have committed it to a
   side branch the moment it was substantial.
3. **Misdiagnosed the llc failure** — chased mangling before doing the 4-line minimal `llc` repro
   that would have isolated `nuw` immediately.
4. **Branch-switch fumble** — tried to commit the doc to the designated branch, but a dirty tree
   silently blocked the checkout and the commit landed on `slice/xm2g.2`; the `||` fallback masked
   it. Recovered with stash + targeted file checkout. **Lesson:** verify `git branch --show-current`
   after a switch that could be blocked by a dirty tree.
5. **Repeated Avra-syntax slips in throwaway probes** — wrote `;` separators (Avra has none) twice,
   and used the `v?` present-binding pattern that isn't implemented yet (Phase 3). Minor, but re-read
   the syntax before writing probes.
6. **Background-task sprawl** — spawned waiter loops that themselves got backgrounded; one `pkill -f
   'bs2 test'` killed my own shell (exit 144). Keep background jobs minimal and targeted.

---

## 6. What actually worked (keep doing)

- **Correctness probing > reading.** Two prepare-pr passes read the diff and found cleanups; the
  *third* pass wrote a cross-construct probe program and found a genuine bug (`uyao`) the reading
  passes missed. Probe the feature across match/closure/struct/list/pipe/`??` — that's where real
  bugs hide.
- **Mutation-checking new tests.** Flipping `optional_repr_tagged(Int)` to `false` and confirming
  exactly the 3 int-distinction assertions failed proved the headline test is a real oracle, not a
  smoke test. Do this for every new test.
- **Fix-or-file discipline.** Kept the PR scoped while losing nothing: filed `3jcq` (toolchain),
  `zuxz` (guard-decode swallow), `uyao` (list-optional boxing) instead of hacking or forgetting.
- **DRY consolidations were real.** Sharing `emit_if_optional_canon`, removing 8 redundant
  box/unbox guards — the compiler's own IR shrank ~516 lines and selfhost stayed byte-identical.
- **Doc-only commits for artifacts.** Once I started committing docs to their own commits on a
  branch, they were safe. The pattern (`git checkout <branch> -- <doc>; commit just that`) works.

---

## 7. Tooling wishlist (prioritized by pain ÷ effort)

1. **Fix `3jcq` first** (or `export LLC=/usr/bin/llc-20 …` at session start). Removes a whole class
   of cryptic build failures. Highest pain ÷ effort.
2. **A fast native single-snippet runner** — `avra eval-native <file>` that compiles+links+runs with
   correct toolchain detection and *without* rebuilding `bs2`. (`bs2 run` is the interpreter;
   `diagnose.sh --run` rebuilds.) This is the missing inner-loop tool.
3. **Memory-adaptive test parallelism** — auto-tune shard `jobs=` to free memory so we don't
   jetsam-kill 76 shards. And a reliable warm-cache fast path (per-file cache-miss bug `uzs9.1`).
4. **Platform: don't silently reclaim uncommitted work** — snapshot/auto-stash-to-ref or warn loudly.
5. **(Resolved) Tracker export hygiene** — the JSONL-diff churn is moot now that task
   tracking uses the Agent Tasks MCP (no committed export).
6. **An "IR-neutral edit?" oracle** — tell me whether an edit changes emitted IR (→ reseed) before I
   spend 90s finding out.
7. **Bidirectional type info in codegen** (architectural) — fixes `uyao` and a class of coercion bugs;
   needed anyway for Phase 4 gating.
8. **The `avra explain-failures` / failure-topology tooling** from the error-handling spec — would
   help an agent navigate the compiler's own error surface.

---

## 8. Handoff for the next (xm2g.4+) session

- **Toolchain:** export `LLC=/usr/bin/llc-20 LLC_PREFIX=/usr/lib/llvm-20 LLVM_PREFIX=/usr/lib/llvm-20`
  before any build, or fix `3jcq`. Otherwise cold builds fail on `nuw`.
- **State:** PR #16 merged → `origin/feat/crafting-intepreters` HEAD is the merge. Phases 0–2 done.
  The error-handling spec (`docs/2026_06_08_ERROR_HANDLING_EPIC.md`) and this retro are on that branch.
- **Test loop:** isolate with `./build/bs2 test <file>`; `FILTER=… SKIP_SELFHOST=1` for areas; one
  full gate at the end. Expect 6+ min and possible OOM-retry; don't re-run to "check for flakes."
- **Reseed rule:** logic/codegen change → `make update-seed`. Comment/`null`↔`none`/doc change → no
  reseed (verify with a clean `git diff seed/seed.ll`).
- **Native run:** `bash scripts/diagnose.sh --run <file>` (NOT `bs2 run`).
- **Beads:** stage named files only; reconstruct minimal jsonl from base + your tickets; never `add -A`.
- **Known bugs to respect/maybe-fix in Phase 4:** `uyao` (list/map literals don't box value-optionals
  — bidirectional typing gap; gating will likely surface it), map `[]`-read ICE, the parser
  record-and-abort coupling.
- **Phase 4 is "the grind"** (flip to gating, fix every surfaced non-null violation across compiler +
  stdlib until selfhost is byte-identical green). Budget many iterations; do NOT weaken a rule to
  make the build pass (CLAUDE.md rules 1–4, 16).
- **Phase 6 owns the wholesale `null`→`none` migration and the spec Axis 10 update** — don't do
  either piecemeal earlier.
- **Don't rewrite the authoritative spec** outside the phase that owns it.
- **Commit valuable artifacts immediately** — the tree is volatile across turns.
