# parse/

Shared parser building blocks and the statement-level dispatcher.
Things in here:
- `expr.av` — the expression parser (precedence climber, postfix loop)
- `pattern.av` — pattern parsing
- `type_expr.av` — type annotations and field lists
- `stmt.av` — the dispatcher that routes by token kind to features

Per-feature parsing lives in `features/<name>/parser.av`.
Operators, literals, and call/index/field-access stay here because
they participate in expression precedence and don't fit the
keyword-feature model.
