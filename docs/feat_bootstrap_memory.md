# Avra — Bootstrap Memory Strategy

## The Problem

The Rust bootstrap compiler's codegen doesn't track value lifetimes. Struct temporaries on the stack get clobbered across function calls. This causes silent corruption, early returns, and type aliasing bugs.

## The Fix

Three phases. Each compiles the next. The Rust bootstrap becomes irrelevant after Phase 1.

```
Phase 0: Rust bootstrap (current, buggy)
  → compiles Phase 1

Phase 1: Copy-everything Avra compiler (slow, correct)
  → compiles Phase 2

Phase 2: Reference-counted Avra compiler (fast, correct)
  → compiles itself forever
```

## Phase 1: Copy Everything

Every value passed to a function, returned from a function, or extracted from a struct is deep-copied. No sharing. No aliasing. No lifetime bugs. Correct by construction.

```avra
// What the codegen emits for: process(self.items[0])
let tmp = deep_copy(self.items[0])
process(tmp)
free(tmp)
```

**Trades:** Slow. Lots of allocation. Doesn't matter — it only needs to compile one program (Phase 2) once.

**What to implement in the Rust bootstrap:**
- `deep_copy` runtime function for each type (string, list, struct)
- Every function argument is copied before the call
- Every field access returns a copy
- Every function return is copied to the caller's frame
- `free` at end of scope for all copies

## Phase 2: Reference Counting

The self-hosted compiler (written in Avra, compiled by Phase 1) implements RC in its own codegen:

- Every heap value (string, list, struct) has a refcount header
- Assignment: retain new, release old
- Function argument: retain before call, release after
- Scope exit: release all locals
- Refcount hits zero: free

```avra
fn emit_assignment(self, target: LValue, value: Expr) -> LLVMValue {
  let val = self.emit_expr(value)?
  self.emit_retain(val)
  let old = self.emit_load(target)
  self.emit_release(old)
  self.emit_store(target, val)
  val
}
```

**Future optimizations (not needed for bootstrap):**
- Elide retain/release when compiler proves single ownership
- Arena allocation for short-lived scopes
- Cycle detection for bidirectional references
- `systems` blocks with ownership tracking (no RC overhead)

## Verification

```bash
# Phase 0 → Phase 1
cargo build --release                           # build Rust bootstrap
./avrac build src/main.av -o avrac-copy       # bootstrap compiles copy-everything compiler
./avrac-copy test                              # all tests pass

# Phase 1 → Phase 2
./avrac-copy build src/main.av -o avrac-rc    # slow compiler compiles RC compiler
./avrac-rc test                                # all tests pass

# Phase 2 → Phase 2 (self-sustaining)
./avrac-rc build src/main.av -o avrac-rc-v2   # RC compiler compiles itself
diff <(./avrac-rc test) <(./avrac-rc-v2 test) # identical output

# Rust bootstrap is now irrelevant
```

## Done When

1. Phase 1 compiler passes all tests
2. Phase 1 compiler compiles Phase 2
3. Phase 2 compiler passes all tests
4. Phase 2 compiler compiles itself
5. Output of step 3 and step 4 are identical
