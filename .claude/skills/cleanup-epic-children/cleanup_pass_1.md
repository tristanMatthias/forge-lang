After the parent ticket's core implementation lands, do a deep performance pass over EVERY new code path. This is not optional polish — it is mandatory before the parent phase counts as done.

## Scope (do not skip any item)

1. **Algorithmic complexity audit.** For every new function, write down the input size variable (N, M, etc.) and the actual complexity. Flag any O(N) where O(1) is possible — usually means swap a linear scan for a hashmap (string→int via `avra_map_*_cstr`, same pattern as `core/registry.av` and `module_graph.av`).

2. **Allocation audit.** For every node-rebuilding walker, ask: does this allocate when nothing changed? If yes, add change-tracking (`{value, changed: bool}` return) so unchanged subtrees keep their original identity instead of allocating fresh nodes.

3. **Hot-path fast-paths.** For walkers that visit every AST node, identify shapes that CANNOT match the current pass's transformation (e.g. leaves like `Number`/`Ident`/`QualifiedIdent` for an expression rewriter). Add explicit early returns BEFORE entering the dispatch match, not just inside one match arm.

4. **Empty-input short-circuits.** If the registry / accumulator / input collection is empty, the pass should return its input unchanged without walking. Programs with zero of the relevant feature pay zero cost.

5. **Pre-built state.** Anything that can be computed once at pipeline-entry and reused across calls SHOULD be. Build hashmaps + caches in the constructor, not per-call.

6. **Bypass abstraction overhead where you can.** If you have already resolved a fn definition and arg literal values, do NOT round-trip through `eval_expr(Expr.Call(...))` — call `eval_fn_with_resolved_args` directly. Same principle applies anywhere you have pre-resolved data being re-resolved through a generic interface.

7. **Mature compiler techniques.** Consider:
   - Memoization (cache fold/eval results when the same call appears multiple times)
   - Hash-consing (intern repeated AST literals)
   - Iteration-to-fixedpoint avoidance (pass design ensures one walk suffices)
   - Lazy evaluation (don't compute what's never observed)
   - Bottom-up traversal (children fold first, parents see post-fold args)
   Apply where they fit. Document in WHY comments where you considered them and rejected as premature.

## Acceptance

- Concrete before/after measurements (test count, build wall-time, IR line count, allocation count where measurable).
- Every optimization committed separately so the reviewer can verify each.
- File a separate bd ticket for any deferred win (wider refactor, requires seed cycle, etc.) — do NOT silently leave optimization opportunities behind.
- The parent phase ticket cannot close until this cleanup is complete.

## Anti-patterns (zero tolerance)

- "It's fast enough." — measure, don't assume.
- "I'll come back to this." — file a ticket NOW.
- "This requires a bigger refactor." — file the bigger ticket and pick the optimization that fits in this pass.
- Skipping items 1-7 because "they don't apply." — they always apply; if you don't see the application, you haven't looked hard enough.
