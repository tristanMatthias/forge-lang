# @std/test — Test Component (TDD)

`@std/test` is a component package. `spec`, `given`, `then` are components and scoped functions with `@syntax` sugar. Everything builds on existing language features: `is`, `table`, closures, error handling.

---

## Test 1: Basic spec/given/then

```forge
use @std.test

spec "arithmetic" {
  given "two numbers" {
    let a = 2
    let b = 3

    then "addition works" { a + b == 5 }
    then "multiplication works" { a * b == 6 }
  }
}
```

```bash
forge test
```

```
  arithmetic
    given two numbers
      ✓ addition works
      ✓ multiplication works

  2 passed (0.1ms)
```

## Test 2: Failing test shows expression diff

```forge
spec "strings" {
  given "a greeting" {
    let name = "forge"

    then "is uppercase" {
      name == "FORGE"
    }
  }
}
```

```
  strings
    given a greeting
      ✖ is uppercase

        name == "FORGE"
        │       │
        "forge" expected "FORGE"

        at tests/string_test.fg:6
```

## Test 3: Nested given blocks

```forge
spec "shopping cart" {
  given "an empty cart" {
    let cart = Cart.new()

    then "total is zero" { cart.total() == 0.0 }
    then "is empty" { cart.count() == 0 }

    given "adding one item" {
      cart.add({ name: "Widget", price: 9.99 })

      then "count is one" { cart.count() == 1 }
      then "total is item price" { cart.total() == 9.99 }

      given "adding another item" {
        cart.add({ name: "Gadget", price: 19.99 })

        then "count is two" { cart.count() == 2 }
        then "total is sum" { cart.total() == 29.98 }
      }
    }
  }
}
```

```
  shopping cart
    given an empty cart
      ✓ total is zero
      ✓ is empty
      given adding one item
        ✓ count is one
        ✓ total is item price
        given adding another item
          ✓ count is two
          ✓ total is sum

  6 passed (0.4ms)
```

## Test 4: Each `then` gets fresh state

```forge
spec "isolation" {
  given "a counter" {
    mut count = 0

    then "first test increments" {
      count = count + 1
      count == 1
    }

    then "second test also sees zero" {
      // count is 0 here, not 1 — fresh copy from given
      count == 0
    }
  }
}
```

```
  isolation
    given a counter
      ✓ first test increments
      ✓ second test also sees zero

  2 passed
```

## Test 5: `where` with table — parameterized tests

```forge
spec "email validation" {
  then "validates correctly" where table {
    input              | expected
    "alice@test.com"   | true
    "bob@example.org"  | true
    "not-an-email"     | false
    ""                 | false
    "@no-user"         | false
  } {
    validate_email(input) == expected
  }
}
```

```
  email validation
    ✓ validates correctly (alice@test.com → true)
    ✓ validates correctly (bob@example.org → true)
    ✓ validates correctly (not-an-email → false)
    ✓ validates correctly ("" → false)
    ✖ validates correctly (@no-user → false)

        validate_email("@no-user") == false
        │                             │
        true                          expected false

  4 passed, 1 failed
```

## Test 6: `should_fail` — expects an error

```forge
spec "input validation" {
  given "invalid data" {
    then "negative age fails" should_fail {
      User.create({ name: "alice", age: -1 })
    }

    then "empty name fails" should_fail {
      User.create({ name: "", age: 25 })
    }

    then "valid data does not fail" should_fail {
      // This should NOT fail, so should_fail makes this test fail
      User.create({ name: "alice", age: 25 })
    }
  }
}
```

```
  input validation
    given invalid data
      ✓ negative age fails
      ✓ empty name fails
      ✖ valid data does not fail

        expected an error, but succeeded

  2 passed, 1 failed
```

## Test 7: `should_fail_with` — expects specific error

```forge
spec "error messages" {
  given "invalid input" {
    then "mentions field name" should_fail_with "name" {
      User.create({ name: "", age: 25 })
    }

    then "mentions constraint" should_fail_with "required" {
      User.create({ name: "", age: 25 })
    }
  }
}
```

```
  error messages
    given invalid input
      ✓ mentions field name
      ✓ mentions constraint

  2 passed
```

## Test 8: `is` in assertions

```forge
spec "result handling" {
  given "a division function" {
    fn divide(a: int, b: int) -> Result<int, string> {
      if b == 0 { Err("division by zero") } else { Ok(a / b) }
    }

    then "valid division returns Ok" {
      divide(10, 2) is Ok
    }

    then "division by zero returns Err" {
      divide(10, 0) is Err
    }

    then "null check works" {
      let x: int? = null
      x is null
    }
  }
}
```

## Test 9: `roughly` — approximate matching

```forge
spec "calculations" {
  then "pi approximation" {
    let pi = calculate_pi(1000)
    roughly(pi, 3.14159, tolerance: 0.01)
  }

  then "timing is reasonable" {
    let elapsed = time { sort_large_list() }
    roughly(elapsed, 50ms, tolerance: 30ms)
  }
}
```

## Test 10: `eventually` — poll until true

```forge
spec "async operations" {
  given "a background job" {
    let counter = channel<int>(10)

    spawn {
      sleep(200ms)
      counter <- 1
    }

    then "completes within timeout" eventually(timeout: 1s, poll: 50ms) {
      counter.length > 0
    }
  }
}
```

```
  async operations
    given a background job
      ✓ completes within timeout (after 250ms, 5 polls)

  1 passed
```

## Test 11: `snapshot` — value snapshots

```forge
spec "API response format" {
  given "a user" {
    let user = User.create({ name: "alice", email: "alice@test.com" })

    then "json format is stable" {
      snapshot("user_json", json.stringify(user))
    }

    then "field list is stable" {
      snapshot("user_fields", typeof(user).fields.map(it.name).join(", "))
    }
  }
}
```

First run: creates `.snap` files alongside the test:
```
tests/
├── user_test.fg
└── user_test.snap/
    ├── user_json.snap
    └── user_fields.snap
```

Subsequent runs: compares against saved snapshot. Mismatch = failure:

```
  ✖ json format is stable

    snapshot mismatch for "user_json":

    - {"id":1,"name":"alice","email":"alice@test.com"}
    + {"id":1,"name":"alice","email":"alice@test.com","created_at":"2026-03-12"}

    Run `forge test --update-snapshots` to accept the new value
```

## Test 12: `fuzz` — property-based testing

```forge
spec "sorting" {
  fuzz "length preserved" (input: List<int>) {
    input.sorted().length == input.length
  }

  fuzz "output is ordered" (input: List<int>) {
    let sorted = input.sorted()
    sorted.windows(2).all((a, b) -> a <= b)
  }

  fuzz "idempotent" (input: List<int>) {
    input.sorted() == input.sorted().sorted()
  }
}
```

```
  sorting
    ✓ length preserved (100 cases)
    ✓ output is ordered (100 cases)
    ✓ idempotent (100 cases)

  3 passed (45ms)
```

On failure, shows the shrunk minimal case:

```
  ✖ output is ordered (failed after 23 cases)

    Minimal failing input: [2, 1]

    input.sorted() == [2, 1]  (not sorted!)

    Shrunk from: [84, 2, 91, 1, 37]
```

## Test 13: `bench` — built-in benchmarking

```forge
spec "performance" {
  bench "list sort" {
    let data = (0..1000).map(_ -> random_int())
    data.sorted()
  }

  bench "hash map insert" {
    let m = Map.new()
    (0..1000).each(i -> m.set(string(i), i))
  }
}
```

```bash
forge test --bench
```

```
  performance
    ⏱ list sort         1.2ms avg  (min 0.9ms, max 1.8ms, 100 runs)
    ⏱ hash map insert   0.8ms avg  (min 0.6ms, max 1.1ms, 100 runs)
```

## Test 14: `skip` and `todo` markers

```forge
spec "user service" {
  then "creates user" {
    User.create({ name: "alice" }) is Ok
  }

  skip "deletes user" {
    // skipped — delete not implemented yet
    User.delete(1) is Ok
  }

  todo "updates user email"
  todo "handles concurrent access"
}
```

```
  user service
    ✓ creates user
    ⊘ deletes user (skipped)
    ○ updates user email (todo)
    ○ handles concurrent access (todo)

  1 passed, 1 skipped, 2 todo
```

## Test 15: Multiple specs in one file

```forge
spec "User model" {
  given "valid data" {
    then "creates successfully" { User.create({ name: "alice" }) is Ok }
  }
}

spec "Task model" {
  given "valid data" {
    then "creates successfully" { Task.create({ title: "test" }) is Ok }
  }
}
```

```
  User model
    given valid data
      ✓ creates successfully

  Task model
    given valid data
      ✓ creates successfully

  2 passed
```

## Test 16: Struct diff on failure

```forge
spec "user fields" {
  given "a created user" {
    let user = User.create({ name: "alice", email: "alice@test.com" })

    then "matches expected" {
      user == { id: 1, name: "alice", email: "bob@test.com" }
    }
  }
}
```

```
  ✖ matches expected

    diff:
      {
        id: 1
        name: "alice"
    -   email: "alice@test.com"
    +   email: "bob@test.com"
      }
```

## Test 17: List diff on failure

```forge
spec "sorting" {
  then "sorts correctly" {
    let result = [3, 1, 4, 1, 5].sorted()
    result == [1, 1, 3, 4, 6]
  }
}
```

```
  ✖ sorts correctly

    diff:
      [1, 1, 3, 4, -5- +6+]
                    ^^^
                    index 4: got 5, expected 6
```

## Test 18: Test filtering from CLI

```bash
# Run all specs
forge test

# Run one file
forge test tests/user_test.fg

# Run specs matching a pattern
forge test --filter "user"

# Run only a specific then block
forge test --filter "creates user"

# Run only fuzz tests
forge test --fuzz

# Run only benchmarks
forge test --bench
```

---

## package.toml

```toml
[package]
name = "test"
namespace = "std"
version = "0.1.0"
description = "Test primitives: spec, given, then, fuzz, bench, snapshot"

[native]
library = "forge_test"

[components.spec]
kind = "block"
context = "top_level"
body = "mixed"
```

## package.fg

```forge
extern fn forge_test_start_spec(name: string)
extern fn forge_test_start_given(name: string)
extern fn forge_test_run_then(name: string, result: bool, file: string, line: int)
extern fn forge_test_run_then_should_fail(name: string, did_error: bool, error_msg: string, expected_msg: string, file: string, line: int)
extern fn forge_test_skip(name: string)
extern fn forge_test_todo(name: string)
extern fn forge_test_snapshot_check(name: string, value: string) -> bool
extern fn forge_test_snapshot_update(name: string, value: string)
extern fn forge_test_fuzz_run(name: string, iterations: int, test_fn: fn(string) -> bool) -> string
extern fn forge_test_bench_run(name: string, iterations: int, bench_fn: fn() -> void) -> string
extern fn forge_test_summary()

component spec(name: string) {
  config {}

  event before_all()
  event after_all()

  fn given(name: string, body: fn()) {
    forge_test_start_given(name)
    body()
  }

  fn then(name: string, body: fn() -> bool) {
    let result = body()
    forge_test_run_then(name, result, __file__, __line__)
  }

  @syntax("{name} should_fail")
  fn then_should_fail(name: string, body: fn()) {
    let did_error = (body() catch { true }) is bool
    forge_test_run_then_should_fail(name, did_error, "", "", __file__, __line__)
  }

  @syntax("{name} should_fail_with {expected}")
  fn then_should_fail_with(name: string, expected: string, body: fn()) {
    let error_msg = body() catch { err.message }
    let did_error = error_msg is string
    forge_test_run_then_should_fail(name, did_error, error_msg ?? "", expected, __file__, __line__)
  }

  @syntax("{name} where {data}")
  fn then_where(name: string, data: List<any>, body: fn() -> bool) {
    for row in data {
      // Bind row fields as local variables, run body
      let result = body_with_bindings(row)
      forge_test_run_then(
        `${name} (${row_summary(row)})`,
        result, __file__, __line__
      )
    }
  }

  @syntax("{name} eventually(timeout: {t}, poll: {p})")
  fn then_eventually(name: string, t: duration, p: duration = 100ms, body: fn() -> bool) {
    let start = now()
    mut passed = false
    mut polls = 0
    while now() - start < t {
      polls = polls + 1
      if body() { passed = true; break }
      sleep(p)
    }
    forge_test_run_then(name, passed, __file__, __line__)
  }

  fn skip(name: string, body: fn() -> bool) {
    forge_test_skip(name)
  }

  fn todo(name: string) {
    forge_test_todo(name)
  }

  fn snapshot(name: string, value: string) -> bool {
    forge_test_snapshot_check(name, value)
  }

  fn fuzz(name: string, iterations: int = 100, test_fn: fn(string) -> bool) {
    let result = forge_test_fuzz_run(name, iterations, test_fn)
    // native lib handles shrinking and reporting
  }

  fn bench(name: string, iterations: int = 100, body: fn()) {
    let result = forge_test_bench_run(name, iterations, body)
    // native lib handles timing and reporting
  }

  fn roughly(actual: float, expected: float, tolerance: float) -> bool {
    (actual - expected).abs() <= tolerance
  }

  on startup { forge_test_start_spec(name) }
  on main_end { forge_test_summary() }
}
```

---

## What's Reused vs New

| Feature | Built on |
|---|---|
| `spec` | Component |
| `given` | Scoped function in component |
| `then` | Scoped function, last expr is bool |
| `where` | Table literal + iteration |
| `should_fail` | `catch` error handling |
| `should_fail_with` | `catch` + string contains |
| `is Ok` / `is Err` / `is null` | `is` keyword |
| `roughly` | Plain function returning bool |
| `eventually` | Loop + sleep + bool check |
| `snapshot` | Package function + filesystem |
| `fuzz` | Package function + `Fuzzable` trait |
| `bench` | Package function + native timing |
| `skip` / `todo` | Scoped functions |
| Struct diff on failure | `json.stringify` + native diff |
| List diff on failure | Native diff in test runner |
| Expression introspection | Compiler embeds expr source in `then` blocks |

Zero new language features. Everything is components, functions, `is`, `table`, and existing error handling.

---

# Implementation Notes & Open Questions

## Concerns

### Per-`then` Isolation
The spec says each `then` block should run in isolation so side effects don't leak between tests. Three options:
1. **Re-run setup**: Re-execute all `given` blocks before each `then`. Simple but slow — O(n×m) for n givens × m thens.
2. **Fork**: `fork()` before each `then`, run in child process. True isolation but platform-dependent (no Windows) and complicates test output collection.
3. **Scope snapshot**: Save/restore variable state. Requires deep-copy semantics the language doesn't have yet.

**Recommendation**: Start with option 1 (re-run setup). It's correct and simple. Optimize later if benchmarks show it matters.

### Expression Diff on Failure
The spec wants `a + b == expected` to print `"expected 30, got 25"` on failure. This requires the compiler to introspect expressions at compile time — decompose `==` into LHS/RHS, stringify each side, and emit code that captures both values before comparison. This is a compiler transform (macro-like expansion), not a runtime feature. It's doable but touches core expression codegen.

### `eventually` / Async Polling
`eventually(timeout) { condition }` needs a sleep/retry loop. Forge has no `sleep()` runtime function yet. Adding one to `@std/process` is straightforward (`std::thread::sleep`), but the polling interval and timeout semantics need design — fixed interval? exponential backoff? configurable?

## Questions for Design

1. **Snapshot storage**: Where do `.snap` files live? Next to the test file? In a `.forge-snapshots/` dir? What's the update workflow — a CLI flag like `--update-snapshots`?

2. **Fuzz testing scope**: Full property-based testing (QuickCheck-style with shrinking) is a large undertaking. Should we start with simple random input generation and add shrinking later? What types get generators — just primitives, or also structs/tables?

3. **Bench timing**: `bench "name" { expr }` needs warm-up runs, multiple iterations, and statistical reporting (min/max/median/stddev). Should this be a separate `forge bench` command or integrated into `forge test`?

4. **CLI `--filter`**: The `forge test --filter "pattern"` flag needs the test runner to pass filter strings to the native runtime. Should filtering happen at compile time (skip codegen for non-matching tests) or runtime (check filter before executing each test)?

## Ideas

- **`test.capture_stdout`**: Wrap a block and capture its stdout as a string for assertion. Useful for testing CLI output. Needs `dup2`/pipe plumbing in the runtime.
- **`test.mock(fn_name, replacement)`**: Function-level mocking by swapping function pointers at runtime. Requires an indirection table for mockable functions.
- **`test.timeout(ms) { block }`**: Per-test timeout via `alarm()`/signal handler or thread-based watchdog.
- **Parallel test execution**: Run spec blocks concurrently. Requires test output buffering per-spec and a merge step. The `atexit` summary handler would need atomic counters (already using statics, would need `AtomicU32`).
