# Forge — Pointer Operations (TDD)

`ptr` gets two operations: `+` for offset and `[]` for byte read/write. Plus `string.from_ptr()` and `ptr.from_string()` for bridging between safe Forge strings and raw memory. These operations are unchecked — when `systems` blocks ship later, they become restricted to those scopes.

---

## Test 1: Allocate and free

```forge
extern fn malloc(size: int) -> ptr
extern fn free(p: ptr)

fn main() {
  let buf = malloc(1024)
  println(string(buf != null))    // true (assuming allocation succeeds)
  free(buf)
}
```

## Test 2: Write and read bytes

```forge
extern fn malloc(size: int) -> ptr
extern fn free(p: ptr)

fn main() {
  let buf = malloc(16)
  defer free(buf)

  buf[0] = 72       // 'H'
  buf[1] = 105      // 'i'

  println(string(buf[0]))    // 72
  println(string(buf[1]))    // 105
}
```

## Test 3: Pointer arithmetic

```forge
extern fn malloc(size: int) -> ptr
extern fn free(p: ptr)

fn main() {
  let buf = malloc(16)
  defer free(buf)

  buf[0] = 65    // 'A'
  buf[1] = 66    // 'B'
  buf[2] = 67    // 'C'

  let second = buf + 1
  println(string(second[0]))    // 66 ('B')
  println(string(second[1]))    // 67 ('C')

  let third = buf + 2
  println(string(third[0]))     // 67 ('C')
}
```

## Test 4: ptr to string conversion

```forge
extern fn malloc(size: int) -> ptr
extern fn free(p: ptr)

fn main() {
  let buf = malloc(16)
  defer free(buf)

  buf[0] = 72       // 'H'
  buf[1] = 101      // 'e'
  buf[2] = 108      // 'l'
  buf[3] = 108      // 'l'
  buf[4] = 111      // 'o'

  let s = string.from_ptr(buf, 5)
  println(s)                      // Hello
  println(string(s.length))       // 5
}
```

## Test 5: string to ptr conversion

```forge
extern fn malloc(size: int) -> ptr
extern fn free(p: ptr)
extern fn write(fd: int, buf: ptr, count: int) -> int

fn main() {
  let msg = "Hello\n"
  let p = ptr.from_string(msg)

  // Write to stdout using raw syscall
  write(1, p, msg.length)        // prints: Hello
}
```

## Test 6: Read from stdin (libc read)

```forge
extern fn malloc(size: int) -> ptr
extern fn free(p: ptr)
extern fn read(fd: int, buf: ptr, count: int) -> int

fn read_bytes(n: int) -> string {
  let buf = malloc(n)
  defer free(buf)

  let bytes_read = read(0, buf, n)
  string.from_ptr(buf, bytes_read)
}

fn main() {
  let input = read_bytes(1024)
  println(`got: ${input}`)
}
```

```bash
echo "hello" | forge run test_read.fg
# got: hello
```

## Test 7: Read line implementation

```forge
extern fn malloc(size: int) -> ptr
extern fn free(p: ptr)
extern fn read(fd: int, buf: ptr, count: int) -> int

fn read_line() -> string {
  let buf = malloc(4096)
  defer free(buf)

  mut i = 0
  loop {
    let n = read(0, buf + i, 1)
    if n <= 0 { break }
    if buf[i] == 10 { break }       // newline
    i = i + 1
    if i >= 4095 { break }          // buffer limit
  }

  string.from_ptr(buf, i)
}

fn main() {
  let line = read_line()
  println(`line: ${line}`)
}
```

```bash
echo "hello world" | forge run test_readline.fg
# line: hello world
```

## Test 8: Write to stderr

```forge
extern fn write(fd: int, buf: ptr, count: int) -> int

fn eprintln(msg: string) {
  let p = ptr.from_string(msg)
  write(2, p, msg.length)
  write(2, ptr.from_string("\n"), 1)
}

fn main() {
  eprintln("this goes to stderr")
  println("this goes to stdout")
}
```

```bash
forge run test_stderr.fg 2>/dev/null
# this goes to stdout

forge run test_stderr.fg 1>/dev/null
# this goes to stderr
```

## Test 9: Pointer comparison

```forge
extern fn malloc(size: int) -> ptr

fn main() {
  let a = malloc(16)
  let b = malloc(16)
  let c = a + 4

  println(string(a == a))       // true
  println(string(a == b))       // false
  println(string(a != b))       // true
  println(string(c == a + 4))   // true
  println(string(a == null))    // false

  let n: ptr = null
  println(string(n == null))    // true
}
```

## Test 10: Null ptr check

```forge
extern fn malloc(size: int) -> ptr
extern fn free(p: ptr)

fn main() {
  let buf: ptr = null

  // Should panic with a clear error, not segfault
  let b = buf[0]
}
```

```
  ╭─[panic] Null pointer access
  │
  │  ╭─[test_null.fg:6:11]
  │  │
  │  │    6 │   let b = buf[0]
  │  │      │           ──────
  │  │      │           buf is null
  │  │
  │  ╰──
```

## Test 11: Pointer subtraction (distance)

```forge
extern fn malloc(size: int) -> ptr

fn main() {
  let buf = malloc(100)
  let end = buf + 42

  let distance = end - buf
  println(string(distance))     // 42
}
```

## Test 12: Copy memory between pointers

```forge
extern fn malloc(size: int) -> ptr
extern fn free(p: ptr)
extern fn memcpy(dest: ptr, src: ptr, n: int) -> ptr

fn main() {
  let src = malloc(5)
  defer free(src)
  src[0] = 72     // H
  src[1] = 101    // e
  src[2] = 108    // l
  src[3] = 108    // l
  src[4] = 111    // o

  let dest = malloc(5)
  defer free(dest)
  memcpy(dest, src, 5)

  println(string.from_ptr(dest, 5))    // Hello
}
```

## Test 13: Build a simple buffer type in pure Forge

```forge
extern fn malloc(size: int) -> ptr
extern fn free(p: ptr)
extern fn memcpy(dest: ptr, src: ptr, n: int) -> ptr

type Buffer = {
  data: ptr,
  len: int,
  cap: int,
}

fn buffer_new(cap: int) -> Buffer {
  Buffer { data: malloc(cap), len: 0, cap: cap }
}

fn buffer_push(buf: Buffer, byte: int) -> Buffer {
  assert buf.len < buf.cap, "buffer full"
  buf.data[buf.len] = byte
  buf with { len: buf.len + 1 }
}

fn buffer_to_string(buf: Buffer) -> string {
  string.from_ptr(buf.data, buf.len)
}

fn buffer_free(buf: Buffer) {
  free(buf.data)
}

fn main() {
  mut buf = buffer_new(256)
  defer buffer_free(buf)

  buf = buffer_push(buf, 72)     // H
  buf = buffer_push(buf, 105)    // i

  println(buffer_to_string(buf))  // Hi
  println(string(buf.len))        // 2
  println(string(buf.cap))        // 256
}
```

## Test 14: Pure Forge IO package (no Rust, no native lib)

```forge
// This is what @std/io would look like — pure Forge calling libc directly

extern fn read(fd: int, buf: ptr, count: int) -> int
extern fn write(fd: int, buf: ptr, count: int) -> int
extern fn malloc(size: int) -> ptr
extern fn free(p: ptr)

export fn read_line() -> string {
  let buf = malloc(4096)
  defer free(buf)

  mut i = 0
  loop {
    let n = read(0, buf + i, 1)
    if n <= 0 || buf[i] == 10 { break }
    i = i + 1
    if i >= 4095 { break }
  }

  string.from_ptr(buf, i)
}

export fn read_all() -> string {
  let buf = malloc(65536)
  defer free(buf)

  mut total = 0
  loop {
    let n = read(0, buf + total, 4096)
    if n <= 0 { break }
    total = total + n
  }

  string.from_ptr(buf, total)
}

export fn print(msg: string) {
  write(1, ptr.from_string(msg), msg.length)
}

export fn println(msg: string) {
  print(msg)
  write(1, ptr.from_string("\n"), 1)
}

export fn eprint(msg: string) {
  write(2, ptr.from_string(msg), msg.length)
}

export fn eprintln(msg: string) {
  eprint(msg)
  write(2, ptr.from_string("\n"), 1)
}
```

```forge
// Usage
use @std.io

fn main() {
  io.print("Enter your name: ")
  let name = io.read_line()
  io.println(`Hello, ${name}!`)
}
```

```bash
echo "Forge" | forge run test_io.fg
# Enter your name: Hello, Forge!
```

---

## Implementation

### New operations on `ptr` type

| Operation | Syntax | Meaning |
|---|---|---|
| Byte write | `ptr[index] = byte` | Write one byte at offset |
| Byte read | `ptr[index]` → `int` | Read one byte at offset |
| Offset | `ptr + int` → `ptr` | Advance pointer by N bytes |
| Distance | `ptr - ptr` → `int` | Byte distance between two pointers |
| Comparison | `ptr == ptr`, `ptr != ptr` | Address equality |
| Null check | `ptr == null` | Check if null |

### Bridge functions

| Function | Signature | Meaning |
|---|---|---|
| `string.from_ptr` | `(ptr, int) -> string` | Create Forge string from raw bytes + length |
| `ptr.from_string` | `(string) -> ptr` | Get raw pointer to string's bytes |

### Parser changes

- `ptr[expr]` as lvalue (assignment target) and rvalue (read)
- `ptr + int` and `ptr - ptr` as binary expressions
- `ptr == ptr` and `ptr != ptr` comparison

### Codegen changes

- `ptr[i]` read → LLVM `GEP` + `load i8`
- `ptr[i] = v` write → LLVM `GEP` + `store i8`
- `ptr + n` → LLVM `GEP` with byte offset
- `ptr - ptr` → LLVM `ptrtoint` + subtract
- Null check on `ptr[i]` access → emit null guard before GEP, panic with source location on null

### Feature registration

```rust
#[forge_feature(
    name = "Pointer Operations",
    status = "draft",
    depends = ["types_core", "extern_ffi"],
    enables = [],
    tokens = [],
    ast_nodes = [PtrIndex, PtrIndexAssign, PtrOffset],
    description = "Byte-level memory access: ptr[i], ptr + offset, string.from_ptr, ptr.from_string",
)]
pub mod ptr_ops;
```

### Future: restrict to systems blocks

When `systems` blocks ship, pointer operations become restricted:

```forge
// Application level — compile error
let buf = malloc(4096)
buf[0] = 65           // ERROR: pointer operations require a systems block

// Systems level — allowed
systems {
  let buf = malloc(4096)
  defer free(buf)
  buf[0] = 65         // OK
}
```

For now, pointer operations work everywhere with a compiler warning on first use:

```
  ╭─[info] Unchecked pointer operations
  │
  │  Pointer indexing and arithmetic are unchecked.
  │  These will require a `systems` block in a future version.
  ╰──
```
