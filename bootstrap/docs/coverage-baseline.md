# Documentation Coverage Baseline

**Snapshot date:** 2026-04-29 (post-1mh6 cleanup, pre-wjxo).
**Tool:** `bs2 docs --validate --no-cache` per package.
**Threshold:** ≥95% public symbols across all packages by wjxo close.

## Per-package status

| Package                | Symbols | Documented | Coverage | Owner ticket           |
| ---------------------- | ------: | ---------: | -------: | ---------------------- |
| `packages/avrac/src/`  |    1781 |       180+ |   **>10%** | many (see breakdown)   |
| `packages/std-lsp/src/`|     165 |         75 |   **45%** | forge-crafting-intepreters-0kdk |
| `packages/std-cli/src/`|      49 |          0 |    **0%** | forge-crafting-intepreters-0kdk |
| `packages/std-test/src/`|      2 |          0 |    **0%** | forge-crafting-intepreters-0kdk |
| `packages/std-process/src/`|   0 |          0 |  **100%** | (n/a — empty)         |
| `packages/std-json/src/`|     21 |         12 |   **57%** | forge-crafting-intepreters-0kdk |

## Compiler internals breakdown (`packages/avrac/src/`)

The bulk of work. Per-area sub-tickets carve up the surface:

| Area                            | Ticket                              | Status |
| ------------------------------- | ----------------------------------- | ------ |
| `core/` — ast, llvm, registry, runtime, type_registry | forge-crafting-intepreters-6i06 | **100%** ✓ |
| `parse/` — lexer, parser        | forge-crafting-intepreters-b5x4     |
| `resolve/` — names, scopes      | forge-crafting-intepreters-gr41     |
| `typeck/` — type checker        | forge-crafting-intepreters-3kbk     |
| `codegen/` — IR emission        | forge-crafting-intepreters-d0vp     |
| `features/<name>/`              | forge-crafting-intepreters-79xf     |
| `diagnostics`, `desugar`, `coverage`, `docs`, `indexer`, `render`, `pathutil` | forge-crafting-intepreters-hmas |
| F-code messages + lang.av round-trip | forge-crafting-intepreters-d1v4 |
| CLI subcommands (`compile`, `run`, `test`, `docs`, `lsp`, …) | forge-crafting-intepreters-7r6q |
| Generated language reference    | forge-crafting-intepreters-aq9c     |

## Definitions

- **Public symbol:** declared with `export fn|type|enum|trait|const|let|mut`.
- **Documented:** has a `///` block immediately above the declaration. The
  doc may be one line; what counts is "intent visible to a consumer".
- **Threshold:** each child ticket closes when its area reports ≥95%
  public coverage via `--validate`. Internal helpers can stay below
  that — coverage is a public-API contract, not a stylistic mandate.

## Update protocol

Each `doc-*` child ticket appends an "after" row to its area row in
this file when it closes — preserving a public diff of the work
completed under wjxo.
