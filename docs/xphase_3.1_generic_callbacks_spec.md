# Forge — Generic C ABI Callbacks & Struct JSON Serialization

**Problem:** HTTP route handler codegen is provider-specific because it needs to (1) wrap Forge closures as C ABI function pointers and (2) serialize structs to JSON. Both are general problems that every callback-taking provider will have.

**Solution:** Make both generic compiler features. Then delete all HTTP-specific codegen.

---

## 1. Generic C ABI Trampoline Generation

### What it does

When a Forge closure is passed to an `extern fn` parameter that expects a function pointer, the compiler auto-generates a C ABI wrapper.

### How the compiler knows to do it

From the `extern fn` declaration's type signature:

```forge
extern fn forge_http_add_route(
  server_id: int,
  method: string,
  path: string,
  handler: fn(string, string, string, string) -> string  // <-- function pointer param
)
```

The compiler sees `handler` is `fn(string, string, string, string) -> string`. When user code passes a Forge closure for this argument, the compiler:

1. Creates a new LLVM function with C calling convention (`extern "C"`)
2. The function signature matches the C ABI types: `i64 handler(char*, i64, char*, i64, char*, i64, char*, i64)` (each string is ptr + len)
3. The function body: unmarshal C types → Forge types, call the Forge closure, marshal return value back to C types
4. Passes the new function's pointer to the `extern fn` call

### Example

User writes:
```forge
forge_http_add_route(id, "GET", "/health", (method, path, body, params) -> {
  json.stringify({ status: "ok" })
})
```

Compiler generates:
```llvm
; Auto-generated C ABI trampoline
define i64 @__trampoline_0(i8* %method_ptr, i64 %method_len, i8* %path_ptr, i64 %path_len, i8* %body_ptr, i64 %body_len, i8* %params_ptr, i64 %params_len) {
  ; Wrap C strings into Forge strings
  %method = ; build ForgeString from ptr+len
  %path = ; build ForgeString from ptr+len
  %body = ; build ForgeString from ptr+len
  %params = ; build ForgeString from ptr+len
  ; Call the user's closure
  %result = call %ForgeString @user_closure(%method, %path, %body, %params)
  ; Return as C string (ptr)
  ret i8* %result.ptr
}
```

### Rules

- Only triggers for `extern fn` parameters with function types
- The trampoline handles all type marshaling (int↔i64, string↔ptr+len, bool↔i8)
- If the closure captures variables, the trampoline includes the environment pointer
- Multiple closures generate multiple trampolines (unique names: `__trampoline_0`, `__trampoline_1`, etc.)

### Test

```forge
// test_callback_trampoline.fg
extern fn call_me_back(cb: fn(int, int) -> int) -> int

fn main() {
  let result = call_me_back((a, b) -> a + b)
  println(string(result))
}
```

With a test native function:
```c
int64_t call_me_back(int64_t (*cb)(int64_t, int64_t)) {
    return cb(10, 20);
}
```

Expected output: `30`

---

## 2. Generic json.stringify / json.parse for Structs

### What it does

`json.stringify(value)` converts any struct to a JSON string at compile time using the struct's known field names and types. `json.parse<T>(str)` does the reverse.

### How it works

The compiler knows every struct's fields at compile time. For `json.stringify(my_struct)`, it generates code that:

1. Allocates a string buffer
2. Writes `{`
3. For each field in the struct (known at compile time):
   - Write `"field_name":`
   - Write the field value (recursively for nested structs):
     - int/float → number literal
     - string → quoted and escaped
     - bool → `true`/`false`
     - null → `null`
     - List → `[` + recursive + `]`
     - nested struct → recursive `{}`
4. Writes `}`

This is NOT runtime reflection. The compiler generates the specific serialization code for each struct type at compile time (like monomorphization).

### For json.parse<T>(str)

The compiler generates a parser function for type T that:

1. Walks the JSON string
2. Extracts values by known field names
3. Constructs the struct

For Phase 4, this can use the C runtime's JSON parser (`forge_json_parse_field(json_str, field_name) -> value`). Full compile-time parser generation is an optimization for later.

### What changes

- `json.stringify` becomes a built-in function that the compiler special-cases (like `println`)
- The compiler generates serialization code per struct type on first use
- `json.parse<T>` generates deserialization code per target type
- Remove `emit_struct_to_json` from providers.rs — it's now the generic `json.stringify`

### Test

```forge
// test_json_generic.fg

type Point = { x: float, y: float }
type User = { name: string, age: int, active: bool }
type Nested = { user: User, location: Point }

fn main() {
  let p = Point { x: 1.5, y: 2.5 }
  println(json.stringify(p))
  // {"x":1.5,"y":2.5}

  let u = User { name: "alice", age: 30, active: true }
  println(json.stringify(u))
  // {"name":"alice","age":30,"active":true}

  let n = Nested { user: u, location: p }
  println(json.stringify(n))
  // {"user":{"name":"alice","age":30,"active":true},"location":{"x":1.5,"y":2.5}}

  let parsed: Point = json.parse(`{"x":10.0,"y":20.0}`)
  println(string(parsed.x))
  // 10
}
```

---

## 3. Removing req.params.get() Special Case

The `req.params.get("id")` special case in collections.rs exists because `params` is a `Map<string, string>` coming from C as a JSON string, and the codegen hardcodes `forge_params_get`.

Fix: once `json.parse` works generically, the route handler parses params as a regular `Map<string, string>`:

```forge
let req = Request {
  method: m,
  path: p,
  body: b,
  params: json.parse(raw_params)   // generic json.parse<Map<string, string>>
}
```

Then `req.params.get("id")` is a normal Map method call. No special case.

---

## 4. What Gets Deleted After This

- `emit_http_route()` in providers.rs — replaced by generic trampoline
- `emit_struct_to_json()` in providers.rs — replaced by generic `json.stringify`
- `ServerBlock` / `ServerChild::Route` handling in mod.rs — server block becomes normal keyword expansion
- `req.params.get()` special case in collections.rs — becomes normal Map access
- `forge_params_get` gated declaration in runtime.rs — no longer needed

## 5. Definition of Done

1. `test_callback_trampoline.fg` passes — Forge closures work as C ABI function pointers
2. `test_json_generic.fg` passes — json.stringify/parse work on arbitrary structs
3. All existing HTTP tests pass using the generic systems (no HTTP-specific codegen)
4. `providers.rs` is deleted or reduced to zero provider-specific code
5. `grep -r "emit_http\|emit_struct_to_json\|ServerBlock\|ServerChild\|forge_params_get" compiler/src/ | grep -v test` returns zero results
