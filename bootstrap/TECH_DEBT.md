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
- added a Chapter 8 statements-and-state milestone with parser and runner tests
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
- represented statement sequences and runtime bindings as recursive chains instead of normal list-backed structures
- kept the external scanner behavior correct and fully tested

**Why this is not ideal Forge code**

The long-term bootstrap compiler should use ordinary in-memory collections for token streams, statement lists, and scope data where that is the clearest design. The current recursive-chain representation exists because host `List.push()` is not reliable enough to trust for bootstrap work.

**What must happen later**

- fix the host compiler/runtime so `List.push()` is correct for bootstrap code
- restore an in-memory token representation for the scanner and parser
- replace recursive chain structures with clearer collection-based representations where appropriate
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

### 6. Nullable returns from recursive enum-matching functions corrupt values

**Status:** open
**Severity:** critical
**Where observed:** evaluator variable lookup, April 8 2026

When a function returns `T?` (nullable) from within a `match` on a recursive enum, and the function recurses through the enum chain, the returned value is corrupted. Specifically, `lookup_binding` returning `Value?` through recursive `BindingList.Node` traversal produced `null` instead of the actual value for any binding that was not at the head of the chain.

Minimal reproduction:

```forge
let a = 1
let b = 2
a   // returns null instead of 1
```

The lookup for `a` requires one recursive step past `b` in the binding chain. The recursive return corrupts the `Value?` to `null`.

**What we did now**

- replaced `lookup_binding` return type from `Value?` to a non-nullable `LookupResult` struct with an explicit `found: bool` field
- callers check `result.found` instead of `result == null`

**Why this is not ideal Forge code**

A nullable return is the natural design for a lookup function. The struct wrapper with an explicit found flag exists only because the host compiler corrupts nullable returns from recursive enum matches.

**What must happen later**

- fix the host compiler so nullable returns from recursive enum-matching functions are correct
- restore `Value?` return type for lookup once the host is trustworthy
- delete the `LookupResult` wrapper

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

### 9. `@std.llvm` non-`_s` extern fns were not pulled into bootstrap binaries [FIXED]

**Status:** fixed in `forge/packages/forgec-rust/driver/driver.rs`, April 8 2026
**Severity:** was high — blocked Milestone 3 native codegen

The host compiler's static link of project-style bootstrap binaries
did not pull in the underlying non-`_s` C symbols from
`libforge_llvm.a`. The auto-generated `_s` wrapper for
`llvm.print_module_to_file` called
`dlsym("forge_llvm_print_module_to_file")` at runtime, which returned
null because the symbol was never linked, so the call silently
no-opped and no file was written.

**What we did**

- in `link_with_packages`, the host now collects every `extern fn`
  declared in any loaded package's `package.fg` and emits one
  `-Wl,-u,_<symbol>` flag per name, forcing the linker to keep those
  archive entries even when no Forge user code statically references
  them
- verified end-to-end: `bootstrapc compile prog.fg` now writes
  `prog.fg.ll` containing valid LLVM IR; `cc -o prog prog.fg.ll`
  links and the resulting binary returns the program's expression as
  its exit code

This fix is the host doing the right thing — every package extern is
intentionally part of the package's public ABI, so it must be
preserved at link time. The previous behavior was a quiet
correctness bug: declarations in `package.fg` claimed those symbols
existed at runtime, but the linker had stripped them.

### 10. Package `use` prescan only walks the entry file

**Status:** open
**Severity:** medium

The host compiler's `prescan_package_uses` runs against the tokens of
the entry file only (`src/main.fg`). Submodules brought in via `mod
foo` are NOT scanned, so packages they `use` are never loaded —
their extern fn list is missing, their native lib is not linked, and
their `-Wl,-u` flags are not emitted (see #9).

**What we did now**

- added a load-bearing `use @std.llvm` to `bootstrap/src/main.fg`
  even though only `src/codegen.fg` actually calls `llvm.*`. The
  comment in `main.fg` flags it as a host workaround.

**What must happen later**

- fix `prescan_package_uses` to walk every module reachable from the
  entry file (or to scan the project's full token stream after `mod`
  resolution, before the package loader runs)
- once that lands, delete the `use @std.llvm` line from `main.fg` and
  the surrounding comment

### 11. Re-matching the same enum value produces a corrupted payload

**Status:** open
**Severity:** high
**Where observed:** codegen.fg `emit_call`, April 8 2026

A function that does:

```forge
match callee {
    .Ident(n) -> eprintln(n)   // prints "add"
    _ -> ...
}
let name = match callee {
    .Ident(n) -> n
    _ -> "?"
}
eprintln(name)                 // prints empty / corrupted
```

…sees the second match's bound name come out empty even though the
first match printed it correctly. The host appears to invalidate the
enum payload pointer after the first destructure.

**What we did now**

- destructure the callee exactly once and immediately tail-call into
  a helper that takes the extracted name as a plain `string` arg

**What must happen later**

- fix the host so a value can be matched against multiple times
  without payload corruption

### 12. Recursive enum fields on a struct don't survive cross-function calls

**Status:** open
**Severity:** high
**Where observed:** codegen.fg `Codegen.fns: FnEnv`, April 8 2026

When a struct contains an `enum` field (e.g. `Codegen.fns: FnEnv`)
and the struct is passed by value through a chain of function calls,
the enum field is silently zeroed somewhere along the way. We
verified that the field is populated correctly in `compile_program`
and inside `emit_function_body`, but by the time `emit_top_level →
emit_stmt → emit_expr → emit_call` runs, `cg.fns` has reverted to
`.End`. Storing the same `FnEnv` in a `mut` global also did not
survive between functions.

**What we did now**

- removed the `fns` field from `Codegen` entirely
- look every function up by LLVM symbol name via
  `llvm.get_named_function(module, name)` instead of via a
  Forge-side symbol table
- this works because every bootstrap function currently has the
  same `(i64, i64, ...) -> i64` shape, so the call site can
  reconstruct the function type from the arg count alone

**What must happen later**

- fix the host so structs with enum fields round-trip safely across
  call boundaries
- once that lands, restore a real symbol table so we can store
  per-function metadata (return type, parameter types, source span)
  alongside the LLVM value

### 13. Passing a recursive enum payload directly into a helper crashes

**Status:** open
**Severity:** high
**Where observed:** codegen.fg `bind_params`, April 8 2026

`bind_params(cg, fn_val, params, 0, env)` consistently segfaults
when `params: ParamList` is the destructured payload of a `match
stmt { .Function(name, params, body) -> ... }` arm. The crash
happens *before* `bind_params`'s first statement runs — it's at the
call instruction itself. Renaming the helper to `bind_params_inline`
and dropping the `Codegen` argument made the call go through
unchanged.

**What we did now**

- pass only the primitives the helper actually needs (`builder`,
  `i64t`, `fn_val`, `params`, `idx`, `env`) and avoid passing
  `Codegen` to it

**What must happen later**

- fix the host so an enum payload bound by a `match` arm can be
  passed by value into another function without corrupting the call
  frame

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
