# for statement

Counted `for i in start..end { body }` loop. Desugars to a counter
alloca, a condition check (`i < end`), and an increment block — the
same basic-block layout as `while`, but with the iteration variable
and bounds handled automatically.
