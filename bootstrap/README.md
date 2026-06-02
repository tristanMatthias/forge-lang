# Avra Bootstrap

`bootstrap/` is the clean restart for self-hosting.

It is intentionally separate from the legacy `avra/packages/std-avrac` tree, which contains bootstrap-era experiments, dead ends, and compatibility hacks. This project starts over with a minimal, production-quality compiler written in Avra and compiled by the existing Rust compiler until it can compile itself.

The implementation strategy follows the front-end progression from *Crafting Interpreters*, adapted to Avra:

- start with a scanner and stable token model
- add a recursive-descent expression parser
- add a tree-walk expression evaluator
- add declarations and control flow
- add semantic checks for the tiny self-host subset
- add LLVM IR codegen (not a bytecode VM — we emit native code via the LLVM C API)

The source language subset for this bootstrap lane stays intentionally small: local modules, functions, variables, literals, calls, conditionals, loops, returns, and comments. Anything outside that subset is deferred until the compiler can build itself reliably.

## Current milestone

The current milestones implement:

- a standalone `tokens` command that scans Avra source and prints a stable token stream
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

## Setup

On a fresh machine, run the environment bootstrapper once. It installs and
verifies the whole toolchain — LLVM 20, a C/C++ compiler, `lld`, `make`, `git`,
`python3`, plus the `bd` + `dolt` beads issue tracker the dev workflow runs on
(it pulls in their own prerequisites: a Go toolchain for `bd`, `curl` for the
`dolt` installer) — and prints the one env var the compiled binary can't
reliably self-discover, `LLVM_PREFIX`:

```bash
scripts/bootstrap.sh                 # detect + install what's missing, then verify
scripts/bootstrap.sh --check         # verify only (CI gate; exits non-zero if a dep is missing)
eval "$(scripts/bootstrap.sh --print-env)"   # export LLVM_PREFIX/LLC into this shell
```

It is platform-agnostic (macOS Homebrew; Debian/Ubuntu, Fedora/RHEL, Arch,
openSUSE, Alpine). LLVM is pinned to 20 — LLVM 21's `-O2` miscompiles certain
ARM64 functions.

## Usage

The everyday entry point is the `Makefile`:

```bash
cd bootstrap
make              # build the bootstrap compiler
make test         # run regression suite + self-host fixed-point check
make run FILE=examples/hello.av
                  # compile and run a Avra program
make selfhost     # verify bs2 and bs3 emit byte-identical IR
make clean        # remove build artifacts
make help         # list all targets
```

The Makefile is a thin wrapper over `scripts/diagnose.sh`, which is
the full diagnostic system (~25 modes). Run `bash scripts/diagnose.sh
--help` to see everything: ASan builds, line bisection, IR diffing,
function ranking, IR scoring, etc.

Install the pre-commit hook (recommended — blocks commits that break
the regression suite or the self-host fixed point):

```bash
make install-hooks
```

### Self-hosting

The bootstrap compiler is self-hosted as of commit `3814cce`: it can
compile its own source code into a binary that produces byte-identical
IR. The chain is:

```
Host (Rust) → stage1 (build/bootstrapc)
                ↓ compiles bootstrap source
              bs2 (build/bs2)              ← the binary you actually use
                ↓ compiles bootstrap source
              bs3 (build/bs3)              ← byte-identical to bs2
```

`make test` verifies both invariants — that bs2 produces correct
output for captured test programs, and that bs2 and bs3 are
self-consistent.
