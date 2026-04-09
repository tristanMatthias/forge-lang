# Ralph Goal: Bootstrap Compiler Polish

The bootstrap compiler under `bootstrap/` is self-hosted and
feature-organized. The migration is done. What remains is polish:
capturing more regression tests, removing debug noise, and
hardening the std-llvm wrapper.

Each task below is a self-contained commit. Run `make -C bootstrap
test` after every change and only commit if it passes (7/7 regress
+ bs2/bs3 fixed-point byte-identical).

## Rules

- Read `bootstrap/CODE_QUALITY.md` before making ANY change
- Read `bootstrap/PLAN.md` Backlog section for full context
- NEVER use `git checkout --` on modified tracked files
- NEVER add mutable globals to the bootstrap
- NEVER add `// TODO` — use PLAN.md backlog instead
- Every commit must pass `make -C bootstrap test`
- If stuck after 3 attempts, skip to the next task

## Tasks (each = one commit)

### 1. Capture more regression tests
Add regression tests for: enum match, struct mutation, while+break,
nested if-else expression, multi-arg function call, string
substring. Each is one `.fg` file compiled by bs2.
```
cd bootstrap
bash scripts/diagnose.sh --regress-add enum_match <file>
bash scripts/diagnose.sh --regress-add struct_mut <file>
# etc.
```
Verify: `make test` still passes with the new tests.

### 2. Remove `[BC]` debug print from std-llvm
In `forge/packages/std-llvm/src/lib.rs`, the `bld_trace2` function
in `forge_llvm_build_call` prints `[BC]` to stderr on every call.
Gate it behind an env var check (`FORGE_LLVM_TRACE=1`) or remove
it. Then rebuild: `cd forge && cargo build --release`.
Verify: `make -C bootstrap test` passes, no `[BC]` lines in output.

### 3. Audit std-llvm silent fallbacks
In `forge/packages/std-llvm/src/lib.rs`, grep for
`return LLVMConstInt` and `return LLVMGetUndef`. Each is a
candidate silent fallback that should be replaced with
`eprintln! + null` (the "no fake successes" rule from
`bootstrap/CODE_QUALITY.md`). Triage each: if it's a legitimate
constant answer, leave it. If it's a "I don't know what to do"
fallback, replace with eprintln + null.
Verify: `cd forge && cargo build --release && cd .. && make -C bootstrap test`.

### 4. Add `example.fg` + `expected.out` to remaining features
These features have `WHY.md` and `grammar.md` but no executable
example: if_stmt, while_stmt, return_stmt, let_stmt, fn_decl,
extern_decl, impl_decl, struct_decl, enum_decl.
For each, write a minimal `.fg` file that exercises the feature,
compile it with bs2, capture the output.
Verify: each example compiles and runs correctly through bs2.

### 5. Short-circuit && / || lowering
In `bootstrap/src/codegen/mod.fg`, `emit_binary` lowers `&&` as
`mul(zext(a), zext(b))` and `||` as `add(zext(a), zext(b)) != 0`.
Both sides are ALWAYS evaluated (eager). Replace with proper
short-circuit: cond_br on the first operand, only evaluate the
second if needed, phi the result.
Verify: `make -C bootstrap test` + write a regression test that
would crash under eager evaluation (e.g. `if x != null && x.field`).

### 6. emit_stmt_as_value coverage audit
In `bootstrap/src/codegen/mod.fg`, `emit_stmt_as_value` handles
`Expr`, `Block`, `Match`, `If` in tail position. Verify no other
Stmt variant could legitimately yield a value. Add a comment
documenting the choice for each variant. If `While` or `For`
should yield a value, implement it.
Verify: `make -C bootstrap test`.

### 7. Exhaustive match audit
Grep all codegen files for `_ -> {}` and `_ -> ok_stmt` and
`_ -> err_stmt`. Each is a silent swallow. Verify that every
swallowed case is genuinely a no-op. If any should produce a
value or an error, fix it.
Verify: `make -C bootstrap test`.

### 8. Remove bootstrap stderr debug noise (TECH_DEBT #2)
The host runtime prints `[char_at #N]` traces to stderr on every
bootstrap run. Find the source in `forge/stdlib/runtime.c` (look
for `char_at` debug prints) and either remove them or gate behind
an env var like `FORGE_DEBUG_RUNTIME=1`.
Verify: `make -C bootstrap test` produces no `[char_at` lines.

### 9. Clean up TECH_DEBT.md
Review `bootstrap/TECH_DEBT.md`. Items marked [FIXED] should be
collapsed to one-liners. Items that are no longer relevant (because
of the feature migration or the Ctx refactor) should be marked as
resolved. Don't delete them — just update status.
Verify: no code changes needed, just documentation.
