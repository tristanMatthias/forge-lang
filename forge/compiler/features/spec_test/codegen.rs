use inkwell::values::BasicValueEnum;

use crate::codegen::codegen::Codegen;
use crate::parser::ast::*;

impl<'ctx> Codegen<'ctx> {
    /// Compile a spec block: calls forge_test_start_spec, compiles body, calls forge_test_end_spec
    pub(crate) fn compile_spec_block(
        &mut self,
        name: &str,
        body: &Block,
    ) {
        self.compile_test_section("spec", name, body, false);
    }

    /// Compile a given block: calls forge_test_start_given, compiles body, calls forge_test_end_given
    pub(crate) fn compile_given_block(
        &mut self,
        name: &str,
        body: &Block,
    ) {
        self.compile_test_section("given", name, body, true);
    }

    /// Shared helper for spec/given blocks: start_{kind}(name), compile body, end_{kind}().
    fn compile_test_section(&mut self, kind: &str, name: &str, body: &Block, scoped: bool) {
        let start_fn = format!("forge_test_start_{}", kind);
        let end_fn = format!("forge_test_end_{}", kind);
        let name_ptr = self.build_test_cstr(name);
        self.call_runtime_expect(
            &start_fn, &[name_ptr.into()], "",
            &format!("{} not declared - did you `use @std.test`?", start_fn),
        );
        if scoped { self.push_scope(); }
        for stmt in &body.statements {
            self.compile_statement(stmt);
        }
        if scoped { self.pop_scope(); }
        self.call_runtime_void(&end_fn, &[]);
    }

    /// Compile a then block: compiles body, uses last expression as bool result,
    /// calls forge_test_run_then(name, result, file, line)
    pub(crate) fn compile_then_block(
        &mut self,
        name: &str,
        body: &Block,
        span: &crate::lexer::Span,
    ) {
        let result = self.compile_then_body(body);
        self.emit_test_run_then(name, result, span);
    }

    /// Compile a then should_fail block: body is expected to produce a falsy result.
    /// Inverts the assertion — passes if body evaluates to false.
    pub(crate) fn compile_then_should_fail(
        &mut self,
        name: &str,
        body: &Block,
        span: &crate::lexer::Span,
    ) {
        self.compile_then_should_fail_impl(name, "", body, span);
    }

    /// Compile a then should_fail_with block: body is expected to produce a falsy result.
    pub(crate) fn compile_then_should_fail_with(
        &mut self,
        name: &str,
        expected: &str,
        body: &Block,
        span: &crate::lexer::Span,
    ) {
        self.compile_then_should_fail_impl(name, expected, body, span);
    }

    /// Shared implementation for should_fail and should_fail_with.
    fn compile_then_should_fail_impl(
        &mut self,
        name: &str,
        expected: &str,
        body: &Block,
        span: &crate::lexer::Span,
    ) {
        let result = self.compile_then_body(body);

        // Invert: if result is 0 (false/error), did_error = 1 (pass)
        let did_error = self.builder.build_int_compare(
            inkwell::IntPredicate::EQ,
            result,
            self.context.i8_type().const_zero(),
            "did_error",
        ).unwrap();
        let did_error_i8 = self.builder.build_int_z_extend(
            did_error, self.context.i8_type(), "did_error_i8"
        ).unwrap();

        let name_ptr = self.build_test_cstr(name);
        let empty_ptr = self.build_test_cstr("");
        let expected_ptr = self.build_test_cstr(expected);
        let file_ptr = self.build_test_cstr(&self.source_file.clone());
        let line_val = self.context.i64_type().const_int(span.line as u64, false);

        self.call_runtime_expect(
            "forge_test_run_then_should_fail",
            &[name_ptr.into(), did_error_i8.into(), empty_ptr.into(), expected_ptr.into(), file_ptr.into(), line_val.into()],
            "",
            "forge_test_run_then_should_fail not declared - did you `use @std.test`?",
        );
    }

    /// Compile a then where block: iterates over table rows, running assertion per row.
    /// Each row's column values are bound as local variables for the body.
    pub(crate) fn compile_then_where(
        &mut self,
        name: &str,
        table: &Expr,
        body: &Block,
        span: &crate::lexer::Span,
    ) {
        // Table literal is Feature("table_literal")
        let (columns, rows) = if let Expr::Feature(fe) = table {
            if fe.feature_id == "table_literal" {
                if let Some(data) = crate::feature_data!(fe, crate::features::table_literal::types::TableLitData) {
                    (data.columns.as_slice(), data.rows.as_slice())
                } else {
                    return;
                }
            } else {
                return;
            }
        } else {
            return;
        };
        for (row_idx, row) in rows.iter().enumerate() {
                self.push_scope();

                // Build descriptive test name: "name (col1=val1, col2=val2)"
                let row_desc = columns.iter().zip(row.iter())
                    .map(|(col, val)| format!("{}: {}", col, expr_preview(val)))
                    .collect::<Vec<_>>()
                    .join(", ");
                let test_name = format!("{} ({}) [{}]", name, row_desc, row_idx + 1);

                // Bind each column value as a local variable
                for (col_idx, col_name) in columns.iter().enumerate() {
                    if col_idx < row.len() {
                        let val = self.compile_expr(&row[col_idx]);
                        if let Some(val) = val {
                            let ty = self.infer_type(&row[col_idx]);
                            let alloca = self.create_entry_block_alloca(&ty, col_name);
                            self.builder.build_store(alloca, val).unwrap();
                            self.define_var(col_name.clone(), alloca, ty);
                        }
                    }
                }

                // Compile assertion body
                let result = self.compile_then_body(body);
                self.emit_test_run_then(&test_name, result, span);

                self.pop_scope();
            }
    }

    /// Compile a skip statement: calls forge_test_skip(name)
    pub(crate) fn compile_skip_block(&mut self, name: &str) {
        self.emit_test_call("forge_test_skip", name);
    }

    /// Compile a todo statement: calls forge_test_todo(name)
    pub(crate) fn compile_todo_stmt(&mut self, name: &str) {
        self.emit_test_call("forge_test_todo", name);
    }

    /// Helper: call a test runtime fn that takes a single name (ptr) arg.
    fn emit_test_call(&mut self, fn_name: &str, name: &str) {
        let name_ptr = self.build_test_cstr(name);
        self.call_runtime_expect(
            fn_name, &[name_ptr.into()], "",
            &format!("{} not declared - did you `use @std.test`?", fn_name),
        );
    }

    /// Compile a then body, returning the last expression as an i8 bool value.
    fn compile_then_body(&mut self, body: &Block) -> inkwell::values::IntValue<'ctx> {
        self.push_scope();
        let mut last_val: Option<BasicValueEnum<'ctx>> = None;
        for stmt in &body.statements {
            match stmt {
                Statement::Expr(expr) => {
                    last_val = self.compile_expr(expr);
                }
                _ => {
                    self.compile_statement(stmt);
                    last_val = None;
                }
            }
        }
        self.pop_scope();

        // The last expression should be a bool (i8). Default to false if no value.
        if let Some(val) = last_val {
            if val.is_int_value() {
                val.into_int_value()
            } else {
                self.context.i8_type().const_zero()
            }
        } else {
            self.context.i8_type().const_zero()
        }
    }

    /// Helper: build a string literal and extract its raw C pointer for runtime calls.
    fn build_test_cstr(&mut self, s: &str) -> BasicValueEnum<'ctx> {
        let expr = Expr::StringLit(s.to_string(), crate::lexer::Span::dummy());
        let val = self.compile_expr(&expr).unwrap();
        if val.is_struct_value() {
            self.builder
                .build_extract_value(val.into_struct_value(), 0, "str_ptr")
                .unwrap()
                .into()
        } else {
            val
        }
    }

    /// Helper: emit forge_test_run_then(name, result, file, line).
    fn emit_test_run_then(&mut self, name: &str, result: inkwell::values::IntValue<'ctx>, span: &crate::lexer::Span) {
        let name_ptr = self.build_test_cstr(name);
        let file_ptr = self.build_test_cstr(&self.source_file.clone());
        let line_val = self.context.i64_type().const_int(span.line as u64, false);

        self.call_runtime_expect(
            "forge_test_run_then",
            &[name_ptr.into(), result.into(), file_ptr.into(), line_val.into()],
            "",
            "forge_test_run_then not declared - did you `use @std.test`?",
        );
    }
}

/// Get a short preview of an expression for test naming
fn expr_preview(expr: &Expr) -> String {
    match expr {
        Expr::IntLit(n, _) => n.to_string(),
        Expr::FloatLit(f, _) => f.to_string(),
        Expr::StringLit(s, _) => format!("\"{}\"", s),
        Expr::BoolLit(b, _) => b.to_string(),
        Expr::NullLit(_) => "null".to_string(),
        Expr::Ident(name, _) => name.clone(),
        _ => "...".to_string(),
    }
}
