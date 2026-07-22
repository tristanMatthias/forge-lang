<!--
forge-lang (Avra) PR template. Fill each section, delete the guidance comments.
Keep it tight — a template nobody fills in is worse than none.
-->

## In plain English
<!-- 1–2 sentences a non-compiler-engineer could follow: what this changes and why
     it matters. No jargon, no file names, no ticket codes. Think "release note". -->


## What changed
<!-- The technical summary: what was added / removed / refactored and the key idea.
     Link the ticket (t-47hc.* / forge-crafting-intepreters-*). If it deletes hand
     code, say how many lines. -->


## Validation
<!-- This repo's bar is a byte-identical, diff-test-gated change. Tick what you ran;
     paste the key numbers. Delete rows that don't apply. -->
- [ ] `make build-quick` green
- [ ] `bash scripts/diagnose.sh --emit-gen-check` GENPASS
- [ ] `make diff-test PREBUILT=1` byte-identical — selfhost ______ lines + corpus, ______ skipped
- [ ] Feature / regression test(s): `______` — N/N
- [ ] Negative / diagnostic tests isolate-run (diff-test does NOT cover error text of invalid programs)

## Perf
<!-- If a hot path changed: callgrind delta (`--lexer-bench` or a micro-bench),
     before → after instructions. Write "N/A" if not perf-relevant. -->


## Seed / bootstrap impact
<!-- Pick one:
     - Byte-identical source change → the seed train cycles automatically on merge (no action).
     - New keyword / new surface syntax the current seed can't parse → needs `make update-seed` BEFORE dogfooding in src/.
     - New enum variant on ValueType|Expr|Stmt (or a new field) → `make seed-patch-traps` first.
     State which applies. -->


## Risk & rollout
<!-- Byte-identical (no behavior/IR change) or a real behavior/IR change? An intended
     IR change must be labelled `intended-ir-change` (CI switches diff-test to
     `--run-equiv`). Call out anything a reviewer should scrutinize. -->
