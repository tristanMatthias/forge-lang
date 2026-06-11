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

## Fix (as it evolved — current state last)

1. First fix: `avra_llvm_zero_init_local`, called from `ctx.bind` for
   cleanup-registered bindings. Initial placement (end of entry block)
   was WRONG — it clobbered locals bound while the builder still sat in
   the entry block (25 derive_walker failures); corrected to
   immediately-after-the-alloca.
2. **Current state** (merge 3f8798a9): the bind-level call was removed,
   replaced by a universal guard inside `avra_llvm_build_alloca` itself
   — EVERY pointer-typed alloca gets `store ptr null` right after
   creation. The merged tree had surfaced garbage READS beyond RC
   cleanup (uninit slots consumed as AST pointers), so the blanket
   guard covers the whole class: a never-initialized slot reads null,
   and releases of null are no-ops.
3. `AVRA_VERIFY_RC=1` (rcsf.2) machine-checks the invariant on every
   compiled module — each ptr alloca's next instruction must be its
   null store; violations fail the compile naming fn+slot. diagnose.sh
   runs it during the self-compile integrity check.

Note: the fix lives in bs2's *codegen*, so it only takes effect in a
binary compiled BY a fixed compiler — a seed cycle (`make update-seed`)
was required before `build/bs2` itself stopped corrupting.

## Regression tests

- `tests/union_return_test.av` — the original deterministic failure.
- `tests/zero_trip_rc_cleanup_test.av` — direct exercise of the fixed
  path (RC struct local bound only inside a possibly-zero-trip loop,
  zero-trip and non-zero-trip calls interleaved).
