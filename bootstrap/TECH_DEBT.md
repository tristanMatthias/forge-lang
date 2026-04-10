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

### 7. return not allowed in bare match arms

**Severity:** low
**Impact:** must wrap return in braces: `_ -> { return x }`

The parser rejects `_ -> return x` because match arm bodies expect
expressions and `return` is a statement. The braces workaround is
fine and doesn't hurt readability.

**Plan:** Fix the parser to accept statements in bare match arm
position. Low priority — the braces are idiomatic anyway.

### 8. Stmt.Return naming (was Ret)

**Severity:** none (RESOLVED)

Previously `Return` was renamed to `Ret` because the Rust host
compiler rejected it. Now resolved — variant is `Stmt.Return`.

### 9. DiagCode parallel match blocks

**Severity:** medium (DRY violation)
**Impact:** `diag_code_str` and `diag_code_help` are two separate match
blocks over the same enum, kept in sync manually

Currently each `DiagCode` variant requires editing two match blocks —
one for the code string (`"F0010"`) and one for the help text. Adding
a variant = 3 lines across 2 functions instead of 1.

**Fix:** Collapse into a single `error_def(code: DiagCode) -> ErrorDef`
match that returns `ErrorDef { code: string, help: string }`. One match,
each arm returns all metadata for that error on a single line. Blocked
on the current mid-refactor state — finish wiring `DiagCode` enum into
parser/resolver first, then collapse.

### 10. Forge needs associated enum data

**Severity:** medium (language gap)
**Impact:** forces the parallel-match pattern above

Forge enums can't carry static metadata per variant. Rust has
`impl DiagCode { fn help(&self) -> &str { match self { ... } } }` and
Swift has computed properties on enum cases. Forge has neither — you
must write a standalone function with a match. This is the root cause
of debt item #9. Eventually the language should support one of:

- `impl` on enums with `self` dispatch (already parsed, not codegen'd for enums)
- Static associated data: `enum Thing { Value { label: "x" } }`
- Derive-style attribute: `@display enum DiagCode { ... }`

**Plan:** Add enum impl codegen support (we already parse `impl EnumName`).
Then `diag_code_str` and `diag_code_help` become methods on `DiagCode`.

### 11. render_diagnostic crashes on bad input

**Severity:** high (blocks bootstrap)
**Impact:** any diagnostic with a dummy span or corrupt data crashes
the entire compiler. This blocked the type checker bootstrap for 30+
minutes across multiple seed cycles.

Three compounding bugs:
1. `render_diagnostic` crashes when `col == 0` (substring with negative index)
2. `render_list` stack-overflows on 100+ diagnostics (recursive linked list)
3. Parse/resolve errors masked by crash — can't see the real error

**Fix:** Make `render_diagnostic` crash-proof. Guard every field access.
Use iterative rendering (or hard limit). Add a C-side `forge_safe_render`
that catches SIGSEGV and prints a fallback message.

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

### 13. Dotted types not supported in parameters

**Severity:** low (easy workaround)
**Impact:** `fn foo(x: core.ast.BinOp)` fails to parse. Must import
the type first: `use core.ast.{BinOp}` then `fn foo(x: BinOp)`.

**Fix:** Support dotted type names in `consume_type` parser function.
Low priority since the import workaround is clean.

### ~~14. Struct args corrupt second parameter~~ (FIXED)

**Status:** fixed (April 10 2026)

**Root cause:** The bootstrap's calling convention passes structs as
single i64 pointers. When a function takes two struct arguments (e.g.
`bind_params(tc: TC, params: ParamList)`), the function prologue
clobbers the register holding the second argument while accessing
fields of the first struct via GEP. This only happens when the first
struct has 6+ fields.

**How it was found:** LLDB showed `params` was valid at the call site
(`forge_selfhost_trace_int` printed the correct pointer) but garbage
inside `bind_params`. Inlining the function body eliminated the crash,
confirming the bug was at the function call boundary, not in the logic.

**Fix:** Inlined `bind_params` into the Function arm of `check_stmt`.

**Proper fix needed:** The codegen should use LLVM's `byval` attribute
or splat struct fields into separate arguments. See item #16.

### 16. Two-struct-arg calling convention bug (SYSTEMATIC)

**Severity:** high (any function with two struct args is at risk)
**Impact:** the second argument is silently corrupted when the first
is a large struct (6+ fields accessed via GEP)

**Known affected patterns:**
- `fn foo(tc: TC, params: ParamList)` — TC has 6 fields
- Any function taking `(Ctx, ...)` where Ctx has 12 fields
  (these work because Ctx fields are accessed via the pointer
  directly, but fragile)

**Audit needed:** grep for all functions that take two struct arguments
where the first struct has 4+ fields. These are all potential crash sites.

**Proper fix:** Change the codegen to either:
1. Use LLVM `byval` attribute on struct pointer args
2. Splat struct fields into separate register arguments (C ABI)
3. Always pass structs via explicit alloca (caller allocates on stack,
   callee receives pointer, guaranteed not to alias registers)

**Audit command:**
```bash
grep "fn.*tc: TC.*params:\|fn.*ctx: Ctx.*env:" src/**/*.fg
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

## Closed (previously from Rust host era)

Items 1–9 from the old TECH_DEBT.md related to the Rust host compiler
(List.push corruption, enum payload bugs, prescan limitations, etc.)
are **no longer relevant** — the bootstrap is fully self-hosted via
seed IR since April 9 2026. The Rust host compiler is not in the
build chain.
