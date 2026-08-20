# Null Safety

Null coalescing (`??`) and optional chaining (`?.`) eliminate
verbose `if x == null { default } else { x! }` patterns.

A nullable is a tagged value, not a bare zero. The old note here said
"in the bootstrap's everything-is-i64 model, null == 0", and that model
was ELIMINATED — see `maybe_wrap_nullable` vs `wrap_in_nullable`, which
exist precisely because the tag is real. Both operators compile to
null-check branches with
short-circuit evaluation.
