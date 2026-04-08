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
- [ ] Parse `return`
- [ ] Implement global declarations required by the bootstrap compiler source
- [x] Add local lexical name binding for the statement runner
- [x] Add tests for shadowing behavior and block-local state

### Part G: Control Flow

Crafting Interpreters reference: Chapter 9, "Control Flow".

- [ ] Parse and validate `if`
- [ ] Parse and validate `while`
- [ ] Add the minimal `for` form only if the bootstrap compiler source truly needs it
- [ ] Add control-flow tests before codegen work starts

### Part H: Functions

Crafting Interpreters reference: Chapter 10, "Functions".

- [ ] Parse function declarations and function calls
- [ ] Support parameters and return types for the MVP subset
- [ ] Add a function symbol table and call validation
- [ ] Add recursive function tests
- [ ] Add module-level function ordering tests

### Part I: Resolving And Binding

Crafting Interpreters reference: Chapter 11, "Resolving and Binding".

- [ ] Implement lexical scope resolution
- [ ] Resolve locals vs globals explicitly
- [ ] Reject invalid reads before initialization
- [ ] Add scope-depth tests
- [ ] Add closure planning only if still required for self-hosting

### Part J: Classes And Inheritance, Deferred

Crafting Interpreters reference: Chapters 12 and 13.

These are not part of the MVP unless the bootstrap compiler source genuinely requires them.

- [ ] Decide whether methods/struct-associated functions are required before self-hosting
- [ ] If not required, leave classes/inheritance out of the MVP entirely
- [ ] If required later, add them after the compiler already self-hosts

## Plan By Backend Adaptation

The second half of *Crafting Interpreters* builds clox, a bytecode VM. We are adapting those chapters into a native self-hosting compiler plan instead of building a VM.

### Part K: Chunk / VM Chapters, Adapted Into IR Design

Crafting Interpreters reference: Chapters 14 and 15.

- [ ] Define the compiler's internal lowering boundary
- [ ] Choose the smallest stable internal representation needed before LLVM/native emission
- [ ] Keep debug dumps for that representation
- [ ] Add tests that lock down lowering output for small programs

### Part L: Scanning On Demand

Crafting Interpreters reference: Chapter 16.

- [ ] Decide whether incremental/on-demand scanning is worth adding before self-hosting
- [ ] Default answer should be no unless profiling proves it matters

### Part M: Compiling Expressions

Crafting Interpreters reference: Chapter 17.

- [ ] Lower expressions to the internal representation
- [ ] Lower variable reads/writes
- [ ] Lower calls and returns
- [ ] Add codegen golden tests for small single-file programs

### Part N: Runtime Value Representation

Crafting Interpreters reference: Chapter 18, "Types of Values".

For Forge bootstrap, this is the ABI/runtime representation question.

- [ ] Define the runtime representation for strings
- [ ] Define the runtime representation for lists only if they remain necessary in the bootstrap source
- [ ] Keep the representation simple and deterministic
- [ ] Add explicit ABI tests at the host/self-host boundary

### Part O: Strings

Crafting Interpreters reference: Chapter 19, "Strings".

- [ ] Finalize bootstrap string operations needed by the compiler itself
- [ ] Add tests for slicing/concatenation only if actually required by the compiler source
- [ ] Keep string support small until self-hosting is reached

### Part P: Hash Tables

Crafting Interpreters reference: Chapter 20, "Hash Tables".

- [ ] Decide whether the bootstrap compiler can avoid maps in the MVP
- [ ] If maps are required, implement them in the runtime or rely on proven host/runtime support
- [ ] Add regression tests for symbol-table correctness

### Part Q: Globals And Locals In Codegen

Crafting Interpreters reference: Chapters 21 and 22.

- [ ] Emit storage for globals
- [ ] Emit storage for locals
- [ ] Make local resolution deterministic and explicit
- [ ] Add codegen tests for shadowing, assignment, and nested blocks

### Part R: Jumping Back And Forth

Crafting Interpreters reference: Chapter 23.

- [ ] Lower conditional branches
- [ ] Lower loops
- [ ] Add CFG-focused tests for nested control flow

### Part S: Calls And Functions

Crafting Interpreters reference: Chapter 24.

- [ ] Emit function definitions
- [ ] Emit function calls
- [ ] Add calling-convention tests between bootstrap-generated code and runtime support

### Part T: Closures

Crafting Interpreters reference: Chapter 25.

- [ ] Decide whether closures are part of the MVP self-host subset
- [ ] If not required for the compiler source, defer until after self-hosting
- [ ] If required, add resolver and runtime support with dedicated tests before enabling them in compiler code

### Part U: Memory Management

Crafting Interpreters reference: Chapter 26, "Garbage Collection".

For Forge bootstrap, this maps to the memory strategy in [docs/feat_bootstrap_memory.md](/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/docs/feat_bootstrap_memory.md).

- [ ] Implement the Phase 1 "copy-everything" strategy or an equivalent simple-correct approach
- [ ] Make compiler-generated code correct before optimizing memory behavior
- [ ] Add tests that specifically exercise values across function-call boundaries
- [ ] Remove host-corruption mitigations once self-host codegen owns value lifetimes

### Part V: Classes / Methods / Superclasses, Deferred

Crafting Interpreters reference: Chapters 27, 28, and 29.

- [ ] Do not add object-model work before self-hosting unless forced by the bootstrap source
- [ ] If methods are needed, add the smallest useful subset after the compiler already rebuilds itself

### Part W: Optimization

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
- [ ] Resolve names and validate the MVP subset
- [ ] Add tests for parse and resolution failures

### Milestone 3: Native Codegen For The MVP Subset

- [ ] Compile minimal single-file programs
- [ ] Compile multi-file bootstrap project source
- [ ] Rebuild the bootstrap compiler with itself once

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

## Source References

This plan is based on:

- *Crafting Interpreters* table of contents: https://craftinginterpreters.com/contents.html
- [docs/feat_bootstrap_memory.md](/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/docs/feat_bootstrap_memory.md)
- [bootstrap/TECH_DEBT.md](/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/TECH_DEBT.md)
