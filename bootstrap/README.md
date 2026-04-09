# Forge Bootstrap

`bootstrap/` is the clean restart for self-hosting.

It is intentionally separate from the legacy `forge/packages/forgec` tree, which contains bootstrap-era experiments, dead ends, and compatibility hacks. This project starts over with a minimal, production-quality compiler written in Forge and compiled by the existing Rust compiler until it can compile itself.

The implementation strategy follows the front-end progression from *Crafting Interpreters*, adapted to Forge:

- start with a scanner and stable token model
- add a recursive-descent expression parser
- add a tree-walk expression evaluator
- add declarations and control flow
- add semantic checks for the tiny self-host subset
- add LLVM IR codegen (not a bytecode VM — we emit native code via the LLVM C API)

The source language subset for this bootstrap lane stays intentionally small: local modules, functions, variables, literals, calls, conditionals, loops, returns, and comments. Anything outside that subset is deferred until the compiler can build itself reliably.

## Current milestone

The current milestones implement:

- a standalone `tokens` command that scans Forge source and prints a stable token stream
- a standalone `expr` command that parses expressions and prints a normalized AST form
- a standalone `program` command that parses statement files and prints a normalized AST form
- a standalone `eval` command that evaluates expressions using the Chapter 7 tree-walk model
- a standalone `run` command that executes the Chapter 8 statement subset with lexical scope, plus Chapter 9 control flow (`if`/`else`, `while`)

This gives us:

- an isolated project that the Rust compiler can build
- a reusable token model for later parser work
- the first real AST representation for the bootstrap compiler
- a working evaluator for literals, grouping, unary operators, arithmetic, comparison, equality, and string concatenation
- a working statement runner for `let`, `mut`, assignment, expression statements, and block scope
- golden tests that catch scanner and parser regressions immediately

## Usage

Build the bootstrap compiler with the Rust host compiler:

```bash
forge/target/release/forgec build bootstrap --dev -o bootstrap/build/bootstrapc
```

Print tokens for a Forge source file:

```bash
bootstrap/build/bootstrapc tokens bootstrap/tests/scanner/basic_function.fg
```

Parse an expression file and print its AST:

```bash
bootstrap/build/bootstrapc expr bootstrap/tests/expr/arithmetic_precedence.fg
```

Parse a statement file and print its AST:

```bash
bootstrap/build/bootstrapc program bootstrap/tests/program/vars_and_assignment.fg
```

Evaluate an expression file and print its result:

```bash
bootstrap/build/bootstrapc eval bootstrap/tests/eval/arithmetic_precedence.fg
```

Execute a statement file and print its final value:

```bash
bootstrap/build/bootstrapc run bootstrap/tests/run/mutable_assignment.fg
```

Run the bootstrap test suite:

```bash
bash bootstrap/scripts/test.sh
```
