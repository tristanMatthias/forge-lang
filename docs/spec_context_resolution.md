# Forge — Language Polish Features (TDD)

Features identified from code review of a real Forge application. These make the difference between "works" and "idiomatic."

---

# Part 1: Contextual Resolution with Dot Prefix

The `.` prefix means "resolve from context." Used everywhere: enum variants, field references, roles, error types, annotations.

## Test 1.1: Enum variants (already exists)

```forge
enum Status { active, pending, done }

fn main() {
  let s: Status = .active
  println(string(s is .active))    // true
}
```

## Test 1.2: Field references in where clauses

```forge
model User {
  name: string
  email: string
  age: int
}

fn main() {
  // .name and .email are contextual references to User fields
  let users = User.where(.name: "alice")
  let adults = User.where(.age: gt(18))
}
```

```forge
// Compile error on invalid field reference
fn main() {
  User.where(.titel: "alice")
}
```

```
  ╭─[error[F0020]] Unknown field reference
  │
  │    2 │ User.where(.titel: "alice")
  │      │            ──────
  │      │            .titel is not a field on User
  │
  │  ├── help: did you mean .title?
  │  ├── available: .name, .email, .age
  ╰──
```

## Test 1.3: Role references in annotations

```forge
auth {
  role admin { all }
  role publisher { read, create }
  role anonymous { read }
}

server :8080 {
  @auth(.publisher)
  POST /packages -> (req) { ... }

  @auth(.admin)
  DELETE /packages/:name -> (req) { ... }
}
```

```forge
// Compile error on invalid role
server :8080 {
  @auth(.superuser)
}
```

```
  ╭─[error[F0074]] Unknown contextual reference
  │
  │    2 │ @auth(.superuser)
  │      │       ──────────
  │      │       .superuser is not a defined role
  │
  │  ├── available: .admin, .publisher, .anonymous
  ╰──
```

## Test 1.4: Error variants in match

```forge
fn main() {
  let result = do_thing()
  
  match result {
    .ok -> println("success")
    .not_found -> println("missing")
    .unauthorized -> println("denied")
  }
}
```

## Test 1.5: Contextual references in component config

```forge
model Post {
  status: PostStatus @default(.draft)    // .draft resolved from PostStatus
  
  author_id: int @belongs_to(User) @owner   // @owner resolved from model annotations
}
```

## Test 1.6: Named params — key is property, value is expression

```forge
fn main() {
  let name = "alice"
  
  // Left of : is field reference, right of : is expression
  User.where(.name: name)       // .name = field, name = variable
  User.create({ name, email })  // shorthand — name the variable IS the field
}
```

---

# Part 2: Match Tables

Match expressions with table syntax. The first column is the pattern, remaining columns are named values. The match expands into a function call or struct.

## Test 2.1: Basic match table

```forge
fn describe(status: Status) -> string {
  match status table {
    pattern  | label       | emoji
    .active  | "active"    | "✓"
    .pending | "pending"   | "◐"
    .done    | "complete"  | "●"
    .failed  | "failed"    | "✖"
  }
  // Returns { label: string, emoji: string }
}

fn main() {
  let result = describe(.active)
  println(`${result.emoji} ${result.label}`)    // ✓ active
}
```

`pattern` is the keyword for the match column. The compiler matches against it and returns a struct with the remaining columns.

## Test 2.2: Match table expanding into function call

```forge
fn handle_error(err: AppError) {
  respond(match err table {
    pattern        | status | body
    .not_found     | 404    | { error: "not found" }
    .unauthorized  | 401    | { error: "unauthorized" }
    .forbidden     | 403    | { error: "forbidden" }
    .validation(e) | 400    | { error: "validation failed", fields: e.fields }
    _              | 500    | { error: "internal error" }
  })
}
```

`respond(match err table { ... })` means: match `err` against the table, return a struct with the column values, pass it to `respond`. The header row names map to the function's parameters. Desugars to:

```forge
match err {
  .not_found -> respond(404, { error: "not found" })
  .unauthorized -> respond(401, { error: "unauthorized" })
  .forbidden -> respond(403, { error: "forbidden" })
  .validation(e) -> respond(400, { error: "validation failed", fields: e.fields })
  _ -> respond(500, { error: "internal error" })
}
```

## Test 2.3: Match table with destructuring result

```forge
fn main() {
  let err = AppError.not_found

  let {status, body} = match err table {
    pattern        | status | body
    .not_found     | 404    | { error: "not found" }
    .unauthorized  | 401    | { error: "unauthorized" }
    _              | 500    | { error: "internal error" }
  }

  respond(status, body)
}
```

Both styles work — `match -> fn()` for direct invocation, or `let {..} = match` for capturing the result.

## Test 2.4: Match table with expressions in cells

```forge
fn status_info(s: Status, user: User) -> string {
  let result = match s table {
    pattern  | code | message
    .active  | 200  | `${user.name} is active`
    .pending | 202  | `${user.name} is pending review`
    .banned  | 403  | `${user.name} is banned`
  }
  
  `${result.code}: ${result.message}`
}
```

## Test 2.5: Match table compile-time exhaustiveness

```forge
enum Color { red, green, blue }

fn name(c: Color) {
  match c table {
    pattern | label
    .red    | "red"
    .green  | "green"
    // missing .blue
  }
}
```

```
  ╭─[error[F0091]] Non-exhaustive match table
  │
  │    3 │   match c {
  │      │   ─────────
  │      │   missing pattern: .blue
  │
  │  ├── help: add the missing row
  │  │     .blue | "blue"
  │  │   or add a wildcard: _ | "unknown"
  ╰──
```

---

# Part 3: Query Operators

Functions that return predicates, not values. Used inside `.where()` to build type-safe queries.

## Test 3.1: Exact match (default)

```forge
fn main() {
  let user = User.where(.name: "alice")     // exact match
  let users = User.where(.active: true)     // exact match
}
```

## Test 3.2: Comparison operators

```forge
fn main() {
  let adults = User.where(.age: gt(18))
  let cheap = Product.where(.price: lt(50.0))
  let mid = Product.where(.price: between(10.0, 50.0))
  let recent = Post.where(.created_at: after(now() - 7d))
  let old = Post.where(.created_at: before(now() - 30d))
}
```

## Test 3.3: String matching

```forge
fn main() {
  let results = Package.where(.name: like(`%${query}%`))
  let dotcom = User.where(.email: ends_with("@gmail.com"))
  let admins = User.where(.name: starts_with("admin"))
  let has_tag = Post.where(.tags: contains("forge"))
}
```

## Test 3.4: Combining conditions

```forge
fn main() {
  let results = Post
    .where(.status: .published)
    .where(.views: gt(100))
    .or(.featured: true)
    .order(.created_at: .desc)
    .limit(10)
}
```

## Test 3.5: Invalid operator — compile error

```forge
fn main() {
  User.where(.name: gt(5))    // name is string, gt takes numeric
}
```

```
  ╭─[error[F0012]] Type mismatch in query operator
  │
  │    2 │ User.where(.name: gt(5))
  │      │                   ─────
  │      │                   gt() expects a numeric field, but .name is string
  │
  │  ├── help: for string matching, use like(), starts_with(), or ends_with()
  ╰──
```

---

# Part 4: Shorthand Field Syntax

When variable name matches field name, write it once.

## Test 4.1: In struct literals

```forge
fn main() {
  let name = "alice"
  let email = "alice@test.com"
  let age = 30

  let user = { name, email, age }
  // Equivalent to: { name: name, email: email, age: age }

  println(user.name)      // alice
  println(string(user.age))  // 30
}
```

## Test 4.2: Mixed shorthand and explicit

```forge
fn main() {
  let name = "alice"
  let user = { name, email: "custom@test.com", age: 30 }
  println(user.name)      // alice
  println(user.email)     // custom@test.com
}
```

## Test 4.3: In function calls

```forge
fn create_user(name: string, email: string) -> User {
  User.create({ name, email })
}

fn main() {
  let name = "alice"
  let email = "alice@test.com"
  let user = create_user(name, email)    // already works — positional
}
```

## Test 4.4: In json.stringify

```forge
fn main() {
  let action = "publish"
  let package = "forge-http"
  let version = "0.1.0"

  let json = json.stringify({ action, package, version })
  println(json)
  // {"action":"publish","package":"forge-http","version":"0.1.0"}
}
```

---

# Part 5: Path Type in Practice

The `path()` type should be used instead of raw string manipulation for file operations.

## Test 5.1: Replace raw fs calls

```forge
// BAD — calling raw extern fns
fn old_way() {
  forge_fs_mkdir("data/packages", true)
  let content = forge_fs_read("data/packages/meta.json")
}

// GOOD — using path type
fn new_way() {
  let dir = path("data") / "packages"
  dir.mkdir()?
  let content = (dir / "meta.json").read()?
}
```

## Test 5.2: Path operations chain

```forge
fn main() {
  let base = path("data")
  let pkg_dir = base / "packages" / "forge-http"
  let meta = pkg_dir / "meta.json"
  let versions = pkg_dir / "versions"

  pkg_dir.mkdir()?
  meta.write(json.stringify({ name: "forge-http" }))?
  
  println(string(meta.exists))     // true
  println(meta.read()?)            // {"name":"forge-http"}
}
```

---

# Part 6: Error Throwing with ??

Pattern for "find or throw" which replaces verbose null checking.

Clarification on operators:
- `?` at end = error propagation (Result). `User.create(data)?` — if Err, propagate upward.
- `?.` = null-safe access. `user?.name` — if null, return null instead of crashing.
- `??` = null coalescing. `value ?? default` — if null, use default.
- `?? throw` = null → error conversion. `value ?? throw .not_found` — if null, throw an error.

These are distinct: `?` is the error path, `?.` and `??` are the null path. `?? throw` bridges null into errors.

## Test 6.1: Throw on null

```forge
fn main() {
  let user = User.find_by(.email: "alice@test.com") ?? throw .not_found
  println(user.name)
}
```

Desugars to:

```forge
let user = match User.find_by(.email: "alice@test.com") {
  Some(u) -> u
  null -> throw .not_found
}
```

## Test 6.2: Throw with custom message

```forge
fn main() {
  let pkg = Package.find_by(.name: "nonexistent") 
    ?? throw .not_found("package not found")
  
  println(pkg.name)
}
```

## Test 6.3: Chain with method calls

```forge
fn main() {
  let version = Package.find_by(.name: req.params.name)
    ?? throw .not_found
    |> it.versions.find(.version: req.params.version)
    ?? throw .not_found
  
  println(version.manifest)
}
```

---

# Part 7: Typed Response Helpers

Common HTTP response patterns as ergonomic functions.

## Test 7.1: respond() with status and body

```forge
server :8080 {
  GET /health -> { status: "ok" }                    // 200 implicit

  GET /users/:id -> (req) {
    User.get(req.params.id) ?? respond(404, { error: "not found" })
  }

  POST /users -> (req) {
    let user = User.create(req.body)?
    respond(201, user)                                // explicit 201
  }
}
```

## Test 7.2: Error handler with match table

```forge
server :8080 {
  on error(err, req) {
    respond(match err table {
      pattern          | status | body
      .not_found       | 404    | { error: "not found" }
      .unauthorized    | 401    | { error: "unauthorized" }
      .forbidden       | 403    | { error: "forbidden" }
      .validation(e)   | 400    | { error: "validation failed", fields: e.fields }
      .rate_limited    | 429    | { error: "too many requests" }
      _                | 500    | { error: "internal error" }
    })
  }
}
```

---

# Part 8: CRUD Improvements

## Test 8.1: CRUD with type operators for response shape

Use `@hidden` on fields that should never be exposed, or use type operators for custom response shapes:

```forge
model User {
  id: int @primary @auto_increment
  name: string
  email: string
  password: string @hidden    // never included in API responses
  created_at: datetime @default(now)
}

// Or use type operators for explicit response types
type PackageResponse = Package without {internal_notes}
type VersionResponse = Version only {.version, .manifest, .content_hash, .published_at}

server :8080 {
  crud Package {
    response Package as PackageResponse
    response Version as VersionResponse
  }
}
```

## Test 8.2: Nested routes with under (no special nest syntax)

Relations are declared on models with `@belongs_to`. Nested routes use `under` — standard language, no custom `nest` keyword:

```forge
model Version {
  id: int @primary @auto_increment
  version: string
  package_name: string @belongs_to(Package)
}

server :8080 {
  under /v1 {
    crud Package

    // Nested versions under packages — just regular routes with under
    under /packages/:name/versions {
      GET / -> (req) {
        let pkg = Package.find_by(.name: req.params.name) ?? throw .not_found
        Version.where(.package_name: pkg.name)
      }

      POST / -> (req) {
        let pkg = Package.find_by(.name: req.params.name) ?? throw .not_found
        Version.create(req.body with { package_name: pkg.name })
      }

      GET /:version -> (req) {
        Version.find_by(
          .package_name: req.params.name,
          .version: req.params.version,
        ) ?? throw .not_found
      }
    }
  }
}
```

## Test 8.3: CRUD publish with hooks and channel-based logging

```forge
type AuditEvent = {
  action: string,
  package: string,
  version: string,
  content_hash: string,
  timestamp: datetime,
}

let audit = channel<AuditEvent>(1000)

// Consumer writes to file
spawn {
  let log = path("data/audit.jsonl")
  for event in audit {
    log.append(json.stringify(event) + "\n")
  }
}

server :8080 {
  under /v1 {
    crud Package {
      @public
      GET /packages
      GET /packages/:name

      @auth(.publisher)
      POST /packages

      on after_create Package (pkg, req) {
        audit <- AuditEvent {
          action: "publish",
          package: pkg.name,
          version: pkg.latest_version,
          content_hash: "",
          timestamp: now(),
        }
      }
    }
  }
}
```

---

# Part 9: Model .include() with Dot References

## Test 9.1: Include with dot syntax

`?.` is null-safe access — `find_by` returns `Package?` (nullable), so `?.include()` only runs if the package was found. This is not error propagation (`?`) — it's null chaining.

```forge
fn main() {
  let pkg = Package.find_by(.name: "forge-http")
    ?.include(.versions)    // ?. = safe access on nullable Package?

  println(string(pkg?.versions.length))   // pkg is still Package?, so ?. again
}
```

## Test 9.2: Nested includes

```forge
fn main() {
  let post = Post.find_by(.slug: "hello-world")
    ?.include(.author, .comments.include(.author), .tags)

  println(post?.author.name)
  println(string(post?.comments.length))
}
```

---

# Part 10: Auth Token Lookup Pattern

Standard pattern for token-based auth that uses the model system.

## Test 10.1: Token auth with crypto

```forge
use @std.auth
use @std.crypto

auth {
  provider token {
    header "Authorization"
    prefix "Bearer "
    lookup (raw_token) -> {
      let hash = crypto.sha256(raw_token)
      Token.find_by(.token_hash: hash)?.user
    }
  }

  role admin { all }
  role publisher { read, create, update_own }
  role anonymous { read }
}
```

## Test 10.2: Login endpoint returning a token

`?? throw .unauthorized` — `find_by` returns `User?` (nullable). `??` triggers on null. `.unauthorized` resolves from the server's error handler context — the `on error` handler defines what error variants exist. `throw` converts a null into that error, which the error handler catches and returns as a 401.

```forge
server :8080 {
  @public
  POST /auth/token -> (req) {
    // find_by returns User? — ?? triggers on null, throws .unauthorized
    let user = User.find_by(.username: req.body.username) ?? throw .unauthorized
    if !crypto.verify(req.body.password, user.password) { throw .unauthorized }

    let raw = crypto.random_hex(32)
    Token.create({ token_hash: crypto.sha256(raw), user_id: user.id })?   // ? propagates Result error
    { token: raw, username: user.username }
  }
}
```

---

# Part 11: Logging Pattern

Structured append-only logging using channels, typed structs, and path type. No `any` — everything is typed.

## Test 11.1: Typed channel-based logging

```forge
type AppEvent = {
  action: string,
  detail: string,
  timestamp: datetime,
}

let events = channel<AppEvent>(1000)

// Consumer persists to disk
spawn {
  let log = path("data/events.jsonl")
  for event in events {
    log.append(json.stringify(event) + "\n")
  }
}

fn main() {
  events <- AppEvent { action: "startup", detail: "", timestamp: now() }
  events <- AppEvent { action: "request", detail: "/health", timestamp: now() }

  sleep(100ms)   // let consumer flush
}
```

## Test 11.2: Reading logs back with typed parsing

```forge
fn main() {
  let log = path("data/events.jsonl")
  let entries = log.lines()?
    .filter(it.length > 0)
    .map(json.parse<AppEvent>(it))

  entries.each(e -> println(`${e.action}: ${e.detail}`))
}
```

## Test 11.3: Generic log function (no any)

```forge
fn log_to_file<T>(file: Path, data: T) {
  file.append(json.stringify(data) + "\n")
}

fn main() {
  let log = path("data/mixed.jsonl")
  log_to_file(log, AppEvent { action: "start", detail: "", timestamp: now() })
  log_to_file(log, AuditEvent { action: "publish", package: "x", version: "1.0", content_hash: "abc", timestamp: now() })
}
```

---

# Part 12: The Polished Registry (Before/After)

What the LLM should generate when it knows all these features:

```forge
use @std.http
use @std.model
use @std.auth
use @std.crypto

// ── Models ──

model Package {
  name: string @primary @min(1) @max(64) @validate(package_name)
  description: string
  keywords: List<string>
  latest_version: string
  owner: string
  created_at: datetime @default(now)

  // versions inferred from Version.@belongs_to(Package)
}

model Version {
  id: int @primary @auto_increment
  version: string @validate(semver)
  manifest: string
  context: string
  source_hash: string
  content_hash: string
  published_at: datetime @default(now)

  package_name: string @belongs_to(Package)

  on before_create(data) {
    data with { content_hash: crypto.sha256(data.manifest + data.context) }
  }
}

model User {
  id: int @primary @auto_increment
  username: string @unique @min(3) @max(32)
  email: string @unique @validate(email)
  password: string @hidden @min(8)
  created_at: datetime @default(now)

  on before_create(data) {
    data with { password: crypto.hash(data.password) }
  }
}

model Token {
  id: int @primary @auto_increment
  token_hash: string @unique
  user_id: int @belongs_to(User)
  created_at: datetime @default(now)
}

// ── Auth ──

auth {
  provider token {
    header "Authorization"
    prefix "Bearer "
    lookup (raw) -> {
      Token.find_by(.token_hash: crypto.sha256(raw))?.user
    }
  }

  role admin { all }
  role publisher { read, create, update_own }
  role anonymous { read }
}

// ── Logging ──

type AuditEvent = {
  action: string,
  package: string,
  version: string,
  content_hash: string,
  timestamp: datetime,
}

let audit = channel<AuditEvent>(1000)

spawn {
  let log = path("data/audit.jsonl")
  for event in audit {
    log.append(json.stringify(event) + "\n")
  }
}

// ── Server ──

server :8080 {
  cors true
  logging true

  middleware rate_limit {
    window 1m
    max_requests 100
    by (req) -> req.ip
  }

  on error(err, req) {
    respond(match err table {
      pattern          | status | body
      .not_found       | 404    | { error: "not found" }
      .unauthorized    | 401    | { error: "unauthorized" }
      .validation(e)   | 400    | { error: "validation failed", fields: e.fields }
      .rate_limited    | 429    | { error: "too many requests" }
      _                | 500    | { error: "internal error" }
    })
  }

  under /v1 {

    // ── Search ──

    @public
    GET /search -> (req) {
      let q = req.query.q ?? ""
      Package.where(.name: like(`%${q}%`))
        .or(.description: like(`%${q}%`))
        .include(.versions)
    }

    // ── Packages ──

    crud Package {
      paginate 50

      @public
      GET /packages
      GET /packages/:name

      @auth(.publisher)
      POST /packages
    }

    // ── Versions (nested under packages) ──

    under /packages/:name/versions {
      @public
      GET / -> (req) {
        let pkg = Package.find_by(.name: req.params.name) ?? throw .not_found
        Version.where(.package_name: pkg.name)
      }

      @public
      GET /:version -> (req) {
        Version.find_by(
          .package_name: req.params.name,
          .version: req.params.version,
        ) ?? throw .not_found
      }

      @auth(.publisher)
      POST / -> (req) {
        let pkg = Package.find_by(.name: req.params.name) ?? throw .not_found
        let v = Version.create(req.body with { package_name: pkg.name })?
        Package.update(pkg.name, { latest_version: v.version })
        audit <- AuditEvent {
          action: "publish",
          package: pkg.name,
          version: v.version,
          content_hash: v.content_hash,
          timestamp: now(),
        }
        v
      }
    }

    // ── Context ──

    @public
    GET /packages/:name/:version/context -> (req) {
      let v = Version.find_by(
        .package_name: req.params.name,
        .version: req.params.version,
      ) ?? throw .not_found

      { package: req.params.name, version: v.version, context: v.context }
    }

    // ── Auth ──

    @public
    POST /auth/register -> (req) {
      User.create(req.body)
    }

    @public
    POST /auth/token -> (req) {
      let user = User.find_by(.username: req.body.username) ?? throw .unauthorized
      if !crypto.verify(req.body.password, user.password) { throw .unauthorized }

      let raw = crypto.random_hex(32)
      Token.create({ token_hash: crypto.sha256(raw), user_id: user.id })?
      { token: raw, username: user.username }
    }

    // ── Audit Log ──

    @public
    GET /log -> {
      path("data/audit.jsonl").lines()?
        .filter(it.length > 0)
        .map(json.parse<AuditEvent>(it))
    }
  }
}
```

---

# Implementation Scope

## New Language Features

| Feature | Description | Tests |
|---|---|---|
| Contextual resolution (`.name`) | Dot-prefix resolves from context: fields, roles, variants | 1.1–1.6 |
| Match tables | `match x { pattern \| col \| col }` with header row | 2.1–2.5 |
| Match table as expression | `fn(match x table { ... })` — match table is an expression, passable to functions | 2.2 |
| Match table exhaustiveness | Compile error on missing patterns | 2.5 |
| Query operators | `gt()`, `lt()`, `like()`, `between()`, `after()`, `before()`, `contains()`, `starts_with()`, `ends_with()` | 3.1–3.5 |
| Query operator type checking | Compile error when operator doesn't match field type | 3.5 |
| Shorthand fields `{ name }` | Desugar `{ name }` to `{ name: name }` | 4.1–4.4 |
| `?? throw` | Null coalesce with throw on null | 6.1–6.3 |

## Features LLMs Need to Know About

These already exist but weren't used in the generated code. Need to be registered with `forge features` and documented so LLMs use them:

| Feature | What the LLM should write | What it wrote instead |
|---|---|---|
| Path type | `path("data") / "file.json"` | `forge_fs_join("data", "file.json")` |
| Path methods | `meta.read()?`, `dir.mkdir()?` | `forge_fs_read(path)`, `forge_fs_mkdir(path, true)` |
| json.stringify | `json.stringify({ name, version })` | Manual string concatenation |
| `with` expression | `data with { hash: computed }` | Manual struct rebuilding |
| Model CRUD | `Package.create()`, `.find_by()`, `.where()` | Manual JSON file reading |
| Shorthand fields | `{ action, package, version }` | `{ action: action, package: package }` |
| `?? throw` | `pkg ?? throw .not_found` | `if pkg == null { return error_json }` |
| `.include()` | `.include(.versions)` | Manual JOIN-like code |
| `under` blocks | `under /v1 { ... }` | Prefix every path with `/v1` |
| Auth component | `@auth(.publisher)` | Manual token checking |
| Validation annotations | `@min(1) @max(64) @validate(email)` | Manual `is_valid_*` functions |
| `match` with table | `respond(match err table { pattern \| s \| b ... })` | `if/else` chain returning JSON strings |
| Contextual `.field` | `.name: like(...)` | String-based field names |

## CLAUDE.md Addition

```markdown
## Idiomatic Forge Patterns

When generating Forge code, ALWAYS prefer:

- `path("x") / "y"` over string path manipulation
- `Model.where(.field: value)` over raw queries
- `json.stringify({ field1, field2 })` with shorthand over manual JSON strings
- `value ?? throw .error` over null checking with manual error returns
- `data with { new_field: value }` over manual struct rebuilding
- `@auth(.role)` and auth component over manual token checking
- `@min()`, `@max()`, `@validate()` annotations over manual validation functions
- `under /prefix { routes }` over repeating the prefix in every path
- `crud Model { ... }` for standard REST endpoints
- Match tables for multi-case error handling
- `.include(.relation)` for eager loading
- Contextual `.field` references in where clauses and annotations

Run `forge features` to see all available language features.
```
