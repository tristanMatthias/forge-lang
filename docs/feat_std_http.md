# Forge — @std/http + @std/model Comprehensive TDD Spec

Everything discussed about HTTP servers, models, auth, middleware, validation, relations, CRUD generation, websockets, SSE, type operators, annotations, and ownership — consolidated into one spec with tests.

---

# Part 1: Type Operators (Language Feature)

New language feature. Type-level operations for deriving types from other types.

## Test 1.1: without — remove fields

```forge
type User = {
  id: int,
  name: string,
  email: string,
  password: string,
  created_at: datetime,
}

type CreateUser = User without {id, created_at}

fn main() {
  let input: CreateUser = { name: "alice", email: "a@test.com", password: "secret123" }
  println(input.name)       // alice
  // input.id               // COMPILE ERROR: id does not exist on CreateUser
}
```

## Test 1.2: with — add fields

```forge
type Point = { x: float, y: float }
type Point3D = Point with { z: float }

fn main() {
  let p: Point3D = { x: 1.0, y: 2.0, z: 3.0 }
  println(string(p.z))     // 3
}
```

## Test 1.3: only — pick fields

```forge
type User = { id: int, name: string, email: string, password: string }
type UserPublic = User only {id, name, email}

fn main() {
  let u: UserPublic = { id: 1, name: "alice", email: "a@test.com" }
  println(u.name)           // alice
  // u.password             // COMPILE ERROR: password does not exist on UserPublic
}
```

## Test 1.4: as partial — all fields optional

```forge
type User = { name: string, email: string, age: int }
type UserUpdate = User only {name, email, age} as partial

fn main() {
  let update: UserUpdate = { name: "bob" }   // only name, others omitted
  println(update.name ?? "none")              // bob
  println(update.email ?? "none")             // none
}
```

## Test 1.5: Chaining operators

```forge
type User = { id: int, name: string, email: string, password: string, role: string }

type UpdateUser = User without {id, password} as partial
// { name: string?, email: string?, role: string? }

type CreateUser = User without {id} with {password_confirm: string}
// { name: string, email: string, password: string, role: string, password_confirm: string }

fn takes_update(u: UpdateUser) { println(u.name ?? "none") }
fn takes_create(c: CreateUser) { println(c.password_confirm) }

fn main() {
  takes_update({ email: "new@test.com" })     // none
  takes_create({
    name: "alice",
    email: "a@test.com",
    password: "secret",
    role: "member",
    password_confirm: "secret",
  })                                           // secret
}
```

## Test 1.6: Works on model-generated types

```forge
use @std.model

model User {
  id: int @primary @auto_increment
  name: string
  email: string @unique
  password: string @hidden
  created_at: datetime @default(now)
}

type CreateUser = User without {id, created_at}
type UserResponse = User without {password}

fn main() {
  let input: CreateUser = { name: "alice", email: "a@test.com", password: "secret" }
  println(input.name)        // alice
}
```

## Test 1.7: Shorthand field syntax

```forge
fn main() {
  let name = "alice"
  let email = "alice@test.com"

  // Shorthand — same name
  let user = { name, email, age: 30 }
  println(user.name)         // alice
  println(string(user.age))  // 30
}
```

---

# Part 2: Annotation System (Language Feature)

Annotations are metadata on declarations. Declared by components with explicit targets. Consumed by component functions as data.

## Test 2.1: Field annotations on model

```forge
use @std.model

model User {
  id: int @primary @auto_increment
  name: string @min(1) @max(100)
  email: string @unique @validate(email)
}

fn main() {
  let user = User.create({ name: "alice", email: "alice@test.com" })?
  println(user.name)          // alice
}
```

## Test 2.2: Invalid annotation — compile error

```forge
model User {
  name: string @primary_key    // wrong annotation name
}
```

```bash
forge build test_bad_annotation.fg 2>&1
```

```
  ╭─[error[F0072]] Unknown annotation
  │
  │    2 │   name: string @primary_key
  │      │                 ───────────
  │      │                 @primary_key is not a valid field annotation for model
  │
  │  ├── help: did you mean @primary?
  │  ├── available: @primary, @auto_increment, @unique, @default, @min, @max, @validate, @hidden, @owner
  ╰──
```

## Test 2.3: Model-level annotations

```forge
model Post {
  @table("blog_posts")

  id: int @primary @auto_increment
  title: string
}

fn main() {
  // Table name is "blog_posts" not "posts"
  let post = Post.create({ title: "Hello" })?
  println(post.title)        // Hello
}
```

## Test 2.4: Annotation on wrong target — compile error

```forge
model User {
  name: string @table("custom")   // @table is model-level, not field-level
}
```

```
  ╭─[error[F0073]] Annotation target mismatch
  │
  │    2 │   name: string @table("custom")
  │      │                 ──────────────
  │      │                 @table is a model annotation, not a field annotation
  │
  │  ├── help: move @table to the model level
  │  │    1 │ model User {
  │  │    2 │   @table("custom")
  │  │    3 │   name: string
  ╰──
```

## Test 2.5: Route annotations

```forge
use @std.http
use @std.auth

server :8080 {
  @public
  POST /register -> (req) {
    User.create(req.body)
  }

  @auth(admin)
  DELETE /users/:id -> (req) {
    User.delete(req.params.id)
  }

  @auth(editor, admin)
  @cache(ttl: 5m)
  GET /posts -> {
    Post.where(status: .published)
  }
}
```

## Test 2.6: Custom annotation in a provider

```forge
// In a custom component definition
component api(name: string) {
  annotation route deprecated(reason: string)
  annotation route version(v: int)

  @syntax("{method} {path} -> {handler}")
  fn route(method: string, path: string, handler: fn, annotations: List<Annotation>) {
    if annotations.get("deprecated") is Some(d) {
      // Add deprecation header to response
      wrap_deprecated(handler, d.reason)
    }
  }
}
```

---

# Part 3: Model — Validation

## Test 3.1: Min/max string length

```forge
model User {
  name: string @min(1) @max(100)
}

fn main() {
  let result = User.create({ name: "" })
  println(string(result is Err))    // true
}
```

## Test 3.2: Validation error has structured fields

```forge
model User {
  name: string @min(1)
  email: string @validate(email)
  age: int @min(0) @max(150)
}

fn main() {
  let result = User.create({ name: "", email: "not-email", age: -5 })

  match result {
    Err(e) -> {
      println(string(e.fields.length))         // 3
      println(e.fields[0].field)               // name
      println(e.fields[0].rule)                // min
      println(e.fields[1].field)               // email
      println(e.fields[1].rule)                // email
      println(e.fields[2].field)               // age
      println(e.fields[2].rule)                // min
    }
    Ok(_) -> println("should not reach")
  }
}
```

## Test 3.3: Custom validator

```forge
model User {
  email: string @validate((val) -> {
    if val.ends_with("@competitor.com") {
      Err("we don't serve competitors")
    } else {
      Ok(val)
    }
  })
}

fn main() {
  let result = User.create({ email: "spy@competitor.com" })
  println(string(result is Err))    // true
}
```

## Test 3.4: Skip validation

```forge
model User {
  name: string @min(1)
}

fn main() {
  // Bypass validation when you know what you're doing
  let user = User.create({ name: "" }, validate: false)?
  println(user.name)               // (empty string)
}
```

## Test 3.5: Validation runs on update too

```forge
model User {
  name: string @min(1)
}

fn main() {
  let user = User.create({ name: "alice" })?
  let result = User.update(user.id, { name: "" })
  println(string(result is Err))   // true
}
```

---

# Part 4: Model — Relations

## Test 4.1: belongs_to

```forge
model Post {
  id: int @primary @auto_increment
  title: string
  belongs_to author: User
}

model User {
  id: int @primary @auto_increment
  name: string
  has_many posts: Post
}

fn main() {
  let user = User.create({ name: "alice" })?
  let post = Post.create({ title: "Hello", author_id: user.id })?

  // Access the relation
  let loaded = Post.get(post.id)?.include(author)?
  println(loaded.author.name)      // alice
}
```

## Test 4.2: has_many

```forge
fn main() {
  let user = User.create({ name: "alice" })?
  Post.create({ title: "Post 1", author_id: user.id })?
  Post.create({ title: "Post 2", author_id: user.id })?

  let loaded = User.get(user.id)?.include(posts)?
  println(string(loaded.posts.length))   // 2
  println(loaded.posts[0].title)          // Post 1
}
```

## Test 4.3: has_many through (many-to-many)

```forge
model Post {
  id: int @primary @auto_increment
  title: string
  has_many tags: Tag through post_tags
}

model Tag {
  id: int @primary @auto_increment
  name: string @unique
  has_many posts: Post through post_tags
}

model PostTag {
  belongs_to post: Post
  belongs_to tag: Tag
}

fn main() {
  let post = Post.create({ title: "Hello" })?
  let tag1 = Tag.create({ name: "forge" })?
  let tag2 = Tag.create({ name: "lang" })?
  PostTag.create({ post_id: post.id, tag_id: tag1.id })?
  PostTag.create({ post_id: post.id, tag_id: tag2.id })?

  let loaded = Post.get(post.id)?.include(tags)?
  println(string(loaded.tags.length))    // 2
  println(loaded.tags.map(it.name).sorted().join(", "))  // forge, lang
}
```

## Test 4.4: Nested includes

```forge
fn main() {
  let post = Post.get(1)?.include(
    author,
    comments.include(author),
    tags
  )?

  println(post.author.name)
  println(string(post.comments.length))
  println(post.comments[0].author.name)
  println(post.tags[0].name)
}
```

## Test 4.5: N+1 compile warning

```forge
fn main() {
  let posts = Post.where(status: .published)
  posts.each(p -> println(p.author.name))    // WARNING: N+1
}
```

```
  ╭─[warning[F0310]] Possible N+1 query
  │
  │    3 │ posts.each(p -> println(p.author.name))
  │      │                        ────────
  │      │                        author is not included
  │
  │  ├── help: add .include(author) to the query
  │  │    2 │ let posts = Post.where(status: .published).include(author)
  ╰──
```

---

# Part 5: Model — Queries

## Test 5.1: Where with named params

```forge
fn main() {
  let posts = Post.where(status: .published, author_id: 1)
  println(string(posts.length))
}
```

## Test 5.2: Comparison operators

```forge
fn main() {
  let recent = Post.where(created_at: after(now() - 7d))
  let popular = Post.where(views: gt(100))
  let affordable = Product.where(price: between(10.0, 50.0))
  let named = User.where(name: like("ali%"))
}
```

## Test 5.3: Chained query builder

```forge
fn main() {
  let results = Post
    .where(status: .published)
    .where(views: gt(100))
    .order(created_at: .desc)
    .limit(10)
    .offset(20)

  println(string(results.length))
}
```

## Test 5.4: Or queries

```forge
fn main() {
  let results = Post
    .where(status: .published)
    .or(featured: true)
    .order(views: .desc)

  println(string(results.length))
}
```

## Test 5.5: Search

```forge
fn main() {
  let results = Post
    .where(status: .published)
    .search(title: "forge", body: "forge")
    .limit(20)

  println(string(results.length))
}
```

## Test 5.6: Paginate

```forge
fn main() {
  let page = Post
    .where(status: .published)
    .order(created_at: .desc)
    .paginate(page: 2, per: 10)

  println(string(page.data.length))       // up to 10
  println(string(page.total))             // total count
  println(string(page.total_pages))       // total / per
  println(string(page.current_page))      // 2
  println(string(page.has_next))          // bool
}
```

## Test 5.7: Count and aggregate

```forge
fn main() {
  let count = Post.where(status: .published).count()
  println(string(count))

  let avg = Product.where(category: "electronics").avg(price)
  println(string(avg))

  let total = Order.where(user_id: 1).sum(total)
  println(string(total))
}
```

## Test 5.8: Compile-time field validation

```forge
fn main() {
  Post.where(titel: "hello")    // COMPILE ERROR: typo
}
```

```
  ╭─[error[F0020]] Unknown field
  │
  │    2 │ Post.where(titel: "hello")
  │      │            ─────
  │      │            `titel` is not a field on Post
  │
  │  ├── help: did you mean `title`?
  ╰──
```

## Test 5.9: Raw SQL escape hatch

```forge
fn main() {
  let results = sql<List<Post>> `
    SELECT p.* FROM posts p
    JOIN post_tags pt ON pt.post_id = p.id
    JOIN tags t ON t.id = pt.tag_id
    WHERE t.name = ${"forge"}
    ORDER BY p.created_at DESC
  `

  println(string(results.length))
}
```

## Test 5.10: find_by

```forge
fn main() {
  let user = User.find_by(email: "alice@test.com")
  println(string(user is Some))     // true

  let missing = User.find_by(email: "nobody@test.com")
  println(string(missing is null))  // true
}
```

---

# Part 6: Model — Hooks (Events)

## Test 6.1: before_create modifies data

```forge
model Post {
  id: int @primary @auto_increment
  title: string
  slug: string

  on before_create(data) {
    data with { slug: data.title.lower().replace(" ", "-") }
  }
}

fn main() {
  let post = Post.create({ title: "Hello World" })?
  println(post.slug)           // hello-world
}
```

## Test 6.2: after_create side effect

```forge
let events = channel<string>(100)

model User {
  id: int @primary @auto_increment
  name: string
  email: string

  on after_create(user) {
    events <- `user_created:${user.email}`
  }
}

fn main() {
  User.create({ name: "alice", email: "a@test.com" })?
  let msg = <- events
  println(msg)                 // user_created:a@test.com
}
```

## Test 6.3: before_update modifies changes

```forge
model Post {
  id: int @primary @auto_increment
  title: string
  status: string @default("draft")
  published_at: datetime?

  on before_update(record, changes) {
    if changes.status is Some("published") && record.published_at is null {
      changes with { published_at: now() }
    } else {
      changes
    }
  }
}

fn main() {
  let post = Post.create({ title: "Draft" })?
  println(string(post.published_at is null))    // true

  let updated = Post.update(post.id, { status: "published" })?
  println(string(updated.published_at is not null))  // true
}
```

## Test 6.4: before_delete can prevent deletion

```forge
model User {
  id: int @primary @auto_increment
  name: string
  role: string @default("member")

  on before_delete(user) {
    if user.role == "admin" {
      Err("cannot delete admin users")
    } else {
      Ok(())
    }
  }
}

fn main() {
  let admin = User.create({ name: "boss", role: "admin" })?
  let result = User.delete(admin.id)
  println(string(result is Err))    // true
}
```

---

# Part 7: Model — Ownership

## Test 7.1: Simple @owner

```forge
model Post {
  id: int @primary @auto_increment
  title: string
  belongs_to author: User @owner
}

// In a server context with auth:
// PUT /posts/:id with role member
// → auth checks post.author_id == req.user.id automatically
```

## Test 7.2: Owner through relation

```forge
model Document {
  id: int @primary @auto_increment
  title: string
  belongs_to team: Team @owner(through: team.members)
}

model Team {
  id: int @primary @auto_increment
  name: string
  has_many members: User through team_members
}

// Auth checks: document.team.members.contains(req.user.id)
```

## Test 7.3: Custom authorize event

```forge
model AuditLog {
  id: int @primary @auto_increment
  action: string
  created_by: int

  on authorize(record, user) -> bool {
    user.role is .admin || record.created_by == user.id
  }
}
```

---

# Part 8: Auth Component

## Test 8.1: JWT auth setup

```forge
use @std.auth

auth {
  provider jwt {
    secret env("JWT_SECRET")
    expiry 7d
  }

  login(email: string, password: string) -> Token? {
    let user = User.find_by(email)?
    if verify_password(password, user.password) {
      issue_token(user)
    }
  }

  role admin { all }
  role editor { read, create, update }
  role member { read, create_own, update_own, delete_own }

  ownership {
    Post -> author_id
    Comment -> author_id
  }
}
```

## Test 8.2: Login endpoint

```forge
server :8080 {
  @public
  POST /login -> (req) {
    let token = auth.login(req.body.email, req.body.password)
    if token is Some(t) {
      { token: t }
    } else {
      respond(401, { error: "invalid credentials" })
    }
  }
}
```

```bash
curl -X POST localhost:8080/login -d '{"email":"alice@test.com","password":"secret"}'
# {"token":"eyJ..."}
```

## Test 8.3: Protected route

```forge
server :8080 {
  @auth(member, editor, admin)
  GET /me -> (req) {
    // req.user is populated by auth middleware
    User only {id, name, email, role} from req.user
  }
}
```

```bash
# Without token
curl localhost:8080/me
# 401 {"error":"unauthorized"}

# With token
curl localhost:8080/me -H "Authorization: Bearer eyJ..."
# {"id":1,"name":"alice","email":"alice@test.com","role":"member"}
```

## Test 8.4: Role-based access

```forge
server :8080 {
  @auth(admin)
  DELETE /users/:id -> (req) {
    User.delete(req.params.id)
  }
}
```

```bash
# As member
curl -X DELETE localhost:8080/users/1 -H "Authorization: Bearer member-token"
# 403 {"error":"forbidden"}

# As admin
curl -X DELETE localhost:8080/users/1 -H "Authorization: Bearer admin-token"
# {"deleted":true}
```

## Test 8.5: Ownership enforcement

```forge
server :8080 {
  @auth(member)
  PUT /posts/:id -> (req) {
    // member has update_own — auth checks post.author_id == req.user.id
    Post.update(req.params.id, req.body)
  }
}
```

```bash
# User 1 updating their own post
curl -X PUT localhost:8080/posts/1 -H "Authorization: Bearer user1-token" -d '{"title":"Updated"}'
# {"id":1,"title":"Updated",...}

# User 2 updating user 1's post
curl -X PUT localhost:8080/posts/1 -H "Authorization: Bearer user2-token" -d '{"title":"Hacked"}'
# 403 {"error":"forbidden"}
```

---

# Part 9: Server — CRUD Generation

## Test 9.1: Basic crud

```forge
server :8080 {
  crud User, Post
}
```

Auto-generates:
```
GET    /users          → User.list() with pagination
GET    /users/:id      → User.get(id)
POST   /users          → User.create(body)
PUT    /users/:id      → User.update(id, body)
DELETE /users/:id      → User.delete(id)
GET    /posts           → Post.list() with pagination
GET    /posts/:id       → Post.get(id)
POST   /posts           → Post.create(body)
PUT    /posts/:id       → Post.update(id, body)
DELETE /posts/:id       → Post.delete(id)
```

```bash
curl localhost:8080/users
# [{"id":1,"name":"alice",...}]

curl -X POST localhost:8080/users -d '{"name":"bob","email":"bob@test.com"}'
# {"id":2,"name":"bob",...}
```

## Test 9.2: CRUD with auth

```forge
server :8080 {
  crud User, Post {
    auth required

    @public
    POST /users            // registration is public

    @auth(admin)
    DELETE /users/:id      // only admins delete users
  }
}
```

## Test 9.3: CRUD with expose

```forge
server :8080 {
  crud User {
    expose { id, name, email, role, created_at }   // hide password
  }
}
```

```bash
curl localhost:8080/users/1
# {"id":1,"name":"alice","email":"alice@test.com","role":"member","created_at":"2026-03-12"}
# No password field
```

## Test 9.4: CRUD with custom handler override

```forge
server :8080 {
  crud User {
    GET /users/:id -> (req) {
      let user = User.get(req.params.id)?.include(posts)
      user without {password}
    }
  }
}
```

## Test 9.5: CRUD with nested routes

```forge
server :8080 {
  crud Post, Comment {
    nest Comment under Post at /posts/:post_id/comments
  }
}
```

```bash
curl localhost:8080/posts/1/comments
# [{"id":1,"body":"Great post!","post_id":1,...}]

curl -X POST localhost:8080/posts/1/comments -d '{"body":"Nice!"}'
# {"id":2,"body":"Nice!","post_id":1,...}
```

## Test 9.6: CRUD with hooks

```forge
server :8080 {
  crud Post {
    on before_create(data, req) {
      data with { author_id: req.user.id }
    }

    on after_create(post, req) {
      events <- { type: "post.created", data: post }
    }
  }
}
```

## Test 9.7: CRUD pagination

```forge
server :8080 {
  crud Post {
    paginate 20
  }
}
```

```bash
curl "localhost:8080/posts?page=2&per=10"
# {
#   "data": [...],
#   "total": 45,
#   "total_pages": 5,
#   "current_page": 2,
#   "has_next": true,
#   "has_prev": true
# }
```

---

# Part 10: Server — Middleware

## Test 10.1: Logger middleware

```forge
server :8080 {
  middleware logger {
    on request(req) {
      println(term.dim("→ ${req.method} ${req.path}"))
    }

    on response(req, res, elapsed) {
      let color = if res.status < 400 { term.green } else { term.red }
      println(color("← ${res.status}") + term.dim(" ${elapsed}ms"))
    }
  }

  GET /health -> { status: "ok" }
}
```

```bash
curl localhost:8080/health
# Terminal shows:
# → GET /health
# ← 200 0.3ms
```

## Test 10.2: Rate limiter

```forge
server :8080 {
  middleware rate_limit {
    window 1m
    max_requests 3
    by (req) -> req.ip

    on exceeded(req) {
      respond(429, { error: "too many requests" })
    }
  }

  GET /api -> { ok: true }
}
```

```bash
curl localhost:8080/api   # 200
curl localhost:8080/api   # 200
curl localhost:8080/api   # 200
curl localhost:8080/api   # 429 {"error":"too many requests"}
```

## Test 10.3: Middleware execution order

```forge
let order = channel<string>(10)

server :8080 {
  middleware first {
    on request(req) { order <- "first-in" }
    on response(req, res, elapsed) { order <- "first-out" }
  }

  middleware second {
    on request(req) { order <- "second-in" }
    on response(req, res, elapsed) { order <- "second-out" }
  }

  GET /test -> { ok: true }
}
```

After a request, order channel contains:
```
first-in, second-in, second-out, first-out
```

Onion model: first middleware wraps second.

## Test 10.4: Scoped middleware with under

```forge
server :8080 {
  middleware logger { ... }    // global

  under /api {
    middleware auth_required {
      on request(req) {
        if req.header("Authorization") is null {
          respond(401, { error: "unauthorized" })
        }
      }
    }

    GET /users -> User.list()      // auth required
    GET /posts -> Post.list()      // auth required
  }

  GET /health -> { status: "ok" }  // no auth
}
```

```bash
curl localhost:8080/health       # 200 (no auth needed)
curl localhost:8080/api/users    # 401 (auth required)
```

## Test 10.5: Nested under blocks

```forge
server :8080 {
  under /api {
    under /v1 {
      GET /users -> users_v1()
    }
    under /v2 {
      GET /users -> users_v2()
    }
  }
}
```

```bash
curl localhost:8080/api/v1/users   # v1 response
curl localhost:8080/api/v2/users   # v2 response
```

---

# Part 11: Server — Validation + Error Handling

## Test 11.1: Model validation errors auto-format

```forge
model User {
  name: string @min(1)
  email: string @validate(email)
}

server :8080 {
  crud User
}
```

```bash
curl -X POST localhost:8080/users -d '{"name":"","email":"bad"}'
# 400
# {
#   "error": "validation failed",
#   "fields": [
#     {"field": "name", "rule": "min", "message": "must be at least 1 character"},
#     {"field": "email", "rule": "email", "message": "must be a valid email"}
#   ]
# }
```

## Test 11.2: Custom error handler

```forge
server :8080 {
  on error(err, req) {
    match err {
      NotFound -> respond(404, { error: "not found", path: req.path })
      Unauthorized -> respond(401, { error: "unauthorized" })
      ValidationError(e) -> respond(400, { error: "validation failed", fields: e.fields })
      _ -> {
        println(term.red("unhandled: ${err}"))
        respond(500, { error: "internal error" })
      }
    }
  }

  GET /users/:id -> (req) {
    User.get(req.params.id) ?? throw NotFound
  }
}
```

```bash
curl localhost:8080/users/999
# 404 {"error":"not found","path":"/users/999"}
```

## Test 11.3: Request body type checking

```forge
type CreatePostInput = {
  title: string,
  body: string,
  tags: List<string>?,
}

server :8080 {
  POST /posts -> (req: CreatePostInput) {
    // req.body is already parsed and typed
    Post.create({ title: req.title, body: req.body })
  }
}
```

```bash
# Missing required field
curl -X POST localhost:8080/posts -d '{"title":"hello"}'
# 400 {"error":"validation failed","fields":[{"field":"body","rule":"required"}]}

# Wrong type
curl -X POST localhost:8080/posts -d '{"title":42,"body":"text"}'
# 400 {"error":"validation failed","fields":[{"field":"title","rule":"type","message":"expected string, got number"}]}
```

---

# Part 12: Server — WebSockets

## Test 12.1: Basic websocket

```forge
server :8080 {
  ws /echo -> (client) {
    on message(msg) {
      client.send(msg)
    }
  }
}
```

## Test 12.2: Chat room with channels

```forge
let room = channel<{from: string, text: string}>(1000)

server :8080 {
  ws /chat -> (client) {
    on connect {
      spawn {
        for msg in room {
          client.send(json.stringify(msg))
        }
      }
    }

    on message(msg) {
      room <- { from: client.id, text: msg }
    }

    on disconnect {
      room <- { from: "system", text: "${client.id} left" }
    }
  }
}
```

## Test 12.3: Authenticated websocket

```forge
server :8080 {
  @auth(member)
  ws /private -> (client) {
    // client.user is available because of @auth
    on message(msg) {
      println("${client.user.name}: ${msg}")
    }
  }
}
```

## Test 12.4: Raw binary websocket

```forge
server :8080 {
  ws /binary -> (client) {
    on message(raw: bytes) {
      let parsed = custom_decode(raw)
      let response = handle(parsed)
      client.send_bytes(custom_encode(response))
    }

    on ping { client.pong() }
    on close(code, reason) { cleanup(client) }
  }
}
```

---

# Part 13: Server — SSE

## Test 13.1: Basic SSE

```forge
let events = channel<{type: string, data: string}>(1000)

server :8080 {
  sse /events -> (stream) {
    for event in events {
      stream.send(event)
    }
  }

  POST /trigger -> (req) {
    events <- { type: "update", data: req.body }
    { sent: true }
  }
}
```

## Test 13.2: Filtered SSE per user

```forge
server :8080 {
  @auth(member)
  sse /my-events -> (stream, req) {
    events
      |> filter(it.user_id == req.user.id)
      |> each(stream.send(it))
  }
}
```

---

# Part 14: Server — File Handling

## Test 14.1: File upload

```forge
server :8080 {
  POST /upload -> (req) {
    let file = req.file("document")?
    assert file.size < 10mb, "file too large"
    assert file.type in ["application/pdf", "image/jpeg", "image/png"], "invalid format"

    let path = path("uploads") / file.name
    path.write_bytes(file.data)?

    { uploaded: true, path: string(path), size: file.size }
  }
}
```

## Test 14.2: File download / static files

```forge
server :8080 {
  // Serve static directory
  static "/assets" from "./public/assets"

  // Dynamic file download
  GET /download/:name -> (req) {
    let file = path("uploads") / req.params.name
    assert file.exists, NotFound
    respond_file(file)
  }
}
```

## Test 14.3: Streaming upload

```forge
server :8080 {
  POST /upload/large -> (req, stream) {
    let output = path("uploads") / req.header("X-Filename")
    
    for chunk in stream {
      output.append_bytes(chunk)?
    }
    
    { uploaded: true, size: output.size }
  }
}
```

---

# Part 15: Server — Streaming AI Response

## Test 15.1: SSE with AI streaming

```forge
server :8080 {
  GET /ai/summarize/:id -> (req) {
    let post = Post.get(req.params.id)?
    
    // Returns SSE stream — each chunk sent as it arrives from the AI
    ai.stream("Summarize: ${post.body}") {
      model "claude-haiku"
    }
  }
}
```

---

# Part 16: Server — Health and Observability

## Test 16.1: Health endpoint with dependencies

```forge
server :8080 {
  GET /health -> {
    {
      status: "ok",
      db: model.health(),
      uptime: process.uptime(),
      version: env("APP_VERSION") ?? "dev",
    }
  }
}
```

## Test 16.2: Request timing headers

```forge
server :8080 {
  middleware timing {
    on response(req, res, elapsed) {
      res.header("X-Response-Time", "${elapsed}ms")
    }
  }
}
```

---

# Part 17: Full Dream App

Everything together. This is the target — all features composed.

```forge
use @std.http
use @std.model
use @std.auth
use @std.ai
use @std.queue
use @std.cron
use @std.channel

// ── Types ──

enum Role { admin, editor, member }
enum PostStatus { draft, published, archived }

type CreatePost = Post without {id, slug, published_at, created_at, author}
type UpdatePost = Post only {title, body, status} as partial
type PostResponse = Post without {author_id} with {author: UserResponse}
type UserResponse = User without {password}

// ── Models ──

model User {
  id: int @primary @auto_increment
  name: string @min(1) @max(100)
  email: string @unique @validate(email)
  password: string @hidden @min(8)
  role: Role @default(.member)
  created_at: datetime @default(now)

  has_many posts: Post

  on before_create(data) {
    data with { password: hash_password(data.password) }
  }

  on after_create(user) {
    email_queue <- {
      to: user.email,
      subject: "Welcome",
      body: "Hi ${user.name}, welcome!",
    }
  }
}

model Post {
  @table("blog_posts")

  id: int @primary @auto_increment
  title: string @min(1) @max(200)
  body: string
  slug: string @unique
  status: PostStatus @default(.draft)
  published_at: datetime?
  created_at: datetime @default(now)

  belongs_to author: User @owner
  has_many comments: Comment
  has_many tags: Tag through post_tags

  on before_create(data) {
    data with { slug: data.title.lower().replace(" ", "-") }
  }

  on before_update(record, changes) {
    if changes.status is Some(.published) && record.published_at is null {
      changes with { published_at: now() }
    } else {
      changes
    }
  }
}

model Comment {
  id: int @primary @auto_increment
  body: string @min(1)
  created_at: datetime @default(now)

  belongs_to post: Post
  belongs_to author: User @owner
}

model Tag {
  id: int @primary @auto_increment
  name: string @unique
  has_many posts: Post through post_tags
}

model PostTag {
  belongs_to post: Post
  belongs_to tag: Tag
}

// ── Auth ──

auth {
  provider jwt {
    secret env("JWT_SECRET")
    expiry 7d
  }

  login(email: string, password: string) -> Token? {
    let user = User.find_by(email)?
    if verify_password(password, user.password) {
      issue_token(user)
    }
  }

  role admin { all }
  role editor { read, create, update }
  role member { read, create_own, update_own, delete_own }
}

// ── Events ──

let events = channel<{type: string, data: any}>(10000)

// ── Server ──

server :8080 {
  cors true
  logging true

  middleware logger {
    on request(req) {
      println(term.dim("→ ${req.method} ${req.path}"))
    }
    on response(req, res, elapsed) {
      let color = if res.status < 400 { term.green } else { term.red }
      println(color("← ${res.status}") + term.dim(" ${elapsed}ms"))
    }
  }

  on error(err, req) {
    match err {
      NotFound -> respond(404, { error: "not found" })
      Unauthorized -> respond(401, { error: "unauthorized" })
      Forbidden -> respond(403, { error: "forbidden" })
      ValidationError(e) -> respond(400, { error: "validation failed", fields: e.fields })
      _ -> respond(500, { error: "internal error" })
    }
  }

  // Auth endpoints
  @public
  POST /login -> (req) {
    let token = auth.login(req.body.email, req.body.password)
    token ?? throw Unauthorized
    { token }
  }

  @public
  POST /register -> (req) {
    User.create(req.body)
  }

  // Auto-CRUD with overrides
  under /api {
    crud User, Post, Comment, Tag {
      auth required
      paginate 20

      expose User as UserResponse
      expose Post as PostResponse

      @public
      GET /posts                     // public listing

      @auth(admin)
      DELETE /users/:id              // admin only

      nest Comment under Post at /posts/:post_id/comments

      on before_create Post (data, req) {
        data with { author_id: req.user.id }
      }

      on after_create Post (post, req) {
        events <- { type: "post.created", data: post }
      }
    }

    // Custom endpoints alongside CRUD
    GET /posts/trending -> {
      Post.where(status: .published)
        .order(views: .desc)
        .limit(10)
        .include(author, tags)
    }

    GET /posts/search -> (req) {
      Post.where(status: .published)
        .search(title: req.query.q, body: req.query.q)
        .include(author, tags)
        .paginate(req.query.page ?? 1, per: 20)
    }

    @auth(member)
    POST /posts/:id/ai-summary -> (req) {
      let post = Post.get(req.params.id)?
      let summary = ai.ask("Summarize in 2 sentences: ${post.body}") {
        model "claude-haiku"
      }
      { summary }
    }
  }

  // Static files
  static "/assets" from "./public"

  // SSE for real-time events
  @auth(member)
  sse /events -> (stream, req) {
    events
      |> filter(it.type.starts_with("post."))
      |> each(stream.send(it))
  }

  // Health
  GET /health -> {
    { status: "ok", db: model.health(), uptime: process.uptime() }
  }
}

// ── Background Jobs ──

queue email_queue {
  retries 3
  backoff exponential

  on message(msg) {
    send_email(msg.to, msg.subject, msg.body)
  }

  on error(err, msg) {
    println(term.red("email failed: ${err}"))
  }
}

// ── Scheduled Jobs ──

schedule daily_digest {
  every 24h

  run {
    let posts = Post.where(
      status: .published,
      created_at: after(now() - 24h),
    )

    if posts.length > 0 {
      let subscribers = User.where(role: .member)
      subscribers.each(user -> {
        email_queue <- {
          to: user.email,
          subject: "Daily Digest",
          body: render_digest(posts),
        }
      })
    }
  }
}
```

---

# Implementation Scope

## New Language Features

| Feature | Tests |
|---|---|
| `without` type operator | 1.1, 1.6 |
| `with` type operator (type level) | 1.2 |
| `only` type operator | 1.3 |
| `as partial` type modifier | 1.4 |
| Chaining type operators | 1.5 |
| Shorthand field `{ name }` → `{ name: name }` | 1.7 |
| Annotation declarations in components | 2.1–2.6 |
| Annotation target validation | 2.4 |
| `sql` template literal | 5.9 |
| `under` route grouping | 10.4, 10.5 |

## @std/model Enhancements

| Feature | Tests |
|---|---|
| Validation: @min, @max, @validate | 3.1–3.5 |
| Structured validation errors | 3.2 |
| Custom validators | 3.3 |
| Skip validation | 3.4 |
| belongs_to / has_many / has_many through | 4.1–4.4 |
| .include() for relation loading | 4.1–4.4 |
| N+1 compile warning | 4.5 |
| .where() with named params | 5.1 |
| Comparison operators (gt, after, between, like) | 5.2 |
| .order(), .limit(), .offset() | 5.3 |
| .or() | 5.4 |
| .search() | 5.5 |
| .paginate() | 5.6 |
| .count(), .avg(), .sum() | 5.7 |
| Compile-time field validation | 5.8 |
| .find_by() | 5.10 |
| Lifecycle hooks (before/after create/update/delete) | 6.1–6.4 |
| @owner simple | 7.1 |
| @owner through | 7.2 |
| Custom authorize event | 7.3 |
| @table model annotation | 2.3 |
| @hidden field annotation | dream app |

## @std/auth

| Feature | Tests |
|---|---|
| JWT provider config | 8.1 |
| Login function | 8.2 |
| Route protection with @auth | 8.3 |
| Role-based access | 8.4 |
| Ownership enforcement | 8.5 |
| @public annotation | 8.2, 9.2 |

## @std/http Enhancements

| Feature | Tests |
|---|---|
| crud auto-generation | 9.1–9.7 |
| crud with auth/expose/nest/hooks | 9.2–9.6 |
| Middleware component | 10.1–10.5 |
| Middleware execution order (onion) | 10.3 |
| under route grouping | 10.4–10.5 |
| Validation error auto-formatting | 11.1 |
| Custom error handler | 11.2 |
| Typed request body | 11.3 |
| WebSocket support | 12.1–12.4 |
| SSE support | 13.1–13.2 |
| File upload/download | 14.1–14.3 |
| Static file serving | 14.2 |
| AI streaming endpoint | 15.1 |
| Health endpoint | 16.1 |
| Response timing headers | 16.2 |
