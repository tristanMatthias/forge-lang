# Forge — Per-Field Mutability

Fields declare their own mutability. Immutable by default, opt into `mut`.

---

## The Rule

- Fields without `mut` are immutable after construction. Always.
- Fields with `mut` can be changed by the owner.
- `let`/`mut` on bindings controls reassignment only.
- Methods can mutate `mut` fields on self without any special syntax.

---

## Test 1: Basic field mutability

```forge
type Counter = {
  mut count: int,
  name: string,
}

fn main() {
  let c = Counter { count: 0, name: "visits" }
  c.count = 5         // OK — count is mut
  c.name = "other"    // ERROR: name is not mut
}
```

```
  ╭─[error[F0031]] Cannot mutate immutable field
  │
  │    5 │ c.name = "other"
  │      │ ────────────────
  │      │ name is not declared mut on Counter
  │
  │  ├── Counter.name is immutable after construction
  ╰──
```

## Test 2: let vs mut on bindings — reassignment only

```forge
type Point = { mut x: int, mut y: int }

fn main() {
  let p = Point { x: 1, y: 2 }
  p.x = 3                          // OK — field is mut
  p = Point { x: 10, y: 20 }      // ERROR — binding is let, can't reassign

  mut q = Point { x: 1, y: 2 }
  q.x = 3                          // OK — field is mut
  q = Point { x: 10, y: 20 }      // OK — binding is mut, can reassign
}
```

## Test 3: Methods mutate mut fields — no special syntax needed

```forge
type Counter = {
  mut count: int,
  name: string,
}

impl Counter {
  fn inc(self) {
    self.count = self.count + 1    // OK — count is mut
  }

  fn value(self) -> int {
    self.count                     // OK — reading is always fine
  }
}

fn main() {
  let c = Counter { count: 0, name: "visits" }
  c.inc()
  c.inc()
  println(string(c.value()))    // 2
}
```

## Test 4: Method trying to mutate immutable field — compile error

```forge
type Counter = {
  mut count: int,
  name: string,
}

impl Counter {
  fn rename(self, n: string) {
    self.name = n       // ERROR — name is not mut
  }
}
```

```
  ╭─[error[F0031]] Cannot mutate immutable field
  │
  │    9 │ self.name = n
  │      │ ─────────────
  │      │ name is not declared mut on Counter
  │
  │  ├── Counter.name is immutable after construction
  │  ├── help: declare it as `mut name: string` if it should be mutable
  ╰──
```

## Test 5: Fully immutable struct — no mut fields

```forge
type Color = {
  r: int,
  g: int,
  b: int,
}

fn main() {
  let red = Color { r: 255, g: 0, b: 0 }
  red.r = 128       // ERROR — r is not mut

  // Use with for new values instead
  let pink = red with { r: 255, g: 192, b: 203 }
  println(string(pink.r))    // 255
}
```

## Test 6: Fully mutable struct — all fields mut

```forge
type Cursor = {
  mut x: int,
  mut y: int,
  mut visible: bool,
}

fn main() {
  let c = Cursor { x: 0, y: 0, visible: true }
  c.x = 100
  c.y = 200
  c.visible = false    // all OK — all fields are mut
}
```

## Test 7: Reading is always allowed — mut only affects writes

```forge
type User = {
  name: string,
  mut login_count: int,
}

fn main() {
  let u = User { name: "alice", login_count: 0 }
  println(u.name)                    // OK — reading immutable field
  println(string(u.login_count))     // OK — reading mut field
  u.login_count = u.login_count + 1  // OK — writing mut field
  u.name = "bob"                     // ERROR — writing immutable field
}
```

## Test 8: Nested struct field mutability

```forge
type Config = {
  host: string,
  port: int,
}

type Server = {
  config: Config,
  mut connections: int,
}

fn main() {
  let s = Server {
    config: Config { host: "localhost", port: 8080 },
    connections: 0,
  }
  s.connections = 5         // OK — connections is mut
  s.config.port = 9090      // ERROR — config is not mut
}
```

```
  ╭─[error[F0031]] Cannot mutate immutable field
  │
  │    14 │ s.config.port = 9090
  │       │ ────────────────────
  │       │ config is not declared mut on Server
  │
  │  ├── To mutate config.port, declare config as mut:
  │  │     mut config: Config,
  ╰──
```

## Test 9: Nested struct — mut parent unlocks child field mutation

```forge
type Config = {
  host: string,
  mut port: int,
}

type Server = {
  mut config: Config,
  mut connections: int,
}

fn main() {
  let s = Server {
    config: Config { host: "localhost", port: 8080 },
    connections: 0,
  }
  s.config.port = 9090       // OK — config is mut AND port is mut
  s.config.host = "0.0.0.0"  // ERROR — config is mut but host is not
}
```

## Test 10: Components — internal state is mut, config is not

```forge
component queue(name: string) {
  config { retries: int = 3 }

  mut id: int

  fn init() {
    self.id = forge_queue_create(self.name, self.config.retries)
  }

  fn send(data: json) {
    forge_queue_send(self.id, data)
  }

  fn drop() {
    forge_queue_shutdown(self.id)
  }
}

// User side
queue orders { retries 3 }
orders.send({ data: "hello" })     // just works
orders.config.retries = 5          // ERROR — config fields are not mut
orders.name = "other"              // ERROR — name is not mut
```

## Test 11: Model fields

```forge
model User {
  id: int @primary @auto_increment         // immutable
  username: string @unique                  // immutable
  email: string                             // immutable
  mut login_count: int @default(0)          // mutable
  mut last_seen: datetime?                  // mutable
  created_at: datetime @default(now)        // immutable
}

fn main() {
  let user = User.find_by(.username: "alice")?
  user.login_count = user.login_count + 1   // OK — mut field
  user.last_seen = now()                     // OK — mut field
  user.username = "bob"                      // ERROR — not mut
  user.id = 999                              // ERROR — not mut
}
```

## Test 12: Type operators preserve field mutability

```forge
type Base = {
  id: int,
  mut status: string,
  created_at: datetime,
}

type Extended = Base with { mut priority: int }
// Extended has: id (immutable), mut status, created_at (immutable), mut priority

fn main() {
  let e = Extended { id: 1, status: "active", created_at: now(), priority: 5 }
  e.status = "done"      // OK — mut carries through from Base
  e.priority = 10        // OK — declared mut
  e.id = 2               // ERROR — not mut
}
```

## Test 13: with expression works on any field — creates a new value

```forge
type User = {
  name: string,
  email: string,
  mut login_count: int,
}

fn main() {
  let u = User { name: "alice", email: "a@b.com", login_count: 0 }

  // with creates a NEW value — doesn't mutate, so works on immutable fields
  let u2 = u with { name: "bob" }         // OK — new value
  let u3 = u with { login_count: 5 }      // OK — new value

  // Direct mutation only works on mut fields
  u.login_count = 5     // OK — mut field
  u.name = "bob"        // ERROR — not mut
}
```

## Test 14: Passing structs to functions

```forge
type Player = {
  name: string,
  mut score: int,
  mut health: int,
}

fn add_score(p: Player, points: int) {
  p.score = p.score + points    // OK — score is mut
  p.name = "cheater"            // ERROR — name is not mut
}

fn describe(p: Player) -> string {
  `${p.name}: score=${p.score} hp=${p.health}`
}

fn main() {
  let hero = Player { name: "Hero", score: 0, health: 100 }
  add_score(hero, 50)
  println(describe(hero))    // Hero: score=50 hp=100
}
```

## Test 15: Lists of structs with mut fields

```forge
type Todo = {
  title: string,
  mut done: bool,
}

fn main() {
  let todos = [
    Todo { title: "Buy milk", done: false },
    Todo { title: "Write spec", done: false },
  ]

  todos[0].done = true       // OK — done is mut
  todos[0].title = "other"   // ERROR — title is not mut

  let remaining = todos.filter(!it.done)
  println(string(remaining.length))    // 1
}
```

## Test 16: Trait methods respect field mutability

```forge
trait Resettable {
  fn reset(self)
}

type Counter = {
  mut count: int,
  name: string,
}

impl Resettable for Counter {
  fn reset(self) {
    self.count = 0        // OK — count is mut
    // self.name = ""     // would ERROR — name is not mut
  }
}

fn reset_all(items: List<Resettable>) {
  items.each(it.reset())
}
```

## Test 17: Enum variants with mut fields

```forge
enum Shape {
  circle { mut radius: float },
  rect { mut width: float, mut height: float },
  point,
}

fn main() {
  let s = Shape.circle { radius: 5.0 }
  s.radius = 10.0       // OK — radius is mut

  let r = Shape.rect { width: 3.0, height: 4.0 }
  r.width = 6.0         // OK — width is mut
}
```

## Test 18: Constructor sets all fields — mut doesn't affect construction

```forge
type Config = {
  name: string,
  version: string,
  mut debug: bool,
}

fn main() {
  // All fields are set at construction regardless of mut
  let cfg = Config { name: "app", version: "1.0", debug: false }

  // After construction, only mut fields can change
  cfg.debug = true      // OK
  cfg.name = "other"    // ERROR
  cfg.version = "2.0"   // ERROR
}
```

## Test 19: Compound assignment operators on mut fields

```forge
type Stats = {
  mut hits: int,
  mut total_bytes: int,
  name: string,
}

fn main() {
  let s = Stats { hits: 0, total_bytes: 0, name: "api" }
  s.hits += 1                  // OK — desugars to s.hits = s.hits + 1
  s.total_bytes += 1024        // OK
  // s.name += "_v2"           // ERROR — name is not mut
}
```

## Test 20: Pattern matching doesn't bypass mutability

```forge
type Pair = {
  key: string,
  mut value: int,
}

fn main() {
  let p = Pair { key: "x", value: 42 }

  match p {
    { key: "x", value: v } -> {
      println(string(v))     // OK — reading via pattern match
      p.value = v + 1        // OK — value is mut
      p.key = "y"            // ERROR — key is not mut
    }
  }
}
```

---

## Future: Abstraction Levels

When `systems` and `bare` blocks ship, per-field mutability combines with borrow checking:

- `&T` (shared reference) = no mutation, ever
- `&mut T` (mutable reference) = only `mut` fields can change (stricter than Rust)
- Owner = only `mut` fields can change

This is documented here for future reference but is not part of the current implementation.

---

## Summary

| Context | Immutable field | `mut` field |
|---|---|---|
| Read | Always OK | Always OK |
| Write (owner) | ERROR | OK |
| Write (method on self) | ERROR | OK |
| Write (function param) | ERROR | OK |
| `with` expression | OK (creates new value) | OK (creates new value) |
| Construction | Set once | Set once |

## Implementation

- Parser: `mut` keyword before field name in struct/type/model/component declarations
- Type checker: track per-field mutability in type info
- Assignment checker: on `x.field = value`, verify field is declared `mut`
- Nested access: `x.a.b = value` requires every field in the chain to allow mutation — `a` must be `mut` on x's type, `b` must be `mut` on a's type
- Method checker: on `self.field = value` inside methods, verify field is `mut`
- Type operators: `with`, `without`, `only` preserve `mut` annotations from source type
- `with` expression: always works (creates new value, not mutation)
- Compound assignment: `x.field += value` desugars to `x.field = x.field + value`, same rules apply
- Error messages: always name the field, the type, and suggest adding `mut` if appropriate
