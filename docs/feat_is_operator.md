# Forge — `is` Keyword (TDD)

`is` is a boolean expression that tests whether a value matches a pattern. It's the inline version of `match` — returns true/false instead of branching.

Desugars to: `match value { pattern -> true, _ -> false }`

---

## Test 1: Type variant check

```forge
fn divide(a: int, b: int) -> Result<int, string> {
  if b == 0 { Err("division by zero") } else { Ok(a / b) }
}

fn main() {
  println(string(divide(10, 2) is Ok))    // true
  println(string(divide(10, 0) is Ok))    // false
  println(string(divide(10, 0) is Err))   // true
}
```

## Test 2: Null check

```forge
fn main() {
  let a: string? = "hello"
  let b: string? = null

  println(string(a is null))     // false
  println(string(b is null))     // true
  println(string(a is string))   // true
  println(string(b is string))   // false
}
```

## Test 3: Enum variant

```forge
enum Status { pending, active, done, failed }

fn main() {
  let s = Status.active

  println(string(s is .active))     // true
  println(string(s is .pending))    // false
  println(string(s is .done))       // false
}
```

## Test 4: Negation with `is not`

```forge
fn main() {
  let x: string? = "hello"

  println(string(x is not null))        // true
  println(string(x is not string))      // false

  let r = Ok(42)
  println(string(r is not Err))         // true
}
```

## Test 5: In if conditions

```forge
fn handle(result: Result<int, string>) -> string {
  if result is Ok {
    "success"
  } else {
    "failure"
  }
}

fn main() {
  println(handle(Ok(42)))      // success
  println(handle(Err("no")))   // failure
}
```

## Test 6: In filter/pipes

```forge
fn main() {
  let items: List<int?> = [1, null, 3, null, 5]

  let non_null = items.filter(it is not null)
  println(string(non_null.length))    // 3

  let results: List<Result<int, string>> = [Ok(1), Err("bad"), Ok(3)]
  let successes = results.filter(it is Ok)
  println(string(successes.length))   // 2
}
```

## Test 7: In while loops

```forge
fn main() {
  mut attempts = 0
  mut result: Result<int, string> = Err("retry")

  while result is Err {
    attempts = attempts + 1
    if attempts >= 3 {
      result = Ok(42)
    }
  }

  println(string(attempts))    // 3
}
```

## Test 8: With binding (is + let pattern)

```forge
fn main() {
  let result: Result<int, string> = Ok(42)

  if result is Ok(value) {
    println(string(value))     // 42
  }

  let maybe: string? = "hello"

  if maybe is string(s) {
    println(s.upper())         // HELLO
  }
}
```

## Test 9: Chained with && and ||

```forge
fn main() {
  let x: int? = 5
  let y: int? = null

  println(string(x is not null && x! > 0))     // true
  println(string(y is not null && y! > 0))      // false
  println(string(x is null || y is null))       // true
}
```

## Test 10: Struct type check

```forge
type Dog = { name: string, breed: string }
type Cat = { name: string, indoor: bool }
type Animal = Dog | Cat

fn describe(a: Animal) -> string {
  if a is Dog { "dog" } else { "cat" }
}

fn main() {
  let d: Animal = Dog { name: "Rex", breed: "Lab" }
  let c: Animal = Cat { name: "Mimi", indoor: true }

  println(describe(d))     // dog
  println(describe(c))     // cat
}
```

---

## Implementation

### Parser

`is` is an infix operator at a new precedence level (between comparison and logical AND):

```rust
// features/is_keyword/mod.rs

pub fn register_parser(p: &mut ParserRegistry) {
    p.infix("is", Precedence::PatternCheck, parse_is);
    p.infix_pair("is", "not", Precedence::PatternCheck, parse_is_not);
}

fn parse_is(parser: &mut Parser, left: Expr) -> Result<Expr, Diagnostic> {
    let pattern = parser.parse_pattern()?;
    Ok(Expr::Is { value: Box::new(left), pattern, negated: false })
}

fn parse_is_not(parser: &mut Parser, left: Expr) -> Result<Expr, Diagnostic> {
    let pattern = parser.parse_pattern()?;
    Ok(Expr::Is { value: Box::new(left), pattern, negated: true })
}
```

### AST

```rust
// One new AST node
enum Expr {
    // ...existing...
    Is {
        value: Box<Expr>,
        pattern: Pattern,    // reuses existing pattern matching infrastructure
        negated: bool,       // `is not`
    },
}
```

### Type Checker

```rust
pub fn register_checker(c: &mut CheckerRegistry) {
    c.register(AstNode::Is, check_is);
}

fn check_is(checker: &mut Checker, expr: &IsExpr) -> Result<Type, Diagnostic> {
    let value_type = checker.check(&expr.value)?;
    checker.verify_pattern_compatible(&value_type, &expr.pattern)?;
    Ok(Type::Bool)
}
```

### Codegen

Desugars to a match expression:

```rust
pub fn register_codegen(g: &mut CodegenRegistry) {
    g.register(AstNode::Is, emit_is);
}

fn emit_is(ctx: &mut CodegenCtx, expr: &IsExpr) -> Result<LLVMValue, Diagnostic> {
    // Generate: match value { pattern -> true, _ -> false }
    // If negated: match value { pattern -> false, _ -> true }
    let match_expr = desugar_to_match(expr);
    ctx.emit_match(&match_expr)
}
```

### Feature Registration

```rust
#[forge_feature(
    name = "Is Keyword",
    status = "draft",
    depends = ["pattern_matching", "types_core"],
    enables = [],
    tokens = [Is, Not],
    ast_nodes = [Is],
    description = "Inline pattern check: value is Pattern → bool",
)]
pub mod is_keyword;
```

---

## Precedence

```
lowest
  ||
  &&
  is / is not        ← new level
  == != < > <= >=
  + -
  * / %
  unary ! -
  . ?. () []
highest
```

`is` sits between logical operators and comparison. This makes `x is Ok && y is Err` parse as `(x is Ok) && (y is Err)` which is what you expect.
