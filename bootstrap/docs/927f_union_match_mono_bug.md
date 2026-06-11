# 927f / zm77 — union-match arg "corruption": RC cleanup of unbound loop-locals

Status: **FIXED** (zm77). The last 3 spec failures (after the
metadata-serialization UAF fix took the suite 414 → 3) shared one root
cause — and it was NOT in the monomorphize pass, despite the earlier
pass-bisection pointing there.

## Symptom

```bash
cd bootstrap
./build/bs2 _test_shard tests/union_return_test.av
# => codegen error: unsupported expression type (tag=<heap ptr>)
```

The arg of the LAST union-match arm's `println` arrived at codegen with
a heap pointer in its Expr tag slot. Triggered only at scale (a second
union-match fn + ≥4 union matches), only on the test-assembly path.

## Actual root cause (found via hardware watchpoint)

A gdb watchpoint on the corrupt node's tag word caught the writer:

```
avra_rc_free(ptr=<AST node>)        ← frees the live Binary AST node
  ← __release_EmitValue
  ← fill_arg_array_boxing           ← emitting a ZERO-ARG call (n=0)
```

`ctx.bind` (codegen/types.av) registers RC-managed locals for scope-exit
cleanup. The alloca is entry-block-hoisted (llvm_wrapper.c
`avra_llvm_build_alloca`), but its **initializing store stays at the
declaration site**. For a local declared inside a loop (here: `mut r` in
`fill_arg_array_boxing`'s arg loop), a zero-trip execution leaves the
hoisted slot as **stack garbage**, and the function epilogue's
`emit_rc_cleanup` loads + releases it anyway.

Every zero-arg call site phantom-released 8 bytes of stack garbage. It
went unnoticed until the garbage happened to alias a live RC allocation
— the line-53 arm's AST node — which got freed mid-codegen and recycled
by malloc into codegen's own map/array structures (hence the
type-confused dump). This explains:

- the scale trigger (enough prior emission for the slot to alias a live node),
- Valgrind silence (the stray free hits a *valid* allocation, and the
  recycled writes stay inside valid malloc blocks),
- "typecheck clean / codegen corrupt" (the free happens DURING codegen,
  after the mono output was validated clean — the earlier mono-pass
  conclusion was an artifact of probing only pass boundaries).

## Fix

`avra_llvm_zero_init_local` (llvm_wrapper.c): stores `ConstNull` into
the hoisted alloca **in the entry block**, called from `ctx.bind` for
every cleanup-registered binding. A never-executed binding now releases
null, which `avra_rc_should_free`/`avra_rc_release` treat as a no-op.

Note: the fix lives in bs2's *codegen*, so it only takes effect in a
binary compiled BY a fixed compiler — a seed cycle (`make update-seed`)
was required before `build/bs2` itself stopped corrupting.

## Regression tests

- `tests/union_return_test.av` — the original deterministic failure.
- `tests/zero_trip_rc_cleanup_test.av` — direct exercise of the fixed
  path (RC struct local bound only inside a possibly-zero-trip loop,
  zero-trip and non-zero-trip calls interleaved).
