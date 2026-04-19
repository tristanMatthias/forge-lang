# Union Types

## Syntax

```
// Type annotation
let x: int | string = 42
fn foo(val: int | string | bool) -> string { ... }

// Pattern matching
match val {
    int(n) -> string(n)
    string(s) -> s
    bool(b) -> string(b)
    _ -> "unknown"
}
```

## Semantics

Union types represent a value that can be one of several types. The compiler
wraps values into a discriminated layout `{i64 tag, ptr payload}` at assignment
and call sites. Tags are djb2 hashes of the type name.

Pattern matching uses `TypeName(binding)` syntax (without dot prefix) to
discriminate and extract the wrapped value. Wildcard `_` matches all remaining types.

## Runtime Layout

Same as enums: `{i64 tag, ptr payload}` (16 bytes). The `__union` LLVM struct
type is shared across all union types.
