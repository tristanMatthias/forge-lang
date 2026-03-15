use inkwell::types::StructType;
use inkwell::values::{BasicValueEnum, FunctionValue, IntValue, PointerValue};
use inkwell::AddressSpace;
use inkwell::IntPredicate;

use crate::codegen::codegen::Codegen;
use crate::parser::ast::*;
use crate::typeck::types::Type;
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

        let current_fn = self.current_function();

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
        let total_size = self.builder.build_int_mul(
            field_error_size,
            self.context.i64_type().const_int(max_errors, false),
            "err_array_size",
        ).unwrap();
        let errors_ptr = self.call_runtime(
            "forge_alloc", &[total_size.into()], "errors_data"
        )?.into_pointer_value();

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
                let has_val_bool = self.extract_tag_is_set(field_val.into_struct_value(), "has_val").unwrap();

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
                self.extract_tagged_payload(field_val.into_struct_value(), "inner").unwrap()
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
        let result_type = Self::validation_result_type(&target_type);
        let result_llvm_ty = self.type_to_llvm_basic(&result_type).into_struct_type();

        // OK path — return the transformed struct
        self.builder.position_at_end(ok_block);
        let ok_result = self.build_tagged_result(result_llvm_ty, 0, struct_val, "ok");
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

        let err_result = self.build_tagged_result(result_llvm_ty, 1, ve_val.into(), "err");
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

        let has_val = self.extract_tag_is_set(field_val.into_struct_value(), "default").unwrap();
        let is_null = self.builder.build_not(has_val, "is_null").unwrap();

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
            let has_val_bool = self.extract_tag_is_set(field_val.into_struct_value(), "tf").unwrap();

            let transform_block = self.context.append_basic_block(current_fn, "transform");
            let skip_block = self.context.append_basic_block(current_fn, "skip_transform");

            self.builder.build_conditional_branch(has_val_bool, transform_block, skip_block).unwrap();
            let pre_block = self.builder.get_insert_block().unwrap();

            self.builder.position_at_end(transform_block);
            let inner_val = self.extract_tagged_payload(field_val.into_struct_value(), "tf").unwrap();

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
        // Check for closure validator: @validate((val) -> { Ok(val) / Err("msg") })
        if ann.name == "validate" {
            if let Some(AnnotationArg::Expr(closure_expr)) = ann.args.first() {
                let closure_parts = match closure_expr {
                    Expr::Feature(fe) if fe.feature_id == "closures" => {
                        fe.data.as_any().downcast_ref::<crate::features::closures::types::ClosureData>()
                            .map(|data| (data.params.as_slice(), data.body.as_ref()))
                    }
                    _ => None,
                };
                if let Some((params, body)) = closure_parts {
                    self.compile_closure_validator_check(
                        params, body, field_val, field_type, field_name,
                        errors_ptr, error_count_ptr, field_error_type, current_fn,
                    );
                    return;
                }
            }
        }

        let check_result = match ann.name.as_str() {
            "min" => self.compile_bound_check(ann, field_val, field_type, true),
            "max" => self.compile_bound_check(ann, field_val, field_type, false),
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

        let error_val = self.build_field_error(field_error_type, field_str, rule_str, msg_str);
        self.append_field_error(error_val, field_error_type, errors_ptr, error_count_ptr);

        self.builder.build_unconditional_branch(cont_block).unwrap();
        self.builder.position_at_end(cont_block);
    }

    /// Compile a closure-based validator: @validate((val) -> { Ok(val) / Err("msg") })
    /// The closure receives the field value and returns Result<T, string>.
    /// On Ok, validation passes. On Err, the error string becomes the validation message.
    fn compile_closure_validator_check(
        &mut self,
        params: &[Param],
        body: &Expr,
        field_val: BasicValueEnum<'ctx>,
        field_type: &Type,
        field_name: &str,
        errors_ptr: PointerValue<'ctx>,
        error_count_ptr: PointerValue<'ctx>,
        field_error_type: StructType<'ctx>,
        current_fn: FunctionValue<'ctx>,
    ) {
        let check_type = match field_type {
            Type::Nullable(inner) => inner.as_ref().clone(),
            other => other.clone(),
        };

        // Build the Result type that the closure will return: Result<check_type, String>
        let result_type = Type::Result(Box::new(check_type.clone()), Box::new(Type::String));

        // Save and set current_fn_return_type so Ok()/Err() compile with the right layout
        let saved_return_type = self.current_fn_return_type.take();
        self.current_fn_return_type = Some(result_type.clone());

        // Bind the closure parameter(s) to the field value
        self.push_scope();
        let param_name = if !params.is_empty() {
            params[0].name.clone()
        } else {
            "it".to_string()
        };
        let alloca = self.create_entry_block_alloca(&check_type, &param_name);
        self.builder.build_store(alloca, field_val).unwrap();
        self.define_var(param_name.clone(), alloca, check_type.clone());
        // Also bind `it` as alias if the param has a different name
        if param_name != "it" {
            self.define_var("it".to_string(), alloca, check_type.clone());
        }

        // Compile the closure body — should produce a Result value
        let result_val = self.compile_expr(body);
        self.pop_scope();

        // Restore the saved return type
        self.current_fn_return_type = saved_return_type;

        let result_val = match result_val {
            Some(v) => v,
            None => return,
        };

        // The result is a struct {i8 tag, payload...}. Tag 0 = Ok, Tag 1 = Err.
        if !result_val.is_struct_value() {
            return;
        }

        let struct_val = result_val.into_struct_value();
        let is_err = self.extract_tag_is_set(struct_val, "closure").unwrap();

        let fail_block = self.context.append_basic_block(
            current_fn, &format!("fail_{}_closure", field_name)
        );
        let cont_block = self.context.append_basic_block(
            current_fn, &format!("cont_{}_closure", field_name)
        );

        self.builder.build_conditional_branch(is_err, fail_block, cont_block).unwrap();

        // Fail block: extract error message from Result Err payload and store FieldError
        self.builder.position_at_end(fail_block);

        // Extract the error string from the Result payload via memory reinterpret
        let result_llvm_ty = self.type_to_llvm_basic(&result_type).into_struct_type();
        let result_alloca = self.builder.build_alloca(result_llvm_ty, "closure_result_tmp").unwrap();
        self.builder.build_store(result_alloca, struct_val).unwrap();
        let payload_ptr = self.builder.build_struct_gep(result_llvm_ty, result_alloca, 1, "err_payload_ptr").unwrap();
        let val_ptr = self.builder.build_bit_cast(
            payload_ptr, self.context.ptr_type(AddressSpace::default()), "err_val_ptr"
        ).unwrap();
        let err_string_type = self.type_to_llvm_basic(&Type::String);
        let err_msg = self.builder.build_load(
            err_string_type, val_ptr.into_pointer_value(), "err_msg"
        ).unwrap();

        let field_str = self.make_forge_string(field_name);
        let rule_str = self.make_forge_string("validate");

        let error_val = self.build_field_error(field_error_type, field_str, rule_str, err_msg);
        self.append_field_error(error_val, field_error_type, errors_ptr, error_count_ptr);

        self.builder.build_unconditional_branch(cont_block).unwrap();
        self.builder.position_at_end(cont_block);
    }

    /// Build a FieldError struct value from field name, rule name, and message.
    fn build_field_error(
        &mut self,
        field_error_type: StructType<'ctx>,
        field_str: BasicValueEnum<'ctx>,
        rule_str: BasicValueEnum<'ctx>,
        msg_str: BasicValueEnum<'ctx>,
    ) -> inkwell::values::StructValue<'ctx> {
        let mut error_val = field_error_type.get_undef();
        error_val = self.builder.build_insert_value(error_val, field_str, 0, "fe_field")
            .unwrap().into_struct_value();
        error_val = self.builder.build_insert_value(error_val, rule_str, 1, "fe_rule")
            .unwrap().into_struct_value();
        error_val = self.builder.build_insert_value(error_val, msg_str, 2, "fe_msg")
            .unwrap().into_struct_value();
        error_val
    }

    /// Store a FieldError at the current index in the errors array and increment the count.
    fn append_field_error(
        &mut self,
        error_val: inkwell::values::StructValue<'ctx>,
        field_error_type: StructType<'ctx>,
        errors_ptr: PointerValue<'ctx>,
        error_count_ptr: PointerValue<'ctx>,
    ) {
        let count = self.builder.build_load(
            self.context.i64_type(), error_count_ptr, "cur_count"
        ).unwrap().into_int_value();
        let elem_ptr = unsafe {
            self.builder.build_gep(
                field_error_type, errors_ptr, &[count], "error_slot"
            ).unwrap()
        };
        self.builder.build_store(elem_ptr, error_val).unwrap();

        let new_count = self.builder.build_int_add(
            count, self.context.i64_type().const_int(1, false), "inc_count"
        ).unwrap();
        self.builder.build_store(error_count_ptr, new_count).unwrap();
    }

    /// Check @min(n) or @max(n) — string length or numeric value bound check.
    /// `is_min`: true for @min (>= check), false for @max (<= check).
    fn compile_bound_check(
        &mut self,
        ann: &FieldAnnotation,
        field_val: BasicValueEnum<'ctx>,
        field_type: &Type,
        is_min: bool,
    ) -> Option<(IntValue<'ctx>, String, String)> {
        let bound_val = match ann.args.first() {
            Some(AnnotationArg::Int(n)) => *n,
            _ => return None,
        };

        let (int_pred, float_pred, rule, qualifier) = if is_min {
            (IntPredicate::SGE, inkwell::FloatPredicate::OGE, "min", "at least")
        } else {
            (IntPredicate::SLE, inkwell::FloatPredicate::OLE, "max", "at most")
        };
        let check_label = format!("{}_ok", rule);

        match field_type {
            Type::String => {
                let len = self.call_runtime("forge_string_length", &[field_val.into()], "str_len")?.into_int_value();
                let ok = self.builder.build_int_compare(
                    int_pred, len,
                    self.context.i64_type().const_int(bound_val as u64, false),
                    &check_label,
                ).unwrap();
                Some((ok, rule.to_string(),
                    format!("must be {} {} character{}", qualifier, bound_val, if bound_val != 1 { "s" } else { "" })))
            }
            Type::Int => {
                let ok = self.builder.build_int_compare(
                    int_pred,
                    field_val.into_int_value(),
                    self.context.i64_type().const_int(bound_val as u64, true),
                    &check_label,
                ).unwrap();
                Some((ok, rule.to_string(), format!("must be {} {}", qualifier, bound_val)))
            }
            Type::Float => {
                let ok = self.builder.build_float_compare(
                    float_pred,
                    field_val.into_float_value(),
                    self.context.f64_type().const_float(bound_val as f64),
                    &check_label,
                ).unwrap();
                Some((ok, rule.to_string(), format!("must be {} {}", qualifier, bound_val)))
            }
            _ => None,
        }
    }

    /// Check @validate(email), @validate(url), @validate(uuid), or @validate(expr)
    fn compile_named_validator_check(
        &mut self,
        ann: &FieldAnnotation,
        field_val: BasicValueEnum<'ctx>,
        field_type: &Type,
    ) -> Option<(IntValue<'ctx>, String, String)> {
        match ann.args.first() {
            Some(AnnotationArg::Ident(name)) => {
                // Named validators: email, url, uuid
                let (fn_name, rule, msg) = match name.as_str() {
                    "email" => ("forge_validate_email", "email", "must be a valid email address"),
                    "url" => ("forge_validate_url", "url", "must be a valid URL"),
                    "uuid" => ("forge_validate_uuid", "uuid", "must be a valid UUID"),
                    _ => return None,
                };

                let validate_fn = self.module.get_function(fn_name)?;
                let result = self.builder.build_call(
                    validate_fn, &[field_val.into()], "validate_result"
                ).unwrap().try_as_basic_value().left()?.into_int_value();

                Some((self.int_ne_zero(result, "validate_ok"), rule.to_string(), msg.to_string()))
            }
            Some(AnnotationArg::Expr(expr)) => {
                // Custom expression validator: @validate(it > 0 && it < 100)
                // Bind `it` to the field value and compile the expression
                let check_type = match field_type {
                    Type::Nullable(inner) => inner.as_ref().clone(),
                    other => other.clone(),
                };
                self.push_scope();
                let alloca = self.create_entry_block_alloca(&check_type, "it");
                self.builder.build_store(alloca, field_val).unwrap();
                self.define_var("it".to_string(), alloca, check_type.clone());
                // Also bind `val` as alias for `it`
                self.define_var("val".to_string(), alloca, check_type);
                let result = self.compile_expr(&expr.clone())?;
                self.pop_scope();

                // The expression should return a bool (i1) or int (i64)
                let ok = if result.is_int_value() {
                    let int_val = result.into_int_value();
                    if int_val.get_type().get_bit_width() == 1 {
                        // Already a bool
                        int_val
                    } else {
                        // Treat non-zero as pass
                        self.int_ne_zero(int_val, "custom_validate_ok")
                    }
                } else {
                    // Non-int result — can't use as validator
                    return None;
                };

                Some((ok, "validate".to_string(), "custom validation failed".to_string()))
            }
            _ => None,
        }
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
        let result = self.call_runtime("forge_validate_pattern", &[field_val.into(), pattern_str.into()], "pattern_result")?.into_int_value();
        Some((self.int_ne_zero(result, "pattern_ok"), "pattern".to_string(), format!("must match pattern {}", pattern)))
    }

    /// Compare an integer value against zero with NE predicate (returns i1 bool).
    fn int_ne_zero(&self, val: IntValue<'ctx>, label: &str) -> IntValue<'ctx> {
        self.builder.build_int_compare(
            IntPredicate::NE,
            val,
            val.get_type().const_zero(),
            label,
        ).unwrap()
    }

    /// Build the Result<TargetType, ValidationError> type for validation results.
    fn validation_result_type(target_type: &Type) -> Type {
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
        Type::Result(
            Box::new(target_type.clone()),
            Box::new(validation_error_type),
        )
    }

    /// Build a Result::Ok wrapping the given struct value
    fn build_validate_ok(
        &mut self,
        struct_val: BasicValueEnum<'ctx>,
        target_type: &Type,
    ) -> Option<BasicValueEnum<'ctx>> {
        let result_type = Self::validation_result_type(target_type);
        let result_llvm_ty = self.type_to_llvm_basic(&result_type).into_struct_type();
        Some(self.build_tagged_result(result_llvm_ty, 0, struct_val, "ok"))
    }

    /// Write a tagged Result value: store tag byte at slot 0, bitcast slot 1 and store payload,
    /// then load and return the complete struct value.
    fn build_tagged_result(
        &mut self,
        result_llvm_ty: inkwell::types::StructType<'ctx>,
        tag: u64,
        payload: BasicValueEnum<'ctx>,
        label: &str,
    ) -> BasicValueEnum<'ctx> {
        let alloca = self.builder.build_alloca(result_llvm_ty, &format!("{}_result", label)).unwrap();
        let tag_ptr = self.builder.build_struct_gep(result_llvm_ty, alloca, 0, "tag_ptr").unwrap();
        self.builder.build_store(tag_ptr, self.context.i8_type().const_int(tag, false)).unwrap();
        let payload_ptr = self.builder.build_struct_gep(result_llvm_ty, alloca, 1, "payload_ptr").unwrap();
        let val_ptr = self.builder.build_bit_cast(
            payload_ptr, self.context.ptr_type(AddressSpace::default()), "val_ptr"
        ).unwrap();
        self.builder.build_store(val_ptr.into_pointer_value(), payload).unwrap();
        self.builder.build_load(result_llvm_ty, alloca, &format!("{}_loaded", label)).unwrap()
    }

    /// Create a ForgeString constant from a &str
    pub(crate) fn make_forge_string(&mut self, s: &str) -> BasicValueEnum<'ctx> {
        let global = self.builder.build_global_string_ptr(s, "str_const").unwrap();
        let ptr = global.as_pointer_value();
        let len = self.context.i64_type().const_int(s.len() as u64, false);

        self.call_runtime("forge_string_new", &[ptr.into(), len.into()], "forge_str").unwrap()
    }
}
