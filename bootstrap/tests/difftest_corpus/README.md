# diff-test corpus

Small, **standalone-compilable** Avra programs that feed the HRN differential
test (`diagnose.sh --diff-test`, `make diff-test`). The harness compiles every
file here with BOTH the OLD (oracle / integration-branch) and NEW (HEAD)
compilers and asserts **byte-identical IR**.

## Why this exists

The decisive diff-test oracle is the *selfhost* differential — compiling the
whole compiler source (`main.av`) with both compilers, which exercises ~all
codegen and is the comprehensive check. This corpus is its **surgical
complement**: small, single-file, feature-diverse programs that give real
per-feature IR comparisons, so a divergence in (say) channel or match codegen
surfaces against a ~20-line file instead of bisecting the ~590k-line selfhost
IR. (The selfhost pass *does* cover concurrency — the compiler's parallel
build driver uses channels/spawn/select — so these files duplicate that
coverage on purpose, for fast triage; they don't fill a selfhost gap.)

The default corpus used to be the test-harness suite (`tests/*.av`). Those
files need `@std` + the `spec`/`given`/`then` runtime, so the OLD oracle could
not compile them standalone: 340 of 341 were skipped every run — but only
after a doomed compile each, ~5 min of wasted work for **zero** real
comparisons (51zr). This curated set is skip-free and fast.

## The contract — every file here MUST

- compile with a bare `./build/bs2 compile <file>` (no `@std`, no sibling
  imports, no `spec`/`given`/`then`);
- declare a top-level `fn main()` and **no** test entries, so the in-process
  test runner skips it (`discover_tests` excludes `has_top_main` files);
- exercise a distinct codegen path, isolated enough that a divergence in it
  is obvious from this file's diff alone.

A file the OLD oracle can't compile standalone is **skipped with a `[warn]`**
(it buys zero coverage); fix it or remove it rather than leave it skipped.

## Adding a file

1. Write `<feature>.av` here with a `// WHY:` header naming the path it covers.
2. Verify it compiles standalone: `./build/bs2 compile tests/difftest_corpus/<feature>.av`
   (the emitted `<file>.av.ll` is gitignored).
3. `make diff-test` (add `PREBUILT=1` to skip the cold NEW rebuild while iterating).
