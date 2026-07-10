# L2 — Compiled comptime / JIT: design + staged unblock (ps3t.5.1)

Spine: `docs/2026_06_14_AST_SOURCE_OF_TRUTH_EPIC.md` §Layer-2. Ticket: `ps3t.5` (epic), `ps3t.5.1` (this design), `ps3t.5.2` (ORC/JIT integration), `ps3t.5.3` (sandbox+purity), `ps3t.5.5` (memoization), `ps3t.5.6` (Value-deletion audit), `g18a` (interpreter removal).

## The finding that unblocks ps3t.5

The bd dependency `ps3t.5 → {ps3t.3 (L1), ps3t.4 (L3)}` is **over-conservative**. The JIT *mechanism* is not missing:

- **`avra_llvm_jit_run(module) -> int`** (`core/llvm.av:165`, impl `llvm_wrapper.c:1066`) already JIT-compiles an LLVM module and runs its `main()` **in-process via MCJIT** — and it is **live and proven**: `codegen/setup.av:529` uses it for `bs2 run`. The spine doc explicitly accepts MCJIT as a bootstrap stage-1 (ORC is a later polish, not a prerequisite).
- Codegen already emits every Avra fn to IR. **A `@comptime` fn IS an ordinary Avra fn** — codegen already produces its IR.

So the raw capability "compile an Avra fn to IR and run it in-process" **exists today**. What ps3t.5 replaces is the *tree-walking interpreter* (`features/eval/mod.av`), invoked at exactly two sites:

- `features/comptime/eval.av:69` — `eval_fn_with_resolved_args(...)` for **constant folding** (`@comptime` call sites collapse to a literal).
- `features/comptime/expand_macro.av:666` — `eval_fn_with_resolved_args(...)` for **`@expand` macro expansion** (a `@comptime` fn that RETURNS AST nodes).

## Where the real L1/L3 dependency actually lives (the split)

The two swap sites have very different marshaling costs, and this is the key to staging:

| Slice | Comptime fn shape | Marshaling | Real prerequisite |
|---|---|---|---|
| **A — constant fold** | scalar/`Value` in → scalar/`Value` out (`add(2,3)→5`, string concat, bool) | int/float/bool/string ↔ native — trivial | **none beyond today's codegen + MCJIT** — startable NOW |
| **B — AST-returning macros** | args in → **AST nodes** out (`@expand` builds `Stmt`/`Expr`) | the JIT'd fn allocates nodes that must land in the compiler's **arena** with correct **typed identity** | **L1 (arena bridge) + L3 (identity)** — this is the genuine dependency |

So: **Slice A is the unblock** — it proves compiled comptime end-to-end with zero L1/L3 work and immediately starts deleting the interpreter's hot path. Slice B trails L1/L3 (and is exactly the "delete `Value`, compiled comptime uses real types" ripple the spine describes).

## Stage 1 (startable now) — ps3t.5.2 slice A: JIT the constant-fold path

1. **JIT-call primitive** (`llvm_wrapper.c`, additive — no behavior change to existing paths):
   `avra_llvm_jit_call(module, fn_name, argc, i64* argv) -> i64` — MCJIT the module, `LLVMGetFunctionAddress(fn_name)`, call with the marshaled args, return the i64 result. (Reuse the `avra_llvm_jit_run` init block; factor a shared engine-create helper.) A `_f64`/pointer-return variant follows as needed; scalars-as-i64 covers int/bool and pointer-tagged string/Value.
2. **Marshal** at `comptime/eval.av`: `List<Value>` args → `i64[]` (int/bool direct; string/Value → pointer). Result `i64` → `Value` by the fn's declared return type (already known — the `@comptime` fn is typed).
3. **Emit the fn into a fresh throwaway module** (the fn + its transitive callees) OR reuse the already-emitted program module. Simplest first: a per-comptime-fn module cache keyed on the fn — folds `ps3t.5.5` (memoization) in naturally.
4. **Swap**: `eval_fn_with_resolved_args` → `jit_eval_fn` for the return-type set {Int, Bool, Float, Str}; **fall back to the interpreter** for everything else (macros/AST, unsupported types). This is `g18a`'s "interpreter stays as fallback until the JIT fully lands" — no capability regression on day one.
5. **Gate**: diff-test byte-identical (folded literals must be identical to the interpreter's) + selfhost fixed point + the comptime spec suite green. M3 holds by construction — same fold results, different evaluator.

Deliverable proof for ps3t.5.2-A: a `@comptime fn add(a: int, b: int) -> int { a + b }` used at a call site folds to `5` via the JIT (traced), interpreter path disabled for that shape, suite green.

### Stage 1 progress — spike landed + mini-Ctx path VALIDATED

Step 1 (primitive) and the crux the ticket flagged "unknown-until-tried" —
*can a single fn be codegen'd standalone and JIT-called?* — are done and proven:

- `avra_llvm_jit_call(module, fn_name, argc, i64* argv) -> i64` + the flat
  `avra_i64_buf_*` argv-marshalling helpers (`llvm_wrapper.c`), plus
  `compile_and_jit_call(stmts, type_reg, store, fn_name, argc, argv)`
  (`codegen/setup.av`) — the codegen+JIT building block `jit_fold_call` will
  drive. All additive; diff-test byte-identical, so zero behavior change.
- **Validated** by `codegen/tests/jit_call_slice_a_test.av`: a self-contained fn
  (with transitive callees, `if` control flow, and a runtime-trap call)
  codegen's standalone via `codegen_program` reusing the resolve-time
  `type_reg`, then JIT-calls with 0..4 i64 args and round-trips the i64 result
  (incl. negatives). The mini-Ctx approach works — `codegen_program` emits a
  single-fn subset into a valid module with no `main`.

**Load-bearing finding — in-process MCJIT needs `-rdynamic`.** A JIT'd body that
calls a runtime function (`avra_div_by_zero_trap` from an integer `/`, and every
string/list/map op) fails at materialization unless the host binary's `avra_*`
symbols are in the dynamic symbol table — MCJIT resolves externs via
`dlsym(RTLD_DEFAULT)`, which only sees exported dynamic symbols. Pure-arithmetic
bodies (no runtime refs) JIT without it; anything real does not. Fixed by adding
`-rdynamic` to the Avra program linker (`build/link.av build_link_argv`), which
covers test-shard binaries. **PR-B prerequisite:** bs2's own link
(`diagnose.sh link_ll`) needs the same flag before the fold path JITs inside the
compiler proper — the test binaries JIT today, bs2 will JIT once `fold_call`
swaps.

Remaining for the real integration (PR-B): marshal `Value` ↔ `i64` by declared
return type (mask bool to the low bit; bit-cast float; pointer for str/enum),
`build_comptime_fn_module` (fn + transitive `@comptime` callees), swap
`fold_call` to try the JIT for `{Int,Bool,Float,Str}` with interpreter fallback,
thread `type_reg` through `run_comptime`, and gate diff-test byte-identical.

## Stage 2 (trails L1/L3) — slice B: AST-returning macros

The JIT'd macro fn must build `Stmt`/`Expr` nodes. Today those are `Value`-boxed AST (`is_boxed_ast_kind`); compiled comptime builds **real** nodes, which must be interned into the compiler's arena (`ps3t.3` L1) with content-addressed identity (`ps3t.4` L3). This is the "delete `Value`" ripple (`ps3t.5.6`). Slice B is scheduled **after** L1+L3 land — but Slice A already retires the interpreter for the common fold path and de-risks the whole layer.

## Sandbox + static purity (ps3t.5.3) — build, not reuse

The spine says "reuse `@pure`". **There is no `@pure` annotation infra yet** (only a stray comment). ps3t.5.3 must:
- add a `@pure` (or `@comptime`-implies-pure) static check: a comptime fn's transitive call graph may touch only pure ops + `@embed` (no ambient IO/FS/net/clock/rand); reject otherwise before JIT.
- resource limits at the JIT boundary (instruction/alloc/time budget) — MCJIT gives us native execution, so limits are a real requirement, tracked under `ps3t.5.4`.

## Corrected ticket guidance

- `ps3t.5.2` re-scoped into **A (now, no L1/L3)** and **B (post-L1/L3)**. A is pickable immediately.
- The `ps3t.5 → ps3t.3, ps3t.4` epic edge is only tight for **Slice B**. Slice A + the interpreter-hot-path deletion can proceed in parallel with L1/L3.
- `g18a` (delete interpreter) stays last — only after Slice B covers macros.
