# Ralph Goal: Bootstrap Compiler — Polish + Phase A Features

The bootstrap compiler under `bootstrap/` is self-hosted and
feature-organized. Work through the tasks in `.ralph/fix_plan.md`
in order. Each task is a self-contained commit.

## Rules

- Read `CLAUDE.md` — it has non-negotiable rules (NO WORKAROUNDS, fix bugs at source, never context-budget)
- Read `bootstrap/CODE_QUALITY.md` before making ANY change
- Read `bootstrap/FEATURE_PARITY.md` for the full feature inventory
- NEVER use `git checkout --` on modified tracked files
- NEVER add mutable globals — all state flows through `Ctx`
- Every commit must pass `make -C bootstrap test`
- TINY COMMITS. One logical change per commit. Never batch unrelated
  changes. Each commit must compile, pass tests, and be independently
  revertable. If a task is big, split it into multiple commits.
- If stuck after 3 attempts on a task, mark it blocked and move on
- After adding a new language feature, REFACTOR the bootstrap source
  to USE that feature (see "Dogfooding Rule" in FEATURE_PARITY.md)

## Build & Test

```bash
make -C bootstrap test      # regression suite + self-host fixed-point
make -C bootstrap score     # IR quality score
make -C bootstrap run FILE=path.fg  # compile + run a .fg file
```

After std-llvm changes:
```bash
cd forge && LLVM_SYS_191_PREFIX=/opt/homebrew/opt/llvm@19 cargo build --release
```

## Task List

See `.ralph/fix_plan.md` for the ordered checklist. Mark each task
`[x]` when its commit lands and tests pass.

When ALL tasks are done, output:
```
RALPH_STATUS:
  EXIT_SIGNAL: true
```
