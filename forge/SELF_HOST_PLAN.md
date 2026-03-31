# Self-Hosting Plan: Stage 2 to Fixed Point

**Goal:** Stage 2 IR = Stage 3 IR (the self-hosted compiler compiles itself identically).

**Current state:** Stage 1 (compiled by mini) produces Stage 2 binary that runs but generates broken IR. The root cause is that `codegen/mod.fg` defaults everything to i64 and uses global flags (`CG_LAST_IS_STR`, `CG_LAST_IS_PTR`, etc.) to track non-i64 types. This flag system misses most cases, producing 3000+ type errors in Stage 2 IR.

**Audit baseline:** Run `scripts/audit_stage2.sh output.ll` to get starting numbers.

---

## Milestone 1: Fix type system in emit_ident

**What to fix:** When loading a variable, the codegen does `load i64, ptr %x` regardless of what `%x` actually holds. Use `LLVMGetAllocatedType` on the alloca to determine the correct type, then emit `load <correct_type>, ptr %x`.

**Where:** `emit_ident` in `codegen/mod.fg`. Every place that does `llvm.build_load(CG_B, ptr, CG_I64, name)` on a variable alloca needs to check the alloca's type first.

**Audit target:**
- `load_type_mismatch` -> 0
- Other metrics may improve as side effects

**How to verify:**
1. Make the change in `codegen/mod.fg`
2. Rebuild Stage 1: `/tmp/mini_s2 build packages/forgec/src/main.fg /tmp/stage1`
3. Rebuild Stage 2: `/tmp/stage1 build packages/forgec/src/main.fg`
4. Run `scripts/audit_stage2.sh output.ll`
5. Confirm `load_type_mismatch` is 0

**Difficulty:** Medium. The LLVM C API function `LLVMGetAllocatedType` must already be exposed in `std-llvm`. If not, add it. The tricky part is that the global flag system may fight with this — you may need to also set the flags correctly after the load so downstream code knows the type.

**Dependencies:** None. This is the safest starting point.

---

## Milestone 2: Fix type system in emit_fn_call_direct

**What to fix:** When calling a function, the codegen passes all arguments as i64. Instead, use `LLVMGlobalGetValueType` on the callee to get the function type, then `LLVMGetParamType` to determine what each parameter expects. If a parameter expects a struct type, pass the struct directly instead of casting to i64.

**Where:** `emit_fn_call_direct` in `codegen/mod.fg` (but see CLAUDE.md rule: NEVER modify `emit_fn_call_direct` or `emit_call` directly — fix behavior in callers or the Let handler).

The safe approach: create a helper function like `coerce_arg_to_param_type(fn_ref, arg_index, arg_value)` that checks whether the function's declared param type matches the arg's actual type, and inserts a bitcast/conversion if needed. Call this helper from the sites that build argument lists before calling `emit_fn_call_direct`.

**Audit target:**
- `call_type_mismatch` < 100
- `struct_as_i64` -> 0

**How to verify:**
1. Same rebuild pipeline as M1
2. Run audit, confirm `struct_as_i64` is 0 and `call_type_mismatch` drops significantly
3. Stage 2 binary should still run (may not produce correct output yet)

**Difficulty:** Hard. This is the highest-impact change. The constraint against modifying `emit_fn_call_direct` directly makes it trickier — you need to fix the callers. The forge-lang repo's mini compiler already solved this with `{i64, ptr}` enum representation and i64 tags, which may provide reference patterns.

**Dependencies:** Milestone 1 (correct loads feed correct types into calls).

---

## Milestone 3: Fix br i1 false

**What to fix:** `br i1 false` means a condition that is always false — the branch is dead code. This likely comes from:
- The `&&` operator always producing `false` instead of evaluating both sides
- While loop conditions not being wired to the actual comparison result
- If-else conditions losing their value before the branch

Investigate which control flow constructs produce `br i1 false` by searching the IR for surrounding context.

**Audit target:**
- `br_i1_false` < 20 (some may be legitimate optimizable patterns)

**How to verify:**
1. Find the `br i1 false` lines in output.ll
2. Trace back to which function/construct generates them
3. Fix the condition wiring in the relevant emit functions
4. Rebuild and audit

**Difficulty:** Medium-Hard. This is likely 2-3 separate bugs (&&, while, if) each needing individual fixes. The debugging loop is: find a `br i1 false` in the IR, figure out which source construct produced it, fix the codegen for that construct.

**Dependencies:** None strictly, but M1/M2 may change how conditions are evaluated, so doing this after M2 avoids duplicate work.

---

## Milestone 4: Fix ret undef

**What to fix:** Functions returning `undef` instead of a meaningful value. Replace with `zeroinitializer` for struct return types, or `0` for i64. This is a safety net — the real fix is making the function body produce the correct return value, but `zeroinitializer` is strictly better than `undef` (deterministic vs undefined behavior).

**Where:** The function epilogue in `emit_all_fn_bodies` / the return handling in codegen. Find where `ret ... undef` is generated and replace with `ret <type> zeroinitializer`.

**Audit target:**
- `ret_undef` -> 0

**How to verify:**
1. Rebuild and audit
2. Confirm no `ret ... undef` in output.ll
3. Stage 2 should produce more stable output (fewer UB crashes)

**Difficulty:** Easy-Medium. This is mostly a mechanical replacement, but some `undef` returns may indicate deeper issues (function body never reaches a return). The `zeroinitializer` fix is a band-aid that prevents UB but doesn't fix logic errors.

**Dependencies:** Best done after M1-M3 so you can distinguish "legitimate missing returns" from "type system bugs causing undef."

---

## Milestone 5: Stage 2 compiles hello world

**What to fix:** This is the integration milestone. With M1-M4 done, Stage 2's IR should be clean enough that the resulting binary can compile a trivial program:

```forge
fn main() {
    println("hello")
}
```

If it doesn't work, the remaining issues are likely:
- Runtime function declarations missing or mistyped
- String literal handling broken
- Main function setup (argc/argv) wrong

**Audit target:**
- `/tmp/stage2 build test.fg` produces a working binary
- The binary prints "hello"

**How to verify:**
```bash
echo 'fn main() { println("hello") }' > /tmp/test_hello.fg
cp a.out /tmp/stage2
/tmp/stage2 build /tmp/test_hello.fg
/tmp/test_hello_out  # or whatever the output binary is called
# Should print: hello
```

**Difficulty:** Hard. This is where all the individual fixes come together. Expect 3-5 small issues that only surface at runtime (segfaults, wrong string pointers, missing runtime symbols). Each needs individual debugging with `llvm-dis` and careful IR inspection.

**Dependencies:** M1-M4.

---

## Milestone 6: Stage 2 compiles itself (Stage 3)

**What to fix:** Run Stage 2 on the full compiler source to produce Stage 3 IR. This will expose issues that don't show up in hello world:
- Enum dispatch (match expressions with many arms)
- Struct field access and construction
- List/map operations
- Template string concatenation
- Module/file resolution

**Audit target:**
- `/tmp/stage2 build packages/forgec/src/main.fg` produces output
- Run `scripts/audit_stage2.sh` on Stage 3 IR — it should have similar (ideally better) numbers than Stage 2

**How to verify:**
```bash
/tmp/stage2 build packages/forgec/src/main.fg
# Produces Stage 3 IR
scripts/audit_stage2.sh output.ll  # audit Stage 3
```

**Difficulty:** Very hard. The full compiler source exercises every codegen path. Expect 10-20 issues to surface. This milestone may take as long as M1-M5 combined.

**Dependencies:** M5.

---

## Milestone 7: Fixed point (Stage 2 IR = Stage 3 IR)

**What to fix:** Diff Stage 2 IR against Stage 3 IR. Any differences indicate the compiler generates different code when compiled by mini vs when compiled by itself. Common causes:
- Hash map iteration order differences
- Floating point constant formatting
- String interning differences
- Optimization differences (mini vs full compiler may make different codegen choices)

**Audit target:**
- `diff stage2.ll stage3.ll` produces no output (byte-identical)

**How to verify:**
```bash
# Build Stage 2
/tmp/stage1 build packages/forgec/src/main.fg -o /tmp/stage2
# Save Stage 2 IR
cp output.ll /tmp/stage2.ll

# Build Stage 3
/tmp/stage2 build packages/forgec/src/main.fg -o /tmp/stage3
# Save Stage 3 IR
cp output.ll /tmp/stage3.ll

diff /tmp/stage2.ll /tmp/stage3.ll
# Should be empty
```

**Difficulty:** Medium (if M6 works well) to Very Hard (if there are systematic differences). The mini compiler already achieved fixed point, so the approach is proven — but the full compiler has 4x more code.

**Dependencies:** M6.

---

## Progress Tracker

Run `scripts/audit_stage2.sh output.ll` after every change. Update this table.

| Metric | Baseline | Current | M1 Target | M2 Target | M3 Target | M4 Target | Done Target |
|--------|----------|---------|-----------|-----------|-----------|-----------|-------------|
| br_i1_false | 99 | 103 | - | - | < 20 | - | 0 |
| null_operands | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| ret_undef | 171 | 170 | - | - | - | 0 | 0 |
| struct_as_i64 | 279 | 274 | - | 0 | - | - | 0 |
| call_type_mismatch | ~~3443~~ | 245 | - | < 100 | - | - | 0 |
| load_type_mismatch | ~~1941~~ | **0** ✅ | 0 | - | - | - | 0 |
| **SCORE** | ~~7076~~ | **1924** | - | - | - | - | **0** |

## Checklist

- [x] **M1: emit_ident types** — load_type_mismatch → 0 ✅ (was false positives from cross-function register collisions)
- [ ] **M2: call arg types** — Use LLVMGlobalGetValueType for declared param types. Target: struct_as_i64 → 0, call_type_mismatch < 100
- [ ] **M3: br i1 false** — Fix && operator and while condition wiring. Target: br_i1_false < 20
- [ ] **M4: ret undef** — Return zeroinitializer instead of undef. Target: ret_undef → 0
- [ ] **M5: Hello world** — `/tmp/stage2 build test_hello.fg` produces working binary
- [ ] **M6: Self-compile** — Stage 2 compiles itself into Stage 3 IR
- [ ] **M7: Fixed point** — Stage 2 IR = Stage 3 IR (diff produces no output)

## Key Rules

1. Work milestones IN ORDER. M1 before M2, etc.
2. Run audit after EVERY change. Update the "Current" column above.
3. If score goes UP, revert immediately.
4. One change at a time. Commit after each improvement.
5. NO C-side workaround functions. Fix the codegen.

**Total estimated: 2-6 weeks of focused work.**

M1 and M2 are the foundation — they fix the type system that causes the cascade. Everything after is cleanup and integration.

**Reference:** The forge-lang repo (`../forge-lang`) already solved enum representation. Check `mini/codegen.fg` for `{i64, ptr}` patterns.
