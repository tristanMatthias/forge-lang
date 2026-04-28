# core/

Stable infrastructure that every phase depends on. Things in here:
- AST node definitions (data only, no logic)
- Cursor / scanner state and helpers
- Diagnostic + Result types
- The Cg fluent helper layer (LLVM boilerplate killer)
- Name resolution

Rule: nothing in `core/` may import from `features/`. The dependency
arrow always points TOWARD core, never away from it.
