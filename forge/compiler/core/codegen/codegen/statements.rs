use super::*;

impl<'ctx> Codegen<'ctx> {
    pub(crate) fn declare_function(
        &mut self,
        name: &str,
        params: &[Param],
        return_type: Option<&TypeExpr>,
    ) {
        let ret_ty = return_type
            .map(|t| self.type_checker.resolve_type_expr(t))
            .unwrap_or(Type::Void);

        let param_types: Vec<Type> = params
            .iter()
            .map(|p| {
                p.type_ann
                    .as_ref()
                    .map(|t| self.type_checker.resolve_type_expr(t))
                    .unwrap_or(Type::Unknown)
            })
            .collect();

        let llvm_param_types: Vec<BasicMetadataTypeEnum<'ctx>> = param_types
            .iter()
            .map(|t| self.type_to_llvm_metadata(t))
            .collect();

        let fn_type = if name == "main" {
            // main must return i32 for C ABI
            self.context.i32_type().fn_type(&llvm_param_types, false)
        } else if ret_ty == Type::Void {
            self.context.void_type().fn_type(&llvm_param_types, false)
        } else {
            let ret_llvm = self.type_to_llvm(&ret_ty);
            ret_llvm.fn_type(&llvm_param_types, false)
        };

        let function = self.module.add_function(name, fn_type, None);
        self.functions.insert(name.to_string(), function);
        self.fn_return_types.insert(name.to_string(), ret_ty);
    }

    pub(crate) fn compile_statement(&mut self, stmt: &Statement) {
        match stmt {
            Statement::FnDecl {
                name,
                type_params,
                params,
                return_type,
                body,
                ..
            } => {
                // Skip generic functions - they are monomorphized on demand
                if !type_params.is_empty() {
                    return;
                }
                self.compile_fn(name, params, return_type.as_ref(), body);
            }
            Statement::Let { name, value, type_ann, .. } => {
                // Set type hints from type annotation
                if let Some(ta) = type_ann {
                    let resolved = self.type_checker.resolve_type_expr(ta);
                    self.json_parse_hint = Some(resolved.clone());
                    if matches!(&resolved, Type::Struct { .. }) {
                        self.struct_target_type = Some(resolved);
                    }
                }
                let val = self.compile_expr(value);
                self.json_parse_hint = None;
                self.struct_target_type = None;
                if let Some(val) = val {
                    let ty = type_ann
                        .as_ref()
                        .map(|t| self.type_checker.resolve_type_expr(t))
                        .unwrap_or_else(|| self.infer_type(value));
                    // If the inferred type doesn't match the actual value (e.g. extern fn
                    // returning ForgeString struct but type inferred as Unknown/Int), derive
                    // the type from the actual LLVM value type.
                    let ty = if ty == Type::Unknown || ty == Type::Int {
                        if val.is_struct_value() {
                            let string_type = self.string_type();
                            if val.into_struct_value().get_type() == string_type {
                                Type::String
                            } else {
                                ty
                            }
                        } else if val.is_float_value() {
                            Type::Float
                        } else {
                            ty
                        }
                    } else {
                        ty
                    };
                    let alloca = self.create_entry_block_alloca(&ty, name);
                    self.builder.build_store(alloca, val).unwrap();
                    self.define_var(name.clone(), alloca, ty);
                }
            }
            Statement::LetDestructure { pattern, value, .. } => {
                self.compile_let_destructure(pattern, value);
            }
            Statement::Mut { name, value, type_ann, .. } => {
                // Skip global mutables - they are created in compile_program first pass
                if self.global_mutables.contains_key(name) {
                    return;
                }
                let val = self.compile_expr(value);
                if let Some(val) = val {
                    let ty = type_ann
                        .as_ref()
                        .map(|t| self.type_checker.resolve_type_expr(t))
                        .unwrap_or_else(|| self.infer_type(value));
                    let alloca = self.create_entry_block_alloca(&ty, name);
                    self.builder.build_store(alloca, val).unwrap();
                    self.define_var(name.clone(), alloca, ty);
                }
            }
            Statement::Const { name, value, type_ann, .. } => {
                let val = self.compile_expr(value);
                if let Some(val) = val {
                    let ty = type_ann
                        .as_ref()
                        .map(|t| self.type_checker.resolve_type_expr(t))
                        .unwrap_or_else(|| self.infer_type(value));
                    let alloca = self.create_entry_block_alloca(&ty, name);
                    self.builder.build_store(alloca, val).unwrap();
                    self.define_var(name.clone(), alloca, ty);
                }
            }
            Statement::Assign { target, value, .. } => {
                if let Expr::Ident(name, _) = target {
                    let val = self.compile_expr(value);
                    if let Some(val) = val {
                        if let Some((ptr, _)) = self.lookup_var(name) {
                            self.builder.build_store(ptr, val).unwrap();
                        }
                    }
                } else if let Expr::MemberAccess { object, field, .. } = target {
                    // Handle struct field assignment
                    if let Expr::Ident(name, _) = object.as_ref() {
                        let val = self.compile_expr(value);
                        if let Some(val) = val {
                            if let Some((ptr, ty)) = self.lookup_var(name) {
                                if let Type::Struct { fields, .. } = &ty {
                                    if let Some(idx) = fields.iter().position(|(n, _)| n == field) {
                                        let field_ptr = self.builder.build_struct_gep(
                                            self.type_to_llvm_basic(&ty),
                                            ptr,
                                            idx as u32,
                                            "field_ptr",
                                        ).unwrap();
                                        self.builder.build_store(field_ptr, val).unwrap();
                                    }
                                }
                            }
                        }
                    }
                } else if let Expr::Index { object, index, .. } = target {
                    // Ignore for now - complex indexing assignment
                    let _ = (object, index, value);
                }
            }
            Statement::Expr(expr) => {
                self.compile_expr(expr);
            }
            Statement::Return { value, .. } => {
                if let Some(val) = value {
                    let compiled = self.compile_expr(val);
                    if let Some(v) = compiled {
                        self.builder.build_return(Some(&v)).unwrap();
                    } else {
                        self.builder.build_return(None).unwrap();
                    }
                } else {
                    self.builder.build_return(None).unwrap();
                }
            }
            Statement::For {
                pattern,
                iterable,
                body,
                ..
            } => {
                self.compile_for(pattern, iterable, body);
            }
            Statement::While {
                condition, body, ..
            } => {
                self.compile_while(condition, body);
            }
            Statement::Loop { body, .. } => {
                self.compile_loop(body);
            }
            Statement::Break { value, .. } => {
                self.compile_break(value.as_ref());
            }
            Statement::Continue { .. } => {
                // Would need loop_continue_block tracking; simplified
            }
            Statement::EnumDecl { .. } | Statement::TypeDecl { .. } => {
                // Type declarations handled at type-check time
            }
            Statement::Defer { body, .. } => {
                // Save deferred expression for execution before function return
                self.deferred_stmts.push(body.clone());
            }
            Statement::Use { .. }
            | Statement::TraitDecl { .. }
            | Statement::ImplBlock { .. } => {
                // Traits and impls are compiled during the registration phase
            }
            Statement::ExternFn { name, params, return_type, .. } => {
                self.compile_extern_fn(name, params, return_type.as_ref());
            }
            Statement::ComponentBlock(_)
            | Statement::ComponentTemplateDef(_) => {
                // Component blocks already expanded before codegen
            }
            Statement::Select { arms, .. } => {
                self.compile_select(arms);
            }
            Statement::SpecBlock { name, body, .. } => {
                self.compile_spec_block(name, body);
            }
            Statement::GivenBlock { name, body, .. } => {
                self.compile_given_block(name, body);
            }
            Statement::ThenBlock { name, body, span } => {
                self.compile_then_block(name, body, span);
            }
            Statement::ThenShouldFail { name, body, span } => {
                self.compile_then_should_fail(name, body, span);
            }
            Statement::ThenShouldFailWith { name, expected, body, span } => {
                self.compile_then_should_fail_with(name, expected, body, span);
            }
            Statement::ThenWhere { name, table, body, span } => {
                self.compile_then_where(name, table, body, span);
            }
            Statement::SkipBlock { name, .. } => {
                self.compile_skip_block(name);
            }
            Statement::TodoStmt { name, .. } => {
                self.compile_todo_stmt(name);
            }
        }
    }

    pub(crate) fn compile_fn(
        &mut self,
        name: &str,
        params: &[Param],
        return_type: Option<&TypeExpr>,
        body: &Block,
    ) {
        let function = if let Some(f) = self.functions.get(name) {
            *f
        } else {
            self.declare_function(name, params, return_type);
            self.functions[name]
        };

        let entry = self.context.append_basic_block(function, "entry");
        self.builder.position_at_end(entry);

        self.push_scope();

        // Bind parameters
        for (i, param) in params.iter().enumerate() {
            let param_val = function.get_nth_param(i as u32).unwrap();
            let ty = param
                .type_ann
                .as_ref()
                .map(|t| self.type_checker.resolve_type_expr(t))
                .unwrap_or(Type::Unknown);
            let alloca = self.create_entry_block_alloca(&ty, &param.name);
            self.builder.build_store(alloca, param_val).unwrap();
            self.define_var(param.name.clone(), alloca, ty);
        }

        // Compile body
        let ret_ty = return_type
            .map(|t| self.type_checker.resolve_type_expr(t))
            .unwrap_or(Type::Void);

        let prev_return_type = self.current_fn_return_type.take();
        self.current_fn_return_type = Some(ret_ty.clone());
        let prev_deferred = std::mem::take(&mut self.deferred_stmts);

        let mut last_val = None;
        for stmt in &body.statements {
            match stmt {
                Statement::Expr(expr) => {
                    last_val = self.compile_expr(expr);
                }
                Statement::Return { value, .. } => {
                    // Execute deferred statements in reverse order before returning
                    let deferred = self.deferred_stmts.clone();
                    for d in deferred.iter().rev() {
                        self.compile_expr(d);
                    }
                    if let Some(val) = value {
                        let compiled = self.compile_expr(val);
                        if let Some(v) = compiled {
                            self.builder.build_return(Some(&v)).unwrap();
                        }
                    } else {
                        self.builder.build_return(None).unwrap();
                    }
                    self.pop_scope();
                    self.deferred_stmts = prev_deferred;
                    return;
                }
                _ => {
                    self.compile_statement(stmt);
                    last_val = None;
                }
            }
        }

        // Execute deferred statements before implicit return
        let deferred = std::mem::take(&mut self.deferred_stmts);
        for d in deferred.iter().rev() {
            self.compile_expr(d);
        }

        // Implicit return
        let current_block = self.builder.get_insert_block().unwrap();
        if current_block.get_terminator().is_none() {
            if name == "main" {
                // main returns i32 0
                self.builder
                    .build_return(Some(&self.context.i32_type().const_zero()))
                    .unwrap();
            } else if ret_ty == Type::Void {
                self.builder.build_return(None).unwrap();
            } else if let Some(val) = last_val {
                let expected_llvm = self.type_to_llvm_basic(&ret_ty);
                if val.get_type() != expected_llvm {
                    if let Type::Nullable(_) = &ret_ty {
                        let wrapped = self.wrap_in_nullable(val, &ret_ty);
                        self.builder.build_return(Some(&wrapped)).unwrap();
                    } else if ret_ty == Type::String && val.is_pointer_value() {
                        // Auto-wrap ptr -> ForgeString (e.g. extern fn returning string)
                        let ptr_val = val.into_pointer_value();
                        let ptr_type = self.context.ptr_type(inkwell::AddressSpace::default());
                        let strlen_fn = self.module.get_function("strlen").unwrap_or_else(|| {
                            let ft = self.context.i64_type().fn_type(&[ptr_type.into()], false);
                            self.module.add_function("strlen", ft, None)
                        });
                        let len = self.builder.build_call(strlen_fn, &[ptr_val.into()], "slen")
                            .unwrap().try_as_basic_value().left().unwrap();
                        let str_new_fn = self.module.get_function("forge_string_new").unwrap();
                        let forge_str = self.builder.build_call(
                            str_new_fn, &[ptr_val.into(), len.into()], "fstr",
                        ).unwrap().try_as_basic_value().left().unwrap();
                        self.builder.build_return(Some(&forge_str)).unwrap();
                    } else {
                        let coerced = self.coerce_value(val, expected_llvm);
                        self.builder.build_return(Some(&coerced)).unwrap();
                    }
                } else {
                    self.builder.build_return(Some(&val)).unwrap();
                }
            } else {
                // Return default value
                let default = self.default_value(&ret_ty);
                self.builder.build_return(Some(&default)).unwrap();
            }
        }

        self.pop_scope();
        self.current_fn_return_type = prev_return_type;
        self.deferred_stmts = prev_deferred;
    }

    pub(crate) fn compile_let_destructure(&mut self, pattern: &Pattern, value: &Expr) {
        match pattern {
            Pattern::Tuple(elems, _) => {
                let val = self.compile_expr(value);
                let val_type = self.infer_type(value);
                if let (Some(val), Type::Tuple(types)) = (val, &val_type) {
                    if val.is_struct_value() {
                        let struct_val = val.into_struct_value();
                        for (i, elem) in elems.iter().enumerate() {
                            if let Pattern::Ident(name, _) = elem {
                                let elem_ty = types.get(i).cloned().unwrap_or(Type::Int);
                                let extracted = self.builder
                                    .build_extract_value(struct_val, i as u32, name)
                                    .unwrap();
                                let alloca = self.create_entry_block_alloca(&elem_ty, name);
                                self.builder.build_store(alloca, extracted).unwrap();
                                self.define_var(name.clone(), alloca, elem_ty);
                            }
                        }
                    }
                }
            }
            Pattern::Struct { fields, .. } => {
                let val = self.compile_expr(value);
                let val_type = self.infer_type(value);
                if let (Some(val), Type::Struct { fields: type_fields, .. }) = (val, &val_type) {
                    if val.is_struct_value() {
                        let struct_val = val.into_struct_value();
                        for (field_name, pat) in fields {
                            if let Pattern::Ident(name, _) = pat {
                                if let Some(idx) = type_fields.iter().position(|(n, _)| n == field_name) {
                                    let field_ty = type_fields[idx].1.clone();
                                    let extracted = self.builder
                                        .build_extract_value(struct_val, idx as u32, name)
                                        .unwrap();
                                    let alloca = self.create_entry_block_alloca(&field_ty, name);
                                    self.builder.build_store(alloca, extracted).unwrap();
                                    self.define_var(name.clone(), alloca, field_ty);
                                }
                            }
                        }
                    }
                }
            }
            Pattern::List { elements, rest, .. } => {
                let val = self.compile_expr(value);
                let val_type = self.infer_type(value);
                if let Some(val) = val {
                    let elem_type = if let Type::List(inner) = &val_type {
                        *inner.clone()
                    } else {
                        Type::Int
                    };
                    // List is {ptr, len} struct
                    if val.is_struct_value() {
                        let list_struct = val.into_struct_value();
                        let data_ptr = self.builder
                            .build_extract_value(list_struct, 0, "list_data")
                            .unwrap()
                            .into_pointer_value();
                        let list_len = self.builder
                            .build_extract_value(list_struct, 1, "list_len")
                            .unwrap()
                            .into_int_value();

                        let elem_llvm_ty = self.type_to_llvm_basic(&elem_type);

                        // Extract each named element by index
                        for (i, elem_pat) in elements.iter().enumerate() {
                            if let Pattern::Ident(name, _) = elem_pat {
                                let idx = self.context.i64_type().const_int(i as u64, false);
                                let elem_ptr = unsafe {
                                    self.builder.build_gep(
                                        elem_llvm_ty,
                                        data_ptr,
                                        &[idx],
                                        &format!("{}_ptr", name),
                                    ).unwrap()
                                };
                                let loaded = self.builder.build_load(elem_llvm_ty, elem_ptr, name).unwrap();
                                let alloca = self.create_entry_block_alloca(&elem_type, name);
                                self.builder.build_store(alloca, loaded).unwrap();
                                self.define_var(name.clone(), alloca, elem_type.clone());
                            }
                        }

                        // Handle ...rest
                        if let Some(rest_name) = rest {
                            let fixed_count = elements.len() as u64;
                            let fixed_count_val = self.context.i64_type().const_int(fixed_count, false);
                            let rest_len = self.builder
                                .build_int_sub(list_len, fixed_count_val, "rest_len")
                                .unwrap();

                            // Compute pointer to start of rest elements
                            let rest_data_ptr = unsafe {
                                self.builder.build_gep(
                                    elem_llvm_ty,
                                    data_ptr,
                                    &[fixed_count_val],
                                    "rest_data_ptr",
                                ).unwrap()
                            };

                            // Build a new list struct {ptr, len} for rest
                            let list_type = self.type_to_llvm_basic(&Type::List(Box::new(elem_type.clone())));
                            let list_struct_type = list_type.into_struct_type();
                            let mut rest_struct = list_struct_type.get_undef();
                            rest_struct = self.builder
                                .build_insert_value(rest_struct, rest_data_ptr, 0, "rest_ptr")
                                .unwrap()
                                .into_struct_value();
                            rest_struct = self.builder
                                .build_insert_value(rest_struct, rest_len, 1, "rest_len_val")
                                .unwrap()
                                .into_struct_value();

                            let rest_ty = Type::List(Box::new(elem_type));
                            let alloca = self.create_entry_block_alloca(&rest_ty, rest_name);
                            self.builder.build_store(alloca, rest_struct).unwrap();
                            self.define_var(rest_name.clone(), alloca, rest_ty);
                        }
                    }
                }
            }
            _ => {}
        }
    }
    // compile_with: extracted to features/
    // compile_select: extracted to features/
}
