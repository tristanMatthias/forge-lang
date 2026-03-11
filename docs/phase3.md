# Forge Compiler — Phase 2 Validation & Phase 3 Spec

---

## Part 1: Phase 2 Validation

Phase 2 added modules, traits, generics, forge.toml, operator overloading, collection methods, and Drop. These tests are designed to break things at the seams — where features interact with each other.

### 1.1 Run All Phase 2 Test Programs

```bash
# Phase 1 regression (these must still work):
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

# Phase 2 new tests:
cd test_project && forge build && ./build/test-project    # multi_module
forge run tests/programs/traits.fg
forge run tests/programs/generics.fg
forge run tests/programs/operators.fg
forge run tests/programs/collections.fg
cd test_visibility && forge build                          # visibility
forge run tests/programs/drop.fg
```

### 1.2 Cross-Feature Interaction Tests

These test features from Phase 1 and Phase 2 interacting. This is where compilers break.

**Traits + Nullability:**
```forge
trait Describable {
  fn describe(self) -> string
}

type User = { name: string, age: int }

impl Describable for User {
  fn describe(self) -> string {
    `${self.name} (${self.age})`
  }
}

fn maybe_describe<T: Describable>(item: T?) -> string {
  item?.describe() ?? "nothing"
}

fn main() {
  let user: User? = User { name: "alice", age: 30 }
  println(maybe_describe(user))          // alice (30)

  let nobody: User? = null
  println(maybe_describe(nobody))        // nothing
}
```

**Generics + Error Handling:**
```forge
fn try_first<T>(list: List<T>) -> Result<T, string> {
  if list.length > 0 { Ok(list[0]) } else { Err("empty list") }
}

fn process() -> Result<string, string> {
  let nums = [10, 20, 30]
  let first = try_first(nums)?
  let strs = ["hello"]
  let word = try_first(strs)?
  Ok(`${word} ${first}`)
}

fn main() {
  let result = process() catch (e) { `error: ${e}` }
  println(result)                        // hello 10

  let empty_result = try_first<int>([]) catch (e) { `error: ${e}` }
  println(empty_result)                  // error: empty list
}
```

**Traits + Operator Overloading + Pipes:**
```forge
type Money = { cents: int }

impl Add for Money {
  type Output = Money
  fn add(self, rhs: Money) -> Money {
    Money { cents: self.cents + rhs.cents }
  }
}

impl Display for Money {
  fn display(self) -> string {
    let dollars = self.cents / 100
    let remainder = self.cents % 100
    `$${dollars}.${remainder}`
  }
}

impl Eq for Money {
  fn eq(self, other: Money) -> bool {
    self.cents == other.cents
  }
}

fn main() {
  let prices = [
    Money { cents: 999 },
    Money { cents: 1499 },
    Money { cents: 250 },
  ]

  let total = prices.reduce(Money { cents: 0 }, (acc, p) -> acc + p)
  println(total.display())               // $27.48

  let expensive = prices.filter(it.cents > 500)
  println(string(expensive.length))      // 2
}
```

**Closures Capturing Cross-Module Values:**
```
test_closure_capture/
├── forge.toml
└── src/
    ├── main.fg
    └── config/
        └── config.fg
```

```forge
// src/config/config.fg
export let MULTIPLIER = 10
export fn make_scaler(factor: int) -> (int) -> int {
  (x) -> x * factor
}
```

```forge
// src/main.fg
use config.{MULTIPLIER, make_scaler}

fn main() {
  let values = [1, 2, 3, 4, 5]

  // Closure capturing imported constant
  let scaled = values.map(it * MULTIPLIER)
  println(scaled.map(string(it)).join(", "))   // 10, 20, 30, 40, 50

  // Closure returned from another module
  let triple = make_scaler(3)
  let tripled = values.map(triple(it))
  println(tripled.map(string(it)).join(", "))  // 3, 6, 9, 12, 15
}
```

**Generic Traits (trait with type parameter used in impl):**
```forge
trait Convertible<Target> {
  fn convert(self) -> Target
}

type Celsius = { degrees: float }
type Fahrenheit = { degrees: float }

impl Convertible<Fahrenheit> for Celsius {
  fn convert(self) -> Fahrenheit {
    Fahrenheit { degrees: self.degrees * 9.0 / 5.0 + 32.0 }
  }
}

impl Convertible<Celsius> for Fahrenheit {
  fn convert(self) -> Celsius {
    Celsius { degrees: (self.degrees - 32.0) * 5.0 / 9.0 }
  }
}

impl Display for Celsius {
  fn display(self) -> string { `${self.degrees}°C` }
}

impl Display for Fahrenheit {
  fn display(self) -> string { `${self.degrees}°F` }
}

fn main() {
  let boiling = Celsius { degrees: 100.0 }
  let f: Fahrenheit = boiling.convert()
  println(f.display())                   // 212°F

  let body = Fahrenheit { degrees: 98.6 }
  let c: Celsius = body.convert()
  println(c.display())                   // 37°C
}
```

**Drop + Error Handling (errdefer interaction):**
```forge
type TempFile = { path: string }

impl Drop for TempFile {
  fn drop(self) {
    println(`cleanup: ${self.path}`)
  }
}

fn risky_operation(fail: bool) -> Result<string, string> {
  let tmp = TempFile { path: "/tmp/work" }
  defer println("defer ran")

  if fail {
    return Err("operation failed")
  }
  Ok("success")
}
// Drop should run in both paths

fn main() {
  let r1 = risky_operation(false) catch (e) { e }
  println(r1)
  // Expected:
  // defer ran
  // cleanup: /tmp/work
  // success

  println("---")

  let r2 = risky_operation(true) catch (e) { e }
  println(r2)
  // Expected:
  // defer ran
  // cleanup: /tmp/work
  // operation failed
}
```

**Match + Generics + Traits:**
```forge
enum Option<T> {
  some(value: T)
  none
}

impl<T: Display> Display for Option<T> {
  fn display(self) -> string {
    match self {
      .some(v) -> `Some(${v.display()})`
      .none -> "None"
    }
  }
}

fn main() {
  let a = Option.some(value: 42)
  let b: Option<int> = Option.none

  println(a.display())                   // Some(42)
  println(b.display())                   // None
}
```

### 1.3 Error Message Quality Tests

Verify these produce clear, helpful errors:

```forge
// E0040: Trait not implemented
fn print_it<T: Display>(x: T) { println(x.display()) }
type Opaque = { data: int }
fn main() { print_it(Opaque { data: 1 }) }
// Expected: error[E0044]: trait bound not satisfied
//   `Opaque` does not implement `Display`
//   help: add `impl Display for Opaque { ... }`
```

```forge
// E0042: Missing method in impl
trait Foo {
  fn bar(self) -> int
  fn baz(self) -> string
}
type X = { val: int }
impl Foo for X {
  fn bar(self) -> int { self.val }
  // Missing baz!
}
// Expected: error[E0042]: missing method `baz` in impl of `Foo` for `X`
```

```forge
// E0050: Cannot infer generic
fn identity<T>(x: T) -> T { x }
fn main() {
  let x = identity(null)    // T = ???
}
// Expected: error[E0050]: cannot infer type parameter `T`
```

```forge
// E0031: Unresolved import
use nonexistent.module.Thing
// Expected: error[E0031]: unresolved import `nonexistent.module.Thing`
//   no module `nonexistent` found in project
```

### 1.4 Performance Check

```bash
# Create a 10-file project and measure compile time
time forge build
# Should be < 5 seconds

# Binary size for a simple project
ls -lh build/test-project
# Note the size — will be useful as a baseline
```

### 1.5 Note Before Phase 3

Phase 3 is fundamentally different from Phases 1-2. Phases 1-2 are "standard compiler construction." Phase 3 is "language extensibility architecture." The provider system is what makes Forge unique — and it's the hardest part to get right.

Key questions to confirm before starting:
- Does the trait system work well enough to define provider interfaces?
- Does the module system handle `@`-prefixed provider paths (even if it just stubs them)?
- Can the codegen link against external C libraries cleanly?

If any of these are shaky, fix them before Phase 3.

---

## Part 2: Phase 3 Implementation Spec

### Goal

Build the **provider system** and the first two standard providers: `@std/model` (data models with auto-persistence) and `@std/http` (HTTP server with routing). At the end of Phase 3, this program compiles and runs:

```forge
use @std.model.{model, service}
use @std.http.{server, route, mount}

model User {
  id: int @primary @auto_increment
  name: string
  email: string @unique
  active: bool @default(true)
}

service UserService for User {
  before create(user) {
    assert user.name.length > 0, "name required"
  }
}

server :8080 {
  mount UserService at /users

  route GET /health -> { status: "ok" }
}
```

```bash
forge build
./build/my-app
# => Server running on http://localhost:8080
# => GET /users → []
# => POST /users {"name":"alice","email":"alice@test.com"} → {id:1, name:"alice", ...}
# => GET /users → [{id:1, name:"alice", ...}]
# => GET /health → {"status":"ok"}
```

### Success Criteria

1. The provider system loads and resolves provider-registered keywords
2. `@std/model` provides `model` and `service` keywords with auto-persistence to SQLite
3. `@std/http` provides `server`, `route`, `mount`, and `middleware` keywords with a working HTTP server
4. A single binary is produced containing the Forge code, SQLite, and the HTTP server
5. All test programs at the end of this document compile and run

---

### 3.1 Provider System Architecture

This is the core of what makes Forge extensible. The architecture has three layers:

```
┌─────────────────────────────┐
│  Forge Source Code           │  Uses provider keywords: model, server, route
├─────────────────────────────┤
│  Provider Interface Layer    │  Defines what keywords exist and their syntax
│  (provider.toml + types.fg)  │  Parsed at compile time
├─────────────────────────────┤
│  Provider Implementation     │  Actual Rust code that handles the keywords
│  (compiled native library)   │  Linked into the final binary
└─────────────────────────────┘
```

#### 3.1.1 How Providers Work (The Big Picture)

1. Developer adds `"@std/http" = "0.1.0"` to `forge.toml`
2. On `forge build`, the compiler reads the provider's manifest (`provider.toml`)
3. The manifest declares keywords (`server`, `route`, etc.) and their syntax patterns
4. The Forge parser recognizes these keywords and produces provider-specific AST nodes
5. The type checker validates the provider blocks using type info from the provider
6. Codegen produces calls into the provider's native library (Rust compiled to a static lib)
7. The linker includes the provider's static library in the final binary

#### 3.1.2 Provider Package Format

Each provider is a directory (or downloaded package) with this structure:

```
std-http/
├── provider.toml          # Manifest: keywords, syntax, metadata
├── types.fg               # Forge type definitions the provider exposes
├── lib/
│   └── libforge_http.a    # Compiled static library (per platform)
└── include/
    └── forge_http.h       # C ABI header for the static library
```

For Phase 3, the `@std` providers are **bundled with the compiler** — they live in the compiler's install directory, not downloaded from a registry. Registry support comes in Phase 6.

#### 3.1.3 Provider Discovery

```
Provider resolution order:
1. Built-in std providers (bundled with compiler)
   → $FORGE_HOME/providers/std/
2. Local providers (in project)
   → ./providers/
3. Downloaded providers (future — Phase 6)
   → $FORGE_HOME/cache/providers/
```

---

### 3.2 Provider Manifest (provider.toml)

```toml
# providers/std-http/provider.toml

[provider]
name = "http"
namespace = "std"
version = "0.1.0"
description = "HTTP server, routing, and middleware"

# Keywords this provider registers
[[keywords]]
name = "server"
kind = "block"                    # introduces a { } block
context = "top_level"             # valid at top level of a file
pattern = "server :<port:int> <body:block>"

[[keywords]]
name = "route"
kind = "statement"
context = "server"                # only valid inside a server block
pattern = "route <method:HTTP_METHOD> <path:path> -> <handler:expr_or_block>"

[[keywords]]
name = "mount"
kind = "statement"
context = "server"
pattern = "mount <service:ident> at <path:path>"

[[keywords]]
name = "middleware"
kind = "statement"
context = "server"
pattern = "middleware [<handlers:expr_list>]"

# Native library to link
[native]
library = "forge_http"
link = "static"

# Dependencies this provider's native lib needs
[native.deps]
# These are Rust crate deps compiled into the provider's static lib
# Not resolved by Forge — the provider ships pre-compiled
```

```toml
# providers/std-model/provider.toml

[provider]
name = "model"
namespace = "std"
version = "0.1.0"
description = "Data models with auto-persistence"

[[keywords]]
name = "model"
kind = "block"
context = "top_level"
pattern = "model <name:ident> <body:model_block>"

[[keywords]]
name = "service"
kind = "block"
context = "top_level"
pattern = "service <name:ident> for <model:ident> <body:service_block>"

[native]
library = "forge_model"
link = "static"
```

---

### 3.3 Provider Keyword Parsing

The parser needs to be extended to recognize provider keywords dynamically. Here's the approach:

#### 3.3.1 Keyword Registry

Before parsing begins, the compiler reads all provider manifests and builds a keyword registry:

```rust
struct ProviderKeyword {
    name: String,              // "server"
    provider: String,          // "std.http"
    kind: KeywordKind,         // Block, Statement, Modifier
    context: KeywordContext,    // TopLevel, InsideBlock("server"), etc.
    pattern: String,           // the pattern string from provider.toml
}

struct KeywordRegistry {
    keywords: HashMap<String, ProviderKeyword>,
}
```

#### 3.3.2 Parser Extension

When the parser encounters an identifier that isn't a core keyword, it checks the keyword registry:

```rust
fn parse_statement(&mut self) -> Result<Statement, ParseError> {
    match self.current_token() {
        Token::Let => self.parse_let(),
        Token::Mut => self.parse_mut(),
        Token::Fn => self.parse_fn(),
        // ... core keywords ...

        Token::Ident(name) => {
            if let Some(provider_kw) = self.keyword_registry.get(name) {
                self.parse_provider_keyword(provider_kw)
            } else {
                self.parse_expr_statement()
            }
        }
    }
}
```

#### 3.3.3 Provider AST Nodes

Provider keywords parse into a generic `ProviderBlock` AST node:

```rust
pub struct ProviderBlock {
    pub provider: String,           // "std.http"
    pub keyword: String,            // "server"
    pub args: Vec<ProviderArg>,     // port, name, etc.
    pub children: Vec<ProviderChild>, // nested keywords (route, mount, etc.)
    pub span: Span,
}

pub enum ProviderArg {
    IntLiteral(i64),
    StringLiteral(String),
    Ident(String),
    Expr(Expr),
    Path(String),                   // URL paths like /users/:id
    ExprOrBlock(Expr),              // handler can be expr or block
}

pub enum ProviderChild {
    ProviderBlock(ProviderBlock),   // nested provider keyword
    Statement(Statement),           // regular Forge statements inside provider blocks
}
```

For the `model` keyword specifically, the parser needs to understand the model body syntax (field declarations with annotations). This can be parsed as a specialized variant:

```rust
pub struct ModelDecl {
    pub name: String,
    pub fields: Vec<ModelField>,
    pub exported: bool,
    pub span: Span,
}

pub struct ModelField {
    pub name: String,
    pub type_ann: TypeExpr,
    pub annotations: Vec<Annotation>,
    pub span: Span,
}

pub struct Annotation {
    pub name: String,               // "primary", "unique", "default"
    pub args: Vec<Expr>,            // default(true), validate(email)
    pub span: Span,
}

pub struct ServiceDecl {
    pub name: String,
    pub for_model: String,
    pub hooks: Vec<ServiceHook>,
    pub methods: Vec<Statement>,    // FnDecl items
    pub exported: bool,
    pub span: Span,
}

pub struct ServiceHook {
    pub timing: HookTiming,         // Before, After
    pub operation: String,          // "create", "update", "delete"
    pub param: String,              // parameter name bound in the hook
    pub body: Block,
    pub span: Span,
}

pub enum HookTiming { Before, After }
```

---

### 3.4 Provider Type Integration

Each provider ships a `types.fg` file that defines the Forge types it introduces. The compiler parses this and adds the types to the type system.

```forge
// providers/std-http/types.fg

export type Request = {
  method: string,
  path: string,
  params: Map<string, string>,
  query: Map<string, string>,
  headers: Map<string, string>,
  body: json,
}

export type Response = {
  status: int,
  headers: Map<string, string>,
  body: json,
}

export fn respond(status: int, body: json) -> Response
export fn redirect(url: string, status: int = 302) -> Response
```

```forge
// providers/std-model/types.fg

export type QueryOptions = {
  limit: int?,
  offset: int?,
  order_by: string?,
  order_dir: string?,
}
```

These types are automatically available when the provider is imported.

---

### 3.5 @std/model — Implementation

#### 3.5.1 What It Does

The `model` keyword declares a data structure that auto-persists to SQLite. For each model, the compiler generates:

1. A Forge struct type with the declared fields
2. CRUD functions: `create`, `get`, `get_by`, `list`, `update`, `delete`, `count`, `exists`
3. SQLite table creation (auto-migrate on first run)
4. JSON serialization/deserialization
5. A `service` wrapper with lifecycle hooks

#### 3.5.2 Native Library (Rust)

The `@std/model` provider is backed by a Rust static library that handles SQLite operations:

```rust
// providers/std-model/src/lib.rs
// This compiles to libforge_model.a

use rusqlite::{Connection, params};
use std::sync::Mutex;
use std::os::raw::c_char;
use std::ffi::{CStr, CString};

// Global database connection (lazy initialized)
static DB: Mutex<Option<Connection>> = Mutex::new(None);

#[no_mangle]
pub extern "C" fn forge_model_init(path: *const c_char) {
    let path = unsafe { CStr::from_ptr(path) }.to_str().unwrap();
    let conn = Connection::open(path).expect("Failed to open database");
    *DB.lock().unwrap() = Some(conn);
}

#[no_mangle]
pub extern "C" fn forge_model_exec(sql: *const c_char) -> i32 {
    let sql = unsafe { CStr::from_ptr(sql) }.to_str().unwrap();
    let db = DB.lock().unwrap();
    let conn = db.as_ref().expect("Database not initialized");
    match conn.execute(sql, []) {
        Ok(_) => 0,
        Err(e) => {
            eprintln!("SQL error: {}", e);
            -1
        }
    }
}

#[no_mangle]
pub extern "C" fn forge_model_query(
    sql: *const c_char,
    result_buf: *mut c_char,
    buf_len: i64,
) -> i64 {
    // Execute query, serialize results to JSON, write to result_buf
    // Return bytes written, or -1 on error
    let sql = unsafe { CStr::from_ptr(sql) }.to_str().unwrap();
    let db = DB.lock().unwrap();
    let conn = db.as_ref().expect("Database not initialized");

    let mut stmt = match conn.prepare(sql) {
        Ok(s) => s,
        Err(e) => {
            eprintln!("SQL prepare error: {}", e);
            return -1;
        }
    };

    let col_count = stmt.column_count();
    let col_names: Vec<String> = (0..col_count)
        .map(|i| stmt.column_name(i).unwrap().to_string())
        .collect();

    let mut rows = Vec::new();
    let mut row_iter = stmt.query([]).unwrap();

    while let Some(row) = row_iter.next().unwrap() {
        let mut obj = String::from("{");
        for (i, name) in col_names.iter().enumerate() {
            if i > 0 { obj.push(','); }
            let val: String = row.get::<_, String>(i).unwrap_or_default();
            obj.push_str(&format!("\"{}\":\"{}\"", name, val));
        }
        obj.push('}');
        rows.push(obj);
    }

    let json = format!("[{}]", rows.join(","));
    let bytes = json.as_bytes();
    let write_len = std::cmp::min(bytes.len() as i64, buf_len);

    unsafe {
        std::ptr::copy_nonoverlapping(bytes.as_ptr(), result_buf as *mut u8, write_len as usize);
    }

    write_len
}

#[no_mangle]
pub extern "C" fn forge_model_insert(
    table: *const c_char,
    json: *const c_char,
) -> i64 {
    // Parse JSON, build INSERT statement, execute, return last_insert_rowid
    // ... implementation ...
    0
}

#[no_mangle]
pub extern "C" fn forge_model_last_id() -> i64 {
    let db = DB.lock().unwrap();
    let conn = db.as_ref().expect("Database not initialized");
    conn.last_insert_rowid()
}
```

**Rust dependencies for the model provider:**
```toml
[dependencies]
rusqlite = { version = "0.31", features = ["bundled"] }  # bundled = includes SQLite
serde_json = "1"
```

The `bundled` feature on rusqlite is critical — it compiles SQLite directly into the static library, so the final Forge binary has zero external dependencies.

#### 3.5.3 Codegen for Model Declarations

When the compiler encounters a `model User { ... }` block, it generates:

1. **A struct type** for User (standard Forge struct)
2. **An init call** in the program's startup:
   ```
   forge_model_init("./data/forge.db")
   forge_model_exec("CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, email TEXT UNIQUE NOT NULL, active INTEGER DEFAULT 1)")
   ```
3. **Generated functions** for CRUD:
   ```
   fn User.create(data: {name: string, email: string, ...}) -> User
   fn User.get(id: int) -> User?
   fn User.get_by(field: string, value: any) -> User?
   fn User.list() -> List<User>
   fn User.list(filter: {...}) -> List<User>
   fn User.update(user: User, changes: {...}) -> User
   fn User.delete(id: int) -> bool
   fn User.count() -> int
   ```

Each generated function calls into the native library (`forge_model_insert`, `forge_model_query`, etc.) and marshals data between Forge types and SQLite via JSON serialization.

#### 3.5.4 Annotation Processing

| Annotation | SQL Effect | Forge Effect |
|---|---|---|
| `@primary` | `PRIMARY KEY` | Field is the identity |
| `@auto_increment` | `AUTOINCREMENT` | Auto-assigned on create |
| `@unique` | `UNIQUE` | Constraint enforced |
| `@default(value)` | `DEFAULT value` | Applied if not provided |
| `@index` | `CREATE INDEX` | Performance optimization |
| `@validate(rule)` | None | Checked in before-create hook |
| `@relation` | `REFERENCES table(id)` | Foreign key (Phase 3.5 stretch goal) |

---

### 3.6 @std/http — Implementation

#### 3.6.1 What It Does

The `server` keyword starts an HTTP server. `route` defines endpoints. `mount` auto-generates REST endpoints for a service.

#### 3.6.2 Native Library (Rust)

The HTTP provider is backed by a Rust static library using `tiny_http` (simpler than hyper for Phase 3, can swap to hyper later):

```rust
// providers/std-http/src/lib.rs
// Compiles to libforge_http.a

use tiny_http::{Server, Request, Response as HttpResponse, Method, Header};
use std::sync::{Arc, Mutex};
use std::os::raw::c_char;
use std::ffi::{CStr, CString};

// Route handler callback type
type HandlerFn = extern "C" fn(
    method: *const c_char,
    path: *const c_char,
    body: *const c_char,
    params_json: *const c_char,
    response_buf: *mut c_char,
    response_buf_len: i64,
) -> i64;    // returns status code

struct Route {
    method: String,
    path_pattern: String,         // "/users/:id"
    handler: HandlerFn,
}

static ROUTES: Mutex<Vec<Route>> = Mutex::new(Vec::new());

#[no_mangle]
pub extern "C" fn forge_http_add_route(
    method: *const c_char,
    path: *const c_char,
    handler: HandlerFn,
) {
    let method = unsafe { CStr::from_ptr(method) }.to_str().unwrap().to_string();
    let path = unsafe { CStr::from_ptr(path) }.to_str().unwrap().to_string();
    ROUTES.lock().unwrap().push(Route { method, path_pattern: path, handler });
}

#[no_mangle]
pub extern "C" fn forge_http_serve(port: u16) {
    let addr = format!("0.0.0.0:{}", port);
    let server = Server::http(&addr).expect("Failed to start server");
    eprintln!("Server running on http://localhost:{}", port);

    for request in server.incoming_requests() {
        handle_request(request);
    }
}

fn handle_request(request: Request) {
    let method = request.method().to_string();
    let path = request.url().to_string();

    // Read body
    let mut body = String::new();
    request.as_reader().read_to_string(&mut body).ok();

    let routes = ROUTES.lock().unwrap();

    for route in routes.iter() {
        if route.method == method {
            if let Some(params) = match_path(&route.path_pattern, &path) {
                let method_c = CString::new(method.as_str()).unwrap();
                let path_c = CString::new(path.as_str()).unwrap();
                let body_c = CString::new(body.as_str()).unwrap();
                let params_c = CString::new(params.as_str()).unwrap();

                let mut response_buf = vec![0u8; 65536];
                let status = (route.handler)(
                    method_c.as_ptr(),
                    path_c.as_ptr(),
                    body_c.as_ptr(),
                    params_c.as_ptr(),
                    response_buf.as_mut_ptr() as *mut c_char,
                    response_buf.len() as i64,
                );

                let response_body = unsafe {
                    CStr::from_ptr(response_buf.as_ptr() as *const c_char)
                }.to_str().unwrap_or("").to_string();

                let header = Header::from_bytes(
                    "Content-Type", "application/json"
                ).unwrap();

                let response = HttpResponse::from_string(response_body)
                    .with_status_code(status as i32)
                    .with_header(header);

                request.respond(response).ok();
                return;
            }
        }
    }

    // 404
    let response = HttpResponse::from_string("{\"error\":\"not found\"}")
        .with_status_code(404);
    request.respond(response).ok();
}

fn match_path(pattern: &str, actual: &str) -> Option<String> {
    // Simple path matching with :param extraction
    // Returns JSON object of params, or None if no match
    let pattern_parts: Vec<&str> = pattern.split('/').collect();
    let actual_parts: Vec<&str> = actual.split('?').next().unwrap().split('/').collect();

    if pattern_parts.len() != actual_parts.len() {
        return None;
    }

    let mut params = Vec::new();
    for (p, a) in pattern_parts.iter().zip(actual_parts.iter()) {
        if p.starts_with(':') {
            let name = &p[1..];
            params.push(format!("\"{}\":\"{}\"", name, a));
        } else if p != a {
            return None;
        }
    }

    Some(format!("{{{}}}", params.join(",")))
}
```

**Rust dependencies for the HTTP provider:**
```toml
[dependencies]
tiny_http = "0.12"
```

#### 3.6.3 Codegen for Server Blocks

When the compiler encounters a `server :8080 { ... }` block, it generates:

1. Route registration calls for each `route` and `mount` inside the block
2. A call to `forge_http_serve(8080)` as the last thing in `main`

For each `route GET /health -> { status: "ok" }`:
1. Generate a handler function that evaluates the expression and serializes it to JSON
2. Call `forge_http_add_route("GET", "/health", handler_fn_ptr)`

For each `mount UserService at /users`:
1. Generate 5 handler functions (GET list, GET by id, POST create, PUT update, DELETE)
2. Each handler calls the corresponding service method
3. Register all 5 routes

#### 3.6.4 Mount Auto-Generation

`mount UserService at /users` generates:

| Method | Path | Handler | Service Call |
|---|---|---|---|
| GET | /users | list_handler | UserService.list() → JSON array |
| GET | /users/:id | get_handler | UserService.get(id) → JSON or 404 |
| POST | /users | create_handler | UserService.create(body) → JSON |
| PUT | /users/:id | update_handler | UserService.update(id, body) → JSON |
| DELETE | /users/:id | delete_handler | UserService.delete(id) → 204 or 404 |

---

### 3.7 Service Hooks Codegen

```forge
service UserService for User {
  before create(user) {
    assert user.name.length > 0, "name required"
  }

  after create(user) {
    println(`Created user: ${user.name}`)
  }

  fn deactivate(user: User) -> User {
    User.update(user, { active: false })
  }
}
```

The compiler wraps the auto-generated CRUD methods with hook calls:

```
// Generated create method (pseudocode):
fn UserService.create(data) -> User {
  // Run before hooks
  before_create_hook(data)    // user's custom validation

  // Do the actual create
  let user = User.create(data)

  // Run after hooks
  after_create_hook(user)     // user's custom side effects

  return user
}
```

---

### 3.8 JSON Serialization

Phase 3 needs a way to convert Forge structs to/from JSON. This is needed for:
- HTTP request/response bodies
- SQLite data marshaling
- Model serialization

Implementation approach:
1. Every model auto-derives a `to_json() -> string` and `from_json(string) -> Self` method
2. These are generated at compile time based on the struct fields
3. The C runtime provides `forge_json_parse` and `forge_json_serialize` helpers
4. Or, more practically: use the generated field info to build/parse JSON strings directly in LLVM IR

For Phase 3, keep it simple — generate string-building code for serialization and a simple recursive-descent JSON parser in the C runtime for deserialization.

---

### 3.9 Startup Sequence

The generated `main` function for a program with models and a server:

```
fn main() {
  // 1. Initialize database
  forge_model_init("./data/forge.db")

  // 2. Run auto-migrations
  forge_model_exec("CREATE TABLE IF NOT EXISTS users (...)")

  // 3. Register routes
  forge_http_add_route("GET", "/health", health_handler)
  forge_http_add_route("GET", "/users", users_list_handler)
  forge_http_add_route("GET", "/users/:id", users_get_handler)
  forge_http_add_route("POST", "/users", users_create_handler)
  forge_http_add_route("PUT", "/users/:id", users_update_handler)
  forge_http_add_route("DELETE", "/users/:id", users_delete_handler)

  // 4. Start server (blocks)
  forge_http_serve(8080)
}
```

---

### 3.10 forge.toml Updates

```toml
[project]
name = "my-app"
version = "0.1.0"
entry = "src/main.fg"

[providers]
"@std/model" = "0.1.0"
"@std/http" = "0.1.0"

[database]
default = "sqlite"
path = "./data/app.db"

[build]
opt_level = 2
```

The compiler reads `[providers]` and loads each provider's manifest. The `[database]` section is passed to `@std/model`'s init function.

---

### 3.11 New Dependencies

```toml
# Add to forge compiler's Cargo.toml

# For building provider native libraries
[build-dependencies]
cc = "1"                  # Compile C/Rust provider libs

# The compiler itself doesn't use rusqlite or tiny_http.
# Those are compiled into the provider static libraries separately.
```

The build process for providers:

```bash
# One-time: compile provider native libraries
cd providers/std-model && cargo build --release
# → produces target/release/libforge_model.a

cd providers/std-http && cargo build --release
# → produces target/release/libforge_http.a

# These .a files are bundled with the Forge compiler distribution
# The Forge compiler links them into the user's binary during codegen
```

---

### 3.12 Test Programs

### 3.12.1 basic_model.fg — Model CRUD

```forge
use @std.model.{model}

model Task {
  id: int @primary @auto_increment
  title: string
  done: bool @default(false)
}

fn main() {
  // Create
  let t1 = Task.create({ title: "Buy groceries" })
  let t2 = Task.create({ title: "Write code" })
  let t3 = Task.create({ title: "Take a nap", done: true })

  // Read
  println(string(Task.count()))              // 3

  let task = Task.get(1)
  println(task?.title ?? "not found")        // Buy groceries

  // List
  let all = Task.list()
  for task in all {
    println(`${task.id}: ${task.title} [${task.done}]`)
  }
  // 1: Buy groceries [false]
  // 2: Write code [false]
  // 3: Take a nap [true]

  // Update
  Task.update(t1, { done: true })
  let updated = Task.get(1)
  println(string(updated?.done ?? false))    // true

  // Delete
  Task.delete(2)
  println(string(Task.count()))              // 2
}
```

### 3.12.2 model_service.fg — Service with hooks

```forge
use @std.model.{model, service}

model User {
  id: int @primary @auto_increment
  name: string
  email: string @unique
  active: bool @default(true)
}

service UserService for User {
  before create(user) {
    assert user.name.length > 0, "name required"
    assert user.email.contains("@"), "invalid email"
  }

  after create(user) {
    println(`created: ${user.name} <${user.email}>`)
  }

  fn deactivate(user: User) -> User {
    User.update(user, { active: false })
  }
}

fn main() {
  let alice = UserService.create({ name: "Alice", email: "alice@test.com" })
  // prints: created: Alice <alice@test.com>

  let bob = UserService.create({ name: "Bob", email: "bob@test.com" })
  // prints: created: Bob <bob@test.com>

  UserService.deactivate(alice)

  let users = UserService.list()
  for u in users {
    println(`${u.name}: active=${u.active}`)
  }
  // Alice: active=false
  // Bob: active=true
}
```

### 3.12.3 basic_server.fg — HTTP server

```forge
use @std.http.{server, route}

server :3000 {
  route GET /health -> { status: "ok" }

  route GET /hello/:name -> (req) {
    { message: `hello ${req.params.get("name") ?? "world"}` }
  }
}
```

Test with curl:
```bash
forge build && ./build/basic-server &
curl http://localhost:3000/health
# {"status":"ok"}
curl http://localhost:3000/hello/forge
# {"message":"hello forge"}
kill %1
```

### 3.12.4 full_stack.fg — The motivating example

```forge
use @std.model.{model, service}
use @std.http.{server, route, mount}

model Todo {
  id: int @primary @auto_increment
  title: string
  done: bool @default(false)
}

service TodoService for Todo {
  before create(todo) {
    assert todo.title.length > 0, "title required"
  }
}

server :8080 {
  mount TodoService at /todos

  route GET /health -> { status: "ok", count: Todo.count() }
}
```

Test with curl:
```bash
forge build && ./build/full-stack &
sleep 1

# Health check
curl http://localhost:8080/health
# {"status":"ok","count":0}

# Create todos
curl -X POST http://localhost:8080/todos -d '{"title":"Learn Forge"}'
# {"id":1,"title":"Learn Forge","done":false}

curl -X POST http://localhost:8080/todos -d '{"title":"Build something"}'
# {"id":2,"title":"Build something","done":false}

# List todos
curl http://localhost:8080/todos
# [{"id":1,"title":"Learn Forge","done":false},{"id":2,...}]

# Get single todo
curl http://localhost:8080/todos/1
# {"id":1,"title":"Learn Forge","done":false}

# Update todo
curl -X PUT http://localhost:8080/todos/1 -d '{"done":true}'
# {"id":1,"title":"Learn Forge","done":true}

# Delete todo
curl -X DELETE http://localhost:8080/todos/2
# (204 No Content)

# Verify count
curl http://localhost:8080/health
# {"status":"ok","count":1}

kill %1
```

---

### 3.13 Implementation Order

#### Step 1: Provider Manifest Loading (Week 1)
- Define `provider.toml` schema and parse with `toml` + `serde`
- Read `[providers]` from `forge.toml`
- Load provider manifests from bundled directory
- Build keyword registry from provider manifests
- **Test: compiler recognizes `model` and `server` as keywords (even if they don't do anything yet)**

#### Step 2: Provider Keyword Parsing (Week 1-2)
- Extend parser to check keyword registry for unknown identifiers
- Parse `model` blocks into `ModelDecl` AST nodes
- Parse `service` blocks into `ServiceDecl` AST nodes
- Parse annotation syntax (`@primary`, `@default(value)`, etc.)
- Parse `server` blocks with `route` and `mount` children
- **Test: provider keyword programs parse without error, AST is correct**

#### Step 3: Build @std/model Native Library (Week 2-3)
- Create Rust crate for `forge_model` provider
- Implement SQLite operations (init, exec, query, insert, last_id)
- Compile to static library (`libforge_model.a`)
- Write C header file for the FFI interface
- **Test: native library compiles, C test program can create/query SQLite**

#### Step 4: Model Codegen (Week 3-4)
- Generate struct types from model declarations
- Generate SQL CREATE TABLE statements from model fields + annotations
- Generate CRUD functions that call into native library
- Generate JSON serialization/deserialization for model types
- Insert database init + migration into main function
- Link `libforge_model.a` into final binary
- **Test: `basic_model.fg` compiles and runs**

#### Step 5: Service Codegen (Week 4-5)
- Generate service wrapper functions with hook insertion
- before/after hooks wrap the generated CRUD calls
- Custom service methods compile as regular functions
- **Test: `model_service.fg` compiles and runs**

#### Step 6: Build @std/http Native Library (Week 5-6)
- Create Rust crate for `forge_http` provider
- Implement HTTP server (tiny_http), route registration, request handling
- Path pattern matching with parameter extraction
- Compile to static library (`libforge_http.a`)
- **Test: native library compiles, C test program can start a server**

#### Step 7: HTTP Codegen (Week 6-7)
- Generate handler functions for each `route` block
- Handler functions evaluate the route expression, serialize to JSON, write to response buffer
- Generate route registration calls
- Generate `mount` auto-endpoints (5 CRUD routes per mounted service)
- Insert server startup call at end of main
- Link `libforge_http.a` into final binary
- **Test: `basic_server.fg` compiles and responds to curl**

#### Step 8: Integration + Full Stack (Week 7-8)
- Wire model + http together — mounted services call into model CRUD
- Request body parsing (JSON → model create/update arguments)
- Response serialization (model instances → JSON)
- Error handling (validation failures → 400, not found → 404)
- **Test: `full_stack.fg` compiles and all curl tests pass**

#### Step 9: Polish + Edge Cases (Week 8-9)
- Handle provider import errors gracefully
- Model with no `@primary` field (auto-add `id`)
- Empty request bodies
- Invalid JSON in request bodies
- Concurrent requests (tiny_http handles this, but verify)
- Database file creation (auto-create `./data/` directory)
- Run all Phase 1 + Phase 2 + Phase 3 tests
- **Test: all test programs produce correct results**

---

### 3.14 What Phase 3 Does NOT Include

Deferred to later phases:

- Community/custom providers (only @std providers in Phase 3)
- Provider registry / downloading
- Provider SDK for external authors
- Middleware implementation
- WebSocket support
- Queues, cron, AI, deploy, CLI providers
- Relations between models (@relation / JOIN queries)
- Pagination in list endpoints
- Authentication / authorization
- CORS
- Request validation beyond basic annotation checks
- PostgreSQL / MySQL backends
- Hot reload
- Events (emit/on)
- The external language bridge (Go/Python components)

---

### 3.15 Definition of Done

Phase 3 is complete when:

1. All Phase 1 + Phase 2 tests still pass (no regressions)
2. `basic_model.fg` creates, reads, updates, and deletes SQLite records
3. `model_service.fg` runs before/after hooks correctly
4. `basic_server.fg` responds to HTTP requests with correct JSON
5. `full_stack.fg` — the motivating example — works end-to-end with curl
6. Provider keywords are dynamically loaded from `provider.toml` manifests
7. Provider native libraries are statically linked into the final binary
8. The resulting binary is self-contained (no runtime dependencies, no external SQLite)
9. Binary size for `full_stack.fg` is < 20MB
10. Server handles at least 100 requests/second on basic endpoints
11. Error messages for provider-related issues are clear and actionable
12. `cargo test` passes all tests
