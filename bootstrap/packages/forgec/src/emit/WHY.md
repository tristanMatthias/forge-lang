# emit/

Shared codegen building blocks and the statement-level emit
dispatcher. Things in here:
- `program.fg` — compile_program top-level
- `expr.fg` — emit_expression dispatcher
- `stmt.fg` — emit_statement dispatcher

Per-feature codegen lives in `features/<name>/codegen.fg`. The
heavy LLVM boilerplate is wrapped by `core/cg.fg` so each
features/X/codegen.fg can stay short.
