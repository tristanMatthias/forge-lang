# Forge — Components as Values

## The Change

Components are values. They're sugar over structs + impl + Drop. The `component` keyword stays for provider definitions. Instances are values of a generated struct type.

No inheritance. Composition + traits + type operators instead.

Components are classes. They're called components, they have nicer syntax, the user never writes `self`, and they're defined by providers. The bad parts of classes (inheritance, deep hierarchies) don't exist. The good parts (state, methods, construction, cleanup) are all here.

---

## Component Anatomy

A component body is purely declarative — fields, config, events, methods. All imperative code lives inside function bodies.

```forge
component queue(name: string) {
  config {
    retries: int = 3
    buffer_size: int = 1000
  }

  event message(msg: string)
  event error(err: string, msg: string)

  let id: int

  fn init() {
    id = forge_queue_create(name, config.buffer_size)
    if config.retries > 0 { forge_queue_set_retries(id, config.retries) }
  }

  fn send(data: json) {
    forge_queue_send(id, json.stringify(data))
  }

  fn receive() -> json? {
    let raw = forge_queue_receive(id)
    if raw == "" { null } else { json.parse(raw) }
  }

  fn depth() -> int {
    forge_queue_depth(id)
  }

  fn drop() {
    forge_queue_shutdown(id)
  }
}
```

| Part | What it is |
|---|---|
| `config { }` | Typed properties with defaults |
| `event name(args)` | Callback slots the user fills with `on` |
| `let field: type` | Instance state (struct fields) |
| `fn init()` | Constructor — runs when instance is created |
| `fn name()` | Methods — implicit self, compiler rewrites field references |
| `fn drop()` | Cleanup — compiler generates Drop trait impl |

No lifecycle hooks. No `on startup`. No `on main_end`. Just: init creates, methods operate, events react, drop cleans up.

## What the Compiler Generates

From the component above, the compiler produces (conceptually):

```rust
struct Queue {
    name: String,
    id: i64,
    config: QueueConfig,
    message_handler: Option<fn(String)>,
    error_handler: Option<fn(String, String)>,
}

struct QueueConfig {
    retries: i64,
    buffer_size: i64,
}

impl Queue {
    fn new(name: &str, config: QueueConfig) -> Queue {
        let mut q = Queue { name, config, id: 0, .. };
        // fn init() body:
        q.id = forge_queue_create(&q.name, q.config.buffer_size);
        if q.config.retries > 0 { forge_queue_set_retries(q.id, q.config.retries); }
        q
    }
    fn send(&self, data: JsonValue) { forge_queue_send(self.id, ...) }
    fn receive(&self) -> Option<JsonValue> { ... }
    fn depth(&self) -> i64 { forge_queue_depth(self.id) }
}

impl Drop for Queue {
    fn drop(&mut self) { forge_queue_shutdown(self.id) }
}
```

## User-Facing Syntax (unchanged)

```forge
// Declaration — creates a value bound to a name
queue orders {
  retries 3
  buffer_size 500
}

// Method calls — real method dispatch, type-checked
orders.send({ data: "hello" })
orders <- { data: "hello" }        // <- desugars to .send()
println(string(orders.depth()))

// It's a value — these all work now
let q = orders
fn process(q: Queue) { q.send({ data: "world" }) }
process(orders)
```

## What Users Never See

- `self` — compiler adds it implicitly. Provider author doesn't write it. User doesn't write it.
- The generated struct — user writes `queue orders { ... }`, not `Queue.new("orders", ...)`
- The impl block — user writes `orders.send()`, compiler routes to the method

## No Inheritance

Forge does not have inheritance. Use composition, traits, and type operators instead.

### Traits for shared behavior

```forge
trait Sendable {
  fn send(data: json)
}

// Multiple components can implement the same trait
// queue and channel both implement Sendable automatically
// because they both have fn send(data: json)

fn broadcast(targets: List<Sendable>, data: json) {
  targets.each(it.send(data))
}

broadcast([orders, notifications], { alert: "hello" })
```

### Type operators for shared structure

```forge
type Base = { id: int, created_at: datetime }
type User = Base with { name: string, email: string }
type Post = Base with { title: string, body: string }
```

### Composition for reuse

```forge
// Not "Server extends Logger" — Server HAS a logger
type Server = {
  port: int,
  logger: Logger,
}
```

## Fixing the Current Issues

### 1. No more name-mangled flat functions

Before:
```
queue orders { ... }
→ orders_send(), orders_receive()    // flat globals, collision risk
```

After:
```
queue orders { ... }
→ Queue struct with .send(), .receive() methods
→ orders is a Queue instance
→ proper method dispatch, no collisions
```

### 2. Type checking on method calls

```forge
queue orders { retries 3 }
orders.send({ data: "hello" })     // OK — Queue has .send()
orders.banana()                     // COMPILE ERROR: Queue has no method banana()
```

### 3. Multiple instances work naturally

```forge
queue orders { retries 3 }
queue notifications { retries 5 }

// Different instances of the same type
// No name collision
orders.send({ item: "widget" })
notifications.send({ alert: "new order" })
```

### 4. Components can be passed to functions

```forge
fn drain_queue(q: Queue) {
  while q.depth() > 0 {
    let msg = q.receive()
    println(msg)
  }
}

drain_queue(orders)
drain_queue(notifications)
```

### 5. Components work in collections

```forge
let queues = [orders, notifications, alerts]
queues.each(q -> println(string(q.depth())))
```

## Nested Components

Components can contain other components. This is just composition — a component's state includes other component values.

```forge
cli forge {
  version "0.1.0"

  command build {
    arg file: string
    flag release: bool = false
    run { ... }

    // Nested — command inside command
    command watch {
      flag poll: bool = false
      run { ... }
    }
  }

  command test {
    option filter: string?
    run { ... }
  }
}

fn main() {
  forge.run()    // walks the component tree, matches args, delegates
}
```

`command` is a component. `cli` contains commands. Commands can contain more commands. Components all the way down. No special nesting mechanism — just values containing values.

## Migration Steps

### 1. Generate struct types from component definitions

Component expansion produces a struct type. Config fields, `let` declarations, and event handlers become struct fields.

### 2. Implicit self — closure rewriting

Provider authors write `fn send(data: json)`. The compiler adds `self` as the first param. Any reference to a component-level field (like `id`) is rewritten to `self.id`. The compiler determines which fields a method references by analyzing the body.

```forge
// Provider writes:
fn send(data: json) {
  forge_queue_send(id, json.stringify(data))    // references `id`
}

// Compiler generates:
fn send(self: &Queue, data: json) {
  forge_queue_send(self.id, json.stringify(data))
}
```

The provider author never writes `self`. The compiler does the rewriting.

### 3. fn init() is the constructor

```forge
component queue(name: string) {
  config { retries: int = 3 }
  let id: int

  fn init() {
    id = forge_queue_create(name, config.buffer_size)
    if config.retries > 0 { forge_queue_set_retries(id, config.retries) }
  }
}
```

`fn init()` compiles to the struct's constructor. It's where imperative setup logic lives. No top-level code outside of function bodies. The component body is purely declarative — fields, config, events, methods.

### 4. fn drop() is cleanup

```forge
fn drop() {
  forge_queue_shutdown(id)
}
```

Compiler generates `impl Drop` from this. Called automatically when the instance goes out of scope. For top-level declarations, that's when main ends. No `on startup`. No `on main_end`. Just init and drop.

### 5. Instance declarations desugar to let bindings

```forge
queue orders { retries 3 }

// Desugars to:
let orders: Queue = Queue.init("orders", { retries: 3 })
```

### 6. Events become optional handler fields

```forge
event message(msg: string)

// Becomes a struct field:
message_handler: fn(string)? = null

// User's `on message(msg) { ... }` sets the field during construction
```

### 7. Method calls become real dispatch

```forge
orders.send(data)

// Compiles to real method call, not flat function lookup
// Type checker validates Queue has .send() method
```

### 8. `<-` desugars to .send()

```forge
orders <- data
// Desugars to:
orders.send(data)
```

### 9. Nested components are values in parent fields

```forge
cli forge {
  command build { ... }
  command test { ... }
}
```

The `cli` component holds `commands: List<Command>` as a struct field. Each `command` block constructs a Command instance and appends it to the parent's list during the parent's `fn init()`.

### 10. Remove old codegen

- Remove the `static_methods` name-mangling table
- Remove flat function generation for component methods
- Remove the `{instance}_{method}` naming convention

## What Stays the Same

- User syntax — `queue orders { ... }` / `orders.send()` — unchanged
- Provider author syntax — `component queue(name) { ... }` — unchanged
- Provider authors never write `self` — compiler adds it
- Config blocks — `config { retries: int = 3 }` — unchanged
- Events — `event message(msg)` — unchanged
- Annotations — `@secret`, `@owner`, etc. — unchanged
- `@syntax` sugar — unchanged
