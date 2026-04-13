## Project Structure

Features are self-contained modules in `forge/compiler/features/`.
Each feature has: mod.rs (parser + checker + codegen metadata), and examples/.

### Adding a feature
1. Create directory in compiler/features/
2. Add `forge_feature!` macro with metadata in mod.rs
3. Add examples with `/// expect:` comments (these are tests AND docs)
4. Add `pub mod` line to features/mod.rs

### Finding code for a feature
Everything for a feature lives in its directory. Don't grep — go to the directory.
`forge features` shows all features with status and test counts.
`forge features <name>` shows details for one feature.

### Rules
- Never put feature-specific code in core/
- Core is infrastructure only: lexer, AST types, type system, codegen context
- **NEVER put package-specific or @std-specific code in core/ or features/.** The compiler must have zero knowledge of any specific package (cli, term, process, http, model, etc.). All package behavior must be expressed through the generic template/expansion system. If the generic system can't express it, extend the generic system — don't add special cases.
- **NEVER add brittle heuristics.** No string-matching source code to detect behavior (e.g., grepping for `model ` to decide isolation). If something needs special handling, use a proper mechanism: explicit annotations, type system checks, or structural analysis. This applies everywhere but ESPECIALLY in the compiler.
- Every example file must have a `/// expect:` comment
- Feature status must be accurate: draft (no tests), wip (some pass), testing (most pass), stable (all pass)
- When adding a new feature, update `forge/tests/programs/comprehensive.fg` to include a test section for it

## Build

### Rust Compiler (for features, tests, non-self-hosting work)
```bash
cd forge/
LLVM_SYS_191_PREFIX=/opt/homebrew/opt/llvm@19 cargo build --release
```

## Adding a Feature to the Bootstrap Compiler — MANDATORY PROCESS

Every new language feature MUST follow this process. No shortcuts, no
skipping steps, no "I'll add tests later." The process exists because
we've been burned by every shortcut listed here.

### CRITICAL RULE: Build What You Need

**If you discover a missing language feature or infrastructure gap while
working on something, STOP what you're doing and implement the missing
piece FIRST.** Then come back to the original task. Do NOT work around
missing features. Do NOT defer them. Do NOT hack a substitute.

Examples:
- Need extern fn declarations from Forge source? Add that feature first.
- Need to read enum tags at runtime? Add ptr indexing first.
- Need typed callbacks? Add typed function signatures first.
- Need to iterate a registry? Make sure the iteration pattern works first.

This is non-negotiable. Every workaround becomes permanent tech debt.
Build the foundation, then build on it.

### Phase 1: Plan & Scope

1. **Check ASSESSMENT.md** — is this feature already listed? Mark it
   in-progress. If it's not listed, add it.
2. **Check the Rust compiler** — `forge/packages/forgec-rust/features/`
   may already have a reference implementation with examples. Read it
   for semantics and edge cases before writing a single line of code.
3. **Identify seed impact** — does this feature add new keywords?
   If yes, you may need a seed cycle. NOTE: enum changes (adding
   variants, adding fields, reordering) do NOT require two-phase
   bootstrap — tags are hash-based (stable across reordering) and
   payloads are heap-allocated (stable across field changes).

### Phase 2: Two-Phase Bootstrap (if needed)

Required when: adding new keywords that the seed's scanner doesn't
recognize. NOT required for enum changes — tags are hash-based
(adding/removing/reordering variants is safe) and payloads are
heap-allocated (adding fields is safe).

**Phase A — Types only:**
1. Add new types/variants at the END of their enums. Never in the middle.
2. Do NOT use the new types anywhere yet.
3. `make build` — must pass including self-compile check.
4. Update seed: `./build/bs2 compile src/main.fg && cp src/main.fg.ll seed/seed.ll`
5. Clean rebuild: `rm -rf build && make build` — must pass.

**Phase B — Implementation:**
1. Now implement parser, codegen, resolver, type checker using the new types.
2. `make build` after every significant change — the self-compile check
   catches bootstrap chain breaks immediately.
3. Update seed when done: same as Phase A step 4-5.

If `make build` fails the self-compile check, your changes broke the
bootstrap chain. Fix before proceeding. Do NOT bypass this.

### Phase 3: Implementation Checklist

Every feature touches these files. Check each one:

- [ ] **AST** (`src/core/ast.fg`) — new Expr/Stmt/Pattern variant (at END)
- [ ] **Scanner** (`src/core/scanner.fg`) — new keyword in `keyword_kind` (if needed)
- [ ] **Parser** (`src/parse/mod.fg` or `src/features/<name>/parser.fg`) — parse the new syntax
- [ ] **Codegen** (`src/codegen/mod.fg` or `src/features/<name>/codegen.fg`) — emit LLVM IR
- [ ] **Resolver** (`src/core/resolver.fg`) — resolve names in the new construct
- [ ] **Type checker** (`src/typeck/mod.fg`) — type-check the new construct
- [ ] **Eval** (`src/core/eval.fg`) — handle in tree-walk interpreter (can be stub with error message)
- [ ] **AST renderer** (`render_expr`/`render_stmt` in `ast.fg`) — pretty-print for debugging

### Phase 4: Testing — AGGRESSIVE

This is where things break. Every feature must have:

1. **Basic test** — the happy path works. Create `src/features/<name>/example.fg`
   with matching `expected.out`.
2. **Edge cases** — empty inputs, single elements, max values, null,
   zero, negative numbers, empty strings.
3. **Combinatorial tests** — the new feature combined with EVERY other
   major feature. These are the real bug-finders:
   - With closures/lambdas (capture semantics)
   - Inside match arms (pattern context)
   - With nullable types (? operator, ??, null coalesce)
   - Inside if-expressions (both branches)
   - With structs and enums (field access, variant matching)
   - Inside for/while loops (break/continue interaction)
   - With pipe operator (|>)
   - With string templates (`${...}`)
   - With list/map operations (.map, .filter, etc.)
   - Nested inside itself (recursive structures)
   - As function arguments and return values
   - With `with` expressions (struct update)
   - With `defer` statements
4. **Regression test** — add to `regress/` with `.out` file. These run
   on every commit via the pre-commit hook.
5. **Error test** — if the feature has error cases, add to
   `src/features/error_messages/examples/` with `/// expect-error:`.

Run `make test` after writing tests. All 186+ tests must pass.

### Phase 5: Documentation

1. **Grammar** — create `src/features/<name>/grammar.md` describing the syntax.
2. **WHY comment** — add a WHY block at the top of each new file explaining
   what it does, when to read it, and when NOT to read it.
3. **ASSESSMENT.md** — mark the feature as ✅ with a brief note.
4. **Update feature count** in the ASSESSMENT.md header line.

### Phase 6: Dogfood

Once the feature works and tests pass:

1. **Search the bootstrap source** for places that could use the new feature.
   `grep` for patterns the new feature replaces.
2. **Refactor** bootstrap code to use the new feature where it improves
   clarity. This validates the feature in real code AND improves the
   codebase. Examples:
   - Added `with` expressions → refactor Ctx copy-helpers to use `with`
   - Added `?` operator → refactor error handling to use `?`
   - Added `is` keyword → refactor variant checks to use `is`
   - Added float → use float where appropriate in the compiler
3. **Update seed** after refactoring (the bootstrap source changed).
4. `make test` — all tests still pass after dogfooding.

### Phase 7: Commit

1. Commit with a clear message: `feat: <feature name> — <what it does>`
2. The pre-commit hook runs regression + selfhost check automatically.
3. If the hook fails, fix before committing. Never `--no-verify`.

### Anti-Patterns — NEVER DO THESE

- **Skip tests** — "it works in the happy path" is not tested.
- **Skip seed update** — the self-compile check exists for a reason.
- ~~**Add enum variants in the middle**~~ — FIXED: hash-based tags are stable across reordering.
- **Add keywords without Phase A** — the seed scanner won't recognize them.
- **Skip the resolver** — resolver errors crash at codegen time with
  unhelpful messages. Always handle new expressions in the resolver.
- **Skip the type checker** — the `_ ->` wildcard catches new variants
  silently but assigns wrong types.
- **Skip eval** — a missing eval arm silently falls through. Add at
  least an error stub.
- **Test only the happy path** — combinatorial tests with other features
  are where real bugs live.
- **Refactor later** — dogfooding the feature immediately validates it
  and prevents bit-rot.

### Self-Hosting Build Pipeline (Makefile)

## NEVER CONTEXT-BUDGET

Do not stop, defer, or take shortcuts because of "context budget", "running
out of context", "limited turns left", or any similar concern about your own
runtime. Do the work properly. If something needs 50 lines of refactor, do
the 50 lines. If something needs 3 fixes, do all 3. Never leave a workaround
in place "for now" because of perceived budget. Finish the job to the same
standard regardless of how much context has been used. The user explicitly
does not want you reasoning about your own context limits — ever.

**ALL self-hosting builds MUST use the Makefile. No ad-hoc commands.**

**⚠️ MINI IS DEPRECATED — DO NOT TOUCH IT.** The mini text-IR compiler
(`packages/forgec/src/mini/`, `make mini`, `make stage1-ir`, `make stage1`,
`make test-mini`) is no longer part of the active bootstrap chain. Do NOT
edit any file under `packages/forgec/src/mini/`, do NOT add `ir_raw`
declarations there, and do NOT debug `build/mini` or `build/stage1.ll`.

The active pipeline is **Rust compiler → Stage 1 binary → Stage 2 IR**:

```bash
make stage1-rust   # Rust compiler builds the self-hosted Stage 1 binary directly
make test-stage1   # Stage 1 compiles + runs hello world
make stage2-ir     # Stage 1 compiles main.fg → build/stage2.ll
make audit         # score Stage 2 IR
```

If you find yourself looking at mini source files or chasing missing
`forge_*` declarations in mini, STOP — you're on the wrong branch of the
build graph. Use `stage1-rust`.

```bash
cd forge/

# Build everything up to Stage 1 binary:
make stage1

# Individual steps:
make runtime      # compile stdlib/runtime.c → build/runtime.o
make mini         # Rust compiler builds mini → build/mini
make stage1-ir    # mini compiles source → build/stage1.ll
make stage1       # llc + link → build/stage1
make stage2-ir    # Stage 1 compiles source → build/stage2.ll
make audit        # audit Stage 2 IR quality (score)

# Testing:
make test-mini    # mini compiles + runs hello world

# Clean:
make clean        # remove build/ and artifacts
```

#### Pipeline Explained
```
Rust compiler (target/release/forgec)
  ↓ builds
Mini compiler (build/mini) — text-based IR generator
  ↓ compiles packages/forgec/src/main.fg
Stage 1 IR (build/stage1.ll) — LLVM IR for the self-hosted compiler
  ↓ llc + cc
Stage 1 binary (build/stage1) — self-hosted compiler, uses LLVM C API
  ↓ compiles packages/forgec/src/main.fg
Stage 2 IR (build/stage2.ll) — LLVM IR produced by Stage 1
  ↓ audit
Score (lower is better)
```

#### Current Status (April 4, 2026)
- `make stage1-rust` — WORKS (Rust compiler builds Stage 1 binary directly)
- `make test-stage1` — WORKS (Stage 1 compiles hello world)
- Stage 2 IR: score 155, 388 functions, llc passes, binary links + runs
- Stage 2 functional: 4/11 (tokenizes, parses, crashes at LLVM init — 0 fns scanned)
- `make stage1-ir` — BLOCKED (mini's llc error, use stage1-rust instead)

#### Key Constraints
- NEVER run self-hosting build commands directly — always use `make <target>`
- The Rust compiler has a `ptr != null` bug for namespace call returns — workaround: i64-based C-side functions or check `lhs.is_pointer_value()` in compile_binary_op
- BasicBlockRefs CANNOT survive Forge global store/load — use C-side `forge_loop_push/break` stack instead
- Struct methods use self-by-pointer (ptr, not value) for mutation persistence
- Parser kind_id dispatch runs BEFORE match-based dispatch — must produce correct AST nodes in BOTH paths

## Debugging & Analysis Tools

### Diagnostic System (`scripts/diagnose.sh`) — single entry point

**One script. One place to look. One place to add new checks.**

```bash
bash scripts/diagnose.sh --help          # ALWAYS START HERE
```

The `--help` lists every mode, every env var, every Forge-callable
runtime helper, and example invocations. A future agent only needs to
know that command — everything else is discoverable from there.

Most-used modes:
```bash
bash scripts/diagnose.sh --score         # IR quality score
bash scripts/diagnose.sh --type-diff     # function signatures that differ between rust and self-host
bash scripts/diagnose.sh --anomaly       # per-function anomaly score (worst first)
bash scripts/diagnose.sh --orphans       # functions with orphan blocks
bash scripts/diagnose.sh --diff-fn <fn>  # one-function IR diff
bash scripts/diagnose.sh --rank-diff     # rank all functions by diff size
bash scripts/diagnose.sh --whyi64 <fn> <param>   # why is this i64?
bash scripts/diagnose.sh --fuzz [count]  # differential fuzzer
bash scripts/diagnose.sh --regress       # regression suite
bash scripts/diagnose.sh --regress-add <name> <src.fg>   # capture a fix
```

**MANDATORY RULE**: When you discover a new class of issue, ADD A
CHECK for it to `scripts/diagnose.sh` (NOT a separate script). The
diagnostic system must grow over time to cover every possible failure
mode, and it must stay centralized so future agents can find it.

**MANDATORY RULE**: When you fix a bug, capture a regression test:
```bash
bash scripts/diagnose.sh --regress-add <bug-name> <minimal-repro.fg>
```
The `forge_regress/` directory is run by `--regress` and should pass
before every commit. We have repeatedly re-introduced bugs because we
don't have regression coverage.

Other scripts:
- `scripts/check_function.sh <name> [keyword]` — inspect one function's IR in output.ll
- `scripts/check_runtime_fns.sh` — pre-build check (run by Makefile)
- `scripts/lint-errors.sh` — error system quality

### Kind IDs (`core/kind_ids.fg`)
Token kind_id values are defined ONCE in `packages/forgec/src/core/kind_ids.fg`. The parser imports named constants (`KID_LET`, `KID_LBRACKET`, etc.) instead of magic numbers.

**Rules:**
- NEVER hardcode kind_id numbers in parser code — use `KID_*` constants
- If you add a new keyword, update BOTH `kind_ids.fg` AND `forge_kind_id_for_keyword()` in `runtime.c`
- Run `bash scripts/diagnose.sh --kind-ids` to verify consistency
- Constants use `export mut` (not `let`) because the Rust compiler compiles `let` as local allocas, not globals

### Debug Utilities (`stdlib/debug.c`)
Reusable debug functions for diagnosing self-hosting issues. These are NOT compiled into the runtime by default — include `debug.c` in your build when needed.

Available functions (call from Forge source):
```forge
forge_dump_stmt_list(stmts)          // Dump Statement list tags + raw bytes (112-byte stride)
forge_dump_token_kids(tokens, count) // Dump first N token kind_ids from a token list
forge_emit_fn_body_start()           // Mark body parsing active (filters other traces)
forge_emit_fn_body_end()             // Mark body parsing done
forge_parse_return_path(path_id)     // Trace which return path a parse function takes
forge_enable_peek_trace()            // Enable verbose forge_peek_kind_id tracing
```

### C-side Runtime Functions (runtime.c)
Tracing (no string allocation — safe in hot paths):
```forge
forge_trace_i64(val1, val2)          // Print two i64s to stderr: "[T] val1 val2"
forge_cg_trace_enable(1)             // Enable codegen tracing
forge_cg_trace_stmt(fn_name, tag)    // Log statement emission
forge_cg_trace_emit(label, val)      // Log value emission
forge_dump_function(fn_val)          // Dump LLVM function IR to stderr
```

**IMPORTANT**: Never use `eprintln("text" + string(val))` for tracing in hot paths (lexer, parser). String concatenation allocates and can cause infinite recursion. Always use `forge_trace_i64` or other C-side functions.

### C-side Registries (runtime.c)
All type/variable tracking uses C-side storage (immune to Forge list corruption):
- **Alloca cache**: `forge_alloca_cache_set/has/load/load_field` — per-function variable storage
- **Alloca type names**: `forge_alloca_cache_set_var_type/get_var_type` — Forge type names per variable
- **Struct types**: `forge_struct_type_register/get_fields/get_field_types`, `forge_struct_field_index`
- **Enum types**: `forge_enum_type_register/max_fields/exists`, `forge_enum_variant_fields_set/get`
- **Global variables**: `forge_global_var_register/count/name/is_str`, `forge_global_type_kind`
- **Global access**: `forge_get_named_global_i64`, `forge_store_to_global`, `forge_load_from_global`
- **Loop stack**: `forge_loop_push/pop/break/continue` — BasicBlockRef stack for break/continue
- **Per-function state**: `forge_fn_nullable_set/get_flag/get_inner/get_ret`, `forge_last_val_set/get/has/clear`
- **Emit depth**: `forge_emit_depth_push/pop`

### Known Issues
- **`ptr != null` produces `br i1 false`** when the variable's inferred type is `Unknown` (i64 alloca for pointer value). Fixed for standalone programs; some namespace call returns still affected. Root cause: `Type::Unknown` → `i64` alloca → pointer loaded as integer → comparison fails.
- **Enum layout**: `{i64 tag, ptr payload}` (16 bytes). Tags are djb2 hashes of variant names (stable across reordering). Payloads are heap-allocated. No two-phase bootstrap needed for any enum change.
- **Duplicate codegen paths**: `emit_statement` exists twice (line ~907 feature path, line ~2161 inline path). Both must handle all statement types. The inline path is used by `emit_fn_body_from_source`.

## CLI Commands

- `forge build <file.fg>` - compile
- `forge run <file.fg>` - compile and run
- `forge check <file.fg>` - type-check only
- `forge test` - run all feature example tests
- `forge test <feature>` - run tests for a specific feature
- `forge features` - list all features with status and test counts
- `forge features --graph` - show dependency graph
- `forge features <name>` - detailed info for one feature
- `forge explain <code>` - explain an error code
- `forge package new <name>` - scaffold a new package

## Performance

- Runtime.c is cached in `/tmp/forge_cache/` keyed by content hash + opt level. Cache is shared across all forge invocations. Delete this dir to force a rebuild.
- Tests run with `--dev` (O0) for faster compilation. The linker (`cc`) is the bottleneck (~100ms/test), not Forge itself (<1ms).
- Error tests (`/// expect-error:`) use `forge check` and skip linking entirely — they're near-instant.

## Error System — ZERO RAW ERRORS POLICY

**Every error the user sees MUST go through `CompileError::render()`.** No exceptions.

### Hard rules (enforced by code comments + tests)
- **NEVER use `eprintln!("error: ...")` for error output.** Use `CompileError::render()` instead. The only acceptable `eprintln!` is for non-error info (e.g., "compiled to X", profile output).
- **NEVER use `.unwrap()` on user-provided paths** — use `.ok_or_else(|| CompileError::...)` instead.
- **NEVER silently ignore package/parse errors** — `load_package()` and `parse_package_fg()` both return `Result` and propagate errors.
- **NEVER add `CompileError::Other`** — always create a specific variant with actionable help text.
- When adding a new error path: add a CompileError variant, a Display arm, a render() arm with help text, and a test in `error_messages/examples/`.

### Error codes
F0001 (syntax), F0002 (unterminated string), F0003 (unterminated template), F0006 (bad number), F0012 (type mismatch), F0013 (immutable assign), F0014 (wrong arg count), F0020 (undefined variable), F0030 (table column mismatch), F0801 (unused variable), F0900 (spec test), F9999 (ICE)

### CompileError variants
`FileNotFound`, `DiagnosticErrors`, `RuntimeNotFound`, `RuntimeCompileFailed`, `UndefinedSymbols`, `LinkerFileError`, `LinkerFailed`, `ObjectWriteFailed`, `PackageLoadFailed`, `PackageNotFound`, `CodegenFailed`, `BinaryRunFailed`, `CliError`

### Testing
- The `error_messages` feature has 50 tests covering all error codes and common user mistakes (semicolons, `=>`, `def`, `var`, `class`, single quotes, etc.)
- Test format: `/// expect-error: F0012` in `.fg` file → test runner uses `forge check` and asserts stderr contains the code
- Error tests run in <1s total (no linking needed)

## Self-Hosting — MANDATORY RULES

### ⚠️ DIFF-DRIVEN APPROACH IS THE ONLY ALLOWED WORKFLOW ⚠️

**Before doing ANY self-hosting work, read `forge/AST_CODEGEN_REFACTOR.md`'s
"MANDATORY APPROACH: DIFF-DRIVEN BUG HUNTING" section at the very top.**

The remaining stage 2 → stage 3 bugs are all divergences between
rust-emitted IR and self-hosted-emitted IR for the same `mod.fg` source.
The two codegens MUST produce equivalent IR. **Every divergence is the
bug.** Find them with `bash scripts/diagnose.sh --diff <fn_name>`, fix
the rust codegen path responsible, repeat. ONE fix typically unblocks
10-50 broken sites.

**DO NOT**:
- Bisect runtime crashes with eprintlns or lldb (symptoms, not cause)
- Add C-side workaround functions (15+ already added, none fixed roots)
- Rewrite mod.fg source to avoid codegen bugs (fix the codegen)
- Trust "stage 3 builds ✓" without verifying `/tmp/stage3` actually
  compiles a real test file and produces correct output (the diagnose
  script had a stale-artifact bug for most of one entire session;
  always be paranoid and re-check by hand)

**DO**:
- Diff one function at a time. The diff IS the bug.
- Fix rust codegen so its output matches what mod.fg expects
- After every fix, re-diff the same function to verify
- Then re-run the full pipeline and check the next function

This is documented in detail in `forge/AST_CODEGEN_REFACTOR.md`.

---

**Read `forge/SELF_HOST_PLAN.md` for the milestone plan and `forge/scripts/diagnose.sh --score` for progress tracking.**

**BEFORE trying any experiment, check `forge/SELF_HOST_EXPERIMENTS.md` to see if it was already tried. AFTER every experiment, log it there with the score result.**

### The Problem
The self-hosted codegen (`codegen/mod.fg`) defaults ALL types to i64 and uses global flags (CG_LAST_IS_STR, CG_LAST_IS_PTR, etc.) to track non-i64 types. This flag system misses most cases, producing ~7000 type errors in Stage 2 IR. The fix is to use LLVM's own type system (`LLVMGetAllocatedType`, `LLVMGlobalGetValueType`) instead of flag-guessing.

### The Bootstrap Chain
```
Rust → mini (mini/codegen.fg) → Stage 1 binary (419 fns)
Stage 1 → Stage 2 IR → patch → llc → Stage 2 binary
Stage 2 → Stage 3 IR (goal: identical to Stage 2 IR)
```

### Progress Tracking — ALWAYS DO THIS
After EVERY change, run the audit:
```bash
bash scripts/diagnose.sh --score output.ll
```
This produces a SCORE (lower is better). Current baseline: **7076**. If score goes DOWN, you're making progress. If it goes UP, revert.

### Session Reporting — END OF EVERY SESSION
At the end of every session, provide a status report:
```
=== SESSION REPORT ===
Milestone: M1 (or whichever is current)
Score: before → after (direction)
Changes: bullet list of what was done
Reverted: anything that was tried and reverted
Next: what to do next session
Blockers: anything that's stuck
```
Update the "Current" column in SELF_HOST_PLAN.md's progress table.

### Autonomous Mode
When told to continue until done: DO NOT STOP to ask questions. Work through milestones in order. Commit after each improvement. If stuck on one approach for more than 3 attempts, try a different approach. Log every experiment. Update the progress table. Keep going until all milestones are complete or context runs out.

### Turn Reports — AFTER EVERY MAJOR CHANGE
After each significant change (commit, experiment, or discovery), give a brief inline report so progress is visible turn-by-turn, not just at session end:
```
TURN: [what changed] | Score: X → Y | [key finding or next step]
```
This prevents the user from losing track of what's happening between session reports.

### Key Learnings (from weeks of debugging)
- **Kind_id mismatches are silent killers.** A single wrong kind_id (e.g., LBracket 126 vs 104) makes `parse_expr` fail for list literals, which makes `parse_var_binding` return null, which makes ALL function bodies contain only Expr statements. No error is reported. Always use `KID_*` constants from `core/kind_ids.fg` and run `--kind-ids` to validate.
- **Statement is 112 bytes, not 16.** The Rust compiler represents `Statement` as `{i8, i64×13}` = 112 bytes. Token is also 112 bytes. Don't assume `{i8, ptr}` = 16 bytes.
- **`export let` compiles to local allocas, not globals.** Use `export mut` for cross-module constants that need to be accessible at runtime. The Rust compiler treats `let` as function-local.
- **Nullable `return null` must use `maybe_wrap_nullable`, not `wrap_in_nullable`.** `wrap_in_nullable` always sets tag=1 (has value). For null literals, `maybe_wrap_nullable` detects const_zero and calls `create_null_value` (tag=0).
- **`LLVMGetAllocatedType`** is the right way to determine load types — don't guess from flags.
- **`llvm.type_of(param_val)`** for parameter allocas — not `resolve_type_to_llvm` (circular dependency in self-hosted code).
- **C-side workaround functions DO NOT SCALE** — we added 15+ and they didn't fix the root cause.
- **The forge-lang repo** (`../forge-lang`) already solved enum representation. Check it for reference.

### HARD RULES — NEVER VIOLATE

1. **ONE change at a time.** Make change → rebuild full pipeline → run audit → commit if score improves → revert if score worsens. NEVER batch changes.

2. **NEVER add C-side workaround functions to runtime.c to bypass codegen bugs.** Fix the CODEGEN that produces wrong output. The only C-side functions should be actual runtime utilities.

3. **Fix bugs at their source, not their symptoms.** If loads use wrong types, fix `emit_ident` to use `LLVMGetAllocatedType` — don't add type-tracking flags for each variable individually.

4. **NEVER rewrite working Forge source to work around codegen bugs.** Fix the codegen, not the source it compiles.

5. **ALWAYS run `bash scripts/diagnose.sh --score output.ll` after changes.** This is how we track progress. No exceptions.

6. **Follow `SELF_HOST_PLAN.md` milestones in order.** M1 (load types) → M2 (call types) → M3 (branch conditions) → M4 (ret undef) → M5 (hello world) → M6 (self-compile) → M7 (fixed point).

7. **If a change breaks the pipeline, REVERT immediately.** Do not try to fix the fix.

8. **The mini compiler (mini/codegen.fg) is the ROOT of the bootstrap chain.** Bugs in mini propagate through ALL stages. Check mini first when debugging.

9. **Always do the right thing.** Centralize logic, don't duplicate. If the same type-detection pattern appears in 3 places, extract it into one function. If a fix requires touching 5 call sites, fix the one function they all call. Hacks create more hacks — every shortcut taken costs 10x to undo later. When in doubt, do the clean thing even if it takes longer.

10. **Check the forge-lang repo FIRST.** Before attempting any fix, search `../forge-lang` for prior solutions. The i64 enum representation, heap-allocated payloads, and many codegen patterns were already solved there. We wasted days rediscovering things that were already done.

11. **Be honest about scope.** Never say "one more fix" or "this conversation turn." If you don't know how deep a problem goes, say so. Run the audit, look at the numbers, and give a real estimate based on data — not optimism.

12. **Do large refactors when necessary.** If the optimal solution requires restructuring significant code, DO IT. Don't avoid the right fix because it's "a large refactor." Avoiding refactors is how the codebase got into this state. The self-hosted codegen needs a proper type tracking system (like the mini's VAR_TYPES), not incremental patches on a broken flag system.

13. **Don't ignore bugs. Fix them immediately or record them.** If you find a bug while working on something else, either fix it right now (if small) or add it to SELF_HOST_EXPERIMENTS.md with a clear description so it gets fixed soon. Never silently skip over a bug hoping it doesn't matter — it always does.

14. **Search for empty/stub handlers.** Empty match arms like `.Break(s) -> {}` silently swallow behavior. Periodically grep for `-> {}` and `-> { }` in codegen/mod.fg to find stubs that should have real implementations. Every empty handler is a potential silent bug.

15. **NEVER work around corruption or bugs — FIX THEM.** If a data structure (Map, List, global variable) is corrupt, find and fix the root cause in the runtime or codegen. Never add parallel tracking systems, CSV string hacks, or alternative data paths to avoid the corrupt one. Every workaround becomes permanent tech debt that compounds. If Map is broken, fix Map. If List push corrupts, fix the push. The correct fix is always shorter than the workaround.

16. **NEVER use mutable global state for type tracking.** Variable types come from LLVM's own type system via `get_allocated_type()` on the variable's alloca. Struct/enum types come from `get_type_by_name()` on the LLVM context. No parallel lists, no CSV strings, no global flags. LLVM is the single source of truth for all type information.

17. **Use Map<string, ptr> for variable lookup, not parallel lists.** Variables should be stored in `Codegen.vars: Map<string, ptr>` (name → alloca). If Map has corruption bugs, fix the Map implementation in runtime.c — don't replace it with parallel List<string>/List<ptr> globals.

## Debugging — MANDATORY PROTOCOL

When you hit a segfault or crash in the bootstrap compiler, follow this
protocol. Do NOT guess, do NOT add eprintln traces that require seed
cycles, do NOT chase theories without evidence.

### Step 1: LLDB first (< 30 seconds)
```bash
lldb -b \
  -o 'target create ./build/bs2' \
  -o 'settings set -- target.run-args check /tmp/test.fg' \
  -o 'run' \
  -o 'bt' \
  -o 'register read x0 x1 x8 x9' \
  -o 'disassemble --pc --count 5'
```
This tells you the EXACT crash instruction, which register has the bad
value, and the full call stack. Takes 5 seconds, no rebuild needed.

### Step 2: Validate the pointer
Use `forge_trace_ptr(label, value)` in Forge source or check the address
range in LLDB:
- `0x100000000-0x200000000` → bump arena (valid)
- `0x600000000000` range → system heap (valid)
- `< 0x100000` → INVALID (null-ish, likely corrupt enum field)
- Stack addresses → near sp register value

### Step 3: Check -O0 vs -O2
```bash
$LLC -O0 -filetype=obj seed/seed.ll -o build/test.o && cc -o build/test ...
```
If -O0 works but -O2 crashes, it's an alignment/optimization bug.
(The old align 4 bug is FIXED — llvm_wrapper.c forces align 8.)

### Step 4: Check seed staleness
If bs2 crashes but the seed compiles fine, the seed is likely stale.
`make build` auto-cycles the seed when this happens. If the auto-cycle
doesn't help, run `bash scripts/diagnose.sh --seed-status` to see
which functions are new/changed.

### Available C-side tools (runtime.c)
```forge
forge_trace_ptr(label, value)       // prints ptr + region (bump/heap/stack)
forge_dump_stmt(label, stmt)        // prints Stmt tag name + field values
forge_dump_stmt_list(label, list)   // prints StmtList structure
forge_selfhost_trace_int(label, n)  // prints label + i64 to stderr
```

### Step 5: Check function name collisions
The bootstrap compiles all modules into a single LLVM module. Function
names are qualified by module path (e.g. `typeck::check_expr`), so
collisions are rare. The codegen detects duplicates and exits with
`FATAL: duplicate function`. Impl methods use `Type__method` naming.

### Rules
- **NEVER do more than ONE seed cycle to diagnose a crash.** Use LLDB.
- **NEVER guess the cause.** Read the register values. Read the IR.
- **NEVER chase heap corruption without first testing -O0.**
- **Function names are module-qualified** (e.g. `typeck::check_expr`).
  Duplicates are caught at compile time. Impl methods use `Type__method`.
- **Log EVERY crash diagnosis in TECH_DEBT.md** with the root cause,
  LLDB output, and fix. Future agents need this history.

## Known Bootstrap Pitfalls

1. **~~Two-struct-arg calling convention bug.~~** DEBUNKED. Tested
   with 4-field struct + int arg and 4-field struct + 2-field struct:
   both produce correct results. Previously attributed crashes were
   actually stale seed issues (now handled by auto-cycling).

2. **~~`align 4` on i64 loads.~~** FIXED. The `llvm_wrapper.c` forces
   `align 8` on all load/store instructions.

3. **Seed bootstrap — AUTO-CYCLING.** `make build` now automatically
   detects when bs2 can't self-compile (stale seed) and cycles the
   seed forward. You rarely need to run `make update-seed` manually.
   
   The auto-cycle works because: the seed compiles bs2 successfully
   (step 1 passes), so bs2's IR is a valid next-generation seed.
   The build copies it to seed.ll, rebuilds from the new seed, and
   retries. If that also fails, it restores the backup and shows
   diagnostics (which functions diverged, which are new, etc.).
   
   **When auto-cycle CAN'T help:** Changing something fundamental
   about the seed's own execution path (e.g. a new keyword the seed
   scanner doesn't recognize). Enum changes are now safe.
   
   **Diagnostic tools:**
   - `bash scripts/diagnose.sh --seed-status` — show new/removed/changed functions
   - `bash scripts/diagnose.sh --seed-diff <fn>` — diff a specific function's IR

   **`make build` catches this automatically.** After building bs2
   from the seed, it runs `bs2 compile src/main.fg` as a safety
   check. If bs2 can't compile itself, the build fails with a clear
   error explaining the bootstrap chain is broken. You will NEVER
   get a green build that silently can't self-host.

4. **render_list stack overflow.** DiagnosticList is a linked list.
   render_list is recursive. 100+ diagnostics = stack overflow. The
   limit is 10 (render_first_n). If you hit this, the resolver is
   producing too many errors — fix the source, don't increase the limit.

## Patterns That Waste Time — RECOGNIZE AND AVOID

These patterns have cost hours of debugging. Recognize them IMMEDIATELY
and apply the known fix instead of investigating from scratch.

### "undefined variable X" when compiling new source with old seed
**Symptom:** the old seed's resolver reports an undefined variable
that clearly IS defined in the new source.
**Root cause:** you changed a container type (ExprList, StmtList,
MatchArmList, etc.) to hold a different inner type. The old seed's
resolver destructures the old layout but gets the new data.
**Fix (historical):** two-phase bootstrap. This specific issue is
largely eliminated by hash-based tags and heap-allocated payloads, but
container STRUCTURE changes (e.g. adding a new field to ExprList.Node)
may still require a seed cycle.

### Build works for small files but fails on main.fg
**Symptom:** `./build/bs2 compile /tmp/small.fg` works, but
`./build/bs2 compile src/main.fg` crashes or errors.
**Root cause:** the full source has 8000+ lines compiled into one
LLVM module. Issues that don't appear in small files: scope depth
limits, stack overflow from recursive rendering, enum variant
ordering mismatches.
**Fix:** check if the error is from the old seed vs the new source
(struct layout mismatch). Use LLDB to find the exact crash point.

### ~~Adding new enum variants MUST go at the END~~ (FIXED)
**Status:** FIXED. Tags are now hash-based (djb2 of variant name).
Adding, removing, or reordering variants is safe. No position dependence.

**Previously:**
**Root cause (historical):** inserting a variant in the MIDDLE shifted
all subsequent tag numbers. The old seed's codegen used the old tags
but the new source has different values.
**Fix:** ALWAYS add new enum variants at the END. Never in the middle.
Apply to Expr, Stmt, ValueType, and all other enums.

### Naming: avoid shadowing function names with pattern variables
**Rule:** never use `sexpr`, `sstmt`, `expr`, `stmt` as pattern
variable names — they shadow function/type names and confuse the
resolver. Use short prefixes: `se` for SExpr, `ss` for SStmt,
`sv` for SExpr in value position.

### Seed cycle takes 3+ minutes — don't debug by adding eprints
**Rule:** use LLDB or C-side trace functions (forge_trace_ptr,
forge_dump_stmt). Never add eprintln traces that require a full
seed rebuild to test. Each seed cycle is 3 minutes of dead time.

## ABSOLUTE RULES (from user, non-negotiable)

1. **NEVER say "that's a bigger change" as a reason to skip work.** Do the work. If it needs 200 lines, write 200 lines. If it needs restructuring, restructure. No deferring.
2. **NEVER say "known limitation" when it's a bug.** Fix it.
3. **NEVER simplify a test to avoid a bug.** Fix the bug.
4. **NEVER leave a workaround and move on.** Fix the root cause.
5. **NEVER write to the memory system.** All persistent notes go in CLAUDE.md or project docs.
