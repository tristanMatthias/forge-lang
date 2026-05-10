# Plan: collapse `bs2 test` into the standard `bs2 build` pipeline

Source: this chat (session `a5c839e1-d683-4c63-9153-ed2d11523ec6`),
2026-05-09 evening, just before context compaction.

## Your articulation (verbatim, in order)

1. **22:42 UTC** — "why are tests so disconnected or strange from our build chain? i forget why"
2. **~midnight UTC** — "i want to use the centralized build archiecture. we shouldn't have drift betwen test and build right? Or am I wrong about that?"
3. **00:01 UTC** — "yeah i dont want anything fancy for tests particularuly. ideally it just uses the **exct same architecture as thebuild command**. maybe i am wrong, but i think we can right? if we need to adad something to build process we absoutely can. but i want this to be a really clean codebase, and not random build processes"
4. **00:07 UTC** — "I want to make sure we can use our **internal functions as opposed to needing to execute a shell command**. new proceses are fine, but **can't we call a compile(filepath) function somehwere?**"
5. **00:11 UTC** — "ok aure" (green-light)

## The 5-task plan

1. **Survey manifest parser + build-driver entry path** — find extension point for `[[test]]` next to `[bin]/[lib]`. _(completed)_
2. **Add `[[test]]` target type to manifest schema** — name + src glob; auto-include spec_test reporter + synthesized `main()`. _(completed — but later partially reversed; see §Direction below)_
3. **Wire build driver to handle `[[test]]` targets** — `build_inputs_for_target(test)` reuses `[bin]` path: glob → modules → hoist @std → reporter → main(`test_render_summary`); same `compile_program/decide_build/record_build_result` downstream. _(in_progress — staged work has BuildInputs.kind="test", driver-side decide/record unified)_
4. **Collapse `run_test_command` into a build shim (~30 lines)** — parse args → find test target → invoke build → exec binary. **Delete the 250+ lines of in-process Module synthesis** (current `main.av:1811–2115`). _(pending)_
5. **Remove dead hkms.1 test-cache code** — `decide_test_build`, `record_test_build_result`, `cache_publish_test`, `cache_has_test`, `entry_bin_path`, `TestBuildInputs` in `driver.av` + `cache.av`. _(pending)_

## Architectural pivot (from your conversation, idx 8696)

- Both `bs2 compile` and `bs2 test` already call `codegen_and_emit_object` in-process; sequential = a tight loop, parallelism = reuse `bs2 build --per_module`'s `pool_run` fan-out.
- Replace `find` shell-out with manifest glob.
- Binary `cp` becomes `avra_selfhost_read_file_bytes` / `write_file_bytes`.

## Direction question that came up after compaction

The staged work in `package.av` + `avra.toml` *removed* `[test]` from the manifest — direction reversed mid-stream by some prior loop iteration to "tests are discovered by convention (`**/*_test.av`); only BuildInputs/driver layer is unified, not the manifest."

**You picked direction (B):** discovery by convention, unification at driver layer only. That's what's currently staged.

## Working-tree state right now

- **Staged (test-cache work, ~700 lines, direction B):**
  - `avra.toml`: `[test]` section removed
  - `packages/std-avrac/src/features/modules/package.av`: `BuildTarget.kind` = "bin"|"lib" only, `sources_glob` deleted
  - `packages/std-avrac/src/build/driver.av`: 316-line refactor — `TestBuildInputs` merged into `BuildInputs(kind="test")`, `decide_build`/`record_build_result` unified
  - `packages/cli/src/main.av`: imports cleaned up, `compute_test_build_inputs` returns `BuildInputs`, `record_test_build_result` calls replaced
- **Unstaged (vez6.8 work — separate, layered on top):**
  - AST: `ComponentDef` gained `implements: TypeNameList` field (vez6.8 Phase A, all match sites updated)
  - Parser: `component foo implements TraitA, TraitB { ... }` (vez6.8 Phase B)
  - Tests: `tests/implements_clause_test.av` (9 spec tests)
- **seed.ll:** regenerated with both sets of changes; selfhost fixed point holds; 2201/2208 tests pass (7 fails = pre-existing oywr flake).

## Next concrete step

Task #4: collapse `run_test_command` (`packages/cli/src/main.av:1811–2115`, 304 lines) into a ~30-line shim that:
- Builds `BuildInputs(kind="test")` via `compute_test_build_inputs`
- Calls a new in-process driver function (e.g. `compile_unit(inputs) -> Result<string, string>` returning bin_path)
- That driver function does the parse → resolve → typeck → mono → codegen → link, including the test-only steps (hoist @std, prepend reporter, append synthesized main).
- run_test_command then `avra_process_forward(bin_path, "[]", "")` and exits.

Same shape for `run_build_command` (which is currently 522 lines and mostly shell-outs to `bs2 compile`). Both commands become thin shims over the same driver function.
