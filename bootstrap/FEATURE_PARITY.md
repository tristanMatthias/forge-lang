# Feature Parity: Bootstrap vs Rust Compiler

Inventory of what the Rust host compiler supports vs what the
bootstrap currently handles. Organized by priority tier.

## What Bootstrap HAS (self-host subset)

### Declarations
- [x] `fn` declarations with params + return type
- [x] `extern fn` (C FFI)
- [x] `let` / `mut` variable bindings with optional type annotation
- [x] `type Foo = { fields }` (struct declaration)
- [x] `enum Foo { Variant(fields) }` (tagged union)
- [x] `impl Type { fn method(self) }` (methods, desugared to Type__method)
- [x] `mod foo` (module system, supports nested dirs)
- [x] `use module.{names}` (import — host resolves, bootstrap text-inlines)
- [x] `export` (visibility marker — host-only semantics)

### Statements
- [x] `if` / `else` (statement + expression form)
- [x] `while` (with break/continue via scoped loop stack)
- [x] `match` on enums (statement + expression, with pattern bindings)
- [x] `return` / `return expr`
- [x] `break` / `continue`
- [x] Block expressions `{ stmts; last_expr }`

### Expressions
- [x] Arithmetic: `+`, `-`, `*`, `/`
- [x] Comparison: `==`, `!=`, `<`, `<=`, `>`, `>=`
- [x] Logical: `&&`, `||` (eager, not short-circuit)
- [x] Unary: `-`, `!`
- [x] String concat via `+`
- [x] String indexing `s[i]`
- [x] String `.length` / `.substring(start, end)`
- [x] Field access `obj.field`
- [x] Field assign `obj.field = val`
- [x] Struct literals `Foo { x: 1, y }` (with shorthand)
- [x] Enum constructors `Foo.Variant(args)`
- [x] Function calls `f(args)`
- [x] Method calls `obj.method(args)`
- [x] Nullable `?` (erased — everything is i64)
- [x] Force-unwrap `expr!` (no-op in bootstrap)
- [x] `null` literal
- [x] `int()`, `string()`, `println()`, `eprintln()` builtins

---

## TIER 1 — Needed to compile real Forge programs
Priority: do first. These are the features that real user programs use daily.

### for loops *(Rust: features/for_loops)*
```forge
for item in list { ... }
for i in 0..10 { ... }
```
Needs: `for` keyword, range expressions, iterator protocol.
The bootstrap currently uses `while` for everything. `for` is
the most common loop form in user code.
**Estimate: medium (parser + codegen, needs range type)**

### closures / lambdas *(Rust: features/closures)*
```forge
let add = fn(a, b) { a + b }
list.map(fn(x) { x * 2 })
```
Needs: lambda expressions, capture semantics, function-typed values.
Critical for any functional-style code and most standard library patterns.
**Estimate: large (capture analysis, heap-allocated closures)**

### generics *(Rust: features/generics)*
```forge
fn identity<T>(x: T) -> T { x }
type Box<T> = { value: T }
```
Needs: type parameters, monomorphization or type erasure.
Required for any generic collection (List<T>, Map<K,V>).
**Estimate: large (type system extension)**

### collections *(Rust: features/collections)*
```forge
let list = [1, 2, 3]
let map = { "a": 1, "b": 2 }
list.push(4)
map.get("a")
```
Needs: List<T>, Map<K,V> with runtime support.
Currently bootstrap uses recursive enums (linked lists) instead.
**Estimate: large (needs generics OR monomorphized builtins)**

### string templates *(Rust: features/string_templates)*
```forge
let msg = "hello {name}, you are {age} years old"
```
Needs: template literal parsing + codegen.
Used everywhere in user code.
**Estimate: small-medium (parser + concat codegen)**

### null safety *(Rust: features/null_safety)*
```forge
let x: int? = null
if x != null { use(x!) }
```
Bootstrap currently erases nullability (everything is i64, null = 0).
Real null safety needs: nullable type tracking, null checks at
access sites, `?` propagation.
**Estimate: large (type system change)**

---

## TIER 2 — Needed for a useful compiler
Priority: after Tier 1. These make the compiler practical but aren't blocking.

### traits *(Rust: features/traits)*
```forge
trait Display { fn display(self) -> string }
impl Display for Foo { ... }
```
Needs: trait declarations, impl-for-trait, virtual dispatch.
**Estimate: large**

### error propagation *(Rust: features/error_propagation)*
```forge
fn read() -> Result<string> {
    let f = open("file")?
    f.read()?
}
```
Needs: `?` operator, Result type, automatic error wrapping.
**Estimate: medium**

### pipe operator *(Rust: features/pipe_operator)*
```forge
data |> transform |> render
```
Needs: parser + desugar to nested calls.
**Estimate: small**

### ranges *(Rust: features/ranges)*
```forge
0..10
0..=10
```
Needs: range literals, iterator integration.
**Estimate: small-medium (pairs with for loops)**

### tuples *(Rust: features/tuples)*
```forge
let (a, b) = get_pair()
```
Needs: tuple types, destructuring.
**Estimate: medium**

### file I/O *(Rust: features/file_io)*
```forge
let content = read_file("path")
write_file("path", content)
```
Bootstrap already has `forge_selfhost_read_file` etc. as C
externs. This is about making them proper language-level features.
**Estimate: small (already works via extern, needs proper API)**

### imports (proper) *(Rust: features/imports)*
Currently bootstrap text-inlines all modules. Real imports need:
separate compilation, symbol visibility, cross-module type checking.
**Estimate: large**

---

## TIER 3 — Nice to have / domain-specific
Priority: after the compiler is useful for general programs.

- `is` keyword (type checking at runtime)
- `with` expressions (functional record update)
- `defer` (cleanup on scope exit)
- `spawn` / `parallel` (concurrency)
- `channels` (message passing)
- `select` syntax (channel multiplexing)
- tagged templates
- shell shorthand (`$"command"`)
- `it` parameter (implicit lambda parameter)
- JSON builtins
- table literals
- query helpers
- component system (component_syntax, component_events, component_config)
- pattern matching (advanced — guards, nested patterns)
- spec tests
- field mutability tracking
- type conversion operators
- validation

---

## Recommended execution order

```
Phase A (self-host++)    for loops → string templates → ranges → pipe operator
Phase B (type system)    null safety → generics → traits
Phase C (collections)    collections (List/Map) → error propagation → tuples
Phase D (real programs)  closures → file I/O → proper imports
```

Phase A makes the language pleasant to write in. Phase B makes the
type system real. Phase C enables data structures. Phase D enables
real-world programs.

Each feature follows the established pattern:
1. Create `features/<name>/` with WHY.md, grammar.md
2. Add parser.fg (impl Parser block)
3. Add codegen.fg (imports from core/cg.fg)
4. Add example.fg + expected.out
5. `make test` + commit
