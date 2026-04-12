# Tech Debt

Active debt in the bootstrap compiler. Each item has a plan.

## In-Progress Work (resume here)

### ~~Trait Dynamic Dispatch~~ (FIXED)

**Status:** fixed (April 11 2026)

**Resolution:** Trait dynamic dispatch fully implemented:
- `let d: Describable = Circle { radius: 5 }` boxes concrete value
  into a trait object with a vtable
- `d.describe()` dispatches through vtable via closure trampolines
- Return types correctly tracked via `TraitMethodNames.ret_ty`
- Function parameters with trait types work (`fn f(d: Trait)`)
- 2 regression tests (basic + combinatorial)

## Open

### ~~1. libforge_llvm.a dependency (Rust LLVM wrapper)~~ (FIXED)

**Status:** fixed (April 11 2026). Replaced with `bootstrap/llvm_wrapper.c`
(~300 lines of pure C calling LLVM 21 C API directly). No Rust toolchain
needed. 11 compatibility stubs removed from runtime.c.

### ~~2. String type tags (ty: string)~~ (FIXED)

**Status:** fixed (April 9 2026)

**Resolution:** `ValueType` enum replaces all string type tags.
Pattern matching instead of CSV parsing. 15 files, 82/82 tests pass.

### ~~3. Operator string dispatch~~ (FIXED)

**Status:** fixed (April 9 2026)

**Resolution:** BinOp/UnOp/LogicOp enums. Parse converts tokens to
enums at parse time. Codegen matches on enums. IR shrank 220 lines.

### 4. VarLookup/FnLookup structs (was nullable return workaround)

**Severity:** low (cosmetic)
**Impact:** `env_lookup` returns `VarLookup { found, alloca, ty }`
instead of just `ptr?`

Originally worked around Rust host bug #6 (nullable returns from
recursive enum matching corrupted values). Our compiler handles
this correctly now — verified with test. The struct pattern is
slightly verbose but clear. Could migrate to `?`-based returns.

**Plan:** Optional cleanup. The struct pattern is actually readable.

### 5. Tagged Value struct in eval.fg (was enum payload workaround)

**Severity:** low (cosmetic)
**Impact:** eval.fg uses `type Value = { tag, int_val, str_val, ... }`
instead of an enum

Originally worked around Rust host bug #5 (enum payloads unreliable
across function boundaries). Our compiler handles enum payloads fine.
The eval is rarely used (only for the `eval` command).

**Plan:** Optional cleanup. Low priority since eval is not the
primary codegen path.

### 6. Recursive enum lists instead of real collections (cosmetic)

**Severity:** low (cosmetic)
**Impact:** ExprList, StmtList, ParamList, VarEnv are linked lists

The AST uses recursive enums (e.g. `ExprList.Node(expr, next)`)
instead of the `List` we just built. This was because the Rust host
compiler's `List.push()` was broken. Now that we have our own
`forge_array_*` runtime, we COULD migrate — but the recursive
enums work fine for AST sizes. Not urgent.

**Plan:** Consider migrating when/if performance matters. The linked
lists are actually idiomatic for immutable scope stacks (VarEnv).

### ~~7. return not allowed in bare match arms~~ (FIXED)

**Status:** fixed (April 11 2026). Parser wraps bare `return expr`
in a Block expression, so `_ -> return x` works without braces.

### ~~8. Stmt.Return naming (was Ret)~~ (RESOLVED)

**Status:** fixed. Variant is `Stmt.Return`.

### ~~9. DiagCode parallel match blocks~~ (FIXED)

**Status:** fixed. Single `error_def(code: DiagCode) -> ErrorDef` match
returns all metadata. `diag_code_str` and `diag_code_help` are thin
wrappers that delegate to `error_def`.

### ~~10. Forge needs associated enum data~~ (FIXED)

**Status:** fixed (April 11 2026)

**Resolution:** Enum impl blocks now work in both the Rust compiler and
the bootstrap compiler. Three fixes in the Rust compiler's traits/codegen.rs:
1. `get_type_name` now returns the enum name for `Type::Enum`
2. `resolve_named_type` now checks `enum_types` in the type checker env
3. `type_to_type_expr` now handles `Type::Enum` (returns `TypeExpr::Named(name)`)

The bootstrap compiler already handled this correctly via `vtype_enum_name`
in the method call dispatch path. Test added to both compilers.

### ~~11. render_diagnostic crashes on bad input~~ (FIXED)

**Status:** fixed. Three fixes applied:
1. `if line > 0 && col > 0` guard prevents source context on dummy spans
2. `render_first_n` limits to 10 diagnostics (prevents stack overflow)
3. `render_bag` re-enabled in both check and compile paths

### 12. Seed bootstrap requires multiple manual cycles

**Severity:** medium (DX pain)
**Impact:** adding a new module requires: disable module → update seed →
re-enable module → update seed. If any step crashes, diagnosis is hard
because the crash is in the OLD seed binary, not the new code.

**Fix:**
1. `make` should catch compilation crashes and print the error message
   instead of just "bs2 codegen failed"
2. Add `--dry-run` mode (parse + resolve only, no codegen) for validating
   new source before committing to a seed cycle
3. The Makefile should detect resolver errors and skip render_bag
4. Consider a "bridge" compilation mode that compiles new modules with
   the old seed but links them separately

### ~~13. Dotted types not supported in parameters~~ (FIXED)

**Status:** fixed (April 11 2026)

**Root cause:** `consume_type()` only consumed a single identifier token.
**Fix:** Added a loop in `consume_type()` that consumes `.identifier`
sequences after the initial identifier, building the full dotted path
(e.g., `core.ast.BinOp` parses as the type name `"core.ast.BinOp"`).

### ~~14. Function name collision~~ (FIXED)

**Status:** fixed (April 10 2026)

**Root cause:** Two functions named `bind_params` existed in different
modules: `eval.fg` (3 params: runtime, params, args) and `typeck/mod.fg`
(2 params: tc, params). The bootstrap inlines all modules into one
compilation unit, so LLVM merged both definitions. The typeck call site
resolved to the eval version, which expected a third argument. The
missing `x2` register contained garbage, causing a segfault when the
eval's `bind_params` accessed it.

**How it was found:** LLDB showed `bind_params` had 3 parameters in
IR (`define i64 @bind_params(i64, i64, i64)`) but the typeck call
only passed 2. `grep -rn "fn bind_params" src/` revealed the collision.

**Fix:** Renamed typeck's function to `tc_bind_params`.

**Prevention:** CLAUDE.md now requires prefixing function names with
the module name to avoid collisions. Added to debugging protocol.

### 16. Function name collisions across modules (MITIGATED)

**Severity:** high (silent crash, very hard to diagnose)
**Impact:** when two modules define a function with the same name but
different signatures, LLVM picks one definition and all call sites
use it. Arguments beyond the shorter signature read garbage.

**Mitigation (done):** `declare_functions` in codegen/mod.fg now checks
`forge_llvm_get_named_function` before adding. If a function with the
same name already exists, it prints `FATAL: duplicate function` and exits.
This catches the bug at compile time instead of runtime.

**Proper fix (TODO):** The module preprocessor should mangle function
names with their module path: `bind_params` in `typeck/mod.fg` becomes
`typeck__bind_params` in the IR. This is what every real compiler does
and eliminates the collision class entirely.

**Prevention:** prefix all non-exported functions with their module
name: `tc_bind_params`, `eval_bind_params`, etc.

**Audit command:**
```bash
grep -rh "^fn \|^export fn " src/ | sed 's/^export //' | sed 's/fn //' | sed 's/(.*//' | sort | uniq -d
```

### 15. Bump allocator (STEPPING STONE — will be removed)

**Severity:** low (intentional temporary solution)
**Impact:** all struct/enum/with allocations use a monotonic bump
allocator (512MB arena, no free, no reuse). Prevents heap corruption
class of bugs but wastes memory.

**What it replaces:** `malloc` for value-type allocations. Array/map
code still uses system malloc (needs realloc).

**Memory strategy roadmap:**
1. **Now:** bump allocator (no corruption, no free, process exits)
2. **Next:** Application-level ref-counting (automatic, deterministic,
   no GC — the default Forge memory model)
3. **Then:** Systems-level ownership tracking (Rust-style, zero overhead,
   compiler-checked lifetimes)
4. **Later:** Bare-level manual allocation (you call alloc/free)
5. **Eventually:** Hardware-level volatile (memory-mapped I/O)

See `docs/idea_scoped_abstraction_levels.md` for the full vision.

**When to remove:** when Application-level ref-counting is implemented
in the real compiler. The bump allocator is bootstrap-only — it never
ships in any user-facing binary.

### ~~17. Type checker: struct field access doesn't detect invalid fields~~ (FIXED)

**Status:** fixed (April 10 2026). Root cause: the parser defaulted
unannotated `let` bindings to type `"i64"`. The type checker saw the
non-empty type annotation and used `translate_type("i64")` → `Int`,
overriding the inferred `Struct("Foo")` from the initializer. Fix:
changed parser default from `"i64"` to `""` (empty). Applied across
`let`, `mut`, `fn`, `impl`, `extern`, `trait` parsers.

### ~~18. Type checker: no source spans on diagnostics~~ (FIXED)

**Status:** fixed. SExpr/SStmt wrappers exist in ast.fg, containers
(ExprList, StmtList, MatchArmList, FieldInitList) use them, and
check_stmts extracts ss.line/ss.col into TC.current_line/current_col.
Type errors now show source file, line number, and column.

**Previously:** blocked by bootstrap chicken-and-egg

**The wrapper struct approach (SExpr/SStmt) was attempted** — all ~200
edits across 22 files were made, but the bootstrap fails because
changing ExprList/StmtList/MatchArmList container types causes the
OLD seed's resolver to read the wrong data layout (it destructures
.Node(pattern, guard: Expr, body: Expr) but gets SExpr values).

**Fix path:** two-phase bootstrap:
1. Phase A: add SExpr/SStmt types + helper functions to ast.fg WITHOUT
   changing any container types. Update seed.
2. Phase B: change container types (ExprList, StmtList, FieldInitList,
   MatchArmList). The Phase A seed understands the new types so it
   can compile Phase B code correctly.

**Alternative:** C-side span table (simpler but adds global state).

### 18b. Original description — Type checker: no source spans on diagnostics

**Severity:** medium (DX limitation)
**Impact:** type checker errors show the error code and message but
no source location (uses `span_dummy()`). The parser tracks byte
offsets (`current_start`) but doesn't attach spans to AST nodes.
Adding spans requires modifying the Expr/Stmt enums which breaks
every match site (~100+ locations).

**Fix path:** add a `Span` field to Expr and Stmt (or a parallel
SpanTable indexed by ExprId). Update all construction sites in the
parser to record spans.

### ~~19. Type checker: `bind_params` inlined in Function arm~~ (FIXED)

**Status:** fixed. `tc_bind_params` is now a proper function call.
The name collision with `eval.fg`'s `bind_params` was resolved by
renaming to `tc_bind_params`.

### ~~20. Resolver bag reporting disabled~~ (FIXED)

**Status:** fixed. `resolve_report` now adds diagnostics to the bag.
Both parse and resolver errors render structured diagnostics in
compile mode. The render_first_n limit (10) prevents stack overflow.

### ~~21. render_bag removed from compile path~~ (FIXED)

**Status:** fixed. render_bag re-enabled for both parse and resolver
error paths in the compile command.

### ~~22. Remaining malloc calls~~ (RESOLVED)

**Status:** resolved. Only 1 malloc call remains in seed. The codegen
uses `cg_malloc` (bump allocator) for all struct/enum constructors.

### 23. ~~Hardcoded `is_builtin` list in resolver~~ FIXED

**Fixed:** removed `is_builtin()` function. Builtins are now
pre-declared via `declare_function()` in `resolve_program()` before
walking the AST, so they resolve through the normal function lookup
path (`lookup_fn`). No separate hardcoded list needed.

Note: `features/modules/names.fg` still has a similar `is_builtin_name()`
for module name rewriting (preventing builtins from being qualified).
That's a separate concern.

### 26. Stmt.Defer stores Expr, not SExpr — loses source location

**Severity:** low (cosmetic — defer errors don't show line numbers)
**Impact:** `Stmt.Defer(body: Expr)` stores an `Expr`. The defer
handler wraps it in `sexpr_dummy(body)` which sets line:0, col:0.
If a defer body has a compile error, the error points to line 0.

**Proper fix:** Change `Stmt.Defer(body: Expr)` to
`Stmt.Defer(body: SExpr)`. This is a container type change requiring
a two-phase bootstrap (Phase A: add variant, Phase B: switch parser).

### ~~27. Closures returned through functions lose Closure type~~ (FIXED)

**Status:** fixed (April 12 2026)
The declaration pass now analyzes function bodies: `decl_fn_ret_type`
checks if the last expression is a Lambda. If so, `FnRetTypes` stores
`Closure(-1, ret_ty)` instead of `FnTyped(...)`. The `-1` means
"closure with unknown capture count." At call sites, `vtype_is_closure`
now returns true for these values. The call still routes through
`forge_closure_call_N` trampolines (which resolve captures at runtime),
but the type system correctly identifies the value as a closure.
Direct LLVM calls (bypassing trampolines) remain available when the
exact capture count is known (e.g., lambdas assigned directly to local
variables where `emit_lambda` sets the precise count).

### ~~28. Registry dispatch is O(n) linked-list scan~~ (FIXED)

**Status:** fixed (April 10 2026)
Replaced with O(1) ForgeIntMap (flat array indexed by tag).

### ~~31. Float values captured by closures lose their type~~ (FIXED)

**Status:** fixed (April 11 2026)
Lambda parameters now have their types inferred from body usage context.
When a parameter appears in a binary expression with a Float-typed
variable (capture, enclosing env, or top-level global), the parameter
is inferred as Float instead of defaulting to Int. This ensures
`bitcast i64 to double` is used instead of `sitofp i64 to double`,
preserving the float bit pattern correctly.

The actual capture types were already preserved correctly by
`bind_captures_as_params`. The real bug was that lambda *parameters*
(not captures) defaulted to `ValueType.Int`, so when a float value
was passed as an argument, the lambda treated the float bits as an
integer.

### 29. Dummy enum values for tag extraction in feature registration

**Severity:** low (ugly but correct)
**Impact:** Features register with `register_expr(reg, Expr.IsCheck(Expr.Null, ""), handler)`.
The `Expr.IsCheck(Expr.Null, "")` constructs a throwaway value just to
extract its tag byte. The field values (`Expr.Null`, `""`) are garbage —
only byte 0 (the tag) is read. This is confusing to read.

**Proper fix:** Add variant tag references as a language feature.
`Expr.IsCheck` without args should evaluate to the tag number (int).
This requires parser + codegen changes: when an enum variant with
fields is referenced without calling it, emit its tag as a constant
instead of requiring field arguments.

### 30. Resolver and typeck not yet dispatched through registry (PARTIALLY DONE)

**Severity:** medium (adding a feature still requires match arms in 2 central files)
**Impact:** The Feature struct has resolve_expr and check_expr handlers
but resolve_expr and check_expr in resolver.fg and typeck/mod.fg still
use hardcoded match statements. Features must add arms in both files.

**Progress:** Catch-all dispatch arms wired in resolver.fg, typeck/mod.fg,
and eval.fg. Match arms not yet extracted from core into features —
features can provide handlers but the explicit arms in core take priority.

**Proper fix:** Wire dispatch_expr_resolve and dispatch_expr_check into
the catch-all arms of resolve_expr and check_expr, same pattern as
codegen. Then features provide all handlers in one Feature struct and
the central files never need editing.

### ~~28-old. Registry dispatch is O(n) linked-list scan~~ (FIXED)
lookup. `forge_registry_set(tag, fn_ptr)` + `forge_registry_get(tag)`.
Only worth doing if the feature count exceeds ~100 or profiling shows
dispatch as a hotspot.

### ~~25. Duplicate keyword lists (scanner.fg + parse/mod.fg)~~ (FIXED)

**Status:** fixed (April 10 2026)
Deleted `keyword_kind` from `scanner.fg`. Scanner now calls
`p_keyword_kind` from `parse/mod.fg` — single source of truth.
New keywords only need to be added in one place.

### ~~24. Float arithmetic uses integer LLVM instructions~~ (FIXED)

**Status:** fixed (April 10 2026)
Float binary ops (+ - * / % == != < <= > >=) and unary negation now
use fadd/fsub/fmul/fdiv/frem/fcmp/fneg instructions. Int operands
are auto-promoted to float via sitofp when mixed with float.

### ~~32. Parser does file I/O directly~~ (FIXED)

**Status:** fixed (April 11 2026). The parser is now pure — `mod foo`
produces an unresolved `Stmt.Module("foo", StmtList.End)` stub. A
separate `resolve_module_files` pass in main.fg walks the AST, resolves
file paths, reads files, parses them, and attaches bodies. The parser
has zero I/O. Module deduplication is handled by a `LoadedPaths` set
threaded through the resolution pass.

### ~~33. No module deduplication~~ (FIXED)

**Status:** fixed (April 11 2026). Parser tracks loaded file paths in
a `LoadedPaths` linked list threaded through recursive sub-parsers.
When `parse_module_declaration` resolves a file that's already loaded,
it returns an empty `Stmt.Module` instead of re-parsing.

### ~~34. Type checker: implicit return type not checked~~ (FIXED)

**Status:** fixed (April 11 2026). `tc_check_fn_body` now calls
`tc_check_implicit_return` which uses `tc_body_tail_type` to get the
type of the last expression in the body and compares it against the
declared return type. Only flags concrete mismatches (skips Void and
Int fallback).

### 37. Name resolution uses globals instead of NameCtx parameter passing

**Severity:** medium (architectural, not correctness)
**Impact:** The seed's compiled `rewrite_expr(expr: Expr)` (1 parameter)
generates code that treats x1 (the second register) as the primary
value instead of x0. Disassembly shows:
```
stp x0, x1, [sp, #0x8]   ; stores BOTH x0 and x1
cbnz x1, ...             ; null check on x1, not x0!
ldr x8, [sp, #0x10]      ; loads x1's value as the expr pointer
```
When x1 happens to be a valid pointer (which it is for the globals
version because the caller's calling context leaves a valid value in
x1), the function works. When source changes alter the calling pattern
(parameter version), x1 is garbage → segfault.

**Root cause:** The bootstrap codegen's parameter binding generates code
that accesses the WRONG register for single-parameter functions. This
is likely an off-by-one in `bind_params_inline` or `forge_llvm_get_param`
indexing. Specifically, the LLVM IR for `rewrite_expr` shows `(i64 %0)`
(1 param) but the compiled ARM64 code uses x1 instead of x0.

**Proper fix:** Check `bind_params_inline` in `features/fn_decl/codegen.fg`
for the parameter index calculation. Also check if `llc -O2` is
reordering parameters or if the LLVM function type has a phantom
parameter. Compare the LLVM IR parameter count vs the ARM64 register
usage.

**Current status:** Globals-based name resolution works (x1 happens to
be valid). Parameter-passing version is architecturally better but
blocked by this codegen bug.

### ~~36. Map method codegen passes i64 instead of ptr~~ (FIXED)

**Status:** fixed (April 11 2026). Map method dispatch now converts
the receiver from i64 to ptr via `to_ptr(ctx, r.value, "map_ptr")`
before passing to `forge_map_*_cstr` C functions. The conversion is
done once at the top of the map method block, covering `.get`, `.has`,
`.set`, `.len`, `.keys`.

### ~~35. `export` can stack: `export export fn` double-wraps~~ (FIXED)

**Status:** fixed (April 11 2026). `export` now uses a match on the
next token kind and only accepts fn, type, enum, trait, extern, let,
mut — no recursive `parse_declaration` call, no stacking possible.

**Severity:** low (grammar enforcement)
**Impact:** `export export fn foo()` produces
`Annotated(@export, Annotated(@export, Function(...)))`. Not a crash
but not clean. The parser should reject double-export.

**Proper fix:** After consuming `export`, check that the next token
is NOT `export` before recursing into `parse_declaration`. Or: don't
recurse — call a restricted `parse_exportable_declaration` that only
handles `fn`, `type`, `enum`, `trait`, `extern`.

## Closed (previously from Rust host era)

Items 1–9 from the old TECH_DEBT.md related to the Rust host compiler
(List.push corruption, enum payload bugs, prescan limitations, etc.)
are **no longer relevant** — the bootstrap is fully self-hosted via
seed IR since April 9 2026. The Rust host compiler is not in the
build chain.
