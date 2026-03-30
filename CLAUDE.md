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

```bash
cd forge/
LLVM_SYS_180_PREFIX=/opt/homebrew/opt/llvm@18 cargo build --release
```

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

**Read `forge/SELF_HOST_PLAN.md` for the milestone plan and `forge/scripts/audit_stage2.sh` for progress tracking.**

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
scripts/audit_stage2.sh output.ll
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

### Turn Reports — AFTER EVERY MAJOR CHANGE
After each significant change (commit, experiment, or discovery), give a brief inline report so progress is visible turn-by-turn, not just at session end:
```
TURN: [what changed] | Score: X → Y | [key finding or next step]
```
This prevents the user from losing track of what's happening between session reports.

### Key Learnings (from weeks of debugging)
- **The `{i64, ptr}` enum representation** matches the mini compiler. Was `{i8, ptr}` — fixed.
- **`Expr.IsCheck`** AST node handles `is` expressions in the codegen phase (was inline-only during parsing with CG_ACTIVE=true).
- **`resolve_type_to_llvm("ptr")`** must return `CG_PTR` not `CG_I64`.
- **`LLVMGetAllocatedType`** is the right way to determine load types — don't guess from flags.
- **Expression statements get dropped** when Statement.Expr tag doesn't match in `emit_statement`. This is a SYMPTOM of the type system — fix the types, not the expressions.
- **The 100 alloca cache misses are harmless** — they fall through to CG_VAR_NAMES lookup.
- **C-side workaround functions DO NOT SCALE** — we added 15+ and they didn't fix the root cause.
- **The forge-lang repo** (`../forge-lang`) already solved enum representation. Check it for reference.

### HARD RULES — NEVER VIOLATE

1. **ONE change at a time.** Make change → rebuild full pipeline → run audit → commit if score improves → revert if score worsens. NEVER batch changes.

2. **NEVER add C-side workaround functions to runtime.c to bypass codegen bugs.** Fix the CODEGEN that produces wrong output. The only C-side functions should be actual runtime utilities.

3. **Fix bugs at their source, not their symptoms.** If loads use wrong types, fix `emit_ident` to use `LLVMGetAllocatedType` — don't add type-tracking flags for each variable individually.

4. **NEVER rewrite working Forge source to work around codegen bugs.** Fix the codegen, not the source it compiles.

5. **ALWAYS run `scripts/audit_stage2.sh output.ll` after changes.** This is how we track progress. No exceptions.

6. **Follow `SELF_HOST_PLAN.md` milestones in order.** M1 (load types) → M2 (call types) → M3 (branch conditions) → M4 (ret undef) → M5 (hello world) → M6 (self-compile) → M7 (fixed point).

7. **If a change breaks the pipeline, REVERT immediately.** Do not try to fix the fix.

8. **The mini compiler (mini/codegen.fg) is the ROOT of the bootstrap chain.** Bugs in mini propagate through ALL stages. Check mini first when debugging.

9. **Always do the right thing.** Centralize logic, don't duplicate. If the same type-detection pattern appears in 3 places, extract it into one function. If a fix requires touching 5 call sites, fix the one function they all call. Hacks create more hacks — every shortcut taken costs 10x to undo later. When in doubt, do the clean thing even if it takes longer.

10. **Check the forge-lang repo FIRST.** Before attempting any fix, search `../forge-lang` for prior solutions. The i64 enum representation, heap-allocated payloads, and many codegen patterns were already solved there. We wasted days rediscovering things that were already done.

11. **Be honest about scope.** Never say "one more fix" or "this conversation turn." If you don't know how deep a problem goes, say so. Run the audit, look at the numbers, and give a real estimate based on data — not optimism.

12. **Do large refactors when necessary.** If the optimal solution requires restructuring significant code, DO IT. Don't avoid the right fix because it's "a large refactor." Avoiding refactors is how the codebase got into this state. The self-hosted codegen needs a proper type tracking system (like the mini's VAR_TYPES), not incremental patches on a broken flag system.

13. **Don't ignore bugs. Fix them immediately or record them.** If you find a bug while working on something else, either fix it right now (if small) or add it to SELF_HOST_EXPERIMENTS.md with a clear description so it gets fixed soon. Never silently skip over a bug hoping it doesn't matter — it always does.

14. **Search for empty/stub handlers.** Empty match arms like `.Break(s) -> {}` silently swallow behavior. Periodically grep for `-> {}` and `-> { }` in codegen/mod.fg to find stubs that should have real implementations. Every empty handler is a potential silent bug.
