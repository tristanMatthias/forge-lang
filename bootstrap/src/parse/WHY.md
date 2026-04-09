# parse/

Shared parser building blocks and the statement-level dispatcher.
Things in here:
- `expr.fg` — the expression parser (precedence climber, postfix loop)
- `pattern.fg` — pattern parsing
- `type_expr.fg` — type annotations and field lists
- `stmt.fg` — the dispatcher that routes by token kind to features

Per-feature parsing lives in `features/<name>/parser.fg`.
Operators, literals, and call/index/field-access stay here because
they participate in expression precedence and don't fit the
keyword-feature model.
