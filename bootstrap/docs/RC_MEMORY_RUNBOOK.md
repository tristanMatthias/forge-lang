# RC / memory-corruption runbook

One-stop operational doc for memory-corruption symptoms in the
bootstrap compiler. Everything here was earned the hard way (zm77 +
the 2026-06-11 merge); start here before improvising.

## The invariant

**Every pointer-typed alloca is null until first stored.**
`avra_llvm_build_alloca` (llvm_wrapper.c) emits `store ptr null`
immediately after every ptr alloca it creates — and it is the only
alloca source. Consequences:

- Scope-exit RC cleanup of a never-bound local releases null → no-op.
- A read of a never-initialized slot yields null → deterministic null
  error, never layout-sensitive garbage.

`AVRA_VERIFY_RC=1` machine-checks this on every compiled module
(each ptr alloca's next instruction must be its null store; violation
= compile failure naming fn + slot). diagnose.sh runs it during every
`--build-bs2` self-compile integrity check, so commit-grade builds
cannot regress the guard silently.

## Symptom → action

| Symptom | Likely cause | First move |
|---|---|---|
| `unmatched tag <huge value>` / `unsupported expression type (tag=<heap ptr>)` | A node slot holds a non-node pointer: freed-and-recycled memory or garbage stored into the AST | `AVRA_VERIFY_RC=1 ./build/bs2 compile <repro>` — if it FAILS, the guard regressed; fix that. If ok → watchpoint hunt (below) |
| Crash only at scale / only in test-assembly / "flaky" | Layout-sensitive UB; with the guard in place, suspect a *stale binary or seed* compiled before the guard | Confirm the binary is fresh (`rm -rf packages/cli/src/build/cache && rm -f build/bs2 && make build-quick`); remember: codegen fixes only take effect in binaries compiled BY a fixed compiler (seed cycle may be needed) |
| `A null value was used where an object was expected` | Real definite-assignment bug, surfaced *cleanly* by the guard (pre-guard this was silent garbage) | Find the unset path; this is a source bug, not a guard bug |
| `__release_*` frees a live object | EmitValue/struct released through a slot that aliases live data — should be impossible post-guard; check verifier first | Watchpoint hunt |
| Test fails only in the bundled suite, instant (~ms) "failure" | Poisoned fixture-stdout cache (it caches `PROBE ...: FAIL` by design — see bead fxfz) | `rm -rf build/cache/fixture_stdout`, re-run the single file |

## The watchpoint hunt (deterministic, ~15 min)

When something corrupts memory and you need WHO, do this — do not
guess from source:

```bash
# 1. Stable addresses: ASLR off. The failing address prints in the
#    error (or add a probe). Run twice to confirm it repeats.
setarch -R ./build/bs2 compile <repro> 2>&1 | grep "tag="

# 2. Watch the address. Break at a point AFTER it should be valid
#    (e.g. codegen entry) or just `break main` and accept the
#    allocation hit first.
cat > /tmp/w.gdb <<EOF
set pagination off
set confirm off
break main
run compile <repro>
delete
watch -l *(long long*)0xADDR
commands
silent
bt 8
continue
end
continue
quit
EOF
gdb -batch -x /tmp/w.gdb ./build/bs2 > /tmp/w.out 2>&1
# The LAST backtrace before the failure is the corrupting write.
```

Reading the result:
- Writer = `tcache_put`/`_int_free` → something FREED the object:
  walk up to the `__release_*` frame. To see the released value,
  break at the release fn with a register condition
  (`break *<addr> if $rdi == 0xADDR`) — Avra passes small structs
  by value in `rdi/rsi`.
- Only ONE write ever (the later allocation) → the pointer was
  **never valid**: garbage was stored into the referencing slot.
  Find who wrote the slot, not the target.
- Address symbolication: `nm build/bs2 | grep <fn>` + offsets, or
  `addr2line -f -e build/bs2 <offset>`.

Useful perturbation checks: if the crash dodges under any probe /
`AVRA_PAGE_ALLOC=1` / `AVRA_REDZONES=1`, it is layout-sensitive
garbage — which post-guard means a stale binary or a new bypass.

## Tools inventory

| Tool | What |
|---|---|
| `AVRA_VERIFY_RC=1` | IR verifier for the invariant (this doc, rcsf.2) |
| `AVRA_RC_STRICT=1` / `make test-strict` | strict allocator (rcsf.3): poison-on-free (0xDD), quarantine ring verifying poison on eviction (UAF writes abort), abort on retain/release of a freed pointer. UAF reads see 0xDDDD… tags — deterministic, never layout-luck |
| `AVRA_TRACK_STORES=1`, `AVRA_REDZONES=1`, `AVRA_PAGE_ALLOC=1` | runtime store-tracking / redzone / page-alloc modes (runtime.c) |
| `avra_trace_ptr`, `avra_dump_stmt`, `avra_dump_function` | C-side tracing — never `eprintln` in hot paths |
| `setarch -R` | ASLR off for stable addresses outside gdb |
| `bash scripts/diagnose.sh --help` | all build/analysis entry points |

## History & open work

- Post-mortem narrative: `927f_union_match_mono_bug.md` (zm77: phantom
  release of uninit cleanup slots froze a live AST node; fix evolved
  bind-level → universal alloca guard → this verifier).
- Open hardening: beads epic `rcsf` — `.4` phase arenas for
  the AST, `.5` definite-init analysis + block-scoped cleanup (the
  principled replacement for the blanket guard), `.1` registration
  encapsulation (hygiene).
- Seed-merge interactions: `SEED_MERGES.md` (a pre-guard seed can
  emit corrupting stage binaries — choose base seeds accordingly).
