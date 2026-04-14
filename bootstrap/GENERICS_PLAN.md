# Generics Implementation Plan — Monomorphization

## Design Philosophy

This is a proper compiler. Generics use **monomorphization**: each unique
instantiation of a generic function or type produces a separate specialized
copy with concrete types substituted. This is the same approach as Rust,
and it's the right foundation for a compiler that will eventually have
real type representations (not just i64 for everything).

Today, monomorphized copies produce identical IR (everything is i64).
That's fine — the infrastructure is correct, and when real types arrive,
it works without redesign.

## Pipeline

```
Source → Parse → Resolve → Type Check → Monomorphize → Codegen
                                            ↑ NEW PASS
```

Monomorphization is a **post-type-check, pre-codegen AST transform**.
The type checker infers concrete type arguments at each call site.
The monomorphizer clones generic declarations with those concrete types
substituted, rewrites call sites, and removes the generic originals.
Codegen never sees generics — it only sees fully concrete code.

## Phase 1: Keep Type Params in the AST

### New types in `core/ast.fg`

```forge
export enum TypeParamList {
    End
    Node(name: string, bounds: string, next: TypeParamList)
}
```

### Modified Stmt variants

```forge
// Before:
Function(name: string, params: ParamList, ret_ty: string, body: StmtList)
TypeDecl(name: string, fields: FieldList)
EnumDecl(name: string, variants: VariantList)

// After:
Function(name: string, type_params: TypeParamList, params: ParamList, ret_ty: string, body: StmtList)
TypeDecl(name: string, type_params: TypeParamList, fields: FieldList)
EnumDecl(name: string, type_params: TypeParamList, variants: VariantList)
```

All ~30 construction/destructuring sites updated.

### Parser changes

`skip_angle_brackets()` → `parse_type_params() -> TypeParamList`.
Returns parsed type params instead of discarding them. The old
`skip_angle_brackets` is kept for type annotation positions where
we just need to skip past `<...>` in `consume_type()`.

## Phase 2: Resolver Scopes Type Param Names

When the resolver enters a generic declaration like `fn identity<T>(x: T)`,
it adds `T` to the current scope. This ensures:
- `T` in parameter types and return type resolves correctly
- `T` used inside the body doesn't trigger "undefined variable"
- Nested generics shadow correctly

Implementation: in `resolve/mod.fg`, when processing a Function/TypeDecl/
EnumDecl with non-empty type_params, push each type param name into scope.

## Phase 3: Type Checker — Infer Type Arguments

When the type checker encounters a call to a generic function:

```forge
fn identity<T>(x: T) -> T { x }
let n = identity(42)
```

1. Look up `identity` → sees type_params `[T]`
2. Match argument types against parameter types:
   - arg 0 is `int`, param 0 type is `T` → infer `T = int`
3. Substitute into return type: `T` → `int`
4. Record the instantiation: `identity<int>` at this call site

For explicit type args (`identity<int>(42)`), skip inference and use
the provided types directly.

### Type inference algorithm

Simple unification — walk parameter types and argument types in parallel:
- If param type is a type variable (matches a type_param name), bind it
- If param type is concrete, check it matches the argument type
- If param type is generic (e.g. `List<T>`), recurse into type args

This handles:
```forge
fn first<A, B>(p: Pair<A, B>) -> A { p.first }
// Call: first(Pair { first: 42, second: "hello" })
// Infers: A = int, B = string
```

### What we store

The type checker produces a map of call site → substitution.
Concretely, each call to a generic function is annotated (or rewritten)
with its resolved type arguments.

## Phase 4: Monomorphization Pass

New pass: `src/mono/mod.fg`

Input: type-checked AST with recorded instantiations.
Output: AST with no generics — all generic declarations replaced by
concrete specializations, all call sites rewritten.

### Algorithm

1. **Collect**: scan AST for all instantiation sites. Build a set of
   unique instantiations: `{(identity, [int]), (identity, [string]),
   (Pair, [int, string]), ...}`

2. **Generate**: for each unique instantiation:
   - Clone the generic declaration's AST
   - Substitute type params → concrete types in all type annotations
   - Mangle the name: `identity` + `<int>` → `identity__int`
   - For types: `Pair` + `<int, string>` → `Pair__int_string`

3. **Rewrite**: replace all call sites:
   - `identity(42)` → `identity__int(42)`
   - `Pair { first: 10, second: "hi" }` → `Pair__int_string { ... }`
   - `Option.Some(99)` → `Option__int.Some(99)`

4. **Remove**: drop the original generic declarations from the AST.

### Name mangling

```
fn identity<T>     + T=int        → identity__int
fn identity<T>     + T=string     → identity__string
type Pair<A, B>    + A=int, B=int → Pair__int__int
enum Option<T>     + T=string     → Option__string
```

Mangled names use `__` separator (already used for impl methods).

### Handling generic types and enums

When we monomorphize `enum Option<T>` with `T=int`:
```forge
// Original:
enum Option<T> { None, Some(value: T) }

// Generated:
enum Option__int { None, Some(value: int) }
```

The struct/enum registries, field type lookups, and variant lookups
all work on the mangled name. No special handling needed — they're
just regular types with funny names.

### Recursive/self-referential generics

```forge
enum List<T> {
    End
    Node(value: T, next: List<T>)
}
```

Monomorphized with T=int:
```forge
enum List__int {
    End
    Node(value: int, next: List__int)
}
```

The monomorphizer must recognize `List<T>` in the field type and
substitute it to `List__int`. This is a recursive substitution
but terminates because we only substitute type params, not
arbitrary types.

## Phase 5: Codegen — Nothing Changes

Codegen sees only concrete, non-generic code. No changes needed.

## Phase 6: Unify Linked Lists (Future)

Once generics work:
```forge
enum List<T> { End, Node(value: T, next: List<T>) }
type ExprList = List<SExpr>
type StmtList = List<SStmt>
```

Each type alias triggers monomorphization: `List__SExpr`, `List__SStmt`.
The 13 hand-written linked list enums become one generic + type aliases.

## Implementation Order

1. Add TypeParamList to ast.fg, update Function/TypeDecl/EnumDecl
2. Change parser: skip_angle_brackets → parse_type_params
3. Update all ~30 destructuring sites (mechanical)
4. Resolver: scope type param names
5. Type checker: infer type args at generic call sites
6. Monomorphization pass: clone, substitute, rewrite, remove
7. Test: existing generics example still passes
8. Test: multi-instantiation (same generic with different types)
9. Test: generic types and enums
10. Test: nested/recursive generics

## Risks

- Adding fields to Function/TypeDecl/EnumDecl is safe (hash-based tags,
  heap payloads) but requires updating ~30 pattern match sites.
- The type checker is currently loose. Generic type inference must be
  ADDITIVE — report more info, don't block compilation. Existing code
  that doesn't use generics must not be affected.
- Monomorphization increases code size (one copy per instantiation).
  For the compiler itself this is negligible.

## What NOT To Do

- No type erasure. Build it right for the future.
- No trait bounds CHECKING (yet). Parse and store them, don't enforce.
- Don't try to unify the 13 linked lists in the SAME session as adding
  generics. Get generics working first.
