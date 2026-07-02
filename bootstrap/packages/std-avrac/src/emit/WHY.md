# emit/

Shared codegen building blocks and the statement-level emit
dispatcher. Things in here:
- `program.av` — compile_program top-level
- `expr.av` — emit_expression dispatcher
- `stmt.av` — emit_statement dispatcher

Per-feature codegen lives in `features/<name>/codegen.av`. The
heavy LLVM boilerplate is wrapped by `core/cg.av` so each
features/X/codegen.av can stay short.
