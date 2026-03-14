# Forge — Scoped Abstraction Levels

**A Proposal for the Future of Forge**

*One language. Every level of the stack. No compromises.*

---

## The Problem

Every programming language makes you choose. Application or systems. Ergonomic or performant. Managed or manual. High-level or low-level. This choice is made once, at language selection time, and it infects everything downstream — your toolchain, your hiring, your deployment, your mental model. Want a web server? Reach for Go or Python. Need a device driver? C or Rust. Building a robot? Write the orchestration in Python, the controller in C++, the firmware in C, the config in YAML, the build system in CMake, and pray they all talk to each other.

This is the world we inherited. It made sense when humans wrote every line. Humans specialize. A web developer thinks differently than an embedded engineer. Different languages for different brains.

But that world is ending.

In the AI-engineered future, the entity writing code doesn't have a specialization. An AI can think about HTTP routing and register manipulation in the same thought. It doesn't find memory management "hard" or garbage collection "easy" — those are just different strategies for different contexts. The bottleneck is no longer human cognitive specialization. The bottleneck is *language boundaries* — the friction of crossing from one language to another, one toolchain to another, one mental model to another.

Forge is already designed as an orchestration language. It already compiles to native code via LLVM. It already has a component/provider system that lets domain-specific syntax feel native. The question is: what if we removed the ceiling?

---

## The Core Idea

**Abstraction level is a property of scope, not a property of language.**

Forge introduces *scoped abstraction levels* — regions within your code where the compiler's strategies change. The syntax stays the same. The type system stays the same. The error system stays the same. But what the compiler *does* with your code — how it manages memory, what operations are available, what guarantees it provides — shifts based on the level you're operating at.

This is not "unsafe blocks." It's not a mode switch. It's a *spectrum* of capabilities that you can fluidly move through within a single file, a single function, a single expression. Each level adds capabilities (lower-level operations) and responsibilities (things you must manage), while the compiler verifies every boundary.

```forge
// Application level — the default. Automatic memory, full ergonomics.
server :8080 {
  POST /analyze -> (req) {
    let image = req.body.file

    // Performance-critical section: drop into systems level.
    let edges = systems {
      // Owned memory, deterministic deallocation, zero RC overhead.
      let buf = Buffer<f32>.alloc(image.width * image.height)
      defer buf.free()

      // Hot loop — drop into bare for SIMD.
      bare {
        let ptr = buf.as_ptr()
        simd.for_each_4(ptr, buf.len, (v) -> {
          // Sobel edge detection, 4 pixels at a time
          v.store(sobel_x(v) * sobel_x(v) + sobel_y(v) * sobel_y(v))
        })
      }

      Image.from_buffer(buf, image.width, image.height)
      // buf freed here by defer — no RC overhead
    }

    // Back to application level. edges is a normal Image value.
    { result: edges.to_png() }
  }
}
```

---

## The Levels

Forge defines four abstraction levels. Each level is a strict superset of the one below in terms of what you must manage, and a strict superset of the one above in terms of what operations are available.

### Level 0: Application (default)

The level most Forge code lives at. Automatic memory management — reference counting with arena allocation and targeted cycle detection, all decided at compile time. No GC. No pauses. Deterministic deallocation. This is what Forge is today.

**You get:** Automatic memory management, auto-serialization, providers (`model`, `server`, `queue`), type inference, pattern matching, channels, spawn, the full standard library.

**You manage:** Nothing related to memory or resources. The compiler handles it.

**Compiled as:** Reference-counted values with compiler-inserted retain/release. Arena allocation for request-scoped patterns (the compiler detects "handle-and-respond" patterns and bulk-frees on scope exit). Targeted cycle detection only on types that could form cycles (bidirectional model relations, etc.) — a lightweight mark-and-sweep that runs only when a refcount doesn't reach zero as expected.

```forge
// Application level — the vast majority of code
server :8080 {
  GET /users -> {
    User.where(active: true)
      .include(posts, profile)
      .paginate(page: 1, per: 20)
  }
}
```

### Level 1: Systems

For code that needs explicit control over allocation strategy, zero reference-counting overhead, or compiler-verified lifetime safety. At application level, the compiler inserts retain/release — cheap, but not zero. At systems level, you get ownership-based memory with zero runtime overhead. Lifetimes are tracked by the compiler (Rust-style ownership and borrowing). Values are stack-allocated by default, heap-allocated explicitly.

**You get:** Everything from application level, plus: manual allocation, stack vs heap control, lifetime annotations, deterministic drop, zero-overhead memory.

**You manage:** Memory lifetimes. The compiler checks them. Failure to manage correctly is a compile error, never a runtime crash.

**Compiled as:** Ownership-tracked values with compiler-inserted drops. No reference counting overhead. No cycle detection. Allocation points are explicit.

```forge
systems {
  let buf = Buffer<u8>.alloc(4096)        // heap allocation — you own it
  let header = buf.slice(0, 12)           // borrow — checked at compile time
  parse_header(header)                    // borrow passed to function
  buf.free()                              // explicit deallocation
  // Using header after buf.free() → compile error (dangling borrow)
}
```

**Why not just use `defer`?** You can. `defer buf.free()` works perfectly. The point is that the *compiler tracks* these lifetimes. At application level, the compiler inserts retain/release automatically and detects cycles for you. At systems level, the compiler *refuses to compile* code that leaks — you get Rust-style ownership guarantees without the retain/release overhead.

### Level 2: Bare

For code that needs raw pointer arithmetic, SIMD intrinsics, inline assembly, manual memory layout, or zero-cost abstractions over hardware. The compiler still type-checks everything, but it stops managing lifetimes for you. You're telling the compiler "I know what I'm doing here."

**You get:** Everything from systems level, plus: raw pointers, pointer arithmetic, `reinterpret_cast`, SIMD intrinsics, inline assembly, manual struct layout with `@packed` / `@align`, volatile reads/writes, memory-mapped I/O.

**You manage:** Everything. Memory, lifetimes, alignment, aliasing. The compiler does not insert any implicit operations.

**Compiled as:** Direct LLVM IR with no inserted runtime calls. What you write is what you get.

```forge
bare {
  let ptr = mem.alloc<u8>(1024)
  let aligned = mem.align_up(ptr, 16)

  // SIMD: process 16 bytes at a time
  let end = aligned + 1024
  mut cursor = aligned
  while cursor < end {
    let v = simd.load_128(cursor as *simd.i8x16)
    let processed = simd.add_saturate(v, threshold)
    simd.store_128(cursor as *simd.i8x16, processed)
    cursor = cursor + 16
  }

  mem.free(ptr)
}
```

### Level 3: Hardware

For code that directly addresses hardware: memory-mapped registers, DMA buffers, interrupt handlers, clock configuration, pin multiplexing. The compiler understands the target hardware and validates register addresses, bit field layouts, and timing constraints at compile time.

**You get:** Everything from bare level, plus: register map declarations, bit field access, interrupt handler registration, DMA configuration, clock tree access, compile-time hardware validation.

**You manage:** Everything, plus: electrical timing, interrupt priorities, peripheral initialization order, bus arbitration.

**Compiled as:** Direct machine code for the target architecture. No operating system assumptions. Suitable for bare-metal deployment.

```forge
hardware {
  // Register map — compiler validates addresses against target chip
  let gpio = register_map(0x3F200000) {
    GPFSEL0: u32 @offset(0x00)
    GPFSEL1: u32 @offset(0x04)
    GPSET0:  u32 @offset(0x1C)
    GPCLR0:  u32 @offset(0x28)
    GPLEV0:  u32 @offset(0x34)
  }

  // Set pin 17 as output (function select bits 21-23 of GPFSEL1)
  let fsel = volatile_read(gpio.GPFSEL1)
  volatile_write(gpio.GPFSEL1, (fsel & !(0b111 << 21)) | (0b001 << 21))

  // Set pin 17 high
  volatile_write(gpio.GPSET0, 1 << 17)
}
```

---

## Boundary Mechanics

The real engineering challenge isn't the individual levels — it's the *transitions between them*. Every transition is a typed boundary that the compiler verifies.

### Application ↔ Systems

Crossing from application to systems requires that all values passed in are either copyable or explicitly moved. Reference-counted values can't cross directly into systems scope because there's no retain/release machinery there — the overhead model is different.

```forge
let users = User.list()    // application: reference-counted list

systems {
  // Can't just use `users` directly — it's reference-counted
  // Must convert to an owned representation
  let owned_users = users.to_owned()    // deep copy into ownership-tracked memory
  defer owned_users.free()

  process(owned_users)
}
```

For simple types (numbers, strings, small structs), the compiler handles this automatically — they're stack-copyable and don't involve reference counting. The boundary cost is zero for these.

```forge
let width = 1920    // int — no RC involvement
let height = 1080

let result = systems {
  // width and height cross for free — they're just stack values
  let buf = Buffer<u8>.alloc(width * height * 4)
  defer buf.free()
  fill_gradient(buf, width, height)
  Image.from_buffer(buf, width, height)    // Image is returned by value
}
// result is now an application-level Image value
```

**Return semantics:** A systems block returns a value to its enclosing application scope. The returned value must be a type that application level can manage. Returning a raw pointer is a compile error. Returning a struct that contains owned allocations triggers an automatic conversion to reference-counted memory.

### Systems ↔ Bare

Crossing from systems to bare drops lifetime tracking. The compiler trusts you inside `bare`. But it still verifies the boundary: anything returned from `bare` to `systems` must be a type that the systems level can track.

```forge
systems {
  let result = bare {
    let ptr = mem.alloc<u8>(256)
    // ... raw pointer work ...
    OwnedBuffer.from_raw(ptr, 256)    // wrap in a type systems can track
  }
  // result is an OwnedBuffer — systems level tracks its lifetime
  defer result.free()
  process(result)
}
```

### Bare ↔ Hardware

Crossing from bare to hardware is mostly about adding hardware-specific intrinsics and compile-time validation against a hardware target. The memory model doesn't change much — both are manual. But hardware level adds `volatile` semantics by default (reads and writes are never reordered or optimized away) and understands peripheral memory maps.

### Skipping Levels

You can skip levels. Application code can drop directly into `bare` or `hardware`. The compiler applies all intermediate boundary checks:

```forge
// Application → Hardware (skipping systems and bare)
server :8080 {
  GET /led/:state -> (req) {
    hardware {
      if req.params.state == "on" {
        volatile_write(gpio.GPSET0, 1 << 17)
      } else {
        volatile_write(gpio.GPCLR0, 1 << 17)
      }
    }
    { status: "ok" }
  }
}
```

This is a web server that directly controls a GPIO pin. The compiler validates the full boundary chain: application → hardware, applying all intermediate constraints. The `req.params.state` string is a simple value that crosses for free.

---

## Providers Across Levels

Forge's component/provider system works at every level. A provider can expose an application-level interface while implementing in a lower level internally. Users of the provider never see the lower level — they interact with a clean, high-level API.

### Provider with Mixed Levels

```forge
// @hw/gpio provider — application-level interface, hardware-level guts
component gpio_controller(target: ChipTarget) {

  // Public API: application level
  fn output(pin: int) -> GpioOutput {
    // Validate pin number at compile time against target
    assert pin >= 0 && pin <= target.max_gpio_pin,
      "pin ${pin} does not exist on ${target.name}"

    hardware {
      let fsel_reg = target.gpio_base + (pin / 10) * 4
      let fsel_bit = (pin % 10) * 3
      let current = volatile_read(fsel_reg)
      volatile_write(fsel_reg, (current & !(0b111 << fsel_bit)) | (0b001 << fsel_bit))
    }

    GpioOutput { pin, target }
  }

  // The GpioOutput struct has methods that use hardware level internally
  fn GpioOutput.high(self) {
    hardware {
      volatile_write(self.target.gpio_base + 0x1C, 1 << self.pin)
    }
  }

  fn GpioOutput.low(self) {
    hardware {
      volatile_write(self.target.gpio_base + 0x28, 1 << self.pin)
    }
  }
}
```

User code:

```forge
use @hw.gpio

let led = gpio.output(pin: 17)    // application level, clean API
led.high()                         // no idea there's hardware-level code inside
wait(1s)
led.low()
```

### Domain Providers for Different Industries

The level system makes Forge viable as the orchestration surface for domains that were previously inaccessible to high-level languages:

**Robotics:**

```forge
use @hw.robot
use @std.http

robot arm_controller {
  let joints = motor.chain([
    servo(pin: 1, range: -180..180, speed: 60),    // base rotation
    servo(pin: 2, range: -90..90, speed: 45),       // shoulder
    servo(pin: 3, range: -135..135, speed: 60),     // elbow
    servo(pin: 4, range: -180..180, speed: 90),     // wrist rotation
    gripper(pin: 5, open: 0, closed: 180),           // end effector
  ])

  let camera = sensor.camera(port: "/dev/video0", fps: 30)
  let imu = sensor.imu(i2c: 1, addr: 0x68)

  // Inverse kinematics — needs systems level for real-time guarantee
  fn move_to(x: float, y: float, z: float) {
    systems {
      let angles = kinematics.inverse(joints.lengths, x, y, z)
      let trajectory = motion.plan(joints.current_angles(), angles, max_accel: 2.0)

      // Execute trajectory with hard real-time loop
      rt_loop(interval: 1ms) {
        let next = trajectory.next() ?? break
        joints.set_angles(next)

        // IMU feedback for vibration damping — bare level for speed
        bare {
          let accel = imu.read_raw()
          let correction = pid_update(accel, target: 0.0)
          joints.apply_torque_offset(correction)
        }
      }
    }
  }
}

// Application-level interface for remote control
server :8080 {
  POST /move -> (req: { x: float, y: float, z: float }) {
    arm_controller.move_to(req.x, req.y, req.z)
    { status: "ok" }
  }

  sse /telemetry -> (stream) {
    loop {
      stream.send({
        angles: arm_controller.joints.current_angles(),
        imu: arm_controller.imu.read(),
        position: arm_controller.joints.end_effector_position(),
      })
      wait(50ms)
    }
  }
}
```

One file. Web server, real-time motor control, SIMD-accelerated sensor fusion, hardware I/O. All Forge. All type-checked. All with structured errors.

**PCB Design and Simulation:**

```forge
use @hw.eda
use @hw.spice

schematic power_regulator {
  // Declarative circuit description — application level
  let vin = net("VIN")
  let vout = net("3V3")
  let gnd = net("GND")

  place ams1117_3v3(input: vin, output: vout, ground: gnd)
  place capacitor(value: 10uF, package: "0805", between: vin, gnd)
  place capacitor(value: 22uF, package: "0805", between: vout, gnd)
  place capacitor(value: 100nF, package: "0402", between: vout, gnd)  // decoupling

  // Design rules — validated at compile time
  rule trace_width(net: vout, min: 0.3mm)
  rule clearance(between: vin, gnd, min: 0.2mm)
  rule thermal_via(pad: ams1117_3v3.tab, count: 4, drill: 0.3mm)
}

// Simulation — systems level for numerical solver
sim transient_response {
  use schematic power_regulator

  let solver = systems {
    // Custom SPICE-like solver for transient analysis
    let circuit = spice.netlist_from(power_regulator)
    let sim = spice.transient(circuit, step: 1us, duration: 10ms)

    // Load step: 0mA to 500mA at t=1ms
    sim.add_current_source(net: vout, waveform: step(from: 0, to: 0.5, at: 1ms))

    bare {
      // Numerically intensive — sparse matrix solve per timestep
      let matrix = sim.conductance_matrix()
      let lu = sparse.lu_decompose(matrix)

      for t in sim.timesteps() {
        let rhs = sim.excitation_vector(t)
        let solution = sparse.lu_solve(lu, rhs)
        sim.record(t, solution)
      }
    }

    sim.results()
  }

  // Back to application level — analyze and report
  let vout_trace = solver.voltage(net: vout)
  assert vout_trace.overshoot() < 5.percent, "Output overshoot exceeds 5%"
  assert vout_trace.settling_time(tolerance: 1.percent) < 2ms, "Settling too slow"
  assert vout_trace.steady_state() between 3.25V and 3.35V, "Output out of range"

  report {
    title "3.3V Regulator Transient Response"
    plot vout_trace, label: "Output Voltage"
    plot solver.current(net: vout), label: "Load Current"
    table {
      "Overshoot"     | vout_trace.overshoot()
      "Settling Time" | vout_trace.settling_time(tolerance: 1.percent)
      "Steady State"  | vout_trace.steady_state()
    }
  }
}
```

**Audio/DSP:**

```forge
use @std.http
use @hw.audio

audio_pipeline reverb_processor {
  let input = audio.input(sample_rate: 44100, channels: 2)
  let output = audio.output(sample_rate: 44100, channels: 2)

  // Real-time audio callback — must be systems level
  // RC overhead in tight audio loop would cause audible glitches
  input.on_buffer(samples -> {
    systems {
      let processed = Buffer<f32>.alloc(samples.length)
      defer processed.free()

      bare {
        // Schroeder reverb: 4 parallel comb filters + 2 series allpass
        let ptr_in = samples.as_ptr()
        let ptr_out = processed.as_ptr()
        let len = samples.length

        simd.for_each_4(ptr_in, ptr_out, len, (input_v) -> {
          let comb1 = comb_filter(input_v, delay: 1557, feedback: 0.84)
          let comb2 = comb_filter(input_v, delay: 1617, feedback: 0.82)
          let comb3 = comb_filter(input_v, delay: 1491, feedback: 0.80)
          let comb4 = comb_filter(input_v, delay: 1422, feedback: 0.78)
          let mixed = (comb1 + comb2 + comb3 + comb4) * 0.25
          allpass_filter(allpass_filter(mixed, delay: 225), delay: 556)
        })
      }

      output.write(processed)
    }
  })
}

// Application-level control surface
server :8080 {
  POST /reverb/params -> (req: { decay: float, mix: float }) {
    reverb_processor.set_decay(req.decay)
    reverb_processor.set_mix(req.mix)
    { status: "ok" }
  }
}
```

**Machine Learning Inference:**

```forge
use @std.http
use @ml.model

// Load a model — application level
let classifier = ml.load("mobilenet_v2.onnx")

server :8080 {
  POST /classify -> (req) {
    let image = req.body.file

    // Inference needs systems level for predictable latency
    let prediction = systems {
      let tensor = Tensor<f32>.alloc([1, 3, 224, 224])
      defer tensor.free()

      // Preprocessing — bare level for throughput
      bare {
        let src = image.pixels_ptr()
        let dst = tensor.data_ptr()
        let len = 224 * 224

        // RGB normalization: (pixel / 255.0 - mean) / std
        // Vectorized over 8 pixels at a time
        let mean = simd.f32x8(0.485, 0.456, 0.406, 0.485, 0.456, 0.406, 0.485, 0.456)
        let std = simd.f32x8(0.229, 0.224, 0.225, 0.229, 0.224, 0.225, 0.229, 0.224)
        let scale = simd.f32x8.splat(1.0 / 255.0)

        for i in 0..(len / 8) {
          let pixels = simd.load_u8x8(src + i * 8).to_f32x8()
          let normalized = (pixels * scale - mean) / std
          simd.store_f32x8(dst + i * 8, normalized)
        }
      }

      classifier.infer(tensor)
    }

    {
      class: prediction.top(1).label,
      confidence: prediction.top(1).score,
    }
  }
}
```

---

## Compiler Architecture

The scoped level system has specific implications for how the compiler works.

### Frontend: Level-Aware Parsing

The parser recognizes `systems`, `bare`, and `hardware` blocks as scope modifiers. Inside each scope, the set of available operations expands. This is not a separate parser — it's the same parser with a wider set of accepted tokens and intrinsics based on the current scope level.

```
Source → [Parser] → AST with level annotations on each scope
                      ↓
                   [Type Checker] → checks levels, verifies boundaries
                      ↓
                   [Level Lowering] → different IR strategies per level
                      ↓
                   [LLVM IR] → unified IR, different patterns per level
                      ↓
                   [Native Code]
```

### Type Checking: Level Polymorphism

A function's level is part of its type signature. If a function contains a `systems` block, its *interface* is still application-level. But if a function is *declared* at systems level, it can only be called from systems level or lower.

```forge
// This function is application-level (the default)
// It uses systems internally, but callers don't know or care
fn process_image(image: Image) -> Image {
  systems {
    // ...
  }
}

// This function IS systems level — can only be called from systems or bare
systems fn fast_multiply(a: *f32, b: *f32, out: *f32, n: int) {
  // ...
}

// Application code can call process_image but NOT fast_multiply
fn main() {
  let img = process_image(my_image)     // OK
  // fast_multiply(...)                  // COMPILE ERROR: systems fn called from app level
}
```

### Memory Strategy Per Level

| Level | Allocation | Deallocation | Memory Model | Overhead |
|---|---|---|---|---|
| Application | Automatic (heap + arena) | Reference counting + arena bulk-free | RC + arena + targeted cycle detection | ~2-5ns per retain/release |
| Systems | Explicit (`alloc`/stack) | Compiler-inserted drops (ownership) | Ownership/borrowing (Rust-style) | Zero runtime overhead |
| Bare | Manual (`mem.alloc`) | Manual (`mem.free`) | Raw — you manage everything | Zero overhead |
| Hardware | Memory-mapped / DMA | N/A (hardware-managed) | Volatile by default | Zero overhead |

### Boundary Transitions

Each boundary transition has a defined set of rules the compiler enforces:

**App → Systems:**
- RC-managed values must be copied or explicitly moved
- Simple types (int, float, bool, small structs) cross with zero cost
- Large collections require explicit `.to_owned()` conversion
- No retain/release inside the systems scope
- Returned value must be a type application level can manage

**Systems → Bare:**
- Lifetime-tracked values are frozen — the borrow checker pauses
- Raw pointers can be obtained from owned values
- Returned value must be wrappable in an owned type
- No implicit drops inside bare scope — all deallocation is manual

**Bare → Hardware:**
- Volatile semantics are default — no reordering of reads/writes
- Register addresses validated against target hardware description
- Interrupt context restrictions enforced (no allocation, no blocking)
- Returned values go back to bare semantics

---

## The Self-Hosting Connection

This proposal connects directly to the vision of Forge describing itself in its own language. Each abstraction level could eventually be defined *as a Forge component*:

```forge
// The application level is a component that provides RC semantics
component level_application {
  on alloc(type: Type, size: int) -> *void {
    let ptr = rc_alloc(size + RC_HEADER_SIZE)
    rc_init(ptr, ref_count: 1)
    ptr + RC_HEADER_SIZE
  }

  on dealloc(ptr: *void) {
    rc_decrement(ptr - RC_HEADER_SIZE)
  }

  on scope_exit(bindings: List<Binding>) {
    for b in bindings {
      rc_release(b.ptr)
    }
  }
}

// The systems level is a component that provides ownership semantics
component level_systems {
  on alloc(type: Type, size: int) -> *void {
    heap_alloc(size)
  }

  on dealloc(ptr: *void) {
    heap_free(ptr)
  }

  on scope_exit(bindings: List<Binding>) {
    // Compiler inserts these based on ownership analysis
    for b in bindings.owned() {
      drop(b)
    }
  }

  on borrow_check(borrows: List<Borrow>) -> Result<(), CompileError> {
    // Lifetime analysis
  }
}
```

The levels are just components with different memory strategies. The compiler is just a pipeline that consults these components when lowering code. As Forge self-hosts, even the memory management strategies become Forge code.

---

## Error Diagnostics Across Levels

Forge's structured error system works at every level. The diagnostic quality doesn't degrade when you drop into systems or bare code. If anything, the errors get *more* helpful because the compiler understands what you're trying to do.

### Lifetime Error (Systems)

```
  ╭─[error[F0200]] Lifetime escapes systems scope
  │
  │   12 │   systems {
  │   13 │     let buf = Buffer<u8>.alloc(1024)
  │   14 │     buf
  │      │     ───
  │      │     buf has manual lifetime — cannot return to application scope
  │
  │  ├── help: copy into a managed type before returning
  │  │    14 │     Bytes.from_buffer(buf)    // copies into RC-managed Bytes
  │  │
  │  ├── note: systems-level allocations are freed on scope exit
  │  │         returning them to application level would create a dangling reference
  ╰──
```

### Use-After-Free (Bare)

```
  ╭─[error[F0210]] Use after free
  │
  │   15 │     bare {
  │   16 │       let ptr = mem.alloc<u8>(256)
  │   17 │       mem.free(ptr)
  │   18 │       let val = ptr[0]
  │      │                 ───────
  │      │                 ptr was freed on line 17
  │
  │  ├── note: in bare scope, the compiler tracks allocations and frees
  │  │         but cannot prevent all use-after-free at compile time
  │  │
  │  ├── help: consider using systems scope instead, which provides
  │  │         compile-time lifetime checking
  ╰──
```

### Register Validation Error (Hardware)

```
  ╭─[error[F0300]] Invalid register address for target
  │
  │    8 │     hardware {
  │    9 │       let gpio = register_map(0x3F200000)
  │      │                               ──────────
  │      │                               0x3F200000 is the BCM2835 GPIO base
  │      │                               but target is STM32F401 (ARM Cortex-M4)
  │
  │  ├── help: STM32F401 GPIO base addresses:
  │  │         GPIOA: 0x40020000
  │  │         GPIOB: 0x40020400
  │  │         GPIOC: 0x40020800
  │  │
  │  ├── note: target set in forge.toml:
  │  │    [hardware]
  │  │    target = "stm32f401"
  ╰──
```

### Boundary Violation Error

```
  ╭─[error[F0205]] RC-managed value in systems scope
  │
  │    5 │   let users = User.list()
  │    6 │   systems {
  │    7 │     process(users)
  │      │             ─────
  │      │             users is List<User> (reference-counted)
  │      │             cannot be used directly in systems scope
  │
  │  ├── help: convert to owned representation
  │  │     7 │     let owned = users.to_owned()
  │  │     8 │     defer owned.free()
  │  │     9 │     process(owned)
  │  │
  │  ├── note: simple types (int, float, string, small structs) cross
  │  │         the boundary automatically. Collections require explicit conversion.
  ╰──
```

---

## Target Hardware Descriptions

For hardware-level code, Forge needs to know what hardware it's targeting. This is configured in `forge.toml` and optionally augmented with hardware description files:

```toml
[hardware]
target = "rp2040"                # Raspberry Pi Pico
clock = 125_000_000              # 125 MHz
flash = "2MB"
ram = "264KB"

# Custom peripherals not in the standard chip description
[hardware.peripherals.custom_adc]
base = 0x40054000
registers = "hw/custom_adc.fgr"  # Forge register description file
```

Hardware description in Forge syntax:

```forge
// hw/rp2040_gpio.fgr — register description file
register_bank gpio @base(0x40014000) {
  GPIO0_STATUS: u32 @offset(0x000) {
    IRQTOPROC:   bit(26)     @readonly
    IRQFROMPAD:  bit(24)     @readonly
    INTOPERI:    bit(19)     @readonly
    INFROMPAD:   bit(17)     @readonly
    OETOPAD:     bit(13)     @readonly
    OUTTOPAD:    bit(9)      @readonly
  }

  GPIO0_CTRL: u32 @offset(0x004) {
    IRQOVER:  bits(29..28)
    INOVER:   bits(17..16)
    OEOVER:   bits(13..12)
    OUTOVER:  bits(9..8)
    FUNCSEL:  bits(4..0)      @values {
      spi = 1, uart = 2, i2c = 3, pwm = 4,
      sio = 5, pio0 = 6, pio1 = 7, usb = 9, null = 31
    }
  }
  // ... more registers
}
```

This register description is compiled into the type system. `gpio.GPIO0_CTRL.FUNCSEL = .spi` is type-checked — the compiler knows that FUNCSEL is 5 bits wide and `.spi` maps to value `1`.

---

## Real-Time Guarantees

Systems-level and below code can declare real-time constraints that the compiler verifies:

```forge
systems {
  // Declare a hard real-time loop — compiler verifies no RC overhead,
  // no unbounded allocation, no blocking I/O inside
  rt_loop(interval: 1ms, priority: .high) {
    let sensor_data = imu.read()                  // OK: hardware read, bounded time
    let correction = pid.update(sensor_data)       // OK: pure computation
    motor.set_torque(correction)                   // OK: hardware write

    // User.list()                                 // COMPILE ERROR: RC-managed, unbounded
    // println("debug")                            // COMPILE ERROR: I/O in rt_loop
    // let buf = Buffer.alloc(...)                 // COMPILE ERROR: heap alloc in rt_loop
  }
}
```

```
  ╭─[error[F0250]] Allocation in real-time loop
  │
  │   10 │     rt_loop(interval: 1ms) {
  │   11 │       let buf = Buffer.alloc(1024)
  │      │                 ─────────────────
  │      │                 heap allocation is not allowed in rt_loop
  │
  │  ├── help: pre-allocate before the loop
  │  │     9 │     let buf = Buffer.alloc(1024)
  │  │    10 │     rt_loop(interval: 1ms) {
  │  │    11 │       // use buf here
  │  │
  │  ├── note: rt_loop guarantees bounded execution time per iteration
  │  │         heap allocation has unbounded latency
  ╰──
```

---

## Deployment Targets

The level system naturally maps to different deployment targets:

| Target | Available Levels | Binary Output |
|---|---|---|
| Linux/macOS/Windows | app, systems, bare | Standard executable |
| Embedded Linux (RPi, etc.) | app, systems, bare, hardware | ELF with hardware support |
| Bare Metal (STM32, RP2040) | systems, bare, hardware | Raw binary / ELF (no OS) |
| WASM | app, systems | `.wasm` module |
| FPGA (future) | hardware | Bitstream via Yosys |

For bare-metal targets, the application level is unavailable (no OS, no arena allocator, no cycle detection runtime). Code must be written at systems level or below. The compiler enforces this:

```
  ╭─[error[F0260]] Application level unavailable on bare-metal target
  │
  │    1 │ let users = User.list()
  │      │             ───────────
  │      │             User.list() requires application level (RC-managed)
  │      │             target stm32f401 only supports: systems, bare, hardware
  │
  │  ├── note: bare-metal targets have no operating system
  │  │         reference counting and arena allocation require OS support
  │  │         all code must use systems, bare, or hardware levels
  ╰──
```

---

## The AI Ergonomics Angle

This system is designed for a future where AI writes most code. Here's why scoped levels are better than separate languages for AI-driven development:

**Single context window.** An AI working on a Forge project can see the web server, the real-time control loop, and the hardware register manipulation in one file. No context switching between "the Python orchestration code" and "the C firmware code." The AI maintains full understanding of the system at all times.

**Fluid level transitions.** An AI doesn't find it cognitively expensive to switch between "application mode" and "systems mode." It can write twelve lines of bare-level SIMD code, close the block, and continue writing application-level route handlers. No project switching, no FFI boilerplate, no build system changes.

**Unified errors.** When something goes wrong across a level boundary, the AI gets one structured error from one compiler, not a cryptic linker error from a cross-language build system. The diagnostic tells it exactly what went wrong, what level it happened at, and how to fix it.

**Verifiable boundaries.** The compiler proves that level transitions are correct. An AI generating systems-level code can't accidentally leak a raw pointer into application space. The type system catches it. This is critical for AI-generated code where a human may not review every line — the compiler is the safety net.

**Incremental optimization.** An AI can write everything at application level first, profile it, and then surgically drop the hot path into systems or bare level. No rewrite in a different language. No new build target. Just wrap the hot code in a `systems { }` or `bare { }` block and optimize in place.

---

## Implementation Phases

This vision doesn't need to ship all at once. It maps naturally to Forge's existing phase roadmap:

### Phase 1: Current (Application Level Only)

Forge as it exists today. RC-managed, provider-based, application-level orchestration. No level system. The existing `@std/http`, `@std/model`, etc. providers work at application level.

### Phase 2: Systems Level

Add the `systems` block with ownership-based memory management. This is the first real level. It doesn't require hardware support or SIMD intrinsics — it's about giving Forge code a way to opt into deterministic resource management.

Key deliverables:
- `systems { }` scope with ownership/borrow checking
- Boundary verification between application ↔ systems
- `Buffer`, `OwnedString`, and other systems-level types
- `defer` with compiler-verified cleanup
- Functions annotated as `systems fn`

### Phase 3: Bare Level

Add the `bare` block with raw pointer support and SIMD intrinsics. This targets performance-critical inner loops and interop with C libraries.

Key deliverables:
- `bare { }` scope with raw pointer access
- SIMD intrinsics (`simd.load_128`, `simd.f32x4`, etc.)
- `mem.alloc` / `mem.free` manual allocation
- Pointer arithmetic and `reinterpret_cast`
- Inline assembly (per-architecture)
- Boundary verification between systems ↔ bare

### Phase 4: Hardware Level

Add the `hardware` block for bare-metal and embedded targets. This requires hardware description files, register map support, and cross-compilation.

Key deliverables:
- `hardware { }` scope with volatile semantics
- Register map declarations and bit field access
- Hardware description files (`.fgr`)
- Cross-compilation for ARM Cortex-M, RISC-V, etc.
- Interrupt handler registration
- `rt_loop` with real-time verification
- Bare-metal deployment target (no OS)

### Phase 5: Domain Providers

With all four levels available, build out domain-specific provider ecosystems:

- `@hw/gpio`, `@hw/i2c`, `@hw/spi` — hardware communication
- `@hw/robot` — robotics primitives
- `@hw/eda` — PCB design and simulation
- `@hw/audio` — real-time audio processing
- `@ml/model` — ML inference with optimized kernels
- `@hw/fpga` — FPGA bitstream generation (far future)

---

## Open Questions

**1. Level inference.** Should the compiler infer levels automatically? If a function only uses application-level operations, it's application-level. If it does manual allocation, it's systems-level. This could reduce annotation burden but might make boundaries less explicit.

**2. Level generics.** Can a function be generic over its level? A sorting algorithm works at any level — the logic is the same, only the memory strategy changes. Could you write `fn sort<L: Level, T: Ord>(list: L.List<T>)` and have it work everywhere?

**3. Async across levels.** Application level has `spawn` and channels for concurrency. Systems level needs a different concurrency model (no heap allocation for task queues). How do async patterns compose across levels?

**4. FFI and the level system.** When Forge calls a C function via FFI, what level is it? Probably `bare`, since C doesn't have lifetime tracking. But should the FFI bridge let you annotate C functions with level information?

**5. Testing across levels.** The `@std/test` component works at application level. How do you write tests for systems-level or bare-level code? Do tests run at a higher level than the code they test (so they can use RC and arenas for test infrastructure)?

**6. Debug vs Release.** Should debug builds add runtime checks inside `bare` blocks (bounds checking on pointer arithmetic, use-after-free detection) that release builds strip? This would make bare-level code safer during development without runtime cost in production.

**7. Level cost model.** Developers (and AIs) need to understand the cost of level transitions. Should the compiler report the overhead of each boundary crossing? A "performance profile" that shows where copies and conversions happen at level transitions?

**8. Community providers.** When third parties write providers, can they declare that their provider requires a minimum level? A GPIO provider obviously needs hardware level internally. But a caching provider might be pure application level. How is this expressed and verified?

---

## Prior Art

This idea doesn't come from nowhere. Several languages and systems have explored parts of this design space. None have put it all together.

### Rust: `unsafe` blocks

The closest existing analog. Rust lets you drop into `unsafe` for raw pointer manipulation, FFI, and operations the borrow checker can't verify. The key differences from Forge's proposal:

- Rust's `unsafe` is binary — safe or unsafe. Forge proposes a spectrum (app → systems → bare → hardware).
- Rust's `unsafe` doesn't change the memory model — you're still in ownership-land, just with the guardrails removed. Forge's levels actually change the compiler's strategy (RC → ownership → manual → hardware).
- Rust's `unsafe` is viral in reputation — a crate that uses `unsafe` internally is viewed with suspicion even if its public API is safe. Forge's levels are implementation details that don't leak through interfaces.
- Rust doesn't have an "easier than ownership" mode. You're always in the ownership model. Forge's application level is genuinely simpler — no lifetimes, no borrowing, just write code.

### Zig: `comptime` and explicit allocators

Zig lets you choose your allocator explicitly and provides `comptime` for compile-time evaluation. Relevant parallels:

- Zig's explicit allocators are philosophically similar to Forge's level system — different memory strategies for different contexts. But in Zig, you pass allocators as function parameters everywhere. In Forge, the strategy is a property of the scope.
- Zig's `comptime` proves that compile-time evaluation can eliminate entire categories of runtime overhead. Forge could leverage similar ideas at the systems and bare levels.

### Terra: Staged compilation

Terra (built on top of Lua) lets you write high-level Lua code that generates low-level Terra code at compile time. The "two-language" approach within one system:

- Terra proves that mixing abstraction levels in one file is viable and useful.
- But Terra is literally two languages (Lua + Terra) sharing a runtime. Forge proposes one language with scoped strategies. The syntax, type system, and error system don't change between levels.

### Nim: Multiple backends and `emit` pragmas

Nim compiles to C, C++, or JavaScript and provides `emit` pragmas for inserting backend-specific code. It also has manual memory management options alongside its GC:

- Nim's `{.emit: "...".}` pragma is conceptually similar to Forge's `bare` block — drop into a lower level for specific operations.
- But Nim's emit is string-based backend insertion, not a type-checked scope. You lose all compiler guarantees. Forge's levels remain fully type-checked.

### Racket: `#lang` and language-oriented programming

Racket lets you define entirely new languages that compose in the same project via `#lang`. Each module can be a different language:

- This proves that multi-paradigm composition within one ecosystem is both possible and beloved by its users.
- But Racket's languages are module-level. You can't switch languages mid-function. Forge's levels are expression-level — you can drop into `bare` for three lines and come back.
- Racket is dynamically typed. Forge's levels work within a single static type system with verified boundaries.

### C#: `unsafe` context and `Span<T>`

C# has `unsafe` blocks for pointer manipulation and `Span<T>` / `Memory<T>` for stack-based, allocation-free work within an otherwise GC'd language:

- `Span<T>` is essentially a "systems-level view" into GC-managed memory — similar in spirit to what Forge's systems level provides.
- C#'s `unsafe` is closer to Forge's `bare` — raw pointers, manual everything.
- But C# can't go further. No hardware level, no register maps, no bare-metal deployment. And the GC is always there, even in `unsafe` code — you're just working around it, not opting out.

### Ada/SPARK: Mixed criticality and verification levels

Ada has different pragma profiles (`Ravenscar`, `Jorvik`) that restrict the language to subsets suitable for real-time and safety-critical work. SPARK is a formally verified subset:

- This is the closest conceptual precedent for "the same language with different capability sets per context."
- But Ada's profiles are module-level or project-level, not block-level. You can't mix a Ravenscar task with unconstrained Ada in the same function.
- Ada's restrictions *remove* capabilities. Forge's levels *add* capabilities as you go lower. The direction is inverted.

### D: `@safe`, `@trusted`, `@system`

D has function-level annotations that control what operations are allowed:

- `@safe` functions can't use raw pointers. `@system` functions can. `@trusted` is the boundary — a `@safe` interface with `@system` guts.
- This is very close to Forge's provider pattern where the public API is application-level and the internals use a lower level.
- But D's annotations are per-function, not per-block. And D doesn't change memory strategy — it's always GC'd (or manually managed if you opt out project-wide).

### Summary: What's genuinely new

No existing language combines all of:

1. **Block-scoped** level transitions (not module-level, not project-level)
2. **Different memory strategies** per level (not just different capabilities on the same strategy)
3. **Verified boundaries** between levels (not just "trust me" annotations)
4. **A full spectrum** from application to hardware (not just safe/unsafe binary)
5. **Same syntax and type system** at every level

Each piece exists somewhere. The combination doesn't.

---

## What People Will Complain About

Let's be honest about the attack surface. Here's what the Hacker News thread will look like, and how we answer each one.

### "This is vaporware. You can't actually build a compiler that does four memory models."

**The complaint:** Implementing RC, ownership/borrowing, manual memory, and hardware semantics in one compiler frontend is an enormous undertaking. LLVM handles the backend, sure — but the frontend work (four different lowering strategies, boundary verification, cross-level type checking) is years of engineering.

**The honest answer:** This is the most legitimate criticism. It *is* a huge compiler project. The mitigation is phased implementation — application level exists today, systems is next, bare and hardware come later. Each phase is independently useful. You don't need all four levels to ship value. And the Rust project proved that ownership/borrowing analysis is tractable compiler engineering, not research-level unsolved problems.

**What we should do:** Be explicit in the roadmap that Phase 2 (systems level) is the critical milestone. If systems-level scoped blocks work well, bare and hardware follow naturally. If systems-level is too hard to get right, the whole approach needs rethinking. Don't oversell the full vision before Phase 2 is proven.

### "The boundary between levels will leak. It always does."

**The complaint:** In practice, the "simple types cross for free" rule will constantly frustrate. String representations differ between RC-managed and owned. Collections need deep copies at every boundary. The boundary overhead will dominate in real code, making the levels useless for the performance-critical work they're designed for.

**The honest answer:** This is partially right. Boundary crossing does have cost for non-trivial types. The arena-allocated patterns at application level help (arena data is laid out contiguously, making `.to_owned()` fast), but it's not free.

**What we should do:**

- Design the application-level types to be "boundary-friendly" from the start. Strings should be UTF-8 byte arrays internally at every level, not different representations. Lists should be contiguous buffers, not linked structures.
- Provide `borrow` semantics at boundaries where possible — instead of always copying, let systems-level code borrow an application-level value with a compile-time guarantee that the borrow doesn't outlive the scope. This is the `Span<T>` insight from C#.
- Profile and publish the actual cost of boundary crossings. Don't handwave.

```forge
let users = User.list()    // application: RC-managed list

systems {
  // Instead of copying, borrow a read-only view
  // Compiler verifies the borrow doesn't escape this scope
  let view = users.borrow()    // zero-copy, read-only
  let count = count_active(view)
  count    // simple int, crosses for free
}
```

### "You're just reinventing Rust's unsafe with extra steps."

**The complaint:** This is Rust's `unsafe` with more marketing. The "levels" are just syntactic sugar for what Rust already does — safe code by default, opt into danger when needed.

**The honest answer:** The systems level *is* similar to Rust's safe code (ownership/borrowing), and bare *is* similar to `unsafe`. But the key differences are:

1. Forge's application level is *easier* than Rust's safe mode. No lifetimes, no borrow checker. RC + arenas. This is the whole point — Rust forces you into the ownership model for *everything*, including code that doesn't need it.
2. The hardware level has no Rust equivalent. Rust can do embedded, but you're still in the ownership model with `unsafe` escape hatches. Forge's hardware level is purpose-built for register maps, volatile access, and compile-time hardware validation.
3. Forge's levels are scoped and composable within a function. Rust's `unsafe` is a blunt instrument by comparison.

**What we should do:** Don't position this as "better than Rust." Position it as "Rust-level performance available when you need it, without Rust-level ceremony when you don't." The application level is the differentiator, not the systems level.

### "Nobody will use the hardware level. Just FFI to C."

**The complaint:** The embedded/hardware community has decades of C tooling, existing register definition files (SVD for ARM), working debuggers, proven RTOS integrations. They won't rewrite all of that for a new language.

**The honest answer:** Mostly correct for the existing embedded community. The hardware level isn't for them — at least not initially.

**What we should do:**

- Build the hardware level as an FFI *consumer* first, not a replacement. Import SVD files as Forge register maps. Bridge to existing RTOS primitives. Interop with existing C HALs (Hardware Abstraction Layers). Don't ask people to rewrite — let them wrap.
- Target the *new* embedded audience — AI agents building hardware integrations, hobbyists who know web development but want to program a robot, teams building IoT devices who currently suffer through the Python-to-C handoff. These people don't have decades of C tooling loyalty.
- The compiler can generate C-compatible headers from hardware-level Forge code, so existing toolchains can call into Forge. Meet people where they are.

### "Four levels is too many. People won't know when to use which."

**The complaint:** Developers already struggle with deciding between `let` and `const`. Now you want them to choose between four memory models? The cognitive overhead of deciding "should this be application, systems, bare, or hardware" will paralyze people.

**The honest answer:** This is a real UX problem. But it's mitigated by two things:

1. **Most people never leave application level.** The default is application. You only drop to systems when you have a measured performance problem. You only drop to bare when systems isn't enough. You only drop to hardware when talking to actual hardware. 99% of code stays at application level.
2. **AI decides, not humans.** This language is designed for AI-assisted development. The AI knows when to use systems level (profiling shows a hot path), when to use bare (SIMD would help), when to use hardware (the target is embedded). The human says "make this faster" or "deploy to this microcontroller" and the AI chooses the level.

**What we should do:**

- Provide clear guidelines: "If you're not sure, stay at application level. Drop down only when you can measure the need."
- The compiler should *suggest* level transitions: "This hot loop would benefit from systems-level allocation. Apply? [y/n]"
- IDE integration that shows the current level of each scope visually — color coding, gutter annotations, whatever makes it obvious.

### "The compile times will be atrocious."

**The complaint:** The Rust compiler is famously slow, and that's just one memory model with one set of lifetime checks. You're proposing four, with boundary verification on top. Compile times will be worse than C++ templates.

**The honest answer:** This is a real concern. Ownership/borrowing analysis is expensive. Doing it only in scoped blocks (not whole-program) helps — the analysis is bounded by the block size, not the project size. But the boundary checking between levels is additional work the compiler must do.

**What we should do:**

- Incremental compilation: only re-analyze scopes that changed.
- Level-local analysis: ownership checking inside a `systems` block doesn't need to look outside the block. This is *more* constrained than Rust's whole-function analysis.
- Fast-path for application-only code: if a file has no level transitions, skip the level analysis entirely. Most files will be application-only.
- Profile the compiler itself. Set compile-time budgets. "Forge must compile 50,000 LOC/second for application-level code, 10,000 LOC/second for mixed-level code."

### "You'll fragment the ecosystem. Libraries written at systems level can't be used from application level."

**The complaint:** If a library is written at systems level, it exposes systems-level types (owned buffers, lifetime-annotated references). Application-level code can't use it without wrapping. You'll get two ecosystems — application libraries and systems libraries — just like the colored-function problem in async.

**The honest answer:** This is the "function coloring" problem applied to levels, and it's a genuine risk.

**What we should do:**

- Enforce the "level is an implementation detail" pattern: a library's public API should always be at the *highest* level that makes sense (usually application). The implementation can use any level internally. The provider pattern already does this — the public `gpio.output(17)` is application-level even though the guts are hardware-level.
- The compiler can auto-generate application-level wrappers for systems-level functions. If a function takes an `OwnedBuffer`, the wrapper takes a `List<u8>`, does the `.to_owned()` conversion, calls the function, and converts back. This is what C# does with `Span<T>` marshaling.
- Standard library types should work at all levels. A `string` at application level is RC-managed. The same `string` type at systems level is ownership-tracked. The in-memory representation is identical — the difference is how the compiler manages its lifecycle.

### "The AI argument is a cop-out. Languages should be designed for humans."

**The complaint:** "Designed for AI" is handwaving away the UX problems. If a language is hard for humans to reason about, no amount of AI assistance fixes that. And AI won't always be available — people need to read and review code.

**The honest answer:** Fair. The language must be readable and understandable by humans, even if AI writes most of it. The level system should *simplify* reading, not complicate it. A `systems { }` block tells a human reader "this section cares about performance, memory is manually managed here." That's *more* information than the reader had before, not less.

**What we should do:**

- Ensure that level blocks are visually obvious. You can read a Forge file top-to-bottom and know exactly where the level transitions happen.
- The default (application level) requires no annotation. You only need to think about levels when you explicitly opt in. A Forge file with no `systems`, `bare`, or `hardware` blocks reads exactly like Forge does today.
- Documentation should be level-aware. API docs should say "this function operates at application level" or "this function contains a systems-level inner loop." Humans need this context for code review.

### "You're building a language for a world that doesn't exist yet."

**The complaint:** The "AI-engineered future" hasn't arrived. Current AI can't reliably write correct `unsafe` Rust. Building a language around the assumption that AI will handle low-level concerns is premature.

**The honest answer:** Partly right. AI is not ready to autonomously write correct bare-metal firmware today. But:

1. The level system is independently useful without AI. A human writing `systems { }` to opt into ownership semantics for a hot loop is a better experience than rewriting that loop in Rust and FFI-bridging it.
2. Languages take years to build. By the time Forge's hardware level ships, AI will be significantly more capable. Designing for the future is the right bet.
3. Even today, AI is very good at writing application-level code and reasonably good at systems-level code with clear constraints. The scoped nature of levels makes the problem tractable — the AI only needs to get ownership right for 20 lines inside a `systems` block, not for an entire codebase.

**What we should do:** Ship the levels that are useful *now* (application + systems), design the levels that will be useful *soon* (bare + hardware), and be honest about the timeline. Don't claim the hardware level is production-ready before it is.

---

## Holes We Haven't Addressed

Beyond what critics will say, here are genuine unsolved problems in this proposal.

### The Standard Library Duplication Problem

If `string`, `List`, `Map` need to work at every level, you need multiple implementations of each data structure — one RC-managed, one ownership-tracked, one manual. Or you need a single implementation that's polymorphic over memory strategy. The former is a maintenance nightmare. The latter is a research problem.

The best existing approach is Zig's explicit allocator pattern — data structures are parameterized by their allocation strategy. Forge could do something similar at the type level:

```forge
// One List implementation, parameterized by level
// The compiler monomorphizes per-level
let app_list: List<int> = [1, 2, 3]                    // RC-managed
systems { let sys_list: List<int> = [1, 2, 3] }        // ownership-tracked
bare { let bare_list: List<int> = List.manual(3) }      // manual alloc
```

But the devil is in the details. Does `List.push()` behave differently at systems level (might need to reallocate, ownership implications)? Does `List.sort()` need a different implementation at bare level (no stack overflow protection)? These questions need concrete answers.

### Debugging Across Levels

GDB and LLDB understand one memory model per binary. A binary with RC-managed, ownership-tracked, and manually-managed memory coexisting is going to confuse debuggers. Breakpoints in a `systems` block need to show ownership state. Breakpoints in a `bare` block need to show raw pointer values. Breakpoints in application code need to show logical values without RC metadata.

This probably requires a custom debug info format or significant GDB/LLDB extensions. That's a real investment.

### Error Recovery Across Boundaries

What happens when a `bare` block panics (null pointer dereference, out-of-bounds)? Application level has structured error handling with `Result` and `catch`. Bare level has... a segfault. How does the error propagate across the boundary?

Options:
- `bare` blocks can't panic — all potentially-panicking operations must be guarded with explicit checks that produce `Result` values.
- `bare` blocks have a "trap" mechanism that converts hardware faults to structured errors at the boundary. Expensive, but safe.
- `bare` blocks are "abort on fault" — a crash in bare brings down the process. This is what C does and what most people expect.

### Incremental Adoption in Existing Projects

How does a team adopt levels incrementally? If they have a large application-level Forge codebase, can they add a `systems` block to one function without reorganizing anything? (Probably yes, but the tooling needs to support this — the build system, the test runner, the linter all need to be level-aware.)

### Cross-Level Closures

```forge
let callback = (x: int) -> x * 2    // application-level closure

systems {
  let items = Buffer<int>.alloc(100)
  // Can we pass `callback` into a systems-level map function?
  // The closure captures nothing, so maybe. But what if it did capture?
  items.map(callback)    // ??? What level is this closure at?
}
```

Closures that capture RC-managed values can't run at systems level. Closures that capture nothing can run anywhere. Closures that capture owned values can run at systems level. The rules need to be precise and the errors need to be clear.

### The "Is This Worth It?" Test

Ultimately, every feature must pass the test: does the benefit justify the complexity? For each level:

- **Systems level:** Almost certainly worth it. "Drop into ownership semantics for a hot loop without rewriting in Rust" is a clear, common, high-value use case.
- **Bare level:** Probably worth it for the SIMD/performance niche. Most users won't touch it, but the ones who need it *really* need it.
- **Hardware level:** Highest risk, highest reward. If it works, Forge becomes viable for embedded — a massive market expansion. If it doesn't, it's a lot of compiler work for a niche audience. The FFI-first approach (bridge to existing C HALs) is the safe bet.

---

## Conclusion

The division between "application languages" and "systems languages" is an accident of history, not a law of physics. It exists because human brains specialize. AI doesn't.

Forge's scoped abstraction levels let you write a web server that controls a robot arm that processes sensor data with SIMD-accelerated algorithms that talk to hardware registers — all in one file, one type system, one error system, one compiler, one deployment. The right level of abstraction for each piece of code, with the compiler verifying every boundary.

The sky is the limit. The compiler is the safety net. Forge on.
