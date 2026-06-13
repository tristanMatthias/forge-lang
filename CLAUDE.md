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
make coverage              # run all spec tests with coverage instrumentation
make run FILE=x            # compile and run a Avra program
make update-seed           # rebuild seed IR (default: verified). Add FAST=1 for inner loop.
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
- **Enforcement:** `diagnose.sh --check-bootstrap-window` — gate 1 rejects
  branches with seed commits since the merge-base; gate 2 rebuilds the
  branch's compiler source AT HEAD (what a push ships — untracked or
  uncommitted files don't count; commit first) from the integration seed in
  an isolated tree (cold unit cache) and smoke-runs the result. Wired into the pre-push hook
  (`bootstrap/scripts/pre-push`, chained from `.beads/hooks/pre-push`) and
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

### Dev-loop gotcha: a stale `bs2` can mask your change (KNOWN BUG — fix, don't build around)

This is a bug to be fixed (tickets `pdme.1` transitive-fingerprint, `6cks`
`source_newer_than` uses macOS `stat -f %m` on Linux), NOT intended
behavior — when those land, delete this note. Until then, be aware:
after editing a **non-entry** source file (e.g. `parse/mod.av`,
`desugar/mod.av`, `typeck/mod.av`), a plain `make build-quick` can re-link
the **previous** `bs2` (the compile cache keys on the entry file's
fingerprint, not transitive sources). Your edit then silently does
nothing.

So: if behavior doesn't change after a rebuild, do NOT conclude your code
is wrong — first confirm the binary actually recompiled. Verified-needed
force (keeps the seed binary, so ~60-90s, NOT the 3-min `make clean` seed
cycle; clearing `build/bs2` alone is insufficient — the CLI unit cache
must go too):

```bash
rm -rf packages/cli/src/build/cache && rm -f build/bs2 && make build-quick
```

This is narrow and deliberate (the CLI unit cache only) — it is NOT the
blanket `find packages -name cache -exec rm` anti-pattern below.

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
1. Check the TRD (`docs/TRD_V1.md`) and beads (`bd ready`) for related tickets
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
- **-O0 works, -O2 crashes:** alignment mismatch. Check LLVM type consistency.
- **Seed contamination:** auto-cycle overwrote seed.ll. Default `NO_AUTOCYCLE=1` is set.

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

- **Enum layout:** `{i64 tag, ptr payload}` (16 bytes). Tags are djb2 hashes (stable across reordering). Payloads heap-allocated.
- **Statement/Token size:** 112 bytes each (`{i8, i64x13}`), not 16.
- **`export let` vs `export mut`:** `let` compiles to local allocas. Use `mut` for cross-module globals.
- **Nullable `return null`:** use `maybe_wrap_nullable` (detects const_zero), not `wrap_in_nullable` (always tag=1).
- **Type info:** use `LLVMGetAllocatedType` / `get_type_by_name` — never global flags or parallel lists. LLVM is single source of truth.
- **Naming:** never shadow fn/type names with pattern vars (`expr`, `stmt`). Use short prefixes: `se`, `ss`, `sv`.
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

<!-- BEGIN BEADS INTEGRATION v:1 profile:minimal hash:7510c1e2 -->
## Beads Issue Tracker

This project uses **bd (beads)** for issue tracking. Run `bd prime` to see full workflow context and commands.

### Quick Reference

```bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --claim  # Claim work
bd close <id>         # Complete work
```

### Rules

- Use `bd` for ALL task tracking — do NOT use TodoWrite, TaskCreate, or markdown TODO lists
- Run `bd prime` for detailed command reference and session close protocol
- Use `bd remember` for persistent knowledge — do NOT use MEMORY.md files

**Architecture in one line:** issues live in a local Dolt DB; sync uses `refs/dolt/data` on your git remote; `.beads/issues.jsonl` is a passive export. See https://github.com/gastownhall/beads/blob/main/docs/SYNC_CONCEPTS.md for details and anti-patterns.

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
<!-- END BEADS INTEGRATION -->

## Beads sync on Claude Code Web (this repo) — READ THIS

This **overrides** the generic "issues.jsonl is a passive export" line in the
bd-managed block above. On Claude Code Web, beads sync is automatic and you do
**not** manage it manually:

- **Just use beads normally** — `bd create` / `bd update` / `bd close`. A `bd`
  wrapper (installed by `scripts/bootstrap.sh`) **auto-pushes** after every
  mutating command, so changes reach GitHub with no manual `bd dolt push`.
- **Source of truth is `refs/dolt/data`** (the Dolt DB ref), **not**
  `.beads/issues.jsonl` — which is **gitignored here and no longer committed**.
- On container start, `bootstrap.sh` hydrates the DB from `refs/dolt/data`.

Why it's non-standard (three Claude-Code-Web constraints, handled in
`bootstrap.sh::setup_beads_sync`):
1. the GitHub proxy only allows pushing the *working branch*, so `refs/dolt/data`
   is pushed **direct to github.com** via a fine-grained PAT in `$GH_TOKEN`
   (Contents:write, this repo only); reads/hydration go through the proxy (no token);
2. Dolt's data commits run with `commit.gpgsign=false` (the env's sign-server
   rejects them) — scoped to bd only, so your *source* commits keep signing.

Caveats: auto-push is **best-effort** — a failed push (network blip / expired
token) leaves the write local until the next successful push. Requires `GH_TOKEN`
in the environment; without it, beads is **read-only** (hydrate works, writes
won't sync). The token is fed via `GIT_ASKPASS` and never stored on disk or in
the repo. Beads' own general model is at
https://github.com/gastownhall/beads/blob/main/docs/SYNC_CONCEPTS.md — this repo
intentionally diverges from it for the reasons above.
