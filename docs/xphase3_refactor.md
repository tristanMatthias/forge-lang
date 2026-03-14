# Forge — Package Architecture Refactor & Codegen Restructuring

**Context:** Phase 3 is complete. The compiler has working `@std/model` and `@std/http` support, but the codegen has package-specific logic baked in. This spec refactors to a clean package architecture and restructures the codegen module.

---

## 1. Codegen Restructuring

The codegen module is doing too much. Split it by responsibility.

### Current (hairy)

```
codegen/
└── codegen.rs        # Everything: expressions, statements, functions,
                      #   strings, control flow, refcounting, model stuff,
                      #   http stuff, JSON, FFI calls...
```

### Target

```
codegen/
├── mod.rs               # Public API: compile(ast) -> LLVM module
├── context.rs           # CodegenContext: holds LLVM module, builder, type maps, symbol table
├── types.rs             # Forge type → LLVM type mapping
├── literals.rs          # Int, float, bool, string, list, map, struct, tuple literals
├── expressions.rs       # Binary ops, unary ops, member access, index, calls
├── statements.rs        # Let, mut, const, assign, return, defer, errdefer
├── functions.rs         # Function definitions, closures, `it` desugaring
├── control_flow.rs      # If, match, for, while, loop, break, continue
├── pattern_match.rs     # Pattern matching compilation (match arms → branches)
├── strings.rs           # String operations, template literal interpolation
├── nullability.rs       # Nullable types, ?., ??, !, smart narrowing
├── errors.rs            # Result type, ? operator, catch blocks
├── collections.rs       # List/Map/Set method codegen (filter, map, reduce, etc.)
├── refcount.rs          # Retain/release insertion, drop calls
├── traits.rs            # Trait method resolution, monomorphization
├── extern_ffi.rs        # extern fn → LLVM external declaration + call marshaling
├── json.rs              # JSON serialize/deserialize generation
├── package_blocks.rs   # Generic package keyword block codegen (desugared via types.fg)
└── linker.rs            # Object emission, linking .a files + runtime
```

Each file handles one concern. The main `mod.rs` walks the AST and dispatches to the right submodule:

```rust
// codegen/mod.rs (simplified)
pub fn compile(program: &TypedProgram, ctx: &mut CodegenContext) {
    for stmt in &program.statements {
        match stmt {
            Statement::Let { .. } => statements::compile_let(stmt, ctx),
            Statement::FnDecl { .. } => functions::compile_fn(stmt, ctx),
            Statement::Expr(expr) => expressions::compile_expr(expr, ctx),
            Statement::For { .. } => control_flow::compile_for(stmt, ctx),
            Statement::TraitDecl { .. } => traits::compile_trait(stmt, ctx),
            Statement::ImplDecl { .. } => traits::compile_impl(stmt, ctx),
            Statement::PackageBlock { .. } => package_blocks::compile(stmt, ctx),
            // etc.
        }
    }
}
```

### Key: `extern_ffi.rs`

This is the bridge between Forge and native libraries. It handles one thing: when the compiler sees `extern fn foo(x: int) -> string`, generate:

1. An LLVM external function declaration with the right C ABI types
2. A Forge-callable wrapper that marshals Forge types → C types on the way in and C types → Forge types on the way out

Every package goes through this. No special cases.

### Key: `package_blocks.rs`

This handles package keyword blocks. But it doesn't know anything about HTTP or models. It just:

1. Looks up the keyword in the package registry
2. Finds the corresponding desugared Forge code (from `types.fg`)
3. Compiles that Forge code normally

If `types.fg` defines how `server` works in terms of regular Forge function calls, then `package_blocks.rs` just triggers that Forge code. The complexity lives in `types.fg`, not in the compiler.

---

## 2. Package Architecture

### 2.1 What a Package Is

A package is a directory containing three things:

```
my-package/
├── package.toml           # Metadata: name, version, keywords, native lib name
├── src/
│   └── package.fg         # Entry point: types, extern fns, keyword expansions, helpers
│       (or split into multiple files and re-export from package.fg)
└── lib/
    └── <platform>/
        └── libmy_package.a    # Native library with C ABI exports (any language)
```

For larger packages, split the Forge code:

```
my-package/
├── package.toml
├── src/
│   ├── package.fg         # Entry point — re-exports everything
│   ├── types.fg            # Type definitions
│   ├── keywords.fg         # Keyword expansions
│   └── helpers.fg          # Utility functions
└── lib/
    └── <platform>/
        └── libmy_package.a
```

### 2.2 package.toml — Minimal Metadata

```toml
[package]
name = "http"
namespace = "std"
version = "0.1.0"
description = "HTTP server and routing"

[native]
library = "forge_http"

# Keywords this package registers
# kind:
#   "block"    — has { } body with config/schema/blocks, needs keyword expansion in package.fg
#   "function" — scoped function call, no special parsing, calls an exported fn from package.fg
# context: where it's valid — "top_level" or name of a parent keyword block
# body: (block only) what's inside — "mixed" (config + schema + blocks)
# syntax: (block only) custom syntax for the opening line

[keywords.server]
kind = "block"
context = "top_level"
syntax = "server :<port:int>"
body = "mixed"

[keywords.route]
kind = "function"
context = "server"

[keywords.mount]
kind = "function"
context = "server"

[keywords.tool]
kind = "block"
context = "agent"
body = "mixed"
```

That's it. The TOML declares:
- What this package is called
- What native library to link
- What keywords it registers with their context and body type

All the interesting stuff lives in `package.fg`.

### 2.3 package.fg — The Package's Heart

This is where the package defines everything: types, native bridges, keyword expansions, and helper functions. It's just Forge code with one addition — the `keyword` block for compile-time expansion.

A keyword expansion has three sections that run in order:
1. **Setup** — creates scope: variables and functions available inside the block
2. **User's block body** — inserted automatically by the compiler after setup
3. **Lifecycle hooks** — `on startup`, `on main_end`, etc.

No explicit `body` placement needed. The user's code always runs between setup and lifecycle hooks.

**@std/http — complete package.fg:**

```forge
// packages/std-http/src/package.fg

// ── Native bridge ──
extern fn forge_http_create_server(port: int) -> int
extern fn forge_http_start_all()
extern fn forge_http_add_route(server_id: int, method: string, path: string, handler: fn(string, string, string, string) -> string)
extern fn forge_http_enable_cors(server_id: int)
extern fn forge_http_enable_logging(server_id: int)
extern fn forge_http_set_rate_limit(server_id: int, rps: int)

// ── Types ──
export type Request = {
  method: string,
  path: string,
  body: string,
  params: Map<string, string>,
}

export type Response = {
  status: int,
  body: string,
}

// ── Helper functions ──
export fn respond(status: int, body: json) -> Response {
  Response { status: status, body: json.stringify(body) }
}

// ── Keywords ──

keyword server(port: int, config, schema) {
  config {
    cors: bool = false
    logging: bool = false
    rate_limit: int = 0
  }

  // Setup — creates scope for the user's block body
  let id = forge_http_create_server(port)
  if config.cors { forge_http_enable_cors(id) }
  if config.logging { forge_http_enable_logging(id) }
  if config.rate_limit > 0 { forge_http_set_rate_limit(id, config.rate_limit) }

  // Functions available inside the server block
  // They close over `id` — no self, no classes, just lexical scope
  fn route(method: string, path: string, handler: fn(Request) -> any) {
    forge_http_add_route(id, method, path, (raw_method, raw_path, raw_body, raw_params) -> {
      let req = Request {
        method: raw_method,
        path: raw_path,
        body: raw_body,
        params: json.parse(raw_params),
      }
      json.stringify(handler(req))
    })
  }

  fn mount(service, path: string) {
    route("GET", path, (req) -> ${service}.list())
    route("GET", `${path}/:id`, (req) -> {
      ${service}.get(int(req.params.get("id") ?? "0"))
    })
    route("POST", path, (req) -> {
      ${service}.create(json.parse(req.body))
    })
    route("PUT", `${path}/:id`, (req) -> {
      let record = ${service}.get(int(req.params.get("id") ?? "0"))
      ${service}.update(record, json.parse(req.body))
    })
    route("DELETE", `${path}/:id`, (req) -> {
      ${service}.delete(int(req.params.get("id") ?? "0"))
    })
  }

  // User's block body is inserted here automatically by the compiler
  // Their route() and mount() calls resolve to the functions above

  // Lifecycle
  on main_end {
    forge_http_start_all()
  }
}
```

**@std/model — complete package.fg:**

```forge
// packages/std-model/src/package.fg

// ── Native bridge ──
extern fn forge_model_init(db_path: string)
extern fn forge_model_exec(sql: string) -> int
extern fn forge_model_insert(table: string, data_json: string) -> string
extern fn forge_model_get_by_id(table: string, id: int) -> string
extern fn forge_model_list(table: string, filter_json: string) -> string
extern fn forge_model_update(table: string, id: int, changes_json: string) -> string
extern fn forge_model_delete(table: string, id: int) -> int
extern fn forge_model_count(table: string, filter_json: string) -> int

// ── Keywords ──

// model User { id: int @primary, name: string, ... }
// Model has no user code body — it's all schema. The keyword generates everything.
keyword model(name: string, config, schema) {
  config {
    table_name: string = name.lower() + "s"
  }

  // Build SQL from schema entries (field declarations with annotations)
  let columns = schema.map(f -> {
    let col = `${f.name} ${sql_type(f.type)}`
    if f.annotation("primary") { col = col + " PRIMARY KEY" }
    if f.annotation("auto_increment") { col = col + " AUTOINCREMENT" }
    if f.annotation("unique") { col = col + " UNIQUE" }
    if f.annotation("default") { col = col + ` DEFAULT ${f.annotation("default").value}` }
    if !f.nullable { col = col + " NOT NULL" }
    col
  })

  on startup {
    forge_model_init(config("database.path", "./data/forge.db"))
    forge_model_exec(`CREATE TABLE IF NOT EXISTS ${config.table_name} (${columns.join(", ")})`)
  }

  // Generated CRUD functions — available globally as Model.method()
  fn ${name}.create(data) -> ${name} {
    json.parse(forge_model_insert(config.table_name, json.stringify(data)))
  }

  fn ${name}.get(id: int) -> ${name}? {
    let raw = forge_model_get_by_id(config.table_name, id)
    if raw == "" { null } else { json.parse(raw) }
  }

  fn ${name}.list() -> List<${name}> {
    json.parse(forge_model_list(config.table_name, "{}"))
  }

  fn ${name}.update(record: ${name}, changes) -> ${name} {
    json.parse(forge_model_update(config.table_name, record.id, json.stringify(changes)))
  }

  fn ${name}.delete(id: int) -> bool {
    forge_model_delete(config.table_name, id) > 0
  }

  fn ${name}.count() -> int {
    forge_model_count(config.table_name, "{}")
  }

  // No user body — model blocks are purely declarative
}

// service UserService for User { ... }
// Service DOES have a user body — hooks and custom methods
keyword service(name: string, model_ref: ident, config, schema) {
  // Setup: wrap the model's CRUD with hook points

  fn ${name}.create(data) -> ${model_ref} {
    // User's before_create hook runs here (if defined in block body)
    let result = ${model_ref}.create(data)
    // User's after_create hook runs here (if defined in block body)
    result
  }

  fn ${name}.get(id: int) -> ${model_ref}? { ${model_ref}.get(id) }
  fn ${name}.list() -> List<${model_ref}> { ${model_ref}.list() }

  fn ${name}.update(record: ${model_ref}, changes) -> ${model_ref} {
    let result = ${model_ref}.update(record, changes)
    result
  }

  fn ${name}.delete(id: int) -> bool {
    ${model_ref}.delete(id)
  }

  // User's block body is inserted here automatically
  // Contains: on before_create { ... }, on after_create { ... }, custom fn declarations
  // These hook into the CRUD methods above
}

// ── Helpers ──
fn sql_type(t: string) -> string {
  match t {
    "int" -> "INTEGER"
    "float" -> "REAL"
    "string" -> "TEXT"
    "bool" -> "INTEGER"
    _ -> "TEXT"
  }
}
```

**A simple library package (no keywords) — @community/redis:**

```forge
// packages/community-redis/src/package.fg

extern fn forge_redis_connect(url: string)
extern fn forge_redis_get(key: string) -> string?
extern fn forge_redis_set(key: string, value: string)
extern fn forge_redis_del(key: string) -> bool

export fn connect(url: string) {
  forge_redis_connect(url)
}

export fn get(key: string) -> string? {
  forge_redis_get(key)
}

export fn set(key: string, value: string) {
  forge_redis_set(key, value)
}

export fn del(key: string) -> bool {
  forge_redis_del(key)
}
```

### 2.4 Keyword Block Anatomy

A keyword block has three kinds of content, distinguished by syntax:

**Config** — `key value` (no colon, no parentheses):
```forge
cors true
logging true
rate_limit 100
table_name "custom_users"
```

**Schema** — `key: type @annotations` (has colon):
```forge
id: int @primary @auto_increment
name: string
email: string @unique @validate(email)
role: string @default("member")
```

**Blocks** — nested keywords, event handlers, function calls:
```forge
route("GET", "/health", (req) -> { status: "ok" })
mount(TodoService, "/todos")
on before_create(record) { assert record.name.length > 0 }
tool lookup_user(id: string) -> User? { UserService.get(int(id)) }
```

The parser distinguishes them syntactically:
- Identifier followed by value (no colon, no parens) → **config**
- Identifier followed by colon and type → **schema**
- Everything else (function calls, blocks, `on` handlers) → **blocks**

The keyword expansion receives config and schema as arguments. The user's block body (function calls, event handlers, nested blocks) is inserted automatically after setup:

```forge
keyword my_keyword(name: string, config, schema) {
  config {
    cors: bool = false        // declares what config keys are valid + defaults
  }
  // config.cors         → true (from user's `cors true`)
  // schema[0].name      → "id"
  // schema[0].type      → "int"
  // schema[0].annotation("primary") → true

  // Setup: define functions and variables...
  fn some_scoped_fn() { ... }

  // User's block body inserted here automatically
  // (function calls, on handlers, etc.)

  // Lifecycle hooks
  on main_end { ... }
}
```

Keywords that are purely declarative (like `model`) don't need a user body — they only use config and schema. Keywords that have user code (like `server`, `service`) have the body inserted automatically after setup.

### 2.5 What The Compiler Knows vs What Packages Know

**Compiler knows:**
- How to parse keyword blocks into config/schema/blocks
- How to execute `keyword` expansion blocks at compile time
- How to compile `extern fn` declarations into LLVM external symbols
- How to marshal Forge types to C ABI types
- How to link `.a` files

**Compiler does NOT know:**
- What HTTP, SQL, queues, AI, or any domain concept means
- What any specific native function does
- How any specific package's keywords should expand (that's in package.fg)

**Package knows:**
- Its domain (HTTP, databases, queues, etc.)
- Its native function implementations
- How its keywords expand into Forge code
- Its Forge types

**Package does NOT know:**
- How the compiler works
- What LLVM is
- How other packages work

### 2.6 Adding a New Package (Author Experience)

Say someone wants to create `@community/redis`:

**Step 1:** Write the native library in any compiled language:

```rust
// src/lib.rs
#[no_mangle]
pub extern "C" fn forge_redis_connect(url: *const c_char) { ... }

#[no_mangle]
pub extern "C" fn forge_redis_get(key: *const c_char) -> *const c_char { ... }

#[no_mangle]
pub extern "C" fn forge_redis_set(key: *const c_char, value: *const c_char) { ... }
```

**Step 2:** Write `package.fg`:

```forge
extern fn forge_redis_connect(url: string)
extern fn forge_redis_get(key: string) -> string?
extern fn forge_redis_set(key: string, value: string)
extern fn forge_redis_del(key: string) -> bool

export fn connect(url: string) { forge_redis_connect(url) }
export fn get(key: string) -> string? { forge_redis_get(key) }
export fn set(key: string, value: string) { forge_redis_set(key, value) }
export fn del(key: string) -> bool { forge_redis_del(key) }
```

**Step 3:** Write `package.toml`:

```toml
[package]
name = "redis"
namespace = "community"
version = "0.1.0"

[native]
library = "forge_redis"
```

No keywords needed. That's the entire package.

**Step 4:** Compile and package:

```bash
cargo build --release
mkdir -p lib/aarch64-macos
cp target/release/libforge_redis.a lib/aarch64-macos/
```

**Step 5:** Users use it:

```forge
use @community.redis

fn main() {
  redis.connect("redis://localhost:6379")
  redis.set("greeting", "hello forge")
  let val = redis.get("greeting")
  println(val ?? "not found")    // hello forge
}
```

### 2.7 Two Kinds of Packages

**Library packages** (like redis): just `extern fn` + Forge wrapper functions. No keywords, no `package.toml` keyword section. Used with regular `use` imports and function calls. Easy to write — most community packages will be this.

**Keyword packages** (like http, model): register custom keywords with special syntax via `keyword` blocks in `package.fg`. More powerful, enable declarative DSL-like syntax. The compiler parses keyword blocks into config/schema/blocks and the `keyword` expansion defines what to generate.

### 2.8 How The Compiler Loads Packages

```
1. Read forge.toml → list of packages
2. For each package:
   a. Find package directory ($FORGE_HOME/packages/<namespace>/<name>/)
   b. Read package.toml → get keyword registrations + native lib name
   c. Parse package.fg → add types, extern fns, and keyword expansions
   d. Register keywords in the parser (if any declared in package.toml)
   e. Record native lib path for the linker
3. Parse user's source files (package keywords now recognized)
4. Type check (package types now available)
5. For each keyword block in user code:
   a. Parse body into config / schema / blocks
   b. Execute the keyword expansion from package.fg
   c. Compile the expanded Forge code normally
6. Codegen (extern fns generate external LLVM declarations)
7. Link: user code + runtime + all package .a files → binary
```

---

## 3. Refactoring Steps

### Step 1: Split codegen into submodules
- Create the file structure from Section 1
- Move code from the monolithic codegen.rs into the appropriate submodules
- Ensure all Phase 1-3 tests still pass after each move
- No behavior changes — just reorganization

### Step 2: Extract extern fn handling
- Create `extern_ffi.rs`
- Move all FFI/external function declaration and call marshaling code here
- The `extern fn` keyword should be the ONLY way native functions enter the compiler
- Remove any direct references to `forge_http_*` or `forge_model_*` from the compiler codegen

### Step 3: Implement keyword expansion engine
- Create `package_keywords.rs`
- Implement the `keyword(name, config, schema, blocks)` compile-time expansion
- The parser detects keyword blocks → parses body into config/schema/blocks → hands off to the expansion engine
- The expansion engine evaluates the `keyword` block from `package.fg` with the parsed data
- Expanded Forge code is compiled through the normal pipeline

### Step 4: Create package loading
- Read `package.toml` for keyword registration
- Parse `package.fg` and inject types, extern fns, and keyword definitions into the compilation
- Resolve `.a` file paths for the linker

### Step 5: Move @std/model out of the compiler
- Create `packages/std-model/` directory with `package.toml`, `src/package.fg`, and native Rust library
- Write the `keyword model(...)` and `keyword service(...)` expansions in `package.fg`
- The compiler loads it through the package system, not special-cased code

### Step 6: Move @std/http out of the compiler
- Same as Step 5 for HTTP
- Write the `keyword server(...)` expansion in `package.fg`
- `route` and `mount` become regular exported functions, not keywords
- After this step, the compiler has zero package-specific code

### Step 7: Verify
- All Phase 1-3 tests pass
- The compiler codebase has no references to "http", "model", "sqlite", or "route" outside of test files
- Adding a new package requires zero compiler changes

---

## 4. Definition of Done

1. Codegen is split into 15+ focused submodules
2. No single codegen file exceeds ~500 lines
3. All `@std/model` code lives in `packages/std-model/`, not the compiler
4. All `@std/http` code lives in `packages/std-http/`, not the compiler
5. Package loading works through `package.toml` + `package.fg` + `.a` file
6. Keyword blocks parse into config/schema/blocks and expand via `package.fg`
7. A library package (no keywords) can be created with just `package.fg` + `.a` file + toml
8. A keyword package can define its expansion entirely in `package.fg`
9. All Phase 1-3 tests pass with zero regressions
10. The compiler binary itself doesn't link against rusqlite or tiny_http
