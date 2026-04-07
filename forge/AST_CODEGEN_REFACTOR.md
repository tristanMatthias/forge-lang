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

## Current State (commits 6fe03f3, 21259e3 on `feat/mini-compiler`)

**Stage 3 builds, links, runs, and exits 0**, score **43** (best ever).
**Stage 1_rust and Stage 2 binary now correctly handle `command == "build"`**
end-to-end: stage 2 binary scans, parses, and runs the build path on
real source files. **Stage 3 main()** still emits only the trace lines
and returns — the actual blocker (now firmly diagnosed) is described
in "THE BLOCKER" below.

```
Rust compiler → Stage 1 binary (build/stage1_rust)        ✅ runs build path
Stage 1       → output.ll = Stage 2 IR                     ✅ score 80
llc + cc      → /tmp/stage2_bin                            ✅ runs build path
/tmp/stage2_bin → /tmp/output.ll = Stage 3 IR              ✅ score 43, 388 fns
llc + cc      → a.out (stage 3 binary)                     ✅ exits 0
```

`make test-stage1` (hello world end-to-end through stage 2) passes.

```
Rust compiler → Stage 1 binary (build/stage1_rust)        ✅
Stage 1       → output.ll = Stage 2 IR                     ✅ score 48
llc + cc      → /tmp/stage2 binary                         ✅
/tmp/stage2   → /tmp/output.ll = Stage 3 IR                ✅ 388 fns
llc + cc      → /tmp/stage3 binary                         ✅ exits 0
```

`make test-stage1` (hello world end-to-end through stage 2) passes.

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

## THE BLOCKER (UPDATED 2026-04-07): rust compile_match arm-body lost when arm body is `if k == "..." { ... } else { ... }`

The previous "nested match-as-block-tail" diagnosis was symptom-level.
After fixing two pattern_tag bugs (commits 6fe03f3, 21259e3) the deeper
bug was uncovered via diff:

```bash
bash scripts/diagnose.sh --diff Parser_token_to_binop_key /tmp/stage1.ll /tmp/stage1.ll
```

In **stage 1 IR (rust-emitted)** for `Parser_token_to_binop_key`, every
match arm body — `if k == "Pipe" { "Pipe" } else { "" }` etc. — is
emitted as **orphan blocks** (`No predecessors!`). The arm dispatch
blocks (`bb995`, `bb997`, `bb999`, …) are all empty `br merge` or store
the wrong value (e.g., `store i64 %level, ptr %16`). The actual
`forge_string_eq` calls live in unreachable blocks.

**Result**: `token_to_binop_key` ALWAYS returns the empty string. So
`parse_binary_level` never recognizes any operator. Every `==`, `!=`,
`<`, `&&`, `||` etc. in main.fg silently parses as just the LHS.
That's why every comparison disappears in stage 3 IR — and why all
if-bodies look empty (the parsed bodies are real, but the conditions
are wrong, and stage-2-binary's `emit_if` falls back to truthy on the
LHS struct).

This is **the** root cause for the entire remaining cascade. Fix this
one bug in the rust compiler's `compile_match` and stage 3 should jump
to a near-functional state.

### Where to look

`packages/forgec-rust/features/pattern_matching/codegen.rs` `compile_match`
around lines 226-308. The arm body emission:
```rust
self.builder.position_at_end(arm_bb);
self.push_scope();
self.bind_pattern_vars(...);
let arm_val = self.compile_expr(&arm.body);   // ← arm body is an if-expr
self.pop_scope();
let arm_end_bb = self.builder.get_insert_block().unwrap();
```

When `arm.body` is `if k == "Pipe" { "Pipe" } else { "" }`:
1. `compile_expr` → `compile_if_feature` → `compile_if`
2. `compile_if` calls `compile_expr(condition)` to emit the string
   equality call. This SHOULD land in `arm_bb`. **It does not** — it
   ends up in an orphan block.
3. The cond_br + then/else/merge that follows the condition all hang
   off that orphan block, so the entire if-expression is unreachable.
4. `compile_match` sees `arm_end_bb = builder.get_insert_block()` =
   the orphan merge, sees no terminator, emits `br merge_bb` — but
   `arm_bb` itself stays empty.

### THE REAL ROOT CAUSE (CONFIRMED 2026-04-07c via runtime tracing)

Instrumented `emit_match_arms`'s for-loop with `forge_trace_i64`
of an `iter_count` (incremented inside the loop). Result: a single
`emit_match_arms` invocation runs **72 iterations** when the source
match has at most ~12 arms. Tag values are `1, -1, -2, -1, -1, 2,
-1, -2, -1, -1, 3, -1, -2, -1, -1, ...` — the source's real arms
(int literals 1, 2, 3, ...) interleaved with 4 junk arms each
(`-1, -2, -1, -1`).

**`List<MatchArm>` is corrupted.** The `arms: List<MatchArm>` parameter
arrives at `emit_match_arms` containing real arms padded with 4 junk
arms per real arm. The for loop dutifully processes all 72, creating
72 `arm_bb`/`next_bb` pairs. The first real arm's body lands in the
first arm_bb correctly (bb995); the remaining 71 iterations process
garbage and emit dispatch + bodies into blocks that no real edge
points to → "No predecessors!" orphan blocks.

This is a **list/Statement-stride bug**, not a builder-position bug.
Per the existing CLAUDE.md "112-byte Statement stride" notes, the
List<T>.push() implementation has had stride bugs for non-16-byte
elements. `MatchArm` is also a multi-field struct.

### Where to look next

1. `forge_list_push` in `stdlib/runtime.c` — verify the element-size
   handling for items larger than 16 bytes (Statement is 112 bytes,
   MatchArm size is similar).
2. `Parser_parse_match_arms` (or wherever `MatchArm` lists are built)
   — print `arms.length` immediately after parsing to confirm the
   junk inflation happens at parse time, not at codegen time.
3. The `match X { .Y -> ... }` patterns in `emit_pattern_bindings`
   and `emit_match_arms` themselves use `MatchArm` lists indirectly
   via `arm.pattern` extraction. The `MatchArm` struct layout in
   the rust compiler vs the self-hosted compiler may have a stride
   mismatch that propagates into List<MatchArm> reads.
4. Fix the list corruption at the source — once 72 → 12, every
   `match` in stage 3 IR should immediately become correct.

### (HISTORICAL) Earlier hypotheses

**Initial guess (WRONG)**: that `emit_pattern_bindings`'s internal
`match pat { ... }` repositioned `CG_B`. **Verified false**: that match
is compiled into LLVM if-else by the rust compiler at compile time;
running it doesn't touch `CG_B`. Adding `position_at_end(arm_bb)` after
`emit_pattern_bindings` had zero effect on the produced IR — the bug
is NOT there.

**Confirmed observations**:
- Stage 1 IR (rust-emitted) for `Parser_token_to_binop_key` is
  CORRECT and clean (no orphans, proper if-then-else, working
  string equality dispatch).
- Stage 2 IR (self-host-emitted) for the same function has all arm
  bodies orphaned — `bb995` (arm 1 body) is empty `br merge`, while
  the actual `forge_string_eq` for `"Pipe"` lives in `bb998`
  (No predecessors!).
- The SECOND arm's dispatch icmp is also in an orphan block
  (`bb1004: No predecessors!`), meaning the builder lost its
  position between iterations of the `for arm in _arms` loop in
  `Codegen_emit_match_arms`.

**Where to look next**:
- Something between iteration N's `position_at_end(next_bb)` and
  iteration N+1's `build_icmp(...)` is repositioning `CG_B`. The
  candidates are: the `for` loop latch (rust-compiled), `cg_reinit_types()`,
  `append_basic_block` ×2, and `self.pattern_tag(...)`.
- `pattern_tag` makes string concatenations and calls
  `match_enum_tag()` — none of these *should* touch `CG_B` directly,
  but pattern_tag goes through nested matches that may have their
  own indirect effects via the alloca cache or register state.
- Worth instrumenting: print `forge_value_type_kind(llvm.get_insert_block(CG_B))`
  before AND after `self.pattern_tag(...)` to see if it changes.
- Worth checking: is it possible the `for arm in _arms` for-loop
  body, when compiled by the rust compiler, allocates per-iteration
  scratch state in the user's IR by accident?

### Smallest repro

`packages/forgec/src/parser/expressions.fg:50` `token_to_binop_key`:
```forge
fn token_to_binop_key(self, level: int) -> string {
    let k = forge_kind_id_to_key(self.peek_kind_id())
    match level {
        1  -> if k == "Pipe" { "Pipe" } else { "" }
        2  -> if k == "Or" { "Or" } else { "" }
        ...
    }
}
```

After fixing, diff `Parser_token_to_binop_key` between stage 1 IR and a
clean reference — it should produce a working dispatch chain.

---

## (Historical) Earlier diagnosis: nested match-as-block-tail value loss

Stage 3's main() reaches `if command == "build"` and falls through to
neither branch (both go to merge → ret 0). Tracing this all the way down
through the cascade lands on a real bug in the **rust compiler's**
`compile_match` for the case where a `match` expression is the *last
expression of an arm body block*. The inner match's result isn't being
propagated as the outer arm's value.

### Repro / verification (already done — do not repeat)

Add an `eprintln` inside `Codegen.pattern_tag`'s `.Literal(value)` arm
in `packages/forgec/src/codegen/mod.fg` AND another at the call site
in `emit_match_arms`. Rebuild and run on main.fg:

```
[ptg_str_inner] StringLit list_lit       ← inner .StringLit arm fires
[ema_str] tag=0 scrut_type=string         ← but the value reaching
                                            emit_match_arms is 0, not -2
```

So pattern_tag's source body says `-2`, the inner `match value { .StringLit -> -2 }`
arm executes, **but the value bubbling out of the outer
`.Literal(value) -> { match value { ... } }` block is `0`, not `-2`**.

This holds for *every* string-literal pattern arm in main.fg. None of
them ever propagate `-2` to `emit_match_arms`. The cascade:

```
pattern_tag returns 0 instead of -2
  ↓
emit_match_arms takes the `else` branch (treating tag 0 as enum tag)
  ↓
emits `icmp eq i64 %subj, 0`  (instead of forge_string_eq)
  ↓
for non-null kind_name strings the comparison is FALSE
  ↓
wildcard arm taken → emit_collection always returns 0
  ↓
list literals collapse → parser arms-list never populated
  ↓
every Statement.Match in main.fg compiles to a stub with no arms
  ↓
emit_collection IR shows: `extractvalue %ForgeString, 0; ptrtoint; icmp eq 0`
                          (a kind_name.ptr null check, NOT a string compare)
  ↓
main()'s `if command == "build"` is reduced to truthy on command struct
  ↓
Stage 3 main always falls through both arms
```

### What this is NOT

It is **not** the old "destructure alloca size" bug from the previous
agent's notes. That one was real but already fixed (`extract_enum_variant_fields`
properly unboxes via inttoptr+load now, and `bind_pattern_vars` calls it).
Pattern.Literal's `value: Expr` field IS correctly boxed and unboxed —
verified by adding eprintln to the inner match's `.StringLit` arm: the
arm fires with the literal string text intact. The destructure works.

It is also **not** a missing runtime function or registry inconsistency.
`forge_string_eq` is declared in stage 2 IR and would be called if
emit_match_arms reached its `tag == -2` branch.

### What IS broken

The **rust compiler's `compile_match`** stores each arm's result in a
`match_result_tmp` alloca and reads it back at the merge block:

```rust
// packages/forgec-rust/features/pattern_matching/codegen.rs ~line 197
let result_alloca = if let Some(rty) = inferred_result_type {
    let alloca = tmp_builder.build_alloca(rty, "match_result_tmp").unwrap();
    let zero = ...const_zero();
    tmp_builder.build_store(alloca, zero).unwrap();
    Some((alloca, rty))
};
```

Each arm body is compiled with `compile_expr(arm.body)`, and the result
is stored back into the alloca. When the arm body is itself a Block
ending in another `match` expression, the inner match has its OWN
`match_result_tmp`. The OUTER arm's `arm_val` is supposed to be the
inner match's loaded result.

Verified: at runtime, pattern_tag's compiled machine code returns 0
for a case where the source clearly says `-2`, and the issue is that
the inner match's loaded result is NOT being propagated back as the
outer arm's value. The outer arm sees the OUTER alloca's zero-init
value (0).

### Where to look

1. **`compile_match` arm body handling** (`packages/forgec-rust/features/pattern_matching/codegen.rs` ~line 269):
   ```rust
   self.builder.position_at_end(arm_bb);
   self.push_scope();
   self.bind_pattern_vars(...);
   let arm_val = self.compile_expr(&arm.body);
   self.pop_scope();
   ```
   `compile_expr(&arm.body)` for a Block should return the last
   expression's value. If the last expression is itself a `match`,
   that's a nested `compile_match` call. Verify that the nested call's
   returned value (which is a load from its own `match_result_tmp`)
   actually flows out as `arm_val`.

2. **`compile_expr` for `Expr::Block`** (`packages/forgec-rust/codegen/codegen/expressions.rs:133-153`):
   ```rust
   Expr::Block(block) => {
       self.push_scope();
       let mut last = None;
       for stmt in &block.statements {
           match stmt {
               Statement::Expr(expr) => {
                   last = self.compile_expr(expr);
                   ...
               }
               _ => { self.compile_statement(stmt); last = None; }
           }
       }
       ...
       last
   }
   ```
   This looks correct on its face. But verify: when the inner expr is a
   `MatchExpr`, does `compile_expr(MatchExpr)` actually call
   `compile_match` and return its loaded result? Trace through
   `dispatch_feature_expr!` → `compile_match_feature`.

3. **Specific suspicion**: at line 297 in `compile_match`, after the
   arm body, the code stores `arm_val` (or a coerced version) into
   `result_alloca`. But this store may be happening AFTER the inner
   match has already advanced the builder past `result_alloca`'s store
   point. Specifically:

   ```rust
   let arm_end_bb = self.builder.get_insert_block().unwrap();
   if arm_end_bb.get_terminator().is_none() {
       if let Some((alloca, rty)) = result_alloca {
           if let Some(val) = arm_val {
               // store arm_val to result_alloca
               self.builder.build_store(alloca, store_val).unwrap();
           }
       }
       self.builder.build_unconditional_branch(merge_bb).unwrap();
   }
   ```

   If the inner match left the builder positioned at the inner merge block
   (which IS the outer block's continuation), then the store-then-branch
   sequence for the outer arm fires correctly. But if `result_alloca` is
   the OUTER alloca and `arm_val` is `Some(load_from_inner_alloca)`, the
   store stores the loaded inner value to the outer alloca. That should
   work.

   The bug must be subtler. Possibilities:
   - The inner match's `compile_match` returns `None` instead of
     `Some(load result)` — check `return Some(result)` paths.
   - The inner match's loaded value has a different LLVM type than the
     outer's `result_alloca`, and `coerce_value` falls back to
     `const_zero` (line 287-294: "Try coercion; fall back to zero
     default of target type"). This is the most likely culprit — the
     inner match returns i64 (from pattern_tag) but the outer alloca
     might have a different type at this point.

### Diff-driven first step

Per the mandatory diff-driven approach at the top of this file, the next
session should:

```bash
# 1. Generate stage 1 IR (rust-emitted) for pattern_tag
./target/release/forgec build packages/forgec/src/main.fg --emit-ir > /tmp/stage1.ll

# 2. Generate stage 2 IR (self-hosted-emitted, what stage1_rust outputs)
./build/stage1_rust build packages/forgec/src/main.fg
mv output.ll /tmp/stage2.ll

# 3. Diff Codegen_pattern_tag specifically
bash scripts/diagnose.sh --diff Codegen_pattern_tag /tmp/stage1.ll /tmp/stage2.ll
```

Stage 1 IR's pattern_tag IS the rust-compiled version — find its
`.Literal` arm in stage 1 IR and look at how the inner match's result
flows to the outer arm's result_alloca store. Compare to stage 2 IR.
The divergence will pinpoint the rust compiler bug.

Note: stage 1 IR is direct rust output (`--emit-ir`). Stage 2 IR is
what stage1_rust EMITS for the same source via its self-hosted codegen.
They should be byte-equivalent. Where they diverge is the bug.

## Fixes added in the most recent session (uncommitted)

All root-cause, no workarounds. Don't regress these.

### Self-hosted codegen (`packages/forgec/src/codegen/mod.fg`)
- **`Pattern` enum registered in `cg_register_core_types`** with
  `forge_enum_type_register("Pattern", 8)`. Without this, every parameter
  typed `pat: Pattern` (e.g. `pattern_tag`, `emit_pattern_bindings`) was
  silently lowered to `i64`, and field destructuring `.EnumVariant(variant, _, _)`
  read fields from a non-aggregate, collapsing every match dispatch.
- **`emit_match_arms` phi wiring rewritten to use the C-side phi stack**
  (`forge_phi_push` / `forge_phi_count_from` / `forge_phi_wire`). The old
  `phi_vals: List<ptr>` / `phi_bbs: List<ptr>` lists corrupted across
  iterations (CLAUDE.md: BasicBlockRefs CANNOT survive Forge `List<ptr>`),
  producing PHI nodes whose entry count didn't match the merge block's
  predecessor count. `emit_match_call` rewritten the same way.
- **For-loop element-variable alloca hoisted to function entry block**.
  Previously the alloca lived in the loop body, so any successor block
  reachable from the loop *header* (the loop end block in particular)
  failed SSA dominance.
- **List `.Index` `safe_idx` extract guarded by struct kind check**.
  Calling `build_extract_value` on a non-aggregate (const i64) is
  undefined and was returning poison → llc folded every `list[k]` to
  `list[0]`.
- **`int(x)` / `float(x)` / `bool(x)` builtin handlers in `emit_call`**.
  The comment said "Cast functions: string(x), int(x), float(x), bool(x)"
  but only `string` was implemented; `int(text)` fell through to the
  generic-call lookup, `parse_int` ended up emitted as `ret 0`, and every
  integer literal in the source then parsed as 0.
- **Missing extern declarations added to `cg_init_runtime`**:
  `forge_phi_count_from`, `forge_phi_get_val`, `forge_phi_get_bb`,
  `forge_struct_field_is_i8`, `forge_global_var_get_init`,
  `forge_global_var_set_init`, `forge_pending_var_type_get`,
  `forge_pending_var_type_clear`.
- **`CG_MAP` lazy `{ptr keys, ptr vals, i64 length}` struct type** plus
  `cg_get_map_struct_ty()` accessor. `resolve_type_to_llvm` now handles
  `Map` / `map` / `Map:K:V` / `map:K:V` and returns the proper 24-byte
  struct.
- **`create_globals_from_registry` consults the full type name** via
  `forge_global_var_get_type` and resolves it via `resolve_type_to_llvm`.
  Falls back to the legacy `is_str` flag only when no full type is
  registered. So `mut LIST_LITS: Map<string, ListLitData> = {}` now
  allocates a 24-byte `{ptr,ptr,i64}` global instead of a 16-byte
  `%ForgeString` (was silently truncating Map globals).
- **`emit_let` and the `.Let` arm in `dispatch_emit_stmt` consult the
  pending var-type table** unconditionally (the table is per-function
  scoped — see runtime fix below — so consulting it always is safe).
- **Exported `CG_B`, `CG_PTR`, `CG_LIST`, `CG_MAP`** so feature modules
  can build typed values without round-tripping through resolve.

### Self-hosted parser (`packages/forgec/src/features/variables/mod.fg`)
- **Captures `Map<K, V>` annotations** the same way it captures
  `List<T>`, stores `Map:K:V` in the global type registry.

### Self-hosted parser bridge (`packages/forgec/src/features/functions/mod.fg`)
- **`forge_pending_var_type_clear()` called at the start of every
  `emit_fn_body_from_source`**. The pending var-type table holds
  parser-time `let X: T = …` annotations and is consumed at codegen-time
  by `emit_let`. Since every function body is parsed and emitted in
  lockstep, the right scope for these annotations is the current
  function — clearing here prevents stale entries (e.g. `let command: int = 0`
  in fn A) from polluting the next function's `let command = args[1]`.

### Self-hosted collections feature (`packages/forgec/src/features/collections/mod.fg`)
- **`emit_collection`'s empty-list fallback builds a real `{ptr null, i64 0}`
  via `build_insert_value`** rather than `const_int 0` or `const_null`.
  Guaranteed to carry the correct LLVM struct type even when CG_LIST is
  partially initialized in bootstrap stages — `mut xs: List<T> = []` then
  alloca's a proper `{ptr,i64}` list instead of an `i64`.

### Runtime (`stdlib/runtime.c`)
- **`_pending_var_types` side table** with `forge_pending_var_type_get` /
  `forge_pending_var_type_clear`. The OLD `forge_alloca_cache_set_var_type`
  required a matching alloca cache entry to exist when called — the parser
  legitimately calls it BEFORE the alloca exists, so it was a silent no-op.
  Every `mut xs: List<T> = []` lost its element type, `define_var_typed`
  defaulted to `i64`, and every subsequent `xs.push(...)` was silently
  dropped — collapsing every parser/codegen helper that builds its result
  via `list_push`. The fix: when no matching alloca exists,
  `forge_alloca_cache_set_var_type` falls back to stashing in the pending
  table; `emit_let` reads from it; `emit_fn_body_from_source` clears it
  per function.

### Rust compiler — `forge_llvm_build_store` (`packages/std-llvm/src/lib.rs`)
- **Replaces `i64 0 → const_null(struct_ty)` for struct allocas**.
  Storing a bare `i64 0` into a multi-field struct alloca leaves the
  upper bytes uninitialized — when the alloca is 16 bytes (`{ptr,i64}`
  list) this means subsequent loads see whatever happened to be on the
  stack, and length-tracking goes haywire. Now produces full
  `store %T zeroinitializer, ptr` for any constant-zero i64 → struct-alloca
  store. Added `LLVMConstIntGetSExtValue` extern.

### Rust compiler — type conversion (`packages/forgec-rust/features/type_conversion/codegen.rs`)
- **`compile_int_conversion` / `compile_float_conversion` use
  `forge_string_to_int` / `forge_string_to_float`** with
  `call_runtime_expect`, not `forge_string_parse_int` / `_parse_float`.
  The latter were registered via `runtime_fn!` but never declared in
  the self-hosted `mod.fg`'s `cg_init_runtime` — two parallel registries.
  Unified on `*_to_*` (single source of truth, reliably declared in both
  Rust and self-hosted codegen). The `_parse_*` registrations were
  removed from `features/strings/mod.rs`. `string.parse_int()` method
  also routed to `forge_string_to_int`.

## Earlier fundamental fixes still in (commit `55261f4`)

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

1. **Diff `Codegen_pattern_tag` between stage 1 IR and stage 2 IR**:
   ```bash
   ./target/release/forgec build packages/forgec/src/main.fg --emit-ir > /tmp/stage1.ll
   ./build/stage1_rust build packages/forgec/src/main.fg && cp output.ll /tmp/stage2.ll
   bash scripts/diagnose.sh --diff Codegen_pattern_tag /tmp/stage1.ll /tmp/stage2.ll
   ```
   The divergence — specifically in the `.Literal(value) -> { match value { … } }`
   arm — IS the bug. Look for where the inner match's loaded result
   should be stored to the outer arm's `match_result_tmp` alloca and
   isn't.

2. **Fix `compile_match` in `packages/forgec-rust/features/pattern_matching/codegen.rs`**.
   The most likely issue is the coerce-to-zero fallback at lines 286-294:
   ```rust
   let coerced = self.coerce_value(val, rty);
   if coerced.get_type() == rty {
       coerced
   } else {
       match rty {
           BasicTypeEnum::IntType(it) => it.const_zero().into(),
           ...
       }
   }
   ```
   When the inner match returns an i64 (a Forge `int`) and the outer
   match's `result_alloca` was inferred as something else (e.g. a struct
   from another arm), the coerce fails and the value is replaced with
   `const_zero`. Fix: improve `coerce_value` to handle int → other-int
   widening, or pre-infer `result_alloca` type from ALL arms not just
   the first.

3. **Once pattern_tag returns -2 for StringLit** (verify with the diff),
   the cascade unblocks. Re-run:
   ```bash
   make stage1-rust && make test-stage1
   ./build/stage1_rust build packages/forgec/src/main.fg
   cp output.ll /tmp/stage2.ll
   /opt/homebrew/opt/llvm@19/bin/llc -O0 -filetype=obj /tmp/stage2.ll -o /tmp/stage2.o
   cc -o /tmp/stage2 /tmp/stage2.o build/runtime.o -lm -Wl,-stack_size,0x10000000 \
      packages/std-llvm/target/release/libforge_llvm.a \
      -L/opt/homebrew/Cellar/llvm@19/19.1.7/lib -lLLVM-19 -lstdc++ -lz -lcurses
   bash scripts/diagnose.sh --stage3
   ```
   Expected: stage 3 score drops below 48; stage 3 output goes from 5
   lines (`M:argc=3 / M:cmd=[build]`) to a real compilation trace.

4. **Then `/tmp/stage3 build packages/forgec/src/main.fg /tmp/stage4`**
   should produce a stage 4 binary.

5. **Fixed-point check**: `/tmp/stage4 build packages/forgec/src/main.fg /tmp/stage5`,
   then `diff /tmp/output.ll` between stages 3→4 and 4→5. Once identical,
   we have M7.

## What NOT to do (lessons from this session)

- **Don't add eprintln tracing to runtime code** to bisect the bug.
  It works but it's slow and the diff-driven approach is faster. The
  one place eprintln helped this session was confirming the cascade
  origin (pattern_tag returning the wrong value) — once confirmed,
  switch to IR diffing.
- **Don't regress the warts that were fixed** — see the "Fixes added in
  the most recent session" list above. Specifically: do not re-add the
  `val_type == "int" || ...` guard to `emit_let`/`.Let`, do not re-add
  the `forge_string_parse_int` registry entries, do not revert the
  Pattern enum registration, and do not weaken the
  `forge_llvm_build_store` const-zero widening.
- **Don't trust "Stage 3 builds ✅"** without checking that stage 3
  binary actually does something useful with a non-trivial input. The
  diagnose script reports build success but the binary may still emit
  empty stub IR for everything.

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
