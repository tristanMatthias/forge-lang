# Forge Compiler — Phase 1 Validation & Phase 2 Spec

---

## Part 1: Phase 1 Validation Checklist

Before moving to Phase 2, verify these things actually work end-to-end. Run each test program and confirm the output matches. Then run the edge cases — these are where compilers typically break.

### 1.1 Run All 12 Test Programs

Run each of the Phase 1 test programs (`hello.fg` through `pipes.fg`) and confirm they produce the expected output. If you skipped any, note which ones — we may need them as prereqs for Phase 2.

```bash
# For each test program:
forge run tests/programs/hello.fg
forge run tests/programs/arithmetic.fg
forge run tests/programs/immutability.fg
forge run tests/programs/functions.fg
forge run tests/programs/strings.fg
forge run tests/programs/control_flow.fg
forge run tests/programs/nullability.fg
forge run tests/programs/structs.fg
forge run tests/programs/enums.fg
forge run tests/programs/error_handling.fg
forge run tests/programs/destructuring.fg
forge run tests/programs/pipes.fg
```

### 1.2 Edge Cases to Verify

These are the subtle things that often break. Create small test files for each:

**Immutability enforcement:**
```forge
fn main() {
  let x = 42
  x = 43  // Should produce ERROR E0013: cannot assign to immutable binding
}
```

**Type mismatch detection:**
```forge
fn main() {
  let x: int = "hello"  // Should produce ERROR E0012: type mismatch
}
```

**Null safety enforcement:**
```forge
fn main() {
  let name: string? = null
  println(name.upper())  // Should produce ERROR E0024: possible null access
}
```

**Exhaustive match check:**
```forge
enum Color { red, green, blue }

fn main() {
  let c = Color.red
  let label = match c {
    .red -> "red"
    .green -> "green"
    // Missing .blue — should produce ERROR E0017: non-exhaustive match
  }
}
```

**Error propagation outside Result function:**
```forge
fn main() {
  let x = some_result_fn()?  // Should produce ERROR E0023: can't use ? here
}
```

**JSON error output:**
```bash
forge build --error-format=json tests/programs/bad_type.fg
# Should produce valid parseable JSON with error codes, spans, and suggestions
```

**LLVM IR output:**
```bash
forge build --emit-ir tests/programs/hello.fg
# Should produce readable LLVM IR
```

### 1.3 Quick Stress Tests

```forge
// Nested expressions
fn main() {
  let x = if true { if false { 1 } else { 2 } } else { 3 }
  println(string(x))  // 2
}
```

```forge
// Deeply chained pipes
fn double(x: int) -> int { x * 2 }
fn add_one(x: int) -> int { x + 1 }

fn main() {
  let result = 1 |> double |> double |> double |> add_one
  println(string(result))  // 9
}
```

```forge
// Closure capturing outer variables
fn main() {
  let multiplier = 10
  let scale = (x: int) -> x * multiplier
  println(string(scale(5)))  // 50
}
```

```forge
// Match with multiple guards
fn classify(n: int) -> string {
  match n {
    x if x < 0 -> "negative"
    0 -> "zero"
    x if x < 10 -> "small"
    x if x < 100 -> "medium"
    _ -> "large"
  }
}

fn main() {
  println(classify(-5))    // negative
  println(classify(0))     // zero
  println(classify(7))     // small
  println(classify(42))    // medium
  println(classify(999))   // large
}
```

```forge
// Error handling chain
fn step1() -> Result<int, string> { Ok(10) }
fn step2(x: int) -> Result<int, string> {
  if x > 5 { Ok(x * 2) } else { Err("too small") }
}
fn step3(x: int) -> Result<string, string> { Ok(`result: ${x}`) }

fn pipeline() -> Result<string, string> {
  let a = step1()?
  let b = step2(a)?
  let c = step3(b)?
  Ok(c)
}

fn main() {
  let result = pipeline() catch (e) { `error: ${e}` }
  println(result)  // result: 20
}
```

### 1.4 What to Note for Phase 2

As you validate, note:
- Which features feel incomplete or buggy
- What error messages are confusing or unhelpful
- Any features from Phase 1 that were partially implemented
- Compile times for the test programs
- Binary sizes for the test programs

---

## Part 2: Phase 2 Implementation Spec

### Goal

Phase 2 adds the **module system**, **trait system**, **multi-file compilation**, **generics**, and the **project system** (forge.toml). At the end of Phase 2, Forge is a real multi-file language with a proper type system — ready for packages in Phase 3.

### Success Criteria

A multi-file project with traits, generics, the `use` keyword, and `forge.toml` compiles to a single binary. All test programs at the end of this document compile and run correctly.

---

### 2.1 Module System

#### 2.1.1 File Discovery

The compiler scans the `src/` directory (or the directory specified in `forge.toml`). Each `.fg` file is a module. Directory names are namespaces.

```
src/
  main.fg           →  root module (entry point)
  math.fg           →  module "math"
  utils/
    helpers.fg      →  module "utils.helpers"
    format.fg       →  module "utils.format"
  models/
    user.fg         →  module "models.user"
```

The compiler builds a module map at startup by walking the source directory. No explicit module declarations needed — file location IS the module path.

#### 2.1.2 The `use` Statement

```forge
// Import specific items
use math.{add, subtract}
use models.user.User
use utils.helpers.{format_date, format_currency as fmt_money}

// Import everything from a namespace
use utils.helpers

// Package imports (parsed but not resolved until Phase 3)
use @std.http.{server, route}
```

Implementation:

1. Parse `use` statements into `UseDecl` AST nodes (already defined in Phase 1 AST)
2. After parsing all files, build a global symbol table mapping fully-qualified names to their definitions
3. Resolve each `use` statement against the global symbol table
4. Report errors for unresolved imports, circular imports, and ambiguous names

#### 2.1.3 The `export` Keyword

Only exported items are visible to other modules:

```forge
// models/user.fg

export type User = {
  name: string,
  email: string,
  age: int,
}

export fn create_user(name: string, email: string) -> User {
  { name: name, email: email, age: 0 }
}

// Private — not importable
fn validate_email(email: string) -> bool {
  email.contains("@")
}
```

If a module tries to `use` a non-exported item, produce:

```
error[E0030]: `validate_email` is private in module `models.user`
  --> src/main.fg:2:5
   |
 2 | use models.user.validate_email
   |     ^^^^^^^^^^^^^^^^^^^^^^^^^^ private item
   |
   = help: mark it with `export` in models/user.fg to make it public
```

#### 2.1.4 Compilation Pipeline (Multi-File)

```
1. Walk src/ directory, discover all .fg files
2. Parse each file independently → per-file ASTs
3. Build global symbol table from all exports
4. Resolve all `use` statements against global symbol table
5. Type-check each file (with resolved cross-module references)
6. Codegen each file to an LLVM module
7. Link all LLVM modules together into one
8. Optimize + emit single object file
9. Link with runtime → single binary
```

The key change from Phase 1: steps 3-4 are new. The type checker now needs access to types and function signatures from other modules.

---

### 2.2 Trait System

#### 2.2.1 Trait Declaration

```forge
export trait Display {
  fn display(self) -> string
}

export trait Eq {
  fn eq(self, other: Self) -> bool

  // Default implementation
  fn neq(self, other: Self) -> bool {
    !self.eq(other)
  }
}

export trait Ord: Eq {             // trait inheritance: Ord requires Eq
  fn cmp(self, other: Self) -> int // -1, 0, 1
}

export trait Clone {
  fn clone(self) -> Self
}

export trait Drop {
  fn drop(self)
}

export trait Default {
  fn default() -> Self
}
```

#### 2.2.2 Impl Blocks

```forge
type Point = { x: float, y: float }

impl Display for Point {
  fn display(self) -> string {
    `(${self.x}, ${self.y})`
  }
}

impl Eq for Point {
  fn eq(self, other: Point) -> bool {
    self.x == other.x && self.y == other.y
  }
  // neq comes from the default
}

impl Clone for Point {
  fn clone(self) -> Point {
    { x: self.x, y: self.y }
  }
}
```

#### 2.2.3 Trait Bounds

```forge
fn print_all<T: Display>(items: List<T>) {
  for item in items {
    println(item.display())
  }
}

fn find<T: Eq>(items: List<T>, target: T) -> int? {
  for (i, item) in items.enumerate() {
    if item.eq(target) {
      return i
    }
  }
  null
}

// Multiple bounds
fn sort_and_print<T: Ord & Display>(items: List<T>) {
  let sorted = items.sorted(a, b -> a.cmp(b))
  print_all(sorted)
}
```

#### 2.2.4 Implementation Notes

**Trait resolution** is the core algorithm. When the type checker sees `item.display()`, it needs to:

1. Look up the type of `item` (e.g., `Point`)
2. Search for an `impl Display for Point` block
3. If found, resolve the call to the specific implementation
4. If not found, produce an error

**Static dispatch** (monomorphization) for Phase 2. When `print_all<Point>(my_points)` is called, the compiler generates a specialized version of `print_all` where `T` is replaced with `Point` and `item.display()` is a direct call to `Point`'s display implementation. No vtables, no dynamic dispatch in Phase 2.

**Method syntax.** When `impl Display for Point` is defined, calling `my_point.display()` should work via method resolution — the compiler checks if the type has the method directly, then checks all impl blocks.

**Self type.** In trait methods, `self` refers to the implementing type. `Self` (capital) refers to the implementing type in type position (e.g., return types).

#### 2.2.5 Operator Overloading via Traits

Define the operator traits in a built-in prelude:

```forge
// Built-in, always available
trait Add<Rhs = Self> {
  type Output
  fn add(self, rhs: Rhs) -> Self.Output
}

trait Sub<Rhs = Self> {
  type Output
  fn sub(self, rhs: Rhs) -> Self.Output
}

trait Mul<Rhs = Self> {
  type Output
  fn mul(self, rhs: Rhs) -> Self.Output
}

trait Div<Rhs = Self> {
  type Output
  fn div(self, rhs: Rhs) -> Self.Output
}

trait Neg {
  type Output
  fn neg(self) -> Self.Output
}

trait Index<Idx> {
  type Output
  fn index(self, idx: Idx) -> Self.Output
}
```

When the compiler sees `a + b`, it desugars to `a.add(b)` and resolves via trait lookup. The built-in numeric types (`int`, `float`) have these traits pre-implemented.

---

### 2.3 User-Defined Generics

Phase 1 supports generics only for built-in types (List<T>, Map<K,V>). Phase 2 allows user-defined generic types and functions.

#### 2.3.1 Generic Functions

```forge
fn first<T>(list: List<T>) -> T? {
  if list.length > 0 { list[0] } else { null }
}

fn map_pair<A, B, R>(pair: (A, B), f: (A) -> R, g: (B) -> R) -> (R, R) {
  (f(pair.0), g(pair.1))
}

fn identity<T>(x: T) -> T { x }
```

#### 2.3.2 Generic Type Aliases

```forge
type Pair<A, B> = { first: A, second: B }
type Result<T, E> = Ok(T) | Err(E)      // already built-in, but now user-definable
type Callback<T> = (T) -> void
```

#### 2.3.3 Monomorphization

Generic functions are compiled via monomorphization — the compiler generates a specialized copy for each concrete type used:

```forge
first<int>([1, 2, 3])       // generates first_int
first<string>(["a", "b"])   // generates first_string
```

This means no runtime overhead for generics — they compile to the same code as if you'd written the specific version by hand.

Implementation:
1. During type checking, record each concrete instantiation of a generic function
2. During codegen, generate a specialized LLVM function for each instantiation
3. Name-mangle the specialization (e.g., `first__int`, `first__string`)

---

### 2.4 The Project System (forge.toml)

#### 2.4.1 Minimal forge.toml for Phase 2

```toml
[project]
name = "my-project"
version = "0.1.0"
entry = "src/main.fg"

[build]
opt_level = 2
```

When `forge build` is run in a directory with `forge.toml`, it:
1. Reads the config
2. Discovers all `.fg` files under the entry point's directory
3. Compiles them as a multi-file project
4. Outputs the binary to `./build/<project-name>`

When `forge build <file.fg>` is run (no forge.toml), it compiles a single file as in Phase 1.

#### 2.4.2 forge.toml Parsing

Use the `toml` crate to parse. Only support the `[project]` and `[build]` sections in Phase 2. Package and database sections are parsed but ignored until Phase 3.

```toml
# Full Phase 2 support:
[project]
name = "my-app"
version = "0.1.0"
description = "Optional description"
entry = "src/main.fg"              # default: "src/main.fg"

[build]
opt_level = 2                      # 0, 1, 2, 3. Default: 2
default_target = "native"          # auto-detect current platform

# Parsed but not functional until Phase 3:
[packages]
[database]
[dev]
```

#### 2.4.3 New Cargo Dependency

```toml
# Add to Cargo.toml
toml = "0.8"
serde = { version = "1", features = ["derive"] }
walkdir = "2"         # for directory traversal
```

---

### 2.5 Built-In Prelude

Phase 2 introduces a prelude — a set of types and traits that are available in every module without importing:

```forge
// Automatically available everywhere:

// Types
type Result<T, E> = Ok(T) | Err(E)

// Traits
trait Display { fn display(self) -> string }
trait Eq { fn eq(self, other: Self) -> bool }
trait Ord: Eq { fn cmp(self, other: Self) -> int }
trait Clone { fn clone(self) -> Self }
trait Drop { fn drop(self) }
trait Default { fn default() -> Self }
trait Add<Rhs = Self> { type Output; fn add(self, rhs: Rhs) -> Self.Output }
trait Sub<Rhs = Self> { type Output; fn sub(self, rhs: Rhs) -> Self.Output }
trait Mul<Rhs = Self> { type Output; fn mul(self, rhs: Rhs) -> Self.Output }
trait Div<Rhs = Self> { type Output; fn div(self, rhs: Rhs) -> Self.Output }
trait Neg { type Output; fn neg(self) -> Self.Output }
trait Index<Idx> { type Output; fn index(self, idx: Idx) -> Self.Output }

// Functions
fn println(value: impl Display)
fn print(value: impl Display)
fn string<T: Display>(value: T) -> string
fn int(s: string) -> Result<int, string>
fn float(s: string) -> Result<float, string>
fn assert(condition: bool, message: string = "assertion failed")
fn panic(message: string) -> never
fn now() -> int                   // Unix timestamp (placeholder until timestamp type)
fn uuid() -> string               // UUID v4 as string (placeholder)
```

The prelude is implemented as a synthetic module that's always imported. The compiler injects `use __prelude` at the top of every file before processing.

---

### 2.6 List, Map, Set Standard Methods

Phase 2 fleshes out the collection methods that were stubbed in Phase 1. These are implemented as built-in trait implementations.

#### List<T>

```forge
impl<T> for List<T> {
  // Already in Phase 1:
  fn length(self) -> int
  fn get(self, index: int) -> T?
  fn push(self, item: T)              // requires mut
  fn pop(self) -> T?                  // requires mut
  fn filter(self, f: (T) -> bool) -> List<T>
  fn map<R>(self, f: (T) -> R) -> List<R>

  // New in Phase 2:
  fn first(self) -> T?
  fn last(self) -> T?
  fn contains(self, item: T) -> bool where T: Eq
  fn find(self, f: (T) -> bool) -> T?
  fn any(self, f: (T) -> bool) -> bool
  fn all(self, f: (T) -> bool) -> bool
  fn reduce<R>(self, init: R, f: (R, T) -> R) -> R
  fn each(self, f: (T) -> void)
  fn enumerate(self) -> List<(int, T)>
  fn zip<U>(self, other: List<U>) -> List<(T, U)>
  fn flatten(self) -> List<T> where T: List     // approximate
  fn sorted(self, f: (T, T) -> int) -> List<T>
  fn reversed(self) -> List<T>
  fn slice(self, start: int, end: int?) -> List<T>
  fn join(self, separator: string) -> string where T: Display
  fn is_empty(self) -> bool
  fn sum(self) -> T where T: Add
  fn to_list(self) -> List<T>         // identity, for iterator chains
}
```

#### Map<K, V>

```forge
impl<K: Eq, V> for Map<K, V> {
  fn length(self) -> int
  fn get(self, key: K) -> V?
  fn set(self, key: K, value: V)       // requires mut
  fn has(self, key: K) -> bool
  fn delete(self, key: K)              // requires mut
  fn keys(self) -> List<K>
  fn values(self) -> List<V>
  fn entries(self) -> List<(K, V)>
  fn map<R>(self, f: (K, V) -> R) -> Map<K, R>
  fn filter(self, f: (K, V) -> bool) -> Map<K, V>
  fn merge(self, other: Map<K, V>) -> Map<K, V>
}
```

These methods can be implemented in the C runtime (for Phase 2) or eventually in Forge itself (post-Phase 3 with self-hosting capabilities).

---

### 2.7 Drop Trait and Scope-Based Cleanup

Phase 2 makes the `Drop` trait functional. When a value with a `Drop` implementation goes out of scope, the compiler inserts a call to its `drop` method.

```forge
type FileHandle = { path: string, fd: int }

impl Drop for FileHandle {
  fn drop(self) {
    close_fd(self.fd)
  }
}

fn process() {
  let file = open("data.txt")
  // ... do work with file ...
}  // file.drop() called automatically here
```

Implementation:
1. At scope exit, for each local variable in reverse declaration order:
   a. Check if the variable's type has an `impl Drop`
   b. If so, insert a call to the drop method before the scope's terminator
2. This interacts with `defer`/`errdefer` — drop calls happen AFTER defer blocks

---

### 2.8 Improved Reference Counting

Phase 2 improves the reference counting from Phase 1:

1. **Elide unnecessary retain/release pairs.** If a value is created and consumed in the same scope without aliasing, skip the refcount entirely. This is a simple liveness analysis pass before codegen.

2. **Move semantics for last use.** If a variable is used for the last time (no further references), transfer ownership instead of incrementing the refcount. This is the common case for pipe chains and function call chains.

3. **Still no cycle detection.** Defer to Phase 3. Note in documentation that circular references between structs can leak memory.

---

### 2.9 Test Programs

### 2.9.1 multi_module.fg — Multi-file project

```
test_project/
├── forge.toml
└── src/
    ├── main.fg
    └── math/
        └── math.fg
```

```toml
# forge.toml
[project]
name = "test-project"
version = "0.1.0"
entry = "src/main.fg"
```

```forge
// src/math/math.fg
export fn add(a: int, b: int) -> int { a + b }
export fn multiply(a: int, b: int) -> int { a * b }

fn internal_helper() -> int { 42 }  // private
```

```forge
// src/main.fg
use math.{add, multiply}

fn main() {
  println(string(add(3, 4)))         // 7
  println(string(multiply(5, 6)))    // 30
}
```

### 2.9.2 traits.fg — Trait system

```forge
trait Describable {
  fn describe(self) -> string

  fn describe_loud(self) -> string {
    self.describe().upper()
  }
}

type Circle = { radius: float }
type Square = { side: float }

impl Describable for Circle {
  fn describe(self) -> string {
    `circle with radius ${self.radius}`
  }
}

impl Describable for Square {
  fn describe(self) -> string {
    `square with side ${self.side}`
  }
}

fn print_description<T: Describable>(item: T) {
  println(item.describe())
  println(item.describe_loud())
}

fn main() {
  let c = Circle { radius: 5.0 }
  let s = Square { side: 3.0 }

  print_description(c)
  // circle with radius 5
  // CIRCLE WITH RADIUS 5

  print_description(s)
  // square with side 3
  // SQUARE WITH SIDE 3
}
```

### 2.9.3 generics.fg — User-defined generics

```forge
fn first<T>(list: List<T>) -> T? {
  if list.length > 0 { list[0] } else { null }
}

fn pair<A, B>(a: A, b: B) -> (A, B) {
  (a, b)
}

fn repeat<T: Clone>(item: T, n: int) -> List<T> {
  mut result: List<T> = []
  mut i = 0
  while i < n {
    result.push(item.clone())
    i = i + 1
  }
  result
}

fn main() {
  let nums = [10, 20, 30]
  let f = first(nums)
  println(string(f ?? 0))           // 10

  let strs = ["hello", "world"]
  let s = first(strs)
  println(s ?? "empty")             // hello

  let p = pair("age", 30)
  println(p.0)                      // age (tuple field access)
  println(string(p.1))              // 30

  let fives = repeat(5, 3)
  println(string(fives.length))     // 3
  println(string(fives[0]))         // 5
}
```

### 2.9.4 operators.fg — Operator overloading

```forge
type Vec2 = { x: float, y: float }

impl Add for Vec2 {
  type Output = Vec2
  fn add(self, rhs: Vec2) -> Vec2 {
    { x: self.x + rhs.x, y: self.y + rhs.y }
  }
}

impl Sub for Vec2 {
  type Output = Vec2
  fn sub(self, rhs: Vec2) -> Vec2 {
    { x: self.x - rhs.x, y: self.y - rhs.y }
  }
}

impl Display for Vec2 {
  fn display(self) -> string {
    `(${self.x}, ${self.y})`
  }
}

impl Eq for Vec2 {
  fn eq(self, other: Vec2) -> bool {
    self.x == other.x && self.y == other.y
  }
}

fn main() {
  let a = Vec2 { x: 1.0, y: 2.0 }
  let b = Vec2 { x: 3.0, y: 4.0 }

  let c = a + b
  println(c.display())              // (4, 6)

  let d = b - a
  println(d.display())              // (2, 2)

  println(string(a == a))           // true
  println(string(a == b))           // false
}
```

### 2.9.5 collections.fg — Collection methods

```forge
fn main() {
  let nums = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

  // filter + map + sum via it
  let even_doubled_sum = nums
    .filter(it % 2 == 0)
    .map(it * 2)
    .sum()
  println(string(even_doubled_sum))  // 60 (2+4+6+8+10)*2

  // find
  let first_big = nums.find(it > 7)
  println(string(first_big ?? 0))    // 8

  // any / all
  println(string(nums.any(it > 9)))  // true
  println(string(nums.all(it > 0)))  // true
  println(string(nums.all(it > 5)))  // false

  // enumerate
  let names = ["alice", "bob", "charlie"]
  for (i, name) in names.enumerate() {
    println(`${i}: ${name}`)
  }
  // 0: alice
  // 1: bob
  // 2: charlie

  // join
  println(names.join(", "))          // alice, bob, charlie

  // reduce
  let product = [2, 3, 4].reduce(1, (acc, n) -> acc * n)
  println(string(product))           // 24

  // Map operations
  let scores = { "alice": 95, "bob": 87, "charlie": 92 }
  println(string(scores.has("alice")))  // true
  println(string(scores.get("bob") ?? 0))  // 87
  println(scores.keys().join(", "))     // alice, bob, charlie
}
```

### 2.9.6 visibility.fg — Export/private enforcement

```
test_visibility/
├── forge.toml
└── src/
    ├── main.fg
    └── secret/
        └── secret.fg
```

```forge
// src/secret/secret.fg
export fn public_fn() -> string { "public" }
fn private_fn() -> string { "private" }
export let PUBLIC_VALUE = 42
let PRIVATE_VALUE = 99
```

```forge
// src/main.fg
use secret.{public_fn, PUBLIC_VALUE}

fn main() {
  println(public_fn())               // public
  println(string(PUBLIC_VALUE))       // 42
}
```

And verify these produce errors:

```forge
// Should fail: private item
use secret.private_fn           // ERROR E0030: private in module
use secret.PRIVATE_VALUE        // ERROR E0030: private in module
```

### 2.9.7 drop.fg — Drop trait

```forge
mut drop_count = 0

type Resource = { name: string }

impl Drop for Resource {
  fn drop(self) {
    drop_count = drop_count + 1
    println(`dropping ${self.name}`)
  }
}

fn main() {
  {
    let a = Resource { name: "alpha" }
    let b = Resource { name: "beta" }
    println("inside scope")
  }
  // Expected output:
  // inside scope
  // dropping beta
  // dropping alpha
  println(`dropped ${drop_count} resources`)   // dropped 2 resources
}
```

---

### 2.10 Implementation Order

#### Step 1: forge.toml + Multi-File Discovery (Week 1)
- Parse forge.toml using `toml` + `serde`
- Walk source directory with `walkdir`
- Build module map (file path → module path)
- Modify driver to parse all files, not just one
- **Test: project with forge.toml compiles (even if single-file)**

#### Step 2: Symbol Table + Use Resolution (Week 1-2)
- After parsing all files, build global symbol table
- Map each `export`-ed declaration to its fully-qualified name
- Resolve `use` statements against the symbol table
- Handle rename (`as`) and wildcard imports
- Error on unresolved imports, private access, circular imports
- **Test: `multi_module.fg` compiles and runs**

#### Step 3: Cross-Module Type Checking (Week 2-3)
- Extend type checker to look up types from other modules
- Function signatures from imported modules are available for type checking
- Struct types from imported modules work in type annotations
- **Test: `visibility.fg` compiles, private access errors work**

#### Step 4: Prelude (Week 3)
- Create synthetic prelude module with built-in types and traits
- Auto-inject prelude into every module
- Implement `Display` for primitive types
- Wire `println` to use `Display` trait
- **Test: `println` works without any imports**

#### Step 5: Trait Declarations + Impl Blocks (Week 3-4)
- Parse trait declarations (method signatures, default implementations, trait bounds)
- Parse impl blocks
- Build trait registry mapping (Type, Trait) → impl block
- Method resolution: when `x.method()` is called, search impl blocks
- **Test: `traits.fg` compiles and runs**

#### Step 6: Generic Functions + Monomorphization (Week 4-5)
- Parse type parameters on functions (`fn first<T>`)
- During type checking, record each concrete instantiation
- During codegen, generate specialized function copies
- Name-mangle specializations
- **Test: `generics.fg` compiles and runs**

#### Step 7: Operator Traits (Week 5-6)
- Define Add, Sub, Mul, Div, Eq, Neg, Index traits in prelude
- Implement them for built-in types (int, float, string concat)
- Desugar `a + b` → `a.add(b)` in the type checker
- Desugar `a == b` → `a.eq(b)`
- Desugar `a[i]` → `a.index(i)`
- **Test: `operators.fg` compiles and runs**

#### Step 8: Collection Methods (Week 6-7)
- Implement List/Map/Set methods from Section 2.6
- These can be implemented in the C runtime with generated bindings
- Wire `it` closures through the collection methods
- **Test: `collections.fg` compiles and runs**

#### Step 9: Drop Trait + Improved Refcounting (Week 7-8)
- Implement Drop trait scope insertion
- At scope exit, insert drop calls for types with Drop impls
- Implement basic refcount elision (skip retain/release for non-aliased values)
- Move semantics for last-use variables
- **Test: `drop.fg` compiles and runs with correct drop order**

#### Step 10: Polish + Error Messages (Week 8-9)
- Add new error codes for Phase 2 features (see below)
- Improve error messages for trait resolution failures
- Improve error messages for generic type inference failures
- Run all Phase 1 + Phase 2 tests
- Profile compile times, optimize hot paths if needed
- **Test: all test programs produce correct results**

---

### 2.11 New Error Codes (Phase 2)

| Code | Description |
|---|---|
| E0030 | Private item access across module boundary |
| E0031 | Unresolved import (item not found in module) |
| E0032 | Circular import detected |
| E0033 | Ambiguous import (same name from multiple modules) |
| E0034 | Duplicate export name |
| E0040 | Trait not implemented for type |
| E0041 | Method not found on type |
| E0042 | Missing required trait method in impl block |
| E0043 | Trait method signature mismatch |
| E0044 | Trait bound not satisfied (`T: Display` but T doesn't impl Display) |
| E0045 | Duplicate impl (two impl blocks for same type+trait) |
| E0046 | Invalid `self` parameter in trait method |
| E0050 | Cannot infer generic type parameter |
| E0051 | Generic type parameter count mismatch |
| E0052 | Type parameter constraint not met |
| E0060 | Invalid forge.toml configuration |
| E0061 | Entry file not found |
| E0062 | Duplicate module name |

---

### 2.12 What Phase 2 Does NOT Include

Explicitly deferred to Phase 3+:

- Package system (`@std/http`, etc.)
- Model/service declarations (these are package keywords)
- Dynamic dispatch / trait objects (`dyn Trait`)
- Associated types on traits (except `type Output` on operator traits)
- Trait inheritance beyond single level
- Where clauses on functions
- Const generics
- Impl blocks for external types (orphan rule)
- `spawn`/`parallel` runtime behavior
- Events (`emit`/`on`)
- Annotations (`@`)
- The REPL
- Hot reload
- Multi-target cross-compilation
- `forge context` and `forge mcp`

---

### 2.13 Definition of Done

Phase 2 is complete when:

1. All Phase 1 test programs still compile and run correctly (no regressions)
2. All 7 Phase 2 test programs compile and produce correct output
3. Multi-file projects with `forge.toml` work
4. `use` / `export` visibility rules are enforced
5. Traits with default methods work
6. Generic functions monomorphize correctly
7. Operator overloading via traits works (`+`, `-`, `*`, `/`, `==`)
8. Collection methods (filter, map, reduce, find, any, all, join, etc.) work with `it`
9. Drop trait inserts cleanup calls at scope exit
10. New error codes produce helpful messages (human + JSON)
11. `cargo test` passes all unit and integration tests
12. Compiling a 5-file project takes < 3 seconds
