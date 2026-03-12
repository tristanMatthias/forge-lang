# Forge — Advanced Error Features (TDD)

All tests red first. Implement until green.

---

## Test 1: --autofix applies suggestions

```bash
# Create a file with a known fixable error
cat > autofix_test.fg << 'EOF'
fn main() {
  let name: int = "hello"
}
EOF

# Autofix should modify the file and compile successfully
forge build autofix_test.fg --autofix

# The file should now be fixed
cat autofix_test.fg
# Expected:
# fn main() {
#   let name: string = "hello"
# }

# Should compile cleanly now
forge build autofix_test.fg
# Expected: exit code 0, no errors
```

```bash
# Multiple fixes in one pass
cat > multi_fix.fg << 'EOF'
fn main() {
  let x: string = 42
  let y: int = "hello"
  let z = x + y
}
EOF

forge build multi_fix.fg --autofix
forge build multi_fix.fg
# Expected: exit code 0
```

```bash
# Low confidence fixes should NOT auto-apply
cat > low_confidence.fg << 'EOF'
fn main() {
  println(usr.name)
}
EOF

forge build low_confidence.fg --autofix 2>&1 | grep "1 error could not be auto-fixed"
# Expected: match (did-you-mean is not high enough confidence to auto-apply)
```

---

## Test 2: Causality chains ("because")

```forge
// test_because_type.fg
fn get_name() -> string { "alice" }

fn main() {
  let x: int = get_name()
}
```

```bash
forge build test_because_type.fg 2>&1
```

Expected output includes a "because" chain:

```
  ╭─[error[F0012]] Type mismatch
  │
  │  ╭─[src/test_because_type.fg:4:17]
  │  │
  │  │    4 │ let x: int = get_name()
  │  │      │        ───   ──────────
  │  │      │         │         │
  │  │      │         │         ╰── this is string
  │  │      │         ╰── expected int
  │  │
  │  ├── because: get_name() returns string
  │  │     → declared at test_because_type.fg:1
  │  │     → fn get_name() -> string
  │  │
  │  ├── help: change the type annotation
  │  │    4 │ let x: string = get_name()
  │  │
  │  ╰──
```

```forge
// test_because_chain.fg
use @std.model.{model}

model User {
  id: int @primary @auto_increment
  name: string
}

fn main() {
  let user = User.get(1)
  let x: int = user?.name
}
```

Expected: because chain traces through model field → nullable return → field access:

```
  ├── because: user?.name is string? because
  │     → user is User? (User.get returns User?)
  │     → User.name is string (declared at test_because_chain.fg:5)
  │     → ?. propagates nullability, so result is string?
```

---

## Test 3: Generated examples from type signatures

```forge
// test_example_gen.fg
use @std.model.{model, service}

model Task {
  id: int @primary @auto_increment
  title: string
  done: bool @default(false)
}

service TaskService for Task {}

fn main() {
  TaskService.create("wrong")
}
```

Expected output includes a generated example:

```
  ╭─[error[F0014]] Wrong number of arguments
  │
  │  ╭─[test_example_gen.fg:13:3]
  │  │
  │  │   13 │ TaskService.create("wrong")
  │  │      │ ───────────────────────────
  │  │
  │  ├── expected: TaskService.create(data: { title: string, done: bool })
  │  │
  │  ├── example:
  │  │   13 │ TaskService.create({ title: "...", done: false })
  │  │
  │  ╰──
```

```forge
// test_example_fn.fg
fn send_email(to: string, subject: string, body: string) { }

fn main() {
  send_email("alice@test.com")
}
```

Expected:

```
  ├── expected: send_email(to: string, subject: string, body: string)
  │
  ├── example:
  │   send_email("alice@test.com", "...", "...")
```

---

## Test 4: Runtime errors with source locations

```forge
// test_runtime_error.fg
fn divide(a: int, b: int) -> int {
  assert b != 0, "division by zero"
  a / b
}

fn calculate() -> int {
  let x = divide(10, 2)
  let y = divide(x, 0)
  y
}

fn main() {
  println(string(calculate()))
}
```

```bash
forge build test_runtime_error.fg -o test_runtime
./test_runtime 2>&1
```

Expected (pretty-printed to stderr, not a raw panic):

```
  ╭─[panic] Assertion failed: division by zero
  │
  │  ╭─[test_runtime_error.fg:2:3]
  │  │
  │  │    2 │   assert b != 0, "division by zero"
  │  │      │   ─────────────
  │  │      │   b was 0
  │  │
  │  ├── stack trace:
  │  │
  │  │   test_runtime_error.fg:2   divide(10, 0)
  │  │   test_runtime_error.fg:8   calculate()
  │  │   test_runtime_error.fg:12  main()
  │  │
  │  ╰──
```

Key: `b was 0` — the actual value of the variable at the time of the assertion failure.

```forge
// test_runtime_null.fg
fn main() {
  let name: string? = null
  println(name!.upper())
}
```

Expected:

```
  ╭─[panic] Null assertion failed
  │
  │  ╭─[test_runtime_null.fg:3:11]
  │  │
  │  │    3 │   println(name!.upper())
  │  │      │           ─────
  │  │      │           name was null
  │  │
  │  ├── help: use `?.` for safe access or `??` for a default
  │  │    3 │   println(name?.upper() ?? "default")
  │  │
  │  ╰──
```

---

## Test 5: `forge why` command

```forge
// test_why.fg
use @std.model.{model}

model User {
  id: int @primary @auto_increment
  name: string
  email: string @unique
}

fn main() {
  let users = User.list()
  let names = users.map(it.name)
  let first = names[0]
}
```

```bash
forge why test_why.fg:10
```

Expected:

```
  Line 10: let users = User.list()

  users: List<User>
    → User.list() returns List<User>
    → User is a model declared at test_why.fg:3
    → list() is auto-generated by @std/model for all models
```

```bash
forge why test_why.fg:11
```

Expected:

```
  Line 11: let names = users.map(it.name)

  names: List<string>
    → users is List<User> (from line 10)
    → .map(it.name) transforms each User to User.name
    → User.name is string (declared at test_why.fg:5)
    → so map returns List<string>

  it: User
    → implicit closure parameter
    → inferred from List<User>.map()
```

```bash
forge why test_why.fg:12
```

Expected:

```
  Line 12: let first = names[0]

  first: string
    → names is List<string> (from line 11)
    → indexing List<string> with int returns string
```

---

## Test 6: Error diffing

```bash
# First build with errors
cat > diff_test.fg << 'EOF'
fn main() {
  let x: int = "hello"
  let y = undefined_var
  let z: string = 42
}
EOF

forge build diff_test.fg --error-format=json 2> before.json

# Fix one error
cat > diff_test.fg << 'EOF'
fn main() {
  let x: string = "hello"
  let y = undefined_var
  let z: string = 42
}
EOF

forge build diff_test.fg --error-format=json 2> after.json

# Diff
forge errors diff before.json after.json
```

Expected:

```
  ✓ Fixed: 1
    F0012 at diff_test.fg:2 — type mismatch (int vs string)

  ✖ New: 0

  ● Remaining: 2
    F0020 at diff_test.fg:3 — undefined variable `undefined_var`
    F0012 at diff_test.fg:4 — type mismatch (string vs int)

  Progress: 3 → 2 errors (33% reduction)
```

---

## Test 7: Build profiling

```bash
forge build my_project/ --profile
```

Expected (appended after normal build output):

```
  ╭─[profile] Build completed in 1.8s
  │
  │   Lexing + Parsing     120ms   ██░░░░░░░░░░░░░░  7%
  │   Type Checking        340ms   █████░░░░░░░░░░░  19%
  │   Component Expansion  180ms   ███░░░░░░░░░░░░░  10%
  │   Codegen (LLVM IR)    520ms   ████████░░░░░░░░  29%
  │   LLVM Optimization    410ms   ██████░░░░░░░░░░  23%
  │   Linking              230ms   ████░░░░░░░░░░░░  13%
  │
  │   Files: 8
  │   Functions: 42
  │   Binary size: 4.2 MB
  │
  ╰──
```

```bash
# JSON output for CI tracking
forge build my_project/ --profile --profile-format=json
```

```json
{
  "total_ms": 1800,
  "stages": {
    "parse": 120,
    "typecheck": 340,
    "component_expansion": 180,
    "codegen": 520,
    "llvm_opt": 410,
    "link": 230
  },
  "files": 8,
  "functions": 42,
  "binary_size_bytes": 4404019
}
```

---

## Test 8: --autofix with interactive mode

```bash
cat > interactive_test.fg << 'EOF'
fn main() {
  let name: int = "hello"
  println(nmae)
}
EOF

forge build interactive_test.fg --autofix=interactive
```

Expected (prompts for each fix):

```
  ╭─[error[F0012]] Type mismatch
  │
  │    2 │ let name: int = "hello"
  │
  │  ╭─[fix] let name: string = "hello"
  │  │  confidence: 95%
  │  ╰── Apply? [y]es / [n]o / [d]iff / [a]ll

  > y
  ✓ Applied fix to line 2

  ╭─[error[F0020]] Undefined variable `nmae`
  │
  │    3 │ println(nmae)
  │
  │  ╭─[fix] println(name)
  │  │  confidence: 89%
  │  ╰── Apply? [y]es / [n]o / [d]iff / [a]ll

  > y
  ✓ Applied fix to line 3

  Rebuilding... ✓ 0 errors
```

---

## What needs to be built

| Feature | Implementation |
|---|---|
| `--autofix` | Read suggestions from diagnostics, apply edits to source, rebuild |
| `--autofix=interactive` | Same but prompt per fix, show diff on `d` |
| Because chains | Type checker records provenance (where each type came from), diagnostics render the chain |
| Example generation | Given a function signature, construct a valid call with placeholder values |
| Runtime source locations | Embed source map (file + line for each LLVM instruction) in debug info, format panics through ariadne |
| Runtime variable values | For `assert`, capture the expression values before the assert and include in panic message |
| `forge why` | Rerun type checker for a specific span, dump the inference chain |
| `forge errors diff` | Compare two JSON diagnostic outputs, categorize as fixed/new/remaining |
| `--profile` | Wrap each compiler stage in `Instant::now()` / `elapsed()`, format results |
| `--profile-format=json` | Same data, JSON output |
