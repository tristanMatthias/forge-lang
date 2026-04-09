# Tech Debt

Active debt in the bootstrap compiler. Each item has a plan.

## Open

### 1. libforge_llvm.a dependency (Rust LLVM wrapper)

**Severity:** medium
**Impact:** requires Rust toolchain to rebuild the LLVM wrapper library

The bootstrap calls LLVM via `forge_llvm_*` functions that live in
`libforge_llvm.a` — a Rust-compiled wrapper around LLVM's C API. This
library has internal callbacks that expect certain C functions to exist,
which we satisfy with no-op stubs in `runtime.c`.

**Current state:**
- The `.a` file is pre-built and works
- 11 stub functions in runtime.c satisfy the linker
- The bootstrap never calls these stubs at runtime

**Plan:** Write `bootstrap/llvm_wrapper.c` (~200 lines) that calls
LLVM's C API directly (`LLVMBuildAdd`, `LLVMBuildAlloca`, etc.).
Drop `libforge_llvm.a` entirely. This makes the bootstrap depend
only on LLVM 19 + a C compiler — no Rust at all.

### 2. String type tags (ty: string)

**Severity:** medium
**Impact:** fragile CSV parsing, no type safety, runtime errors on typos

Types are encoded as strings: `"i64"`, `"str"`, `"enum:Name"`,
`"struct:Name"`, `"tuple:ty1,ty2"`, `"list"`. This means:
- Typos in type tags are silent runtime bugs
- Nested tuple types require CSV parsing
- No exhaustiveness checking

**Plan:** Replace `ty: string` with a `ValueType` enum. This is a
large refactor that touches every emit function. Do it before
feature #20.

### 3. Operator string dispatch

**Severity:** low
**Impact:** O(k) string comparisons per binary expression

Binary operators are stored as strings (`"+"`, `"=="`, etc.) and
dispatched via cascading `if operator == "+"` checks. At 30+
operators this becomes measurable.

**Plan:** Parse-time conversion to a `BinaryOp` enum. Quick refactor,
do before adding bitwise operators.

### 4. Recursive enum lists instead of real collections

**Severity:** low (cosmetic)
**Impact:** ExprList, StmtList, ParamList, VarEnv are linked lists

The AST uses recursive enums (e.g. `ExprList.Node(expr, next)`)
instead of the `List` we just built. This was because the Rust host
compiler's `List.push()` was broken. Now that we have our own
`forge_array_*` runtime, we COULD migrate — but the recursive
enums work fine for AST sizes. Not urgent.

**Plan:** Consider migrating when/if performance matters. The linked
lists are actually idiomatic for immutable scope stacks (VarEnv).

### 5. return not allowed in bare match arms

**Severity:** low
**Impact:** must wrap return in braces: `_ -> { return x }`

The parser rejects `_ -> return x` because match arm bodies expect
expressions and `return` is a statement. The braces workaround is
fine and doesn't hurt readability.

**Plan:** Fix the parser to accept statements in bare match arm
position. Low priority — the braces are idiomatic anyway.

### 6. Stmt.Return naming (was Ret)

**Severity:** none (RESOLVED)

Previously `Return` was renamed to `Ret` because the Rust host
compiler rejected it. Now resolved — variant is `Stmt.Return`.

## Closed (previously from Rust host era)

Items 1–9 from the old TECH_DEBT.md related to the Rust host compiler
(List.push corruption, enum payload bugs, prescan limitations, etc.)
are **no longer relevant** — the bootstrap is fully self-hosted via
seed IR since April 9 2026. The Rust host compiler is not in the
build chain.
