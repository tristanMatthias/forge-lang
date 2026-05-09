After the parent ticket's core implementation, perf pass, AND DRY pass are all done, do a final aggressive red-team review. This is the last gate before the parent phase counts as done.

## Scope (do not skip any item)

1. **Smell hunt.** Aggressively review every line of new code for:
   - Hacks ("works but ugly")
   - Workarounds ("avoiding bug X")
   - "TODO later" comments
   - String-matching heuristics (compare names, parse identifiers from text)
   - Hard-coded magic numbers without WHY comments
   - Hidden dependencies on global state
   - Silently-swallowed errors (`match { _ -> {} }`)
   - Assumed invariants that aren't enforced

   For each smell: either FIX IT NOW, or file a P-appropriate bd ticket. No silent acceptance.

2. **Edge-case battery.** Write a test for each:
   - Empty input (empty list, empty body, no annotations)
   - Single-element input (off-by-one)
   - Deeply-nested input (recursion depth)
   - Malformed AST (intentionally broken — does the pass error gracefully or panic?)
   - Boundary values (0, -1, INT_MAX)
   - Reserved keyword collisions in user input
   - Non-ASCII / quoted / escaped strings if relevant

3. **Stress test.** Generate or hand-write a program that exercises this phase 1000+ times. Compile-time should remain reasonable; output should still be correct.

4. **Recursion / infinite-loop guards.** Anywhere this phase invokes user-supplied code (e.g. comptime-fn bodies, macro expansions): is there a depth limit? An iteration count limit? A "stop after N seconds" guard? Add one. Test it triggers cleanly.

5. **Error message quality.** For every error this phase can produce: is the message actionable? Does it cite a source location? Does it suggest a fix? Compare against existing F-coded errors in `core/diagnostics.av` for the bar.

6. **Documentation coverage.** Every exported fn/type has a `///` docstring. Every WHY comment is accurate. Every test asserts something specific (no smoke-tests-only).

7. **Cross-pipeline integration.** Does this phase interact correctly with:
   - The other compile-pipeline stages (parse / resolve / typeck / mono / codegen)?
   - The selfhost cycle (does the bootstrap still build itself byte-identically)?
   - Coverage instrumentation (`bs2 test --coverage`)?
   - The eval REPL (`bs2 eval`)?
   - Test discovery (does the runner pick up the new tests)?
   File any issue found with concrete repro.

## Acceptance

- Tests for every edge case actually pass.
- Every smell either fixed or filed.
- Stress test runs in CI / pre-commit.
- The parent phase ticket cannot close until this cleanup is complete.

## Anti-patterns (zero tolerance)

- "It works in the happy path." — happy path is 10% of code, 90% of bugs are in the rest.
- "That edge case is unlikely." — edge cases are why bugs land in production.
- "I tested it manually." — manual tests don't run in CI; write the spec.
- Closing this ticket without filing all the issues found. — if you found 3 smells but only fixed 2, the third must be filed.
