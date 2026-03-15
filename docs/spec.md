# The Forge Language Specification

**Version:** 0.2.0-draft
**Status:** Design Specification
**Date:** March 2026
**Revision:** 2 — incorporates immutability-by-default, trait system, package-based models, revised imports, error propagation (`?`/`catch`/`errdefer`), `it` implicit closures, deployment primitives, CLI support, observability, and expanded standard package library.

---

## Table of Contents

1. [Overview](#1-overview)
2. [Design Principles](#2-design-principles)
3. [Core Language](#3-core-language)
4. [Type System](#4-type-system)
5. [Traits and Interfaces](#5-traits-and-interfaces)
6. [Models and Persistence](#6-models-and-persistence)
7. [Services](#7-services)
8. [Package System](#8-package-system)
9. [Standard Packages](#9-standard-packages)
10. [Concurrency and Parallelism](#10-concurrency-and-parallelism)
11. [Error Handling](#11-error-handling)
12. [Module System](#12-module-system)
13. [Embedded Sublanguages](#13-embedded-sublanguages)
14. [External Language Bridge](#14-external-language-bridge)
15. [Toolchain](#15-toolchain)
16. [LLM and Agent Ergonomics](#16-llm-and-agent-ergonomics)
17. [Memory Management](#17-memory-management)
18. [Testing and Benchmarking](#18-testing-and-benchmarking)
19. [Project Structure](#19-project-structure)
20. [Standard Library](#20-standard-library)
21. [Deployment](#21-deployment)
22. [CLI Applications](#22-cli-applications)
23. [Observability](#23-observability)
24. [Mobile Support](#24-mobile-support)
25. [Implementation Roadmap](#25-implementation-roadmap)
26. [Open Questions](#26-open-questions)

---

## 1. Overview

Forge is a compiled, statically-typed programming language designed for building agent-oriented services, APIs, and tools. It prioritizes developer ergonomics, vibe-coding with LLM assistance, and the ability to orchestrate complex systems with minimal boilerplate.

Forge compiles to native code via LLVM, producing single binaries with no runtime dependency. It is designed to be the orchestration surface for modern software — providing high-level primitives for common infrastructure (HTTP servers, queues, databases, WebSockets) while allowing breakout into Rust, Go, C, or other languages for performance-critical components.

### What Forge Is

- An orchestration language with first-class infrastructure primitives
- A compiled language producing single static binaries via LLVM
- An extensible language where new keywords and syntax blocks are added via packages
- An agent-friendly language with machine-readable errors and context-loadable specs
- A polyglot host that can embed components written in other languages

### What Forge Is Not

- A systems programming language (use Rust/C for that, and bridge it in)
- A replacement for general-purpose languages (it's the glue between them)
- An interpreted scripting language (it compiles to native code)
- A framework (it's a language with a framework-level standard library)

### Hello World

```forge
use @std.http.{server, route}

server :8080 {
  route GET /hello -> { message: "hello world" }
}
```

Compile and run:

```bash
forge build
./build/my-service
# => Server started on :8080
```

### Motivating Example

```forge
use @std.http.{server, route, mount}
use @std.queue.{queue, worker, enqueue}
use @std.cron.schedule
use @std.ai.{agent, tool, prompt}
use @std.model.{model, service}

model User {
  id: uuid @primary
  email: string @unique @validate(email)
  name: string
  role: enum(admin, member, viewer)
  created: timestamp @default(now)
}

model Task {
  id: uuid @primary
  owner: User @relation
  title: string
  status: enum(pending, active, done, failed)
  due: timestamp?
}

service TaskService for Task {
  before create(task) {
    assert task.title.length > 0, "title required"
  }

  after create(task) {
    emit task_created(task)
    enqueue notification_queue { type: "new_task", task: task }
  }

  fn assign(task, user: User) {
    task.owner = user
    task.status = .active
    save task
    emit task_assigned(task, user)
  }
}

agent support_bot {
  model: "claude-sonnet"

  tool lookup_task(id: string) -> Task? {
    TaskService.get(id)
  }

  tool assign_task(task_id: string, user_email: string) {
    let task = TaskService.get(task_id) ?? panic("task not found")
    let user = UserService.get_by(email: user_email) ?? panic("user not found")
    TaskService.assign(task, user)
  }

  prompt system {
    You help users manage their tasks. Be concise and helpful.
  }

  on message(input) -> stream {
    respond(input)
  }
}

worker notification_worker {
  consume notification_queue
  concurrency: 4

  on message(msg) {
    match msg.type {
      "new_task" -> send_email(msg.task.owner.email, "New task: ${msg.task.title}")
      _ -> log.warn("unknown notification type: ${msg.type}")
    }
  }
}

schedule daily at "09:00 UTC" {
  let stale = sql {
    SELECT * FROM tasks
    WHERE status = 'active' AND updated_at < now() - interval '7 days'
  }
  for task in stale {
    TaskService.update(task, status: .failed)
  }
}

server :8080 {
  middleware [cors, auth, rate_limit(100/min)]

  mount TaskService at /tasks
  mount UserService at /users
  mount support_bot at /chat

  route GET /dashboard -> {
    active_tasks: TaskService.count(status: .active),
    users: UserService.count(),
    queue_depth: notification_queue.depth()
  }
}
```

This single file defines data models, business logic, an AI agent, background workers, scheduled jobs, and an HTTP API. It compiles to one binary.

---

## 2. Design Principles

### 2.1 Convention Over Configuration (With Escape Hatches)

Forge provides sensible defaults for everything. Defining a model automatically persists it. Defining a service automatically generates CRUD. But every default is overridable.

### 2.2 Describe What, Not How

The language is declarative where possible, imperative when needed. You declare a server, a queue, a schedule — you don't manually set up sockets, thread pools, or cron daemons.

### 2.3 Packages, Not Frameworks

New capabilities are added through the package system rather than baked into the language. The core language is intentionally tiny. Packages register new keywords, syntax blocks, and compile-time behavior.

### 2.4 Single Binary, No Runtime

Forge compiles to a self-contained native binary via LLVM. No JVM, no interpreter, no container required. This enables edge deployment, embedding, and simple operations.

### 2.5 Agent-First Ergonomics

Error messages are machine-parseable. The language spec fits in an LLM context window. The toolchain provides commands for generating LLM-friendly context. Vibe-coding is a first-class workflow.

### 2.6 Polyglot By Design

Forge doesn't replace Rust, Go, or Python. It orchestrates components that may be written in those languages, linked via a typed foreign function interface.

---

## 3. Core Language

### 3.1 Keywords

The core language has a minimal set of reserved keywords. All other keywords (like `server`, `queue`, `agent`, etc.) are introduced by packages.

**Core keywords:**

```
let       mut       const     fn        return
if        else      match     for
in        while     break     continue
enum      type      use       as
export    emit      on        true      false
null      yield     trait     impl
defer     errdefer  spawn     parallel
with
```

Note: `model`, `service`, `server`, `queue`, `agent`, and other domain keywords are introduced by packages, not the core language.

**Reserved for future use:**

```
async     await     select    comptime
macro     where
```

### 3.2 Variables

Variables are **immutable by default**. Use `mut` for mutable bindings and `const` for compile-time constants.

```forge
let name = "alice"              // immutable, type inferred as string
name = "bob"                    // ERROR: cannot reassign immutable binding

mut counter = 0                 // mutable (opt-in)
counter = counter + 1           // OK

let age: int = 30               // explicit type annotation
let score = 0.95                // inferred as float

const MAX_RETRIES = 3           // compile-time constant
```

Immutable-by-default makes concurrent code safer (immutable data can be shared freely), reduces bugs from unintended mutation, and encourages functional transformation patterns via `with`, `|>`, and `map`/`filter`.

### 3.3 Basic Types

```forge
// Primitives
int                         // 64-bit signed integer
float                       // 64-bit floating point
bool                        // true or false
string                      // UTF-8 string
char                        // single Unicode character

// Special types
uuid                        // UUID v4
timestamp                   // UTC timestamp with nanosecond precision
duration                    // time duration (e.g., 5m, 2h, 30s)
bytes                       // raw byte buffer
json                        // dynamic JSON value
void                        // no return value
never                       // function never returns (panics, infinite loop)
```

### 3.4 Composite Types

```forge
// Arrays
let names: List<string> = ["alice", "bob", "charlie"]
let matrix: List<List<int>> = [[1, 2], [3, 4]]

// Maps
let scores: Map<string, int> = { "alice": 95, "bob": 87 }

// Tuples
let pair: (string, int) = ("alice", 30)
let (name, age) = pair     // destructuring

// Sets
let tags: Set<string> = #{"urgent", "bug", "frontend"}
```

### 3.5 Strings

Double quotes for strings. Backticks for template literals with **compile-time type checking**. No single-quote strings.

```forge
let name = "alice"
let greeting = `hello ${name}`
let multiline = `
  this is a
  multiline string
`

// Format specifiers — compiler checks type matches specifier
let price = 19.99
let formatted = `price: ${price:.2f}`     // "price: 19.99"
let padded = `id: ${id:>10}`              // right-pad to 10 chars

// Compile-time safety examples:
let nums: List<int> = [1, 2, 3]
let bad = `items: ${nums}`                // ERROR: List<int> doesn't implement Display
                                          // Help: use nums.join(", ")

let y = 42
let bad2 = `result: ${y:.2f}`            // ERROR: float format specifier on int

// String operations
name.length                 // 5
name.upper()                // "ALICE"
name.contains("li")         // true
name.split(",")             // List<string>
name.trim()                 // trimmed string
name.replace("a", "A")     // "Alice" (first occurrence)
name.replace_all("a", "A") // "Alice" (only one 'a' here but replaces all)
```

### 3.6 Functions

```forge
// Basic function
fn greet(name: string) -> string {
  `hello ${name}`           // last expression is return value
}

// Multiple return via tuples
fn divide(a: float, b: float) -> (float, float) {
  (a / b, a % b)
}

// Named parameters with defaults
fn paginate(items: List<any>, page: int = 1, per_page: int = 20) -> List<any> {
  let start = (page - 1) * per_page
  items.slice(start, start + per_page)
}

// Call with named params
paginate(my_list, page: 3, per_page: 50)

// Closures — arrow syntax
let double = (x: int) -> x * 2

// Single arg — parens optional
let double = x -> x * 2

// Multi-line closure
let process = (item: Task) -> {
  validate(item)
  transform(item)
}

// Implicit `it` parameter for single-argument closures
users.filter(it.active)                    // equivalent to: u -> u.active
users.map(it.name)                         // equivalent to: u -> u.name
users.sort_by(it.created)                  // equivalent to: u -> u.created
tasks.map(process(it))                     // equivalent to: t -> process(t)
users.filter(it.age > 18 && it.active)     // compound expressions work

// Multiple args still need explicit params
scores.reduce(0, (sum, n) -> sum + n)
```

### 3.7 Control Flow

```forge
// If/else (expression — returns a value, no ternary needed)
let status = if score > 0.9 { "excellent" } else { "good" }

// Match (exhaustive pattern matching)
match user.role {
  .admin -> grant_all_permissions(user)
  .member -> grant_standard_permissions(user)
  .viewer -> grant_read_only(user)
}

// Match with guards
match task {
  { status: .active, due: d } if d < now() -> escalate(task)
  { status: .active } -> process(task)
  { status: .done } -> archive(task)
  _ -> skip()
}

// Match with variable comparison (no pin operator needed)
// If a variable exists in scope, it's a comparison; if not, it's a binding
let expected = .active
match task {
  { status: expected } -> process(task)  // compares against existing variable
  { status: new_status } -> log(`unexpected: ${new_status}`)  // binds new variable
}

// let else — unwrap or diverge (for nullable types)
let user = get_user(id) else {
  return respond(404, "not found")
}
// user is unwrapped (non-null) and in scope here

// if let — conditional unwrapping
if let user = get_user(id) {
  process(user)
}

// For loops
for user in users {
  notify(user)
}

// For with index
for (i, user) in users.enumerate() {
  log.info(`processing user ${i + 1} of ${users.length}`)
}

// For with map entries
for (key, value) in scores {
  log.info(`${key}: ${value}`)
}

// While
while queue.depth() > 0 {
  process(queue.pop())
}

// Loop (infinite, with break value)
let result = loop {
  if let answer = try_compute() {
    break answer
  }
}

// Labeled breaks
outer: for row in matrix {
  for cell in row {
    if cell == target { break outer }
  }
}

// Pipe operator for chaining
users
  |> filter(it.active)
  |> map(it.email)
  |> each(send_newsletter(it))

// With expression — immutable update (copy and modify)
let updated_user = user with { role: .admin, name: "Alice" }
let prod_config = dev_config with {
  database.host: "prod-db",
  database.port: 5432,
  log_level: "warn"
}
```

### 3.8 Ranges

Ranges use Kotlin-style readable syntax with Rust-style lazy evaluation. Ranges are iterators — they don't allocate a collection upfront.

```forge
0..10                  // exclusive: 0,1,2,...,9 (lazy iterator)
0..=10                 // inclusive: 0,1,2,...,10
10.down_to(0)          // reverse: 10,9,8,...,0
0..100 step 2          // stepped: 0,2,4,...,98

// Lazy composition — O(1) memory regardless of range size
let result = (0..1_000_000)
  .filter(it % 3 == 0)
  .map(it * it)
  .take(5)
  .to_list()           // [0, 9, 36, 81, 144]

// In for loops
for i in 0..users.length {
  println(`${i}: ${users[i].name}`)
}
```

### 3.9 Enums

```forge
// Simple enum
enum Color { red, green, blue }

// Enum with associated data (algebraic data types)
enum Shape {
  circle(radius: float)
  rectangle(width: float, height: float)
  point
}

let s = Shape.circle(radius: 5.0)

match s {
  .circle(r) -> 3.14159 * r * r
  .rectangle(w, h) -> w * h
  .point -> 0.0
}

// Inline enums in models (no separate declaration needed)
// (when using @std.model package)
// status: enum(pending, active, done, failed)
```

### 3.10 Destructuring

TypeScript-style destructuring for all composite types:

```forge
// Object/struct destructuring
let { name, age, role } = user
let { name, age: years } = user              // rename
let { name, role = "member" } = data         // default value
let { address: { city, zip } } = user        // nested

// Array destructuring
let [first, second, ...rest] = items
let [head, _, third] = list                  // skip elements

// Tuple destructuring
let (x, y) = get_coordinates()
let (_, count) = measure()                   // ignore first

// In function parameters
fn greet({ name, role }: User) -> string {
  `hello ${name} (${role})`
}

// In for loops
for { title, status } in tasks {
  println(`${title}: ${status}`)
}
```

### 3.11 Comments

```forge
// Single line comment

/*
  Multi-line
  comment
*/

/// Documentation comment (attached to the next declaration)
/// Supports markdown formatting.
fn important_function() { }
```

---

## 4. Type System

Forge uses a structural type system inspired by TypeScript. Types are checked by shape, not by name.

### 4.1 Structural Typing

```forge
type HasName = { name: string }
type HasEmail = { email: string }

fn greet(thing: HasName) -> string {
  `hello ${thing.name}`
}

// Works with any type that has a 'name' field
greet(user)    // User has name: string — OK
greet(task)    // Task has title, not name — ERROR
greet({ name: "anon" })  // anonymous struct — OK
```

### 4.2 Type Aliases and Intersections

```forge
type Identifiable = { id: uuid }
type Timestamped = { created: timestamp, updated: timestamp }
type BaseModel = Identifiable & Timestamped

// Union types
type StringOrNumber = string | int
type ApiResponse = SuccessResponse | ErrorResponse
```

### 4.3 Generics

```forge
fn first<T>(list: List<T>) -> T? {
  if list.length > 0 { list[0] } else { null }
}

fn map_values<K, V, R>(m: Map<K, V>, f: (V) -> R) -> Map<K, R> {
  let result: Map<K, R> = {}
  for (k, v) in m {
    result[k] = f(v)
  }
  result
}

// Constrained generics
fn soft_delete<T: { deleted_at: timestamp? }>(record: T) {
  record.deleted_at = now()
  save record
}
```

### 4.4 Nullable Types (Kotlin-style)

Null safety is enforced by the type system. A type is non-nullable by default. Append `?` to make it nullable.

```forge
let name: string = "alice"     // cannot be null
let nickname: string? = null   // explicitly nullable

// Compiler forces null handling
nickname.upper()               // ERROR: nickname might be null
nickname?.upper()              // OK: returns string? (null propagation)
nickname?.upper() ?? "N/A"     // OK: returns string (with default)
nickname!.upper()              // OK: runtime assertion (panics if null)

// Smart narrowing
if nickname != null {
  // nickname is string (not string?) inside this block
  print(nickname.upper())      // OK
}

// Null coalescing assignment
let display = nickname ?? "anonymous"

// Nullable chaining
let city = user?.address?.city ?? "unknown"
```

### 4.5 Type Inference

Forge infers types locally within function bodies. Function signatures require explicit type annotations for parameters and return types.

```forge
// Inferred
let x = 42                     // int
let names = ["a", "b"]         // List<string>
let scores = { "a": 1 }       // Map<string, int>

// Required annotations at boundaries
fn add(a: int, b: int) -> int {   // params and return type explicit
  let result = a + b               // result type inferred as int
  result
}

// Annotations optional for obvious closures
users.filter((u) -> u.active)      // u inferred from List<User>
```

### 4.6 Literal Types

```forge
type Direction = "north" | "south" | "east" | "west"
type HttpMethod = "GET" | "POST" | "PUT" | "DELETE" | "PATCH"
type DiceRoll = 1 | 2 | 3 | 4 | 5 | 6
```

### 4.7 Type Assertions and Casting

```forge
let value: json = get_dynamic_data()

// Safe cast (returns nullable)
let name = value as? string        // string?

// Assertion cast (panics if wrong)
let name = value as! string        // string (or panic)

// Type checking
if value is string {
  // value is narrowed to string here
  print(value.upper())
}
```

---

## 5. Traits and Interfaces

Forge uses a hybrid type contract system: **structural types** for data shape requirements (TypeScript-style, from Section 4) and **traits** for behavior contracts (Rust-style). They coexist and serve different purposes.

### 5.1 Trait Declaration

```forge
trait Serializable {
  fn to_json(self) -> json
  fn from_json(data: json) -> Result<Self, Error>
}

trait Drawable {
  fn draw(self)
  fn area(self) -> float

  // Default implementation — implementors get this for free
  fn describe(self) -> string {
    `shape with area ${self.area()}`
  }
}
```

### 5.2 Implementing Traits

```forge
impl Drawable for Circle {
  fn draw(self) { println(`circle r=${self.radius}`) }
  fn area(self) -> float { 3.14159 * self.radius * self.radius }
  // describe() comes from the default
}
```

### 5.3 Trait Bounds on Generics

```forge
fn draw_all<T: Drawable>(items: List<T>) {
  for item in items { item.draw() }
}

// Multiple trait bounds
fn process<T: Serializable & Drawable>(item: T) {
  item.draw()
  let data = item.to_json()
  save(data)
}
```

### 5.4 When to Use Structural Types vs Traits

Use **structural types** for simple data shape requirements:
```forge
type HasName = { name: string }
fn greet(thing: HasName) -> string { `hello ${thing.name}` }
// Works with anything that has a name field — no declaration needed
```

Use **traits** for behavior contracts with methods and defaults:
```forge
trait Cacheable {
  fn cache_key(self) -> string
  fn ttl(self) -> duration { 5m }    // default TTL
}
```

### 5.5 Standard Traits

The following traits are defined in the core language:

| Trait | Methods | Used For |
|---|---|---|
| `Display` | `fn display(self) -> string` | String interpolation, printing |
| `Eq` | `fn eq(self, other: Self) -> bool` | Equality comparison |
| `Ord` | `fn cmp(self, other: Self) -> Ordering` | Sorting, comparison operators |
| `Hash` | `fn hash(self) -> int` | Map keys, Set membership |
| `Clone` | `fn clone(self) -> Self` | Explicit copying |
| `Drop` | `fn drop(self)` | Cleanup when value goes out of scope |
| `Default` | `fn default() -> Self` | Default values |

Standard traits are auto-derived for simple types. Models auto-derive `Display`, `Eq`, `Clone`, `Serializable`.

### 5.6 Operator Overloading via Traits

Known operators can be overloaded by implementing the corresponding trait:

```forge
trait Add<Rhs = Self> {
  type Output
  fn add(self, rhs: Rhs) -> Self.Output
}

impl Add for Vector2D {
  type Output = Vector2D
  fn add(self, rhs: Vector2D) -> Vector2D {
    Vector2D { x: self.x + rhs.x, y: self.y + rhs.y }
  }
}

let v3 = v1 + v2  // calls v1.add(v2)
```

Only known operators (`+`, `-`, `*`, `/`, `%`, `==`, `<`, `>`, `[]`) can be overloaded. Custom operators are not supported.

---

## 6. Models and Persistence

Models are provided by `@std/model` and define both the shape of data and its persistence behavior. By default, models auto-persist to the configured database (SQLite by default).

### 6.1 Model Declaration

```forge
use @std.model.{model, service}

model User {
  id: uuid @primary
  email: string @unique @validate(email)
  name: string
  bio: string?                    // nullable field
  role: enum(admin, member, viewer) @default(.member)
  active: bool @default(true)
  created: timestamp @default(now)
  updated: timestamp @default(now) @on_update(now)
}
```

### 5.2 Field Annotations

| Annotation | Description |
|---|---|
| `@primary` | Primary key field |
| `@unique` | Unique constraint |
| `@index` | Create database index |
| `@default(value)` | Default value |
| `@validate(rule)` | Validation rule (email, url, min, max, regex, custom fn) |
| `@relation` | Foreign key relation to another model |
| `@on_update(fn)` | Run on update (e.g., timestamp refresh) |
| `@json_name("name")` | Override JSON serialization key |
| `@redact` | Exclude from serialization (passwords, tokens) |

### 5.3 Relations

```forge
model User {
  id: uuid @primary
  name: string
  posts: List<Post> @has_many
}

model Post {
  id: uuid @primary
  author: User @relation               // FK to User
  title: string
  tags: List<Tag> @many_to_many
}

model Tag {
  id: uuid @primary
  name: string @unique
}
```

### 5.4 Auto-Generated Operations

Every model automatically gets the following operations (via auto-generated service):

```forge
// These exist implicitly for every model
User.create({ name: "alice", email: "alice@example.com" })
User.get(id)                    // -> User?
User.get_by(email: "alice@example.com") // -> User?
User.list()                     // -> List<User>
User.list(role: .admin)         // -> List<User> (filtered)
User.update(user, { name: "Alice" })
User.delete(id)
User.count()                    // -> int
User.count(active: true)        // -> int (filtered)
User.exists(id)                 // -> bool
```

### 5.5 Persistence Configuration

```forge
// In forge.toml — project-level config
[database]
default = "sqlite"              // "sqlite", "postgres", "mysql"
path = "./data/forge.db"        // SQLite path

// Or per-model override via annotation
@persist(postgres("postgresql://localhost/mydb"))
model AnalyticsEvent {
  id: uuid @primary
  event: string
  data: json
  created: timestamp @default(now)
}

// Or opt out of persistence entirely
@transient
model TemporaryResult {
  score: float
  label: string
}
```

### 5.6 Migrations

Forge auto-generates migrations by comparing model definitions against the current database schema.

```bash
# Generate migration from model changes
forge migrate create

# Preview SQL that will run
forge migrate preview

# Apply pending migrations
forge migrate run

# Rollback last migration
forge migrate rollback

# Migration status
forge migrate status
```

Migration files are stored in `./migrations/` as timestamped SQL files that can be reviewed and edited before applying.

```
migrations/
  20260310_120000_create_users.sql
  20260310_120001_create_tasks.sql
  20260311_090000_add_user_bio.sql
```

---

## 6. Services

Services define business logic around models. They wrap auto-generated CRUD with custom behavior, hooks, and additional methods.

### 6.1 Service Declaration

```forge
service TaskService for Task {
  // Lifecycle hooks
  before create(task) {
    assert task.title.length > 0, "title required"
    task.status = .pending
  }

  after create(task) {
    emit task_created(task)
    log.info(`task created: ${task.id}`)
  }

  before update(task, changes) {
    changes.updated = now()
  }

  before delete(task) {
    assert task.status != .active, "cannot delete active tasks"
  }

  // Custom methods
  fn assign(task, user: User) -> Task {
    task.owner = user
    task.status = .active
    save task
    emit task_assigned(task, user)
    task
  }

  fn complete(task) -> Task {
    task.status = .done
    task.completed_at = now()
    save task
    emit task_completed(task)
    task
  }

  // Custom query methods
  fn overdue() -> List<Task> {
    sql {
      SELECT * FROM tasks
      WHERE status = 'active' AND due < now()
      ORDER BY due ASC
    }
  }
}
```

### 6.2 Service Hooks

| Hook | Trigger | Arguments |
|---|---|---|
| `before create` | Before insert | `(record)` |
| `after create` | After insert | `(record)` |
| `before update` | Before update | `(record, changes)` |
| `after update` | After update | `(record, old_record)` |
| `before delete` | Before delete | `(record)` |
| `after delete` | After delete | `(record)` |

### 6.3 Events

Services can emit and listen to events:

```forge
// Emitting (in a service method)
emit task_created(task)

// Listening (anywhere)
on task_created(task) {
  send_notification(task.owner, `New task: ${task.title}`)
}

// Events with custom payloads
emit payment_processed({
  order_id: order.id,
  amount: order.total,
  method: "card"
})

on payment_processed(event) {
  log.info(`payment of ${event.amount} for order ${event.order_id}`)
}
```

Events are local by default (in-process pub/sub). Packages can extend events to be distributed (e.g., via Redis, Kafka).

---

## 7. Package System

The package system is Forge's core extensibility mechanism. Packages are compiler plugins that register new keywords, syntax blocks, and compile-time transformations. They are backed by native implementations in any language.

### 7.1 Concept

The core Forge language is intentionally minimal (~20 keywords). All infrastructure primitives — servers, queues, WebSockets, AI agents — are added by packages. This means:

- `server` is not a keyword until you import `@std/http`
- `queue` is not a keyword until you import `@std/queue`
- `agent` is not a keyword until you import `@std/ai`

Packages are declared in `forge.toml` and imported in source files.

### 7.2 Using Packages

```forge
// forge.toml
[packages]
"@std/http" = "0.1.0"
"@std/queue" = "0.1.0"
"@community/graphql" = "0.3.2"
```

```forge
// In source files
use @std.http.{server, route, middleware}
use @std.queue.{queue, worker}
use @community.graphql
```

### 7.3 Package Architecture

A package consists of:

1. **Syntax definitions** — what new keywords/blocks are introduced
2. **Compile-time transformer** — how those blocks lower to core language + native calls
3. **Native library** — the actual implementation (compiled Rust, Go, C, etc.)
4. **Type definitions** — types the package adds to the type system
5. **Metadata** — name, version, documentation, dependencies

### 7.4 Package Manifest

Every package has a `package.toml`:

```toml
[package]
name = "http"
namespace = "std"
version = "0.1.0"
description = "HTTP server, routing, and middleware"
language = "rust"
license = "MIT"

[keywords]
server = "block"          # introduces a { } block
route = "statement"       # single statement within a server block
middleware = "modifier"    # modifies a block
mount = "statement"       # mounts a service

[dependencies.native]
hyper = "1.0"
tokio = { version = "1", features = ["full"] }

[interface]
types = "types.forge"     # type definitions file
schema = "package.wit"   # interface definition
```

### 7.5 Package Syntax Registration

Packages register keyword patterns using a structured grammar:

```
keyword server:
  pattern: "server" <name:ident>? ":" <port:int_literal> <body:block>
  valid_children: [route, middleware, mount, ws]

keyword route:
  pattern: "route" <method:HTTP_METHOD> <path:path_pattern> "->" <handler:expr_or_block>
  context: server  // only valid inside a server block

keyword middleware:
  pattern: "middleware" "[" <handlers:expr_list> "]"
  context: server
```

### 7.6 Package Implementation (Rust Example)

```rust
// src/lib.rs for @std/http package
use forge_package_sdk::prelude::*;

#[forge_keyword("server")]
pub struct ServerBlock {
    pub name: Option<String>,
    pub port: u16,
    pub routes: Vec<Route>,
    pub middleware: Vec<MiddlewareRef>,
    pub mounts: Vec<Mount>,
}

#[forge_compile]
impl ServerBlock {
    /// Transforms the server block into native function calls.
    /// Called at compile time by the Forge compiler.
    fn lower(&self, ctx: &mut CompileContext) -> Result<NativeIR> {
        // Generate LLVM IR that calls into the native http library
        let server_init = ctx.call_native("forge_http_server_create", &[
            ctx.const_u16(self.port),
        ]);

        for route in &self.routes {
            ctx.call_native("forge_http_add_route", &[
                server_init,
                ctx.const_str(&route.method),
                ctx.const_str(&route.path),
                ctx.fn_ref(&route.handler),
            ]);
        }

        for mount in &self.mounts {
            ctx.call_native("forge_http_mount_service", &[
                server_init,
                ctx.const_str(&mount.path),
                ctx.service_ref(&mount.service),
            ]);
        }

        ctx.call_native("forge_http_server_start", &[server_init]);
        Ok(server_init)
    }
}

/// The native C ABI functions that the compiled binary links against.
#[no_mangle]
pub extern "C" fn forge_http_server_create(port: u16) -> *mut Server {
    // Actual hyper/tokio server creation
    let server = Server::new(port);
    Box::into_raw(Box::new(server))
}

#[no_mangle]
pub extern "C" fn forge_http_server_start(server: *mut Server) {
    let server = unsafe { &*server };
    server.start_blocking();
}
```

### 7.7 Package Interface Contract

Packages expose their interface through a `.wit`-inspired definition file:

```wit
// package.wit for @std/http
interface http-package {
  record server-config {
    port: u16,
    host: option<string>,
  }

  record route-config {
    method: string,
    path: string,
  }

  resource server {
    constructor(config: server-config)
    add-route: func(config: route-config, handler: func-ref) -> result<void, error>
    mount-service: func(path: string, service: service-ref) -> result<void, error>
    start: func() -> result<void, error>
    shutdown: func() -> result<void, error>
  }
}
```

### 7.8 Package Composability

Packages declare what resources they claim and the compiler prevents conflicts:

```toml
# In package.toml
[resources]
claims = ["tcp:port"]     # This package binds TCP ports
conflicts = []            # Explicit conflict declarations

[resources.shared]
uses = ["models", "events"]  # Can read models and emit events
```

If two packages both claim `tcp:port` in the same project, the compiler emits an error:

```
ERROR[E0201]: resource conflict at forge.toml

  Packages @std/http and @community/grpc both claim resource "tcp:port".

  Options:
    1. Configure distinct ports: @std/http on :8080, @community/grpc on :9090
    2. Use @community/grpc-http which shares the HTTP transport
```

### 7.9 Swappable Implementations

Packages conform to interfaces, allowing implementation swaps:

```toml
# forge.toml — use a different HTTP engine
[packages]
"@std/http" = { version = "0.1.0", impl = "@community/http-bun" }
```

The syntax in your source code stays identical. Only the compiled native code changes.

---

## 8. Standard Packages

These packages ship with Forge and are maintained as part of the core distribution.

### 8.1 @std/http — HTTP Server

**Keywords:** `server`, `route`, `middleware`, `mount`, `redirect`

```forge
use @std.http.{server, route, middleware, mount}

server :8080 {
  middleware [cors, auth, rate_limit(100/min)]

  route GET /health -> { status: "ok" }

  route GET /users/:id -> (req) {
    let user = UserService.get(req.params.id)
    user ?? respond(404, { error: "not found" })
  }

  route POST /users -> (req) {
    UserService.create(req.body)
  }

  mount TaskService at /tasks     // auto-generates REST endpoints:
                                  // GET /tasks, GET /tasks/:id,
                                  // POST /tasks, PUT /tasks/:id,
                                  // DELETE /tasks/:id
}
```

**Backed by:** Rust (hyper + tokio)

### 8.2 @std/sql — Database and Queries

**Keywords:** `sql` (embedded block), `migrate`

Provides the persistence layer for models, raw SQL blocks, and migration tooling.

```forge
use @std.sql

// Raw SQL with compile-time validation against models
let active_users = sql {
  SELECT u.*, count(t.id) as task_count
  FROM users u
  LEFT JOIN tasks t ON t.owner_id = u.id
  WHERE u.active = true
  GROUP BY u.id
  HAVING count(t.id) > 5
}
// Type: List<{ ...User, task_count: int }>

// Parameterized queries (safe from injection)
fn find_by_role(role: string) -> List<User> {
  sql {
    SELECT * FROM users WHERE role = ${role}
  }
}
```

**Backed by:** Rust (sqlx) with drivers for SQLite, PostgreSQL, MySQL

### 8.3 @std/queue — Message Queues

**Keywords:** `queue`, `worker`, `enqueue`, `consume`

```forge
use @std.queue.{queue, worker, enqueue}

queue email_queue {
  max_retries: 3
  backoff: exponential
  dead_letter: failed_emails
  persistence: true            // survive restarts
}

worker email_sender {
  consume email_queue
  concurrency: 4

  on message(msg) {
    send_email(msg.to, msg.subject, msg.body)
  }

  on error(err, msg) {
    log.error(`failed to send email: ${err}`)
  }

  on dead_letter(msg) {
    alert("email permanently failed", msg)
  }
}

// Enqueue from anywhere
enqueue email_queue {
  to: user.email,
  subject: "Welcome!",
  body: `Hello ${user.name}`
}
```

**Backed by:** Rust (in-process persistent queue, with option to swap to Redis/RabbitMQ)

### 8.4 @std/ws — WebSockets

**Keywords:** `ws`, `broadcast`, `subscribe`

```forge
use @std.ws.{ws, broadcast}

server :8080 {
  // WebSocket endpoint inside a server block
  ws /live {
    on connect(client) {
      log.info(`client connected: ${client.id}`)
      client.send(current_state())
    }

    on message(client, msg) {
      match msg.type {
        "subscribe" -> client.join(msg.channel)
        "unsubscribe" -> client.leave(msg.channel)
      }
    }

    on disconnect(client) {
      log.info(`client disconnected: ${client.id}`)
    }
  }
}

// Broadcast from anywhere
on task_created(task) {
  broadcast("tasks", { type: "new_task", task: task })
}
```

**Backed by:** Rust (tokio-tungstenite)

### 8.5 @std/cron — Scheduled Tasks

**Keywords:** `schedule`

```forge
use @std.cron.schedule

schedule every 5m {
  log.info("health check")
  check_external_services()
}

schedule daily at "09:00 UTC" {
  generate_daily_report()
}

schedule cron "0 */2 * * *" {   // every 2 hours
  sync_external_data()
}
```

**Backed by:** Rust (tokio-cron-scheduler)

### 8.6 @std/ai — AI and Agent Integration

**Keywords:** `agent`, `tool`, `prompt`

```forge
use @std.ai.{agent, tool, prompt}

agent my_agent {
  model: "claude-sonnet"           // or "gpt-4o", "gemini-pro", etc.
  temperature: 0.7
  max_tokens: 4096

  tool get_weather(city: string) -> WeatherData {
    fetch_weather_api(city)
  }

  tool search_docs(query: string) -> List<Document> {
    DocumentService.search(query)
  }

  prompt system {
    You are a helpful assistant. Use tools when you need real data.
    Be concise and accurate.
  }

  on message(input: string) -> stream {
    respond(input)
  }

  on tool_error(tool_name: string, err: Error) {
    log.warn(`tool ${tool_name} failed: ${err}`)
    respond("I had trouble accessing that information. Let me try another way.")
  }
}
```

**Backed by:** Rust (HTTP client calling package APIs)

### 8.7 @std/log — Structured Logging

**Keywords:** (none — provides the `log` global)

```forge
use @std.log

log.info("server started", { port: 8080 })
log.warn("slow query", { duration_ms: 1500, query: "SELECT ..." })
log.error("request failed", { error: err, request_id: req.id })
log.debug("processing item", { item: item })
```

### 8.8 @std/test — Testing Framework

**Keywords:** `test`, `describe`, `expect`

See [Section 17: Testing](#17-testing) for full details.

### 8.9 @std/env — Configuration

**Keywords:** (none — provides the `env` global and config loading)

```forge
use @std.env.{env, config}

// Environment variables with typed defaults
let port = env.get("PORT", 8080)              // int
let debug = env.get("DEBUG", false)            // bool
let db_url = env.require("DATABASE_URL")       // panics if missing

// Config file loading (TOML, JSON, YAML)
let cfg = config.load("./config.toml")
let db_host = cfg.get("database.host", "localhost")
```

---

## 10. Concurrency and Parallelism

Forge distinguishes between **concurrency** (many tasks sharing threads, for I/O) and **parallelism** (tasks on separate OS threads, for CPU). The language manages both automatically, with opt-in control when needed.

### 10.1 Implicit Async

All I/O operations are non-blocking under the hood. The developer writes code that looks synchronous:

```forge
// These are concurrent (I/O) — many tasks, few OS threads
let user = UserService.get(id)             // DB query, non-blocking
let weather = fetch_weather("SF")          // HTTP call, non-blocking
let result = process(data)                 // CPU work, runs on thread pool
```

### 10.2 Explicit Parallelism

When you want to run things concurrently and wait for all results:

```forge
// Parallel execution — true OS threads
let (users, tasks, metrics) = parallel {
  UserService.list()
  TaskService.list(status: .active)
  fetch_metrics()
}
// All three run concurrently, function continues when all complete

// Parallel with timeout
let (users, tasks) = parallel timeout 5s {
  UserService.list()
  TaskService.list()
} ?? {
  // Fallback if timeout exceeded
  ([], [])
}
```

### 10.3 Spawn

`spawn` creates a concurrent lightweight task (scheduled on the thread pool). `spawn cpu` creates a parallel task on a dedicated OS thread for CPU-intensive work:

```forge
// Concurrent — lightweight, good for I/O
spawn {
  let data = fetch_external_api()
  cache.set("data", data)
}

// Parallel — dedicated OS thread, good for CPU work
spawn cpu {
  let result = crunch_numbers(dataset)
  results_channel.send(result)
}
```

### 10.4 Channels

For explicit message passing between concurrent/parallel tasks:

```forge
let ch = channel<Task>(buffer: 10)

// Producer
spawn {
  for task in generate_tasks() {
    ch.send(task)
  }
  ch.close()
}

// Consumer
for task in ch.receive() {
  process(task)
}
```

### 10.5 Streams

`Stream<T>` is a lazy, pull-based sequence — use for data pipelines, pagination, and backpressure-aware processing:

```forge
// Stream from a database query (fetches in batches)
let active_tasks: Stream<Task> = TaskService.stream(status: .active)

// Compose with pipe operators
active_tasks
  |> filter(it.due < now())
  |> batch(10)
  |> each(batch -> process_batch(batch))

// Convert between channels and streams
let ch = my_stream.to_channel()     // push stream items into channel
let st = my_channel.to_stream()     // pull channel items as stream
```

### 10.6 Select

For waiting on multiple channels:

```forge
select {
  msg from data_channel -> process(msg)
  err from error_channel -> handle_error(err)
  timeout 30s -> log.warn("no activity for 30s")
}
```

### 10.7 Implementation

The concurrency runtime is a lightweight task scheduler compiled into the binary:

- **I/O-bound work:** cooperative scheduling on a small thread pool (like Go's goroutines). Many tasks share few OS threads, switching when they'd block.
- **CPU-bound work** (`spawn cpu`): true OS thread parallelism.
- **Channels:** work across both concurrent and parallel tasks seamlessly.
- **Streams:** lazy evaluation, single-threaded by default, can be parallelized with `.par()`.

This is a compiled-in scheduler, not a separate runtime — it's statically linked into the final binary.

---

## 11. Error Handling

Forge provides three complementary error mechanisms: `?` for propagation, `catch` for inline handling, and `errdefer`/`defer` for cleanup.

### 11.1 Result Type

Forge uses a `Result<T, E>` type for recoverable errors:

```forge
fn parse_config(path: string) -> Result<Config, ConfigError> {
  let content = read_file(path)?                    // propagate with ?
  let parsed = json.parse(content)?
  Ok(validate_config(parsed))
}
```

### 11.2 The `?` Operator

The `?` operator unwraps `Ok` values or returns `Err` early. It's Forge's primary error propagation mechanism — one character instead of boilerplate:

```forge
fn load_user_tasks(id: uuid) -> Result<List<Task>, Error> {
  let user = UserService.get(id)?          // returns Err if fails
  let tasks = TaskService.list(owner: user)?
  Ok(tasks)
}
```

The `?` operator works on `Result<T, E>` types and performs automatic error conversion via the `From` trait when error types differ.

### 11.3 The `catch` Keyword

`catch` handles errors inline — use it when you want to handle the error locally rather than propagate it:

```forge
// Catch and provide default
let config = parse_config("./config.toml") catch {
  Config.default()
}

// Catch with error access
let data = fetch(url) catch (e) {
  log.warn(`fetch failed: ${e}`)
  cached_data()
}

// Catch and return early
let user = UserService.get(id) catch {
  return respond(404, { error: "user not found" })
}
```

### 11.4 Defer and Errdefer

`defer` runs cleanup when the current scope exits (always). `errdefer` runs cleanup **only on error paths** — Zig's most innovative feature, adopted for Forge:

```forge
fn process_upload(file: File) -> Result<Document, Error> {
  let conn = db.connect()
  defer conn.close()              // ALWAYS runs when scope exits

  let temp = create_temp_file()?
  errdefer delete(temp)           // ONLY runs if a later step fails

  let parsed = parse(file)?       // if this fails: temp deleted, conn closed
  let doc = store(parsed, temp)?  // if this fails: temp deleted, conn closed
  Ok(doc)                         // success: conn closed, temp NOT deleted
}
```

`defer` statements execute in LIFO (reverse) order. Use `defer` for unconditional cleanup and `errdefer` for rollback-style cleanup.

The `Drop` trait (Section 5.5) provides type-level cleanup for resources like connections and file handles. `defer`/`errdefer` provide scope-level cleanup for ad-hoc operations. They are complementary.

### 11.5 The `attempt` / `fallback` Pattern

For retry-with-fallback logic (common in agent workflows):

```forge
let result = attempt {
  call_primary_api(data)
} retry 3 times with exponential_backoff {
  // Retried up to 3 times
} fallback {
  call_secondary_api(data)
} fallback {
  cached_result(data)
}
```

### 11.6 Panic and Assert

For unrecoverable errors and invariant checking:

```forge
fn divide(a: float, b: float) -> float {
  if b == 0.0 { panic("division by zero") }
  a / b
}

fn process_order(order: Order) {
  assert order.total > 0, "order total must be positive"
  assert order.items.length > 0, "order must have items"
}
```

### 10.6 Compiler Error Format

All compiler errors follow a consistent format with error codes, source locations, and suggestions:

**Human-readable format (default):**

```
ERROR[E0012]: type mismatch at src/main.fg:23:14

  22 |  let user = UserService.get(id)
  23 |  let name: int = user.name
     |            ^^^   ^^^^^^^^^ this is string
     |            |
     |            expected int

  Help: user.name is a string. Did you mean:
    let name: string = user.name

  Docs: https://forgelang.dev/errors/E0012
```

**Machine-parseable format (`forge build --error-format=json`):**

```json
{
  "errors": [{
    "code": "E0012",
    "severity": "error",
    "message": "type mismatch",
    "file": "src/main.fg",
    "line": 23,
    "col": 14,
    "span": { "start": 456, "end": 465 },
    "context_lines": {
      "22": "  let user = UserService.get(id)",
      "23": "  let name: int = user.name"
    },
    "suggestions": [
      {
        "message": "change type annotation to string",
        "replacement": {
          "span": { "start": 456, "end": 459 },
          "text": "string"
        },
        "confidence": 0.95
      }
    ],
    "docs_url": "https://forgelang.dev/errors/E0012",
    "related": []
  }]
}
```

Every error includes:
- **Error code** (stable, searchable identifier)
- **Source span** (exact byte range for programmatic editing)
- **Ranked suggestions** with replacement text and confidence scores
- **Docs URL** linking to detailed explanation with examples
- **Related errors** (if this error is caused by or causes another)

### 10.7 Package Error Boundaries

Errors from package native code are caught at the FFI boundary and converted to Forge's error type:

```
ERROR at src/main.fg:14:16
Package @std/queue encountered an internal error

  14 |  enqueue(payment_queue, order)
     |          ^^^^^^^^^^^^^^^^^^^^

  Package error (source: Go runtime):
    goroutine panic: index out of range [3] with length 2

  This is a bug in the @std/queue package, not in your code.
  Suggestion: try updating @std/queue or report this issue

  Package trace:
    queue.go:142  processMessage()
    queue.go:89   Enqueue()
    [FFI boundary]
    src/main.fg:14  main()
```

The FFI boundary catches:
- **Rust:** `catch_unwind` for panics
- **Go:** `recover()` for panics
- **C/C++:** Signal handlers for segfaults, plus exception catching for C++
- **Python:** Exception catching in embedded interpreter

A package crash never takes down the host process. It always surfaces as a catchable `PackageError`.

---

## 11. Module System

Forge uses a file-based module system with dot-separated paths and compiler auto-discovery. No string paths. No index files.

### 11.1 File = Module

Each `.fg` file is a module. Directories are namespaces. The compiler auto-discovers exported items by scanning files.

```
src/
  main.fg              // entry point
  tasks/
    task.fg            // namespace: tasks, exports Task model etc.
    task_test.fg       // tests for task.fg
  users/
    user.fg            // namespace: users
    user_test.fg
  utils/
    helpers.fg         // namespace: utils
```

### 11.2 Imports

```forge
// Import specific items from your project (dots, not strings)
use tasks.Task
use tasks.{Task, TaskService}
use users.{User, User as BaseUser}          // rename with `as`

// Import everything from a namespace (wildcard = bare path)
use utils                                    // all exports from utils/
use tasks                                    // all exports from tasks/

// Import from packages — @ prefix for external
use @std.http.{server, route, middleware as mw}
use @std.queue.{queue, worker}
use @std.model                               // all exports from @std/model

// Import from community packages
use @community.graphql

// The compiler resolves names to files automatically
// If User is exported in users/user.fg, `use users.User` finds it
// No index.fg files needed
```

### 11.3 Exports

All top-level declarations are private by default. Use `export` to make them available:

```forge
// users/user.fg

export model User {
  id: uuid @primary
  name: string
}

export fn validate_email(email: string) -> bool {
  // ...
}

// Private helper — not importable
fn normalize_name(name: string) -> string {
  name.trim().lower()
}
```

---

## 12. Embedded Sublanguages

Forge supports embedding other language syntaxes within blocks. The outer parser handles brace-matching; the package parses the inner content.

### 12.1 SQL Blocks

```forge
use @std.sql

let results = sql {
  SELECT u.name, count(t.id) as task_count
  FROM users u
  JOIN tasks t ON t.owner_id = u.id
  WHERE u.active = true
  GROUP BY u.name
  ORDER BY task_count DESC
  LIMIT 10
}
// Type: List<{ name: string, task_count: int }>
// Validated at compile time against model definitions
```

SQL blocks are compile-time validated:
- Table and column names checked against model definitions
- Return type inferred from SELECT columns
- Parameterized values (`${expr}`) are safely escaped
- Invalid SQL syntax caught at compile time

### 12.2 Regex Blocks

```forge
use @std.regex

let email_pattern = regex { [A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z]{2,} }
let is_valid = email_pattern.test("user@example.com")
let matches = email_pattern.find_all(text)
```

### 12.3 Shell Blocks

```forge
use @std.shell

let output = sh { ls -la /tmp }
let git_hash = sh { git rev-parse HEAD }.trim()
```

### 12.4 How Embedded Blocks Work

The Forge parser treats embedded blocks generically:

1. Parser sees `<keyword> { ... }` where `<keyword>` is registered by a package as an embedded block
2. Parser does brace-matching to find the block boundaries
3. Raw text inside braces is passed to the package's parser
4. Package parses, validates, and returns typed AST nodes
5. Compiler lowers package AST nodes to LLVM IR

This means new embedded syntaxes can be added by community packages without modifying the Forge parser.

---

## 13. External Language Bridge

Forge can link components written in other languages into the same binary. This is the mechanism that allows "write it in Rust, use it from Forge."

### 13.1 Extern Declarations

```forge
// Declare a component implemented in another language
extern component fraud_detector {
  source: "rust://components/fraud"

  fn evaluate(transaction: Transaction) -> {
    score: float
    flags: List<string>
    block: bool
  }

  fn train(data: List<Transaction>) -> TrainingResult
}

// Use it like any Forge code
let result = fraud_detector.evaluate(tx)
if result.block {
  reject(tx, result.flags)
}
```

### 13.2 Compilation Pipeline

For compiled languages (Rust, Go, C, C++, Zig):

1. Forge toolchain invokes the foreign compiler to produce a static library with C ABI
2. Forge generates FFI bindings matching the declared interface
3. Types are marshaled across the boundary using a shared binary format
4. The foreign library is statically linked into the final binary

For interpreted languages (Python, JavaScript):

1. Forge embeds a minimal interpreter runtime (libpython, QuickJS)
2. Foreign code runs in the embedded interpreter
3. Communication uses optimized shared-memory IPC
4. The interpreter runtime is statically linked into the final binary

### 13.3 Type Marshaling

Types crossing the FFI boundary are automatically serialized/deserialized:

| Forge Type | C ABI Representation |
|---|---|
| `int` | `int64_t` |
| `float` | `double` |
| `bool` | `uint8_t` (0 or 1) |
| `string` | `forge_string_t` (ptr + len) |
| `List<T>` | `forge_list_t` (ptr + len + element_size) |
| `Map<K, V>` | `forge_map_t` (serialized) |
| `struct/model` | `forge_struct_t` (field-by-field marshaling) |
| `T?` (nullable) | `forge_optional_t` (tag + value) |

The Forge compiler generates marshaling code at compile time based on the `extern` declarations, so there's no runtime reflection cost.

### 13.4 Go-Specific Notes

Go requires special handling due to its runtime:

```toml
# component.toml for a Go component
[component]
name = "fraud_detector"
language = "go"

[build]
# Go compiles as c-shared, producing a .so with C ABI
mode = "c-shared"
cgo_enabled = true
```

The Go runtime (goroutine scheduler, GC) runs within the shared library. Forge's concurrency scheduler and Go's goroutine scheduler coexist but operate independently. This works because they communicate only through C ABI function calls at the boundary.

### 13.5 Python-Specific Notes

Python components embed libpython:

```toml
[component]
name = "ml_classifier"
language = "python"

[build]
python_version = "3.12"
requirements = ["scikit-learn", "numpy"]
# Dependencies are bundled into the component
```

Python components have higher latency than compiled components due to the interpreter overhead. They are best used for workloads where Python's library ecosystem is essential (ML, data science) rather than performance-critical paths.

---

## 14. Toolchain

### 14.1 CLI Overview

```bash
forge new <name>              # Create new project
forge build                   # Build release binary (LLVM optimized)
forge build --dev             # Build dev binary (faster compile, debug info)
forge dev                     # Run in dev mode with hot reload
forge run                     # Build and run
forge test                    # Run tests
forge repl                    # Interactive REPL

forge add <package>          # Add a package
forge remove <package>       # Remove a package
forge packages list          # List installed packages
forge packages search <q>    # Search package registry

forge migrate create          # Generate migration from model changes
forge migrate run             # Apply pending migrations
forge migrate rollback        # Rollback last migration
forge migrate preview         # Preview SQL

forge context                 # Output LLM-friendly project context
forge context --packages     # Include all package specs
forge context --compact       # Minimal context for small windows

forge fmt                     # Format source code
forge lint                    # Run linter
forge doc                     # Generate documentation
forge doc serve               # Serve docs locally
```

### 14.2 Compiler Architecture

```
Source (.fg files)
       │
       ▼
┌─────────────┐
│   Lexer     │  Tokenize, handle embedded blocks
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   Parser    │  Build AST, delegate package blocks
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  Package    │  Packages transform their keyword
│  Transform  │  blocks into core AST + native calls
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   Type      │  Structural type checking,
│   Checker   │  null safety, inference
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   MIR       │  Mid-level IR: ref counting insertion,
│  Lowering   │  arena optimization, monomorphization
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   LLVM IR   │  Generate LLVM IR from MIR
│   Codegen   │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   LLVM      │  Optimization passes, native code gen,
│  Backend    │  link package native libs
└──────┬──────┘
       │
       ▼
  Native Binary
```

The compiler is written in Rust and uses the LLVM C API (via the `inkwell` or `llvm-sys` crate) for code generation.

### 14.3 Build Modes

| Mode | Command | LLVM Opt | Compile Speed | Binary Size | Debug Info |
|---|---|---|---|---|---|
| Dev | `forge build --dev` | O0 | Fast | Large | Yes |
| Release | `forge build` | O2 | Slow | Small | No |
| Size | `forge build --size` | Os | Slow | Smallest | No |
| Debug | `forge build --debug` | O0 | Fast | Large | Full DWARF |

### 14.4 Hot Reload (Dev Mode)

`forge dev` watches source files and recompiles changed modules as shared libraries, then hot-swaps them in the running process. This gives sub-second reload times for most changes without restarting servers or losing state.

Limitations:
- Model schema changes require a full restart (migration needed)
- Adding/removing packages requires a full restart
- Changes to `main.fg` entry point require a full restart

### 14.5 REPL

`forge repl` provides an interactive environment backed by JIT compilation via LLVM's ORC JIT:

```
$ forge repl
Forge 0.1.0 REPL (type :help for commands)

> let x = 42
x: int = 42

> x * 2
84

> model User { id: uuid @primary, name: string }
Model User created (in-memory)

> User.create({ name: "alice" })
User { id: "a1b2...", name: "alice" }

> :packages
@std/core (built-in)
No additional packages loaded. Use :add @std/http to add.

> :add @std/http
Loading @std/http... done.

> server :8080 { route GET /test -> { ok: true } }
Server started on :8080

> :quit
```

REPL commands start with `:` to distinguish from language expressions.

### 14.6 LSP Server

Forge ships with a Language Server Protocol implementation for editor support:

- **Completions:** keyword, type, field, package keyword completions
- **Diagnostics:** real-time error reporting as you type
- **Go to definition:** works across modules and into package type definitions
- **Hover:** type info, documentation, package docs
- **Rename:** safe rename across modules
- **Format:** integrated formatter

The LSP server is distributed as part of the `forge` binary (`forge lsp`).

---

## 15. LLM and Agent Ergonomics

Forge is designed to be written by both humans and AI agents. This section describes the specific design choices that support LLM-assisted development.

### 15.1 Context Loading

The `forge context` command outputs a complete, structured description of the current project that can be loaded into an LLM's context window:

```bash
# Full project context (spec + packages + models + types)
forge context

# Output:
# ============================
# FORGE PROJECT CONTEXT
# Project: my-service
# ============================
#
# LANGUAGE SPEC (core keywords, syntax, types):
# [compact spec ~5k tokens]
#
# PACKAGES:
# @std/http v0.1.0: server, route, middleware, mount
#   [keyword syntax and examples ~1k tokens]
# @std/sql v0.1.0: sql{}
#   [keyword syntax and examples ~500 tokens]
# ...
#
# PROJECT MODELS:
# model User { id: uuid, email: string, name: string, ... }
# model Task { id: uuid, title: string, status: enum(...), ... }
#
# PROJECT SERVICES:
# service TaskService for Task { assign, complete, overdue }
#
# PROJECT STRUCTURE:
# src/main.fg, src/models/user.fg, src/models/task.fg, ...
```

Options:

```bash
forge context --compact       # Minimal context (~3k tokens)
forge context --full          # Everything including package internals (~15k tokens)
forge context --packages     # Just package specs
forge context --models        # Just model definitions
forge context --format=json   # Machine-parseable output
```

### 15.2 MCP Server

Forge can run as an MCP (Model Context Protocol) server, allowing AI agents to query project information dynamically:

```bash
forge mcp serve
```

This exposes tools for:
- Querying project structure and models
- Running builds and getting structured errors
- Executing tests and getting results
- Searching package documentation
- Running REPL expressions

### 15.3 Error Design for Agents

Every compiler error includes machine-actionable fix suggestions:

```json
{
  "code": "E0087",
  "severity": "error",
  "message": "unknown keyword 'stream'",
  "suggestions": [
    {
      "message": "use 'ws' for WebSocket blocks",
      "replacement": {
        "span": { "start": 156, "end": 162 },
        "text": "ws"
      },
      "confidence": 0.92
    },
    {
      "message": "add @std/ws package for streaming",
      "action": "forge add @std/ws",
      "confidence": 0.45
    }
  ]
}
```

An LLM agent can:
1. Run `forge build --error-format=json`
2. Parse errors
3. Apply the highest-confidence suggestion
4. Rebuild and verify

### 15.4 Spec Compactness

The core language spec (keywords, syntax, types) is designed to fit in approximately 5,000 tokens. Package specs add approximately 500-1,000 tokens each. A typical project's full context (spec + 3-4 packages + models) fits in approximately 10,000 tokens.

This is intentional — every language design decision was evaluated for how concisely it can be described to an LLM.

### 15.5 Naming Conventions

Forge enforces consistent naming to reduce ambiguity for LLM code generation:

- **Models:** PascalCase (`User`, `TaskAssignment`)
- **Functions:** snake_case (`process_order`, `send_email`)
- **Variables:** snake_case (`user_count`, `active_tasks`)
- **Constants:** UPPER_SNAKE_CASE (`MAX_RETRIES`, `DEFAULT_PORT`)
- **Packages:** kebab-case namespaced (`@std/http`, `@community/graphql`)
- **Files:** snake_case (`task_service.fg`, `user_model.fg`)
- **Enums:** snake_case values (`.pending`, `.in_progress`, `.done`)

The formatter enforces these conventions automatically.

---

## 16. Memory Management

Forge uses automatic memory management that is invisible to the programmer. The strategy combines reference counting with arena allocation, all decided at compile time.

### 16.1 Core Strategy

**Reference counting** is the default. The compiler inserts retain/release calls at assignment and scope exit. This provides:
- Deterministic deallocation (objects freed immediately when unused)
- No GC pauses
- No runtime required
- Predictable performance

**Cycle detection** runs only when needed. The compiler performs static analysis to identify types that could form cycles (e.g., models with bidirectional relations). Only those types get cycle-detection instrumentation (a lightweight mark-and-sweep that runs when a reference count doesn't reach zero as expected).

**Arena allocation** is used automatically for request-scoped data. The compiler detects "handle-and-respond" patterns (common in server routes and queue handlers) and allocates all objects created during that scope in an arena. The entire arena is freed at once when the scope exits, which is much faster than individual reference count decrements.

### 16.2 Developer Experience

The programmer never writes memory management code:

```forge
fn process_request(req: Request) -> Response {
  // All objects here are arena-allocated (compiler detects request scope)
  let user = UserService.get(req.user_id)
  let tasks = TaskService.list(owner: user)
  let summary = generate_summary(tasks)

  // Response is returned; arena freed after response sent
  { user: user.name, task_count: tasks.length, summary: summary }
}
// No manual free, no defer, no Drop — it just works
```

### 16.3 Package Authors

Package authors writing native Rust/Go/C code manage their own internal memory. However, any object that crosses the FFI boundary into Forge is automatically reference-counted. The Package SDK handles this:

```rust
// Package SDK automatically wraps returned values
#[forge_export]
fn create_server(port: u16) -> ForgeHandle<Server> {
    // ForgeHandle adds reference counting at the boundary
    ForgeHandle::new(Server::new(port))
}
```

---

## 17. Testing

### 17.1 Test Files

Tests live in separate files with a `_test.fg` suffix:

```
src/
  models/
    user.fg
    user_test.fg         // tests for user.fg
  services/
    task_service.fg
    task_service_test.fg // tests for task_service.fg
```

### 17.2 Writing Tests

```forge
// task_service_test.fg
use @std.test.{describe, test, expect, before_each, mock}
use tasks.TaskService
use users.User

describe "TaskService" {
  let test_user: User

  before_each {
    // Fresh database for each test (auto-managed)
    test_user = User.create({ name: "test", email: "test@example.com" })
  }

  test "creates a task with pending status" {
    let task = TaskService.create({
      title: "test task",
      owner: test_user
    })

    expect(task.status).to_equal(.pending)
    expect(task.owner.id).to_equal(test_user.id)
  }

  test "rejects tasks with empty titles" {
    expect {
      TaskService.create({ title: "", owner: test_user })
    }.to_panic("title required")
  }

  test "assigns task and updates status" {
    let task = TaskService.create({ title: "test", owner: test_user })
    let assigned = TaskService.assign(task, test_user)

    expect(assigned.status).to_equal(.active)
    expect(assigned.owner.id).to_equal(test_user.id)
  }

  test "overdue returns only active past-due tasks" {
    TaskService.create({
      title: "overdue",
      owner: test_user,
      status: .active,
      due: now() - 1d   // duration literal: 1 day ago
    })
    TaskService.create({
      title: "not overdue",
      owner: test_user,
      status: .active,
      due: now() + 1d
    })

    let overdue = TaskService.overdue()
    expect(overdue.length).to_equal(1)
    expect(overdue[0].title).to_equal("overdue")
  }
}
```

### 17.3 Mocking

```forge
test "sends notification on task creation" {
  let sent_emails = mock(send_email)

  TaskService.create({ title: "test", owner: test_user })

  expect(sent_emails.call_count).to_equal(1)
  expect(sent_emails.last_call.args[0]).to_equal(test_user.email)
}
```

### 17.4 Running Tests

```bash
forge test                    # Run all tests
forge test src/tasks/         # Run tests in directory
forge test --filter "overdue" # Run tests matching pattern
forge test --watch            # Re-run on file changes
forge test --coverage         # Generate coverage report
forge test --json             # Machine-readable output
```

### 17.5 Benchmarking

```forge
use @std.test.{bench}

bench "task creation" {
  let user = User.create({ name: "test", email: "test@test.com" })
  TaskService.create({ title: "bench task", owner: user })
}

bench "bulk query" (iterations: 1000) {
  TaskService.list(status: .active)
}
```

```bash
forge bench                     # run all benchmarks
forge bench --compare HEAD~1    # compare against previous commit
forge bench --output json       # machine-readable results
```

Output includes iterations, mean time, standard deviation, and p50/p95/p99 latencies.

---

## 19. Project Structure

### 19.1 Standard Layout (Feature-Based)

Projects are organized by feature/domain, not by layer. Each directory represents a feature and contains its models, services, and tests together.

```
my-project/
├── forge.toml               # Project configuration
├── src/
│   ├── main.fg              # Entry point
│   ├── tasks/
│   │   ├── task.fg          # Task model, service, helpers
│   │   └── task_test.fg     # Tests for tasks
│   ├── users/
│   │   ├── user.fg          # User model, service, helpers
│   │   └── user_test.fg     # Tests for users
│   ├── notifications/
│   │   ├── notification.fg
│   │   └── notification_test.fg
│   └── utils/
│       └── helpers.fg
├── migrations/
│   ├── 20260310_create_users.sql
│   └── 20260310_create_tasks.sql
├── components/              # External language components
│   └── fraud_detector/
│       ├── component.toml
│       └── src/
│           └── lib.rs
└── build/                   # Compiled output (gitignored)
    ├── my-project-linux
    ├── my-project-macos
    └── my-project-windows.exe
```

### 19.2 forge.toml

```toml
[project]
name = "my-project"
version = "0.1.0"
description = "A task management API"
entry = "src/main.fg"

[database]
default = "sqlite"
path = "./data/app.db"

[database.production]
default = "postgres"
url = "${DATABASE_URL}"

[packages]
"@std/model" = "0.1.0"
"@std/http" = "0.1.0"
"@std/sql" = "0.1.0"
"@std/queue" = "0.1.0"
"@std/cron" = "0.1.0"
"@std/ai" = "0.1.0"
"@std/log" = "0.1.0"
"@std/cli" = "0.1.0"
"@std/deploy" = "0.1.0"
"@std/observe" = "0.1.0"

[components]
fraud_detector = { path = "./components/fraud_detector" }

# Build targets — sane defaults, override as needed
[build]
default_target = "native"           # auto-detect current platform
opt_level = 2                       # LLVM optimization level (0-3)

[build.targets.linux]
triple = "x86_64-unknown-linux-gnu"

[build.targets.macos]
triple = "aarch64-apple-darwin"

[build.targets.macos-intel]
triple = "x86_64-apple-darwin"

[build.targets.windows]
triple = "x86_64-pc-windows-msvc"

[build.targets.edge]
triple = "wasm32-wasi"
max_binary_size = "10MB"

# Build commands:
# forge build                    → builds for current platform
# forge build --target linux     → specific target
# forge build --all              → all declared targets

[dev]
hot_reload = true
port = 8080
log_level = "debug"

[events]
backend = "in-process"             # default: in-process pub/sub
# backend = "redis"                # swap to Redis for distributed
# url = "redis://localhost:6379"

[observe]
enabled = true
exporter = "stdout"                # default: log to stdout
# exporter = "otlp"               # swap to OpenTelemetry
# endpoint = "http://localhost:4317"
```

---

## 19. Standard Library

Beyond packages, Forge has a small standard library of functions and types always available without imports.

### 19.1 Built-in Functions

```forge
// Output
print(value)                  // Print to stdout
println(value)                // Print with newline

// Type conversion
int("42")                     // Parse string to int
float("3.14")                 // Parse string to float
string(42)                    // Convert to string
bool("true")                  // Parse string to bool

// Collections
len(collection)               // Length of list, map, set, string
range(start, end)             // Integer range [start, end)
range(start, end, step)       // With step

// Time
now()                         // Current UTC timestamp
today()                       // Current UTC date
sleep(duration)               // Sleep for duration

// Math
min(a, b)                     // Minimum
max(a, b)                     // Maximum
abs(x)                        // Absolute value
clamp(x, low, high)           // Clamp to range

// UUID
uuid()                        // Generate UUID v4

// Assertions
assert(condition, message?)   // Panic if false
panic(message)                // Unconditional panic
```

### 19.2 Duration Literals

```forge
let timeout = 30s             // 30 seconds
let interval = 5m             // 5 minutes
let ttl = 24h                 // 24 hours
let delay = 1d                // 1 day
let refresh = 500ms           // 500 milliseconds

// Arithmetic
let total = 1h + 30m          // 1.5 hours
let double = timeout * 2      // 60 seconds
```

### 19.3 String Methods

```forge
// All string methods are non-mutating (return new string)
s.length                      // Character count
s.upper()                     // Uppercase
s.lower()                     // Lowercase
s.trim()                      // Trim whitespace
s.trim_start()                // Trim leading whitespace
s.trim_end()                  // Trim trailing whitespace
s.starts_with(prefix)         // Bool
s.ends_with(suffix)           // Bool
s.contains(substr)            // Bool
s.replace(old, new)           // Replace first occurrence
s.replace_all(old, new)       // Replace all occurrences
s.split(delimiter)            // List<string>
s.join(list)                  // Join list with separator
s.slice(start, end?)          // Substring
s.pad_start(len, char?)       // Pad start
s.pad_end(len, char?)         // Pad end
s.chars()                     // List<char>
s.bytes()                     // bytes
s.is_empty()                  // Bool
s.repeat(n)                   // Repeat n times
```

### 19.4 List Methods

```forge
list.length                   // Size
list.push(item)               // Add to end (mutates)
list.pop()                    // Remove from end (mutates) -> T?
list.first()                  // First element -> T?
list.last()                   // Last element -> T?
list.get(index)               // Get by index -> T?
list.map(fn)                  // Transform each -> List<R>
list.filter(fn)               // Filter -> List<T>
list.reduce(init, fn)         // Reduce to single value -> R
list.each(fn)                 // Iterate (no return value)
list.find(fn)                 // First match -> T?
list.any(fn)                  // Any match -> bool
list.all(fn)                  // All match -> bool
list.sort(fn?)                // Sort (mutates)
list.sorted(fn?)              // Sorted copy -> List<T>
list.reverse()                // Reverse (mutates)
list.reversed()               // Reversed copy -> List<T>
list.slice(start, end?)       // Sublist -> List<T>
list.flatten()                // Flatten nested -> List<T>
list.unique()                 // Deduplicate -> List<T>
list.enumerate()              // -> List<(int, T)>
list.zip(other)               // -> List<(T, U)>
list.contains(item)           // -> bool
list.is_empty()               // -> bool
list.join(sep)                // Join strings -> string
list.chunks(size)             // -> List<List<T>>
```

### 19.5 Map Methods

```forge
map.length                    // Number of entries
map.get(key)                  // -> V?
map.set(key, value)           // Set entry (mutates)
map.has(key)                  // -> bool
map.delete(key)               // Remove entry (mutates)
map.keys()                    // -> List<K>
map.values()                  // -> List<V>
map.entries()                 // -> List<(K, V)>
map.map(fn)                   // Transform values -> Map<K, R>
map.filter(fn)                // Filter entries -> Map<K, V>
map.merge(other)              // Merge maps -> Map<K, V>
```

### 20.6 Standard Package Release Schedule

**v0 — Ships with the language:**

| Package | Description |
|---|---|
| `@std/model` | Data models, persistence, migrations, CRUD |
| `@std/http` | HTTP server, routing, middleware |
| `@std/sql` | Database queries, embedded SQL blocks |
| `@std/log` | Structured logging |
| `@std/test` | Testing framework and benchmarking |
| `@std/env` | Config and environment management |
| `@std/cli` | CLI tool building |
| `@std/fetch` | HTTP client |

**v1 — Fast follow:**

| Package | Description |
|---|---|
| `@std/queue` | Message queues, workers, dead letters |
| `@std/ws` | WebSockets, pub/sub |
| `@std/cron` | Scheduled tasks |
| `@std/ai` | LLM/agent integration, tools |
| `@std/deploy` | Deployment primitives |
| `@std/auth` | Authentication, authorization, JWT |
| `@std/notify` | Email, SMS, push notifications |
| `@std/observe` | Tracing, metrics, OpenTelemetry |
| `@std/validate` | Validation rules and schemas |
| `@std/events` | Distributed event backends |

**v2 — Ecosystem expansion:**

| Package | Description |
|---|---|
| `@std/resilience` | Rate limiting, circuit breakers, bulkheads |
| `@std/storage` | File storage abstraction (local, S3, GCS) |
| `@std/jobs` | Background jobs with state tracking |
| `@std/transform` | Data transformation (CSV, JSON, XML) |
| `@std/docs` | API documentation generation |
| `@std/ui` | Mobile UI (long-term vision) |

---

## 21. Deployment

Deployment is a first-class concept in Forge via the `@std/deploy` package. No Dockerfiles, no YAML, no separate IaC tools.

### 21.1 Deployment Configuration

```forge
use @std.deploy.{deploy, target, health}

deploy my_service {
  target production {
    platform: "docker"             // or "fly", "aws-lambda", "cloudflare"
    replicas: 3
    memory: "512MB"
    cpu: 1

    env {
      DATABASE_URL: secret("db-url")
      API_KEY: secret("api-key")
    }

    health GET /health {
      interval: 30s
      timeout: 5s
    }

    scale {
      min: 2
      max: 10
      metric: cpu > 70%
    }
  }

  target staging {
    platform: "docker"
    replicas: 1
    memory: "256MB"
  }
}
```

### 21.2 CLI Commands

```bash
forge deploy staging            # deploy to staging
forge deploy production         # deploy to production
forge deploy status             # check deployment status
forge deploy rollback           # rollback last deployment
forge deploy logs               # stream logs
```

The toolchain generates Dockerfiles, Kubernetes manifests, or platform-specific configs automatically. Deployment targets are packages — `@community/deploy-fly`, `@community/deploy-aws`, `@community/deploy-vercel` — so the community can add platforms.

### 21.3 Secrets Management

```forge
use @std.secrets.{secret, vault}

let api_key = secret("API_KEY")                    // from environment

let db_password = vault("production/db-password") {
  provider: "aws-ssm"                              // or "hashicorp-vault", "1password"

  cache: 5m
  rotate: 30d
}
```

---

## 22. CLI Applications

CLI tools are first-class via `@std/cli`. Argument parsing, help text, shell completions — all auto-generated.

```forge
use @std.cli.{command, arg, flag}

command app "my-tool" version "1.0.0" {
  description "A task management CLI"

  command list {
    description "List all tasks"
    flag verbose: bool = false, "Show details"
    flag status: string?, "Filter by status"

    run (args) {
      let tasks = TaskService.list(status: args.status)
      if args.verbose {
        tasks.each(t -> println(`${t.id} ${t.title} [${t.status}]`))
      } else {
        tasks.each(t -> println(t.title))
      }
    }
  }

  command create {
    arg title: string, "Task title"
    flag assign: string?, "Assign to user"

    run (args) {
      let task = TaskService.create({ title: args.title })
      if let assignee = args.assign {
        TaskService.assign(task, assignee)
      }
      println(`Created: ${task.id}`)
    }
  }
}
```

---

## 23. Observability

Observability is first-class via `@std/observe`. Auto-instruments every function call, HTTP request, database query, and queue operation with zero code changes.

```forge
use @std.observe

// That's it. Everything is now traced.
// Configure export in forge.toml:
// [observe]
// exporter = "otlp"
// endpoint = "http://localhost:4317"
```

Manual spans for custom instrumentation:

```forge
use @std.observe.{span, metric}

fn process_order(order: Order) -> Result<Receipt, Error> {
  span "process_order" {
    metric.increment("orders.processed")
    let payment = charge(order)?
    metric.histogram("order.amount", order.total)
    generate_receipt(order, payment)
  }
}
```

Built-in dashboards available via `forge observe serve` for local development.

---

## 24. Mobile Support

Forge targets mobile platforms as a long-term vision. LLVM's ARM backend makes this architecturally feasible.

### 24.1 Phase 1: Business Logic Library

Forge compiles to a native library (`.so`/`.dylib`/`.framework`) that native UI code calls:

```bash
forge build --target aarch64-apple-ios        # iOS
forge build --target aarch64-linux-android    # Android
```

Write business logic, networking, and data layer in Forge. Write UI in Swift/Kotlin. This is the same approach used by Rust, Go, and Kotlin Multiplatform on mobile today.

### 24.2 Phase 2: UI Package (Future Vision)

A `@std/ui` package that compiles to native controls on each platform:

```forge
use @std.ui.{app, view, text, button, list, state}

app TasksApp {
  mut tasks = state(TaskService.list())

  view body {
    list(tasks) { task ->
      row {
        text(task.title)
        button("Done") {
          TaskService.complete(task)
          tasks = TaskService.list()
        }
      }
    }
  }
}
```

This would compile to SwiftUI on iOS and Jetpack Compose on Android. This is a post-v1.0 goal.

---

## 25. Implementation Roadmap

### Phase 1: Core Language (Months 1-6)

**Goal:** Compile basic Forge programs to native binaries via LLVM.

Deliverables:
- Lexer and parser for core keywords
- Type checker with structural typing, generics, null safety
- LLVM IR code generation via `inkwell` crate
- Reference counting insertion pass
- Basic standard library (print, string ops, collections)
- `forge build` and `forge run` commands
- `forge.toml` project configuration

**Milestone:** `Hello World` compiles and runs as a native binary.

### Phase 2: Models and Persistence (Months 4-8)

**Goal:** Models auto-persist, migrations work, basic queries run.

Deliverables:
- Model declaration and field annotations
- SQLite driver (bundled, zero-config)
- Auto-generated CRUD operations
- Migration generation and execution
- `sql {}` embedded blocks with compile-time validation
- PostgreSQL driver

**Milestone:** Define a model, create/query records, compile to single binary with embedded SQLite.

### Phase 3: Package System (Months 6-12)

**Goal:** Packages can register keywords and compile to native code.

Deliverables:
- Package manifest format (`package.toml`)
- Package SDK crate for Rust package authors
- Keyword registration and syntax pattern matching
- Package compile-time transformation pipeline
- Package fault boundaries (FFI error catching)
- `@std/http` package (server, route, middleware, mount)
- `@std/queue` package (queue, worker, enqueue)
- `forge add`, `forge remove`, `forge packages` commands
- Package registry (package hosting)

**Milestone:** Full motivating example (Section 1) compiles and runs.

### Phase 4: External Language Bridge (Months 10-14)

**Goal:** Components written in Go/Rust/Python can be linked into Forge binaries.

Deliverables:
- `extern component` declaration syntax
- C ABI FFI code generation
- Type marshaling across language boundaries
- Go c-shared compilation integration
- Python embedding via libpython
- Component build orchestration in `forge build`

**Milestone:** A Forge service calls a Go component and a Python component in the same binary.

### Phase 5: Developer Experience (Months 12-16)

**Goal:** Forge is pleasant to use for daily development.

Deliverables:
- LSP server (completions, diagnostics, hover, go-to-def)
- REPL with LLVM ORC JIT
- Hot reload in dev mode
- `forge fmt` (formatter)
- `forge lint` (linter)
- `forge context` (LLM context export)
- `forge mcp serve` (MCP server)
- Testing framework (`@std/test`)
- Documentation generator

**Milestone:** A developer (or LLM agent) can write, test, and iterate on a Forge service with full tooling support.

### Phase 6: Ecosystem (Months 14-18+)

**Goal:** Community can build and share packages.

Deliverables:
- Package SDK for Go, Python, C package authors
- Public package registry with search
- `@std/ws`, `@std/cron`, `@std/ai`, `@std/auth` packages
- Edge/WASI compilation target
- CI/CD integration guides
- Documentation site

**Milestone:** Community members publish third-party packages.

---

## 26. Open Questions

The following design areas need further exploration and prototyping. Many questions from v0.1 have been resolved.

### Resolved Since v0.1

| Question | Decision |
|---|---|
| Event system | First-class (`emit`/`on`), in-process default, package-extensible (Redis, Kafka via config) |
| Package security | Capability-based declarations in `package.toml`, compiler-verified |
| Package registry | Hybrid — centralized registry for discovery, git-based for source |
| Streaming | Both `Stream<T>` (lazy pull) and `Channel<T>` (concurrent push), with conversion between them |
| Observability | First-class via `@std/observe`, auto-instrumented, OpenTelemetry export |
| Access control | Standard package `@std/auth` with annotation-based route protection |
| Mutability | Immutable-by-default (`let`), opt-in mutation (`mut`), compile-time constants (`const`) |
| Model as core vs package | Package (`@std/model`) — keeps core language minimal |

### 26.1 Compile-Time Computation

Should Forge support Zig-style `comptime` for compile-time evaluation? This would enable type-level programming, compile-time code generation, and const generics. Deferred to post-v1.0 but the type system and trait system are designed to not preclude it.

### 26.2 Versioning and Compatibility

How do model schema changes interact with running services? The migration system handles schema changes, but zero-downtime deployment needs further design around backward-compatible migrations and multi-step rollout warnings.

### 26.3 Effect System

Should Forge track side effects in the type system? An effect system could distinguish pure functions from those that do I/O, mutate state, or panic. This improves testability and reasoning but adds complexity. Deferred to post-v1.0.

### 26.4 Mobile UI Package Design

The `@std/ui` package (Section 24.2) needs deep design work around reactivity, state management, layout primitives, and platform-specific escape hatches. This is a post-v1.0 research area.

---

## Appendix A: Grammar (EBNF Summary)

```ebnf
program        = declaration* ;

declaration    = fn_decl | type_decl | enum_decl | trait_decl | impl_decl
               | use_decl | export_decl
               | package_keyword_block | statement ;

fn_decl        = "fn" IDENT "(" params? ")" ("->" type)? block ;
params         = param ("," param)* ;
param          = IDENT ":" type ("=" expr)? ;

trait_decl     = "trait" IDENT ("<" type_params ">")?  "{" trait_method* "}" ;
impl_decl      = "impl" IDENT "for" IDENT "{" fn_decl* "}" ;

use_decl       = "use" module_path ("." "{" use_items "}")? ;
use_items      = use_item ("," use_item)* ;
use_item       = IDENT ("as" IDENT)? ;
module_path    = ("@" IDENT ".")? IDENT ("." IDENT)* ;

export_decl    = "export" declaration ;

type_decl      = "type" IDENT "=" type ;
enum_decl      = "enum" IDENT "{" enum_variant ("," enum_variant)* "}" ;

type           = IDENT ("<" type ("," type)* ">")?   // generic
               | type "?"                              // nullable
               | type "|" type                         // union
               | type "&" type                         // intersection
               | "{" field_type ("," field_type)* "}" // structural
               | "(" type ("," type)* ")"             // tuple
               | "fn" "(" type* ")" "->" type         // function
               ;

annotation     = "@" IDENT ("(" args? ")")? ;

statement      = let_stmt | mut_stmt | const_stmt | assign_stmt | expr_stmt
               | if_stmt | match_stmt | for_stmt | while_stmt | loop_stmt
               | return_stmt | emit_stmt | on_stmt
               | defer_stmt | errdefer_stmt | spawn_stmt ;

let_stmt       = "let" pattern (":" type)? "=" expr ;
let_stmt       = "let" pattern "=" expr "else" block ;       // let-else
mut_stmt       = "mut" IDENT (":" type)? "=" expr ;
const_stmt     = "const" IDENT (":" type)? "=" expr ;

defer_stmt     = "defer" (expr | block) ;
errdefer_stmt  = "errdefer" (expr | block) ;
spawn_stmt     = "spawn" "cpu"? block ;

expr           = literal | IDENT | "it" | binary_expr | unary_expr
               | call_expr | member_expr | index_expr
               | closure | pipe_expr | block
               | if_expr | match_expr | with_expr
               | null_coalesce | null_propagate
               | error_propagate | type_check | type_cast
               | parallel_expr | range_expr ;

closure        = IDENT "->" expr                   // single param, no parens
               | "(" params ")" "->" expr          // multi param
               ;

with_expr      = expr "with" "{" field_update* "}" ;
error_propagate = expr "?" ;
range_expr     = expr ".." "="? expr ("step" expr)? ;
pipe_expr      = expr "|>" expr ;

block          = "{" statement* expr? "}" ;

pipe_expr      = expr "|>" expr ;
null_coalesce  = expr "??" expr ;
null_propagate = expr "?." IDENT ;
```

This is a simplified grammar. The full grammar includes package-extensible syntax patterns and embedded block delegation.

---

## Appendix B: Error Code Registry

| Range | Category |
|---|---|
| E0001-E0099 | Syntax errors |
| E0100-E0199 | Type errors |
| E0200-E0299 | Package errors |
| E0300-E0399 | Model/persistence errors |
| E0400-E0499 | Import/module errors |
| E0500-E0599 | FFI/extern errors |
| E0600-E0699 | Concurrency errors |
| W0001-W0099 | Warnings |

Each error code has a permanent, stable meaning. Error codes are never reused or reassigned.

---

## Appendix C: Comparison with Existing Languages

| Feature | Forge | Go | Rust | TypeScript | Elixir |
|---|---|---|---|---|---|
| Compilation | Native (LLVM) | Native | Native (LLVM) | JIT (V8) | Bytecode (BEAM) |
| Type system | Structural | Structural | Nominal | Structural | Dynamic |
| Null safety | Kotlin-style `?` | Nil (unsafe) | `Option<T>` | Optional `?` | Pattern match |
| Concurrency | Implicit (Go-style) | Goroutines | async/await | async/await | Actors (OTP) |
| Memory | Ref counting | GC | Ownership | GC | GC |
| Extensibility | Package system | Interfaces | Traits + macros | Types | Macros |
| Built-in HTTP | Package | `net/http` | Libraries | Libraries | Phoenix |
| Built-in DB | Auto-persist | Libraries | Libraries | Libraries | Ecto |
| Binary output | Single binary | Single binary | Single binary | Requires Node/Bun | Requires BEAM |
| Agent-friendly | First-class | No | No | Partial | No |

---

## Appendix D: Glossary

- **Package:** A compiler plugin that registers keywords, syntax, and native implementations. The primary extensibility mechanism.
- **Model:** A data type declaration that auto-persists to a database.
- **Service:** Business logic layer around a model with lifecycle hooks and custom methods.
- **Extern Component:** A module implemented in another language (Rust, Go, Python) and linked into the Forge binary.
- **Embedded Block:** A syntax block (like `sql { ... }`) whose contents are parsed by a package, not the core parser.
- **Arena:** A memory allocation region where all objects are freed at once when the scope exits.
- **MIR:** Mid-level Intermediate Representation — Forge's internal representation after type checking but before LLVM IR generation.
- **Package SDK:** The library/framework used by package authors to build new packages.
- **Forge Context:** The LLM-loadable description of a project generated by `forge context`.

---

*End of Forge Language Specification v0.1.0-draft*
