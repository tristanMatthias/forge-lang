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

### New types in `core/ast.av`

```avra
export enum TypeParamList {
    End
    Node(name: string, bounds: string, next: TypeParamList)
}
```

### Modified Stmt variants

```avra
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

Implementation: in `resolve/mod.av`, when processing a Function/TypeDecl/
EnumDecl with non-empty type_params, push each type param name into scope.

## Phase 3: Type Checker — Infer Type Arguments

When the type checker encounters a call to a generic function:

```avra
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
```avra
fn first<A, B>(p: Pair<A, B>) -> A { p.first }
// Call: first(Pair { first: 42, second: "hello" })
// Infers: A = int, B = string
```

### What we store

The type checker produces a map of call site → substitution.
Concretely, each call to a generic function is annotated (or rewritten)
with its resolved type arguments.

## Phase 4: Monomorphization Pass

New pass: `src/mono/mod.av`

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
```avra
// Original:
enum Option<T> { None, Some(value: T) }

// Generated:
enum Option__int { None, Some(value: int) }
```

The struct/enum registries, field type lookups, and variant lookups
all work on the mangled name. No special handling needed — they're
just regular types with funny names.

### Recursive/self-referential generics

```avra
enum List<T> {
    End
    Node(value: T, next: List<T>)
}
```

Monomorphized with T=int:
```avra
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
```avra
enum List<T> { End, Node(value: T, next: List<T>) }
type ExprList = List<SExpr>
type StmtList = List<SStmt>
```

Each type alias triggers monomorphization: `List__SExpr`, `List__SStmt`.
The 13 hand-written linked list enums become one generic + type aliases.

## Implementation Order

1. [x] Add TypeParamList to ast.av, update Function/TypeDecl/EnumDecl
2. [x] Change parser: skip_angle_brackets → parse_type_params (in features/generics/parser.av)
3. [x] Update all ~40 destructuring sites (mechanical)
4. [x] Resolver: scope type param names
5. [x] Type checker: infer type args at generic call sites (TypeBindings, FnTypeEntry extended)
6. [x] Monomorphization pass: clone, substitute, rewrite, remove (features/generics/mono.av)
7. [x] Test: existing generics example still passes (42, 30, 99)
8. [x] Test: multi-instantiation (same generic with different types)
9. [x] Test: generic types and enums (Wrapper<T>, Option<T>)
10. [ ] Test: nested/recursive generics (List<T> — needs generic enum monomorphization)

## Remaining Work

These are real problems — not style nits. Each must be fixed before
generics can be considered production-quality.

### ~~1. `infer_expr_type` only handles literals~~ DONE
**status:** fixed (April 14, 2026)

Added `ty: ValueType` field to `SExpr` (core/ast.av). Typeck populates it
via a Pass 3 annotation walk (`annotate_stmts/annotate_expr/annotate_sexpr`
in typeck/mod.av). `TypeCheckResult` now returns the annotated `StmtList`.
Mono pass reads `arg.ty` from SExpr instead of re-inferring. Deleted all
inference logic (TypeEnv, FnRetReg, infer_expr_type, normalize_type_str).
The typeck is the single source of truth for expression types.

### ~~2. No explicit type arguments at call sites~~ DONE
**status:** fixed (April 14, 2026)

Added `Expr.GenericCall(callee, type_args, args)` variant and `TypeNameList`
type. Parser uses speculative parsing with backtracking (`save_state`/
`restore_state` on `Parser`) in `parse_comparison` to disambiguate
`f<int>(x)` (generic call) from `f < int` (comparison). Backtracking is
general-purpose infrastructure in `parse/mod.av`, not generics-specific.
Mono pass reads explicit type args via `explicit_to_type_args` and
uses them directly instead of inferring.

### ~~3. `Option.None` can't be used standalone~~ MOSTLY DONE
**status:** fixed via merging (April 14, 2026)

Bare variant access `Option.None` works when another ctor site in the program
provides type args (e.g. `Option.Some(42)` infers T=int, merged into the
same instantiation that `Option.None` uses). Standalone `Option.None` with
no other ctor site correctly emits F0400 error.

Return-type-directed inference (inferring from `fn foo() -> Option<int>`) is
NOT implemented — the return type annotation is a bare string `"Option"` with
no generic args. This would require parsing `Option<int>` in type annotation
positions, which is blocked on #2 (consume_type handling for generic args).
For now, users must have at least one ctor with args, or use explicit type
args at the ctor site.

### ~~4. Enum merging is global, not scoped~~ DONE
**status:** fixed (April 14, 2026)

Collection pass now scopes enum merging to function bodies. When entering
a `Stmt.Function`, instantiations are collected into a fresh `InstList`,
then appended (deduplicated) to the parent. Compatibility check
(`type_args_compatible`) prevents conflicting bindings from merging —
incompatible entries create separate instantiations.

### ~~5. `rewrite_type_name` / `inst_mangled` returns first match~~ DONE
**status:** fixed (April 14, 2026)

`rewrite_enum_ctor` now uses `inst_mangled_compatible` which finds the
entry whose type args are compatible with the site's partial inference,
not just the first entry with the same name. `mangle_enum_at_site`
computes the partial inference at each ctor site and matches against
the compatible instantiation.

### 6. F0400 diagnostics have no source location
**priority:** medium
**file:** `features/generics/mono.av`

`check_resolved` passes `line: 0, col: 0`. The error renders without a
source snippet — just the message and help text.

**Fix:** Thread SExpr line/col from the call site expression through the
collection pass into `check_resolved`. The `CollectState` or the
`try_add_*` helpers need the line/col from the expression being processed.

### 7. Old seed resolver workarounds
**priority:** low
**file:** `features/generics/mono.av`

Functions like `try_add_fn_inst`, `try_add_enum_inst`, `try_add_struct_inst`
exist because the old seed's resolver crashes on `let x = f(...)` inside
nested match arms. Once the seed is updated past this bug, these can be
inlined back into `collect_inst_expr`.

**Fix:** After the next seed update, try inlining. If the new seed handles
it, remove the helpers. If not, keep them — they're not harmful, just verbose.

### 8. `substitute_*` and `rewrite_*` are 90% duplicated
**priority:** low — blocked on closure bug
**file:** `features/generics/mono.av`

`substitute_stmt`/`substitute_expr` and `rewrite_stmt`/`rewrite_expr` walk
every AST variant with identical structure, differing only in leaf operations.
~200 lines of pure duplication.

**Fix:** Extract `map_expr(expr, transform_fn)` mapper. Higher-order functions
work (tested: recursive mapper with named transform functions passes). BUT
the transform functions need context (TypeArgList or GenRegs), which requires
closures. **Closures with match pattern bindings are broken** — match arms
inside a closure body can't resolve pattern-bound variables. This blocks the
HO mapper approach.

**Unblock:** ~~Fix closure codegen~~ DONE (April 14, 2026). Closures with
match pattern bindings now work. However, the savings (~100 lines) don't
justify the added complexity (HO callbacks, different leaf behaviors per
pass). The two passes serve different purposes at different scales
(substitute: small cloned subtrees, rewrite: entire program). Accepted
duplication — will revisit if a third AST transform pass is needed.

### ~~9. ParamList type strings not rewritten~~ DONE
**status:** fixed (April 14, 2026)

Added `rewrite_param_types` that walks ParamList and applies
`rewrite_type_name` to each node's `ty` string. Applied in `.Function`
and `.ExternFn` arms of `rewrite_stmt`.

### ~~10. Nested/recursive generics not tested~~ DONE
**status:** works (April 14, 2026)

`enum List<T> { End, Node(value: T, next: List<T>) }` works out of the box.
The self-referential `next: List<T>` field type string stays unchanged during
substitution, which is correct because all enums have the same layout
`{i64, ptr}`. The `List.Node(1, List.Node(2, ...))` calls correctly infer
`T=int` and the monomorphized `List__int` enum is generated.
Test: `tests/recursive_generic.av`.
