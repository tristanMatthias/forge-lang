# Self-Hosting Status & Next Steps

## ⚠️ MANDATORY APPROACH: DIFF-DRIVEN BUG HUNTING ⚠️

**Read this first. Do not skip. Do not improvise a different approach.**

Every bug remaining in the stage 2 → stage 3 pipeline manifests as a
**divergence between rust-emitted IR and self-hosted-emitted IR for the
same source function**. Stage 1 IR (rust-emitted) and stage 2 IR
(self-hosted-emitted) should be byte-for-byte equivalent. They aren't.
**Every place they differ is exactly one bug.**

The two compilers (rust codegen and self-hosted codegen) MUST emit
equivalent IR for the same source. Any divergence is the bug surface.

### The ONLY workflow that's allowed for self-hosting work

1. **Pick ONE function that's broken in stage 3 IR.** Start with the
   smallest, most-called function (`Codegen_emit_binary`,
   `Codegen_emit_ident`, `Codegen_emit_call`).
2. **Diff stage 1 IR vs stage 2 IR for that function**:
   ```bash
   # Make sure both IR files are fresh:
   ./target/release/forgec build packages/forgec/src/main.fg --dev --emit-ir > /tmp/stage1.ll
   ./build/stage1_rust build packages/forgec/src/main.fg   # writes /tmp/stage1_output.ll
   bash scripts/diagnose.sh --diff <fn_name> /tmp/stage1.ll /tmp/stage1_output.ll
   ```
3. **Read the diff. The diff IS the bug.** It will show exactly which
   instructions stage 2's runtime emit dropped, replaced with `undef`,
   constant-folded to `false`, or substituted with `i64 0`.
4. **Identify the source pattern in `mod.fg`** that produces the
   divergent instruction. Usually it's a method call (`self.X(...)`),
   an enum destructure, a generic return type, or a namespace method.
5. **Fix the rust codegen path** that compiles that pattern. ONE fix
   typically unblocks 10-50 broken sites because the same pattern is
   used everywhere in `mod.fg`.
6. **Re-run the diff.** The function should now be byte-equivalent.
   If it still diverges, you fixed the wrong thing.
7. **Re-run the full pipeline.** Stage 3 IR should have meaningfully
   fewer `br i1 false`, `undef args`, and `ret undef` instructions.
   Score should drop noticeably.
8. **Commit. Repeat from step 1 with the next broken function.**

### Why diff-driven, not runtime-driven

- Runtime crashes (segfaults, "garbage value", "wrong tag") are
  **symptoms**, not bugs. They tell you the cascade has reached a
  failure point but not where the cascade started.
- The IR diff shows the cascade origin directly. No bisection. No
  eprintln tracing. No lldb sessions.
- Bugs cluster: one rust codegen path generates ~30 broken sites in
  mod.fg. Fixing it once fixes all 30.
- Each iteration is bounded: a function diff is ~100 lines you can
  read in 2 minutes.

### Anti-patterns that have wasted entire sessions

- ❌ Adding `eprintln!` to runtime code paths to bisect what's failing
- ❌ Running stage 3 in lldb and looking at register values
- ❌ Writing minimal test programs and hoping they reproduce the bug
- ❌ Adding C-side workaround functions to bypass codegen issues
- ❌ Trusting "stage 3 builds ✓" from `diagnose.sh` (it had a stale
  artifact bug — fixed in commit `4b82f02`, but be paranoid)
- ❌ Claiming progress before running stage 3 on a real test file and
  verifying the output

### What success looks like

After each diff-fix iteration, the divergence count for that one
function should drop to zero. After 5–10 iterations, stage 2 IR ≡
stage 1 IR for the entire codegen module. At that point stage 2 → stage
3 will produce IR that's also equivalent, llc will succeed, and stage 3
will actually compile programs.

**There is no shortcut that hasn't already been tried and failed.**
Mini approach failed. Inline-rewriting failed. Runtime bisection failed.
Diff-driven is what's left.

---

## Current State (latest commit: `55261f4`)

**Stage 3 compiles and runs hello world end-to-end.** Full pipeline:
```
Rust compiler → Stage 2 binary (2.3 MB)
Stage 2       → Stage 3 binary (1.98 MB)
Stage 3       → /tmp/hello3 → prints "Hello from Stage 3!"
```

**Stage 3 does NOT yet fully self-compile main.fg.** Crashes in `Codegen_emit_match_arms` at `forge_value_type_kind+228` while compiling `severity_to_string` (and any function whose body is a match on an enum-valued parameter).

## Build Commands

LLVM 19 is required (inkwell 0.7 uses `llvm19-1`). `.cargo/config.toml` sets `LLVM_SYS_191_PREFIX`.

```bash
cd forge/

# Rust compiler
cargo build --release

# Stage 2 (Rust-compiled self-hosted compiler)
./target/release/forgec build packages/forgec/src/main.fg --emit-ir > /tmp/stage1_ir.ll
/opt/homebrew/opt/llvm@19/bin/llc -O2 -filetype=obj /tmp/stage1_ir.ll -o /tmp/stage2.o
cc -c -O0 stdlib/runtime.c -o build/runtime.o
cc -o /tmp/stage2 /tmp/stage2.o build/runtime.o \
   packages/std-process/target/release/libforge_process.a \
   -lm -Wl,-stack_size,0x10000000 \
   packages/std-llvm/target/release/libforge_llvm.a \
   -L/opt/homebrew/Cellar/llvm@19/19.1.7/lib -lLLVM-19 -lstdc++ -lz -lcurses

# Stage 3 (Stage-2-compiled self-hosted compiler)
/tmp/stage2 build packages/forgec/src/main.fg /tmp/stage3

# Sanity: Stage 3 compiles hello world
cat > /tmp/hello.fg <<'EOF'
fn main() { println("Hello from Stage 3!") }
EOF
/tmp/stage3 build /tmp/hello.fg /tmp/hello3
/tmp/hello3   # prints: Hello from Stage 3!
```

## What Works

1. Stage 2 compiles main.fg into a working Stage 3 binary (llc clean, no link errors)
2. Stage 3 parses, scans, tokenizes, emits IR, and invokes `llc`/`cc` as subprocesses
3. `fn main() { println(...) }` — the classic single-statement body — round-trips fully
4. Enum constructors for the codegen-registered enums (`Expr`, `Statement`, `BinOp`, `UnaryOp`) build proper tagged structs
5. Named `Nullable_<T>` types are used consistently — no more anon-vs-named mismatches dropping `ret` to `undef`
6. `return null` from a `ptr`-typed function emits `ret ptr null`
7. `build_ret` / `build_br` / `build_cond_br` guard against double-terminator bugs
8. process.run is a real fork/exec and handles `List<string>` args

## THE BLOCKER: Stage 3 can't compile `match x` on enum-valued params

Reproduce with the smallest possible test:

```forge
// /tmp/match_test.fg
enum Color { Red Green }
fn name(c: Color) -> string {
    match c {
        .Red -> "red"
        .Green -> "green"
    }
}
fn main() { println(name(Color.Red)) }
```

Running `/tmp/stage3 build /tmp/match_test.fg /tmp/match_test`:

```
  [TOK] done name tokens=21
  [BODY] name
Backtrace:
0   stage3 ... forge_signal_handler + 464
1   libsystem_platform.dylib ... _sigtramp + 56
2   stage3 ... forge_value_type_kind + 228
3   stage3 ... Codegen_emit_match_arms + 1392
4   stage3 ... Codegen_emit_expr_inner + 1940
5   stage3 ... emit_fn_body_from_source + 1240
```

### Root Cause

In `packages/forgec/src/codegen/mod.fg` `emit_match_arms` (~line 2046):
```forge
let subj_raw = self.emit_expr(scrutinee)
...
let val_kind = forge_value_type_kind(subj_raw)   // CRASH: subj_raw is garbage
```

`subj_raw` is a non-null but **invalid** LLVMValueRef. `forge_value_type_kind` → `LLVMTypeOf(val)` dereferences it → segfault. Confirmed: inserting `forge_trace_i64(8888, subj_raw)` one line earlier prevents the crash but makes the output wrong — i.e. the value reaching the call is already garbage.

**Where the garbage comes from** (this is the fundamental bug, not a workaround target):

The outer `match expr { ... .MatchExpr(scrutinee, arms, span) -> ... }` in `emit_expr_inner` is compiled by the **Rust compiler** (it's building Stage 2 from source). The Rust compiler's enum destructure for **self-referential boxed fields** creates a binding alloca of the wrong size:

Stage 3 IR (`/tmp/s3main.ll`) for that arm shows:
```llvm
%22 = alloca i64, align 8                           ; scrutinee alloca — only 8 bytes
...
%347 = extractvalue %Expr %expr, 1                  ; boxed pointer slot
store i64 %347, ptr %22, align 4
...
%reload144 = load %Expr, ptr %22, align 4           ; loads 112 bytes from an 8-byte alloca
%358 = call i64 @Codegen_emit_match_arms(ptr %0, %Expr %reload144, ...)
```

`load %Expr, ptr %22` reads 112 bytes from an `i64` alloca — overflowing into adjacent stack slots. The resulting `%reload144` is garbage, passed into `emit_match_arms` as the scrutinee, then flows into `emit_expr → emit_ident("c") → forge_value_type_kind(garbage_ptr) → segfault`.

The Rust compiler's `extract_enum_variant_fields`
(`packages/forgec-rust/features/pattern_matching/codegen.rs:467`) DOES
have an inttoptr+load unbox path for `boxed_fields`, but it isn't reaching
this destructure — either because:
  (a) `bind_pattern_vars` isn't the codepath used here, OR
  (b) the variant's `boxed_fields` list is empty for `MatchExpr` at the
      point where the destructure is compiled, OR
  (c) `create_entry_block_alloca` receives the stub `Type::Enum { name: "Expr", variants: vec![] }` and `type_to_llvm_basic` falls through to `i64_type()` because `enum_types.get("Expr")` returns `None` at that moment (circular type registration order).

### Next Agent: Debugging Playbook

1. **Confirm the alloca type.** Grep `/tmp/s3main.ll` for the outer `match expr` destructure:
   ```
   grep -n "Codegen_emit_match_arms" /tmp/s3main.ll
   ```
   Find the caller (bb with `call i64 @Codegen_emit_match_arms(...)`) and look at how its scrutinee alloca was created. If `alloca i64`, confirm the bug.

2. **Find where the alloca is emitted.** Add an `eprintln!` in
   `packages/forgec-rust/features/pattern_matching/codegen.rs`:
   - In `bind_pattern_vars` Pattern::Ident arm: log `name, subject_type,
     llvm_ty_of_alloca` for `name == "scrutinee"`.
   - In `extract_enum_variant_fields`: log the incoming variant's
     `boxed_fields` and the resolved `full_type` for each boxed field.

3. **Check `enum_types` registration order.** If `enum_types.get("Expr")`
   returns `None` during emit_expr_inner compilation, the issue is that
   Expr's full variants aren't yet registered when bind_pattern_vars runs.
   Fix: register all enum types in a first pass before compile_fn runs.

4. **Verify the fix.** After the fix, the destructure IR should show:
   ```llvm
   %22 = alloca %Expr, align 8                       ; full struct alloca
   ...
   ; OR: unbox via inttoptr + load
   %ptr = inttoptr i64 %field_val to ptr
   %loaded = load %Expr, ptr %ptr, align 4
   store %Expr %loaded, ptr %22
   ```

5. **Run the match_test repro.** Both `/tmp/match_test` and the full
   main.fg self-compile should succeed.

## Fundamental Fixes Already In (commit `55261f4`)

These are all **real fixes**, not workarounds. Don't regress them:

### Rust compiler (`packages/forgec-rust/`)
- **`expressions.rs` `Expr::NullLit`** is target-type-aware: emits `ptr
  null` for `ptr` slots, proper `Nullable_T` for nullable slots, legacy
  `{i8,i64}` fallback only when no target. Uses priority:
  `struct_target_type` → `json_parse_hint` → `current_fn_return_type`.
- **`statements.rs` `Statement::Let`**: promotes any type annotation
  (not just `Type::Struct`) to `struct_target_type`.
- **`features/variables/codegen.rs` `compile_mut_var`**: same hint setup
  for `mut x: T = ...` so NullLit sees the target.
- **`codegen/codegen/types.rs`**: `type_references_struct` helper breaks
  self-referential struct cycles by substituting `ptr` for fields that
  recursively reference the containing struct (`Scope.parent: Scope?`).
- **`statements.rs` implicit return**: `int → ptr` coercion via
  `int_to_ptr` when the function returns `ptr` but the last value is i64.
- **`features/functions/codegen.rs` `coerce_value`**: handles `int↔ptr`
  coercion so C functions returning handles as `i64` can be returned
  from `ptr`-typed Forge functions.

### Self-hosted codegen (`packages/forgec/src/codegen/mod.fg`)
- **`make_nullable_type`** returns the NAMED `%Nullable_<T>` when the
  inner is a named struct — matches what `declare_all_fns` registers for
  function returns. Single source of truth. This is what made parser
  functions stop silently returning `undef`.
- **`coerce_to_fn_return(val)`** helper: one place for
  "wrap-or-pass-through or typed-null fallback" logic. Used by
  `emit_ret_value`, `emit_if_expr`, `emit_match_arms`, and the implicit
  return path in `features/functions/mod.fg` `emit_fn_body_from_source`.
- **`emit_member_access` `.length`** uses `extractvalue` field 1
  directly for any 2-field struct value. Sidesteps the
  `forge_string_length` named-vs-anonymous coercion bug for List values.
- **`emit_call` enum constructor**: `TypeName.Variant(args)` for the
  struct-represented enums (`Expr`, `Statement`, `BinOp`, `UnaryOp`)
  now builds a named enum struct via alloca + tag store + per-field
  stores at correct slot offsets. For boxed (`"p"`-typed) struct fields
  like `Expr.Call(callee: Expr, ...)`, heap-allocates the value and
  stores the pointer so aggregates don't overflow into adjacent slots.
- **`emit_pattern_bindings`** unboxes `"p"`-typed boxed fields: looks up
  the per-field type name registered by the parser, inttoptr → load the
  actual struct value, and binds under the real type. This is what
  makes self-hosted `match x { .Variant(field) -> ... }` work when
  `field` is a boxed struct. Note: this only applies to SELF-HOSTED
  match arms. The outer `match` inside `emit_expr_inner` is compiled by
  the Rust compiler, which is where the current blocker is.

### std-llvm (`packages/std-llvm/src/lib.rs`, `package.fg`)
- **`forge_llvm_build_br` / `build_cond_br` / `build_ret`** skip when the
  current block already has a terminator. LLVM-idiomatic guard that
  prevents `emit_return` inside if/match arms from having its `ret`
  silently dropped by a subsequent `br` to the merge block.
- **`forge_llvm_get_struct_name_s`** (in `runtime.c`) wraps
  `LLVMGetStructName` and returns a `ForgeString`. Declared in
  `package.fg` so `llvm.get_struct_name(ty)` resolves in the
  self-hosted codegen — this is what `make_nullable_type` uses to
  derive `Nullable_<T>` from the inner struct's name.

### Runtime (`stdlib/runtime.c`)
- **`forge_selfhost_process_run`** is now a real fork/exec. Treats its
  second arg as a `List<string>` (ABI-compatible with `{ptr, i64}`
  pointing to an array of ForgeStrings), builds `argv`, and calls
  `execvp`. Previously a stub returning `{"code":0}`.

### `main.fg`
- `build_compile_separate` link command now includes the std-process +
  std-llvm + LLVM 19 libs so self-hosted output actually links.
- `parse_list_literal` collects elements and calls `make_list_lit`
  (was a stub returning an empty block, dropping every argument list).

## LLVM 18 → 19 Migration

Already done in commit `91a5f9b`. Key points:
- `inkwell = "0.7"` with `features = ["llvm19-1"]`
- `/opt/homebrew/opt/llvm@19/` (19.1.7)
- `.cargo/config.toml` sets `LLVM_SYS_191_PREFIX`
- Makefile, diagnose.sh, std-llvm/build.rs all point at llvm@19
- `main.fg`'s hardcoded llc path updated to `/opt/homebrew/opt/llvm@19/bin/llc`

## Diagnose Tools

```bash
bash scripts/diagnose.sh --score /tmp/stage1_ir.ll   # IR quality (lower = better)
bash scripts/diagnose.sh --stage2                    # Stage 2 functional tests
bash scripts/diagnose.sh --stage3                    # Stage 3 functional tests
bash scripts/diagnose.sh --kind-ids                  # Kind ID consistency
```

## Hard Rules (unchanged)

1. **No workarounds.** If the root cause is in the Rust compiler, fix it
   there. If it's in the self-hosted codegen, fix it there. Don't
   rewrite source to avoid the bug.
2. **No method().field chains** in Forge source that the Rust compiler
   compiles for self-host — they silently drop the method call. Use
   helper methods or split into two lines. (This constraint exists
   because the Rust compiler still has a chained-field bug.)
3. **Single source of truth.** If the same type decision appears in
   three places, extract it (see `coerce_to_fn_return`,
   `make_nullable_type`).
4. **Run after every change:**
   ```bash
   cargo build --release && \
     ./target/release/forgec build packages/forgec/src/main.fg --emit-ir > /tmp/stage1_ir.ll && \
     /opt/homebrew/opt/llvm@19/bin/llc -O2 -filetype=obj /tmp/stage1_ir.ll -o /tmp/stage2.o && \
     cc -o /tmp/stage2 /tmp/stage2.o build/runtime.o \
        packages/std-process/target/release/libforge_process.a -lm \
        -Wl,-stack_size,0x10000000 \
        packages/std-llvm/target/release/libforge_llvm.a \
        -L/opt/homebrew/Cellar/llvm@19/19.1.7/lib -lLLVM-19 -lstdc++ -lz -lcurses && \
     /tmp/stage2 build packages/forgec/src/main.fg /tmp/stage3 && \
     /tmp/stage3 build /tmp/hello.fg /tmp/hello3 && /tmp/hello3
   ```
   Should print `Hello from Stage 3!` — if not, something regressed.

## Immediate Next Steps

1. **Fix the destructure alloca size bug** for boxed self-ref enum
   fields in the Rust compiler (see "Debugging Playbook" above). Once
   `/tmp/match_test` runs, main.fg self-compile will likely unblock.
2. **Rerun self-compile**: `/tmp/stage3 build packages/forgec/src/main.fg /tmp/stage4`. Expected: produces `/tmp/stage4` binary.
3. **Fixed-point check**: `/tmp/stage4 build packages/forgec/src/main.fg /tmp/stage5` and `diff /tmp/forgec_out.ll` between stages 3→4 and 4→5. Once identical, we have M7 (fixed point).

## File Map

| File | Role |
|------|------|
| `packages/forgec/src/codegen/mod.fg` | Self-hosted codegen (THE file to audit / modify for self-host fixes) |
| `packages/forgec/src/parser/mod.fg` | Self-hosted parser |
| `packages/forgec/src/parser/expressions.fg` | Expression parser |
| `packages/forgec/src/features/functions/mod.fg` | Function declaration + body emission (includes nullable return flag setup) |
| `packages/forgec/src/features/collections/mod.fg` | List/Map literal dispatch — `emit_collection` wires list_lit to `emit_list_literal` |
| `packages/forgec/src/features/if_else/mod.fg` | if/else codegen — uses `coerce_to_fn_return` for both branches |
| `packages/forgec/src/core/kind_ids.fg` | Token kind_id constants (single source of truth) |
| `packages/forgec-rust/codegen/codegen/expressions.rs` | Rust compiler expression codegen (NullLit lives here) |
| `packages/forgec-rust/codegen/codegen/statements.rs` | Rust compiler statement codegen (Let/Mut handling) |
| `packages/forgec-rust/features/pattern_matching/codegen.rs` | Rust compiler match codegen (**current blocker lives here** — `bind_pattern_vars` / `extract_enum_variant_fields`) |
| `packages/forgec-rust/features/enums/checker.rs` | Enum type checker — where `boxed_fields` is computed |
| `packages/forgec-rust/features/variables/codegen.rs` | Let/Mut via feature dispatch path |
| `stdlib/runtime.c` | C runtime (selfhost_process_run, alloca cache, forge_value_type_kind, etc.) |
| `packages/std-llvm/src/lib.rs` | Rust extern LLVM bindings (terminator-guarded build_br/ret live here) |
| `packages/std-llvm/src/package.fg` | Forge extern declarations for LLVM bindings |
| `scripts/diagnose.sh` | All diagnostics |
