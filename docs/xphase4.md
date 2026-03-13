# Forge — Phase 4: Provider System Completion (TDD)

**Goal:** Kill `providers.rs`. Build `@std/queue` and `@std/cron` entirely through the provider system with zero compiler changes. Validate the architecture.

**Approach:** Every section starts with tests. Write the tests first, then implement until they pass.

---

## Part 1: Kill providers.rs

The expansion engine must generate real Forge AST (function declarations, extern fn calls, struct types) instead of bridging to old provider-specific AST nodes. When done, `providers.rs` is deleted.

### Tests

Write these as Forge programs. Each must compile and produce the expected output. They're the same programs that work today — the only change is the codegen path.

**Test 1.1: Model CRUD still works**

```forge
// test_provider_refactor_model.fg
use @std.model.{model}

model Item {
  id: int @primary @auto_increment
  name: string
  price: float @default(0.0)
}

fn main() {
  let a = Item.create({ name: "Widget", price: 9.99 })
  let b = Item.create({ name: "Gadget", price: 19.99 })

  println(string(Item.count()))            // 2
  println(Item.get(1)?.name ?? "missing")  // Widget

  let all = Item.list()
  for item in all {
    println(`${item.name}: ${item.price}`)
  }
  // Widget: 9.99
  // Gadget: 19.99

  Item.delete(1)
  println(string(Item.count()))            // 1
}
```

Expected output:
```
2
Widget
Widget: 9.99
Gadget: 19.99
1
```

**Test 1.2: Service hooks still work**

```forge
// test_provider_refactor_service.fg
use @std.model.{model, service}

model Task {
  id: int @primary @auto_increment
  title: string
  status: string @default("pending")
}

service TaskService for Task {
  on before_create(task) {
    assert task.title.length > 0, "title required"
    println(`creating: ${task.title}`)
  }

  on after_create(task) {
    println(`created: ${task.id}`)
  }

  fn complete(task: Task) -> Task {
    Task.update(task, { status: "done" })
  }
}

fn main() {
  let t = TaskService.create({ title: "Test task" })
  println(t.status)
  let done = TaskService.complete(t)
  println(done.status)
}
```

Expected output:
```
creating: Test task
created: 1
pending
done
```

**Test 1.3: HTTP server still works**

```forge
// test_provider_refactor_http.fg
use @std.model.{model, service}
use @std.http.{server}

model Note {
  id: int @primary @auto_increment
  text: string
}

service NoteService for Note {}

server :9100 {
  route("GET", "/ping", (req) -> { pong: true })
  mount(NoteService, "/notes")
}
```

Test with:
```bash
forge build test_provider_refactor_http.fg -o test_http
./test_http &
sleep 1
curl -s http://localhost:9100/ping                              # {"pong":true}
curl -s -X POST http://localhost:9100/notes -d '{"text":"hi"}'  # {"id":1,"text":"hi"}
curl -s http://localhost:9100/notes                             # [{"id":1,"text":"hi"}]
kill %1
```

**Test 1.4: Multiple servers on different ports**

```forge
// test_multi_server.fg
use @std.http.{server}

server :9200 {
  route("GET", "/api", (req) -> { service: "api" })
}

server :9201 {
  route("GET", "/admin", (req) -> { service: "admin" })
}
```

Test with:
```bash
forge build test_multi_server.fg -o test_multi
./test_multi &
sleep 1
curl -s http://localhost:9200/api     # {"service":"api"}
curl -s http://localhost:9201/admin   # {"service":"admin"}
kill %1
```

**Test 1.5: Compiler has zero provider-specific code**

```bash
# After refactor, this should return 0 matches:
grep -r "ModelDecl\|ServiceDecl\|ServerBlock" compiler/src/ --include="*.rs" | grep -v test | grep -v providers.rs | wc -l
# Expected: 0

# providers.rs should not exist:
test ! -f compiler/src/codegen/providers.rs && echo "PASS" || echo "FAIL"
# Expected: PASS

# The compiler binary should not link rusqlite or tiny_http:
nm target/release/forge | grep -i sqlite | wc -l   # 0
nm target/release/forge | grep -i tiny_http | wc -l # 0
```

### Implementation Steps

1. Make the keyword expansion engine emit `FnDecl` AST nodes for generated CRUD functions
2. Make it emit `ExternFn` references for native calls
3. Make it emit struct type declarations for model types
4. Rewire service hook wrapping to generate regular function AST with hook calls inlined
5. Rewire server codegen to generate `extern fn` calls + closure definitions
6. Delete `ModelDecl`, `ServiceDecl`, `ServerBlock` from the AST enum
7. Delete `providers.rs`
8. Run all tests — every one must pass identically

---

## Part 2: @std/queue Provider

Build a message queue provider entirely through `provider.fg` + native Rust library. Zero compiler changes.

### Tests

**Test 2.1: Basic queue send/receive**

```forge
// test_queue_basic.fg
use @std.queue.{queue, worker}

queue task_queue {}

worker task_processor {
  consume task_queue

  on message(msg) {
    println(`received: ${msg.payload}`)
  }
}

fn main() {
  task_queue.send({ payload: "hello" })
  task_queue.send({ payload: "world" })

  // Give worker time to process
  sleep(100ms)
}
```

Expected output (order may vary):
```
received: hello
received: world
```

**Test 2.2: Queue with config**

```forge
// test_queue_config.fg
use @std.queue.{queue, worker}

queue email_queue {
  max_retries 3
  buffer_size 100
}

worker email_sender {
  consume email_queue
  concurrency 2

  on message(msg) {
    println(`sending to: ${msg.to}`)
  }

  on error(err, msg) {
    println(`failed: ${err}`)
  }
}

fn main() {
  email_queue.send({ to: "alice@test.com", subject: "Hello" })
  email_queue.send({ to: "bob@test.com", subject: "Hi" })
  sleep(100ms)
}
```

Expected output:
```
sending to: alice@test.com
sending to: bob@test.com
```

**Test 2.3: Queue depth and drain**

```forge
// test_queue_depth.fg
use @std.queue.{queue}

queue work_queue {}

fn main() {
  work_queue.send({ data: "a" })
  work_queue.send({ data: "b" })
  work_queue.send({ data: "c" })

  println(string(work_queue.depth()))  // 3

  let msg = work_queue.receive()
  println(msg?.data ?? "empty")        // a
  println(string(work_queue.depth()))  // 2
}
```

Expected output:
```
3
a
2
```

### Provider Definition

```toml
# providers/std-queue/provider.toml
[provider]
name = "queue"
namespace = "std"
version = "0.1.0"

[native]
library = "forge_queue"

[keywords.queue]
kind = "block"
context = "top_level"
body = "mixed"

[keywords.worker]
kind = "block"
context = "top_level"
body = "mixed"
```

```forge
// providers/std-queue/src/provider.fg

extern fn forge_queue_create(name: string, buffer_size: int) -> int
extern fn forge_queue_send(queue_id: int, payload_json: string)
extern fn forge_queue_receive(queue_id: int) -> string
extern fn forge_queue_depth(queue_id: int) -> int
extern fn forge_queue_start_worker(queue_id: int, concurrency: int, handler: fn(string) -> int, error_handler: fn(string, string) -> void)

keyword queue(name: string, config, schema) {
  config {
    max_retries: int = 3
    buffer_size: int = 1000
  }

  let id = forge_queue_create(name, config.buffer_size)

  fn send(payload: json) {
    forge_queue_send(id, json.stringify(payload))
  }

  fn receive() -> json? {
    let raw = forge_queue_receive(id)
    if raw == "" { null } else { json.parse(raw) }
  }

  fn depth() -> int {
    forge_queue_depth(id)
  }
}

keyword worker(name: string, config, schema) {
  config {
    concurrency: int = 1
  }

  // Setup — the user's body defines on message and on error handlers
  // These are captured and passed to the native worker start function

  // User's block body inserted here (contains consume, on message, on error)

  on startup {
    // Start the worker with the handlers defined in the user's body
    forge_queue_start_worker(
      queue_ref.id,
      config.concurrency,
      message_handler,
      error_handler
    )
  }
}
```

### Native Library (Rust)

```rust
// providers/std-queue/src/lib.rs
// In-process message queue using crossbeam channels

use crossbeam_channel::{bounded, Sender, Receiver};
use std::collections::HashMap;
use std::sync::Mutex;
use std::os::raw::c_char;
use std::ffi::{CStr, CString};
use std::thread;

static QUEUES: Mutex<HashMap<i64, (Sender<String>, Receiver<String>)>> = Mutex::new(HashMap::new());
static NEXT_ID: Mutex<i64> = Mutex::new(1);

#[no_mangle]
pub extern "C" fn forge_queue_create(name: *const c_char, buffer_size: i64) -> i64 {
    let (tx, rx) = bounded(buffer_size as usize);
    let mut id_lock = NEXT_ID.lock().unwrap();
    let id = *id_lock;
    *id_lock += 1;
    QUEUES.lock().unwrap().insert(id, (tx, rx));
    id
}

#[no_mangle]
pub extern "C" fn forge_queue_send(queue_id: i64, payload: *const c_char) {
    let payload = unsafe { CStr::from_ptr(payload) }.to_str().unwrap().to_string();
    let queues = QUEUES.lock().unwrap();
    if let Some((tx, _)) = queues.get(&queue_id) {
        tx.send(payload).ok();
    }
}

#[no_mangle]
pub extern "C" fn forge_queue_receive(queue_id: i64) -> *const c_char {
    let queues = QUEUES.lock().unwrap();
    if let Some((_, rx)) = queues.get(&queue_id) {
        match rx.try_recv() {
            Ok(msg) => CString::new(msg).unwrap().into_raw(),
            Err(_) => CString::new("").unwrap().into_raw(),
        }
    } else {
        CString::new("").unwrap().into_raw()
    }
}

#[no_mangle]
pub extern "C" fn forge_queue_depth(queue_id: i64) -> i64 {
    let queues = QUEUES.lock().unwrap();
    if let Some((_, rx)) = queues.get(&queue_id) {
        rx.len() as i64
    } else {
        0
    }
}

#[no_mangle]
pub extern "C" fn forge_queue_start_worker(
    queue_id: i64,
    concurrency: i64,
    handler: extern "C" fn(*const c_char) -> i64,
    error_handler: extern "C" fn(*const c_char, *const c_char),
) {
    let queues = QUEUES.lock().unwrap();
    if let Some((_, rx)) = queues.get(&queue_id) {
        let rx = rx.clone();
        for _ in 0..concurrency {
            let rx = rx.clone();
            thread::spawn(move || {
                for msg in rx.iter() {
                    let msg_c = CString::new(msg.as_str()).unwrap();
                    let result = handler(msg_c.as_ptr());
                    if result != 0 {
                        let err_c = CString::new("handler failed").unwrap();
                        error_handler(err_c.as_ptr(), msg_c.as_ptr());
                    }
                }
            });
        }
    }
}
```

Cargo.toml:
```toml
[package]
name = "forge_queue"
version = "0.1.0"
edition = "2021"

[lib]
crate-type = ["staticlib"]

[dependencies]
crossbeam-channel = "0.5"
```

### Verification

```bash
# The key test: did we modify the compiler at all?
git diff --stat compiler/src/
# Expected: 0 files changed
```

---

## Part 3: @std/cron Provider

Scheduled task execution. Again, zero compiler changes.

### Tests

**Test 3.1: Basic schedule**

```forge
// test_cron_basic.fg
use @std.cron.{schedule}

schedule cleanup {
  every 1s

  run {
    println("tick")
  }
}

fn main() {
  // Let it tick 3 times
  sleep(3500ms)
}
```

Expected output:
```
tick
tick
tick
```

**Test 3.2: Cron expression**

```forge
// test_cron_expr.fg
use @std.cron.{schedule}

schedule report {
  cron "*/2 * * * * *"    // every 2 seconds

  run {
    println("report generated")
  }
}

fn main() {
  sleep(5s)
}
```

Expected output (approximately):
```
report generated
report generated
```

**Test 3.3: Schedule with config**

```forge
// test_cron_config.fg
use @std.cron.{schedule}

schedule sync {
  every 1s
  timeout 500ms
  max_retries 2

  run {
    println("syncing")
  }

  on error(err) {
    println(`sync failed: ${err}`)
  }
}

fn main() {
  sleep(3500ms)
}
```

Expected output:
```
syncing
syncing
syncing
```

### Provider Definition

```toml
# providers/std-cron/provider.toml
[provider]
name = "cron"
namespace = "std"
version = "0.1.0"

[native]
library = "forge_cron"

[keywords.schedule]
kind = "block"
context = "top_level"
body = "mixed"
```

```forge
// providers/std-cron/src/provider.fg

extern fn forge_cron_create(name: string) -> int
extern fn forge_cron_set_interval_ms(schedule_id: int, ms: int)
extern fn forge_cron_set_cron(schedule_id: int, expr: string)
extern fn forge_cron_start(schedule_id: int, handler: fn() -> int, error_handler: fn(string) -> void)
extern fn forge_cron_start_all()

keyword schedule(name: string, config, schema) {
  config {
    timeout: int = 30000       // ms
    max_retries: int = 0
  }

  let id = forge_cron_create(name)

  // Functions available in the schedule block
  fn every(interval: duration) {
    forge_cron_set_interval_ms(id, interval.to_ms())
  }

  fn cron(expr: string) {
    forge_cron_set_cron(id, expr)
  }

  // User's block body inserted here (contains every/cron, run, on error)

  on startup {
    forge_cron_start(id, run_handler, error_handler)
  }
}
```

### Native Library (Rust)

```rust
// providers/std-cron/src/lib.rs

use std::collections::HashMap;
use std::sync::Mutex;
use std::os::raw::c_char;
use std::ffi::{CStr, CString};
use std::thread;
use std::time::Duration;

struct ScheduleEntry {
    name: String,
    interval_ms: Option<u64>,
    cron_expr: Option<String>,
}

static SCHEDULES: Mutex<HashMap<i64, ScheduleEntry>> = Mutex::new(HashMap::new());
static NEXT_ID: Mutex<i64> = Mutex::new(1);

#[no_mangle]
pub extern "C" fn forge_cron_create(name: *const c_char) -> i64 {
    let name = unsafe { CStr::from_ptr(name) }.to_str().unwrap().to_string();
    let mut id_lock = NEXT_ID.lock().unwrap();
    let id = *id_lock;
    *id_lock += 1;
    SCHEDULES.lock().unwrap().insert(id, ScheduleEntry {
        name,
        interval_ms: None,
        cron_expr: None,
    });
    id
}

#[no_mangle]
pub extern "C" fn forge_cron_set_interval_ms(schedule_id: i64, ms: i64) {
    let mut schedules = SCHEDULES.lock().unwrap();
    if let Some(entry) = schedules.get_mut(&schedule_id) {
        entry.interval_ms = Some(ms as u64);
    }
}

#[no_mangle]
pub extern "C" fn forge_cron_set_cron(schedule_id: i64, expr: *const c_char) {
    let expr = unsafe { CStr::from_ptr(expr) }.to_str().unwrap().to_string();
    let mut schedules = SCHEDULES.lock().unwrap();
    if let Some(entry) = schedules.get_mut(&schedule_id) {
        entry.cron_expr = Some(expr);
    }
}

#[no_mangle]
pub extern "C" fn forge_cron_start(
    schedule_id: i64,
    handler: extern "C" fn() -> i64,
    error_handler: extern "C" fn(*const c_char),
) {
    let schedules = SCHEDULES.lock().unwrap();
    if let Some(entry) = schedules.get(&schedule_id) {
        if let Some(ms) = entry.interval_ms {
            thread::spawn(move || {
                loop {
                    thread::sleep(Duration::from_millis(ms));
                    let result = handler();
                    if result != 0 {
                        let err = CString::new("schedule handler failed").unwrap();
                        error_handler(err.as_ptr());
                    }
                }
            });
        }
        // TODO: cron expression parsing for cron_expr
    }
}
```

### Verification

```bash
# Again — zero compiler changes:
git diff --stat compiler/src/
# Expected: 0 files changed
```

---

## Part 4: Provider Scaffold Command

Build `forge provider new` so creating providers is easy.

### Tests

**Test 4.1: Scaffold creates correct structure**

```bash
forge provider new my-awesome-provider
test -f my-awesome-provider/provider.toml && echo "PASS" || echo "FAIL"
test -f my-awesome-provider/src/provider.fg && echo "PASS" || echo "FAIL"
test -d my-awesome-provider/native && echo "PASS" || echo "FAIL"
test -f my-awesome-provider/native/Cargo.toml && echo "PASS" || echo "FAIL"
test -f my-awesome-provider/native/src/lib.rs && echo "PASS" || echo "FAIL"
test -f my-awesome-provider/README.md && echo "PASS" || echo "FAIL"
```

**Test 4.2: Scaffold provider compiles**

```bash
forge provider new test-provider
cd test-provider

# Native lib should compile
cd native && cargo build --release && cd ..

# The scaffold should include a working example
forge build example.fg
./build/example
# Should print something like "test-provider works!"
```

**Test 4.3: Scaffold with keyword flag**

```bash
forge provider new my-keyword-provider --keyword

# Should include keyword example in provider.fg
grep "keyword" my-keyword-provider/src/provider.fg | wc -l
# Expected: > 0

# provider.toml should have keyword section
grep "\[keywords\." my-keyword-provider/provider.toml | wc -l
# Expected: > 0
```

### Generated Files

`forge provider new my-provider` generates:

```toml
# provider.toml
[provider]
name = "my-provider"
namespace = "community"
version = "0.1.0"
description = "TODO: describe your provider"

[native]
library = "forge_my_provider"
```

```forge
// src/provider.fg

// Native bridge — functions implemented in native/src/lib.rs
extern fn forge_my_provider_hello(name: string) -> string

// Exported functions — available to Forge users
export fn hello(name: string) -> string {
  forge_my_provider_hello(name)
}
```

```rust
// native/src/lib.rs
use std::os::raw::c_char;
use std::ffi::{CStr, CString};

#[no_mangle]
pub extern "C" fn forge_my_provider_hello(name: *const c_char) -> *const c_char {
    let name = unsafe { CStr::from_ptr(name) }.to_str().unwrap();
    let greeting = format!("hello from my-provider, {}!", name);
    CString::new(greeting).unwrap().into_raw()
}
```

```toml
# native/Cargo.toml
[package]
name = "forge_my_provider"
version = "0.1.0"
edition = "2021"

[lib]
crate-type = ["staticlib"]
```

```forge
// example.fg
use @local.my_provider

fn main() {
  println(my_provider.hello("world"))
}
```

With `--keyword` flag, additionally generates:

```forge
// src/provider.fg (keyword version)

extern fn forge_my_provider_init(name: string) -> int
extern fn forge_my_provider_exec(id: int, data: string) -> string

export type MyProviderResult = {
  id: int,
  data: string,
}

keyword my_provider(name: string, config, schema) {
  config {
    // Add your config options here
    // option_name: type = default_value
  }

  let id = forge_my_provider_init(name)

  // Define functions available inside the keyword block
  fn exec(data: string) -> MyProviderResult {
    json.parse(forge_my_provider_exec(id, data))
  }

  // User's block body is inserted here automatically

  // Lifecycle hooks
  // on startup { }
  // on main_end { }
}
```

---

## Definition of Done

1. `providers.rs` is deleted from the compiler
2. `ModelDecl`, `ServiceDecl`, `ServerBlock` AST variants are deleted
3. All Phase 1-3 tests pass (no regressions)
4. Test 1.4 passes (multiple servers on different ports)
5. `@std/queue` works with zero compiler changes — tests 2.1-2.3 pass
6. `@std/cron` works with zero compiler changes — tests 3.1-3.3 pass
7. `forge provider new` scaffolds a working provider — tests 4.1-4.3 pass
8. `git diff --stat compiler/src/` shows zero changes for Parts 2-4
9. Total provider count: 4 (@std/model, @std/http, @std/queue, @std/cron)
