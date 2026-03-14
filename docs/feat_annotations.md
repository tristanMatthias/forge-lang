# Forge — Validation System (TDD)

Validation is a **core language feature**, not a package feature. Annotations like `@min`, `@max`, `@validate` work on any shaped type — plain `type` aliases, `model` fields, function parameters, anonymous structs. Packages can extend the annotation registry, but the base set lives in the language.

Type operators (`with`, `without`, `only`, `as partial`) **inherit** validation annotations from their source type. You define constraints once; they flow everywhere.

---

## Annotations — Language Feature

Annotations (`@name` or `@name(args)`) are a **language-level** feature. The syntax `@ident` followed by optional parenthesized arguments is part of the grammar:

```
annotation = "@" IDENT ("(" args? ")")? ;
```

They are **metadata on declarations** — the compiler parses them, validates them, and passes them to whatever system consumes them (the language runtime, a package, or user code). They are not macros, they are not decorators that wrap functions. They are inert data until something reads them.

### Annotation Targets

Annotations attach to different kinds of declarations. Each annotation has an explicit **target** — the kind of thing it can be placed on. The compiler enforces this.

| Target | Where it appears | Example |
|---|---|---|
| **field** | On a field in a type, model, or struct | `name: string @min(1)` |
| **type** | On a type alias or model declaration | `@table("blog_posts")` on a model |
| **route** | On a route handler in a server block | `@auth(admin)` before a route |
| **component** | On a component block declaration | `@persist(postgres(...))` on a model |
| **function** | On a function declaration | `@deprecated("use v2")` on a fn |

A field annotation on a type-level target is a compile error, and vice versa. The compiler knows which target each annotation belongs to because the annotation is **declared** with an explicit target — either by the language core or by a package.

### Annotation Sources

Annotations come from three places:

**1. Core (language-level)** — Built into the compiler. Available everywhere, no import needed. These are primarily validation and data annotations on fields:

```forge
type Input = {
  name: string @min(1) @max(100),
  email: string @transform(it.lower().trim()) @validate(email),
  role: string? @default("member"),
  slug: string @pattern("^[a-z0-9-]+$"),
}
```

**2. Package-declared** — A component package declares annotations scoped to its context using the `annotation` keyword:

```forge
// Inside the @std/model package definition
component model(name: string) {
  annotation field primary()
  annotation field auto_increment()
  annotation field unique()
  annotation field hidden()
  annotation field owner(through: string?)
  annotation type table(name: string)
  // ...
}
```

These are only valid inside that package's blocks. `@primary` inside a `model` block is valid; `@primary` on a plain `type` field is a compile error.

```forge
// Inside the @std/http package definition
component server(port: int) {
  annotation route public()
  annotation route auth(roles: List<Role>)
  annotation route cache(ttl: duration)
  annotation route deprecated(reason: string)
  // ...
}
```

**3. User-declared** — Users can declare annotations in their own custom component definitions, following the same `annotation target name(args)` pattern:

```forge
component api(name: string) {
  annotation route version(v: int)
  annotation route rate_limit(max: int, window: duration)

  @syntax("{method} {path} -> {handler}")
  fn route(method: string, path: string, handler: fn, annotations: List<Annotation>) {
    if annotations.get("rate_limit") is Some(rl) {
      handler = wrap_rate_limit(handler, rl.max, rl.window)
    }
  }
}
```

### Annotation Consumption

Annotations are passed as data to the functions that handle the annotated declaration. In a component's `@syntax` function, annotations on the matched line are available as `List<Annotation>`:

```forge
@syntax("{name}: {type}")
fn field(name: string, type: Type, annotations: List<Annotation>) {
  // annotations contains @min(1), @validate(email), etc.
  // The package reads them and acts accordingly
}
```

For core annotations, the language runtime itself reads them at validation boundaries (assignment, function entry, HTTP body parsing, model operations).

### Target Mismatch — Compile Errors

```forge
// Field annotation on a type target
model User {
  name: string @table("custom")
}
```

```
  ╭─[error[F0073]] Annotation target mismatch
  │
  │    2 │   name: string @table("custom")
  │      │                 ──────────────
  │      │                 @table is a type annotation, not a field annotation
  │
  │  ├── help: move @table to the model level
  │  │    1 │ model User {
  │  │    2 │   @table("custom")
  │  │    3 │   name: string
  ╰──
```

```forge
// Route annotation on a field
type User = {
  name: string @auth(admin),
}
```

```
  ╭─[error[F0073]] Annotation target mismatch
  │
  │    2 │   name: string @auth(admin)
  │      │                 ──────────
  │      │                 @auth is a route annotation, not a field annotation
  │
  │  ├── available field annotations: @min, @max, @validate, @pattern, @transform, @default
  ╰──
```

```forge
// Package annotation outside its package context
type UserInput = {
  name: string @primary,    // @primary is a model field annotation, not available on plain types
}
```

```
  ╭─[error[F0074]] Annotation not available in this context
  │
  │    2 │   name: string @primary
  │      │                 ───────
  │      │                 @primary is declared by @std/model and can only be used inside model blocks
  │
  ╰──
```

---

## Part 1: Core Validation on Plain Types

### Test 1.1: Annotations on type fields

```forge
type ContactForm = {
  name: string @min(1) @max(100),
  email: string @validate(email),
  age: int @min(0) @max(150),
}

fn main() {
  let valid: ContactForm = { name: "alice", email: "a@test.com", age: 30 }
  println(valid.name)    // alice

  let result = validate({ name: "", email: "bad", age: -1 }, ContactForm)
  println(string(result is Err))    // true
}
```

### Test 1.2: validate() returns structured errors

```forge
type ContactForm = {
  name: string @min(1),
  email: string @validate(email),
  age: int @min(0) @max(150),
}

fn main() {
  let result = validate({ name: "", email: "not-email", age: -5 }, ContactForm)

  match result {
    Err(e) -> {
      println(string(e.fields.length))    // 3
      println(e.fields[0].field)          // name
      println(e.fields[0].rule)           // min
      println(e.fields[0].message)        // must be at least 1 character
      println(e.fields[1].field)          // email
      println(e.fields[1].rule)           // email
      println(e.fields[2].field)          // age
      println(e.fields[2].rule)           // min
    }
    Ok(_) -> println("should not reach")
  }
}
```

### Test 1.3: validate() returns typed Ok

```forge
type SignupInput = {
  name: string @min(1),
  email: string @validate(email),
}

fn process(input: SignupInput) {
  println(input.name)
}

fn main() {
  let raw = { name: "alice", email: "a@test.com" }
  match validate(raw, SignupInput) {
    Ok(input) -> process(input)    // input is SignupInput
    Err(e) -> println("invalid")
  }
  // alice
}
```

### Test 1.4: Custom validator on plain type

```forge
type Config = {
  port: int @validate((val) -> {
    if val < 1024 || val > 65535 {
      Err("port must be 1024-65535")
    } else {
      Ok(val)
    }
  }),
}

fn main() {
  let result = validate({ port: 80 }, Config)
  println(string(result is Err))    // true
}
```

### Test 1.5: Annotation on wrong type — compile error

```forge
type Bad = {
  name: int @validate(email),    // email validator on int
}
```

```
  ╭─[error[F0080]] Annotation type mismatch
  │
  │    2 │   name: int @validate(email)
  │      │              ───────────────
  │      │              @validate(email) requires string, got int
  │
  ╰──
```

### Test 1.6: Unknown annotation — compile error

```forge
type Bad = {
  name: string @required,    // not a core annotation
}
```

```
  ╭─[error[F0072]] Unknown annotation
  │
  │    2 │   name: string @required
  │      │                 ────────
  │      │                 @required is not a valid field annotation
  │
  │  ├── available: @min, @max, @validate, @default, @transform, @pattern
  ╰──
```

---

## Part 2: Core Annotation Registry

### Test 2.1: @min / @max on strings (length)

```forge
type Input = { name: string @min(2) @max(50) }

fn main() {
  println(string(validate({ name: "a" }, Input) is Err))       // true (too short)
  println(string(validate({ name: "al" }, Input) is Ok))       // true
  println(string(validate({ name: "a".repeat(51) }, Input) is Err))  // true (too long)
}
```

### Test 2.2: @min / @max on numbers (value)

```forge
type Input = { age: int @min(0) @max(150) }

fn main() {
  println(string(validate({ age: -1 }, Input) is Err))     // true
  println(string(validate({ age: 25 }, Input) is Ok))      // true
  println(string(validate({ age: 200 }, Input) is Err))    // true
}
```

### Test 2.3: @pattern for regex

```forge
type Input = {
  slug: string @pattern("^[a-z0-9-]+$"),
}

fn main() {
  println(string(validate({ slug: "hello-world" }, Input) is Ok))     // true
  println(string(validate({ slug: "Hello World!" }, Input) is Err))   // true
}
```

### Test 2.4: @validate with named validators

```forge
type Input = {
  email: string @validate(email),
  url: string @validate(url),
  uuid: string @validate(uuid),
}

fn main() {
  let bad = { email: "nope", url: "nope", uuid: "nope" }
  let result = validate(bad, Input)
  match result {
    Err(e) -> println(string(e.fields.length))    // 3
    Ok(_) -> println("should not reach")
  }
}
```

### Test 2.5: @transform runs before validation

```forge
type Input = {
  email: string @transform(it.lower().trim()) @validate(email),
}

fn main() {
  let result = validate({ email: "  ALICE@Test.Com  " }, Input)
  match result {
    Ok(input) -> println(input.email)    // alice@test.com
    Err(_) -> println("should not reach")
  }
}
```

### Test 2.6: @default provides fallback for optional fields

```forge
type Input = {
  role: string? @default("member"),
  active: bool? @default(true),
}

fn main() {
  let result = validate({}, Input)
  match result {
    Ok(input) -> {
      println(input.role)               // member
      println(string(input.active))     // true
    }
    Err(_) -> println("should not reach")
  }
}
```

---

## Part 3: Annotation Inheritance Through Type Operators

### Test 3.1: `without` inherits annotations

```forge
type User = {
  id: int,
  name: string @min(1) @max(100),
  email: string @validate(email),
  created_at: datetime,
}

type CreateUser = User without {id, created_at}

fn main() {
  // name still has @min(1) — inherited
  let result = validate({ name: "", email: "a@test.com" }, CreateUser)
  println(string(result is Err))       // true

  match result {
    Err(e) -> {
      println(e.fields[0].field)       // name
      println(e.fields[0].rule)        // min
    }
    Ok(_) -> {}
  }
}
```

### Test 3.2: `only` inherits annotations

```forge
type User = {
  id: int,
  name: string @min(1) @max(100),
  email: string @validate(email),
  password: string @min(8),
}

type UserPublic = User only {name, email}

fn main() {
  let result = validate({ name: "", email: "bad" }, UserPublic)
  match result {
    Err(e) -> {
      println(string(e.fields.length))    // 2
      println(e.fields[0].field)          // name
      println(e.fields[1].field)          // email
    }
    Ok(_) -> {}
  }
}
```

### Test 3.3: `with` inherits existing, adds new

```forge
type User = {
  name: string @min(1) @max(100),
  email: string @validate(email),
  password: string @min(8),
}

type CreateUser = User with { password_confirm: string @min(8) }

fn main() {
  // name @min(1) inherited, password_confirm @min(8) added
  let result = validate({
    name: "",
    email: "a@test.com",
    password: "secret123",
    password_confirm: "x",
  }, CreateUser)

  match result {
    Err(e) -> {
      println(string(e.fields.length))      // 2
      println(e.fields[0].field)            // name (min)
      println(e.fields[1].field)            // password_confirm (min)
    }
    Ok(_) -> {}
  }
}
```

### Test 3.4: `with` can override annotations on existing fields

```forge
type User = {
  name: string @min(1) @max(100),
}

type StricterUser = User with { name: string @min(3) @max(50) }

fn main() {
  // @min is now 3, not 1
  let result = validate({ name: "ab" }, StricterUser)
  println(string(result is Err))    // true (length 2 < min 3)
}
```

### Test 3.5: `as partial` — validation only on present fields

```forge
type User = {
  name: string @min(1) @max(100),
  email: string @validate(email),
  age: int @min(0),
}

type UserUpdate = User only {name, email, age} as partial

fn main() {
  // Only name provided — only name validated
  let result = validate({ name: "alice" }, UserUpdate)
  println(string(result is Ok))      // true

  // Email provided but invalid — fails
  let result2 = validate({ email: "bad" }, UserUpdate)
  println(string(result2 is Err))    // true

  // Empty object — all optional, all absent, no validation
  let result3 = validate({}, UserUpdate)
  println(string(result3 is Ok))     // true
}
```

### Test 3.6: Chained operators preserve annotations

```forge
type User = {
  id: int,
  name: string @min(1) @max(100),
  email: string @validate(email),
  password: string @min(8),
  role: string @default("member"),
  created_at: datetime,
}

type UpdateUser = User without {id, password, created_at} as partial

fn main() {
  // name still @min(1), email still @validate(email)
  let result = validate({ name: "" }, UpdateUser)
  println(string(result is Err))    // true

  let result2 = validate({ email: "bad" }, UpdateUser)
  println(string(result2 is Err))    // true

  let result3 = validate({ name: "alice" }, UpdateUser)
  println(string(result3 is Ok))     // true
}
```

### Test 3.7: @transform inherits through operators

```forge
type User = {
  email: string @transform(it.lower().trim()) @validate(email),
}

type CreateUser = User with { name: string @min(1) }

fn main() {
  let result = validate({ email: "  ALICE@TEST.COM  ", name: "alice" }, CreateUser)
  match result {
    Ok(input) -> println(input.email)    // alice@test.com
    Err(_) -> println("should not reach")
  }
}
```

---

## Part 4: Model Validation (Unchanged, But Now Shares Core)

Models use the same core annotations. `@std/model` adds package-specific annotations (`@primary`, `@auto_increment`, `@unique`, `@hidden`, `@owner`) but validation behavior is identical to plain types.

### Test 4.1: Model validates on create

```forge
use @std.model

model User {
  id: int @primary @auto_increment
  name: string @min(1) @max(100)
  email: string @validate(email)
}

fn main() {
  let result = User.create({ name: "", email: "bad" })
  match result {
    Err(e) -> {
      println(string(e.fields.length))    // 2
      println(e.fields[0].field)          // name
      println(e.fields[1].field)          // email
    }
    Ok(_) -> println("should not reach")
  }
}
```

### Test 4.2: Model validates on update

```forge
use @std.model

model User {
  id: int @primary @auto_increment
  name: string @min(1)
}

fn main() {
  let user = User.create({ name: "alice" })?
  let result = User.update(user.id, { name: "" })
  println(string(result is Err))    // true
}
```

### Test 4.3: Derived type from model inherits all

```forge
use @std.model

model User {
  id: int @primary @auto_increment
  name: string @min(1) @max(100)
  email: string @unique @validate(email)
  password: string @hidden @min(8)
  created_at: datetime @default(now)
}

type CreateUser = User without {id, created_at}

fn main() {
  // CreateUser inherits @min(1) on name, @validate(email) on email, @min(8) on password
  // Does NOT inherit @primary, @auto_increment, @unique, @hidden — those are package annotations
  // that only apply in model context
  let result = validate({ name: "", email: "bad", password: "short" }, CreateUser)
  match result {
    Err(e) -> println(string(e.fields.length))    // 3
    Ok(_) -> println("should not reach")
  }
}
```

### Test 4.4: Skip validation on model

```forge
use @std.model

model User {
  id: int @primary @auto_increment
  name: string @min(1)
}

fn main() {
  let user = User.create({ name: "" }, validate: false)?
  println(user.name)    // (empty string)
}
```

---

## Part 5: HTTP Body Validation

The server layer validates incoming request bodies against typed handler parameters. This uses the same annotation system — no separate "http validation" concept.

### Test 5.1: Typed handler validates body

```forge
use @std.http

type CreatePost = {
  title: string @min(1) @max(200),
  body: string @min(1),
  tags: List<string>?,
}

server :8080 {
  POST /posts -> (req: CreatePost) {
    // req is already validated — annotations enforced
    println(req.title)
  }
}
```

```bash
# Missing required field
curl -X POST localhost:8080/posts -d '{"title":"hello"}'
# 400 {"error":"validation failed","fields":[{"field":"body","rule":"required"}]}

# Annotation violation
curl -X POST localhost:8080/posts -d '{"title":"","body":"text"}'
# 400 {"error":"validation failed","fields":[{"field":"title","rule":"min","message":"must be at least 1 character"}]}

# Valid
curl -X POST localhost:8080/posts -d '{"title":"hello","body":"world"}'
# 200
```

### Test 5.2: Derived type on handler inherits validation

```forge
use @std.http
use @std.model

model User {
  id: int @primary @auto_increment
  name: string @min(1) @max(100)
  email: string @unique @validate(email)
  password: string @hidden @min(8)
  created_at: datetime @default(now)
}

type CreateUser = User without {id, created_at}

server :8080 {
  POST /users -> (req: CreateUser) {
    // HTTP layer validates: name @min(1), email @validate(email), password @min(8)
    // Model layer validates again on create (defense in depth)
    User.create(req)
  }
}
```

```bash
curl -X POST localhost:8080/users -d '{"name":"","email":"bad","password":"short"}'
# 400
# {
#   "error": "validation failed",
#   "fields": [
#     {"field": "name", "rule": "min", "message": "must be at least 1 character"},
#     {"field": "email", "rule": "email", "message": "must be a valid email"},
#     {"field": "password", "rule": "min", "message": "must be at least 8 characters"}
#   ]
# }
```

### Test 5.3: Partial type on handler — PATCH semantics

```forge
use @std.http
use @std.model

model User {
  id: int @primary @auto_increment
  name: string @min(1) @max(100)
  email: string @validate(email)
}

type UpdateUser = User only {name, email} as partial

server :8080 {
  PATCH /users/:id -> (req: UpdateUser) {
    User.update(req.params.id, req)
  }
}
```

```bash
# Only name provided — only name validated, passes
curl -X PATCH localhost:8080/users/1 -d '{"name":"bob"}'
# 200

# Only email provided — email validated, fails
curl -X PATCH localhost:8080/users/1 -d '{"email":"bad"}'
# 400 {"error":"validation failed","fields":[{"field":"email","rule":"email"}]}

# Empty body — all optional, passes
curl -X PATCH localhost:8080/users/1 -d '{}'
# 200
```

### Test 5.4: @transform runs at HTTP boundary

```forge
use @std.http

type CreateUser = {
  email: string @transform(it.lower().trim()) @validate(email),
  name: string @transform(it.trim()) @min(1),
}

server :8080 {
  POST /users -> (req: CreateUser) {
    // req.email is already lowercased and trimmed
    // req.name is already trimmed
    println(req.email)
  }
}
```

```bash
curl -X POST localhost:8080/users -d '{"email":"  ALICE@Test.Com  ","name":"  bob  "}'
# handler receives: email="alice@test.com", name="bob"
```

---

## Part 6: Intersection and Composition

### Test 6.1: Intersection merges annotations

```forge
type HasName = { name: string @min(1) @max(100) }
type HasEmail = { email: string @validate(email) }
type ContactInfo = HasName & HasEmail

fn main() {
  let result = validate({ name: "", email: "bad" }, ContactInfo)
  match result {
    Err(e) -> println(string(e.fields.length))    // 2
    Ok(_) -> {}
  }
}
```

### Test 6.2: Conflicting annotations in intersection — compile error

```forge
type A = { name: string @min(1) }
type B = { name: string @min(5) }
type C = A & B
```

```
  ╭─[error[F0081]] Conflicting annotations in intersection
  │
  │    3 │ type C = A & B
  │      │          ─────
  │      │          field 'name' has conflicting @min: 1 (from A) vs 5 (from B)
  │
  │  ├── help: use `with` to override: `type C = A & B with { name: string @min(5) }`
  ╰──
```

### Test 6.3: Structural typing respects annotations

```forge
fn create_user(input: { name: string @min(1), email: string @validate(email) }) {
  println(input.name)
}

fn main() {
  create_user({ name: "alice", email: "a@test.com" })    // alice
  create_user({ name: "", email: "bad" })                 // RUNTIME: validation error
}
```

---

## Part 7: Full Composition — The Dream

Everything together. Define once, validate everywhere.

```forge
use @std.http
use @std.model

// ── Model: single source of truth for constraints ──

model User {
  id: int @primary @auto_increment
  name: string @min(1) @max(100)
  email: string @unique @transform(it.lower().trim()) @validate(email)
  password: string @hidden @min(8)
  role: string @default("member")
  created_at: datetime @default(now)

  on before_create(data) {
    data with { password: hash_password(data.password) }
  }
}

// ── Derived types: inherit all validation ──

type CreateUser = User without {id, role, created_at} with {
  password_confirm: string @min(8) @validate((val, fields) -> {
    if val != fields.password { Err("passwords must match") } else { Ok(val) }
  })
}

type UpdateUser = User only {name, email} as partial
type UserResponse = User without {password}

// ── Server: zero validation boilerplate ──

server :8080 {
  // HTTP validates CreateUser (name @min(1), email @validate, password @min(8), password_confirm)
  // Model validates again on User.create (defense in depth)
  POST /users -> (req: CreateUser) {
    User.create(req without {password_confirm})
  }

  // HTTP validates UpdateUser (partial — only present fields checked)
  PATCH /users/:id -> (req: UpdateUser) {
    User.update(req.params.id, req)
  }

  // No body validation needed — read-only
  GET /users/:id -> (req) {
    let user = User.get(req.params.id) ?? throw NotFound
    user as UserResponse
  }
}
```

```bash
# Validation errors bubble from annotations defined on the model
curl -X POST localhost:8080/users \
  -d '{"name":"","email":"bad","password":"short","password_confirm":"nope"}'
# 400
# {
#   "error": "validation failed",
#   "fields": [
#     {"field": "name", "rule": "min", "message": "must be at least 1 character"},
#     {"field": "email", "rule": "email", "message": "must be a valid email"},
#     {"field": "password", "rule": "min", "message": "must be at least 8 characters"},
#     {"field": "password_confirm", "rule": "min", "message": "must be at least 8 characters"}
#   ]
# }

# Transform runs — email lowercased and trimmed at HTTP boundary
curl -X POST localhost:8080/users \
  -d '{"name":"alice","email":"  ALICE@Test.Com  ","password":"secret123","password_confirm":"secret123"}'
# 200 — email stored as "alice@test.com"

# Partial update — only validates provided fields
curl -X PATCH localhost:8080/users/1 -d '{"name":"bob"}'
# 200

# Partial update — validates the field that IS provided
curl -X PATCH localhost:8080/users/1 -d '{"email":"bad"}'
# 400 {"error":"validation failed","fields":[{"field":"email","rule":"email"}]}
```

---

## Annotation Tiers (Summary)

See **Annotations — Language Feature** above for full details on targets, sources, and consumption.

| Tier | Annotations | Target | Scope |
|---|---|---|---|
| **Core (language)** | `@min`, `@max`, `@validate`, `@pattern`, `@transform`, `@default` | field | Any shaped type — `type`, `model`, anonymous struct, function parameter |
| **Package (@std/model)** | `@primary`, `@auto_increment`, `@unique`, `@hidden`, `@owner` | field | `model` blocks only |
| **Package (@std/model)** | `@table`, `@persist` | type | `model` blocks only |
| **Package (@std/http)** | `@public`, `@auth`, `@cache`, `@deprecated`, `@version` | route | `server` blocks only |
| **User-defined** | Via `annotation target name(args)` in custom components | any declared target | Scoped to that component |

Type operators inherit **core field annotations**. Package annotations are context-bound and don't propagate to derived plain types (a `CreateUser` derived from `User` doesn't carry `@unique` — that's a database constraint, not a shape constraint).

---

## Validation Error Shape

All validation errors — from `validate()`, model operations, and HTTP body parsing — share the same structure:

```forge
type ValidationError = {
  fields: List<FieldError>,
}

type FieldError = {
  field: string,
  rule: string,
  message: string,
  value: any?,
}
```

---

## Open Questions

1. **Cross-field validation**: Test 7 shows `password_confirm` accessing `fields.password`. Is `(val, fields) ->` the right signature for custom validators that need sibling access? Or should this be a type-level `@validate` instead of field-level?

2. **Nested validation**: If a type has a field that is itself a shaped type with annotations, does `validate()` recurse? (Probably yes.)

3. **List item validation**: `tags: List<string @min(1)>` — do annotations inside generic params work? Or do you need `tags: List<string> @each(@min(1))`?

4. **Async validators**: `@validate(unique_email)` that checks the database — does this belong in core validation or only in model hooks?

5. **Validation order**: Transform → Default → Validate? Or Default → Transform → Validate?
