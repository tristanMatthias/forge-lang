# Pluggable Feature Architecture

## Goal

Adding a language feature should NEVER require editing core files.
Create `features/<name>/`, register it, done. Core is thin infrastructure.

## Current State

Every feature (if, while, match, modules, closures, etc.) has hardcoded
match arms in 5+ core files:

- `parse/mod.fg` — `if self.check("kw_if") { return self.parse_if_statement() }`
- `codegen/mod.fg` — `emit_stmt`: `.If(...) -> emit_if(...)` in explicit arm
- `core/resolver.fg` — `resolve_stmt`: `.If(...) -> { resolve children }`
- `typeck/mod.fg` — `check_stmt`: `.If(...) -> { check children }`
- `core/eval.fg` — `execute_stmt`: `.If(...) -> { eval branches }`

The ONLY pluggable dispatch point today is `emit_stmt`/`emit_expr` catch-all
→ `dispatch_stmt_emit`/`dispatch_expr_emit` in the registry. But even that
only covers SOME features — If, While, For, Match have explicit arms AND
feature registrations (the explicit arms take priority).

## Target Architecture

### Core becomes a thin loop

```
parse → resolve → typecheck → codegen
```

Each stage walks the AST and dispatches EVERY node through the feature
registry. Core handles ONLY the infrastructure:
- StmtList iteration
- Block scoping
- Stmt.Annotated unwrapping
- Error propagation

### Feature registration expands to cover all passes

```forge
type Feature = {
    name: string,
    // Parser: called when the keyword is encountered
    parse_keyword: string,              // e.g. "kw_if", "kw_mod"
    parse_fn: fn(Parser) -> Stmt?,      // the parser function

    // Codegen
    emit_expr: fn(Ctx, VarEnv, Expr) -> EmitResult,
    emit_stmt: fn(Ctx, VarEnv, Stmt) -> StmtResult,

    // Resolver
    resolve_stmt: fn(Resolver, Stmt) -> Resolver,
    resolve_expr: fn(Resolver, Expr) -> Resolver,

    // Type checker
    check_stmt: fn(TC, Stmt) -> TC,
    check_expr: fn(TC, Expr) -> ExprResult,

    // Eval (tree-walk interpreter)
    eval_stmt: fn(Runtime, Stmt) -> StepResult,
    eval_expr: fn(Runtime, Expr) -> StepResult,

    // Declaration passes (codegen pre-passes)
    declare_fn: fn(Module, Stmt, FnRetTypes) -> FnRetTypes,
    declare_struct: fn(Ctx, Stmt, StructReg) -> StructReg,
    declare_enum: fn(Ctx, Stmt, EnumReg) -> EnumReg,
}
```

### Parser becomes keyword-dispatched

Instead of:
```forge
if self.check("kw_if") { return self.parse_if_statement() }
if self.check("kw_while") { return self.parse_while_statement() }
if self.check("kw_mod") { return self.parse_module_declaration() }
```

It becomes:
```forge
let handler = registry.lookup_keyword(self.current_kind)
if handler != null { return handler(self) }
```

### What stays in core

- **AST types** (`Stmt`, `Expr`, `Pattern` enums) — these are the shared data model
- **Diagnostic codes** — centralized error system
- **Registry infrastructure** — the dispatch tables
- **StmtList/ExprList walkers** — iteration + Annotated unwrapping
- **Scoping** — `enter_scope`/`exit_scope` in resolver and typechecker
- **Basic expressions** — Number, String, Bool, Null, Ident, Assign, Binary, Unary
  (these are so fundamental they stay in core)

### What becomes features

EVERYTHING else:
- `features/if_stmt/` — If, IfExpr
- `features/while_stmt/` — While
- `features/for_stmt/` — For, ForIn
- `features/match_expr/` — Match, MatchExpr
- `features/fn_decl/` — Function, ExternFn, Return
- `features/let_stmt/` — Let, Mut, LetDestructure
- `features/struct_decl/` — TypeDecl, StructLit, FieldAccess, FieldAssign, With
- `features/enum_decl/` — EnumDecl, EnumCtor
- `features/impl_decl/` — Impl
- `features/trait_decl/` — TraitDecl
- `features/closures/` — Lambda, closure captures
- `features/modules/` — Module, Use, QualifiedIdent, name resolution
- `features/null_safety/` — NullCoalesce, OptionalChain, Try
- `features/tuples/` — Tuple, TupleIndex
- `features/list_lit/` — ListLit
- `features/map_lit/` — MapLit
- `features/defer_stmt/` — Defer
- `features/is_keyword/` — IsCheck
- `features/select_stmt/` — Select
- `features/parallel_stmt/` — Parallel
- `features/spec_test/` — SpecBlock, GivenBlock, ThenBlock

### Migration strategy

1. Extend `Feature` type with all dispatch hooks (resolve, check, eval, declare)
2. Wire dispatch into resolver, typechecker, eval catch-all arms
3. Migrate one feature at a time — remove explicit arms, add feature handlers
4. Start with the simplest (defer_stmt) and end with the most complex (fn_decl)
5. After each feature, verify 225 tests + fixed point

## Implementation order

1. Extend Feature type + Registry dispatch for all passes
2. Wire dispatch catch-alls in resolver.fg, typeck/mod.fg, eval.fg
3. Add keyword-dispatch to parser
4. Migrate features one by one (simplest first)
5. Core shrinks to thin infrastructure after each migration
