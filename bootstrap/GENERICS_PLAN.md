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

1. [x] Add TypeParamList to ast.fg, update Function/TypeDecl/EnumDecl
2. [x] Change parser: skip_angle_brackets → parse_type_params (in features/generics/parser.fg)
3. [x] Update all ~40 destructuring sites (mechanical)
4. [x] Resolver: scope type param names
5. [x] Type checker: infer type args at generic call sites (TypeBindings, FnTypeEntry extended)
6. [x] Monomorphization pass: clone, substitute, rewrite, remove (features/generics/mono.fg)
7. [x] Test: existing generics example still passes (42, 30, 99)
8. [x] Test: multi-instantiation (same generic with different types)
9. [x] Test: generic types and enums (Wrapper<T>, Option<T>)
10. [ ] Test: nested/recursive generics (List<T> — needs generic enum monomorphization)

## Remaining Work

These are real problems — not style nits. Each must be fixed before
generics can be considered production-quality.

### ~~1. `infer_expr_type` only handles literals~~ DONE
**status:** fixed (April 14, 2026)

Added `ty: ValueType` field to `SExpr` (core/ast.fg). Typeck populates it
via a Pass 3 annotation walk (`annotate_stmts/annotate_expr/annotate_sexpr`
in typeck/mod.fg). `TypeCheckResult` now returns the annotated `StmtList`.
Mono pass reads `arg.ty` from SExpr instead of re-inferring. Deleted all
inference logic (TypeEnv, FnRetReg, infer_expr_type, normalize_type_str).
The typeck is the single source of truth for expression types.

### ~~2. No explicit type arguments at call sites~~ DONE
**status:** fixed (April 14, 2026)

Added `Expr.GenericCall(callee, type_args, args)` variant and `TypeNameList`
type. Parser uses speculative parsing with backtracking (`save_state`/
`restore_state` on `Parser`) in `parse_comparison` to disambiguate
`f<int>(x)` (generic call) from `f < int` (comparison). Backtracking is
general-purpose infrastructure in `parse/mod.fg`, not generics-specific.
Mono pass reads explicit type args via `explicit_to_type_args` and
uses them directly instead of inferring.

### 3. `Option.None` can't be used standalone
**priority:** high
**file:** `features/generics/mono.fg`

Bare variant access `Option.None` has no args to infer from → F0400 error.
Rust solves this with return-type-directed inference: `fn foo() -> Option<int>`
tells the compiler that `None` in this function is `Option__int.None`.

**Fix:** When a function has a return type that names a generic enum/struct,
resolve the type args from that annotation and apply them to all unresolved
uses of that generic within the function body. This requires:
1. Parse the return type string for generic args (e.g. `"Result<int, string>"`)
2. Or: after collecting all ctor sites in a function, check the return type
   annotation and use it to fill remaining unresolved params.

### 4. Enum merging is global, not scoped
**priority:** high
**file:** `features/generics/mono.fg`

All `Result.Ok(...)` and `Result.Err(...)` across the entire program merge
into one `Result__T__E`. If `fn a()` uses `Result<int, string>` and `fn b()`
uses `Result<float, int>`, the merge produces a single wrong instantiation.

**Fix:** Scope merging to the enclosing function. Each function body's
constructor calls merge independently. Two functions using Result with
different types produce two separate instantiations.

### 5. `rewrite_type_name` / `inst_mangled` returns first match
**priority:** high
**file:** `features/generics/mono.fg`

`inst_mangled(insts, "Wrapper")` returns the first InstList entry named
"Wrapper". If both `Wrapper__int` and `Wrapper__string` exist, `fn foo() -> Wrapper`
gets the wrong one.

**Fix:** This is the same problem as #4 — once merging is scoped, each
function's return type annotation maps to a specific instantiation. The
rewrite pass should re-infer at each site (as it already does for
`rewrite_struct_lit`) rather than looking up by bare name.

### 6. F0400 diagnostics have no source location
**priority:** medium
**file:** `features/generics/mono.fg`

`check_resolved` passes `line: 0, col: 0`. The error renders without a
source snippet — just the message and help text.

**Fix:** Thread SExpr line/col from the call site expression through the
collection pass into `check_resolved`. The `CollectState` or the
`try_add_*` helpers need the line/col from the expression being processed.

### 7. Old seed resolver workarounds
**priority:** low
**file:** `features/generics/mono.fg`

Functions like `try_add_fn_inst`, `try_add_enum_inst`, `try_add_struct_inst`
exist because the old seed's resolver crashes on `let x = f(...)` inside
nested match arms. Once the seed is updated past this bug, these can be
inlined back into `collect_inst_expr`.

**Fix:** After the next seed update, try inlining. If the new seed handles
it, remove the helpers. If not, keep them — they're not harmful, just verbose.

### 8. `substitute_*` and `rewrite_*` are 90% duplicated
**priority:** low
**file:** `features/generics/mono.fg`

`substitute_stmt`/`substitute_expr` and `rewrite_stmt`/`rewrite_expr` walk
every AST variant with identical structure, differing only in leaf operations.
~200 lines of pure duplication.

**Fix:** Requires higher-order functions or a visitor pattern. The bootstrap
doesn't support passing functions as generic transformers yet. Once closures
work reliably as feature handlers, extract a generic `map_stmt(stmt, expr_fn)`
that both passes use. Until then, this is accepted duplication.

### 9. ParamList type strings not rewritten
**priority:** medium
**file:** `features/generics/mono.fg`

`fn foo(x: Wrapper)` — the param type string `"Wrapper"` is not rewritten to
`"Wrapper__int"` by the mono pass. Only `ret_ty` and `Let`/`Mut` type strings
are rewritten via `rewrite_type_name`.

**Fix:** Add `rewrite_type_name` calls to ParamList nodes in `rewrite_stmt`'s
`.Function` arm and anywhere params are threaded through. Also rewrite
`ExternFn` param types.

### 10. Nested/recursive generics not tested
**priority:** medium

`enum List<T> { End, Node(value: T, next: List<T>) }` — the `next` field
type is `"List<T>"` which contains a generic reference. The mono pass's
`substitute_fields` would turn `"List<T>"` into... `"List<T>"` (unchanged,
since `type_arg_lookup` looks for exact match on `"List<T>"` which isn't
a type param name).

**Fix:** `substitute_fields` (and `type_arg_lookup`) need to handle compound
type strings like `"List<T>"` — parse the `<...>` suffix, substitute type
params inside it, and reconstruct: `"List<T>"` + `T=int` → `"List__int"`.
This also requires the mono pass to transitively monomorphize referenced
generic types.
