# Forge Feature Development Guidelines

> This document defines how every language feature in the Forge compiler must be built.
> Read this BEFORE writing any code. No exceptions.

## Philosophy

Forge exists to make complex things look elegant — like you're writing config files, not code.
The compiler must embody this same philosophy. Beautiful, modular, zero cruft.

## Architecture: Thin Core, Rich Features

The core compiler (`lexer/`, `parser/`, `typeck/`, `codegen/codegen/`) is **infrastructure only**.
It provides the skeleton: tokenization, AST types, type system primitives, LLVM emission.
It must contain **zero feature-specific logic**.

Every language capability lives in `features/<name>/` as a self-contained module.
Adding a new feature should require **zero changes to core** in the ideal case.
The only acceptable core touches are:
- New token types in the lexer (if truly new syntax)
- New AST variants in `parser/ast.rs` (if a new structural form)
- New `Type::` variants in `typeck/types.rs` (if a new type concept)

These are structural extensions, not logic. The logic lives in the feature.

## Feature Directory Structure

```
features/<name>/
  mod.rs          — forge_feature! macro with metadata, docs, error codes
  parser.rs       — impl Parser: parsing logic
  checker.rs      — impl TypeChecker: type checking logic
  codegen.rs      — impl Codegen<'ctx>: LLVM IR generation
  types.rs        — shared types (optional, only if needed)
  examples/       — .fg test files with /// expect: comments
```

Every feature MUST have:
- `forge_feature!` macro with: name, id, status, depends, enables, tokens, ast_nodes,
  description, syntax, short, long_description, grammar, category
- At least 3 example test files
- At least 1 error test file (`/// expect-error:`)
- Registration in `features/mod.rs` via `pub mod <name>;`

## The forge_feature! Macro

```rust
crate::forge_feature! {
    name: "Feature Name",
    id: "feature_id",
    status: Stable,              // Draft | Wip | Testing | Stable
    depends: ["other_feature"],
    enables: ["downstream"],
    tokens: ["keyword"],
    ast_nodes: ["NodeType"],
    description: "One-line summary",
    syntax: ["example syntax"],
    short: "feature_id — brief tagline",
    long_description: "
Multi-paragraph explanation written for a future LLM reader.
Explain WHAT it does, WHY it exists, HOW to use it, and
WHAT it's analogous to in other languages.
Include edge cases and gotchas.",
    grammar: "<rule> ::= ...",
    category: "Category",
}
```

## Documentation Standard

Every feature's `long_description` must be good enough that an LLM reading
`forgec lang <feature>` can:
1. Understand the feature completely without reading source code
2. Write correct Forge code using the feature
3. Know the edge cases and limitations
4. Understand the error messages it might encounter

After writing docs, run `./target/release/forgec lang <feature>` to verify rendering.

## Error Messages: The Gold Standard

Every error a user can trigger MUST:
- Go through `CompileError::render()` — never raw `eprintln!`
- Have an error code (F0xxx)
- Show the exact source location with a caret
- Include a `Help:` line with a concrete fix suggestion
- Be tested with a `/// expect-error: F0xxx` example file

Error messages are the primary user interface of a compiler.
They must be empathetic, specific, and actionable.

## Testing Philosophy

Tests are examples. Examples are documentation. Documentation is the spec.

**Tests are sacred. NEVER delete a test file to fix a failure.** Fix the compiler instead.
If a test exists, it represents a feature someone expects to work. Removing it
silently drops the requirement.

Every `.fg` file in `examples/` must have:
- A `/// # Title` doc comment
- A `/// description` explaining what it demonstrates
- `/// expect: output` or `/// expect-error: F0xxx`

Test naming: `<feature>_<what_it_tests>.fg`
- `bitwise_and.fg`, `bitwise_precedence.fg`, `bitwise_error_float.fg`

After implementing, **red team your own feature**:
- Try to break it with edge cases
- Try invalid inputs — verify errors are excellent
- Try combining with other features — verify no regressions
- Run the FULL test suite: `./target/release/forgec test`

**Commit test files early.** If tests are untracked, they can be lost if a process
crashes or an agent accidentally deletes them. Commit test files as soon as they're
written, even before the feature passes them.

## Code Style: Use Forge's Own Features

When writing Forge code (examples, tests, package.fg), use the language idiomatically:
- Template literals over string concatenation
- Match expressions over if/else chains
- Match tables for lookup-style mappings
- Pipe operator for data transformations
- `it` parameter for simple closures
- `with` expressions for immutable updates
- Destructuring where available
- Type inference — don't over-annotate

Before writing Forge code, ALWAYS run:
```
./target/release/forgec lang --full
```

## No Hardcoding. Ever.

- No string-matching source code to detect behavior
- No special cases for specific types/packages/names
- No if/else chains that enumerate known variants
- Everything must be generic, table-driven, or registry-based
- If something needs special handling, use a proper mechanism:
  annotations, type system checks, or structural analysis

## DRY: Reduce, Reuse, Eliminate

- If two features share logic, extract a helper
- If a pattern repeats 3+ times, abstract it
- If boilerplate exists, find a way to generate or eliminate it
- Shared runtime functions go in `stdlib/runtime.c`
- Shared codegen helpers go in the feature that owns the concept

When adding a field to a widely-used type (like `Type::Struct`), prefer a **centralized
registry** approach over changing every consumer. For example, per-field mutability uses
a `HashSet<(TypeName, FieldName)>` in the TypeChecker rather than adding a `mutable` bool
to every `(String, Type)` tuple in 16 files. The 16 files don't need to know about mutability —
only the assignment checker does.

## Design Decisions (Learned the Hard Way)

### Traits as Types (No `dyn` keyword)

Trait names ARE types. `let x: Greet = greeter` — the compiler auto-selects static vs dynamic
dispatch. No `dyn` keyword. The programmer describes intent, the compiler figures out implementation.
Under the hood: vtable thunks that take `ptr` as self, enabling heterogeneous collections.

### Implicit Self

Methods in `impl` blocks get `self` automatically — don't declare it as a parameter.
```forge
impl Counter {
  fn inc() { self.count = self.count + 1 }  // self is magic
  fn get() -> int { self.count }
}
```
Backward-compatible: explicit `self` still works but is unnecessary.

### Per-Field Mutability

Fields declare their own mutability: `type Counter = { mut count: int, name: string }`.
`let`/`mut` on bindings controls reassignment only. Methods can mutate `mut` fields without
special syntax. Immutable fields produce `F0031` errors on write.

**Implementation detail:** For types with `mut` fields, methods receive `self` as a pointer
(not by value) so mutations are visible to the caller. This is transparent to the user.

### Self by Pointer for Mut Fields

When a struct has ANY `mut` fields, ALL methods on it pass `self` by pointer automatically.
This is critical — without it, `self.pos = self.pos + 1` inside a method modifies a local
copy and the caller never sees the change. Verified with a mini lexer smoke test.

### Module Type Exports

Types and enums can be exported across modules with `export type` / `export enum`.
The resolver injects the declaration statement directly into the importing module's AST.
No name mangling needed for types — they're structural, not code.

### Positional Enum Fields

`Token.Ident("hello")` and `Token.Ident(value: "hello")` both work. Positional fields
use the param name as the type name (no `:` means the identifier IS the type).
The checker resolves `f.name` as a type via `resolve_type_name` when `f.type_ann` is None.

## Parallel Agent Safety

When running multiple agents in worktrees:
- Agents touching the same core files (ast.rs, types.rs, parser.rs) MUST run sequentially
- Each agent's changes should be reviewed and merged one at a time
- **Never let an agent delete files** — always fix the compiler, not the tests
- Commit test files before launching agents so they can't be lost
- If a rogue agent restructures the codebase, all subsequent agents will be on the wrong branch

## Build & Test Commands

```bash
cd /Users/tristanmatthias/projects/tristanMatthias/forge-lang/forge
LLVM_SYS_180_PREFIX=/opt/homebrew/opt/llvm@18 cargo build --release
./target/release/forgec test                    # ALL tests
./target/release/forgec test <feature>          # one feature
./target/release/forgec features                # list all features
./target/release/forgec lang <feature>          # view feature docs
./target/release/forgec lang --full             # full language spec
```

## Checklist Before Declaring Done

```
[ ] Feature directory created with all required files
[ ] forge_feature! macro with complete metadata and docs
[ ] Parser/checker/codegen implemented in feature dir (not core)
[ ] 3+ positive test examples with /// expect:
[ ] 1+ error test examples with /// expect-error:
[ ] Test files committed to git (not left untracked)
[ ] Red-teamed: edge cases, invalid inputs, feature combinations
[ ] Smoke test: write a small program that uses the feature end-to-end
[ ] forgec lang <feature> renders correctly
[ ] forgec test <feature> — all pass
[ ] forgec test — ALL tests pass (zero regressions, zero failures)
[ ] No hardcoded special cases anywhere
[ ] Code is clean, minimal, and idiomatic
```
