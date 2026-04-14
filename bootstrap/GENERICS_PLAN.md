# Generics Implementation Plan

## Key Insight

The bootstrap compiler uses an everything-is-i64 value model. Strings,
structs, enums, lists — all pointers stored as i64. This means generics
are **type erasure only**. No monomorphization, no code duplication, zero
runtime cost. `List<int>` and `List<string>` compile to the same LLVM IR.

The Rust compiler's monomorphization approach is unnecessary here.
Generics are purely a type checker concern.

## What Generics Unlock

1. Unify 13+ linked list enums → `List<T>`
2. `Result<T, E>` → eliminate 98 `had_error` checks
3. Generic `Map<K, V>` → clean registry/dispatch systems
4. Desugar hook registry → features register their own desugar rules
5. `fn map<T, U>(list: List<T>, f: fn(T) -> U) -> List<U>`

## Current State

- Parser ALREADY skips `<T>` via `skip_angle_brackets()` — parsing works
- `features/generics/example.fg` ALREADY passes (identity, Pair, Option)
- Everything compiles because types are erased to i64
- What's MISSING: the type checker discards type params instead of tracking them

## Design: Type Erasure Generics

### Phase 1: Keep Type Params in the AST

Currently `skip_angle_brackets()` consumes `<T, U>` and throws it away.
Change: store type params on the AST nodes.

**AST changes in `core/ast.fg`:**
```forge
// Current:
Function(name: string, params: ParamList, ret_ty: string, body: StmtList)

// New:
Function(name: string, type_params: TypeParamList, params: ParamList, ret_ty: string, body: StmtList)
```

New types:
```forge
export enum TypeParamList {
    End
    Node(name: string, bounds: string, next: TypeParamList)
}
```

This is a BREAKING CHANGE to the Function variant. Requires two-phase
bootstrap (Phase A: add TypeParamList type, Phase B: add field to Function).

Actually — since enum changes are safe (hash-based tags, heap payloads),
adding a field to Function SHOULD be safe without two-phase. But test
carefully.

### Phase 2: Parser Keeps Type Params

In `features/generics/parser.fg`, change `skip_angle_brackets()` to
`parse_type_params() -> TypeParamList`. Returns the parsed type params
instead of discarding them.

The function/type/enum declaration parsers pass the type params through
to the AST node.

### Phase 3: Type Checker Tracks Generic Types

In `typeck/mod.fg`, when checking a generic function call like
`identity(42)`, the type checker:

1. Looks up `identity` → sees it has type param `T`
2. Infers `T = int` from the argument type
3. Substitutes `T → int` in the return type → returns `int`

For generic types like `List<int>`:
1. `ValueType` gets a new variant: `.Generic(name: string, args: TypeList)`
2. `List<int>` = `ValueType.Generic("List", [.Int])`
3. `List<string>` = `ValueType.Generic("List", [.Str])`

These are DISTINCT types for the checker but IDENTICAL at runtime (both i64).

### Phase 4: Codegen — Nothing Changes

The codegen doesn't care about type params. Everything is i64.
`List<int>.Node(1, .End)` compiles to the same IR as `ExprList.Node(1, .End)`.

The type params are erased after type checking.

### Phase 5: Unify Linked Lists

Once generics work, replace the 13 linked list enums:
```forge
// Before: 13 separate enums
enum ExprList { End, Node(expr: SExpr, next: ExprList) }
enum StmtList { End, Node(stmt: SStmt, next: StmtList) }
enum ParamList { End, Node(name: string, ty: string, next: ParamList) }
// ... 10 more

// After: one generic
enum List<T> { End, Node(value: T, next: List<T>) }

// Usage:
type ExprList = List<SExpr>
type StmtList = List<SStmt>
```

This is a MASSIVE refactor (touches every file) but is purely mechanical.
Do it AFTER generics are working and tested.

## Implementation Order

1. Add `TypeParamList` enum to `core/ast.fg`
2. Add `type_params` field to `Function` (and TypeDecl, EnumDecl)
3. Change parser to keep type params instead of skipping
4. Update resolver to scope type param names
5. Add `ValueType.Generic(name, args)` to the type system
6. Update type checker to infer and track type args
7. Test: generic functions, generic types, generic enums
8. Dogfood: unify linked list enums (Phase 5 — separate session)

## Risks

- Adding fields to Function/TypeDecl/EnumDecl changes payload layout.
  Hash-based tags are stable but payload field counts matter. Test the
  bootstrap chain carefully after each change.
- The type checker is currently loose (many warnings, not blocking).
  Generic type checking needs to be ADDITIVE (report more info) not
  RESTRICTIVE (block compilation) to avoid breaking existing code.
- The 13-enum unification (Phase 5) is the biggest mechanical change
  in the project's history. Do it in a SEPARATE session with full
  test coverage.

## What NOT To Do

- No monomorphization. Everything is i64.
- No trait bounds checking (yet). Just parse and store them.
- No generic impls (yet). Start with generic functions and types.
- Don't try to unify the linked lists in the SAME session as adding
  generics. Get generics working first, then unify.
