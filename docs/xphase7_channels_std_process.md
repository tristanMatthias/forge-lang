# Forge — @std/channel + @std/process (TDD)

Two packages that work together. Channels are the connective tissue. Processes are one of many things that plug into them.

---

# Part 1: @std/channel

## Test 1.1: Basic send and receive with `<-`

```forge
use @std.channel

fn main() {
  let ch = channel<string>()

  spawn { ch <- "hello" }

  let msg = <- ch
  println(msg)                 // hello
}
```

## Test 1.2: Buffered channel

```forge
fn main() {
  let ch = channel<int>(3)

  // Can send 3 without blocking
  ch <- 1
  ch <- 2
  ch <- 3

  println(string(ch.length))    // 3
  println(string(ch.capacity))  // 3
  println(string(ch.is_full))   // true

  let a = <- ch
  let b = <- ch
  println(string(a))            // 1
  println(string(b))            // 2
  println(string(ch.length))    // 1
  println(string(ch.is_full))   // false
}
```

## Test 1.3: Channel as iterable (for loop)

```forge
fn main() {
  let ch = channel<string>(10)

  spawn {
    ch <- "one"
    ch <- "two"
    ch <- "three"
    ch.close()
  }

  mut items: List<string> = []
  for msg in ch {
    items = items + [msg]
  }

  println(items.join(", "))     // one, two, three
  println(string(ch.is_closed)) // true
}
```

## Test 1.4: Typed channels — compile-time safety

```forge
fn main() {
  let numbers = channel<int>()
  numbers <- 42       // ok
  numbers <- "hello"  // COMPILE ERROR: F0012 expected int, found string
}
```

```bash
forge build test_channel_type.fg 2>&1 | grep "F0012"
# Expected: match
```

## Test 1.5: Close and drain

```forge
fn main() {
  let ch = channel<string>(10)
  ch <- "a"
  ch <- "b"
  ch <- "c"

  ch.close()

  let remaining = ch.drain()
  println(string(remaining.length))   // 3
  println(remaining.join(", "))       // a, b, c

  println(string(ch.is_closed))       // true
  println(string(ch.is_empty))        // true
}
```

## Test 1.6: Send to closed channel panics

```forge
fn main() {
  let ch = channel<string>()
  ch.close()
  ch <- "oops"
}
```

```bash
forge build test_closed_send.fg -o test_closed
./test_closed 2>&1
```

Expected runtime error:

```
  ╭─[panic] Send on closed channel
  │
  │  ╭─[test_closed_send.fg:4:3]
  │  │
  │  │    4 │   ch <- "oops"
  │  │      │   ────────────
  │  │      │   channel was closed at line 3
  │  │
  │  ╰──
```

## Test 1.7: One-shot channel

```forge
fn main() {
  let done = channel.once<bool>()

  spawn {
    sleep(100ms)
    done <- true
  }

  let result = <- done
  println(string(result))        // true
}
```

## Test 1.8: Timeout on receive

```forge
fn main() {
  let ch = channel<string>()

  // Nobody sends, so this times out
  let msg = <- ch.timeout(100ms) ?? "timed out"
  println(msg)                    // timed out
}
```

## Test 1.9: Deadline channel — auto-closes after duration

```forge
fn main() {
  let window = channel<int>.deadline(500ms)

  spawn {
    mut i = 0
    loop {
      if window.is_closed { break }
      window <- i catch { break }
      i = i + 1
      sleep(100ms)
    }
  }

  mut count = 0
  for _ in window {
    count = count + 1
  }

  // Should have received ~5 items in 500ms
  println(string(count > 0))     // true
  println(string(count < 10))    // true
}
```

---

## Test 1.10: Channel.map — transform stream

```forge
fn main() {
  let raw = channel<string>(10)
  let upper = raw.map(it.upper())

  spawn {
    raw <- "hello"
    raw <- "world"
    raw.close()
  }

  let a = <- upper
  let b = <- upper
  println(a)                     // HELLO
  println(b)                     // WORLD
}
```

## Test 1.11: Channel.filter

```forge
fn main() {
  let all = channel<int>(10)
  let evens = all.filter(it % 2 == 0)

  spawn {
    (1..=6).each(all <- it)
    all.close()
  }

  mut results: List<int> = []
  for n in evens {
    results = results + [n]
  }
  println(results.map(string(it)).join(", "))  // 2, 4, 6
}
```

## Test 1.12: Channel.batch — collect N then emit

```forge
fn main() {
  let items = channel<string>(20)
  let batched = items.batch(3)

  spawn {
    ["a", "b", "c", "d", "e", "f"].each(items <- it)
    items.close()
  }

  mut batch_count = 0
  for batch in batched {
    println(`batch ${batch_count}: ${batch.join(", ")}`)
    batch_count = batch_count + 1
  }
  // batch 0: a, b, c
  // batch 1: d, e, f
  println(string(batch_count))   // 2
}
```

## Test 1.13: Channel.debounce

```forge
fn main() {
  let raw = channel<string>(20)
  let debounced = raw.debounce(200ms)

  spawn {
    // Rapid fire — only last one should come through
    raw <- "a"
    sleep(50ms)
    raw <- "b"
    sleep(50ms)
    raw <- "c"
    sleep(300ms)  // silence — "c" emits

    raw <- "d"
    sleep(300ms)  // silence — "d" emits

    raw.close()
  }

  mut results: List<string> = []
  for msg in debounced {
    results = results + [msg]
  }
  println(results.join(", "))    // c, d
}
```

## Test 1.14: Channel.merge — combine multiple channels

```forge
fn main() {
  let a = channel<string>(10)
  let b = channel<string>(10)
  let c = channel<string>(10)

  let merged = channel.merge(a, b, c)

  spawn { a <- "from a"; a.close() }
  spawn { b <- "from b"; b.close() }
  spawn { c <- "from c"; c.close() }

  mut results: List<string> = []
  for msg in merged {
    results = results + [msg]
  }

  println(string(results.length))           // 3
  println(string(results.contains("from a")))  // true
  println(string(results.contains("from b")))  // true
  println(string(results.contains("from c")))  // true
}
```

## Test 1.15: Channel chaining with |>

```forge
fn main() {
  let raw = channel<string>(20)

  spawn {
    ["error: disk full", "info: started", "error: timeout", "info: ready", ""].each(raw <- it)
    raw.close()
  }

  raw
    |> filter(it.length > 0)
    |> filter(it.contains("error"))
    |> map(it.upper())
    |> each(println(it))

  // ERROR: DISK FULL
  // ERROR: TIMEOUT
}
```

## Test 1.16: Select — wait on multiple channels

```forge
fn main() {
  let numbers = channel<int>(10)
  let strings = channel<string>(10)
  let done = channel.once<bool>()

  spawn {
    sleep(50ms)
    numbers <- 42
  }
  spawn {
    sleep(100ms)
    strings <- "hello"
  }
  spawn {
    sleep(150ms)
    done <- true
  }

  mut received: List<string> = []

  loop {
    select {
      n <- numbers -> received = received + [`num:${n}`]
      s <- strings -> received = received + [`str:${s}`]
      _ <- done -> break
    }
  }

  println(received.join(", "))   // num:42, str:hello
}
```

## Test 1.17: Select with guard conditions

```forge
fn main() {
  let cpu = channel<float>(10)
  let mem = channel<float>(10)
  let alerts = channel<string>(10)

  spawn {
    cpu <- 45.0
    cpu <- 92.0   // this triggers alert
    mem <- 60.0
    mem <- 88.0   // this triggers alert
    cpu.close()
    mem.close()
  }

  // Small delay to let spawns complete
  sleep(50ms)

  mut alert_count = 0
  loop {
    if cpu.is_closed && mem.is_closed { break }
    select {
      usage <- cpu if usage > 90.0 -> {
        alerts <- `CPU at ${usage}%`
        alert_count = alert_count + 1
      }
      usage <- cpu -> {} // below threshold, ignore
      usage <- mem if usage > 85.0 -> {
        alerts <- `Memory at ${usage}%`
        alert_count = alert_count + 1
      }
      usage <- mem -> {} // below threshold, ignore
    }
  }

  println(string(alert_count))   // 2
}
```

## Test 1.18: Channel as function return type

```forge
fn countdown(from: int) -> channel<int> {
  let ch = channel<int>(from)

  spawn {
    mut i = from
    while i > 0 {
      ch <- i
      i = i - 1
      sleep(50ms)
    }
    ch.close()
  }

  ch
}

fn main() {
  for n in countdown(5) {
    println(string(n))
  }
  // 5
  // 4
  // 3
  // 2
  // 1
}
```

## Test 1.19: Fan-out — one producer, multiple consumers

```forge
fn main() {
  let events = channel<int>(20)

  // Two consumers
  let evens = events.filter(it % 2 == 0)
  let odds = events.filter(it % 2 != 0)

  mut even_sum = 0
  mut odd_sum = 0

  spawn {
    for n in evens { even_sum = even_sum + n }
  }
  spawn {
    for n in odds { odd_sum = odd_sum + n }
  }

  // Producer
  (1..=10).each(events <- it)
  events.close()

  sleep(100ms)  // let consumers finish

  println(string(even_sum))    // 30 (2+4+6+8+10)
  println(string(odd_sum))     // 25 (1+3+5+7+9)
}
```

## Test 1.20: Channel tick — periodic timer

```forge
fn main() {
  let tick = channel.tick(100ms)

  mut count = 0
  for _ in tick {
    count = count + 1
    if count >= 3 { break }
  }

  println(string(count))       // 3
}
```

---

# Part 2: @std/process

## Test 2.1: Basic run

```forge
use @std.process

fn main() {
  let result = process.run("echo", ["hello forge"])?
  println(result.stdout.trim())       // hello forge
  println(string(result.code))        // 0
}
```

## Test 2.2: Failing process

```forge
fn main() {
  let result = process.run("ls", ["/nonexistent_path_xyz"])?
  println(string(result.code != 0))        // true
  println(string(result.stderr.length > 0))  // true
}
```

## Test 2.3: `$` shorthand

```forge
fn main() {
  let greeting = $"echo hello"
  println(greeting.trim())            // hello

  // With interpolation
  let name = "forge"
  let result = $"echo hello ${name}"
  println(result.trim())              // hello forge
}
```

## Test 2.4: `$` with error fallback

```forge
fn main() {
  let result = $"nonexistent-command-xyz" catch { "failed" }
  println(result)                     // failed
}
```

## Test 2.5: Spawn and manage background process

```forge
fn main() {
  let handle = process.spawn("sleep", ["30"])?

  println(string(handle.is_alive()))  // true

  handle.kill()
  sleep(50ms)

  println(string(handle.is_alive()))  // false
}
```

## Test 2.6: Spawn and wait for output

```forge
fn main() {
  // Start a process that prints "ready" after a delay
  let handle = process.spawn("sh", ["-c", "sleep 0.1 && echo ready && sleep 30"])?
  defer handle.kill()

  handle.wait_for_output("ready", timeout: 5s)?
  println("server is ready")          // server is ready
}
```

## Test 2.7: Stream output line by line

```forge
fn main() {
  mut lines_received: List<string> = []

  process.stream("sh", ["-c", "echo one && echo two && echo three"]) { line ->
    lines_received = lines_received + [line.trim()]
  }

  println(lines_received.join(", "))  // one, two, three
}
```

## Test 2.8: Process stdout into channel

```forge
use @std.channel

fn main() {
  let logs = channel<string>(100)

  // Process feeds channel
  spawn {
    process.stream("sh", ["-c", "echo alpha && echo beta && echo gamma"]) { line ->
      logs <- line.trim()
    }
    logs.close()
  }

  mut items: List<string> = []
  for msg in logs {
    items = items + [msg]
  }

  println(items.join(", "))           // alpha, beta, gamma
}
```

## Test 2.9: Process pipe with |>

```forge
fn main() {
  let result = $"echo hello world"
    |> lines
    |> map(it.upper())
    |> join(", ")

  println(result)                     // HELLO WORLD
}
```

## Test 2.10: Pipe between processes

```forge
fn main() {
  fs.write("pipe_data.txt", "apple\nbanana\napricot\ncherry\navocado")?
  defer fs.remove("pipe_data.txt")

  let result = $"cat pipe_data.txt"
    |> process.pipe("grep", ["^a"])
    |> process.pipe("sort")

  println(result.trim())
  // apple
  // apricot
  // avocado
}
```

## Test 2.11: Environment variables

```forge
fn main() {
  let home = process.env("HOME") ?? "unknown"
  println(string(home.length > 0))    // true

  let missing = process.env("FORGE_TEST_NONEXISTENT_VAR_XYZ")
  println(string(missing == null))    // true
}
```

## Test 2.12: Run with custom environment and cwd

```forge
fn main() {
  let result = process.run("sh", ["-c", "echo $MY_VAR"]) {
    env { MY_VAR "custom_value" }
  }?

  println(result.stdout.trim())       // custom_value
}
```

```forge
fn main() {
  fs.mkdir("cwd_test")?
  fs.write("cwd_test/hello.txt", "hi")?
  defer fs.remove_dir("cwd_test")

  let result = process.run("ls", []) {
    cwd "cwd_test"
  }?

  println(string(result.stdout.contains("hello.txt")))  // true
}
```

## Test 2.13: Run with timeout

```forge
fn main() {
  let result = process.run("sleep", ["30"]) {
    timeout 500ms
  }

  match result {
    Err(e) -> println(string(e.contains("timed out")))  // true
    Ok(_) -> println("should not reach here")
  }
}
```

## Test 2.14: Parallel processes

```forge
fn main() {
  let results = process.parallel(
    () -> process.run("echo", ["first"]),
    () -> process.run("echo", ["second"]),
    () -> process.run("echo", ["third"]),
  )?

  println(results.map(it.stdout.trim()).sorted().join(", "))
  // first, second, third
}
```

## Test 2.15: Race — first to finish wins

```forge
fn main() {
  let winner = process.race(
    () -> process.run("sh", ["-c", "sleep 0.5 && echo slow"]),
    () -> process.run("sh", ["-c", "echo fast"]),
  )?

  println(winner.stdout.trim())       // fast
}
```

## Test 2.16: Chain with reporting

```forge
fn main() {
  mut report: List<string> = []

  process.chain(
    ("compile", () -> process.run("echo", ["compiled"])),
    ("test", () -> process.run("echo", ["tested"])),
    ("package", () -> process.run("echo", ["packaged"])),
  )? { step, result ->
    let icon = if result.code == 0 { "✓" } else { "✖" }
    report = report + [`${icon} ${step}`]
  }

  report.each(println(it))
  // ✓ compile
  // ✓ test
  // ✓ package
}
```

## Test 2.17: Chain stops on failure

```forge
fn main() {
  mut steps_run = 0

  let result = process.chain(
    ("step1", () -> process.run("echo", ["ok"])),
    ("step2", () -> process.run("sh", ["-c", "exit 1"])),
    ("step3", () -> process.run("echo", ["never reached"])),
  ) { step, result ->
    steps_run = steps_run + 1
  }

  println(string(steps_run))          // 2 (step3 never ran)
  println(string(result.is_err()))    // true
}
```

## Test 2.18: Retry with backoff

```forge
fn main() {
  mut attempts = 0

  let result = process.retry("sh", ["-c", "exit 1"]) {
    max_attempts 3
    backoff linear
    retry_if (r) -> r.code != 0
    on_retry (attempt, result) -> {
      attempts = attempts + 1
      println(`retry ${attempt}`)
    }
  }

  println(string(attempts))          // 2 (initial + 2 retries = 3 total)
  println(string(result.code != 0))  // true (still failed)
}
```

## Test 2.19: `sh` multi-line block

```forge
fn main() {
  fs.mkdir("sh_test")?
  defer fs.remove_dir("sh_test")

  sh ```
    touch sh_test/file1.txt
    touch sh_test/file2.txt
    echo "created" > sh_test/file1.txt
  ```

  println(string(fs.exists("sh_test/file1.txt")))  // true
  println(string(fs.exists("sh_test/file2.txt")))  // true
  println(fs.read("sh_test/file1.txt")?.trim())     // created
}
```

## Test 2.20: `sh` with Forge variable interpolation

```forge
fn main() {
  let name = "forge"
  let count = 3

  let result = sh `echo ${name} has ${count} features`
  println(result.trim())              // forge has 3 features
}
```

---

# Part 3: Channels + Processes Together

## Test 3.1: Process output into channel, filter, consume

```forge
use @std.channel
use @std.process

fn main() {
  fs.write("mixed_log.txt", "INFO: started\nERROR: disk full\nINFO: running\nERROR: timeout\nINFO: done")?
  defer fs.remove("mixed_log.txt")

  let logs = channel<string>(100)
  let errors = logs.filter(it.contains("ERROR"))

  spawn {
    process.stream("cat", ["mixed_log.txt"]) { line ->
      logs <- line.trim()
    }
    logs.close()
  }

  mut error_count = 0
  for err in errors {
    println(err)
    error_count = error_count + 1
  }

  println(string(error_count))        // 2
}
```

## Test 3.2: Multiple processes feeding one channel

```forge
fn main() {
  fs.write("log_a.txt", "from A line 1\nfrom A line 2")?
  fs.write("log_b.txt", "from B line 1\nfrom B line 2")?
  defer fs.remove("log_a.txt")
  defer fs.remove("log_b.txt")

  let combined = channel<string>(100)

  spawn {
    process.stream("cat", ["log_a.txt"]) { line -> combined <- line.trim() }
  }
  spawn {
    process.stream("cat", ["log_b.txt"]) { line -> combined <- line.trim() }
  }

  // Wait for both to finish
  sleep(200ms)
  combined.close()

  mut total = 0
  for _ in combined { total = total + 1 }
  println(string(total))              // 4
}
```

## Test 3.3: Channel driving process input

```forge
fn main() {
  let commands = channel<string>(10)

  spawn {
    commands <- "echo first"
    commands <- "echo second"
    commands <- "echo third"
    commands.close()
  }

  mut outputs: List<string> = []
  for cmd in commands {
    let parts = cmd.split(" ")
    let result = process.run(parts[0], parts.slice(1))?
    outputs = outputs + [result.stdout.trim()]
  }

  println(outputs.join(", "))         // first, second, third
}
```

## Test 3.4: Select between process and timer

```forge
fn main() {
  let results = channel<string>(10)
  let tick = channel.tick(200ms)

  spawn {
    // Slow process
    let r = process.run("sh", ["-c", "sleep 0.5 && echo done"])?
    results <- r.stdout.trim()
    results.close()
  }

  mut tick_count = 0
  mut got_result = false

  loop {
    select {
      msg <- results -> {
        println(`result: ${msg}`)
        got_result = true
        break
      }
      _ <- tick -> {
        tick_count = tick_count + 1
        println("waiting...")
      }
    }
  }

  println(string(got_result))         // true
  println(string(tick_count > 0))     // true (at least 1 tick while waiting)
}
```

## Test 3.5: Process pipeline through channels

```forge
fn main() {
  let raw = channel<string>(100)
  let parsed = raw.map(json.parse<{level: string, msg: string}>(it))
  let errors = parsed.filter(it.level == "error")
  let alerts = errors.map(`ALERT: ${it.msg}`)

  spawn {
    raw <- `{"level":"info","msg":"started"}`
    raw <- `{"level":"error","msg":"disk full"}`
    raw <- `{"level":"info","msg":"running"}`
    raw <- `{"level":"error","msg":"timeout"}`
    raw.close()
  }

  for alert in alerts {
    println(alert)
  }
  // ALERT: disk full
  // ALERT: timeout
}
```

## Test 3.6: Managed process component with channels

```forge
use @std.process.{managed}
use @std.channel

fn main() {
  let events = channel<string>(10)

  // Will fail immediately since command doesn't exist
  // but tests the component wiring
  managed test_service {
    command "echo"
    args ["service started"]
    restart_on_failure false

    on started {
      events <- "started"
    }

    on crashed(code: int) {
      events <- `crashed:${code}`
    }
  }

  sleep(200ms)

  // echo exits immediately with code 0, so "started" should fire
  let msg = <- events.timeout(1s) ?? "nothing"
  println(msg)                         // started
}
```

## Test 3.7: Full pipeline — HTTP + Queue + Channel + Process

```forge
// This is the dream test — everything connected
use @std.http.{server}
use @std.queue.{queue}
use @std.channel

let events = channel<string>(1000)

queue jobs {
  on message(msg) {
    events <- `job:${msg.payload}`
  }
}

server :9300 {
  POST /webhook -> (req) {
    events <- `http:${req.body}`
    { received: true }
  }
}

fn main() {
  // Consumer — processes events from any source
  spawn {
    for event in events {
      match event {
        e if e.starts_with("job:") -> {
          let cmd = e.slice(4)
          let result = process.run("sh", ["-c", cmd])?
          println(`job result: ${result.stdout.trim()}`)
        }
        e if e.starts_with("http:") -> {
          println(`webhook: ${e.slice(5)}`)
        }
      }
    }
  }

  // Simulate: send a job via queue
  jobs.send({ payload: "echo hello from queue" })

  // Simulate: send a webhook
  process.run("curl", ["-s", "-X", "POST", "http://localhost:9300/webhook", "-d", "hello from http"])?

  sleep(500ms)
  // job result: hello from queue
  // webhook: hello from http
}
```

---

# Package Definitions

## @std/channel — package.toml

```toml
[package]
name = "channel"
namespace = "std"
version = "0.1.0"
description = "Typed channels for concurrent communication"

[native]
library = "forge_channel"
```

## @std/channel — package.fg

```forge
extern fn forge_channel_create(capacity: int) -> int
extern fn forge_channel_send(id: int, data: string) -> bool
extern fn forge_channel_receive(id: int) -> string
extern fn forge_channel_try_receive(id: int, timeout_ms: int) -> string
extern fn forge_channel_close(id: int)
extern fn forge_channel_is_closed(id: int) -> bool
extern fn forge_channel_length(id: int) -> int
extern fn forge_channel_capacity(id: int) -> int
extern fn forge_channel_drain(id: int) -> string
extern fn forge_channel_select(channel_ids_json: string, timeout_ms: int) -> string
extern fn forge_channel_tick_create(interval_ms: int) -> int

export type Channel<T> = {
  id: int,
}

export fn channel<T>(capacity: int = 0) -> Channel<T> {
  Channel { id: forge_channel_create(capacity) }
}

impl<T> Channel<T> {
  fn send(self, value: T) {
    forge_channel_send(self.id, json.stringify(value))
  }

  fn receive(self) -> T {
    json.parse(forge_channel_receive(self.id))
  }

  fn close(self) { forge_channel_close(self.id) }
  fn is_closed(self) -> bool { forge_channel_is_closed(self.id) }
  fn is_empty(self) -> bool { forge_channel_length(self.id) == 0 }
  fn is_full(self) -> bool { forge_channel_length(self.id) >= forge_channel_capacity(self.id) }
  fn length(self) -> int { forge_channel_length(self.id) }
  fn capacity(self) -> int { forge_channel_capacity(self.id) }

  fn drain(self) -> List<T> {
    json.parse(forge_channel_drain(self.id))
  }

  fn timeout(self, duration: duration) -> Channel<T> {
    // Returns a wrapper that times out on receive
    self  // native implementation handles timeout in receive
  }

  fn map<U>(self, f: fn(T) -> U) -> Channel<U> {
    let out = channel<U>(self.capacity)
    spawn {
      for item in self { out <- f(item) }
      out.close()
    }
    out
  }

  fn filter(self, f: fn(T) -> bool) -> Channel<T> {
    let out = channel<T>(self.capacity)
    spawn {
      for item in self {
        if f(item) { out <- item }
      }
      out.close()
    }
    out
  }

  fn batch(self, size: int) -> Channel<List<T>> {
    let out = channel<List<T>>(self.capacity)
    spawn {
      mut batch: List<T> = []
      for item in self {
        batch = batch + [item]
        if batch.length >= size {
          out <- batch
          batch = []
        }
      }
      if batch.length > 0 { out <- batch }
      out.close()
    }
    out
  }

  fn debounce(self, duration: duration) -> Channel<T> {
    let out = channel<T>(self.capacity)
    spawn {
      mut last: T? = null
      loop {
        let item = <- self.timeout(duration)
        if item != null {
          last = item
        } else {
          if last != null {
            out <- last!
            last = null
          }
          if self.is_closed { break }
        }
      }
      out.close()
    }
    out
  }

  fn each(self, f: fn(T)) {
    for item in self { f(item) }
  }
}

export fn merge<T>(...channels: List<Channel<T>>) -> Channel<T> {
  let out = channel<T>(100)
  mut alive = channels.length
  channels.each(ch -> {
    spawn {
      for item in ch { out <- item }
      alive = alive - 1
      if alive == 0 { out.close() }
    }
  })
  out
}

export fn once<T>() -> Channel<T> {
  channel<T>(1)
}

export fn tick(interval: duration) -> Channel<void> {
  let id = forge_channel_tick_create(interval.to_ms())
  Channel { id: id }
}
```

## @std/process — package.toml

```toml
[package]
name = "process"
namespace = "std"
version = "0.1.0"
description = "Process spawning, management, and shell integration"

[native]
library = "forge_process"

[components.managed]
kind = "block"
context = "top_level"
body = "mixed"
```

## @std/process — package.fg

```forge
extern fn forge_process_run(cmd: string, args_json: string, opts_json: string) -> string
extern fn forge_process_spawn(cmd: string, args_json: string, opts_json: string) -> int
extern fn forge_process_kill(pid: int) -> bool
extern fn forge_process_wait(pid: int) -> string
extern fn forge_process_wait_for_output(pid: int, pattern: string, timeout_ms: int) -> bool
extern fn forge_process_read_line(pid: int) -> string
extern fn forge_process_is_alive(pid: int) -> bool
extern fn forge_process_env_get(key: string) -> string
extern fn forge_process_pipe(input: string, cmd: string, args_json: string) -> string

export type ProcessResult = {
  stdout: string,
  stderr: string,
  code: int,
}

export type ProcessHandle = {
  pid: int,
}

export fn run(cmd: string, args: List<string>) -> Result<ProcessResult, string> {
  let result_json = forge_process_run(cmd, json.stringify(args), "{}")
  Ok(json.parse(result_json))
}

export fn spawn(cmd: string, args: List<string>) -> Result<ProcessHandle, string> {
  let pid = forge_process_spawn(cmd, json.stringify(args), "{}")
  if pid < 0 { Err("failed to spawn") } else { Ok(ProcessHandle { pid: pid }) }
}

export fn env(key: string) -> string? {
  let val = forge_process_env_get(key)
  if val == "\0NULL" { null } else { val }
}

export fn pipe(input: string, cmd: string, args: List<string>) -> Result<string, string> {
  let result_json = forge_process_pipe(input, cmd, json.stringify(args))
  let result: ProcessResult = json.parse(result_json)
  if result.code == 0 { Ok(result.stdout) } else { Err(result.stderr) }
}

export fn stream(cmd: string, args: List<string>, handler: fn(string)) {
  let handle = spawn(cmd, args)?
  loop {
    let line = forge_process_read_line(handle.pid)
    if line == "\0EOF" { break }
    handler(line)
  }
}

export fn parallel(...fns: List<fn() -> Result<ProcessResult, string>>) -> Result<List<ProcessResult>, string> {
  let results = parallel {
    fns.map(f -> f())
  }
  Ok(results)
}

export fn race(...fns: List<fn() -> Result<ProcessResult, string>>) -> Result<ProcessResult, string> {
  let result_ch = channel.once<ProcessResult>()
  fns.each(f -> spawn {
    let r = f()?
    result_ch <- r catch {}  // first one wins, rest silently fail
  })
  Ok(<- result_ch)
}

impl ProcessHandle {
  fn kill(self) -> bool { forge_process_kill(self.pid) }
  fn is_alive(self) -> bool { forge_process_is_alive(self.pid) }

  fn wait(self) -> Result<ProcessResult, string> {
    Ok(json.parse(forge_process_wait(self.pid)))
  }

  fn wait_for_output(self, pattern: string, timeout: duration = 5s) -> Result<void, string> {
    if forge_process_wait_for_output(self.pid, pattern, timeout.to_ms()) {
      Ok(())
    } else {
      Err(`timed out waiting for "${pattern}"`)
    }
  }
}

component managed(name: string) {
  config {
    command: string
    args: List<string> = []
    restart_on_failure: bool = false
    max_restarts: int = 3
  }

  event started()
  event crashed(code: int)

  mut handle: ProcessHandle? = null
  mut restarts = 0

  fn start() {
    handle = spawn(config.command, config.args)?
    started()
  }

  fn monitor() {
    spawn {
      loop {
        if handle == null { break }
        let result = handle!.wait()?
        if result.code != 0 {
          crashed(result.code)
          if config.restart_on_failure && restarts < config.max_restarts {
            restarts = restarts + 1
            start()
          } else {
            break
          }
        } else {
          break
        }
      }
    }
  }

  on startup {
    start()
    monitor()
  }

  on main_end {
    handle?.kill()
  }
}
```

---

# What needs to be built

| Feature | Package | Implementation |
|---|---|---|
| `channel<T>()` constructor | @std/channel | Typed wrapper around crossbeam channel |
| `<-` send operator | compiler | New operator, desugars to `.send()` |
| `<- ch` receive expression | compiler | New prefix operator, desugars to `.receive()` |
| `for x in channel` | compiler | Channel implements Iterable trait |
| `.map .filter .batch .debounce` | @std/channel | Spawn transform goroutines with new channels |
| `channel.merge` | @std/channel | Fan-in with spawn per source |
| `channel.tick` | @std/channel | Native timer thread |
| `channel.once` | @std/channel | Buffered(1) channel |
| `.timeout()` | @std/channel | Native timed receive |
| `.deadline()` | @std/channel | Timer-based auto-close |
| `select { }` | compiler | New syntax, desugars to native select |
| `select` guards (`if`) | compiler | Conditional arm matching |
| `process.run` | @std/process | Wrap `std::process::Command` |
| `process.spawn` | @std/process | Non-blocking Command with pid tracking |
| `$"..."` shorthand | compiler | New syntax, desugars to `process.run` + split |
| `sh` blocks | compiler | Multi-line shell execution |
| Process env/cwd/timeout | @std/process | Options struct passed to native |
| `process.pipe` | @std/process | stdin piping between processes |
| `process.parallel` | @std/process | Forge's `parallel { }` + collect |
| `process.race` | @std/process | First-to-finish via channel |
| `process.chain` | @std/process | Sequential with early abort |
| `process.retry` | @std/process | Loop with backoff |
| `process.stream` | @std/process | Line-by-line reader via native |
| `managed` component | @std/process | Supervised process with restart policy |
| Channel + process integration | both | Process stdout → channel bridging |
