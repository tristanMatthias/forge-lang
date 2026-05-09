After the parent ticket's core implementation lands AND the perf pass is complete, do a deep DRY/architectural pass over EVERY new code path. This is not optional polish — it is mandatory before the parent phase counts as done.

## Scope (do not skip any item)

1. **Duplication audit.** For every new function, find all near-duplicates elsewhere in the codebase. Pull common logic into a shared helper. If the duplication spans modules, file a ticket for the cross-cutting refactor (e.g. a generic AST visitor) but extract the local DRY in this pass.

2. **Replace functional-duct-tape with proper Avra constructs.** If you wrote 4 helper fns that thread state through recursion, ask: should this be a component? A trait? A typed registry? A method on a struct? Avra's component + trait machinery exists for a reason; use it.

3. **Centralize logic, zero copy-paste.** No two call sites should contain the same logic. If two sites converge on a similar pattern, extract it.

4. **Audit for missed-abstraction opportunities.**
   - Could this be a trait? (heterogeneous handling, polymorphic dispatch)
   - Could this be a generic? (works for List<T> regardless of T)
   - Could this be a derive? (a `@comptime fn` generates the boilerplate)
   - Could this be a component? (declarative block syntax with auto-validation)

5. **Consolidate similar APIs.** If your phase added 4 lookup variants that differ slightly (e.g. `has_X`, `find_X`, `find_X_body`, `count_X`), can they all share a single underlying walker? Wrappers are fine; the walker should be one.

6. **Eliminate redundant types.** If you added a struct that's a near-duplicate of an existing one (different fields but same role), consolidate. Avra's resolver gets confused by name collisions and reviewers get confused by visual duplicates.

7. **Documentation accuracy + WHY comments.** Every new file's WHY header should describe its actual current state, not its planned future state. Stale comments lie to readers; aggressively prune them.

8. **API surface review.** Are the exported names self-explanatory? Could a third-party caller use this without reading the implementation? Privatize anything not needed publicly.

## Acceptance

- Each DRY commits separately so the reviewer can verify the consolidation.
- File a bd ticket for every cross-cutting refactor uncovered (don't fix in this pass; just track).
- The parent phase ticket cannot close until this cleanup is complete.

## Anti-patterns (zero tolerance)

- "These are slightly different so I'll keep them separate." — if 80% is shared, share 80%.
- "I'll DRY this when there's a third user." — DRY at two; the third never comes.
- "It's just a small duplication." — small duplications compound. Three bugs all in slightly different copies of the same logic is the canonical Avra anti-pattern.
- Leaving stale comments. — every WHY comment must be current; if it's not, fix it or delete it.
