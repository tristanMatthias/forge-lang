# 927f — union-match-arm arg corruption in the monomorphize pass

Status: **diagnosed, not fixed.** One bug accounts for the last 3 failures
in the spec suite (after the metadata-serialization UAF fix took it 414 → 3).

## Reproduce (deterministic)

```bash
cd bootstrap
rm -rf build/cache/*                       # MUST clear — a stale-good test
                                           # binary in the cache hides the bug
./build/bs2 _test_shard tests/union_return_test.av
# => shard compile failed: codegen error: unsupported expression type (tag=<heap ptr>)
```

`bs2 test tests/union_return_test.av` also fails (always recompiles). The
"flakiness" seen earlier was **test-binary cache hits masking it**, not a
heisenbug — fresh compile fails every time.

## What it is

- **Deterministic logic bug, NOT memory corruption.** Valgrind memcheck with
  a 1 GB freelist quarantine reports **0 errors** — no UAF, no invalid read,
  no uninitialized read. (An earlier `--wrap=free` "found free" was a false
  positive from glibc address recycling.)
- At codegen, `emit_println`'s arg (`se.node`) is a **type-confused node**:
  its first word (the Expr tag slot) holds a **heap pointer** instead of a
  djb2 tag, i.e. some non-Expr/wrapped node sits in the arg slot.

## Where (pass-bisected)

Probe (`avra_dbg_dump_expr(label, expr)` that fires when `expr[0]` is a
heap-range pointer) placed at the typecheck `check_expr` entry (label 111)
and the codegen "unsupported expression" arm (label 999):

- **Typecheck: clean** — no expr has a heap-range tag (the large values seen
  there are legit djb2 hashes; the corruption probe needs a threshold that
  distinguishes heap pointers `0x5xxxxxxxxxxx` from large tags, since djb2
  hashes exceed `0x500000000000`).
- **Codegen: corrupt** — the arg's tag is a heap pointer.

⇒ corruption is introduced in **`monomorphize`** (the only pass between
typecheck and codegen). File: `packages/std-avrac/src/features/generics/mono.av`.

## Trigger conditions (minimized)

- Test-assembly compile path (module-wrapped + reporter). Plain
  `bs2 compile` of the *identical* source works.
- Requires a second `int | string` union-match function present
  (`ur_match`) **plus ≥4 union matches** in `ur_run`. Removing `ur_match`,
  or dropping to ≤3 matches, makes it pass. Pure scale/accumulation
  threshold.
- Fails at the **last** match's string arm (`union_return_test.av:53`,
  `println("struct field: " + s)`).

## Next step

Instrument inside `mono.av` — the arm / SExpr-list rebuilders
(`substitute_expr_list`, `rename_self_calls_arms`, `rename_self_calls_sexpr_list`,
and the generic call-site rewrite that rewrites `string(n)` call sites) — for
an indexing / aliasing bug that lands the wrong (adjacent, valid) AST node in
the arg slot once enough union-match arms have been processed. The wrong node
points to a valid Expr, consistent with an off-by-one / shared-node list
rebuild rather than freed memory.
