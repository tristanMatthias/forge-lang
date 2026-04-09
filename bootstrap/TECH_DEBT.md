# Host Compiler Tech Debt

This file records limitations in the current Rust host compiler and bootstrap toolchain that affect the new `bootstrap/` project.

When host limitations force the bootstrap project away from the cleanest or most idiomatic Forge implementation, that deviation must be called out here explicitly. The point is to make "works under the host compiler today" visibly distinct from "ideal Forge code we actually want to keep".

The rule for this file is simple:

- if the limitation lives in the Rust host compiler or its runtime, record it here
- if we add a temporary mitigation in `bootstrap/`, record exactly what we changed
- when the self-hosted compiler replaces the host path, delete the mitigation and close the debt

This is not a backlog for new language features. It is only for debt caused by the current host compiler and bootstrap environment.

## Open host-compiler debt

### 1. `List.push()` is unsafe in the bootstrap path

**Status:** open
**Severity:** critical
**Where observed:** scanner milestone, April 8 2026

When the new bootstrap scanner stored tokens in memory using `List<Token>`, the generated program corrupted values immediately. Rewriting the token stream into four primitive lists still failed.

**What we did now**

- removed list-based token accumulation from the milestone
- switched the scanner to emit a deterministic rendered token stream directly
- represented statement sequences and runtime bindings as recursive chains instead of normal list-backed structures
- kept the external scanner behavior correct and fully tested

**What must happen later**

- fix the host compiler/runtime so `List.push()` is correct for bootstrap code
- restore an in-memory token representation for the scanner and parser
- replace recursive chain structures with clearer collection-based representations where appropriate

### ~~2. Bootstrap binaries emit internal debug noise on stderr~~ (FIXED)

**Status:** fixed (April 9 2026)

**Resolution:** `[char_at]` removed from `runtime.c`. All std-llvm trace prints (`[BC]`, `[AF]`, `[GNF]`, `[GGVT]`) gated behind `FORGE_DEBUG_BUILDER` env var or removed. Silent `LLVMGetUndef`/`LLVMConstNull` fallbacks (build_call args, phi incoming) now emit `[std-llvm]` warnings.

### 3. Single-file `check` is not a reliable way to validate module-based bootstrap code

**Status:** open
**Severity:** low
**Where observed:** `forgec check ../bootstrap/src/scanner.fg`

Checking a module file directly produced missing-symbol errors for imported project modules, while checking/building the project root worked correctly. For bootstrap work, the project root is the reliable unit, not individual files.

**What we did now**

- use project-root builds and the bootstrap test script as the source of truth

**What must happen later**

- either make file-level `check` resolve project modules correctly
- or document it as intentionally unsupported for module-scoped files

### 4. Native package dependencies are not built automatically

**Status:** open
**Severity:** low
**Where observed:** first use of `@std.process` and `@std.fs`

Fresh projects can resolve package metadata, but native packages fail at link time unless their Rust libraries have already been built. The bootstrap project currently needs `@std.process` for CLI argument handling.

**What we did now**

- built `forge/packages/std-process` explicitly
- taught `bootstrap/scripts/test.sh` to build that native library if it is missing

**What must happen later**

- make the host toolchain build required native package artifacts automatically
- or provide a first-class bootstrap/dependency setup command

### 5. User enum payloads are unreliable across helper-function boundaries

**Status:** open
**Severity:** high
**Where observed:** evaluator milestone, April 8 2026

The Rust host compiler/runtime can mis-handle user enum payloads once they cross certain function boundaries: methods returning user enums produced empty output, helper functions extracting `float` payloads from enum variants returned corrupted values.

**What we did now**

- rewrote the evaluator from mutable methods into plain free functions
- replaced the evaluator runtime `Value` enum with an explicit tagged `Value` struct

**What must happen later**

- fix enum payload passing/extraction in the Rust host compiler/runtime
- restore a proper tagged union or enum-based runtime value model once the host path is trustworthy

### 6. Nullable returns from recursive enum-matching functions corrupt values

**Status:** open
**Severity:** critical
**Where observed:** evaluator variable lookup, April 8 2026

When a function returns `T?` (nullable) from within a `match` on a recursive enum, and the function recurses through the enum chain, the returned value is corrupted.

**What we did now**

- replaced `lookup_binding` return type from `Value?` to a non-nullable `LookupResult` struct with an explicit `found: bool` field

**What must happen later**

- fix the host compiler so nullable returns from recursive enum-matching functions are correct
- restore `Value?` return type for lookup once the host is trustworthy

### 7. `return` is not allowed in bare match arms

**Status:** open
**Severity:** low
**Where observed:** eval.fg function milestone, April 8 2026

The host compiler rejects `return` as the expression in a bare (non-braced) match arm:

```forge
_ -> return error_result(...)   // rejected: "expected expression, got Return"
_ -> { return error_result(...) }  // works
```

**What we did now**

- wrapped all bare match arm `return` statements in braces

**What must happen later**

- fix the host compiler parser to accept `return` in bare match arm position
- or document this as intentionally unsupported syntax

### 8. Enum variant names that match keywords are rejected

**Status:** open
**Severity:** low
**Where observed:** eval.fg function milestone, April 8 2026

The host compiler rejects `Return` as an enum variant name, presumably because it case-insensitively conflicts with the `return` keyword. We renamed `Stmt.Return` to `Stmt.Ret` to work around this.

**What we did now**

- renamed `Return` variant to `Ret` and added a separate `RetEmpty` variant

**What must happen later**

- fix the host compiler to correctly distinguish uppercase variant names from lowercase keywords

### 9. Package `use` prescan only walks the entry file

**Status:** open
**Severity:** medium

The host compiler's `prescan_package_uses` runs against the tokens of the entry file only (`src/main.fg`). Submodules brought in via `mod foo` are NOT scanned, so packages they `use` are never loaded.

**What we did now**

- added a load-bearing `use @std.llvm` to `bootstrap/src/main.fg` even though only `src/codegen.fg` actually calls `llvm.*`. The comment in `main.fg` flags it as a host workaround.

**What must happen later**

- fix `prescan_package_uses` to walk every module reachable from the entry file
- once that lands, delete the `use @std.llvm` line from `main.fg`

## Related existing documents

These documents already capture older bootstrap debt and should stay in sync with what we learn here:

- [docs/feat_bootstrap_memory.md](/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/docs/feat_bootstrap_memory.md)
- [forge/docs/SELF_HOSTED_HACKS.md](/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/forge/docs/SELF_HOSTED_HACKS.md)
- [CLAUDE.md](/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/CLAUDE.md)

## Exit criteria

This file should shrink over time. For each item above, the correct end state is:

- the host limitation is fixed at the source, or becomes irrelevant after self-hosting
- the mitigation in `bootstrap/` is deleted
- the tests continue to pass without the mitigation
