## Language: Avra (codenamed Avra during bootstrap)

Avra is a compiled, statically-typed, agent-first language. The full spec lives in `docs/2026_04_18_FULL_SPEC.md`.
The v1.0 TRD (gap analysis + tickets) lives in `docs/TRD_V1.md`.

**All work MUST follow the spec.** When in doubt, read the spec. The spec is the source of truth.

## Project Structure

The bootstrap compiler is fully self-hosted in `bootstrap/`. No external compiler needed.
It builds from a PINNED LLVM IR seed (sdmg.3 pin-don't-vendor): `bootstrap/seed/seed.lock`
names {version, sha256, url} on GitHub Releases; the build fetches + hash-verifies it into
`bootstrap/seed/seed.ll` (gitignored — a locally cycled seed.ll is normal during dev and is
NEVER committed). Publish a new pin with `make seed-publish` (integration branch only).

Features are self-contained modules in `bootstrap/packages/avrac/src/features/`.
Each feature has: parser, codegen, and `tests/*_test.av` spec/given/then files.

### Key directories
- `bootstrap/src/core/ast.av` — AST definitions, token kinds (`Tk` enum), value types, all list types
- `bootstrap/src/core/llvm.av` — LLVM C-API extern bindings
- `bootstrap/src/core/registry.av` — feature dispatch registry (tag-based routing to feature handlers)
- `bootstrap/src/parse/mod.av` — recursive descent parser + lexer
- `bootstrap/src/codegen/` — LLVM IR emission (mod.av + helpers + per-feature codegen)
- `bootstrap/src/typeck/mod.av` — type checker (currently additive, MUST become gating per spec)
- `bootstrap/src/resolve/` — name resolver (mod.av = scope, names.av = module/import resolution)
- `bootstrap/runtime.c` — C runtime (~1900 lines: allocator, string ops, LLVM wrappers, channels, threads)
- `bootstrap/seed/seed.ll` — bootstrap seed IR
- `bootstrap/tests/` — spec/given/then test files (`*_test.av`); run via `bs2 test`

### File locations (NOT where old CLAUDE.md said)
- Token kinds: `Tk` enum in `src/core/ast.av` (NOT `src/core/kind_ids.av` — that file doesn't exist)
- Scanner/lexer: `src/parse/mod.av` and `src/parse/lexer.av` (NOT `src/core/scanner.av`)
- Resolver: `src/resolve/mod.av` + `src/resolve/names.av` (NOT `src/core/resolver.av`)
- Eval: `src/features/eval/mod.av` (NOT `src/core/eval.av`)

### Rules
- Never put feature-specific code in `core/` — core is infrastructure only
- **NEVER put package-specific or @std-specific code in core/ or features/.** All package behavior uses the generic template/expansion system.
- **NEVER add brittle heuristics.** No string-matching to detect behavior. Use annotations, type system checks, or structural analysis.
- Every feature must have `tests/*_test.av` files with `spec`/`given`/`then` blocks asserting behavior
- Feature status: draft (no tests), wip (some pass), testing (most pass), stable (all pass)

## Value Model

**The everything-is-i64 model has been eliminated.** The codegen now uses proper LLVM types:
- `Int` → i64
- `Bool` → i1
- `Float` → double
- `Str`, `Ptr`, `Struct`, `Enum`, `List`, `Map`, `Fn`, `Closure`, `Trait` → ptr

The canonical type mapping function is `llvm_type_for_full` in `codegen/types.av`.
Struct fields use proper LLVM named struct types via `avra_llvm_struct_create_named` + GEP.
A legacy `llvm_type_for` still exists (maps Bool/Float to i64) for callers not yet updated.

`EmitValue` carries both `value: ptr` and `ty: ValueType` — every emitted value is type-aware.

## Implemented Features

### Core language (fully working)
- **Bindings:** `let`, `mut`, `const`, destructuring
- **Functions:** `fn`, `export fn`, generic `fn<T>`, `extern fn`
- **Control flow:** `if`/`else` (stmt + expr), `while`, `for i in start..end`, `for x in collection`, `break`, `continue`
- **Pattern matching:** `match` (stmt + expr), guards, or-patterns, nested patterns, subjectless `match`/`when`
- **Types:** `type Foo = { fields }` (structs), `enum Foo { variants }`, `trait`, `impl`, `impl Trait for Type`
- **Generics:** `<T, U: Bound>`, full monomorphization (4-pass), explicit type args `f::<int>(x)`
- **Closures:** `(x) -> body`, `(x: int) -> body`, `it` pronoun (method-call contexts), captures
- **Collections:** `[a, b, c]` list literals, `{k: v}` map literals, list comprehensions, table literals
- **Null safety:** `T?` nullable, `?.` optional chain, `??` null coalesce, `?` try/propagation
- **Error handling:** `Result<T, E>`, `?` operator on Result, `Try` expression
- **Operators:** `|>` pipe (desugared in parser), `is` type check, `in` membership, `with` struct update
- **Other:** `defer`, `select` (channels), `parallel`, `spec`/`given`/`then` (testing), `@annotations`, modules/`use`/`export`
- **Dynamic dispatch:** `dyn Trait` with vtable boxing

### What's parsed but NOT yet in codegen
- `ListComp` — parsed into AST, no `emit_list_comp` exists

### Type checker status
**Gating** — type errors stop compilation before codegen runs. Per spec Axis 20.

## Build

```bash
cd bootstrap/
make                       # build the bootstrap compiler (produces build/bs2)
make build-quick           # rebuild bs2, skip selfhost verify (inner loop)
make test                  # spec suite + selfhost. Options: FILTER=<substr>, SKIP_SELFHOST=1
make test FILTER=<substr>  # narrow tests (substring match against filename) — USE THIS for iteration
make diff-test             # HRN: old (base) vs new (HEAD) compiler emit byte-identical IR. PREBUILT=1 (fast local) / BASE= / NEW= / CORPUS= / JOBS=
make coverage              # run all spec tests with coverage instrumentation
make run FILE=x            # compile and run a Avra program
make update-seed           # rebuild seed IR (default: verified). Add FAST=1 for inner loop.
make cache-gc              # prune COLD cache entries repo-wide (mtime == last use). DAYS= overrides 30d.
make clean-cache           # wipe EVERY cache (per-package + top-level). Guarded: never touches src/.
make clean                 # remove all build artifacts (3-min seed rebuild on next make)
make help                  # show all targets
```

Pipeline: `seed/seed.ll → llc + cc → seed binary → compiles src/ → bs2 → compiles src/ → bs3 (must match bs2)`

Diagnostics: `bash scripts/diagnose.sh --help` (single entry point for all analysis)

Seed merge conflicts: on lock-era history the conflict lands on `seed/seed.lock` — artifacts are immutable, so take the HIGHER version line (or run `diagnose.sh --seed-merge` when the source union needs restaging + a fresh publish). Pre-lock `seed/seed.ll` conflicts stay `merge=binary` — never merge textually. Full recipe + base-seed selection criteria: `bootstrap/docs/SEED_MERGES.md`.

## Bootstrap window & seed train (sdmg.2 — ENFORCED)

The Rust stage0 rule, adopted: compiler source must ALWAYS build from the
integration branch's pristine seed (`feat/crafting-intepreters`'s pinned
`seed/seed.lock`, fetched + hash-verified into the gitignored `seed/seed.ll`).
Concretely:

- **Feature branches NEVER cycle the seed.** No `seed.lock` bumps (or, on
  pre-lock history, `seed.ll` commits) off the integration branch — and
  therefore no dogfooding of new surface syntax / enum variants in compiler
  `src/` until the integration seed has advanced past them (the Phase A/B
  discipline below, promoted to an enforced invariant). Implement the
  feature + tests on your branch; dogfood it in compiler `src/` only AFTER
  it merges and the train advances.
- **Seed advancement = the seed train.** Dedicated `chore(seed): cycle`
  commits on the integration branch only, serialized after merges land —
  automated by `.github/workflows/seed-train.yml`, which runs
  `diagnose.sh --seed-train` on every integration push: build from the
  pin (no auto-cycle), fixed point, full suite, then publish + lock-bump
  ONLY when the compiler's output actually diverged from the pinned
  artifact (doc/test-only merges advance nothing). `make seed-train`
  does the same manually; `make seed-publish` is the raw publish step.
  The train recompiles `main.av` hermetically (metadata fast-path
  stripped) before pinning, because **the seed MUST be self-contained**
  — a fresh clone bootstraps it via `seed.ll → llc + cc → seed binary`
  with no other objects, so a fast-path build (which leaves `@`-package
  symbols as extern `declare`s, mangled `$40…`) would brick every clone.
  `mode_update_seed` enforces this at the seed-writing chokepoint (so
  `make update-seed` is guarded too); `--seed-self-contained` is the
  spec-tested check.
- **Enforcement:** `diagnose.sh --check-bootstrap-window` — gate 1 rejects
  branches with seed commits since the merge-base; gate 2 rebuilds the
  branch's compiler source AT HEAD (what a push ships — untracked or
  uncommitted files don't count; commit first) from the integration seed in
  an isolated tree (cold unit cache) and smoke-runs the result. Wired into the pre-push hook
  (`bootstrap/scripts/pre-push`, installed at `.git/hooks/pre-push` via `make install-hooks`) and
  CI (`.github/workflows/bootstrap-window.yml`, every PR into the
  integration branch). Green results are cached (keyed on integration seed
  + compiler sources), so a clean push is seconds. Escape hatch for genuine
  emergencies only: `AVRA_SKIP_WINDOW_CHECK=1 git push`.

Any two branches that pass are compilable by the same seed BY CONSTRUCTION —
the 2026-06-11 "neither seed can compile the union" merge state cannot
happen. If `make build` auto-cycled your local seed (it does this when bs2
can't self-compile), the cycled `seed.ll` is gitignored so it can't land by
accident — but your build is now ahead of the pin. Restore the pinned seed
with `rm bootstrap/seed/seed.ll && bash bootstrap/scripts/diagnose.sh
--seed-fetch` and remove whatever post-seed feature use forced the cycle.

### Dev-loop build freshness (pdme.1 + 6cks LANDED — the stale-bs2 bug is fixed)

The historical "a plain `make build-quick` re-links the previous bs2 after a
non-entry edit" bug is FIXED, at two layers: (1) the compile-cache key folds
the entry package's dep-aware full fingerprint (`package_full_fingerprint`,
pdme.1 — every source in the manifest dep closure participates), and
diagnose.sh's `source_newer_than` uses a portable stat (6cks); (2) because the
bs2 rebuild itself is performed by the PINNED SEED — which can predate pdme.1
and would key entry-only, serving its own stale slot — `ensure_bs2` drops the
CLI unit cache before the seed compile (a rebuild only triggers when a source
genuinely changed, so a fresh compile is owed anyway). Editing `parse/mod.av`,
`typeck/mod.av`, etc. now propagates on a plain `make build-quick` regardless
of seed vintage, and `make build-quick` on an unchanged tree is sub-second.

The 18z8 hole is closed too: `bs2 build` now removes any stale entry `.ll`
before the child compile and fails on the child's real exit code (the
non-TTY progress runner used to swallow it), so a crashed child can no
longer report `Built` off a leftover artifact. Mutation→revert cycles are
also content-keyed now: a revert restores the pre-mutation fingerprints, so
the pre-mutation cache slots (correct results) are what reruns hit.

**Frozen-FAIL in the fixture-stdout cache (zp5b/fxfz).** Distinct from the
compile caches above: the test runner also memoises each *fixture's stdout*
under `build/cache/fixture_stdout/<key>.out` (keyed on toolchain fingerprint +
fixture source). A fixture that FAILed once on a transient hiccup — cold-cache
jetsam, a concurrent build, a half-published `@std` package cache — can have
that `: FAIL` frozen and replayed with no source diff to explain it. If a test
fails with nothing in the diff to explain it, run `bs2 cache clear-failed`: it
evicts only the frozen-`: FAIL` captures and keeps passing ones warm (cheaper
than `make clean`, which discards every warm capture). Fixtures that probe
SHARED build state (e.g. pre-building `@std` into `packages/*/build`) opt out of
caching failures entirely via the `@@fixture-stateful@@` source directive — the
test runner reads it with `fixture_is_stateful` and never caches a `: FAIL` from
such a fixture, so a repaired environment re-probes instead of replaying.

## Differential testing (HRN — the go-hard safety net)

The `ps3t` "AST as the single source of truth" program rewrites the
compiler's foundations. The net that makes a big-bang rewrite safe is the
**HRN differential test** (spine doc §8): the OLD compiler is the oracle —
OLD and NEW must emit **byte-identical IR** for the same inputs, so you can
rip the foundation out and instantly catch behaviour drift.

```bash
make diff-test                 # OLD = integration branch, NEW = HEAD (HERMETIC; == CI)
make diff-test PREBUILT=1      # FAST LOCAL ITERATION: reuse the warm build/bs2 as NEW,
                               # skipping the dominant ~5-7 min cold rebuild. Reflects
                               # your WORKING TREE (uncommitted edits), not committed HEAD.
make diff-test BASE=<ref>      # override the oracle ref
make diff-test CORPUS='path/*.av'   # override the corpus glob
make diff-test JOBS=<n>        # corpus fan-out width (default ~nproc-1)
```

**Iterating on a compiler-source change? Use `make diff-test PREBUILT=1`** — it
skips the isolated NEW rebuild and reuses your `build/bs2`, turning a multi-minute
check into a ~30s one (that residual ~30s is the selfhost compile itself — the
decisive oracle, which nothing removes; the corpus is tiny and always runs). Two caveats: (1) it is
**NON-HERMETIC** (build/bs2's seed/source aren't pinned), so the plain
`make diff-test` is the authoritative check and the only one CI runs; (2)
**rebuild `bs2` first** (`make build-quick` — cheap now that freshness is
content-keyed) so build/bs2 reflects your edits; a stale build/bs2 compared
against OLD reports a false **PASS**. The two **selfhost** compiles (OLD
and NEW) run **concurrently** in every mode (via `bs2 compile --output`), so the
selfhost phase costs ~one compile, not two; the corpus files fan out in parallel
too — no flag needed.

- Implemented as `diagnose.sh --diff-test` (centralized, per rule 10). It
  builds the compiler at both refs **in isolation, from the SAME pinned
  seed** (the seed-train invariant guarantees a feature branch's seed ==
  the integration seed), so any IR difference is attributable to compiler
  **source** alone, never the seed. Builds reuse the bootstrap-window
  primitives and cache on a (seed + source) fingerprint.
- **Inputs:** the selfhost source (the whole compiler — one compile each,
  exercising ~all codegen; the decisive, comprehensive oracle) + the
  **curated standalone corpus** `bootstrap/tests/difftest_corpus/*.av` —
  small, single-file, feature-diverse programs that compile with a bare
  `bs2 compile`. The corpus is the surgical complement to the selfhost pass:
  a divergence in (say) channel or match codegen surfaces against a ~20-line
  file instead of bisecting the ~590k-line selfhost IR. It is NOT the harness
  suite (`tests/*.av`): those need `@std` + the spec/given/then runtime, so
  OLD can't compile them standalone — every one would be skipped after a
  doomed compile, leaving the corpus phase doing zero work (51zr). A corpus
  file OLD can't compile standalone is skipped with a `[warn]` (fix or remove
  it). Add coverage by dropping a new standalone `.av` into that dir (see its
  README).
- **Why IR equality is the oracle:** the toolchain is deterministic (the
  selfhost fixed point already relies on it), so identical IR ⇒ identical
  object ⇒ identical run-results. IR equality is the strict superset of the
  "binary / test-results" checks. A *legitimate* IR change (e.g. an
  intended codegen improvement) trips the gate by design — the landing path
  is `--run-equiv`: label the PR `intended-ir-change` and CI switches the
  oracle to RUN-equivalence (every corpus artifact must link+run
  byte-identically under OLD and NEW; corpus skips are forbidden; the suite
  under NEW — the rc-strict job — completes the evidence). The oracle then
  advances at merge as usual.
- **Wired in:** CI (`.github/workflows/diff-test.yml`, full corpus, every
  PR into the integration branch) and the pre-push hook (selfhost + corpus
  check, only when compiler sources changed; `AVRA_SKIP_DIFFTEST=1` to
  skip). This is the sibling of `--check-bootstrap-window`: the window gate
  proves the source *builds* from the seed; diff-test proves it *behaves*
  identically.

## CRITICAL RULE: Test cycle hygiene

The full `make test` is ~60s warm (19s suite + selfhost check; cold
after a compiler change ~390s — batched shard compiles dominate).
Don't burn it on every failure. The pattern that wastes the most time is:
**`make test` → `grep FAIL` → `make test` again to "see if it passes this time"**.
Don't do this. Each round costs 6 minutes.

When a test fails, the loop is:
1. **Once** — `make test 2>&1 | grep -A2 FAIL` to capture the failing test path.
2. Isolate — `./build/bs2 test <single_file>` to reproduce the failure deterministically.
3. If it doesn't reproduce in isolation, it's an ORDERING / GLOBAL-STATE bug. Don't re-run the bundled suite to confirm — file or fix the state leak.
4. Fix the root cause. Then ONE bundled rerun before commit, via the pre-commit hook.

Anti-patterns:
- Bundled-test rerun-loops to "check if it flaked." Flakes are bugs; isolate them.
- `make clean` between failed runs unless you have a concrete reason. The seed rebuild costs another 3 min on top.
- `find packages -type d -name cache -exec rm -rf {} +` as a "fresh start." Same as above.
- Running the suite without `FILTER=<x>` when you only need a feature area's tests.

Per-file test runs are 15s each (uzs9.1 — cache miss bug). When debugging,
isolate-and-iterate on ONE file. Don't bundle.

## CRITICAL RULE: Build What You Need

If you discover a missing language feature or infrastructure gap while working, STOP and implement the missing piece FIRST. Do NOT work around, defer, or hack a substitute. Every workaround becomes permanent tech debt.

## CRITICAL RULE: Out-of-Space Recovery

When any command fails with ENOSPC / "no space left on device" / similar disk-full errors, do NOT ask the user to clean up manually. Run `make clean` from `bootstrap/` first (drops `build/` — caches, test-shard logs, coverage artifacts, staged binaries; tens of GB recoverable on a warm tree). Then retry the failing command. The bootstrap rebuilds itself from `seed/seed.ll`, so wiping `build/` is always safe — never destroys uncommitted source.

## Adding a Feature — MANDATORY PROCESS

### Phase 1: Plan
1. Check the TRD (`docs/TRD_V1.md`) and Agent Tasks (`mcp__Agent_Tasks__ready`) for related tickets
2. Identify seed impact — new keywords need a seed cycle. So does any **new surface syntax the current seed's parser cannot produce**, even when it reuses existing tokens (e.g. a new literal form like `table<Row> { … }`): the checked-in seed is an older compiler, so you must `make update-seed` BEFORE that syntax appears anywhere in compiler `src/` — otherwise `make build` fails parsing it (often as a misleading `undefined variable` / parse error). This is inherent to self-hosting, not a bug. Order: implement + land the feature without using it in `src/` → `make update-seed` → then dogfood the new syntax in `src/`. New enum VARIANTS on types the seed processes (ValueType, Expr, Stmt) DO need seed patching: run `make seed-patch-traps` before `make build` to convert the seed's match traps to safe fallthrough. Then `make update-seed` after the build succeeds. Adding fields to existing variants also needs this treatment.

### Phase 2: Two-Phase Bootstrap (only if adding new keywords)

**Phase A — Types only:** Add new types/variants. Don't use them yet. `make build` must pass. Update seed.
**Phase B — Implementation:** Implement parser/codegen/resolver/typeck. `make build` after every change. Update seed when done.

### Phase 3: Implementation Checklist
- [ ] AST (`src/core/ast.av`) — new Expr/Stmt/Pattern variant
- [ ] Lexer (`src/parse/lexer.av`) — new token kind if needed
- [ ] Scanner (`src/parse/mod.av` `p_keyword_kind`) — new keyword mapping
- [ ] Parser (`src/parse/mod.av` or `src/features/<name>/parser.av`)
- [ ] Codegen (`src/codegen/mod.av` or `src/features/<name>/codegen.av`)
- [ ] Resolver (`src/resolve/mod.av`)
- [ ] Type checker (`src/typeck/mod.av`)
- [ ] Feature registry (`src/features/mod.av` `init_features`)
- [ ] AST renderer (`render_expr`/`render_stmt` in `ast.av`)

### Phase 4: Testing
1. Basic happy-path test in `src/features/<name>/tests/<name>_example_test.av` (spec/given/then format)
2. Edge cases (empty, null, zero, negative, boundary values) — one `*_test.av` per scenario
3. Combinatorial: closures, match, nullable, if-expr, structs, enums, loops, pipe, templates, lists, maps, `with`, `defer`, nested, as args/returns
4. Compile-error tests via `avra_shell_exec("./build/bs2 compile ...")` from a spec block — assert the F-code in the captured output

### Phase 5: Documentation
1. Create `src/features/<name>/grammar.md` describing syntax
2. Add WHY comment at top of each new file
3. Update TRD if completing a ticket

### Phase 6: Dogfood
Search bootstrap source for places to use the new feature. Refactor, update seed, `make test`.

### Phase 7: Commit
Commit with `feat: <feature> — <what it does>`. Pre-commit hook runs spec test suite + selfhost check. Never `--no-verify`.

### Anti-Patterns
- Never skip tests, seed update, resolver, type checker, or registry registration
- Never test only the happy path — combinatorial tests find real bugs
- Never defer dogfooding

## NEVER CONTEXT-BUDGET

Do not stop, defer, or take shortcuts because of context limits. Do the work properly. Never reason about your own context limits.

## Spec Compliance

The authoritative spec is `docs/2026_04_18_FULL_SPEC.md`. Key v1.0 requirements:

### Type System (spec Axes 1-8)
- **Fully static** — every value has a compile-time type
- **`type` (nominal) + `shape` (structural)** — shapes use width subtyping
- **Traits are nominal** — must explicitly `impl`
- **Generics** — monomorphization default, `dyn Trait` for heterogeneous
- **Associated types** on traits (`type Item`)
- **Enums + union types** — `A | B` ad-hoc unions alongside declared enums
- **Exhaustive matching** — compiler enforces, wildcard lint when hiding >2 variants
- **Newtype wrappers** — `type UserId = UUID` creates nominal distinction

### Memory Model (spec Axis 9) — v1.0 is app-level only
- **Refcounting** (non-atomic) + **targeted cycle detection** + **arenas**
- **Drop trait** + **defer** + **errdefer** — LIFO ordering
- **Copy auto-derivation** for all-Copy-field types
- **Escape analysis** — stack vs heap
- **String SSO** — <=23 bytes inline

### Error Handling (spec Axis 12)
- **Result<T, E>** with `?` propagation
- **Union error types** — `Result<T, IoError | ParseError>` with auto-widening at `?`
- **`catch` blocks** — `let x = expr() catch { default }`
- **Error trait** — message(), kind() (hierarchical), cause(), context(), trace()
- **Panic at task boundary** — spawned task panics become errors to parent

### Concurrency (spec Axis 18) — green threads, no async/await
- **spawn** — green threads on single OS thread (v1.0)
- **Task<T, E>** — mirrors Result; .await, .cancel(), Task.all(), Task.race()
- **Channels** — bounded/unbounded/synchronous
- **select** — multi-channel wait
- **Streams** — lazy pipelines on single fiber
- **Structured concurrency** — scoped task lifetime

### Syntax (spec Axis 28)
- **No semicolons** — newline-sensitive
- **Braces** — `{}` delimit blocks
- **Strings** — `"..."` with `{expr}` interpolation, `"""..."""` multiline, `r"..."` raw
- **Closures** — `(x) -> body`, `it` pronoun
- **Pipe** — `|>` desugars to function call
- **Comments** — `//`, `/* nested */`, `///` doc, `//!` module doc
- **Naming** — PascalCase types, snake_case fns/vars, SCREAMING_SNAKE constants

## Debugging Protocol

When hitting a segfault/crash, follow this order. Do NOT guess.

1. **LLDB first:** `lldb -b -o 'target create ./build/bs2' -o 'settings set -- target.run-args check /tmp/test.av' -o run -o bt -o 'register read x0 x1 x8 x9'`
2. **Check seed integrity:** `git diff seed/seed.ll` — if dirty and you didn't update, restore it
3. **Check -O0 vs -O2:** if only -O2 crashes, it's an alignment bug
4. **Store tracking:** `AVRA_TRACK_STORES=1` finds return-type mismatches
5. **Redzones:** `AVRA_REDZONES=1` / `AVRA_PAGE_ALLOC=1` catches cross-allocation writes
6. Only then read IR

LLDB notes: the runtime's `avra_match_unreachable` reporter calls `exit(99)` (no
abort), so set `b avra_match_unreachable` BEFORE `run` or you get no stop. The
orchestrated `bs2 build --lib` spawns the real compile as a CHILD process —
LLDB on the parent sees only SIGCHLDs; reproduce single-process first (below).

### The full-coverage smoke: the metadata lib build (a green plain compile is NOT enough)

`make build-quick` + `bs2 compile avrac.av` from `src/` can both be green while
the compiler is broken: comptime macro expansion of component/derive output is
only consumed on the manifest-driven path. After any compiler change, the probe
that covers it (this exact shape — cwd at the PACKAGE ROOT so the manifest +
dep-metadata path engage; the exit code is the verdict):

```bash
cd packages/std-avrac && AVRA_USE_METADATA=1 \
  AVRA_LIB_PKG_ROOT='@std::avrac' ../../build/bs2 compile --emit_metadata \
  --module_path='@std::avrac' src/avrac.av; echo "exit: $?"
```

The orchestrated form (`bs2 build --lib --emit_metadata` from the package
root) is equally trustworthy as a pass/fail probe: the parent gates Built on
the child's exit status and removes any pre-existing entry `.ll` before
spawning, so a stale artifact can no longer mask a crashed child (the old
18z8 failure mode; guard: `build/tests/libbuild_stale_ll_test.av`). No
`rm -f src/avrac.av.ll` prelude is needed on either form.

### Memory / OOM measurement (READ before diagnosing an OOM)

**Session-accumulated pressure masquerades as a code bug.** A killed `make test` leaves `bs2`/`llc` procs + page cache resident, so the NEXT memory reading is inflated — a whole session was once spent concluding the std-avrac lib build needs ~15GB (it's ~140MB; the rest was session pressure, which `snw0` already documented and warned about). Before trusting ANY memory number: `free` shows recovered avail AND `pgrep -f 'bs2 build|llc'` is empty. Measure whole-tree/cgroup RSS, not `ps --ppid` (misses the `llc` grandchild that does the heavy lifting). Kill stray runs by PID — `pkill -f '<pat>'` self-matches your own shell command (exit 144). The full-suite OOM on a ≤16GB box is a KNOWN, scoped issue (`snw0`) — don't re-diagnose from scratch.

**On a ≤16GB Claude-Code-Web container, `make test` doesn't just OOM — it takes the whole container down** (three restarts in one 2026-07-12 session, all mid-suite). The pattern that survives is now a first-class mode: **`make sweep`** (= `diagnose.sh --sweep`) — one sequential `bs2 test <dir>` per test directory, per-dir logs + `.ok` resume markers under `build/sweep/` (a kill resumes at the failing dir instead of restarting), loud failure at the first red dir (no later dir masks an earlier one), and a suite-wide tally on green. `FRESH=1` (or `--fresh`) drops the markers; extra args scope it to specific dirs. This is the sanctioned full-suite runner on a small box; pair it with `make selfhost` for the full `make test` equivalent.

Do NOT rebuild `bs2` (or clear caches) while a sweep is running; the runner re-invokes `./build/bs2` per compile and a mid-sweep rebuild silently invalidates the run.

### C-side debug tools (runtime.c)
- `avra_trace_i64(v1, v2)` / `avra_trace_ptr(label, val)` — safe tracing (no string alloc)
- `avra_dump_stmt(label, stmt)` / `avra_dump_stmt_list(label, list)`
- `avra_cg_trace_enable(1)` / `avra_cg_trace_stmt/emit` — codegen tracing
- `avra_dump_function(fn_val)` — dump LLVM function IR

**NEVER use `eprintln("text" + string(val))` in hot paths** — causes infinite recursion. Use C-side trace functions.

### Pointer address ranges (for LLDB)
- `0x100000000-0x200000000` → bump arena (valid)
- `0x600000000000` range → system heap (valid)
- `< 0x100000` → INVALID (null-ish, likely corrupt enum field)
- Near sp register → stack (valid)

### Token Kinds
Token kinds defined as `Tk` enum in `src/core/ast.av`. Keywords are mapped in `p_keyword_kind` in `src/parse/mod.av`.
New keywords must be added to: (1) `Tk` enum in ast.av, (2) `p_keyword_kind` in parse/mod.av. (`avra_kind_id_for_keyword()` in runtime.c no longer exists — the keyword table lives solely in the parser; verified 2026-06 while adding `channel`.)

## Silent Failure Modes

These bugs build successfully but corrupt memory at runtime.

- **Wrong return type:** `return r` where r is inner value instead of Result wrapper. Grep all `return` in refactored files.
- **Dropped generic args:** parser consumed `<...>` without parsing inside. Render AST and verify.
- **Monomorphizer ambiguity:** "first match wins" when multiple instantiations exist. Use `scope_insts_for_ret` to pin by return type.
- **Expected-type generic inference must FILL gaps, never OVERRIDE a concrete binding.** When mono threads a `let`/return annotation into a generic struct/fn (`infer_from_field_inits_with_expected`, `infer_from_params_with_expected`), the annotation may bind ONLY the params the fields/args left unresolved (a phantom, or one behind an empty collection — bound to `Unknown`). Letting it override a param a field/arg bound concretely turns a wrong annotation (`Box<string> = { val: 9 }`) into a layout swap: mono stamps the `int` field as a `string`/ptr slot and codegen emits `store ptr inttoptr (i64 9 to ptr)` — int stored as a wild pointer. Fill-only is byte-identical to override on every VALID program (they differ only on a conflict, which is an invalid program), so diff-test stays green; typeck (`check_binding` → `check_expr_expected`) rejects the conflict as F1000. BOTH sides are now fill-only (26ql): the fn side too — `infer_from_params_with_expected` (mono) + `tc_subst_generic_ret_with_expected` (typeck) unify the return against the expected into a FRESH acc, then `fill_unresolved_typeargs` / `tc_fill_unresolved_typeargs` fill only the params the args left unresolved. Residual (separate, pre-existing): a generic fn returning a BARE type param from a scalar literal (`id(9)`) still isn't caught — `tc_infer_type_args` doesn't bind a type param from a literal arg, so the expected legitimately fills it, and the scalar int→string assignability leniency hides the rest.
- **-O0 works, -O2 crashes:** alignment mismatch. Check LLVM type consistency.
- **Seed contamination:** auto-cycle overwrote seed.ll. Default `NO_AUTOCYCLE=1` is set.
- **Stale seed after a base change → misleading `expects X, got X` errors:** after rebasing/restarting a branch onto a newer integration base, the gitignored local `seed/seed.ll` stays at the OLD version and compiles the newer source with an older compiler — throwing F1000 `expects @…::ExprId, got @…::ExprId` (identical expected/got) that mimics a type-checker bug, not a seed mismatch. Re-fetch the pin first: `rm bootstrap/seed/seed.ll && bash bootstrap/scripts/diagnose.sh --seed-fetch`.
- **Materialise atomically, or validate completeness on reuse.** Any artifact written straight to a final path that a *later run* reuses (cache-hit, mtime-freshness, existence gate) can be served half-written if the writer is killed mid-materialise — the zp5b/fxfz/kaux/rrio bug class. Produce to a per-pid temp then rename (`build/link.av` `atomic_obj_llc_cmd` / `atomic_cp_cmd`; `cache_publish` staging), and gate reuse on completeness (`slot_complete`). A validation gate with a bypass path is worse than none. FIXED instance of this class (was 18z8): the lib build's post-compile `file_exists(entry.ll)` check used to be satisfied by a STALE .ll from an earlier run, so a crashed child compile still reported `Built` — now the parent removes the pre-existing entry `.ll` before spawning and gates Built on the child's real exit status (`run_with_progress`/`run_silent` never fabricate a 0), with the existence check demoted to a consistency assert; guard test `build/tests/libbuild_stale_ll_test.av`. Lib builds are safe pass/fail probes without any `rm` prelude. Meta reads are validated too (pdme.2 `metadata_slot_matches`): a slot serves only when whole AND stamped with the key it was looked up under.
- **Concurrent same-slot compiles are safe LOCK-FREE (pdme.7) — don't add a cache lock.** N bs2 processes compiling the same entry (the shard/pre-build contention shape) contend on one cache slot safely: staging dirs are pid-unique, IR emission itself is atomic (`avra_llvm_print_module_to_file` prints to a per-pid tmp then renames — LLVM's own API truncates in place), wreck-repair renames damaged slots ASIDE into `_tmp` (readers see whole-or-absent, never half-deleted), and every cache-hit read is validated (an emptied-mid-read slot demotes to an honest MISS + recompile). A publish-race loser loses benignly. The regression net is `diagnose.sh --cache-fuzz-parallel [ROUNDS] [JOBS] [SEED]` (suite-wired at small rounds): simultaneous same-fp compiles + a chaos agent damaging the live slot, asserting rc=0 everywhere, worker IR == bypassed reference, and post-melee liveness. One rule remains for CALLERS: concurrent same-entry compiles must each pass their own `--output` — the shared `<entry>.ll` is the one path the cache can't defend (and `--output` is compile-cache-eligible now, so per-consumer outputs still share the slot).
- **Unmatched tag `-559038737` / `0xffffffffdeadbeef` = the CLOSURE MARKER, not freed memory.** That constant is `closure_marker()` (codegen/types.av) — the head of a closure array `[MARKER, fn_ptr, captures…]`. Seeing it as an enum tag means a FUNCTION REFERENCE landed where a value belongs. Historically the first suspect was a fn-name/local-name collision, but **that class is now FIXED (ticket zo1a, #667/#691)**: locals AND match-arm pattern bindings reliably shadow same-named fns (the qualifier threads let/loop/pattern bindings), and module-private fns don't leak cross-module (a bare cross-module private ref is F3000, never a silent closure). So a closure marker today points at a genuine codegen/memory bug — a value slot that received a fn reference — NOT a shadow collision; investigate the emitting codegen path directly. Regression guards: `resolve/tests/pattern_var_shadows_fn_test.av`, `resolve/tests/local_value_shadows_import_test.av`, `tests/err_private_cross_module_test.av`. **Caveat:** reproducing the OLD corruption requires a **stale/contaminated `seed/seed.ll`** whose resolver predates the fix — always `sha256sum bootstrap/seed/seed.ll` and confirm it matches `bootstrap/seed/seed.lock` before diagnosing a "shadow" crash; a mismatch IS the bug (`rm bootstrap/seed/seed.ll && bash bootstrap/scripts/diagnose.sh --seed-fetch` restores the pin).

## CLI Commands

`avra build <file>` | `avra run <file>` | `avra check <file>` | `avra test [feature]` | `avra features [--graph|name]` | `avra explain <code>` | `avra package new <name>`

## Error System — ZERO RAW ERRORS POLICY

All errors go through `CompileError::render()`. No exceptions.
- NEVER `eprintln!("error: ...")` — use CompileError
- NEVER silently ignore errors — propagate via Result
- NEVER `CompileError::Other` — create specific variants with help text

Error codes: F0001 (syntax), F0002 (unterminated string), F0003 (unterminated template), F0006 (bad number), F0012 (type mismatch), F0013 (immutable assign), F0014 (wrong arg count), F0020 (undefined variable), F0030 (table column), F0801 (unused var), F0900 (spec test), F9999 (ICE)

Per spec (Axis 20): F-codes are stable identifiers. Ranges: F0001-0999 lexer/parser, F1000-1999 typeck, F2000-2999 borrow/memory, F3000-3999 resolution, F9000-9998 warnings, F9999 ICE.

## Known Technical Details

- **TypeId is content-addressed, not a counter:** `type_registry_register` assigns `id = content_id_for(FQN)` (FNV-1a-64 of the fully-qualified name), so the SAME type gets the SAME id in every registry/process/build. Ids are sparse i64 (frequently NEGATIVE) — NEVER index by them (`infos[id-1]` is gone; go through `type_registry_lookup` / the `id_to_index` map) and test "stamped" as `id != 0`, never `> 0`. `vtype_eq` compares nominal identity by id, kind-agnostically (a parser-default `Struct("Foo")` and a resolved `Newtype("Foo")` of the same FQN are equal); the FQN string is only the pre-resolve (id==0) fallback. The on-disk symbol id (`build::metadata::sym_id_for`) delegates to the same `content_id_for` — one identity, in-process and on-disk. (Counter ids were collision-free but diverged across package registries — the 24yd bug; content ids trade a negligible i64-truncation collision risk for cross-registry stability, matching the scheme metadata already trusted.)
- **Enum layout:** `{i64 tag, ptr payload}` (16 bytes). Tags are djb2 hashes (stable across reordering). Payloads heap-allocated.
- **Statement/Token size:** 112 bytes each (`{i8, i64x13}`), not 16.
- **`export let` vs `export mut`:** `let` compiles to local allocas. Use `mut` for cross-module globals.
- **Nullable `return null`:** use `maybe_wrap_nullable` (detects const_zero), not `wrap_in_nullable` (always tag=1).
- **Type info:** use `LLVMGetAllocatedType` / `get_type_by_name` — never global flags or parallel lists. LLVM is single source of truth.
- **Naming:** shadowing a fn/type name with a pattern var or local is now SAFE (zo1a fixed — the binding wins lexically, no closure leak), but still discouraged for readability. Short prefixes (`se`, `ss`, `sv`) keep intent clear.
- **Seed cycle is 3+ min** — use LLDB or C-side traces, never eprintln traces requiring rebuild.
- **Duplicate codegen paths:** `emit_statement` exists twice (feature path + inline path). Both must handle all statement types.
- **BasicBlockRefs CANNOT survive Avra global store/load** — use C-side `avra_loop_push/break` stack instead.
- **Struct methods use self-by-pointer** (ptr, not value) for mutation persistence.
- **`llvm.type_of(param_val)`** for parameter allocas — not `resolve_type_to_llvm` (circular dependency).
- **Seed auto-cycling:** `make build` detects when bs2 can't self-compile and cycles the seed forward. Auto-cycle CAN'T help when adding new keywords the seed scanner doesn't recognize. `--seed-status` shows new/changed fns, `--seed-diff <fn>` diffs specific functions.
- **Memory corruption / RC symptoms** (`unmatched tag <heap ptr>`, phantom releases, null-where-object-expected): START at `docs/RC_MEMORY_RUNBOOK.md` — the invariant (`AVRA_VERIFY_RC=1`), symptom→action table, and the deterministic watchpoint-hunt recipe.
- **render_list stack overflow:** DiagnosticList is a linked list, render is recursive. Limit is 10 (render_first_n). Fix the source producing too many errors, don't increase the limit.
- **Empty match arms** like `.Break(s) -> {}` silently swallow behavior. Periodically grep for `-> {}` in codegen to find stubs needing real implementations.
- **Walkers that rebuild stmts MUST preserve `Annotated` wrappers.** Match on `stmt_unwrap`/peeled nodes for dispatch, but emit rebuilt nodes via `rewrap_annotations` (core/ast.av) — pushing a bare rebuilt `Stmt.Module` silently strips the module's annotations (the @deferred_init-eating bug class, d4jv). `expand_stmt_list` + `derive_marshal` were both guilty.
- **In-process test parallelism (d4jv):** every assembled test binary runs its test FILES as `@deferred_init` units across `AVRA_TEST_JOBS` worker threads (default: cpu count; coverage pins 1). Per-unit output is grouped via per-thread runtime sinks (`avra_sink_push/pop` — `println` lowers to `avra_puts`, NOT libc puts). Capture (`avra_test_capture_*`) is sink-based, per-thread, nestable — no dup2. Channel surface: `channel<T>(cap)`, `.send/.recv/.try_recv/.close`, recv → `T?` null ⇔ closed+drained. `AVRA_TEST_STALL_MS` shrinks the stall-detector window (testing). `bs2 test <dir>` scopes discovery to that directory.
- **Test counts:** specs registered per spec/given/then live in atomic C counters; intmap-backed registries grow (the historic 256-slot intmap silently dropped insert #257 — see intmap_growth_test).
- **File-level consts are scoped per module (t-5vze — FIXED):** module-level `const` declarations are qualified by the resolver (`mod::NAME`, one LLVM global per module — exactly like fns/types), so same-named consts in batched test files can no longer silently read each other's value. Historically every module's consts shared ONE flat bare-name global (first-match-wins, no duplicate error — the `CONSUMER_SRC` incident: a fixture passed standalone but compiled a sibling batch member's source when bundled). Regression guards: `resolve/tests/module_const_scoping_test.av` (deterministic per-module readers + lowercase/uppercase `use` imports) and `test_runner/tests/batch_const_collision_test.av` (the real two-files-one-shard shape with overlapping unit inits). Consequences to know: const references arrive as `QualifiedIdent` downstream (is_const_expr, typeck's QualifiedIdent arm, and the naming lint all handle the qualified form), and nested/concurrent `bs2 test` runs no longer clobber each other's shard logs (per-pid `build/test_shards/<pid>` dirs — the shared dir used to be `rm -rf`'d by every run start; coverage runs still share `build/coverage/_test.profraw`/`.profdata`, so don't run two `make coverage` concurrently). Module-level `let`/`mut` globals intentionally stay flat/bare — `export mut` cross-module globals depend on it.
- **Test-suite OOM / @std metadata fast-path (snw0, 08ro, pdme — don't refile):** the per-file runner pre-builds each `@std/*` package into a producer `.o` + `meta.bin`; shards then STUB `@std` and link the producer obj (lightweight). When the pre-build fails it DEGRADES to whole-program shards that each inline ALL of `@std` (~10GiB) → parallel OOM on a ≤16GB box. Three gotchas that disable the fast-path: (1) the pre-build's `> ${pkg}build/prebuild.log` redirect needs the pkg `build/` dir, which std-process/std-test lack on a cold tree (`mkdir -p` first); (2) the lib-build unit cache MUST key on `AVRA_LIB_PKG_ROOT` (a wrong root — `@std.avrac` vs the correct `@std::avrac` from `derive_lib_root_for` — caches a symbol-less `.ll` that poisons a later correct-root consumer → `undefined symbol` at link); (3) degraded-shard compile concurrency is capped (`prepare_test_run`: jobs=2 when `!lib.want_meta`) so the fallback can't OOM.

## ABSOLUTE RULES

1. NEVER say "that's a bigger change" to skip work. Do the work.
2. NEVER say "known limitation" for a bug. Fix it.
3. NEVER simplify a test to avoid a bug. Fix the bug.
4. NEVER leave a workaround. Fix the root cause.
5. NEVER write to the memory system. Notes go in CLAUDE.md or project docs.
6. NEVER add C-side workaround functions to bypass codegen bugs. Fix the codegen.
7. ONE change at a time. Build -> audit -> commit if better, revert if worse.
8. Always do the right thing. Centralize logic, don't duplicate. Hacks create more hacks.
9. Fix bugs immediately or record them. Never silently skip.
10. When adding diagnostics, add to `scripts/diagnose.sh` (centralized), not separate scripts.
11. When fixing a bug, capture a spec test: write a `tests/<scenario>_test.av` with a `then` block that exercises the fixed path.
12. Be honest about scope. Never say "one more fix." Give real estimates based on data, not optimism.
13. Do large refactors when necessary. Don't avoid the right fix because it's big.
14. ALWAYS fix hacks and workarounds before ending a session. No hack survives a commit. If a proper fix requires a seed cycle, do the seed cycle.
15. NEVER skip a feature because it's "complex" or "a bigger lift." You discovered the defer/errdefer interleaving is wrong — fix it NOW, don't file a ticket and move on. The ticket IS the work. Do it.
16. NEVER build on top of bad architecture. If the foundation is wrong, stop and fix the foundation FIRST. "Pre-existing tech debt" is not an excuse — it's your job to fix it. String-based type annotations, untyped registries, i64 fallbacks — these are bugs, not features. Every time you encounter one, fix it before continuing. Tech debt compounds; the longer you wait the harder it gets.
17. NEVER create mutable globals (`export mut`). Mutable globals break parallel compilation, create hidden state coupling, and make save/restore bugs inevitable. Thread state through function parameters or struct fields. The historical DEFER_STACK / RC_CLEANUP / RC_RELEASABLE carveouts are gone — they've been refactored into `Ctx` struct fields (e.g. `ctx.rc_cleanup` in codegen/mod.av). Keep it that way. The only remaining process-wide statics live in runtime.c (rc bookkeeping, arena state) — fine for one bs2 process, and the reason we use process-level parallelism (not threads) for parallel test execution.
18. NEVER run destructive git operations without explicit user permission. No `git stash drop`, no `git reset --hard`, no `git checkout -- .`, no `git clean`. When a build fails, FIX THE ERROR. When a merge conflict appears, RESOLVE IT. When stuck, ASK THE USER. "Starting fresh" is never acceptable — every stash and every uncommitted change represents hours of work. The instinct to wipe-and-restart is a bug, not a strategy.
19. NEVER close or defer a ticket without 100% of the work being done. "Partially done" is NOT done. "Deferred" is NOT done. "Acceptable for bootstrap" is NOT done. If a ticket says "implement X" and X is not fully implemented per the spec, the ticket stays OPEN. If you can't finish it now, leave it open and move to the next one — do NOT close it with excuses. The only valid close reason is "all work described in this ticket is complete, tested, and committed." Adding a test without implementing the feature is NOT closing the ticket. Adding scaffolding without the logic is NOT closing the ticket. Workarounds are NOT closing the ticket.
20. NEVER close a parent ticket (epic) until ALL child tickets are genuinely closed with real completed work. "All sub-tasks resolved" means nothing if those sub-tasks were themselves closed without doing the work.

## Task Tracking — USE AGENT TASKS (`mcp__Agent_Tasks__*`)

All work is tracked in the **Agent Tasks MCP**. Use it for ALL task tracking —
`mcp__Agent_Tasks__create` / `update` / `close` / `comment` / `ready` / `search`
/ `show` / `list` / `tree` / `dep`. Do NOT use TodoWrite or markdown TODO lists.
Persistent knowledge goes in CLAUDE.md or project docs — never a MEMORY.md file.

Task IDs use the `forge-crafting-intepreters-*` scheme, so ticket references
throughout the codebase and these docs still resolve via `mcp__Agent_Tasks__show`.

**SEARCH before you FILE.** Before opening a ticket for a perf / test-runner /
compiler-memory / OOM symptom, `mcp__Agent_Tasks__search` it and skim the epics
`4apk` (COMPILER-FAST) and `uzs9` (test cycle speed) — that area is already
densely scoped (`snw0`, `08ro`, `pdme.*`, `i7gw`, `05yc`). Filing parallel
tickets (and re-diagnosing what they already document) burns a session; the
existing ones often already hold the answer.

## Session Completion

**When ending a work session**, you MUST complete ALL steps below. Work is NOT complete until `git push` succeeds.

**MANDATORY WORKFLOW:**

1. **File issues for remaining work** - Create issues for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **PUSH TO REMOTE** - This is MANDATORY:
   ```bash
   git pull --rebase
   git push
   git status  # MUST show "up to date with origin"
   ```
5. **Clean up** - Clear stashes, prune remote branches
6. **Verify** - All changes committed AND pushed
7. **Hand off** - Provide context for next session

**CRITICAL RULES:**
- Work is NOT complete until `git push` succeeds
- NEVER stop before pushing - that leaves work stranded locally
- NEVER say "ready to push when you are" - YOU must push
- If push fails, resolve and retry until it succeeds
