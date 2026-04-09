# Bootstrap Plan

This is the implementation plan for the new self-hosting restart in `bootstrap/`.

The goal is not to recreate the existing Rust compiler feature-for-feature.
The goal is to build the smallest Forge compiler that can fully self-host, and to do it in the same broad order as *Crafting Interpreters*.

The roadmap below follows the book chapter progression where that is appropriate, and explicitly marks where we adapt the book for Forge's native compiler pipeline instead of copying jlox or clox literally.

## Scope Rules

- Keep the source language subset minimal until self-hosting is stable.
- No legacy bootstrap hacks from `forge/packages/forgec`.
- No "temporary" feature work that is not required for self-hosting.
- Every milestone must build and test cleanly before the next one starts.
- Host-compiler limitations belong in [TECH_DEBT.md](/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/TECH_DEBT.md), not hidden in code comments.
- **When the bootstrap is forced to do something awkward to dodge a host-compiler bug, FIX THE HOST FIRST whenever the host fix is small and well-understood.** The host compiler lives at `forge/packages/forgec-rust/` and is plain Rust — most bugs we hit while writing bootstrap code are localised (a single match arm, a missing target-type hint, a bad codegen path) and take less time to fix at the source than to work around three different ways. Workarounds in `bootstrap/src/` are only acceptable when:
  1. The host fix is genuinely large or risky, AND
  2. The workaround is recorded in `TECH_DEBT.md` with a clear undo plan.
  Otherwise: change `forge/packages/forgec-rust/`, rebuild forgec, retest bootstrap, and commit the host fix as its own commit. This is faster overall and stops bootstrap from accreting hacks that we then have to clean up before the second-generation build can succeed.

## Definition Of Done

The bootstrap compiler is done when all of the following are true:

- it is written in Forge
- it can compile its own source tree
- the resulting compiler can compile the same source tree again
- the second-generation compiler passes the same test suite
- host-only mitigations recorded in `TECH_DEBT.md` are either deleted or no longer on the execution path

## Current Status

- [x] Create a new clean project outside the legacy self-host compiler tree
- [x] Verify the Rust host compiler can build that standalone project
- [x] Add a bootstrap test harness
- [x] Add the first working milestone: scanner-driven `tokens` command
- [x] Add scanner golden tests
- [x] Record host-compiler limitations and current mitigations in `TECH_DEBT.md`
- [x] Add the first expression AST + parser milestone
- [x] Add expression parser golden tests
- [x] Add the Chapter 7 tree-walk expression evaluator
- [x] Add evaluator golden tests
- [x] Add the Chapter 8 statements-and-state parser milestone
- [x] Add statement runner golden tests
- [x] Add control flow (`if`/`else`, `while`) with parser and runner tests
- [x] Discover and mitigate host nullable-return corruption (TECH_DEBT #6)
- [x] Add functions (declarations, calls, return, recursion) with tests
- [x] Add `println` and `string` builtins
- [x] Add logical operators (`&&`, `||`) with short-circuit evaluation
- [x] Add resolver pass with `check` command and error tests
- [x] Complete Milestone 2: Front-End Without Codegen

## Plan By Chapter

### Part A: Project Setup

- [x] Create `bootstrap/` with its own `forge.toml`
- [x] Add `README.md`
- [x] Add `TECH_DEBT.md`
- [x] Add repeatable local test script
- [ ] Add a bootstrap build script that covers host build, self-build, and re-build
- [ ] Add fixed-point self-host verification script

### Part B: Scanning

Crafting Interpreters reference: Chapter 4, "Scanning".

- [x] Define a stable token output format for tests
- [x] Implement scanner support for comments, punctuation, numbers, strings, identifiers, and core keywords
- [x] Emit precise line and column information
- [x] Add scanner golden tests
- [ ] Expand scanner coverage to the full MVP self-host subset
- [ ] Add scanner error tests
- [ ] Replace rendered token-stream mitigation with in-memory token storage once host debt is fixed

### Part C: Representing Code

Crafting Interpreters reference: Chapter 5, "Representing Code".

- [x] Define the minimal AST for the MVP compiler
- [x] Keep the AST small: declarations, statements, expressions, and type references needed for self-hosting
- [x] Add AST rendering or debug output for tests
- [x] Add parser fixtures that validate AST shape

### Part D: Parsing Expressions

Crafting Interpreters reference: Chapter 6, "Parsing Expressions".

- [x] Implement precedence-based expression parsing
- [x] Support literals, identifiers, grouping, unary ops, and binary ops
- [x] Keep precedence rules explicit and tested
- [x] Add parser tests for associativity and precedence
- [x] Extend expression parsing to assignment
- [ ] Extend expression parsing to calls when functions need them

### Part E: Evaluating Expressions

Crafting Interpreters reference: Chapter 7, "Evaluating Expressions".

We are not building a tree-walk interpreter as the end product, but we are following Chapter 7 directly as a front-end milestone before any codegen work starts.

- [x] Add a tree-walk evaluator for the current expression subset
- [x] Define the minimal runtime value model required for literals, strings, booleans, and null
- [x] Add runtime errors for invalid unary and binary operator usage
- [x] Keep this phase free of target-code emission
- [ ] Decide whether to keep the evaluator as a long-term semantic harness once native codegen exists

### Part F: Statements And State

Crafting Interpreters reference: Chapter 8, "Statements and State".

- [x] Parse `let`, `mut`, expression statements, and blocks
- [x] Parse assignment expressions and wire them into statement execution
- [x] Parse `return`
- [ ] Implement global declarations required by the bootstrap compiler source
- [x] Add local lexical name binding for the statement runner
- [x] Add tests for shadowing behavior and block-local state

### Part G: Control Flow

Crafting Interpreters reference: Chapter 9, "Control Flow".

- [x] Parse and validate `if`
- [x] Parse and validate `while`
- [ ] Add the minimal `for` form only if the bootstrap compiler source truly needs it
- [x] Add control-flow tests before codegen work starts

### Part H: Functions

Crafting Interpreters reference: Chapter 10, "Functions".

- [x] Parse function declarations and function calls
- [x] Support parameters and return values for the MVP subset
- [x] Add a function symbol table and call validation
- [x] Add recursive function tests
- [ ] Add module-level function ordering tests

### Part I: Resolving And Binding

Crafting Interpreters reference: Chapter 11, "Resolving and Binding".

- [x] Implement lexical scope resolution
- [x] Resolve locals vs globals explicitly
- [x] Reject invalid reads before initialization
- [x] Add scope-depth tests
- [ ] Add closure planning only if still required for self-hosting

### Part J: Classes And Inheritance, Deferred

Crafting Interpreters reference: Chapters 12 and 13.

These are not part of the MVP unless the bootstrap compiler source genuinely requires them.

- [ ] Decide whether methods/struct-associated functions are required before self-hosting
- [ ] If not required, leave classes/inheritance out of the MVP entirely
- [ ] If required later, add them after the compiler already self-hosts

## Plan By Backend Adaptation

The second half of *Crafting Interpreters* builds clox, a bytecode VM. We skip the VM
and emit LLVM IR directly. The book's concepts map cleanly:

| Book concept (clox)       | Our approach (LLVM)                               |
|---------------------------|----------------------------------------------------|
| Bytecode chunk            | LLVM module + functions                            |
| `OP_CONSTANT`             | LLVM constant values                               |
| `OP_ADD`, `OP_MULTIPLY`   | `add`, `fmul` instructions                         |
| `OP_JUMP_IF_FALSE`        | `br i1 %cond, label %then, label %else`            |
| `OP_CALL` + stack frames  | LLVM `call` + function definitions                 |
| `OP_GET_LOCAL/GLOBAL`     | `load` from allocas / globals                      |
| Value union (NaN-boxing)  | LLVM struct types, tagged unions                   |
| GC heap objects           | malloc + runtime (no GC in MVP, leak-and-exit)     |

The codegen walks the AST directly — no intermediate bytecode. Each AST node lowers
to LLVM instructions via the LLVM C API.

### Part K: LLVM Scaffolding

Crafting Interpreters reference: Chapters 14-15 (VM setup), adapted to LLVM.

- [ ] Add a `codegen.fg` module that creates an LLVM module, builder, and context
- [ ] Emit a minimal `main` function that returns an integer exit code
- [ ] Link with `cc` to produce a runnable binary
- [ ] Add a `compile` command to the bootstrap CLI
- [ ] Add codegen golden tests that compile and run small programs
- [ ] Verify the full pipeline: source → parse → codegen → LLVM IR → binary → run

### Part L: Compiling Expressions

Crafting Interpreters reference: Chapters 16-17 (scanning + compiling expressions).

Scanning is already done (Part B). This part lowers expressions to LLVM IR.

- [ ] Emit integer/float constants
- [ ] Emit arithmetic (`+`, `-`, `*`, `/`) as LLVM instructions
- [ ] Emit comparisons (`<`, `<=`, `>`, `>=`, `==`, `!=`) as `icmp`/`fcmp`
- [ ] Emit boolean logic (`&&`, `||`) with short-circuit basic blocks
- [ ] Emit unary operators (`-`, `!`)
- [ ] Emit grouping (just recurse, no IR needed)
- [ ] Add codegen tests for expression evaluation

### Part M: Variables And Storage

Crafting Interpreters reference: Chapters 21-22 (globals and locals).

- [ ] Emit `alloca` for local variables (`let`, `mut`)
- [ ] Emit `store`/`load` for variable access and assignment
- [ ] Handle block scoping (allocas in entry block, scoped lifetime)
- [ ] Add codegen tests for shadowing, assignment, and nested blocks

### Part N: Control Flow

Crafting Interpreters reference: Chapter 23 (jumping back and forth).

- [ ] Emit `if`/`else` as conditional branches between basic blocks
- [ ] Emit `while` as loop with back-edge basic blocks
- [ ] Ensure all basic blocks are properly terminated
- [ ] Add codegen tests for nested control flow

### Part O: Functions And Calls

Crafting Interpreters reference: Chapter 24 (calls and functions).

- [ ] Emit LLVM function definitions with typed parameters
- [ ] Emit `call` instructions for function calls
- [ ] Emit `ret` for return statements
- [ ] Handle `println` as an extern call to a C runtime function
- [ ] Add codegen tests for recursion (fibonacci) and early return

### Part P: Runtime Value Representation

Crafting Interpreters reference: Chapter 18 (types of values).

This defines how Forge values map to LLVM types at the ABI level.

- [ ] Define string representation (pointer + length, or null-terminated C strings)
- [ ] Define enum/tagged-union representation (i8 tag + payload struct)
- [ ] Define nullable representation (i8 tag + value)
- [ ] Link against the existing Forge runtime for string operations (concat, substring, etc.)
- [ ] Add ABI-level tests for value passing between functions

### Part Q: Strings

Crafting Interpreters reference: Chapter 19 (strings).

- [ ] Emit string literals as global constants
- [ ] Emit string concatenation via runtime call
- [ ] Emit string comparison via runtime call
- [ ] Emit string indexing and `.length` access
- [ ] Emit `.substring()` via runtime call
- [ ] Add codegen tests for all string operations used by the bootstrap source

### Part R: Structs And Enums

Not in Crafting Interpreters — Forge-specific.

- [ ] Emit struct types as LLVM named struct types
- [ ] Emit struct construction (field initialization)
- [ ] Emit field access as `getelementptr` + `load`
- [ ] Emit enum types as tagged unions (`{i8, max-payload-struct}`)
- [ ] Emit `match` as a chain of tag comparisons + payload extraction
- [ ] Emit nullable types as tag-0/tag-1 enums
- [ ] Add codegen tests for struct and enum patterns used by the bootstrap source

### Part S: Modules And Imports

Not in Crafting Interpreters — Forge-specific.

- [ ] Compile multiple source files into one LLVM module
- [ ] Resolve cross-module function references
- [ ] Resolve cross-module type references
- [ ] Add codegen tests for the bootstrap module structure

### Part T: Closures, Deferred

Crafting Interpreters reference: Chapter 25.

- [ ] Not required for the bootstrap MVP
- [ ] Defer until after self-hosting unless the bootstrap source genuinely needs them

### Part U: Memory Management

Crafting Interpreters reference: Chapter 26 (garbage collection).

For the bootstrap MVP, we use the simplest correct strategy: malloc, never free.
The compiler runs once and exits — leaked memory is reclaimed by the OS.

- [ ] Use malloc for heap-allocated values (strings, enum payloads)
- [ ] No GC in the MVP
- [ ] Add memory strategy notes for post-self-hosting optimization
- [ ] Defer real memory management until the compiler can rebuild itself

### Part V: Optimization, Deferred

Crafting Interpreters reference: Chapter 30.

- [ ] No optimizer work before self-hosting
- [ ] Only optimize after self-host builds are repeatable and diffable

## Self-Hosting Milestones

### Milestone 1: Scanner Tool

- [x] Build standalone scanner binary
- [x] Print stable token stream
- [x] Add golden tests

### Milestone 2: Front-End Without Codegen

- [x] Parse source into AST
- [x] Evaluate the Chapter 7 expression subset
- [x] Execute the Chapter 8 statement/state subset
- [x] Resolve names and validate the MVP subset
- [x] Add tests for parse and resolution failures

### Milestone 3: Native Codegen For The MVP Subset

- [x] Emit LLVM IR for integer expressions and print the result
- [x] Emit variables, assignment, and block scoping
- [x] Emit control flow (if/else, while)
- [x] Emit function definitions and calls
- [x] Emit string literals + `println` + string concat (`+`) via libc
- [x] Emit struct types, struct literals, and field access
- [x] Emit enums (tagged unions) with constructors
- [x] Emit match statements as conditional branches with payload binding
- [x] `impl Type { fn name(self, ...) }` desugars to `Type__name(self, ...)`
- [x] Method-call dispatch via `obj.method(args)` based on value type tag
- [x] `use ...` and `mod ...` parse as no-ops (single-file MVP)
- [x] `export` keyword as no-op modifier
- [x] Struct-literal field-init shorthand `Foo { name }`
- [x] Typed function parameters and return type annotations
- [x] Emit module imports and cross-file compilation
- [x] Compile the bootstrap compiler source with itself (syntactic milestone — produces a linked binary; semantic self-host requires real codegen for the @std.llvm namespace, see post-MVP TODO)

### Remaining bootstrap-source-syntax gaps

To actually feed `bootstrap/src/*.fg` into the bootstrap compiler we still need:

- [ ] Indexing: `text[i]` returning a single-char string or i64 byte
- [ ] String equality and comparison via `==` / `!=` (currently only ints)
- [ ] String method `.length` (✅ partial — only works on direct exprs of `str` type)
- [ ] String method `.substring(start, end)`
- [ ] `for x in iter` loops
- [ ] Block expressions (so a brace block can return its last expression)
- [ ] Match-as-expression with non-block bodies (`.Variant(x) -> expr`)
- [ ] Nullable types `T?` parsed and lowered
- [ ] Force-unwrap operator `expr!`
- [ ] Negative integer literals
- [ ] List literals and operations (`List<T>`, `.push`, `.length`, indexing)
- [ ] String escapes inside literals (`\n`, `\t`, `\\`, `\"`)
- [ ] Multi-file modules (concatenation OR proper module system)
- [ ] `extern fn` declarations
- [ ] Builtin functions: `int(text)`, `string(value)`, `read_file`, `write_file`, etc.

### Milestone 4: Fixed-Point Self-Host

- [ ] Build compiler A with the Rust host compiler
- [ ] Build compiler B with compiler A
- [ ] Build compiler C with compiler B
- [ ] Verify B and C are equivalent by behavior and stable artifacts where reasonable

### Milestone 5: Delete Host-Only Mitigations

- [ ] Remove scanner rendered-stream mitigation
- [ ] Remove test harness stderr suppression once runtime noise is fixed
- [ ] Retest from clean checkout using only documented bootstrap steps

## Explicit Non-Goals Before Self-Hosting

- [ ] no classes unless forced
- [ ] no inheritance unless forced
- [ ] no closures unless forced
- [ ] no registries, extensibility layers, or full feature-plug-in architecture
- [ ] no optimization work
- [ ] no parity chase with the current Rust compiler

## Future Tooling Ideas

Not yet built — pull off the shelf when there's a concrete bug they
would have helped diagnose.

- **`--trace-codegen`** in the bootstrap compiler: emit each LLVM IR
  line with a sidecar comment naming the Forge source span / AST node
  that produced it (e.g. `; from emit_binary, parser.fg:961`). Lets
  `diagnose.sh --diff` say "this divergence is from `emit_binary` on
  line X" instead of just dumping the raw IR diff. Add when we hit a
  divergence we can't trivially eyeball.

- **`--dump-types`** in the bootstrap compiler: print the inferred
  Forge type tag (`i64`, `str`, `enum:Token`, etc.) for every
  expression and every variable load. Useless today because bs2's
  type tracker is "everything is i64 unless flagged otherwise" — there
  is no real type lattice to dump. Add only after we replace the
  flag-based tracking with a real per-alloca type table (the same
  refactor M1 in forge/SELF_HOST_PLAN.md describes for the Rust
  compiler — bs2 will need it eventually).

## Source References

This plan is based on:

- *Crafting Interpreters* table of contents: https://craftinginterpreters.com/contents.html
- [docs/feat_bootstrap_memory.md](/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/docs/feat_bootstrap_memory.md)
- [bootstrap/TECH_DEBT.md](/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/TECH_DEBT.md)
