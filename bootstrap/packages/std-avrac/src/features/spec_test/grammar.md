# spec / given / then (in-language test framework)

## Syntax

```
spec_block  = "spec" STRING_LITERAL "{" body "}"
given_block = "given" STRING_LITERAL "{" body "}"
then_block  = "then" STRING_LITERAL "{" expression "}"
```

`spec` outer blocks contain zero or more `given` setup blocks
and `then` assertions; `given` blocks contain zero or more
`then` assertions and may declare local setup state. The label
strings are free-form English.

## Semantics

Tests are first-class language constructs, not a separate
runner shape. A `*_test.av` file gets compiled into a shard
binary that:

1. Initialises the reporter state (C-side counters).
2. Walks the spec/given/then tree in source order.
3. Evaluates each `then` block as a boolean expression — true
   counts as PASS, false as FAIL.
4. Emits a `[shard-summary] pass=N fail=N total=N elapsed_ms=N`
   line at end-of-run.

The test runner orchestrator (`bs2 test` in `cli/main.av`)
spawns one shard per file, captures stdout, and aggregates.
Per-shard isolation via process boundary means a segfault in
one test file doesn't take down the rest of the run.

## Examples

Basic shape:

```avra
spec "addition" {
    then "1 + 1 == 2" {
        1 + 1 == 2
    }
    then "negative add" {
        let a = 0 - 5
        a + 5 == 0
    }
}
```

With a `given` setup:

```avra
spec "user creation" {
    given "fresh user" {
        let u = create_user("alice")
        then "id is positive" {
            u.id > 0
        }
        then "name matches" {
            u.name == "alice"
        }
    }
}
```

Test files live alongside source as `<feature>_test.av` —
either in `tests/` directories under a feature or at the
top-level `bootstrap/tests/` directory.

## Reporter

`features/spec_test/reporter.av` (inlined into every test
bundle) provides:

- `test_render_spec_start(name)` — prints the spec header.
- `test_render_given_start(name)` — prints the given subheader.
- `test_render_then(name, result, file, line)` — increments
  pass/fail, prints PASS/FAIL line + source location.
- `test_render_summary()` — prints the failure list + the
  summary line + the wall-clock total, also emits the
  machine-readable shard-summary marker.
- Optional structured outputs: writes a JSON file when
  `AVRA_TEST_RESULTS_PATH` is set; writes a 32-byte
  `@marshal`-compatible binary when `AVRA_TEST_RESULTS_BIN_PATH`
  is set (nce6.1.F).

## Failure tracking

When a `then` block evaluates false, the reporter records the
spec name, given name (if any), then label, source file, and
line into a C-side failure list (`avra_test_record_failure`).
At the end of the run, the failure list renders below the
PASS/FAIL summary so the user can jump to each failure's
source.

## Pipeline placement

- Parser produces `Stmt.SpecBlock(name, body)`,
  `Stmt.GivenBlock(name, body)`, `Stmt.ThenBlock(name, expr)`.
- The test_runner pass (`@std/avrac/test_runner`) walks the
  test file, wraps each then-block expression in a
  `test_render_then(name, expr, file, line)` call, and
  synthesises a top-level `fn main()` that calls the reporter
  begin/end functions plus every wrapped then.
- The synthesised main is what the shard binary actually runs.

## Discovery

Files ending in `_test.av` are picked up by `bs2 test`'s
discovery walker. Filter rules:

- Path must end in `_test.av`.
- File content must contain the literal `spec ` (a quick
  presence check — saves parsing files that aren't tests).
- File must not contain a top-level `fn main(`. Detection uses
  the `has_top_level_main` walker, which strips comments and
  leading whitespace so doc-comments mentioning `fn main()`
  don't accidentally exclude tests.

## Spec reference

Axis 27 (Testing as first-class).
