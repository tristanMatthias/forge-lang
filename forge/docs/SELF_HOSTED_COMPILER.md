# Self-Hosted Forge Compiler

## Context

The Forge compiler is 52,911 lines of Rust across 70 features in `packages/forgec-rust/`. The goal: rewrite it in Forge itself as `packages/forgec/`.

The Rust compiler is frozen. It serves only as the bootstrap compiler.

**Why:** Per Principle #24: "If Forge can't build its own tooling beautifully, it's not ready." Per Principle #12: "Adding a language feature means creating a feature directory... it does NOT mean editing core files." Per Principle #13: "No hardcoding, ever. Everything is generic, table-driven, or registry-based."

---

## Architecture: Registry-Driven, Zero Dispatch Tables

### The Core Principle

**Adding a feature = create 1 directory + add 1 import line.** Nothing else. No editing AST enums, no adding match arms, no touching dispatch files. Core never changes after Phase 1.

### How It Works

1. **`AstData` trait** — all feature AST nodes implement this trait
2. **`Statement.Feature(FeatureStmt)` / `Expr.Feature(FeatureExpr)`** — catch-all enum variants that wrap ANY feature's data via trait objects
3. **`FeatureRegistry`** — global `Map<string, fn>` tables populated at import time
4. **Core dispatch = `REGISTRY.get(key)?.call(args)`** — zero hardcoded match arms

Features register their parse/check/emit handler functions into the registry when their module is imported. Core dispatch just does map lookups. The registry IS the dispatch.

### Directory Structure

```
packages/forgec/
├── forge.toml
└── src/
    ├── main.fg                     # CLI entry
    │
    ├── core/
    │   ├── mod.fg                  # Core exports
    │   ├── token.fg                # TokenKind enum, Token, Span
    │   ├── ast.fg                  # Statement/Expr enums with Feature(...) extension points
    │   ├── types.fg                # Type enum
    │   ├── registry.fg             # FeatureRegistry + register_feature() + REGISTRY global
    │   └── error.fg                # Diagnostic type + render()
    │
    ├── lexer/
    │   └── mod.fg                  # Lexer struct + tokenize()
    │
    ├── parser/
    │   ├── mod.fg                  # Parser struct + parse_program()
    │   └── expressions.fg          # Precedence-climbing expression parser
    │
    ├── checker/
    │   ├── mod.fg                  # TypeChecker struct + check()
    │   └── env.fg                  # TypeEnv (scoped symbol tables)
    │
    ├── codegen/
    │   ├── mod.fg                  # Codegen struct (wraps @std.llvm)
    │   ├── types.fg                # Type → LLVM type mapping
    │   ├── runtime.fg              # Runtime fn declarations
    │   └── linker.fg               # Object emission + cc invocation
    │
    ├── driver/
    │   └── mod.fg                  # Pipeline orchestration
    │
    └── features/
        ├── mod.fg                  # ONLY file edited per feature: one `use` line
        │
        ├── variables/
        │   └── mod.fg              # Data types + parse + check + codegen + register
        │
        ├── functions/
        │   └── mod.fg
        │
        ├── operators/
        │   └── mod.fg
        │
        ├── if_else/
        │   └── mod.fg
        │
        ├── printing/
        │   └── mod.fg
        │
        ├── primitive_types/
        │   └── mod.fg
        │
        └── ... (each feature: 1 directory, 1+ files, examples/)
```

---

### Core AST (core/ast.fg) — NEVER CHANGES for new features

```forge
// The AstData trait — every feature's AST node implements this
trait AstData {
    fn kind(self) -> string         // "Let", "FnDecl", "If"
    fn feature_id(self) -> string   // "variables", "functions", "if_else"
    fn span(self) -> Span
}

// Wrapper types for feature-owned data
type FeatureStmt = { data: AstData }   // trait object (dyn dispatch)
type FeatureExpr = { data: AstData }

// The Statement enum — structural primitives + catch-all Feature variant
enum Statement {
    Expr(expr: Expr)
    Assign(target: Expr, value: Expr, span: Span)
    Feature(stmt: FeatureStmt)         // ALL feature statements go here
}

// The Expr enum — structural primitives + catch-all Feature variant
enum Expr {
    IntLit(value: int, span: Span)
    FloatLit(value: float, span: Span)
    StringLit(value: string, span: Span)
    BoolLit(value: bool, span: Span)
    NullLit(span: Span)
    Ident(name: string, span: Span)
    Binary(left: Expr, op: BinOp, right: Expr, span: Span)
    Unary(op: UnaryOp, operand: Expr, span: Span)
    Call(callee: Expr, args: List<Expr>, span: Span)
    MemberAccess(object: Expr, field: string, span: Span)
    Index(object: Expr, index: Expr, span: Span)
    Block(block: Block)
    Feature(expr: FeatureExpr)         // ALL feature expressions go here
}
```

The `Feature(...)` variants are the extension points. Adding 100 features never adds a variant to these enums.

---

### Feature Registry (core/registry.fg) — NEVER CHANGES for new features

```forge
type ParseHandler = fn(Parser) -> Statement?
type CheckStmtHandler = fn(TypeChecker, AstData)
type CheckExprHandler = fn(TypeChecker, AstData) -> Type
type EmitStmtHandler = fn(Codegen, AstData)
type EmitExprHandler = fn(Codegen, AstData) -> ptr

type FeatureRegistry = {
    mut parse_stmt: Map<string, ParseHandler>,       // token_kind → parse fn
    mut check_stmt: Map<string, CheckStmtHandler>,   // feature_id → check fn
    mut check_expr: Map<string, CheckExprHandler>,    // feature_id → check fn
    mut emit_stmt: Map<string, EmitStmtHandler>,     // feature_id → codegen fn
    mut emit_expr: Map<string, EmitExprHandler>,     // feature_id → codegen fn
    mut top_level: Map<string, fn(TypeChecker, AstData)>,  // first-pass registration
}

let REGISTRY = FeatureRegistry {
    parse_stmt: {}, check_stmt: {}, check_expr: {},
    emit_stmt: {}, emit_expr: {}, top_level: {},
}

type FeatureRegistration = {
    id: string,
    name: string,
    status: string,
    parsers: Map<string, ParseHandler>,    // token → handler
    check_stmt: CheckStmtHandler?,
    check_expr: CheckExprHandler?,
    emit_stmt: EmitStmtHandler?,
    emit_expr: EmitExprHandler?,
    top_level: fn(TypeChecker, AstData)?,
}

fn register_feature(reg: FeatureRegistration) {
    for token in reg.parsers.keys() {
        REGISTRY.parse_stmt[token] = reg.parsers[token]
    }
    if reg.check_stmt != null { REGISTRY.check_stmt[reg.id] = reg.check_stmt! }
    if reg.check_expr != null { REGISTRY.check_expr[reg.id] = reg.check_expr! }
    if reg.emit_stmt != null  { REGISTRY.emit_stmt[reg.id] = reg.emit_stmt! }
    if reg.emit_expr != null  { REGISTRY.emit_expr[reg.id] = reg.emit_expr! }
    if reg.top_level != null  { REGISTRY.top_level[reg.id] = reg.top_level! }
}
```

---

### Core Dispatch — NEVER CHANGES for new features

```forge
// parser/mod.fg
fn parse_statement(self) -> Statement? {
    let token = self.peek()
    let handler = REGISTRY.parse_stmt.get(token.kind.to_string())
    if handler != null { return handler!(self) }
    self.parse_expr_statement()
}

// checker/mod.fg
fn check_feature_stmt(self, fe: FeatureStmt) {
    let handler = REGISTRY.check_stmt.get(fe.data.feature_id())
    if handler != null { handler!(self, fe.data) }
}

fn check_feature_expr(self, fe: FeatureExpr) -> Type {
    let handler = REGISTRY.check_expr.get(fe.data.feature_id())
    if handler != null { return handler!(self, fe.data) }
    Type.Unknown
}

// codegen/mod.fg
fn emit_feature_stmt(self, fe: FeatureStmt) {
    let handler = REGISTRY.emit_stmt.get(fe.data.feature_id())
    if handler != null { handler!(self, fe.data) }
}

fn emit_feature_expr(self, fe: FeatureExpr) -> ptr {
    let handler = REGISTRY.emit_expr.get(fe.data.feature_id())
    if handler != null { return handler!(self, fe.data) }
    llvm.const_int(self.i64_type, 0, 0)  // fallback
}
```

---

### Concrete Feature Example: Variables

```forge
// features/variables/mod.fg — EVERYTHING in one place

use core.{AstData, Statement, Expr, Span, FeatureStmt}
use core.registry.{register_feature, FeatureRegistration}

// ─── AST Data ──────────────────────────────────

enum VarKind { Let, Mut, Const }

type VarDeclData = {
    var_kind: VarKind,
    name: string,
    type_ann: TypeExpr?,
    value: Expr,
    exported: bool,
    span: Span,
}

impl AstData for VarDeclData {
    fn kind(self) -> string { match self.var_kind { .Let -> "Let", .Mut -> "Mut", .Const -> "Const" } }
    fn feature_id(self) -> string { "variables" }
    fn span(self) -> Span { self.span }
}

// ─── Parser ────────────────────────────────────

fn parse_let(p: Parser) -> Statement? {
    let start = p.advance().span   // consume 'let'
    let name = p.expect_ident()
    let type_ann = p.try_type_annotation()
    p.expect_eq()
    let value = p.parse_expr()
    Statement.Feature(FeatureStmt {
        data: VarDeclData { var_kind: .Let, name, type_ann, value, exported: false, span: start }
    })
}

fn parse_mut(p: Parser) -> Statement? {
    let start = p.advance().span
    let name = p.expect_ident()
    let type_ann = p.try_type_annotation()
    p.expect_eq()
    let value = p.parse_expr()
    Statement.Feature(FeatureStmt {
        data: VarDeclData { var_kind: .Mut, name, type_ann, value, exported: false, span: start }
    })
}

// ─── Type Checker ──────────────────────────────

fn check_var(tc: TypeChecker, data: AstData) {
    let d = data as VarDeclData
    let val_type = tc.infer_expr(d.value)
    let ty = if d.type_ann != null {
        let ann = tc.resolve_type(d.type_ann!)
        tc.expect_assignable(ann, val_type, d.span)
        ann
    } else { val_type }
    let mutable = d.var_kind is .Mut
    tc.env.define(d.name, ty, mutable)
}

// ─── Codegen ───────────────────────────────────

fn emit_var(cg: Codegen, data: AstData) {
    let d = data as VarDeclData
    let val = cg.emit_expr(d.value)
    let ty = cg.type_to_llvm(cg.type_of(d.value))
    let alloca = llvm.build_alloca(cg.builder, ty, d.name)
    llvm.build_store(cg.builder, val, alloca)
    cg.define_var(d.name, alloca, cg.type_of(d.value))
}

// ─── Registration (runs at import time) ────────

register_feature(FeatureRegistration {
    id: "variables",
    name: "Variables",
    status: "stable",
    parsers: { "let": parse_let, "mut": parse_mut },
    check_stmt: check_var,
    check_expr: null,
    emit_stmt: emit_var,
    emit_expr: null,
    top_level: null,
})
```

---

### Adding a New Feature: The Complete Workflow

To add `while_loops`:

**Step 1:** Create `features/while_loops/mod.fg`:
```forge
type WhileData = { condition: Expr, body: Block, span: Span }

impl AstData for WhileData {
    fn kind(self) -> string { "While" }
    fn feature_id(self) -> string { "while_loops" }
    fn span(self) -> Span { self.span }
}

fn parse_while(p: Parser) -> Statement? { /* ... */ }
fn check_while(tc: TypeChecker, data: AstData) { /* ... */ }
fn emit_while(cg: Codegen, data: AstData) { /* ... */ }

register_feature(FeatureRegistration {
    id: "while_loops", name: "While Loops", status: "stable",
    parsers: { "while": parse_while },
    check_stmt: check_while, emit_stmt: emit_while,
    check_expr: null, emit_expr: null, top_level: null,
})
```

**Step 2:** Add one line to `features/mod.fg`:
```forge
use features.while_loops
```

**That's it. 2 files. 1 new, 1 line added. Zero core changes.**

---

### The `as` Cast Question

Feature handlers receive `AstData` (trait object) and need to access the concrete type (`VarDeclData`, `WhileData`, etc.). This requires `data as VarDeclData` — a trait-to-concrete downcast.

**If dyn trait `as` cast is available:** Use it directly (clean, type-safe).

**Bridge solution if not:** Each feature stores its data in a feature-local side table keyed by a node ID. The `AstData` carries just the ID; handlers look up the real data from their own table. No downcast needed.

```forge
// Bridge: side-table approach
mut VAR_DECLS: Map<int, VarDeclData> = {}
mut next_id = 0

fn parse_let(p: Parser) -> Statement? {
    // ...parse...
    let id = next_id
    next_id = next_id + 1
    VAR_DECLS[string(id)] = data
    Statement.Feature(FeatureStmt { data: NodeRef { id, feature: "variables", kind: "Let", span } })
}

fn check_var(tc: TypeChecker, data: AstData) {
    let d = VAR_DECLS[string(data.node_id())]!
    // ...full type safety from here...
}
```

Either approach works. We'll determine which to use when we start implementation.

---

## Phases

### Phase 0: Extend @std.llvm

44 functions exist. Need ~30 more:

| Group | Functions | Why |
|-------|-----------|-----|
| Struct types | `struct_type`, `struct_get_type_at_index` | ForgeString = {ptr, i64}, enums |
| Aggregate ops | `build_gep2`, `build_insert_value`, `build_extract_value` | Field access |
| Int arithmetic | `build_sdiv`, `build_srem` | Division, modulo |
| Float ops | `build_fadd/fsub/fmul/fdiv`, `build_fcmp` | Float support |
| Int conversions | `build_zext`, `build_sext`, `build_trunc`, `build_sitofp`, `build_fptosi` | Casts |
| Pointer ops | `build_bitcast`, `build_ptrtoint`, `build_inttoptr` | Heap boxing |
| Bitwise | `build_and/or/xor/shl/ashr`, `build_not` | Flags |
| Control flow | `build_unreachable`, `build_switch` | Dead code, enum dispatch |
| Constants | `const_null`, `get_undef` | Zero init |
| Globals | `add_global`, `set_initializer` | Global data |
| Builder ops | `get_insert_block`, `get_bb_parent`, `position_before` | Entry alloca |
| Target machine | `init_all_targets`, `get_triple`, `create_target_machine`, `emit_to_file` | Object output |

**Done when:** Forge program creates struct types, builds GEP, emits object file.

---

### Phase 1: Minimum Viable Compiler (6 features)

**Features:** `primitive_types`, `variables`, `functions`, `operators`, `if_else`, `printing`

**Includes:** Core infrastructure (registry, AST, lexer, parser, checker, codegen, driver, linker) + 6 feature directories.

**Target:** Compile `fib(10)` to a working binary.

**Done when:** `forgec-rust run src/main.fg -- hello.fg -o hello && ./hello`

**Estimated:** ~3,500 lines, ~25 tasks

---

### Phase 2: Self-Compilation Features

| Sub-phase | New feature directories | Est. tasks |
|-----------|------------------------|------------|
| **2a** | `enums`, `pattern_matching` | 15 |
| **2b** | `structs`, `impl_methods` | 12 |
| **2c** | `while_loops`, `for_loops`, `ranges` | 8 |
| **2d** | `collections` (List, Map) | 10 |
| **2e** | `strings`, `string_templates` | 8 |
| **2f** | `closures`, `fn_types` | 8 |
| **2g** | `null_safety`, `error_propagation` | 8 |
| **2h** | `traits`, `generics` | 12 |
| **2i** | `pipe_operator`, `match_tables`, `modules` | 8 |

Each sub-phase: create feature directory + 1 import line. Core never changes.

**Done when:** `forgec-fg build src/main.fg -o forgec-fg2` — self-compilation.

---

### Phase 3: Full Language Parity

Remaining ~40 features. **Done when:** `forgec-fg test` passes all 968+ tests.

---

## Critical Files

| File | Role |
|------|------|
| `packages/std-llvm/src/lib.rs` | LLVM C API wrappers (extend in Phase 0) |
| `packages/std-llvm/src/package.fg` | Forge-facing LLVM API |
| `packages/forgec-rust/feature.rs` | Blueprint: FeatureNode/FeatureExpr/FeatureStmt pattern |
| `packages/forgec-rust/lexer/lexer.rs` | Lexer to port (~1,256 lines) |
| `packages/forgec-rust/parser/ast.rs` | AST reference (~589 lines) |
| `packages/forgec-rust/codegen/codegen/` | Codegen patterns (~2,824 lines) |
| `stdlib/runtime.c` | Runtime for compiled binaries (shared, not rewritten) |

## Key Design Decisions

1. **Registry-driven dispatch.** `Map<string, fn>` lookups, not match arms. Core never changes.
2. **Trait objects for AST data.** `AstData` trait + `Feature(FeatureStmt)` catch-all. No per-feature enum variants in core.
3. **Feature self-registration.** `register_feature()` called at import time populates the global registry.
4. **Runtime reuse.** Output links `stdlib/runtime.c`. No rewrite.
5. **Object emission via LLVM target machine.** Phase 0 adds the C API wrappers.

## Risks

| Risk | Severity | Mitigation |
|------|----------|------------|
| LLVM target machine API gaps | High | Phase 0 first. Fallback: IR text + `llc` |
| Trait object downcast (`as`) | High | Bridge: side-table approach if `as` not ready |
| String handling ({ptr, i64}) | High | String helper layer early in codegen |
| Enum codegen via raw LLVM C API | Medium | Port Rust compiler's tagged-union patterns |

## Verification

- **Phase 0:** `forge run llvm_struct_test.fg` — struct types + object file emission
- **Phase 1:** `forgec-fg build hello.fg && ./hello` → "Hello, World!"
- **Phase 2:** `forgec-fg build src/main.fg -o forgec-fg2` → self-compilation
- **Phase 3:** `forgec-fg test` passes all 968 tests
