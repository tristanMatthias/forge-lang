# Forge — World-Class Error System

## Philosophy

Errors are not failures — they're a conversation between the compiler and the developer. Every error should answer three questions instantly: **what** went wrong, **where** it went wrong, and **how** to fix it. For agents, errors must be machine-parseable and actionable without human interpretation.

Inspired by: Rust (structured diagnostics with codes), Elm (friendly explanations), ariadne (beautiful rendering), and miette (rich metadata).

---

## 1. Error Anatomy

Every Forge error has these parts:

```
  ╭─[error[F0012]] Type mismatch
  │
  │  ╭─[src/main.fg:23:14]
  │  │
  │  │   22 │ let user = UserService.get(id)
  │  │   23 │ let name: int = user.name
  │  │      │           ───   ─────────
  │  │      │            │         │
  │  │      │            │         ╰── this is string
  │  │      │            ╰── expected int
  │  │
  │  ├── help: change the type annotation
  │  │
  │  │   23 │ let name: string = user.name
  │  │      │           ~~~~~~
  │  │
  │  ├── docs: https://forgelang.dev/errors/F0012
  │  │
  │  ╰── tip: user.name comes from the User model where name is declared as string
  │
  ╰──
```

### Parts:

| Part | Purpose |
|---|---|
| **Error code** | `F0012` — stable, searchable, links to docs |
| **Title** | Short description: "Type mismatch" |
| **Source location** | File, line, column with code snippet |
| **Primary label** | Points at the problem with explanation |
| **Secondary labels** | Points at related code that contributes to the error |
| **Help** | Concrete fix — shows the corrected code |
| **Docs link** | URL to full explanation with examples |
| **Tip** | Optional extra context (where the type came from, etc.) |

---

## 2. Error Levels

| Level | Icon | When |
|---|---|---|
| `error` | `✖` | Code won't compile |
| `warning` | `⚠` | Code compiles but something is suspicious |
| `info` | `ℹ` | Informational (deprecation notices, etc.) |
| `hint` | `💡` | Suggestion for improvement (unused variable, etc.) |

---

## 3. Error Code Registry

### Format

Error codes follow the pattern `F{category}{number}`:

| Range | Category |
|---|---|
| F00xx | Syntax errors |
| F01xx | Type errors |
| F02xx | Name resolution errors |
| F03xx | Model/component errors |
| F04xx | Import/module errors |
| F05xx | FFI/extern errors |
| F06xx | Concurrency errors |
| F07xx | Package errors |
| F08xx | Trait errors |
| F09xx | Pattern matching errors |

### Registry File

Error definitions live in a single TOML file that's easy to maintain and extend:

```toml
# errors/registry.toml

[F0001]
title = "Unexpected token"
level = "error"
message = "expected {expected}, found {found}"
help = "check for missing punctuation or misspelled keywords"
doc = """
The parser encountered a token it wasn't expecting. Common causes:
- Missing closing brace `}`
- Missing comma in a list or function arguments
- Misspelled keyword (e.g., `funciton` instead of `fn`)
"""
examples = [
  { code = "fn main( { }", error_at = 9, fix = "fn main() { }" },
]

[F0012]
title = "Type mismatch"
level = "error"
message = "expected {expected}, found {actual}"
help = "change the type annotation or the value to match"
doc = """
The type of a value doesn't match what was expected. This can happen when:
- A variable has an explicit type annotation that doesn't match the assigned value
- A function argument doesn't match the parameter type
- A return value doesn't match the declared return type
"""
examples = [
  { code = "let x: int = \"hello\"", error_at = 13, fix = "let x: string = \"hello\"" },
  { code = "let x: int = \"hello\"", error_at = 13, fix = "let x: int = 42" },
]

[F0013]
title = "Cannot assign to immutable binding"
level = "error"
message = "`{name}` is declared with `let` and cannot be reassigned"
help = "use `mut` instead of `let` if you need to reassign"
doc = """
Variables declared with `let` are immutable by default.
To make a variable mutable, use `mut` instead.
"""
examples = [
  { code = "let x = 1\nx = 2", error_at = 11, fix = "mut x = 1\nx = 2" },
]

[F0024]
title = "Possible null access"
level = "error"
message = "`{name}` is {type} which may be null"
help = "use `?.` for safe access, `??` for a default, or check for null first"
doc = """
You're accessing a property or calling a method on a value that might be null.
Forge requires you to handle the null case explicitly.
"""
examples = [
  { code = "let name: string? = null\nname.upper()", error_at = 25, fix = "name?.upper() ?? \"default\"" },
  { code = "let name: string? = null\nname.upper()", error_at = 25, fix = "if name != null { name.upper() }" },
]

[F0040]
title = "Trait not implemented"
level = "error"
message = "`{type}` does not implement `{trait}`"
help = "add an impl block"
doc = """
A function requires its argument to implement a trait, but the type you're
passing doesn't have that implementation.
"""
examples = [
  {
    code = "fn show<T: Display>(x: T) { }\ntype Foo = { x: int }\nshow(Foo { x: 1 })",
    error_at = 52,
    fix = "impl Display for Foo {\n  fn display(self) -> string { `Foo(${self.x})` }\n}"
  },
]

[F0071]
title = "Unknown config option"
level = "error"
message = "`{key}` is not a valid config option for `{component}`"
help = "available options: {available_options}"
doc = """
You used a config key inside a component block that the component doesn't recognize.
Check the component's documentation for valid config options.
"""

[F0091]
title = "Non-exhaustive match"
level = "error"
message = "match does not cover all cases"
help = "add the missing patterns or a wildcard `_` arm"
doc = """
A match expression must cover every possible value. If you're matching on an
enum, every variant must have an arm. Add the missing variants or use `_` as
a catch-all.
"""
```

### Generating Docs from Registry

```bash
forge docs errors           # generate error reference docs from registry.toml
forge explain F0012         # print the full explanation for an error code
```

The `forge explain` command prints the doc, examples, and fix suggestions directly in the terminal. The docs website auto-generates an error index from `registry.toml`.

---

## 4. Smart Suggestions

### 4.1 Did You Mean

Levenshtein distance matching for misspelled identifiers:

```
  ╭─[error[F0020]] Undefined variable
  │
  │  ╭─[src/main.fg:5:10]
  │  │
  │  │    5 │ println(uesr.name)
  │  │      │         ────
  │  │      │          │
  │  │      │          ╰── `uesr` is not defined
  │  │
  │  ├── help: did you mean `user`?
  │  │
  │  │    5 │ println(user.name)
  │  │      │         ~~~~
  │  ╰──
```

### 4.2 Missing Import Suggestion

```
  ╭─[error[F0040]] Undefined type `Request`
  │
  │  ╭─[src/main.fg:3:15]
  │  │
  │  │    3 │ fn handle(req: Request) -> Response {
  │  │      │                ───────
  │  │
  │  ├── help: add an import
  │  │
  │  │    1 │ use @std.http.{Request, Response}
  │  │
  │  ╰── tip: Request is exported by @std.http
```

### 4.3 Type Coercion Hints

```
  ╭─[error[F0012]] Type mismatch
  │
  │  ╭─[src/main.fg:8:20]
  │  │
  │  │    8 │ let port: string = 8080
  │  │      │           ──────   ────
  │  │      │            │        │
  │  │      │            │        ╰── this is int
  │  │      │            ╰── expected string
  │  │
  │  ├── help: convert with `string()`
  │  │
  │  │    8 │ let port: string = string(8080)
  │  │      │                    ~~~~~~~~~~~~
  │  ╰──
```

### 4.4 Exhaustive Match Suggestions

```
  ╭─[error[F0091]] Non-exhaustive match
  │
  │  ╭─[src/main.fg:12:3]
  │  │
  │  │   12 │ match status {
  │  │   13 │   .active -> "active"
  │  │   14 │   .pending -> "pending"
  │  │   15 │ }
  │  │      │ ─
  │  │      │ │
  │  │      │ ╰── missing: .done, .failed
  │  │
  │  ├── help: add the missing arms
  │  │
  │  │   14 │   .pending -> "pending"
  │  │   15 │   .done -> todo("handle done")
  │  │   16 │   .failed -> todo("handle failed")
  │  │   17 │ }
  │  │
  │  ╰── tip: or add `_ -> ...` as a catch-all
```

### 4.5 Package-Specific Suggestions

Packages can register custom error messages for common mistakes:

```
  ╭─[error[F0071]] Unknown config option
  │
  │  ╭─[src/main.fg:3:3]
  │  │
  │  │    2 │ server :8080 {
  │  │    3 │   ssl true
  │  │      │   ───
  │  │      │    │
  │  │      │    ╰── `ssl` is not a config option for `server`
  │  │
  │  ├── help: did you mean `tls`?
  │  │
  │  │   available options: cors, logging, rate_limit, tls
  │  │
  │  ╰── docs: https://forgelang.dev/packages/std-http#server-config
```

---

## 5. JSON Output

`forge build --error-format=json` produces machine-parseable output for agents:

```json
{
  "diagnostics": [
    {
      "code": "F0012",
      "level": "error",
      "title": "Type mismatch",
      "message": "expected int, found string",
      "file": "src/main.fg",
      "span": {
        "start": { "line": 23, "col": 14, "offset": 456 },
        "end": { "line": 23, "col": 23, "offset": 465 }
      },
      "labels": [
        {
          "span": { "start": { "line": 23, "col": 14 }, "end": { "line": 23, "col": 17 } },
          "message": "expected int",
          "kind": "primary"
        },
        {
          "span": { "start": { "line": 23, "col": 20 }, "end": { "line": 23, "col": 29 } },
          "message": "this is string",
          "kind": "secondary"
        }
      ],
      "suggestions": [
        {
          "message": "change type annotation to string",
          "edits": [
            {
              "span": { "start": { "line": 23, "col": 14 }, "end": { "line": 23, "col": 17 } },
              "replacement": "string"
            }
          ],
          "confidence": 0.95
        }
      ],
      "docs_url": "https://forgelang.dev/errors/F0012",
      "tip": "user.name comes from the User model where name is declared as string"
    }
  ]
}
```

Agents use this to: parse the error, read the highest-confidence suggestion, apply the edit, rebuild. Fully automated fix loop.

---

## 6. Multi-Error Reporting

Don't stop at the first error. Collect and report multiple errors in one pass, but limit to avoid flooding:

```
  ╭─[error[F0012]] Type mismatch
  │  ...
  ╰──

  ╭─[error[F0020]] Undefined variable
  │  ...
  ╰──

  ╭─[warning[F0801]] Unused variable
  │  ...
  ╰──

  Found 2 errors and 1 warning.
  Run `forge explain F0012` for more information about type mismatches.
```

Max errors per build: 20 (configurable with `--max-errors`). After hitting the limit: "... and N more errors. Fix the above first."

---

## 7. Warning System

Warnings don't prevent compilation but surface potential issues:

| Code | Warning |
|---|---|
| F0800 | Unused import |
| F0801 | Unused variable (suggest prefix with `_`) |
| F0802 | Unreachable code after return/break/panic |
| F0803 | Shadowed variable |
| F0804 | Redundant null check (value is never null) |
| F0805 | Empty match arm body |
| F0806 | Deprecated function/feature |

```
  ╭─[warning[F0801]] Unused variable
  │
  │  ╭─[src/main.fg:5:7]
  │  │
  │  │    5 │ let result = compute()
  │  │      │     ──────
  │  │      │      │
  │  │      │      ╰── `result` is never used
  │  │
  │  ├── help: prefix with _ if intentional
  │  │
  │  │    5 │ let _result = compute()
  │  │
  │  ╰── or remove the binding: compute()
```

---

## 8. Implementation

### 8.1 Use ariadne for rendering

ariadne produces the prettiest output of any Rust diagnostic library. It handles multi-line spans, overlapping labels, colored output, and Unicode box-drawing characters.

```toml
# Cargo.toml
[dependencies]
ariadne = { version = "0.4", features = ["concolor"] }
```

### 8.2 Diagnostic struct

```rust
pub struct Diagnostic {
    pub code: String,              // "F0012"
    pub level: Level,              // Error, Warning, Info, Hint
    pub title: String,             // "Type mismatch"
    pub message: String,           // "expected int, found string"
    pub file: String,
    pub labels: Vec<Label>,
    pub suggestions: Vec<Suggestion>,
    pub tip: Option<String>,
    pub related: Vec<Diagnostic>,  // related errors
}

pub struct Label {
    pub span: Span,
    pub message: String,
    pub kind: LabelKind,           // Primary, Secondary
}

pub struct Suggestion {
    pub message: String,
    pub edits: Vec<Edit>,
    pub confidence: f64,           // 0.0 to 1.0
}

pub struct Edit {
    pub span: Span,
    pub replacement: String,
}
```

### 8.3 Error registry loader

At compile time, load `errors/registry.toml` and build a HashMap of error code → metadata. When emitting a diagnostic, look up the code to get the doc URL and template.

### 8.4 Suggestion engine

Build suggestions contextually:

1. **Levenshtein matching** — for undefined identifiers, search all in-scope names
2. **Type-based suggestions** — for type mismatches, suggest conversions (`string()`, `int()`)
3. **Import resolver** — for undefined types/functions, search all package exports
4. **Pattern completeness** — for non-exhaustive matches, list missing variants
5. **Config validation** — for component blocks, list valid config options with did-you-mean

---

## 9. Testing Error Messages

Every error code must have test coverage. Tests verify both the error detection and the quality of the output:

```rust
#[test]
fn test_type_mismatch_with_suggestion() {
    let source = r#"
        let x: int = "hello"
    "#;
    let diag = compile_and_get_error(source);
    assert_eq!(diag.code, "F0012");
    assert_eq!(diag.level, Level::Error);
    assert!(diag.suggestions.len() > 0);
    assert!(diag.suggestions[0].edits[0].replacement == "string"
         || diag.suggestions[0].edits[0].replacement == "42");
}

#[test]
fn test_did_you_mean() {
    let source = r#"
        let user = "alice"
        println(uesr)
    "#;
    let diag = compile_and_get_error(source);
    assert_eq!(diag.code, "F0020");
    assert!(diag.suggestions[0].message.contains("user"));
}

#[test]
fn test_json_output_parseable() {
    let source = r#"let x: int = "hello""#;
    let json = compile_with_json_errors(source);
    let parsed: serde_json::Value = serde_json::from_str(&json).unwrap();
    assert!(parsed["diagnostics"][0]["code"].as_str() == Some("F0012"));
    assert!(parsed["diagnostics"][0]["suggestions"].as_array().unwrap().len() > 0);
}
```

---

## 10. Zero Error Leaks

No raw panics, LLVM errors, or Rust stack traces should ever reach the user. Every possible failure path must produce a proper `Diagnostic`.

### 10.1 No unwrap/panic/expect in compiler source

Every function that can fail returns `Result<T, Diagnostic>`. No exceptions.

```bash
# CI lint — run on every PR:

# No unwrap() outside of tests
grep -rn "\.unwrap()" compiler/src/ --include="*.rs" | grep -v _test | grep -v "/tests/" | wc -l
# Expected: 0

# No raw panic!() outside of tests
grep -rn "panic!" compiler/src/ --include="*.rs" | grep -v _test | grep -v "/tests/" | wc -l
# Expected: 0

# No expect() outside of tests
grep -rn "\.expect(" compiler/src/ --include="*.rs" | grep -v _test | grep -v "/tests/" | wc -l
# Expected: 0
```

### 10.2 Error code coverage check

Every `F####` code emitted in the codebase must exist in `registry.toml`:

```bash
# Extract all error codes from source
grep -roh "F[0-9]\{4\}" compiler/src/ --include="*.rs" | sort -u > /tmp/used_codes.txt

# Extract all error codes from registry
grep -oh "F[0-9]\{4\}" errors/registry.toml | sort -u > /tmp/registered_codes.txt

# Find any used but unregistered codes
comm -23 /tmp/used_codes.txt /tmp/registered_codes.txt
# Expected: empty
```

### 10.3 Internal compiler errors

When the compiler hits an unexpected state (a bug in the compiler itself), it must still produce a pretty diagnostic, never a raw Rust panic:

```
  ╭─[internal[F9999]] Compiler bug
  │
  │  This is a bug in the Forge compiler, not in your code.
  │  Please report it at https://github.com/forge-lang/forge/issues
  │
  │  Context: codegen failed to lower match arm at src/main.fg:12:5
  │  Compiler location: codegen/pattern_match.rs:142
  │
  ╰──
```

Implementation: wrap the entire compiler pipeline in a `catch_unwind`. If anything panics, catch it and emit `F9999` with as much context as possible. The user never sees `thread 'main' panicked at`.

```rust
// In main.rs
fn main() {
    let result = std::panic::catch_unwind(|| {
        run_compiler()
    });

    match result {
        Ok(Ok(())) => std::process::exit(0),
        Ok(Err(diagnostics)) => {
            render_diagnostics(&diagnostics);
            std::process::exit(1);
        }
        Err(panic_info) => {
            render_internal_error(panic_info);
            std::process::exit(2);
        }
    }
}
```

### 10.4 Package error boundaries

Errors from package native libraries are caught at the FFI boundary and wrapped in diagnostics:

```
  ╭─[error[F0700]] Package error
  │
  │  ╭─[src/main.fg:14:3]
  │  │
  │  │   14 │ emails.send({ to: "alice@test.com" })
  │  │      │ ─────────────────────────────────────
  │  │
  │  ├── @std/queue encountered an internal error:
  │  │   "queue buffer full: capacity 1000 exceeded"
  │  │
  │  ├── help: increase buffer_size in queue config, or consume messages faster
  │  │
  │  ╰── This may be a bug in the package, not in your code.
  │      Package: @std/queue v0.1.0
```

### 10.5 LLVM error wrapping

LLVM can fail during codegen or linking. These are always wrapped:

```
  ╭─[internal[F9998]] Code generation failed
  │
  │  The LLVM backend encountered an error while compiling your program.
  │  This is likely a compiler bug.
  │
  │  LLVM error: "Cannot select: intrinsic %llvm.experimental.vector.reduce.add"
  │  While compiling: src/main.fg, function main()
  │
  │  Please report at https://github.com/forge-lang/forge/issues
  │
  ╰──
```

---

## 11. Claude Code / Agent Integration

### 11.1 Update CLAUDE.md

Add to the project's `CLAUDE.md` (or equivalent agent instruction file):

```markdown
## Error System Rules

- NEVER use `.unwrap()`, `.expect()`, or `panic!()` in compiler source code outside of tests
- ALL errors must go through the Diagnostic system with a registered error code
- Every new error code must be added to `errors/registry.toml` with title, doc, and examples
- Error messages must include a concrete suggestion when possible
- Run `./scripts/lint-errors.sh` before committing to verify:
  - Zero unwrap/panic/expect outside tests
  - All error codes registered in registry.toml
  - All error codes have at least one test
- When adding a new error path, always include:
  1. Primary label pointing at the exact problem
  2. At least one suggestion with replacement text
  3. A tip explaining where the conflicting type/name came from (if applicable)
- Internal compiler failures use F9999 — never let raw panics reach the user
```

### 11.2 Lint script

Create `scripts/lint-errors.sh` that runs all the checks from sections 10.1 and 10.2. This runs in CI and can be run locally:

```bash
#!/bin/bash
set -e

echo "=== Checking for unwrap/panic/expect ==="
UNWRAP=$(grep -rn "\.unwrap()" compiler/src/ --include="*.rs" | grep -v _test | grep -v "/tests/" | wc -l)
PANIC=$(grep -rn "panic!" compiler/src/ --include="*.rs" | grep -v _test | grep -v "/tests/" | wc -l)
EXPECT=$(grep -rn "\.expect(" compiler/src/ --include="*.rs" | grep -v _test | grep -v "/tests/" | wc -l)

if [ "$UNWRAP" -gt 0 ] || [ "$PANIC" -gt 0 ] || [ "$EXPECT" -gt 0 ]; then
  echo "FAIL: Found $UNWRAP unwrap(), $PANIC panic!(), $EXPECT expect()"
  exit 1
fi
echo "PASS"

echo "=== Checking error code coverage ==="
grep -roh "F[0-9]\{4\}" compiler/src/ --include="*.rs" | sort -u > /tmp/used_codes.txt
grep -oh "F[0-9]\{4\}" errors/registry.toml | sort -u > /tmp/registered_codes.txt
MISSING=$(comm -23 /tmp/used_codes.txt /tmp/registered_codes.txt | wc -l)

if [ "$MISSING" -gt 0 ]; then
  echo "FAIL: Unregistered error codes:"
  comm -23 /tmp/used_codes.txt /tmp/registered_codes.txt
  exit 1
fi
echo "PASS"

echo "=== All error checks passed ==="
```

---

## 12. Definition of Done

1. All existing error codes use the new diagnostic system with full labels and suggestions
2. `errors/registry.toml` contains every error code with title, doc, and examples
3. `forge explain F0012` prints the full explanation
4. `forge build --error-format=json` produces valid, parseable JSON with suggestions
5. Did-you-mean works for identifiers, types, and config options
6. Missing import suggestions work for all package exports
7. Non-exhaustive match lists missing variants
8. Multi-error reporting works (up to 20 errors per build)
9. Warnings fire for unused variables, unused imports, unreachable code
10. Every error code has at least one test
11. Output renders beautifully in terminal with Unicode box-drawing and colors
12. **Zero** `.unwrap()`, `.expect()`, or `panic!()` in compiler source outside tests
13. **Every** error code in source exists in `registry.toml`
14. Internal compiler errors produce `F9999` with context, never raw panics
15. Package errors produce `F0700` with package name and version, never raw FFI crashes
16. LLVM errors produce `F9998` with context, never raw LLVM output
17. `scripts/lint-errors.sh` passes in CI
18. `CLAUDE.md` updated with error system rules
