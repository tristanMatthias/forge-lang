# Post-Mortem: Module System Debug Session (April 11, 2026)

## The Bug

`bind_params_ctx` matched on a 2-variant `ParamList` enum. The bootstrap's
match codegen initializes `match_result = 0` and generates a fallthrough
path that returns 0 when no arm matches. A corrupt/unexpected tag byte hit
the fallthrough, returning null as the `NameCtx`, which propagated through
thousands of calls until `rewrite_ident` dereferenced `ctx.locals` at
address `0x18` (null + offset) and segfaulted.

**Time to find: ~6 hours. Time to fix: 30 seconds (`_ -> ctx` catch-all).**

## Root Cause

The bootstrap compiler's match codegen does this for every match expression:

```
store i64 0, ptr %match_result          ; initialize to 0
; ... check tag == 0 (arm 1) ...
; ... check tag == 1 (arm 2) ...
march_next_final:
  br label %match_end                    ; FALLTHROUGH: no arm matched
match_end:
  load i64, ptr %match_result            ; returns 0 if no arm set it
  ret i64 %match_val
```

For an "exhaustive" 2-variant enum, the fallthrough is supposed to be dead
code. But if the tag byte is corrupt (e.g., uninitialized bump memory,
enum layout mismatch), the fallthrough executes and returns 0 = null.

## Why It Took 6 Hours

### 1. Zero visibility into what was happening

The only diagnostic was:
```
segfault at rewrite_expr + 104
```

This pointed to the WRONG function. The actual crash was in `rewrite_ident`
(called from `rewrite_expr`). I couldn't see:
- Which function actually crashed
- What the argument values were (ctx was null)
- Which of the 8000+ calls was the broken one
- Whether it was a null pointer, bad pointer, or stack overflow

### 2. Guessing instead of diagnosing

Every theory was wrong:
- "Two-struct-arg calling convention bug" → debunked, tested directly
- "LLVM -O2 miscompilation" → partially real (different bug) but not the root cause
- "Stale seed" → real problem that kept happening, but not the root cause
- "~8200 expression count threshold" → wrong, proved with dummy functions
- "Stack overflow" → tested with 64MB stack, still crashed

Each wrong theory led to hours of experiments. The actual bug (match
fallthrough returning null) was never considered until lldb showed
`x8 = 0` and `ldr x0, [x8, #0x18]` = access at address 0x18.

### 3. Seed system multiplied every mistake

Each experiment required: edit → rebuild seed → rebuild bs2 → test.
That's 3-10 minutes per attempt. With ~20 failed attempts = hours of
waiting. Plus seed contamination (accidentally committing bad seeds)
created cascading failures.

### 4. lldb was a last resort instead of first tool

One lldb run found the bug in the crash output:
```
EXC_BAD_ACCESS (code=1, address=0x18)
frame #0: rewrite_ident + 36
ldr x0, [x8, #0x18]   ; x8 = 0, loading ctx.locals from null
```

But lldb took 5+ minutes under the debugger because it was compiling
the full 8000-line bootstrap source. I only ran it once, at the very end.

---

## Action Plan

### 1. Non-exhaustive match compiler error

**Priority: CRITICAL — prevents this entire class of bug**

Like Rust, Swift, and every modern language: if a match doesn't cover all
variants and has no `_ ->` catch-all, emit a compile error:

```
error: non-exhaustive match on `ParamList` — missing variant `.Node`
  --> src/core/names.fg:302:5
```

Implementation:
- In the match codegen (`features/match_expr/codegen.fg`), after processing
  all arms, check if every variant of the enum was covered
- If not, and there's no wildcard arm, report the error
- The enum registry already tracks all variants — just compare matched tags
  against the full variant list
- Additionally: the match fallthrough should call `forge_match_unreachable(fn, tag)`
  instead of silently returning 0, as a runtime safety net even when the
  compiler check passes (defensive programming for corrupt data)

### 2. Better crash diagnostics

**Priority: HIGH — turns 6-hour hunts into 5-minute fixes**

Current crash output is nearly useless. We need:

#### a) Full symbolicated backtrace
The signal handler captures 64 frames but `backtrace_symbols_fd` only
resolves ~3 on macOS. Use `dladdr()` to resolve ALL frames:

```c
for (int i = 0; i < n; i++) {
    Dl_info info;
    if (dladdr(frames[i], &info) && info.dli_sname) {
        fprintf(stderr, "  %2d  %s + %lld\n", i, info.dli_sname,
                (long long)((char*)frames[i] - (char*)info.dli_saddr));
    }
}
```

#### b) Register dump at crash point
Use `sigaction` with `SA_SIGINFO` to capture the `ucontext_t` at crash:
```c
ucontext_t *uc = (ucontext_t *)context;
// ARM64: x0-x7 are argument registers
fprintf(stderr, "x0=%p x1=%p x2=%p x3=%p\n", ...);
```

If x0 is 0, we immediately know "first argument is null."

#### c) Null argument detection in debug mode
`make build-debug` adds null checks at every function entry:
```
fn foo(ctx: NameCtx, x: int) {
    // Generated: if ctx == null { panic("null arg 'ctx' in foo") }
    ...
}
```

Expensive but catches null propagation at the SOURCE instead of at the
crash site 8000 calls later.

### 3. Debug compile mode

**Priority: HIGH — makes lldb usable**

Problems:
- Full bootstrap takes 5+ minutes under lldb
- No way to compile partially
- No way to skip expensive passes for quick iteration

Solutions:

#### a) `--stop-after <pass>` flag
```bash
bs2 compile --stop-after=parse src/main.fg     # just parse
bs2 compile --stop-after=resolve src/main.fg   # parse + resolve
bs2 compile --stop-after=names src/main.fg     # parse + resolve + name res
```

When the crash is in `resolve_names`, compiling only through that pass
is 10x faster and makes lldb responsive.

#### b) `make build-O0` target
Build everything at -O0 for debuggability. The current build always
uses -O2. Having a one-command -O0 build would make lldb + breakpoints
practical.

#### c) Module-level compilation
```bash
bs2 compile --only-module=core.names src/main.fg
```

Compiles the full source but only emits codegen for one module. This
would let us test specific functions without processing everything.

### 4. Seed verification and safety

**Priority: HIGH — prevents cascading seed failures**

#### a) `make verify-seed`
Before committing, verify that:
1. The seed can compile the current source
2. The resulting bs2 can self-compile
3. The function signatures in seed.ll match the source declarations

```bash
make verify-seed  # runs all 3 checks, prints OK or specific failure
```

#### b) Seed function signature checker
On every `make build`, compare the function signatures in seed.ll against
the source. If a function changed its parameter count (e.g., `rewrite_expr`
went from 1-param to 2-param), warn BEFORE attempting compilation:

```
WARN: seed has rewrite_expr(i64) but source has rewrite_expr(NameCtx, Expr)
      Run 'make update-seed' to sync
```

This would have caught the "stale seed" issue in 0.1 seconds instead of
30 minutes.

#### c) Seed provenance tracking
Add a comment to seed.ll recording what source commit it was built from:
```llvm
; seed built from commit abc1234 at 2026-04-11T14:30:00
; source hash: sha256:...
```

Then `make build` can compare and warn when the seed is out of date.

### 5. Faster debug cycle

**Priority: MEDIUM — reduces experiment time from 3min to 30sec**

#### a) Incremental seed updates
Instead of rebuilding the entire seed, detect which functions changed and
only update those in the seed.ll. This reduces seed update time from
~60s to ~5s for single-function changes.

#### b) In-process self-compile test
Instead of spawning `bs2 compile src/main.fg` as a separate process,
have a `--self-test` flag that compiles the source in-process. This
eliminates process startup overhead and makes the test ~2x faster.

#### c) Parallel regression tests
The 221-test regression suite runs sequentially. Parallelize with
`xargs -P` or GNU parallel to reduce from ~60s to ~10s.

---

## Summary

| Tool | Prevents | Effort | Impact |
|------|----------|--------|--------|
| Non-exhaustive match error | Silent null returns | Medium | Eliminates the bug class |
| Full backtrace + registers | Blind debugging | Small | 10x faster crash diagnosis |
| Null arg debug mode | Null propagation hunts | Medium | Catches bugs at source |
| --stop-after flag | Slow lldb | Small | Makes debugger practical |
| Seed signature checker | Stale seed cascades | Small | Instant seed mismatch detection |
| Seed provenance tracking | Seed contamination | Small | Clear audit trail |
| make build-O0 | Debugger unusable | Small | One-command debug build |
| match_unreachable runtime trap | Silent fallthrough | Small | Runtime safety net |
