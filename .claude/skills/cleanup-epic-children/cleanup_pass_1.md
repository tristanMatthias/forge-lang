After the parent ticket's core implementation lands, do a deep performance pass over EVERY new code path. This is not optional polish — it is mandatory before the parent phase counts as done.

## Scope (do not skip any item)

1. **Algorithmic complexity audit.** For every new function, write down the input size variable (N, M, etc.) and the actual complexity. Flag any O(N) where O(1) is possible — usually means swap a linear scan for a hashmap (`Map<K, V>` or the project's equivalent fast-lookup primitive).

2. **Allocation audit.** For every node-rebuilding walker, ask: does this allocate when nothing changed? If yes, add change-tracking (`{value, changed: bool}` return) so unchanged subtrees keep their original identity instead of allocating fresh nodes.

3. **Hot-path fast-paths.** For walkers that visit every AST/data node, identify shapes that CANNOT match the current pass's transformation (e.g. leaves with no children for a tree rewriter). Add explicit early returns BEFORE entering the dispatch match, not just inside one match arm.

4. **Empty-input short-circuits.** If the registry / accumulator / input collection is empty, the pass should return its input unchanged without walking. Programs with zero of the relevant feature should pay zero cost.

5. **Pre-built state.** Anything that can be computed once at pipeline-entry and reused across calls SHOULD be. Build hashmaps + caches in the constructor, not per-call.

6. **Bypass abstraction overhead where you can.** If you have already resolved data, do NOT round-trip through a generic interface that re-resolves it. Add a direct entry point. Same principle applies anywhere pre-resolved data is being re-resolved through a generic interface.

7. **Mature compiler/runtime techniques.** Consider:
   - **Memoization** (cache results when the same call appears multiple times)
   - **Hash-consing** (intern repeated values so equality is pointer-cheap)
   - **Iteration-to-fixedpoint avoidance** (pass design ensures one walk suffices)
   - **Lazy evaluation** (don't compute what's never observed)
   - **Bottom-up traversal** (children settle first; parents see post-fold args)
   - **Persistent / structural-sharing data structures** (modify-without-copying)

   Apply where they fit. Document in a comment where you considered them and rejected as premature.

## Acceptance

- Concrete before/after measurements (test count, build wall-time, output size, allocation count where measurable).
- Every optimization committed separately so the reviewer can verify each.
- File a separate issue for any deferred win (wider refactor, requires upstream fix, etc.) — do NOT silently leave optimization opportunities behind.
- The parent phase ticket cannot close until this cleanup is complete.

## Anti-patterns (zero tolerance)

- "It's fast enough." — measure, don't assume.
- "I'll come back to this." — file a ticket NOW.
- "This requires a bigger refactor." — file the bigger ticket and pick the optimization that fits in this pass.
- Skipping items 1-7 because "they don't apply." — they always apply; if you don't see the application, you haven't looked hard enough.
