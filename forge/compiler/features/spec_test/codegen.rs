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
        let start_fn = self.module.get_function("forge_test_start_spec")
            .expect("forge_test_start_spec not declared - did you `use @std.test`?");
        let end_fn = self.module.get_function("forge_test_end_spec")
            .expect("forge_test_end_spec not declared");

        // Call forge_test_start_spec(name)
        let name_val = self.build_test_string(name);
        let name_ptr = self.extract_string_ptr(name_val);
        self.builder.build_call(start_fn, &[name_ptr.into()], "").unwrap();

        // Compile body
        for stmt in &body.statements {
            self.compile_statement(stmt);
        }

        // Call forge_test_end_spec()
        self.builder.build_call(end_fn, &[], "").unwrap();
    }

    /// Compile a given block: calls forge_test_start_given, compiles body, calls forge_test_end_given
    pub(crate) fn compile_given_block(
        &mut self,
        name: &str,
        body: &Block,
    ) {
        let start_fn = self.module.get_function("forge_test_start_given")
            .expect("forge_test_start_given not declared - did you `use @std.test`?");
        let end_fn = self.module.get_function("forge_test_end_given")
            .expect("forge_test_end_given not declared");

        // Call forge_test_start_given(name)
        let name_val = self.build_test_string(name);
        let name_ptr = self.extract_string_ptr(name_val);
        self.builder.build_call(start_fn, &[name_ptr.into()], "").unwrap();

        // Compile body in new scope
        self.push_scope();
        for stmt in &body.statements {
            self.compile_statement(stmt);
        }
        self.pop_scope();

        // Call forge_test_end_given()
        self.builder.build_call(end_fn, &[], "").unwrap();
    }

    /// Compile a then block: compiles body, uses last expression as bool result,
    /// calls forge_test_run_then(name, result, file, line)
    pub(crate) fn compile_then_block(
        &mut self,
        name: &str,
        body: &Block,
        span: &crate::lexer::Span,
    ) {
        let then_fn = self.module.get_function("forge_test_run_then")
            .expect("forge_test_run_then not declared - did you `use @std.test`?");

        let result = self.compile_then_body(body);

        // Build args: name (ptr), result (i8), file (ptr), line (i64)
        let name_val = self.build_test_string(name);
        let name_ptr = self.extract_string_ptr(name_val);

        let file_val = self.build_test_string(&self.source_file.clone());
        let file_ptr = self.extract_string_ptr(file_val);

        let line_val = self.context.i64_type().const_int(span.line as u64, false);

        self.builder.build_call(
            then_fn,
            &[name_ptr.into(), result.into(), file_ptr.into(), line_val.into()],
            "",
        ).unwrap();
    }

    /// Compile a then should_fail block: body is expected to produce a falsy result.
    /// Inverts the assertion — passes if body evaluates to false.
    pub(crate) fn compile_then_should_fail(
        &mut self,
        name: &str,
        body: &Block,
        span: &crate::lexer::Span,
    ) {
        let should_fail_fn = self.module.get_function("forge_test_run_then_should_fail")
            .expect("forge_test_run_then_should_fail not declared - did you `use @std.test`?");

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

        let name_val = self.build_test_string(name);
        let name_ptr = self.extract_string_ptr(name_val);
        let empty = self.build_test_string("");
        let empty_ptr = self.extract_string_ptr(empty);
        let file_val = self.build_test_string(&self.source_file.clone());
        let file_ptr = self.extract_string_ptr(file_val);
        let line_val = self.context.i64_type().const_int(span.line as u64, false);

        self.builder.build_call(
            should_fail_fn,
            &[name_ptr.into(), did_error_i8.into(), empty_ptr.into(), empty_ptr.into(), file_ptr.into(), line_val.into()],
            "",
        ).unwrap();
    }

    /// Compile a then should_fail_with block: body is expected to produce a falsy result.
    pub(crate) fn compile_then_should_fail_with(
        &mut self,
        name: &str,
        expected: &str,
        body: &Block,
        span: &crate::lexer::Span,
    ) {
        let should_fail_fn = self.module.get_function("forge_test_run_then_should_fail")
            .expect("forge_test_run_then_should_fail not declared - did you `use @std.test`?");

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

        let name_val = self.build_test_string(name);
        let name_ptr = self.extract_string_ptr(name_val);
        let empty = self.build_test_string("");
        let empty_ptr = self.extract_string_ptr(empty);
        let expected_val = self.build_test_string(expected);
        let expected_ptr = self.extract_string_ptr(expected_val);
        let file_val = self.build_test_string(&self.source_file.clone());
        let file_ptr = self.extract_string_ptr(file_val);
        let line_val = self.context.i64_type().const_int(span.line as u64, false);

        self.builder.build_call(
            should_fail_fn,
            &[name_ptr.into(), did_error_i8.into(), empty_ptr.into(), expected_ptr.into(), file_ptr.into(), line_val.into()],
            "",
        ).unwrap();
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
        let then_fn = self.module.get_function("forge_test_run_then")
            .expect("forge_test_run_then not declared - did you `use @std.test`?");

        // Table literal is Expr::TableLit { columns, rows }
        if let Expr::TableLit { columns, rows, .. } = table {
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

                // Call forge_test_run_then
                let name_val = self.build_test_string(&test_name);
                let name_ptr = self.extract_string_ptr(name_val);
                let file_val = self.build_test_string(&self.source_file.clone());
                let file_ptr = self.extract_string_ptr(file_val);
                let line_val = self.context.i64_type().const_int(span.line as u64, false);

                self.builder.build_call(
                    then_fn,
                    &[name_ptr.into(), result.into(), file_ptr.into(), line_val.into()],
                    "",
                ).unwrap();

                self.pop_scope();
            }
        }
    }

    /// Compile a skip statement: calls forge_test_skip(name)
    pub(crate) fn compile_skip_block(&mut self, name: &str) {
        let skip_fn = self.module.get_function("forge_test_skip")
            .expect("forge_test_skip not declared - did you `use @std.test`?");

        let name_val = self.build_test_string(name);
        let name_ptr = self.extract_string_ptr(name_val);
        self.builder.build_call(skip_fn, &[name_ptr.into()], "").unwrap();
    }

    /// Compile a todo statement: calls forge_test_todo(name)
    pub(crate) fn compile_todo_stmt(&mut self, name: &str) {
        let todo_fn = self.module.get_function("forge_test_todo")
            .expect("forge_test_todo not declared - did you `use @std.test`?");

        let name_val = self.build_test_string(name);
        let name_ptr = self.extract_string_ptr(name_val);
        self.builder.build_call(todo_fn, &[name_ptr.into()], "").unwrap();
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

    /// Helper: build a ForgeString from a string literal
    fn build_test_string(&mut self, s: &str) -> BasicValueEnum<'ctx> {
        let expr = Expr::StringLit(s.to_string(), crate::lexer::Span::dummy());
        self.compile_expr(&expr).unwrap()
    }

    /// Helper: extract the raw pointer from a ForgeString struct
    fn extract_string_ptr(&mut self, val: BasicValueEnum<'ctx>) -> BasicValueEnum<'ctx> {
        if val.is_struct_value() {
            self.builder
                .build_extract_value(val.into_struct_value(), 0, "str_ptr")
                .unwrap()
                .into()
        } else {
            val
        }
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
