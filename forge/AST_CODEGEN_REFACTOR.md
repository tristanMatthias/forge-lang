# Self-Hosting Status & Next Steps

## ═══════════════════════════════════════════════════════
## ❌ NO HACKS. PERFECT-WORLD COMPILER. NO EXCEPTIONS. ❌
## ═══════════════════════════════════════════════════════

> **Read this first. Read it twice. If you skip this section you will
> waste your session and add more debt to a codebase that already has
> too much.**

This compiler is a **mature, self-hosting language compiler**. Treat it
as one. Every decision you make should be answerable to the question:
**"Is this how a real compiler does it?"** If the answer is "no, but
it works for now" — STOP. You are about to add a hack.

### What "no hacks" means

A hack is anything that:

1. **Aliases two semantically distinct types to the same LLVM type** so
   that one can stand in for the other. Lists are not strings. Spans
   are not lists. Bools are not i64. Floats are not i64. Pointers are
   not i64. **Each type gets its own LLVM type.** Even when the
   layouts happen to coincide. LLVM 19 type unification will not save
   you — the IR builder will silently substitute `undef` at call
   boundaries when it can't tell two unified types apart, and you
   will spend three sessions chasing the resulting garbage.

2. **Patches a symptom at the call site instead of fixing the source.**
   If `Codegen_emit_list_literal` is being called with `%ForgeString
   undef`, the fix is **not** to add a `coerce_call_arg` helper at
   every call site that round-trips the value through an alloca. The
   fix is to make `List<T>` a distinct named type so the call site
   produces the right value in the first place.

3. **Adds a runtime auto-coercion fallback that emits `LLVMGetUndef`
   when it can't figure out the right answer.** This exists today in
   `forge_llvm_build_call` (`packages/std-llvm/src/lib.rs` lines
   ~1434-1510). It is the central source of fragility in the
   compiler. **Delete it.** Force every call site to produce
   correctly-typed args. The cascade of failures that exposes is the
   actual work — those failures are the real bugs the runtime
   coercion has been hiding.

4. **Stores a multi-byte aggregate through a smaller-byte alloca**
   ("the bytes still fit if I'm careful"). This is what produces the
   `store %ForgeString through ptr-typed alloca` overflow we found in
   parse_int. Every alloca's type must match every store/load through
   it. No exceptions, no "but it works because of alignment".

5. **Uses a global flag, mutable global, or string-keyed side table to
   track type information that LLVM already knows.** LLVM's type
   system is the single source of truth. Use `LLVMGetAllocatedType`,
   `LLVMTypeOf`, `LLVMGetParamTypes`, `get_nth_param().get_type()`.
   The CG_VAR_TYPES, CG_LAST_IS_STR, etc. patterns from earlier
   bootstrap eras are technical debt and should be deleted as you
   encounter them.

6. **Adds a "this branch is rare so I'll handle it lazily" path.**
   Every variant must be handled. Every match arm must produce the
   right value. Empty match arms (`-> {}`) are bugs unless they're
   genuinely no-ops with comments explaining why.

7. **Ships an "intermittent" or "build-cache-sensitive" bug.** If
   something only crashes "sometimes", you have a real bug — usually
   a use-of-uninitialized memory or a use-after-free. Track it down.
   Don't shrug.

8. **Uses string concatenation in a hot path** (lexer, parser,
   codegen inner loop). Strings allocate. Allocation in the lexer
   means the lexer is allocating thousands of times per file and
   you'll never get fast compile times. Use `forge_trace_i64` or
   integer-only telemetry in hot paths.

9. **Wraps a bug in a comment that says "workaround for X" or "TODO:
   fix later" or "the proper fix is Y but that's a multi-day
   effort".** If the proper fix is multi-day, **do the proper fix**.
   That's how mature compilers get built. Workarounds compound;
   proper fixes pay down debt. Every multi-day fix you do is a week
   of future sessions you don't have to spend chasing the same root
   cause.

### What "perfect world, mature compiler" means

The reference is rustc, clang, ghc — compilers that solved these
problems decades ago and don't have hacks for them. Concretely:

- **Every Forge type maps to exactly one LLVM type.** `Type::List(T)`
  → `%List_T` or a per-instantiation anonymous `{ ptr, i64 }`, but
  *consistently*, never `%ForgeString`. `Type::Span` → `%Span` (the
  4-i64 named struct), always. `Type::Bool` → `i8`. `Type::Float` →
  `double`. `Type::Ptr` → `ptr`. The mapping function is **the only
  place** these decisions are made, and every codegen path goes
  through it.

- **Every function declaration uses the type system to compute its
  signature.** No "hardcode List<T> as %ForgeString in
  declare_all_fns" shortcuts. The signature comes from the types,
  the types come from the type checker, the type checker is the
  single source of truth.

- **Every call site coerces using the function's actual declared
  param types**, looked up via `get_nth_param(i).get_type()`. The
  coercion is small and explicit because the types match in
  *almost every case* — coerce is for the rare legitimate
  conversions (i64 → ptr handle, etc.), not the catch-all hammer it
  is today.

- **The runtime helpers in `forge_llvm_build_call` and friends are
  thin wrappers around the LLVM C API.** They null-check, they
  forward, they do *not* try to coerce arguments. If the caller
  passes the wrong type, the LLVM verifier catches it and the
  compiler reports a clear internal error pointing at the buggy
  emit site.

- **Variable allocas are typed.** `let xs: List<int> = []` allocates
  a `%List_int` (or anon `{ptr, i64}`) and stores a zero-init list
  value into it. Loading from it produces a list value. There is
  no "store 16 bytes through an 8-byte alloca and hope the upper
  bits aren't read" anywhere.

- **Match arm bindings inherit the variant field's declared type.**
  `.IntLit(value, span)` binds `value: int` (i64) and `span: Span`
  (4-i64 struct). The codegen unpacks the enum payload using the
  exact field offsets and types from the variant declaration, no
  guessing, no "assume Span is 2 i64s and read the first half".

- **The bootstrap chain has parity.** Stage 2 IR (emitted by
  stage1_rust running self-host source) and Stage 3 IR (emitted by
  stage 2 binary running self-host source) should be **byte-for-byte
  identical** modulo SSA renumbering. If they differ, the diff is a
  bug. Period. The current ~46 ret_undef + 60 undef_args + 10
  undef_length values in the audit are **all bugs**, not "areas to
  improve". They are tracked because someone needs to delete them.

- **Diagnostics are first-class.** Every internal error gives a clear
  message ("expected `%ForgeString` for parameter 1 of
  Codegen_emit_list_literal, got `{ptr, i64}` from emit_collection
  line 112"), not a segfault in `LLVMTypeOf`. The diagnose script's
  --score and --diff-fn modes are how you find bugs; they exist
  because the codebase didn't have proper diagnostics earlier and
  it cost weeks.

- **The error paths are real.** No `unwrap()` on user input. No
  silent `return null`. No "this branch is unreachable so I'll
  return undef and hope it's never hit". Every error gets a
  CompileError variant and renders through `CompileError::render()`.

### How to evaluate any proposed fix

Before you write a single line of code, ask yourself:

> Is this fix making the compiler more like a real, mature compiler,
> or is it making the compiler more like itself?

If the answer is "more like itself", you are probably about to add a
hack. Stop and think about what a real compiler would do here.

If you find yourself patching the same root cause in 5 places, **stop
patching and fix the root cause**. Five sites with the same hack is
five sites that will need to be fixed in the eventual cleanup, plus
the original bug, plus the time you spent on the hacks. Do the
cleanup *now*.

If your "fix" requires explaining "this is fine because [historical
reason] [bootstrap quirk] [interaction with other hack]", you are
adding a hack. Real compilers don't need historical justification
for their type system.

---

## ═══════════════════════════════════════════════════════
## SYSTEMIC ROOT CAUSE: THE AGGREGATE-TYPE COLLAPSE
## ═══════════════════════════════════════════════════════

This is the single most important diagnosis in the codebase right
now. **Every "stage 3 doesn't work" symptom traces back to this.**
Internalize this section before you touch anything.

### The bug, in one sentence

**The self-host treats every aggregate type that's "around 16 bytes"
as `%ForgeString`**, with scattered ad-hoc hacks throughout the
codebase to interpret the bytes correctly when the difference matters.

### How it manifests

1. **`CG_LIST = CG_STR`** in `cg_reinit_types`
   (`packages/forgec/src/codegen/mod.fg` ~line 885). This single
   line aliases the list type and the string type. Every `let xs:
   List<T> = ...` then allocates a `%ForgeString` and the list
   header is interpreted as a string header at runtime. `args:
   List<Expr>` parameters in self-host functions are all typed as
   `%ForgeString` for the same reason.

2. **`Span` collapses to `%ForgeString` in enum-variant unpacking.**
   Stage 2 IR for `Codegen_emit_call`'s match arms shows patterns
   like:
   ```llvm
   %13 = extractvalue %Expr %callee1, 3
   %14 = extractvalue %Expr %callee1, 4
   %15 = inttoptr i64 %13 to ptr
   %16 = insertvalue %ForgeString undef, ptr %15, 0
   %17 = insertvalue %ForgeString %16, i64 %14, 1
   store %ForgeString %17, ptr %span, align 8
   ```
   This unpacks **two** i64 fields out of a four-i64 Span, builds a
   ForgeString, and stores it into a `%span` alloca that's also
   typed as `%ForgeString`. The remaining 16 bytes (line, col)
   are silently dropped.

3. **`bool` collapses to `i64`** because `resolve_type_to_llvm("bool")`
   returns `CG_I64`. Every bool param/local is widened, breaking
   ABI parity with rust-emitted callers.

4. **`float` collapses to `i64`** for the same reason.

5. **`Map`** would collapse too but happens to use a 3-i64 shape so
   the alias would lose data — handled separately in
   `cg_get_map_struct_ty()`.

6. **The runtime catch-all in `forge_llvm_build_call`** (in
   `packages/std-llvm/src/lib.rs` lines ~1434-1510) does a gauntlet
   of `extractvalue` / `inttoptr` / `ptrtoint` coercions when arg
   types don't match param types, and **falls back to `LLVMGetUndef`
   when it can't figure out a coercion**. That `undef` is the
   garbage that propagates everywhere downstream. It is **the
   central enabler** of the type-collapse pattern: without it, the
   LLVM verifier would catch every type mismatch immediately and
   force the upstream emit code to be correct.

### Why it's hard to fix piecemeal

Every site that touches the collapsed types has been written
assuming the alias holds. A `let xs: List<T> = []` site stores a
ForgeString-zero into the alloca because that's what `const_null(CG_LIST)`
returns. A `extract_value(expr_val, 3)` site reads only 2 fields
because the surrounding code assumes Span is 2 slots wide. A
`define_var_typed("span", "Span", ...)` site relies on `type_of(value)`
returning `%ForgeString` so the alloca is sized to match.

**You cannot flip the alias without flipping all of these at once.**
We tried this session. The result was stage1_rust segfaulting
during its own compilation because half the codebase assumes the
alias and the other half had been patched not to.

### The actual fix (do all of this in one branch)

1. **Make `CG_LIST` a distinct anonymous `{ ptr, i64 }`** (not
   `%ForgeString`). Set it once in `cg_init_str` and never clobber
   it in `cg_reinit_types`. Update the `cg_reinit_types` comment.

2. **Make every `List<T>` parameter, return, local, and field use
   `CG_LIST`.** This means:
   - `declare_all_fns` (`features/functions/mod.fg`) — replace the
     `if tname == "List" || ... { param_ty = CG_STR }` lines with
     `param_ty = CG_LIST`. Same for return.
   - `define_var_typed` (`codegen/mod.fg`) — when `type_name`
     starts with "List" / "list", use `CG_LIST`, not `type_of(value)`
     which currently returns `%ForgeString`.
   - `emit_expr_inner`'s `.Block(block)` empty-list path — already
     fixed in this session, keep it.
   - `emit_list_literal` — already uses `CG_LIST` correctly,
     verify the new distinct type propagates.

3. **Fix Span unpacking in match arms.** Find the codegen path that
   emits the broken `extractvalue ..., 3 / 4 / insertvalue
   %ForgeString` pattern and replace it with proper Span field
   access. The variant-field metadata already records Span as
   `"4"` slots; the unpacking code is what's wrong.

4. **Fix `resolve_type_to_llvm`:**
   - `if type_name == "bool" { return CG_I8 }`
   - `if type_name == "float" { return CG_F64 }`
   - `if type_name == "ptr" { return CG_PTR }` (already correct)

5. **Delete `forge_llvm_build_call`'s auto-coercion entirely.** Lines
   ~1434-1510 of `packages/std-llvm/src/lib.rs`. The function
   becomes:
   ```rust
   pub extern "C" fn forge_llvm_build_call(builder, fn_type, f, args, num_args, name) -> LLVMPtr {
       if builder.is_null() || fn_type.is_null() || f.is_null() { return null; }
       LLVMBuildCall2(builder, fn_type, f, args, num_args as c_uint, safe_name(name))
   }
   ```
   That's it. Every caller must produce correctly-typed args. The
   failures this exposes are the real bugs that need to be fixed.

6. **Delete the equivalent in-runtime coercion for `forge_llvm_build_store`,
   `forge_llvm_build_load`, etc.** if they exist. Search for
   `LLVMGetUndef` in `lib.rs` and audit every use.

7. **Run the cascade.** Build stage1_rust. Fix the verifier errors
   it surfaces — each one is a real bug. Then run stage 2 → stage
   3. Fix the new errors that surface. Continue until parity.

### Estimated effort

**2-4 days of focused work**, not a session. Probably more like 4
than 2. The cascade from removing the runtime coercion will surface
30-50 individual emit-site bugs. Each is small. The aggregate is
the work.

**Do not attempt this in less than half a day per layer.** Rushing
this and committing partial fixes is how we got here.

### Why this is the only way forward

We have spent multiple sessions patching individual symptoms of this
single root cause. The score has walked in a tight circle (72 → 70
→ 64 → 70 → 64) for hours of work. Each patch exposes the next
symptom. Each "fix" requires another patch. **This is a sign that
the patches are at the wrong layer.**

The session log (search "session_2026" in `~/.claude/projects/...`)
shows the same bug being re-discovered in different forms across
every session for weeks. This is technical debt compound interest.
The only way out is to pay it down all at once.

After this refactor lands, the remaining stage 3 work will be
*linear* (one bug, one fix, one diff drop) instead of
*combinatorial* (one fix exposes three new bugs because they were
all entangled with the same hack).

---

## ───────────────────────────────────────────────────────
## SESSION HANDOFF (2026-04-07 evening, second session)
## ───────────────────────────────────────────────────────

> Read this whole section before reading the rest of the doc. Then read
> CLAUDE.md (the **NO WORKAROUNDS** section at the very top is
> non-negotiable).

### Where things stand
- `make stage1-rust` builds clean.
- `./build/stage1_rust build packages/forgec/src/main.fg` produces
  `output.ll` (Stage 2 IR) cleanly. **395 functions**, score 72,
  builds + links + runs.
- `bash scripts/diagnose.sh --pipeline` tail says
  `Stage 3 IR produced — no /tmp/output.ll` — i.e. stage 2 binary
  segfaults when compiling main.fg. The crash currently lands in
  `Codegen_emit_statement + 88` during `>> span_new`. Same crash hits
  hello-world (`/tmp/_t1.fg`) sometimes — appears intermittent /
  build-cache-sensitive, hello-world has been seen to compile on a
  fresh build.
- `bash scripts/diagnose.sh --binop-test` (the canonical "is the
  parser/codegen actually working" probe) was at **9/10 passing**
  earlier today and `match_enum` was the only failure. After the
  changes below it should still pass — re-run it first thing.
- Stage 3 progress score (`bash scripts/diagnose.sh --progress`) was
  at **44%** before the latest unfinished work. Composite breakdown
  was: fn-count 100% × 0.20, body parity 61% × 0.40, hello-world
  boot 0% × 0.10, binop runtime 0% × 0.30.

### What I was actually working on (mid-fix, NOT FINISHED)

The remaining body-parity gap is overwhelmingly explained by
**`return Pattern.EnumVariant(...)` and any other `EnumName.Variant(args)`
constructor in tail-return position emitting `ret zeroinitializer`** in
the *self-host's* output (NOT in the rust compiler's output). The rust
compiler's `compile_enum_constructor` works fine — `--emit-ir` of a
small repro shows correct alloca + insertvalue + load. The self-host
just doesn't have an emit path for enum constructors at all.

Concrete root cause:
- The Forge parser produces `EnumName.Variant(args)` as a regular
  `Expr.Call(MemberAccess(Ident(EnumName), Variant), args)` AST node.
  There is **no** separate `Expr.Feature("enums", "enum_construct")`
  node — `make_enum_construct` exists in `features/enums/mod.fg` but
  is never called from the parser.
- `dispatch_emit_expr` in `features/mod.fg` therefore never gets a
  chance to dispatch enum construction.
- The self-host's `Codegen.emit_call`'s `.MemberAccess(o, f, s)` arm
  doesn't recognize the enum-constructor pattern at all. It falls
  through, eventually returning a default zero/null which then gets
  wrapped (incorrectly, with the wrong size) into the function's
  Nullable return.

**The fix in flight (finish this):**

1. **NEW FUNCTION** `Codegen.emit_enum_construct_inline(self, enum_name,
   variant_name, args)` was added in `packages/forgec/src/codegen/mod.fg`
   (around line 2425). It uses `cg_get_enum_ty_for`,
   `cg_enum_variant_field_types`, `cg_enum_field_slot_offset`, and
   `match_enum_tag`. It allocas the enum struct, stores the tag byte,
   packs each arg into the right `i64` slot(s) per the field-type code
   ("i" = 1 slot, "s"/"l" = 2 slots, "4" = 4 slots), and loads/returns.
   It guards `s`/`l` against non-struct values so a wrong-typed `v` does
   not crash `build_ptrtoint`.

2. **NEW HELPER** `ident_name_of(e: Expr) -> string` near `coerce_to_fn_return`
   (returns the name of an `Expr.Ident`, or `""`). Lifted out of a nested
   match because the rust compiler historically miscompiles match-in-match.

3. **NEW DISPATCH** in `emit_call`'s `.MemberAccess(o, f, s)` arm:
   ```forge
   let enum_name = ident_name_of(o)
   if enum_name.length > 0 && forge_enum_type_exists(enum_name) == 1 {
       return self.emit_enum_construct_inline(enum_name, f, args)
   }
   ```
   Currently in the file. **THIS IS WHAT BREAKS STAGE 2.** Without
   this 4-line block, stage 2 binary compiles main.fg cleanly. With
   it, stage 2 binary segfaults during `>> span_new` (or anywhere
   else) at `Codegen_emit_statement + 88`. The crash is intermittent
   on the first build attempt and reliable on subsequent attempts.

4. **NEW DISPATCH ENTRY** in `features/mod.fg`'s `dispatch_emit_expr`:
   ```forge
   else if fid == "enums" { return emit_enum_construct(cg, node) }
   ```
   This is dead code right now (the parser doesn't produce
   `Feature("enums", "enum_construct")` nodes), but it's harmless
   and lines up with future parser work.

5. **NEW UNUSED FUNCTION** `emit_enum_construct(cg, node)` in
   `features/enums/mod.fg`. Same body shape as
   `emit_enum_construct_inline` but takes a `NodeRef` and looks up
   `ENUM_CONSTRUCTS`. Not yet reachable.

### Why item #3 crashes — what to chase

The crash signature:
```
forge: fatal error — segmentation fault
0  stage2  forge_signal_handler + 464
1  libsystem_platform.dylib  _sigtramp
2  stage2  Codegen_emit_statement + 88
```
Always +88 from emit_statement, always during compilation of the
*first* function emitted. Last good trace before crash is `[T] 999
999` (entry of emit_statement) followed sometimes by `[T] 0 998`
(.Expr arm). The crash is in the load right after extracting the
boxed Expr ptr from `Statement.Expr`.

What I confirmed:
- `ident_name_of` and `forge_enum_type_exists` calls alone do NOT
  trigger the crash. Removing the call to
  `self.emit_enum_construct_inline(...)` (but keeping the helper
  call and the if-check) makes stage 2 work again.
- The IR for `Codegen_emit_call` after the fix shows the exact call
  site `call ptr @Codegen_emit_enum_construct_inline(ptr %0,
  %ForgeString %enum_name99, %ForgeString %f100, %ForgeString
  %args101)`. The signature matches. Both the function and the call
  site agree the third arg is `%ForgeString` (List<Expr> maps to it).
- Score regresses 18 → 72 with the new code, mostly from new
  `ret_undef` sites — likely because `emit_enum_construct_inline`
  itself contains `for arg in _args { ... }` and the inner code
  produces some bad returns.

What I would do next:
1. `bash scripts/diagnose.sh --fn-ir Codegen_emit_enum_construct_inline output.ll`
   and read the IR. Look for any `ret`, dead bbs, mistyped store
   widths into the `enum_tmp` alloca, or `inttoptr` of a non-int.
   The bug is almost certainly a mismatched-store-size between the
   value coming back from `emit_expr(arg)` and the i64 slot it gets
   stored into.
2. Diff `Codegen_emit_call` before/after the call-site addition with
   `--diff-fn`. Look for verifier warnings like `Terminator found in
   the middle of a basic block!` which the rust compiler prints to
   stderr during build — that's a red flag.
3. The "intermittent crash on first build" thing — investigate
   whether output.ll is sometimes stale. The pre-commit hook updates
   `forge/scripts/stage3_baseline.txt`, but `make stage1-rust` may
   not be picking up changed `mod.fg` files via its dependency graph.

### What you do NOT do

- **No workarounds.** Read the **NO WORKAROUNDS** section at the top
  of `CLAUDE.md`. The previous agent (me) committed six of them in a
  row this week and you can see how that played out — it just moved
  the bugs around. If you find yourself wanting to "rewrite the call
  site to avoid the broken pattern" or "use a temporary variable to
  dodge the miscompile" — STOP and fix the actual bug instead.
- **No rewriting parse_pattern in self-host source to dodge the
  enum-constructor problem.** The fix is in
  `Codegen.emit_enum_construct_inline` + the dispatch in
  `emit_call.MemberAccess`.
- **No deleting `emit_enum_construct_inline` to make stage 2 build.**
  That just gets us back to a broken-but-quiet state.

### Useful diagnostics added this session

```bash
bash scripts/diagnose.sh --binop-test       # 10 runtime fixtures, fastest probe
bash scripts/diagnose.sh --progress         # composite % toward stage 3 self-compile
bash scripts/diagnose.sh --show-fn <fn>     # stage 2 vs stage 3 IR side-by-side
bash scripts/diagnose.sh --fn-ir <fn> [.ll] # dump one function's IR (no awk)
bash scripts/diagnose.sh --ret-undef [.ll]  # functions returning undef
```

The progress guard (`forge/scripts/check_stage3_progress.sh`,
`.githooks/pre-commit`) blocks commits that regress stage 3 metrics.
Bypass with `--no-verify` only when intentional. Run with `--update`
after a deliberate metric shift to rebaseline.

### One-shot recovery (if everything's broken)

```bash
make stage1-rust
./build/stage1_rust build packages/forgec/src/main.fg
cp output.ll /tmp/stage1_output.ll
/opt/homebrew/opt/llvm@19/bin/llc -O2 -filetype=obj /tmp/stage1_output.ll -o /tmp/stage2.o
cc -o /tmp/stage2 /tmp/stage2.o build/runtime.o -lm \
   -Wl,-stack_size,0x10000000 \
   packages/std-llvm/target/release/libforge_llvm.a \
   -L/opt/homebrew/Cellar/llvm@19/19.1.7/lib -lLLVM-19 -lstdc++ -lz -lcurses
/tmp/stage2 build /tmp/_t1.fg && ./a.out   # should print "hi"
```

If stage2 segfaults: revert the `.MemberAccess` arm dispatch in
`packages/forgec/src/codegen/mod.fg` (remove the `let enum_name = …`
+ `if … { return self.emit_enum_construct_inline(...) }` block, but
keep `emit_enum_construct_inline`, `ident_name_of`, and
`emit_enum_construct` defined). That gets back to a green stage 2
without losing the foundation of the fix.

## ───────────────────────────────────────────────────────
## ORIGINAL DOC (pre-handoff)
## ───────────────────────────────────────────────────────

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

### CORRECTION (2026-04-07d): the 72-iter trace was a different match

Initial runtime tracing showed an emit_match_arms call running 72
iterations and the diagnosis was "List<MatchArm> corruption". That
diagnosis was **wrong**. Verified by:
1. Adding `forge_trace_i64(6000, arms.length)` at entry to
   emit_match_arms — distribution shows 27 matches with 2 arms,
   10 with 3, ..., and outliers at 11, 12, 13, 16, 17, 19, **43, 44,
   72, 87**.
2. Adding parser-side trace (`forge_trace_i64(7000, arms.length)`
   at end of `parse_match_expr`) — parser produces the same
   counts as codegen.
3. Source search: `parser/mod.fg:1163` `Parser.kind_to_key()` is
   a real 87-arm match dispatching all `TokenKind` variants.
   `lexer/mod.fg:1000` is the 44-arm one. Both are legitimate.
4. Counting `icmp eq i64 %level` in token_to_binop_key's stage 2
   IR: **11 dispatches** for 12 arms (wildcard has no icmp). The
   for loop iterates correctly — the bug is NOT iteration count.

So the original symptom — bb995 empty + arm body in orphan
blocks — is a builder-position drift WITHIN the iter, not a list
length problem. The 72-iter call is a separate (legitimate) match
that happens to have 72 real arms.

### Status: builder-drift root cause still unknown

Tested (all ruled out as the source):
- emit_pattern_bindings repositioning
- pattern_tag repositioning
- List<MatchArm> corruption
- Per-iter cg_reinit_types side effects

The drift IS happening — bb995 is provably empty + arm body lives
in `bb998: No predecessors!` — but every static suspect has been
ruled out. Next step: instrument the if-expression path
(`emit_if_expr` in `if_else/mod.fg`) directly with a position
trace at every step to find which `llvm.*` call moves the
builder away from arm_bb.

**Earlier diagnosis (via runtime tracing) — initial finding (NOW WITHDRAWN)**:
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
