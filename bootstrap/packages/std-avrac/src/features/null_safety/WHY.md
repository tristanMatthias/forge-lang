# Null Safety

Null coalescing (`??`) and optional chaining (`?.`) eliminate
verbose `if x == null { default } else { x! }` patterns.

In the bootstrap's everything-is-i64 model, null == 0. Both
operators compile to simple i64 null-check branches with
short-circuit evaluation.
