# Forge — Test Runner Output Spec

Two output modes: human (beautiful terminal UI) and stream (machine-parseable JSON lines). Both emit results in real-time as tests complete.

---

## Human Output (default)

### Live progress — tests appear as they complete

```
  forge test

  ◐ User registration                          (3/7)
    given a new user with valid email
      ✓ user is created with an id              0.2ms
      ✓ email is stored lowercase               0.1ms
      ✓ default role is member                  0.1ms
    given a user with duplicate email
      ◐ creation fails                          ...
```

The `◐` spinner rotates live. Each test appears instantly on completion. No waiting for the full suite.

### Failures expand inline immediately

```
  ● User registration                          (5/7) 1 failed
    given a new user with valid email
      ✓ user is created with an id              0.2ms
      ✓ email is stored lowercase               0.1ms
      ✖ default role is member                  0.1ms

        user.role == .member
        │            │
        .admin       expected .member

        at tests/user_test.fg:14

    given a user with duplicate email
      ✓ creation fails                          0.3ms
      ✓ error mentions email                    0.2ms
    given no users exist
      ◐ count is zero                           ...
```

Failures show the expression diff right there — no scrolling to the bottom.

### Spec markers

| Icon | Meaning |
|---|---|
| `◐` | Running (animated spinner) |
| `✓` | Passed |
| `✖` | Failed |
| `⊘` | Skipped |
| `○` | Todo (not implemented) |
| `●` | Spec has at least one failure |
| `⏱` | Benchmark result |

### Nesting shows depth with indentation

```
  ✓ Shopping cart
    given an empty cart
      ✓ total is zero                           0.1ms
      ✓ count is zero                           0.1ms
      given adding one item
        ✓ count is one                          0.1ms
        ✓ total is item price                   0.1ms
        given adding a second item
          ✓ count is two                        0.1ms
          ✓ total is sum                        0.1ms
```

### Where tables show each row

```
  ✓ email validation
    ✓ validates correctly (alice@test.com → true)       0.1ms
    ✓ validates correctly (bob@example.org → true)      0.1ms
    ✓ validates correctly (not-an-email → false)        0.1ms
    ✓ validates correctly ("" → false)                  0.1ms
    ✖ validates correctly (@no-user → false)            0.1ms

        validate_email("@no-user") == false
        │                             │
        true                          expected false

        at tests/email_test.fg:12, row 5
```

### Fuzz tests show progress bar

```
  ◐ sorting > length preserved              (847/1000 cases)
    ████████████████████████████████████░░░░░░  84%
```

On failure, shows the shrunk minimal case:

```
  ✖ sorting > output is ordered             (failed after 23 cases)

    Minimal failing input: [2, 1]

    input.sorted() == [2, 1]  (not sorted!)

    Shrunk from: [84, 2, 91, 1, 37] → [2, 1]
```

### Eventually tests show poll count

```
  ✓ queue processing > worker processes it   (after 250ms, 5 polls)
```

On timeout:

```
  ✖ queue processing > worker processes it   (timed out after 5s, 50 polls)

    Never became true. Last value: processed_count() == 0
```

### Snapshot mismatches show diffs

```
  ✖ API format > json format is stable

    Snapshot mismatch for "user_json":

    - {"id":1,"name":"alice","email":"alice@test.com"}
    + {"id":1,"name":"alice","email":"alice@test.com","created_at":"2026-03-12"}

    Run `forge test --update-snapshots` to accept
```

### Struct diffs

```
  ✖ user fields > matches expected

    diff:
      {
        id: 1
        name: "alice"
    -   email: "alice@test.com"
    +   email: "bob@test.com"
      }
```

### List diffs

```
  ✖ sorting > sorts correctly

    diff:
      [1, 1, 3, 4, -5- +6+]
                    ^^^
                    index 4: got 5, expected 6
```

---

## Final Summary

Always printed at the end. Compact but complete.

### All passing

```
  ──────────────────────────────────────────────────────

  ✓ 24 passed

  Duration: 0.8s | Files: 4 | Specs: 6 | Tests: 24

  ──────────────────────────────────────────────────────
```

### With failures

```
  ──────────────────────────────────────────────────────

  ✖ 2 failed  ✓ 18 passed  ⊘ 2 skipped  ○ 3 todo

  Failures:

    1) User registration > given a new user > default role is member
       user.role == .member → got .admin
       at tests/user_test.fg:14

    2) email validation > validates correctly (@no-user → false)
       validate_email("@no-user") == false → got true
       at tests/email_test.fg:12

  Run `forge test --filter "default role"` to rerun just this test

  ──────────────────────────────────────────────────────
  Duration: 1.2s | Files: 4 | Specs: 6 | Tests: 25
```

### With benchmarks

```
  ──────────────────────────────────────────────────────

  ✓ 24 passed

  Benchmarks:

    ⏱ list sort             1.2ms avg  (0.9ms – 1.8ms, 100 runs)
    ⏱ hash map insert       0.8ms avg  (0.6ms – 1.1ms, 100 runs)
    ⏱ json parse            2.1ms avg  (1.8ms – 2.5ms, 100 runs)

  Duration: 4.2s | Files: 4 | Specs: 6 | Tests: 24 | Benchmarks: 3

  ──────────────────────────────────────────────────────
```

---

## Stream Output (--format=stream)

One JSON object per line. Streaming — parseable line by line as events arrive.

```bash
forge test --format=stream
```

### Events

```json
{"event":"suite_start","timestamp":"2026-03-12T10:00:00Z","files":4,"specs":6,"tests":24}
{"event":"file_start","file":"tests/user_test.fg"}
{"event":"spec_start","spec":"User registration","file":"tests/user_test.fg"}
{"event":"given_start","name":"a new user with valid email","depth":1}
{"event":"pass","test":"user is created with an id","duration_ms":0.2,"file":"tests/user_test.fg","line":5}
{"event":"pass","test":"email is stored lowercase","duration_ms":0.1,"file":"tests/user_test.fg","line":9}
{"event":"fail","test":"default role is member","duration_ms":0.1,"file":"tests/user_test.fg","line":14,"expected":".member","actual":".admin","expression":"user.role == .member","suggestion":{"message":"User.create sets role to .admin by default","edit":{"file":"src/user.fg","line":8,"old":"role: .admin","new":"role: .member"},"confidence":0.85}}
{"event":"given_end","name":"a new user with valid email"}
{"event":"given_start","name":"a user with duplicate email","depth":1}
{"event":"pass","test":"creation fails","duration_ms":0.3,"file":"tests/user_test.fg","line":20}
{"event":"pass","test":"error mentions email","duration_ms":0.2,"file":"tests/user_test.fg","line":24}
{"event":"given_end","name":"a user with duplicate email"}
{"event":"spec_end","spec":"User registration","passed":4,"failed":1,"skipped":0,"todo":0,"duration_ms":0.9}
{"event":"skip","test":"deletes user","reason":"skipped — delete not implemented","file":"tests/user_test.fg","line":30}
{"event":"todo","test":"updates user email","file":"tests/user_test.fg","line":34}
{"event":"file_end","file":"tests/user_test.fg","passed":4,"failed":1,"skipped":1,"todo":1}
{"event":"suite_end","passed":18,"failed":1,"skipped":2,"todo":3,"duration_ms":1200,"files":4}
```

### Event Types

| Event | When | Key fields |
|---|---|---|
| `suite_start` | Test run begins | `files`, `specs`, `tests`, `timestamp` |
| `file_start` | Starting a test file | `file` |
| `spec_start` | Entering a spec block | `spec`, `file` |
| `given_start` | Entering a given block | `name`, `depth` |
| `given_end` | Leaving a given block | `name` |
| `pass` | Test passed | `test`, `duration_ms`, `file`, `line` |
| `fail` | Test failed | `test`, `duration_ms`, `expected`, `actual`, `expression`, `suggestion`, `file`, `line` |
| `skip` | Test skipped | `test`, `reason`, `file`, `line` |
| `todo` | Test not implemented | `test`, `file`, `line` |
| `fuzz_progress` | Fuzz test progress | `test`, `cases_run`, `cases_total` |
| `fuzz_fail` | Fuzz found a failure | `test`, `failing_input`, `shrunk_from`, `minimal_input` |
| `bench` | Benchmark result | `test`, `avg_ms`, `min_ms`, `max_ms`, `runs` |
| `snapshot_mismatch` | Snapshot differs | `test`, `name`, `expected`, `actual` |
| `eventually_timeout` | Eventually timed out | `test`, `timeout_ms`, `polls`, `last_value` |
| `spec_end` | Leaving a spec block | `spec`, `passed`, `failed`, `skipped`, `todo`, `duration_ms` |
| `file_end` | Finished a test file | `file`, `passed`, `failed`, `skipped`, `todo` |
| `suite_end` | Test run complete | `passed`, `failed`, `skipped`, `todo`, `duration_ms`, `files` |

### Fail events include suggestions

The `suggestion` field on `fail` events gives agents everything they need to auto-fix:

```json
{
  "suggestion": {
    "message": "User.create sets role to .admin by default",
    "edit": {
      "file": "src/user.fg",
      "line": 8,
      "old": "role: .admin",
      "new": "role: .member"
    },
    "confidence": 0.85
  }
}
```

Agent workflow: read fail event → apply suggestion edit → rerun test → repeat until green.

---

## Watch Mode (--watch)

```bash
forge test --watch
```

```
  watching 14 files...
```

On file change:

```
  src/user.fg changed → rerunning 3 affected tests

  ✓ User registration > default role is member    0.1ms  (was ✖ failing)
  ✓ User registration > email is stored lowercase  0.1ms
  ✓ User registration > user is created with id    0.2ms

  All passing now.
```

Rules:
- Only reruns tests that import or depend on the changed file
- Shows status change: `(was ✖ failing)` when a previously failing test now passes
- Shows `(new)` for newly added tests
- Debounces file changes — waits 100ms after last change before rerunning
- Clear screen between runs (configurable with `--no-clear`)

Stream format for watch mode adds:

```json
{"event":"watch_trigger","changed_file":"src/user.fg","rerunning_tests":3}
{"event":"status_change","test":"default role is member","was":"fail","now":"pass"}
```

---

## Coverage (--coverage)

```bash
forge test --coverage
```

Appended after the summary:

```
  Coverage: 84%

  src/user.fg          ████████████████████░░░░  87%
  src/auth.fg          ██████████████░░░░░░░░░░  62%  ← needs attention
  src/tasks.fg         ████████████████████████  100%
  src/utils.fg         ███████████████████░░░░░  81%

  Uncovered functions:
    src/auth.fg:23     validate_token()
    src/auth.fg:45     refresh_session()
    src/user.fg:67     delete_user()
```

Stream format:

```json
{"event":"coverage","total_percent":84,"files":[{"file":"src/user.fg","percent":87,"uncovered_lines":[67,68,69,70]},{"file":"src/auth.fg","percent":62,"uncovered_lines":[23,24,25,26,27,28,29,30,31,45,46,47,48,49,50,51,52]}]}
```

---

## Benchmark Comparison (--bench --compare=branch)

```bash
forge test --bench --compare=main
```

```
  Performance vs main branch:

  Benchmark              main      current    change
  ─────────────────────────────────────────────────────
  list sort              1.2ms     0.8ms      ▼ 33% faster
  hash map insert        0.8ms     0.9ms      ▲ 12% slower  ⚠
  json parse             2.1ms     2.0ms      ~ no change

  ⚠ hash_map_insert regressed by 12%.
    Run `forge bench hash_map_insert --profile` for details.
```

Threshold for `⚠` warning: >10% slower (configurable in forge.toml).

Stream format:

```json
{"event":"bench_compare","test":"list sort","baseline_ms":1.2,"current_ms":0.8,"change_percent":-33,"status":"faster"}
{"event":"bench_compare","test":"hash map insert","baseline_ms":0.8,"current_ms":0.9,"change_percent":12,"status":"slower","warning":true}
{"event":"bench_compare","test":"json parse","baseline_ms":2.1,"current_ms":2.0,"change_percent":-5,"status":"no_change"}
```

---

## CLI Flags

```bash
forge test                           # run all, human output
forge test tests/user_test.fg        # run one file
forge test --filter "user"           # run matching tests
forge test --format=stream           # JSON lines for agents
forge test --format=json             # full JSON report (not streaming)
forge test --format=tap              # TAP protocol for CI
forge test --watch                   # rerun on file change
forge test --coverage                # show coverage
forge test --bench                   # run benchmarks
forge test --bench --compare=main    # benchmark vs branch
forge test --fuzz                    # run fuzz tests
forge test --fuzz --cases=10000      # more fuzz cases
forge test --update-snapshots        # accept new snapshot values
forge test --fail-fast               # stop on first failure
forge test --parallel                # run specs in parallel
forge test --timeout=30s             # global test timeout
forge test --no-color                # strip ANSI for piping
forge test --verbose                 # show passing test expressions too
forge test --quiet                   # only show failures and summary
```

---

## Color Rules

| Element | Color |
|---|---|
| `✓` and passing test names | Green |
| `✖` and failing test names | Red |
| `⊘` skipped | Dim |
| `○` todo | Dim |
| `⏱` benchmark | Cyan |
| Duration | Dim |
| Expression diff — expected | Green |
| Expression diff — actual | Red |
| File paths and line numbers | Dim underline |
| `▼ faster` | Green |
| `▲ slower` | Red |
| `⚠` warnings | Yellow |
| Spinner | Cyan |
| Progress bar filled | Green |
| Progress bar empty | Dim |
| Summary separator line | Dim |

All colors stripped automatically when output is piped (not a TTY) or `--no-color` is set.

---

## forge.toml Test Configuration

```toml
[test]
timeout = "30s"                    # per-test timeout
parallel = true                    # run specs in parallel by default
fail_fast = false                  # don't stop on first failure
fuzz_cases = 100                   # default fuzz iterations
bench_runs = 100                   # default benchmark iterations
bench_warn_threshold = 10          # % regression to trigger warning
coverage_threshold = 80            # fail if coverage below this
snapshot_dir = ".snapshots"        # where snapshots are stored

[test.watch]
debounce_ms = 100
clear_screen = true
```
