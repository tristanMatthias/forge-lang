# Host Compiler Tech Debt

This file records limitations in the current Rust host compiler and bootstrap toolchain that affect the new `bootstrap/` project.

When host limitations force the bootstrap project away from the cleanest or most idiomatic Forge implementation, that deviation must be called out here explicitly. The point is to make "works under the host compiler today" visibly distinct from "ideal Forge code we actually want to keep".

The rule for this file is simple:

- if the limitation lives in the Rust host compiler or its runtime, record it here
- if we add a temporary mitigation in `bootstrap/`, record exactly what we changed
- when the self-hosted compiler replaces the host path, delete the mitigation and close the debt

This is not a backlog for new language features. It is only for debt caused by the current host compiler and bootstrap environment.

## Already done

The following bootstrap restart work is complete:

- created a clean standalone project in `bootstrap/` with its own `forge.toml`
- verified the Rust host compiler can build a fresh project directory outside the legacy self-host tree
- implemented the first milestone as a scanner-driven `tokens` command
- added golden scanner tests in `bootstrap/tests/scanner/`
- added a repeatable test harness in `bootstrap/scripts/test.sh`
- added expression AST and parser milestones with golden tests
- added a Chapter 7 tree-walk evaluator milestone with golden tests
- built the native `@std.process` support library needed by the bootstrap CLI

## Open host-compiler debt

### 1. `List.push()` is unsafe in the bootstrap path

**Status:** open  
**Severity:** critical  
**Where observed:** scanner milestone, April 8 2026

When the new bootstrap scanner stored tokens in memory using `List<Token>`, the generated program corrupted values immediately. Rewriting the token stream into four primitive lists still failed. The runtime printed repeated anomalies like:

```text
[list_push #N] ANOMALY ptr=0x0 len=0 size=...
```

This matches the broader lifetime/copying problem already described in [docs/feat_bootstrap_memory.md](/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/docs/feat_bootstrap_memory.md).

**What we did now**

- removed list-based token accumulation from the milestone
- switched the scanner to emit a deterministic rendered token stream directly
- kept the external scanner behavior correct and fully tested

**What must happen later**

- fix the host compiler/runtime so `List.push()` is correct for bootstrap code
- restore an in-memory token representation for the scanner and parser
- delete the rendered-string mitigation once the host fix is proven by tests

### 2. Bootstrap binaries emit internal debug noise on stderr

**Status:** open  
**Severity:** medium  
**Where observed:** scanner tests, April 8 2026

Successful bootstrap binaries currently print internal trace lines such as:

```text
[char_at #0] ptr=... len=... idx=...
```

This is not bootstrap project behavior. It is coming from the host-generated runtime path and pollutes normal command output.

**What we did now**

- updated `bootstrap/scripts/test.sh` to capture stderr separately and only print it on command failure

**What must happen later**

- remove the runtime debug logging at the source
- make successful bootstrap binaries silent on stderr unless the program explicitly writes there
- delete the stderr-capture suppression once the host runtime is clean

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

During the Chapter 7 evaluator work, small repros showed that the Rust host compiler/runtime can mis-handle user enum payloads once they cross certain function boundaries:

- methods returning user enums produced empty output even when the same enum matched correctly inline
- helper functions extracting `float` payloads from enum variants returned corrupted values like `0.0`
- the original evaluator implementation segfaulted in `forge_string_to_float` after corrupted payload extraction

The evaluator logic itself was correct. The failures came from moving `Value` enum payloads through helper functions in host-generated code.

**What we did now**

- rewrote the evaluator from mutable methods into plain free functions
- replaced the evaluator runtime `Value` enum with an explicit tagged `Value` struct
- kept the external `bootstrapc eval` behavior correct and fully tested

**Why this is not ideal Forge code**

In the long-term self-hosted compiler, the evaluator/runtime value model should be expressed as a real Forge tagged union or enum with clear helper methods. The current free-function + tagged-struct shape exists only because the host compiler miscompiles the more direct design.

**What must happen later**

- fix enum payload passing/extraction in the Rust host compiler/runtime
- restore a proper tagged union or enum-based runtime value model once the host path is trustworthy
- delete the tagged-struct mitigation after dedicated repro tests pass

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
