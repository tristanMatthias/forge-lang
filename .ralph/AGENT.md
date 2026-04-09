# Build & Test Commands

## Build the bootstrap compiler
```bash
make -C bootstrap build
```

## Run all tests (regression suite + self-host fixed-point check)
```bash
make -C bootstrap test
```

## Run just the regression suite (faster)
```bash
make -C bootstrap regress
```

## Verify self-host fixed point only
```bash
make -C bootstrap selfhost
```

## Score the IR quality
```bash
make -C bootstrap score
```

## Rebuild the host compiler (after std-llvm changes)
```bash
cd forge && LLVM_SYS_191_PREFIX=/opt/homebrew/opt/llvm@19 cargo build --release
```

## Run a single Forge file through bs2
```bash
make -C bootstrap run FILE=path/to/program.fg
```

## Add a regression test
```bash
cd bootstrap && bash scripts/diagnose.sh --regress-add <name> <file.fg>
```
