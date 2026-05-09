After the parent ticket's core implementation lands AND the perf pass is complete, do a deep DRY + readability + use-the-language pass over EVERY new code path. This is not optional polish — it is mandatory before the parent phase counts as done.

The bar is not "it works" or even "it's not duplicated." The bar is **does this read like the language was designed for it**. Resist functional-duct-tape; lean into the language's idioms.

## Scope (do not skip any item)

1. **Duplication audit.** For every new function, find all near-duplicates elsewhere in the codebase. Pull common logic into a shared helper. If the duplication spans modules, file a ticket for the cross-cutting refactor (e.g. a generic visitor) but extract the local DRY in this pass.

2. **Use the language's features, don't fight them.** For every multi-line helper you wrote, ask: did the language already give me a tool for this? Examples to look for:
   - **Are you threading state through recursion via accumulators?** Probably wants a method on a struct, a class, or the language's iteration construct.
   - **Are you pattern-matching on type tags by hand?** Probably wants traits/interfaces with polymorphic dispatch.
   - **Are you generating boilerplate fields/methods for many similar types?** Probably wants a derive / decorator / annotation-driven generator.
   - **Are you building scattered configuration through builder calls?** Probably wants a declarative block / component.
   - **Are you stringly-typing dispatch on values?** Probably wants enum variants or sealed traits.

   If the language provides the construct, USE IT. Functional-duct-tape (chains of helper fns threading state) is the canonical anti-pattern to replace.

3. **Beauty + readability.** Code is read 10× more than written. Apply each:
   - **Names tell a story.** A reader skimming function names should understand the file's intent. Replace `do_thing_2` / `helper3` / `inner` with names that describe what the function actually does.
   - **One screen per function.** If a function exceeds ~30 lines, extract sub-pieces with descriptive names. Fewer-lines-per-function reads as fewer concepts per screen.
   - **No accidental complexity.** A reader should not have to mentally rewind: variables introduced near use, conditions read top-to-bottom, edge cases handled at the start with early returns.
   - **Match the file's existing style.** If the surrounding code uses iterative loops, don't introduce recursion (and vice versa). Inconsistency breaks reading flow.

4. **Centralize logic, zero copy-paste.** No two call sites should contain the same logic. If two sites converge on a similar pattern, extract it.

5. **Audit for missed-abstraction opportunities.** For each new construct, ask:
   - Could this be a trait / interface? (heterogeneous handling, polymorphic dispatch)
   - Could this be a generic? (works for `Container<T>` regardless of T)
   - Could this be a derive / decorator / annotation-driven generator? (the boilerplate is expressible declaratively)
   - Could this be a component / declarative block? (replaces scattered builder calls with one structured shape)
   - Could this be inferred from types instead of passed explicitly?

6. **Consolidate similar APIs.** If your phase added 4 lookup variants that differ slightly (e.g. `has_X`, `find_X`, `find_X_body`, `count_X`), can they all share a single underlying walker? Wrappers are fine; the walker should be one.

7. **Eliminate redundant types.** If you added a struct/type that's a near-duplicate of an existing one (different fields but same role), consolidate. Type-system resolvers can get confused by name collisions and reviewers get confused by visual duplicates.

8. **Documentation accuracy + WHY comments.** Every new file's header / docstring should describe its actual current state, not its planned future state. Every WHY comment should explain a non-obvious *reason*, not restate WHAT the code does. Stale comments lie to readers; aggressively prune them.

9. **API surface review.** Are the exported names self-explanatory? Could a third-party caller use this without reading the implementation? Privatize anything not needed publicly.

## Acceptance

- Each DRY commits separately so the reviewer can verify the consolidation.
- File an issue for every cross-cutting refactor uncovered (don't fix in this pass; just track).
- The parent phase ticket cannot close until this cleanup is complete.

## Anti-patterns (zero tolerance)

- "These are slightly different so I'll keep them separate." — if 80% is shared, share 80%.
- "I'll DRY this when there's a third user." — DRY at two; the third never comes.
- "It's just a small duplication." — small duplications compound. Three bugs all in slightly different copies of the same logic is the canonical anti-pattern this pass exists to prevent.
- "The language doesn't quite fit, so I wrote my own thing." — usually means you didn't look hard enough at the language's existing constructs. Look again.
- "I'll add language-feature use later." — usually never happens. The duct-tape calcifies.
- Leaving stale comments. — every comment must be current; if it's not, fix it or delete it.
- Names like `do_thing_2`, `helper3`, `process`, `inner`. — every function name owes the reader an explanation of what it actually does.
