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

**Read `forge/SELF_HOST_PROGRESS.md` before touching ANY self-hosting code.**

The self-hosted compiler (`packages/forgec/`) is compiled through a fragile bootstrap chain. These rules exist because violating them caused days of wasted work and regressions.

### The Bootstrap Chain
```
Rust bootstrap (68 type errors, fragile) → Stage 1 binary → Stage 2 binary → Stage 3
```
`forge/stage1_bootstrap` is a saved working Stage 1 binary. It is the ONLY reliable way to produce Stage 2. If lost, recreate from commit 64299d9 source + pre-span runtime.

### HARD RULES — NEVER VIOLATE

1. **ONE change at a time.** Make a change. Test FULL pipeline (bootstrap → llc → link → Stage 1 runs → builds Stage 2 → Stage 2 runs). Commit. Then next change. NEVER batch changes.

2. **NEVER modify `emit_fn_call_direct` or `emit_call` in codegen/mod.fg.** The Rust bootstrap generates fragile code. Adding even ONE line to these functions breaks the tokenizer (385 → 18 fns). Fix behavior OUTSIDE these functions (in callers, in the Let handler, in the parser).

3. **NEVER rewrite working code to work around codegen bugs.** If `collect_module_paths` works with `stage1_bootstrap`, leave it alone. Fix the codegen, not the source it compiles.

4. **NEVER add new runtime function declarations to codegen.** The bootstrap drops new `llvm.add_function` calls. Only 8 string functions work: `forge_string_new`, `forge_string_concat`, `forge_string_char_at`, `forge_string_length`, `forge_string_eq`, `forge_string_compare`, `forge_string_substring`, `forge_string_index_of`.

5. **ALWAYS preserve working binaries.** After any successful Stage 1 build, copy to `forge/stage1_bootstrap`. /tmp files vanish on restart.

6. **ASK before deviating from the plan in `SELF_HOST_PROGRESS.md`.** Do not silently change approach. Stop, explain what's happening, and ask.

7. **If a change breaks the pipeline, REVERT immediately.** Do not try to fix the fix. Revert, understand why it broke, then try a different approach.
