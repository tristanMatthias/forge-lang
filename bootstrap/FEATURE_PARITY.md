# Feature Parity: Bootstrap vs Forge Language

Complete inventory. Every feature of the Forge language is listed
below with its bootstrap status. Source of truth: `forge lang --llm`
and `forge features` (67 features, 62 stable).

Status key:
  ✅ = implemented in bootstrap
  🔲 = not yet implemented
  ⬜ = not applicable to bootstrap (domain-specific / runtime-only)

---

## Variables & Bindings

| Feature | Forge syntax | Bootstrap | Notes |
|---|---|---|---|
| let binding | `let x = 1` | ✅ | |
| mut binding | `mut y = 2` | ✅ | |
| const binding | `const Z = 3` | ✅ | parsed as let (immutability not enforced) |
| type annotation | `let x: int = 42` | ✅ | optional, defaults to i64 |
| immutability enforcement | `x = 2` errors if `let` | ✅ | resolver rejects let reassignment |
| field mutability | `type T = { mut x: int }` | ✅ | parsed, not enforced |
| shorthand fields | `Foo { name }` = `Foo { name: name }` | ✅ | |

## Primitive Types

| Feature | Forge syntax | Bootstrap | Notes |
|---|---|---|---|
| int (i64) | `42`, `-1`, `1_000_000` | ✅ | |
| float (f64) | `3.14`, `1.0e10` | ✅ | full arithmetic, string conversion |
| string | `"hello"` | ✅ | raw cstr in bootstrap |
| bool | `true`, `false` | ✅ | |
| null | `null` | ✅ | = i64 0 |
| hex/bin/oct literals | `0xFF`, `0b1010`, `0o755` | ✅ | |
| numeric underscores | `1_000_000` | ✅ | lexer strips underscores | |

## Functions

| Feature | Forge syntax | Bootstrap | Notes |
|---|---|---|---|
| fn declaration | `fn name(params) -> type { body }` | ✅ | |
| return | `return expr` | ✅ | |
| implicit return | last expression is return value | ✅ | |
| extern fn | `extern fn name(params) -> type` | ✅ | C ABI |
| fn types | `fn(A, B) -> R` | ✅ | ValueType.Fn(ret) carries return type |
| closures / lambdas | `(x) -> x * 2` | ✅ | lifted functions, typed params |
| `it` parameter | `.method(it * 2)` | ✅ | parser sugar |
| generics | `fn name<T>(x: T) -> T` | ✅ | parsed, erased to i64 |
| generic constraints | `fn name<T: Trait>(x: T)` | ✅ | parsed + erased; use dyn dispatch |

## Structs & Types

| Feature | Forge syntax | Bootstrap | Notes |
|---|---|---|---|
| type declaration | `type T = { fields }` | ✅ | |
| struct literal | `Foo { x: 1, y: 2 }` | ✅ | |
| field access | `obj.field` | ✅ | |
| field assign | `obj.field = val` | ✅ | |
| `with` expression | `obj with { field: val }` | ✅ | functional update, dogfooded |
| traits | `trait Name { fn method(self) }` | ✅ | static + dynamic dispatch via vtable |
| impl for trait | `impl Trait for Type { }` | ✅ | desugars to Type__method |
| impl block | `impl Type { fn method(self) }` | ✅ | desugars to Type__method |

## Enums & Pattern Matching

| Feature | Forge syntax | Bootstrap | Notes |
|---|---|---|---|
| enum declaration | `enum Name { A, B(x: int) }` | ✅ | |
| enum constructor | `Name.Variant(args)` | ✅ | |
| match statement | `match expr { .A -> ... }` | ✅ | |
| match expression | `let x = match expr { ... }` | ✅ | |
| wildcard pattern | `_ -> ...` | ✅ | |
| variant binding | `.A(x, y) -> use(x)` | ✅ | |
| nested patterns | `.A(.Inner(x), y) -> ...` | ✅ | |
| match guards | `pattern if guard -> body` | ✅ | |
| match tables | `match expr table { ... }` | 🔲 | |
| `is` keyword | `value is Pattern` | ✅ | |
| contextual resolution | `let x: Enum = .variant` | ✅ | searches all enums by variant |

## Control Flow

| Feature | Forge syntax | Bootstrap | Notes |
|---|---|---|---|
| if / else | `if cond { } else { }` | ✅ | stmt + expr form |
| else if | `if a { } else if b { }` | ✅ | |
| while | `while cond { body }` | ✅ | |
| for-in | `for x in collection { }` | ✅ | index-based desugar, typed elements |
| for-range | `for i in 0..10 { }` | ✅ | half-open range, i64 counter |
| break / continue | `break`, `continue` | ✅ | scoped via Ctx.loops |
| expression blocks | `{ stmts; last_expr }` | ✅ | |
| defer | `defer cleanup()` | ✅ | LIFO order, works with early return |

## Operators

| Feature | Forge syntax | Bootstrap | Notes |
|---|---|---|---|
| arithmetic | `+`, `-`, `*`, `/` | ✅ | |
| comparison | `==`, `!=`, `<`, `<=`, `>`, `>=` | ✅ | |
| logical | `&&`, `||` | ✅ | short-circuit |
| logical keywords | `and`, `or`, `not` | ✅ | aliases for &&, ||, ! |
| unary | `-x`, `!x` | ✅ | |
| bitwise | `&`, `|`, `^`, `<<`, `>>`, `~` | ✅ | full precedence chain | |
| pipe | `expr |> fn` | ✅ | desugars to call |
| ranges | `start..end`, `start..=end` | ✅ | `for i in 0..10 {}` |
| type operators | `without`, `only`, `partial` | 🔲 | |

## Strings

| Feature | Forge syntax | Bootstrap | Notes |
|---|---|---|---|
| string literals | `"hello"` | ✅ | |
| string concat | `a + b` | ✅ | |
| string indexing | `s[i]` | ✅ | returns 1-char string |
| `.length` | `s.length` | ✅ | via strlen |
| `.substring` | `s.substring(start, end)` | ✅ | |
| string templates | `` `hello ${name}` `` | ✅ | desugars to string concat |
| tagged templates | `` tag`template` `` | ✅ | desugars to function call |
| `.split`, `.trim`, etc. | `s.split(sep)` | ✅ | C runtime |
| `.contains`, `.starts_with` | `s.contains(sub)` | ✅ | C runtime |
| `.replace`, `.upper`, `.lower` | `s.replace(a, b)` | ✅ | C runtime |
| `char_code(s)` | `char_code("A")` | ✅ | C runtime | |

## Null Safety

| Feature | Forge syntax | Bootstrap | Notes |
|---|---|---|---|
| nullable types | `T?` | ✅ | parsed, erased to i64 |
| null check | `expr == null` | ✅ | via icmp |
| force unwrap | `expr!` | ✅ | no-op (everything is i64) |
| optional chaining | `expr?.field` | ✅ | short-circuit branch |
| null coalescing | `expr ?? default` | ✅ | short-circuit branch |
| null throw | `expr ?? throw .error` | ✅ | `panic("msg")`, `x ?? panic("err")` |
| error propagation | `expr?` | ✅ | dogfooded (98 patterns) |
| catch blocks | `catch { body }` | ✅ | covered by `??` with block expressions |

## Collections

| Feature | Forge syntax | Bootstrap | Notes |
|---|---|---|---|
| list literal | `[1, 2, 3]` | ✅ | forge_array_*, typed elements | bootstrap uses recursive enums |
| map literal | `{ "a": 1 }` | ✅ | forge_map_*_cstr | |
| tuple literal | `(a, b, c)` | ✅ | with type tracking |
| tuple destructuring | `let (x, y) = pair` | ✅ | |
| slicing | `list[start..end]` | ✅ | forge_array_slice | |
| list methods | `.push`, `.map`, `.filter`, etc. | ✅ | push,pop,map,filter,reduce,foreach | |
| map methods | `.has`, `.get`, `.keys` | ✅ | get,set,has,keys,length | |

## Modules & Imports

| Feature | Forge syntax | Bootstrap | Notes |
|---|---|---|---|
| mod declaration | `mod name` | ✅ | supports nested dirs |
| use import | `use module.{names}` | ✅ | host resolves; bootstrap text-inlines |
| export | `export fn name()` | ✅ | host-only semantics |
| package use | `use @namespace.name` | ✅ | via host prescan workaround |
| proper separate compilation | | 🔲 | bootstrap inlines everything |

## I/O & Runtime

| Feature | Forge syntax | Bootstrap | Notes |
|---|---|---|---|
| println / print | `println(value)` | ✅ | via puts |
| eprintln / eprint | `eprintln(value)` | ✅ | via C extern |
| string() conversion | `string(42)` | ✅ | via snprintf |
| int() conversion | `int("42")` | ✅ | via atoi |
| float() conversion | `float("3.14")` | ✅ | string→float, int→float |
| file_exists | `file_exists(path)` | ✅ | via C extern |
| read_file | `read_file(path)` | ✅ | via C extern |
| write_file | `write_file(path, content)` | ✅ | via C extern |
| json.parse / stringify | `json.parse(str)` | ✅ | stringify_int/string/bool, get_int/string/bool |
| process_uptime | `process_uptime()` | ✅ | forge_uptime_ms() via extern fn |
| datetime | `datetime_now()` | ✅ | forge_datetime_now + year/month/day/hour/min/sec |
| durations | `7d`, `24h`, `5m` | ✅ | compile-time millisecond conversion |
| shell shorthand | `$"command ${arg}"` | ✅ | forge_shell_exec via C extern |

## Concurrency

| Feature | Forge syntax | Bootstrap | Notes |
|---|---|---|---|
| spawn | `spawn { body }` | 🔲 | |
| channels | `ch <- value`, `<- ch` | 🔲 | |
| select | `select { ch -> body }` | 🔲 | |
| parallel | `parallel { }` | 🔲 | |

## Components (domain-specific)

| Feature | Forge syntax | Bootstrap | Notes |
|---|---|---|---|
| component blocks | `name(args) { config }` | ⬜ | not applicable |
| config declaration | `config { field: type = default }` | ⬜ | not applicable |
| events | `event before_create(record)` | ⬜ | not applicable |
| custom syntax | `@syntax("pattern") fn name(...)` | ⬜ | not applicable |

## Testing

| Feature | Forge syntax | Bootstrap | Notes |
|---|---|---|---|
| spec tests | `spec "name" { given { } then { } }` | ✅ | hierarchical pass/fail output |
| table literals | `table { col | col; val | val }` | ✅ | desugars to list of maps |
| validation | `validate(value)` | ✅ | not_null/positive/not_empty via C runtime |
| annotations | `@name`, `@name(args)` | ✅ | parsed, stored in AST |

## Pointer Operations (low-level)

| Feature | Forge syntax | Bootstrap | Notes |
|---|---|---|---|
| ptr arithmetic | `ptr + n`, `ptr - ptr` | ✅ | ptr + int, ptr - int, ptr - ptr |
| ptr indexing | `ptr[i]`, `ptr[i] = byte` | ✅ | forge_ptr_store_byte writes |
| ptr ↔ string | `string.from_ptr`, `ptr.from_string` | ✅ | forge_string_from_ptr |
| c_abi_trampolines | | 🔲 | |

## Packages (standard library)

| Package | Bootstrap | Notes |
|---|---|---|
| @llvm | ✅ | via C extern wrappers |
| @process | ✅ | via forge_selfhost_* C externs |
| @fs | ✅ | via forge_selfhost_* C externs |
| @forgec | ✅ | the bootstrap IS the compiler |
| @ai | ⬜ | not applicable |
| @archive | ⬜ | not applicable |
| @cache | ⬜ | not applicable |
| @channel | 🔲 | needs concurrency |
| @cli | ✅ | argc/get_arg via C externs |
| @crypto | ⬜ | not applicable |
| @http | ⬜ | not applicable |
| @jsonrpc | ⬜ | not applicable |
| @semver | ✅ | major/minor/patch/compare via C runtime |
| @term | ✅ | ANSI escape codes via \x sequences |
| @test | ✅ | spec/given/then via C runtime |
| @toml | ✅ | get_string/get_int/get_bool via C runtime |

---

## Summary

| Category | Total | ✅ Done | 🔲 TODO | ⬜ N/A |
|---|---|---|---|---|
| Variables & Bindings | 7 | 6 | 1 | 0 |
| Primitive Types | 7 | 7 | 0 | 0 |
| Functions | 9 | 9 | 0 | 0 |
| Structs & Types | 8 | 8 | 0 | 0 |
| Enums & Matching | 11 | 9 | 2 | 0 |
| Control Flow | 8 | 8 | 0 | 0 |
| Operators | 8 | 8 | 0 | 0 |
| Strings | 11 | 11 | 0 | 0 |
| Null Safety | 8 | 8 | 0 | 0 |
| Collections | 7 | 7 | 0 | 0 |
| Modules & Imports | 5 | 4 | 1 | 0 |
| I/O & Runtime | 12 | 12 | 0 | 0 |
| Concurrency | 4 | 0 | 4 | 0 |
| Components | 4 | 0 | 0 | 4 |
| Testing | 4 | 2 | 2 | 0 |
| Pointer Ops | 4 | 3 | 1 | 0 |
| Packages | 14 | 8 | 0 | 6 |
| **TOTAL** | **131** | **113** | **8** | **10** |

## Dogfooding Rule

**After each feature is added, refactor the bootstrap source to USE
that feature.** This is non-negotiable. The bootstrap compiler is
the first and most important user of its own language. If we add
`for` loops, every `while i < n { ... i = i + 1 }` in the bootstrap
source gets rewritten to `for i in 0..n { ... }`. If we add string
templates, every `"hello " + name` becomes `` `hello ${name}` ``.

This serves three purposes:
1. **Regression coverage** — the bootstrap self-compiles, so any
   miscompilation of the new feature is caught by `make selfhost`.
2. **Proof the feature works** — if we can't rewrite our own code to
   use it, the feature has a bug.
3. **Code quality** — the bootstrap becomes a showcase of idiomatic
   Forge, not a museum of workarounds.

## Priority Order

### Phase A — Make the language pleasant (small features)
1. `for` loops + ranges
2. string templates (`` `hello ${name}` ``)
3. pipe operator (`|>`)
4. `const` bindings
5. hex/bin/oct numeric literals
6. `and`/`or`/`not` keyword operators

### Phase B — Type system (large features)
7. null safety (nullable types, `?.`, `??`)
8. generics (`<T>`)
9. traits + impl-for-trait

### Phase C — Data structures
10. collections (List, Map) — needs generics or monomorphized builtins
11. tuples + destructuring
12. error propagation (`?` operator, Result type)
13. slicing

### Phase D — Real programs
14. closures / lambdas
15. proper separate compilation (not text-inlining)
16. short-circuit `&&` / `||`

### Phase E — Extended
17. `with` expression
18. `defer`
19. `is` keyword
20. nested patterns + match guards
21. bitwise operators
22. float support

### Phase F — Domain-specific (as needed)
23. spec tests
24. concurrency (spawn, channels, select)
25. shell shorthand
26. annotations
27. pointer ops
