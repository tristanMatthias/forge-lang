# Forge Bootstrap

`bootstrap/` is the clean restart for self-hosting.

It is intentionally separate from the legacy `forge/packages/forgec` tree, which contains bootstrap-era experiments, dead ends, and compatibility hacks. This project starts over with a minimal, production-quality compiler written in Forge and compiled by the existing Rust compiler until it can compile itself.

The implementation strategy follows the front-end progression from *Crafting Interpreters*, adapted to Forge:

- start with a scanner and stable token model
- add a Pratt parser for expressions
- add declarations and control flow
- add semantic checks for the tiny self-host subset
- add code generation only after the front end is boring and correct

The source language subset for this bootstrap lane stays intentionally small: local modules, functions, variables, literals, calls, conditionals, loops, returns, and comments. Anything outside that subset is deferred until the compiler can build itself reliably.

## Current milestone

This first milestone implements a standalone `tokens` command that scans Forge source and prints a stable token stream. It gives us:

- an isolated project that the Rust compiler can build
- a reusable token model for later parser work
- golden tests that catch scanner regressions immediately

## Usage

Build the bootstrap compiler with the Rust host compiler:

```bash
forge/target/release/forgec build bootstrap --dev -o bootstrap/build/bootstrapc
```

Print tokens for a Forge source file:

```bash
bootstrap/build/bootstrapc tokens bootstrap/tests/scanner/basic_function.fg
```

Run the bootstrap test suite:

```bash
bash bootstrap/scripts/test.sh
```
