use super::*;
use crate::typeck::types::{AnnotationArg, FieldAnnotation};

impl<'ctx> Codegen<'ctx> {
    /// Compile `validate(value, TypeName)` → Result<TypeName, ValidationError>
    ///
    /// Pipeline: @default → @transform → validation checks
    /// Returns Ok(transformed_value) if all pass, Err(ValidationError) if any fail.
    pub(crate) fn compile_validate(
        &mut self,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        if args.len() < 2 {
            return None;
        }

        // Second arg must be a type name (identifier)
        let type_name = match &args[1].value {
            Expr::Ident(name, _) => name.clone(),
            _ => return None,
        };

        // Look up the type
        let target_type = self.type_checker.env.resolve_type_name(&type_name);
        let struct_fields = match &target_type {
            Type::Struct { fields, .. } => fields.clone(),
            _ => return None,
        };

        // Look up annotations for this type
        let annotations = self.type_checker.env.type_annotations
            .get(&type_name)
            .cloned()
            .unwrap_or_default();

        // Check if this is a partial type
        let is_partial = self.type_checker.env.partial_types.contains(&type_name);

        // Compile the value (first arg) — set struct target type for correct layout
        self.struct_target_type = Some(target_type.clone());
        let initial_val = self.compile_expr(&args[0].value)?;
        self.struct_target_type = None;

        // If no annotations, just return Ok(struct_val)
        if annotations.is_empty() {
            return self.build_validate_ok(initial_val, &target_type);
        }

        let current_fn = self.builder.get_insert_block().unwrap().get_parent().unwrap();

        // ── Phase 1: @default — fill null nullable fields with defaults ──
        let mut struct_val = initial_val;
        for (field_name, field_anns) in &annotations {
            let field_idx = match struct_fields.iter().position(|(n, _)| n == field_name) {
                Some(idx) => idx,
                None => continue,
            };
            let field_type = &struct_fields[field_idx].1;

            for ann in field_anns {
                if ann.name != "default" { continue; }
                if !matches!(field_type, Type::Nullable(_)) { continue; }

                struct_val = self.apply_default(
                    struct_val, field_idx, ann, field_type, current_fn,
                );
            }
        }

        // ── Phase 2: @transform — mutate field values before validation ──
        for (field_name, field_anns) in &annotations {
            let field_idx = match struct_fields.iter().position(|(n, _)| n == field_name) {
                Some(idx) => idx,
                None => continue,
            };
            let field_type = &struct_fields[field_idx].1;

            for ann in field_anns {
                if ann.name != "transform" { continue; }

                if let Some(new_val) = self.apply_transform(
                    struct_val, field_idx, ann, field_type, is_partial, current_fn,
                ) {
                    struct_val = new_val;
                }
            }
        }

        // ── Phase 3: Validation checks ──
        // FieldError type: { ForgeString field, ForgeString rule, ForgeString message }
        let string_type = self.string_type();
        let field_error_type = self.context.struct_type(
            &[string_type.into(), string_type.into(), string_type.into()],
            false,
        );
        let field_error_size = field_error_type.size_of().unwrap();

        // Count max possible errors (only from validation annotations)
        let max_errors: u64 = annotations.iter().map(|(_, anns)| {
            anns.iter().filter(|a| matches!(a.name.as_str(), "min" | "max" | "validate" | "pattern")).count() as u64
        }).sum();

        if max_errors == 0 {
            // Only @default/@transform annotations, no validation to do
            return self.build_validate_ok(struct_val, &target_type);
        }

        // Allocate error array
        let alloc_fn = self.module.get_function("forge_alloc").unwrap();
        let total_size = self.builder.build_int_mul(
            field_error_size,
            self.context.i64_type().const_int(max_errors, false),
            "err_array_size",
        ).unwrap();
        let errors_ptr = self.builder.build_call(
            alloc_fn, &[total_size.into()], "errors_data"
        ).unwrap().try_as_basic_value().left()?.into_pointer_value();

        // Error counter
        let error_count_ptr = self.builder.build_alloca(
            self.context.i64_type(), "error_count"
        ).unwrap();
        self.builder.build_store(error_count_ptr, self.context.i64_type().const_zero()).unwrap();

        // For each annotated field, generate validation checks
        for (field_name, field_anns) in &annotations {
            // Find field index in struct
            let field_idx = match struct_fields.iter().position(|(n, _)| n == field_name) {
                Some(idx) => idx,
                None => continue,
            };
            let field_type = &struct_fields[field_idx].1;

            // Skip fields with only non-validation annotations
            let has_validation = field_anns.iter().any(|a| {
                matches!(a.name.as_str(), "min" | "max" | "validate" | "pattern")
            });
            if !has_validation { continue; }

            // Extract field value from (possibly transformed) struct
            let field_val = self.builder.build_extract_value(
                struct_val.into_struct_value(),
                field_idx as u32,
                &format!("field_{}", field_name),
            ).unwrap();

            // For partial types, skip validation if field is null
            let after_field_block = if is_partial && matches!(field_type, Type::Nullable(_)) {
                let has_value = self.builder.build_extract_value(
                    field_val.into_struct_value(), 0, "has_val"
                ).unwrap();
                let has_val_bool = self.builder.build_int_compare(
                    IntPredicate::NE,
                    has_value.into_int_value(),
                    self.context.i8_type().const_zero(),
                    "has_val_bool",
                ).unwrap();

                let check_block = self.context.append_basic_block(current_fn, &format!("check_{}", field_name));
                let skip_block = self.context.append_basic_block(current_fn, &format!("skip_{}", field_name));
                self.builder.build_conditional_branch(has_val_bool, check_block, skip_block).unwrap();
                self.builder.position_at_end(check_block);

                Some(skip_block)
            } else {
                None
            };

            // Get the actual value to check (unwrap nullable for partial types)
            let check_val = if is_partial && matches!(field_type, Type::Nullable(_)) {
                self.builder.build_extract_value(
                    field_val.into_struct_value(), 1, "inner_val"
                ).unwrap()
            } else {
                field_val
            };

            // The underlying type for checks (unwrap nullable)
            let check_type = match field_type {
                Type::Nullable(inner) => inner.as_ref(),
                other => other,
            };

            for ann in field_anns {
                self.compile_annotation_check(
                    ann,
                    check_val,
                    check_type,
                    field_name,
                    errors_ptr,
                    error_count_ptr,
                    field_error_type,
                    current_fn,
                );
            }

            // Jump to after_field_block if we created one for partial check
            if let Some(skip_block) = after_field_block {
                self.builder.build_unconditional_branch(skip_block).unwrap();
                self.builder.position_at_end(skip_block);
            }
        }

        // Build the final result based on error count
        let final_count = self.builder.build_load(
            self.context.i64_type(), error_count_ptr, "final_count"
        ).unwrap().into_int_value();

        let has_errors = self.builder.build_int_compare(
            IntPredicate::NE,
            final_count,
            self.context.i64_type().const_zero(),
            "has_errors",
        ).unwrap();

        let ok_block = self.context.append_basic_block(current_fn, "validate_ok");
        let err_block = self.context.append_basic_block(current_fn, "validate_err");
        let merge_block = self.context.append_basic_block(current_fn, "validate_merge");

        self.builder.build_conditional_branch(has_errors, err_block, ok_block).unwrap();

        // Build the Result type
        let validation_error_type = Type::Struct {
            name: Some("ValidationError".to_string()),
            fields: vec![
                ("fields".to_string(), Type::List(Box::new(Type::Struct {
                    name: Some("FieldError".to_string()),
                    fields: vec![
                        ("field".to_string(), Type::String),
                        ("rule".to_string(), Type::String),
                        ("message".to_string(), Type::String),
                    ],
                }))),
            ],
        };
        let result_type = Type::Result(
            Box::new(target_type.clone()),
            Box::new(validation_error_type),
        );
        let result_llvm_ty = self.type_to_llvm_basic(&result_type).into_struct_type();

        // OK path — return the transformed struct
        self.builder.position_at_end(ok_block);
        let ok_alloca = self.builder.build_alloca(result_llvm_ty, "ok_result").unwrap();
        let tag_ptr = self.builder.build_struct_gep(result_llvm_ty, ok_alloca, 0, "tag_ptr").unwrap();
        self.builder.build_store(tag_ptr, self.context.i8_type().const_zero()).unwrap();
        let payload_ptr = self.builder.build_struct_gep(result_llvm_ty, ok_alloca, 1, "payload_ptr").unwrap();
        let val_ptr = self.builder.build_bit_cast(
            payload_ptr, self.context.ptr_type(AddressSpace::default()), "val_ptr"
        ).unwrap();
        self.builder.build_store(val_ptr.into_pointer_value(), struct_val).unwrap();
        let ok_result = self.builder.build_load(result_llvm_ty, ok_alloca, "ok_loaded").unwrap();
        self.builder.build_unconditional_branch(merge_block).unwrap();

        // ERR path
        self.builder.position_at_end(err_block);
        let list_type = self.context.struct_type(
            &[
                self.context.ptr_type(AddressSpace::default()).into(),
                self.context.i64_type().into(),
            ],
            false,
        );
        let mut list_val = list_type.get_undef();
        list_val = self.builder.build_insert_value(list_val, errors_ptr, 0, "list_ptr")
            .unwrap().into_struct_value();
        let final_count_err = self.builder.build_load(
            self.context.i64_type(), error_count_ptr, "final_count_err"
        ).unwrap();
        list_val = self.builder.build_insert_value(list_val, final_count_err, 1, "list_len")
            .unwrap().into_struct_value();

        let ve_type = self.context.struct_type(&[list_type.into()], false);
        let mut ve_val = ve_type.get_undef();
        ve_val = self.builder.build_insert_value(ve_val, list_val, 0, "ve_fields")
            .unwrap().into_struct_value();

        let err_alloca = self.builder.build_alloca(result_llvm_ty, "err_result").unwrap();
        let tag_ptr = self.builder.build_struct_gep(result_llvm_ty, err_alloca, 0, "tag_ptr").unwrap();
        self.builder.build_store(tag_ptr, self.context.i8_type().const_int(1, false)).unwrap();
        let payload_ptr = self.builder.build_struct_gep(result_llvm_ty, err_alloca, 1, "payload_ptr").unwrap();
        let val_ptr = self.builder.build_bit_cast(
            payload_ptr, self.context.ptr_type(AddressSpace::default()), "val_ptr"
        ).unwrap();
        self.builder.build_store(val_ptr.into_pointer_value(), ve_val).unwrap();
        let err_result = self.builder.build_load(result_llvm_ty, err_alloca, "err_loaded").unwrap();
        self.builder.build_unconditional_branch(merge_block).unwrap();

        // Merge
        self.builder.position_at_end(merge_block);
        let phi = self.builder.build_phi(result_llvm_ty, "validate_result").unwrap();
        phi.add_incoming(&[(&ok_result, ok_block), (&err_result, err_block)]);

        Some(phi.as_basic_value())
    }

    /// Apply @default annotation: if nullable field is null, replace with default value.
    fn apply_default(
        &mut self,
        struct_val: BasicValueEnum<'ctx>,
        field_idx: usize,
        ann: &FieldAnnotation,
        field_type: &Type,
        current_fn: FunctionValue<'ctx>,
    ) -> BasicValueEnum<'ctx> {
        let inner_type = match field_type {
            Type::Nullable(inner) => inner.as_ref(),
            _ => return struct_val,
        };

        // Extract the nullable field
        let field_val = self.builder.build_extract_value(
            struct_val.into_struct_value(), field_idx as u32, "default_field"
        ).unwrap();

        let has_value = self.builder.build_extract_value(
            field_val.into_struct_value(), 0, "has_val"
        ).unwrap();
        let is_null = self.builder.build_int_compare(
            IntPredicate::EQ,
            has_value.into_int_value(),
            self.context.i8_type().const_zero(),
            "is_null",
        ).unwrap();

        let apply_block = self.context.append_basic_block(current_fn, "apply_default");
        let skip_block = self.context.append_basic_block(current_fn, "skip_default");

        self.builder.build_conditional_branch(is_null, apply_block, skip_block).unwrap();

        // Apply default: build nullable { 1, default_value }
        self.builder.position_at_end(apply_block);
        let default_val = match (&ann.args.first(), inner_type) {
            (Some(AnnotationArg::String(s)), Type::String) => {
                Some(self.make_forge_string(s))
            }
            (Some(AnnotationArg::Int(n)), Type::Int) => {
                Some(self.context.i64_type().const_int(*n as u64, true).into())
            }
            (Some(AnnotationArg::Float(f)), Type::Float) => {
                Some(self.context.f64_type().const_float(*f).into())
            }
            (Some(AnnotationArg::Bool(b)), Type::Bool) => {
                Some(self.context.i8_type().const_int(*b as u64, false).into())
            }
            (Some(AnnotationArg::Ident(s)), Type::String) => {
                // @default(member) treated as string literal
                Some(self.make_forge_string(s))
            }
            _ => None,
        };

        let applied_struct = if let Some(dv) = default_val {
            // Build nullable wrapper: { tag=1, value }
            let nullable_llvm = self.type_to_llvm_basic(field_type);
            let nullable_ty = nullable_llvm.into_struct_type();
            let mut nullable_val = nullable_ty.get_undef();
            nullable_val = self.builder.build_insert_value(
                nullable_val, self.context.i8_type().const_int(1, false), 0, "has"
            ).unwrap().into_struct_value();
            nullable_val = self.builder.build_insert_value(
                nullable_val, dv, 1, "default_val"
            ).unwrap().into_struct_value();

            // Replace field in struct
            self.builder.build_insert_value(
                struct_val.into_struct_value(), nullable_val, field_idx as u32, "with_default"
            ).unwrap().into_struct_value().into()
        } else {
            struct_val
        };

        self.builder.build_unconditional_branch(skip_block).unwrap();
        let apply_end = self.builder.get_insert_block().unwrap();

        // Merge
        self.builder.position_at_end(skip_block);
        let phi = self.builder.build_phi(struct_val.get_type(), "default_merged").unwrap();
        phi.add_incoming(&[(&applied_struct, apply_end), (&struct_val, {
            // The block before the conditional branch — we need the predecessor
            // The skip_block has two incoming edges: apply_block and the original block
            // We need the block that branched to skip_block directly
            apply_block.get_previous_basic_block().unwrap()
        })]);
        phi.as_basic_value()
    }

    /// Apply @transform annotation: compile the expression with `it` bound to field value.
    /// Supports method chains like `it.lower().trim()`.
    fn apply_transform(
        &mut self,
        struct_val: BasicValueEnum<'ctx>,
        field_idx: usize,
        ann: &FieldAnnotation,
        field_type: &Type,
        is_partial: bool,
        current_fn: FunctionValue<'ctx>,
    ) -> Option<BasicValueEnum<'ctx>> {
        let transform_expr = match ann.args.first() {
            Some(AnnotationArg::Expr(expr)) => expr.clone(),
            _ => return Some(struct_val),
        };

        // For partial nullable fields, only transform if present
        if is_partial && matches!(field_type, Type::Nullable(_)) {
            let field_val = self.builder.build_extract_value(
                struct_val.into_struct_value(), field_idx as u32, "tf_field"
            ).unwrap();
            let has_value = self.builder.build_extract_value(
                field_val.into_struct_value(), 0, "tf_has"
            ).unwrap();
            let has_val_bool = self.builder.build_int_compare(
                IntPredicate::NE,
                has_value.into_int_value(),
                self.context.i8_type().const_zero(),
                "tf_has_bool",
            ).unwrap();

            let transform_block = self.context.append_basic_block(current_fn, "transform");
            let skip_block = self.context.append_basic_block(current_fn, "skip_transform");

            self.builder.build_conditional_branch(has_val_bool, transform_block, skip_block).unwrap();
            let pre_block = self.builder.get_insert_block().unwrap();

            self.builder.position_at_end(transform_block);
            let inner_val = self.builder.build_extract_value(
                field_val.into_struct_value(), 1, "tf_inner"
            ).unwrap();

            // Bind `it` and compile transform expression
            self.push_scope();
            let inner_type = match field_type {
                Type::Nullable(inner) => inner.as_ref().clone(),
                _ => unreachable!(),
            };
            let alloca = self.create_entry_block_alloca(&inner_type, "it");
            self.builder.build_store(alloca, inner_val).unwrap();
            self.define_var("it".to_string(), alloca, inner_type);
            let transformed = self.compile_expr(&transform_expr)?;
            self.pop_scope();

            // Re-wrap in nullable
            let nullable_llvm = self.type_to_llvm_basic(field_type).into_struct_type();
            let mut new_nullable = nullable_llvm.get_undef();
            new_nullable = self.builder.build_insert_value(
                new_nullable, self.context.i8_type().const_int(1, false), 0, "has"
            ).unwrap().into_struct_value();
            new_nullable = self.builder.build_insert_value(
                new_nullable, transformed, 1, "transformed"
            ).unwrap().into_struct_value();

            let new_struct: BasicValueEnum = self.builder.build_insert_value(
                struct_val.into_struct_value(), new_nullable, field_idx as u32, "with_transform"
            ).unwrap().into_struct_value().into();

            self.builder.build_unconditional_branch(skip_block).unwrap();
            let transform_end = self.builder.get_insert_block().unwrap();

            self.builder.position_at_end(skip_block);
            let phi = self.builder.build_phi(struct_val.get_type(), "tf_merged").unwrap();
            phi.add_incoming(&[(&new_struct, transform_end), (&struct_val, pre_block)]);
            return Some(phi.as_basic_value());
        }

        // Non-nullable field: always transform
        let field_val = self.builder.build_extract_value(
            struct_val.into_struct_value(), field_idx as u32, "tf_field"
        ).unwrap();

        // Bind `it` and compile transform expression
        self.push_scope();
        let check_type = match field_type {
            Type::Nullable(inner) => inner.as_ref().clone(),
            other => other.clone(),
        };
        let alloca = self.create_entry_block_alloca(&check_type, "it");
        self.builder.build_store(alloca, field_val).unwrap();
        self.define_var("it".to_string(), alloca, check_type);
        let transformed = self.compile_expr(&transform_expr)?;
        self.pop_scope();

        // Replace field in struct
        let new_struct = self.builder.build_insert_value(
            struct_val.into_struct_value(), transformed, field_idx as u32, "with_transform"
        ).unwrap().into_struct_value();
        Some(new_struct.into())
    }

    /// Generate a single annotation check for a field.
    /// If the check fails, stores a FieldError in the errors array and increments the count.
    fn compile_annotation_check(
        &mut self,
        ann: &FieldAnnotation,
        field_val: BasicValueEnum<'ctx>,
        field_type: &Type,
        field_name: &str,
        errors_ptr: PointerValue<'ctx>,
        error_count_ptr: PointerValue<'ctx>,
        field_error_type: StructType<'ctx>,
        current_fn: FunctionValue<'ctx>,
    ) {
        let check_result = match ann.name.as_str() {
            "min" => self.compile_min_check(ann, field_val, field_type),
            "max" => self.compile_max_check(ann, field_val, field_type),
            "validate" => self.compile_named_validator_check(ann, field_val, field_type),
            "pattern" => self.compile_validate_pattern_check(ann, field_val, field_type),
            _ => return, // @default, @transform already handled in earlier phases
        };

        let (check_ok, rule_name, error_message) = match check_result {
            Some(r) => r,
            None => return,
        };

        // Create blocks for pass/fail
        let fail_block = self.context.append_basic_block(
            current_fn, &format!("fail_{}_{}", field_name, ann.name)
        );
        let cont_block = self.context.append_basic_block(
            current_fn, &format!("cont_{}_{}", field_name, ann.name)
        );

        self.builder.build_conditional_branch(check_ok, cont_block, fail_block).unwrap();

        // Fail block: store FieldError
        self.builder.position_at_end(fail_block);

        let field_str = self.make_forge_string(field_name);
        let rule_str = self.make_forge_string(&rule_name);
        let msg_str = self.make_forge_string(&error_message);

        let mut error_val = field_error_type.get_undef();
        error_val = self.builder.build_insert_value(error_val, field_str, 0, "fe_field")
            .unwrap().into_struct_value();
        error_val = self.builder.build_insert_value(error_val, rule_str, 1, "fe_rule")
            .unwrap().into_struct_value();
        error_val = self.builder.build_insert_value(error_val, msg_str, 2, "fe_msg")
            .unwrap().into_struct_value();

        // Store at errors_ptr[error_count]
        let count = self.builder.build_load(
            self.context.i64_type(), error_count_ptr, "cur_count"
        ).unwrap().into_int_value();
        let elem_ptr = unsafe {
            self.builder.build_gep(
                field_error_type, errors_ptr, &[count], "error_slot"
            ).unwrap()
        };
        self.builder.build_store(elem_ptr, error_val).unwrap();

        // Increment count
        let new_count = self.builder.build_int_add(
            count, self.context.i64_type().const_int(1, false), "inc_count"
        ).unwrap();
        self.builder.build_store(error_count_ptr, new_count).unwrap();

        self.builder.build_unconditional_branch(cont_block).unwrap();
        self.builder.position_at_end(cont_block);
    }

    /// Check @min(n) — string length >= n or numeric value >= n
    fn compile_min_check(
        &mut self,
        ann: &FieldAnnotation,
        field_val: BasicValueEnum<'ctx>,
        field_type: &Type,
    ) -> Option<(IntValue<'ctx>, String, String)> {
        let min_val = match ann.args.first() {
            Some(AnnotationArg::Int(n)) => *n,
            _ => return None,
        };

        match field_type {
            Type::String => {
                let len_fn = self.module.get_function("forge_string_length").unwrap();
                let len = self.builder.build_call(
                    len_fn, &[field_val.into()], "str_len"
                ).unwrap().try_as_basic_value().left()?.into_int_value();
                let ok = self.builder.build_int_compare(
                    IntPredicate::SGE, len,
                    self.context.i64_type().const_int(min_val as u64, false),
                    "min_ok",
                ).unwrap();
                Some((ok, "min".to_string(),
                    format!("must be at least {} character{}", min_val, if min_val != 1 { "s" } else { "" })))
            }
            Type::Int => {
                let ok = self.builder.build_int_compare(
                    IntPredicate::SGE,
                    field_val.into_int_value(),
                    self.context.i64_type().const_int(min_val as u64, true),
                    "min_ok",
                ).unwrap();
                Some((ok, "min".to_string(), format!("must be at least {}", min_val)))
            }
            Type::Float => {
                let ok = self.builder.build_float_compare(
                    inkwell::FloatPredicate::OGE,
                    field_val.into_float_value(),
                    self.context.f64_type().const_float(min_val as f64),
                    "min_ok",
                ).unwrap();
                Some((ok, "min".to_string(), format!("must be at least {}", min_val)))
            }
            _ => None,
        }
    }

    /// Check @max(n) — string length <= n or numeric value <= n
    fn compile_max_check(
        &mut self,
        ann: &FieldAnnotation,
        field_val: BasicValueEnum<'ctx>,
        field_type: &Type,
    ) -> Option<(IntValue<'ctx>, String, String)> {
        let max_val = match ann.args.first() {
            Some(AnnotationArg::Int(n)) => *n,
            _ => return None,
        };

        match field_type {
            Type::String => {
                let len_fn = self.module.get_function("forge_string_length").unwrap();
                let len = self.builder.build_call(
                    len_fn, &[field_val.into()], "str_len"
                ).unwrap().try_as_basic_value().left()?.into_int_value();
                let ok = self.builder.build_int_compare(
                    IntPredicate::SLE, len,
                    self.context.i64_type().const_int(max_val as u64, false),
                    "max_ok",
                ).unwrap();
                Some((ok, "max".to_string(),
                    format!("must be at most {} character{}", max_val, if max_val != 1 { "s" } else { "" })))
            }
            Type::Int => {
                let ok = self.builder.build_int_compare(
                    IntPredicate::SLE,
                    field_val.into_int_value(),
                    self.context.i64_type().const_int(max_val as u64, true),
                    "max_ok",
                ).unwrap();
                Some((ok, "max".to_string(), format!("must be at most {}", max_val)))
            }
            Type::Float => {
                let ok = self.builder.build_float_compare(
                    inkwell::FloatPredicate::OLE,
                    field_val.into_float_value(),
                    self.context.f64_type().const_float(max_val as f64),
                    "max_ok",
                ).unwrap();
                Some((ok, "max".to_string(), format!("must be at most {}", max_val)))
            }
            _ => None,
        }
    }

    /// Check @validate(email), @validate(url), @validate(uuid)
    fn compile_named_validator_check(
        &mut self,
        ann: &FieldAnnotation,
        field_val: BasicValueEnum<'ctx>,
        _field_type: &Type,
    ) -> Option<(IntValue<'ctx>, String, String)> {
        let validator = match ann.args.first() {
            Some(AnnotationArg::Ident(name)) => name.clone(),
            _ => return None,
        };

        let (fn_name, rule, msg) = match validator.as_str() {
            "email" => ("forge_validate_email", "email", "must be a valid email address"),
            "url" => ("forge_validate_url", "url", "must be a valid URL"),
            "uuid" => ("forge_validate_uuid", "uuid", "must be a valid UUID"),
            _ => return None,
        };

        let validate_fn = self.module.get_function(fn_name)?;
        let result = self.builder.build_call(
            validate_fn, &[field_val.into()], "validate_result"
        ).unwrap().try_as_basic_value().left()?.into_int_value();

        let ok = self.builder.build_int_compare(
            IntPredicate::NE,
            result,
            self.context.i64_type().const_zero(),
            "validate_ok",
        ).unwrap();

        Some((ok, rule.to_string(), msg.to_string()))
    }

    /// Check @pattern("regex")
    fn compile_validate_pattern_check(
        &mut self,
        ann: &FieldAnnotation,
        field_val: BasicValueEnum<'ctx>,
        _field_type: &Type,
    ) -> Option<(IntValue<'ctx>, String, String)> {
        let pattern = match ann.args.first() {
            Some(AnnotationArg::String(s)) => s.clone(),
            _ => return None,
        };

        let pattern_str = self.make_forge_string(&pattern);
        let validate_fn = self.module.get_function("forge_validate_pattern")?;
        let result = self.builder.build_call(
            validate_fn, &[field_val.into(), pattern_str.into()], "pattern_result"
        ).unwrap().try_as_basic_value().left()?.into_int_value();

        let ok = self.builder.build_int_compare(
            IntPredicate::NE,
            result,
            self.context.i64_type().const_zero(),
            "pattern_ok",
        ).unwrap();

        Some((ok, "pattern".to_string(), format!("must match pattern {}", pattern)))
    }

    /// Build a Result::Ok wrapping the given struct value
    fn build_validate_ok(
        &mut self,
        struct_val: BasicValueEnum<'ctx>,
        target_type: &Type,
    ) -> Option<BasicValueEnum<'ctx>> {
        let validation_error_type = Type::Struct {
            name: Some("ValidationError".to_string()),
            fields: vec![
                ("fields".to_string(), Type::List(Box::new(Type::Struct {
                    name: Some("FieldError".to_string()),
                    fields: vec![
                        ("field".to_string(), Type::String),
                        ("rule".to_string(), Type::String),
                        ("message".to_string(), Type::String),
                    ],
                }))),
            ],
        };
        let result_type = Type::Result(
            Box::new(target_type.clone()),
            Box::new(validation_error_type),
        );
        let result_llvm_ty = self.type_to_llvm_basic(&result_type).into_struct_type();

        let alloca = self.builder.build_alloca(result_llvm_ty, "ok_result").unwrap();
        let tag_ptr = self.builder.build_struct_gep(result_llvm_ty, alloca, 0, "tag_ptr").unwrap();
        self.builder.build_store(tag_ptr, self.context.i8_type().const_zero()).unwrap();
        let payload_ptr = self.builder.build_struct_gep(result_llvm_ty, alloca, 1, "payload_ptr").unwrap();
        let val_ptr = self.builder.build_bit_cast(
            payload_ptr, self.context.ptr_type(AddressSpace::default()), "val_ptr"
        ).unwrap();
        self.builder.build_store(val_ptr.into_pointer_value(), struct_val).unwrap();
        let result = self.builder.build_load(result_llvm_ty, alloca, "ok_loaded").unwrap();
        Some(result)
    }

    /// Create a ForgeString constant from a &str
    pub(crate) fn make_forge_string(&mut self, s: &str) -> BasicValueEnum<'ctx> {
        let global = self.builder.build_global_string_ptr(s, "str_const").unwrap();
        let ptr = global.as_pointer_value();
        let len = self.context.i64_type().const_int(s.len() as u64, false);

        let string_new_fn = self.module.get_function("forge_string_new").unwrap();
        self.builder.build_call(
            string_new_fn,
            &[ptr.into(), len.into()],
            "forge_str",
        ).unwrap().try_as_basic_value().left().unwrap()
    }
}
