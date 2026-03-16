use inkwell::values::{BasicValue, BasicValueEnum, IntValue};
use inkwell::types::BasicTypeEnum;
use inkwell::IntPredicate;

use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::feature_codegen;
use crate::parser::ast::*;
use crate::typeck::types::Type;

use super::types::MatchData;

impl<'ctx> Codegen<'ctx> {
    /// Compile a match expression via the Feature dispatch system.
    pub(crate) fn compile_match_feature(
        &mut self,
        fe: &FeatureExpr,
    ) -> Option<BasicValueEnum<'ctx>> {
        feature_codegen!(self, fe, MatchData, |data| self.compile_match(&data.subject, &data.arms))
    }

    pub(crate) fn compile_match(
        &mut self,
        subject: &Expr,
        arms: &[MatchArm],
    ) -> Option<BasicValueEnum<'ctx>> {
        let subject_val = self.compile_expr(subject)?;
        let subject_type = self.infer_type(subject);

        let function = self.current_function();
        let merge_bb = self.context.append_basic_block(function, "match_end");

        // For simplicity, implement match as a chain of if-else
        let mut arm_results: Vec<(BasicValueEnum<'ctx>, inkwell::basic_block::BasicBlock<'ctx>)> =
            Vec::new();
        let mut result_type: Option<BasicTypeEnum<'ctx>> = None;

        for (i, arm) in arms.iter().enumerate() {
            let is_last = i == arms.len() - 1;
            let arm_bb = self.context.append_basic_block(function, &format!("arm_{}", i));
            let next_bb = if is_last {
                // Last arm: always branch to it unconditionally (default case)
                arm_bb
            } else {
                self.context.append_basic_block(function, &format!("arm_{}_next", i))
            };

            // Check pattern
            let matched = self.compile_pattern_check(&arm.pattern, &subject_val, &subject_type);

            // Check guard
            let condition = if let Some(guard) = &arm.guard {
                if let Some(guard_val) = {
                    self.push_scope();
                    self.bind_pattern_vars(&arm.pattern, &subject_val, &subject_type);
                    let gv = self.compile_expr(guard);
                    self.pop_scope();
                    gv
                } {
                    if let Some(m) = matched {
                        let guard_bool = self.to_i1(guard_val);
                        Some(self.builder.build_and(m, guard_bool, "guard_and").unwrap())
                    } else {
                        Some(self.to_i1(guard_val))
                    }
                } else {
                    matched
                }
            } else {
                matched
            };

            if is_last {
                // Last arm always matches (default/fallthrough)
                self.builder.build_unconditional_branch(arm_bb).unwrap();
            } else if let Some(cond) = condition {
                self.builder.build_conditional_branch(cond, arm_bb, next_bb).unwrap();
            } else {
                // Wildcard/always match
                self.builder.build_unconditional_branch(arm_bb).unwrap();
            }

            // Compile arm body
            self.builder.position_at_end(arm_bb);
            self.push_scope();
            self.bind_pattern_vars(&arm.pattern, &subject_val, &subject_type);
            let arm_val = self.compile_expr(&arm.body);
            self.pop_scope();

            let arm_end_bb = self.builder.get_insert_block().unwrap();
            if arm_end_bb.get_terminator().is_none() {
                self.builder.build_unconditional_branch(merge_bb).unwrap();
                if let Some(val) = arm_val {
                    if result_type.is_none() {
                        result_type = Some(val.get_type());
                    }
                    arm_results.push((val, arm_end_bb));
                }
            }

            if !is_last {
                self.builder.position_at_end(next_bb);
            }
        }

        self.builder.position_at_end(merge_bb);

        // Build phi for results
        if let Some(rtype) = result_type {
            if !arm_results.is_empty() {
                let phi = self.builder.build_phi(rtype, "match_result").unwrap();
                let incoming: Vec<(&dyn BasicValue<'ctx>, inkwell::basic_block::BasicBlock<'ctx>)> =
                    arm_results.iter().map(|(v, bb)| (v as &dyn BasicValue, *bb)).collect();
                phi.add_incoming(&incoming);
                return Some(phi.as_basic_value());
            }
        }

        None
    }

    pub(crate) fn compile_pattern_check(
        &mut self,
        pattern: &Pattern,
        subject_val: &BasicValueEnum<'ctx>,
        subject_type: &Type,
    ) -> Option<IntValue<'ctx>> {
        match pattern {
            Pattern::Wildcard(_) | Pattern::Ident(_, _) => {
                // Always matches
                None
            }
            Pattern::Literal(expr) => {
                let lit_val = self.compile_expr(expr)?;
                if subject_val.is_int_value() && lit_val.is_int_value() {
                    let (a, b) = self.widen_ints(
                        subject_val.into_int_value(),
                        lit_val.into_int_value(),
                    );
                    Some(
                        self.builder
                            .build_int_compare(IntPredicate::EQ, a, b, "pat_eq")
                            .unwrap(),
                    )
                } else if subject_val.is_float_value() && lit_val.is_float_value() {
                    Some(
                        self.builder
                            .build_float_compare(
                                inkwell::FloatPredicate::OEQ,
                                subject_val.into_float_value(),
                                lit_val.into_float_value(),
                                "pat_eq",
                            )
                            .unwrap(),
                    )
                } else if subject_val.is_struct_value() && lit_val.is_struct_value() {
                    // String comparison via forge_string_eq
                    let bool_val = self.call_runtime(
                        "forge_string_eq",
                        &[(*subject_val).into(), lit_val.into()],
                        "str_eq",
                    )?.into_int_value();
                    Some(
                        self.builder
                            .build_int_compare(IntPredicate::NE, bool_val, self.context.i8_type().const_zero(), "str_pat")
                            .unwrap(),
                    )
                } else {
                    None
                }
            }
            Pattern::Enum { variant, fields, .. } => {
                // Check the tag of the enum or Result
                if let Type::Result(_, _) = subject_type {
                    // Result matching: Ok tag=0, Err tag=1
                    let tag_val = if variant == "Ok" { 0u64 } else if variant == "Err" { 1u64 } else { return None };
                    if subject_val.is_struct_value() {
                        let struct_val = subject_val.into_struct_value();
                        let tag = self.builder.build_extract_value(struct_val, 0, "tag").ok()?;
                        let expected = self.context.i8_type().const_int(tag_val, false);
                        Some(
                            self.builder
                                .build_int_compare(IntPredicate::EQ, tag.into_int_value(), expected, "result_match")
                                .unwrap(),
                        )
                    } else {
                        None
                    }
                } else if let Type::Enum { variants, .. } = subject_type {
                    if let Some(idx) = variants.iter().position(|v| v.name == *variant) {
                        if subject_val.is_struct_value() {
                            let struct_val = subject_val.into_struct_value();
                            let tag = self.builder.build_extract_value(struct_val, 0, "tag").ok()?;
                            let expected = self.context.i8_type().const_int(idx as u64, false);
                            let tag_check = self.builder
                                .build_int_compare(IntPredicate::EQ, tag.into_int_value(), expected, "enum_match")
                                .unwrap();

                            // Check nested patterns in fields recursively.
                            // Skip boxed (recursive) fields — loading a boxed pointer
                            // from a wrong-variant payload would segfault since the IR
                            // runs before the branch based on tag_check.
                            let v = &variants[idx];
                            let mut combined = tag_check;
                            let has_non_trivial_nested = fields.iter().any(|p| !matches!(p, Pattern::Wildcard(_) | Pattern::Ident(_, _)));
                            if has_non_trivial_nested && !v.fields.is_empty() {
                                let field_vals = self.extract_enum_variant_fields(subject_val, subject_type, v);
                                for (i, field_pattern) in fields.iter().enumerate() {
                                    // Skip boxed fields — cannot safely dereference before branching
                                    if v.boxed_fields.contains(&i) {
                                        continue;
                                    }
                                    if let Some((field_val, field_type)) = field_vals.get(i) {
                                        if let Some(nested_check) = self.compile_pattern_check(
                                            field_pattern,
                                            field_val,
                                            field_type,
                                        ) {
                                            combined = self.builder.build_and(combined, nested_check, "nested_and").unwrap();
                                        }
                                    }
                                }
                            }
                            Some(combined)
                        } else {
                            None
                        }
                    } else {
                        None
                    }
                } else {
                    None
                }
            }
            _ => None,
        }
    }


    /// Extract all field values from an enum variant, handling boxed (recursive) fields.
    /// Returns Vec of (value, field_type) pairs.
    fn extract_enum_variant_fields(
        &mut self,
        subject_val: &BasicValueEnum<'ctx>,
        subject_type: &Type,
        v: &crate::typeck::types::EnumVariantType,
    ) -> Vec<(BasicValueEnum<'ctx>, Type)> {
        let mut results = Vec::new();
        if !subject_val.is_struct_value() || v.fields.is_empty() {
            return results;
        }

        let enum_llvm_ty = self.type_to_llvm_basic(subject_type).into_struct_type();
        let enum_alloca = self.builder.build_alloca(enum_llvm_ty, "nested_extract_tmp").unwrap();
        self.builder.build_store(enum_alloca, *subject_val).unwrap();

        let payload_ptr = self.builder.build_struct_gep(
            enum_llvm_ty, enum_alloca, 1, "payload_ptr"
        ).unwrap();

        let variant_field_types: Vec<BasicTypeEnum<'ctx>> = v.fields.iter()
            .enumerate()
            .map(|(i, (_, ty))| {
                if v.boxed_fields.contains(&i) {
                    self.context.i64_type().into()
                } else {
                    self.type_to_llvm_basic(ty)
                }
            })
            .collect();
        let variant_struct_type = self.context.struct_type(&variant_field_types, false);

        let typed_ptr = self.builder.build_bit_cast(
            payload_ptr,
            self.context.ptr_type(inkwell::AddressSpace::default()),
            "variant_ptr",
        ).unwrap().into_pointer_value();

        let variant_val = self.builder.build_load(
            variant_struct_type, typed_ptr, "variant_data"
        ).unwrap().into_struct_value();

        for (i, (_field_name, field_type)) in v.fields.iter().enumerate() {
            let field_val = self.builder.build_extract_value(
                variant_val,
                i as u32,
                &format!("field_{}", i),
            ).unwrap();

            let (final_val, final_type) = if v.boxed_fields.contains(&i) {
                let full_type = subject_type.clone();
                let full_llvm_ty = self.type_to_llvm_basic(&full_type);
                let heap_ptr = self.builder.build_int_to_ptr(
                    field_val.into_int_value(),
                    self.context.ptr_type(inkwell::AddressSpace::default()),
                    "unboxed_ptr",
                ).unwrap();
                let loaded = self.builder.build_load(
                    full_llvm_ty, heap_ptr, "unboxed_val"
                ).unwrap();
                (loaded, full_type)
            } else {
                (field_val, field_type.clone())
            };

            results.push((final_val, final_type));
        }

        results
    }

    pub(crate) fn bind_pattern_vars(
        &mut self,
        pattern: &Pattern,
        subject_val: &BasicValueEnum<'ctx>,
        subject_type: &Type,
    ) {
        match pattern {
            Pattern::Ident(name, _) => {
                let ty = subject_type.clone();
                let alloca = self.create_entry_block_alloca(&ty, name);
                self.builder.build_store(alloca, *subject_val).unwrap();
                self.define_var(name.clone(), alloca, ty);
            }
            Pattern::Enum { variant, fields, .. } => {
                if let Type::Result(ok_type, err_type) = subject_type {
                    // Result payload extraction via memory bitcast
                    if !fields.is_empty() {
                        if let Pattern::Ident(name, _) = &fields[0] {
                            let payload_type = if variant == "Ok" { ok_type.as_ref() } else { err_type.as_ref() };
                            let result_llvm_ty = self.type_to_llvm_basic(subject_type).into_struct_type();
                            let payload_llvm_ty = self.type_to_llvm_basic(payload_type);

                            // Alloca the result, store it, then GEP to payload and bitcast
                            let result_alloca = self.builder.build_alloca(result_llvm_ty, "result_tmp").unwrap();
                            self.builder.build_store(result_alloca, *subject_val).unwrap();
                            let payload_ptr = self.builder.build_struct_gep(
                                result_llvm_ty, result_alloca, 1, "payload_ptr"
                            ).unwrap();
                            let typed_ptr = self.builder.build_bit_cast(
                                payload_ptr,
                                self.context.ptr_type(inkwell::AddressSpace::default()),
                                "typed_ptr",
                            ).unwrap();
                            let payload_val = self.builder.build_load(
                                payload_llvm_ty, typed_ptr.into_pointer_value(), name
                            ).unwrap();

                            let alloca = self.create_entry_block_alloca(payload_type, name);
                            self.builder.build_store(alloca, payload_val).unwrap();
                            self.define_var(name.clone(), alloca, payload_type.clone());
                        }
                    }
                } else if let Type::Enum { variants, .. } = subject_type {
                    if let Some(v) = variants.iter().find(|v| v.name == *variant) {
                        // Extract fields and recursively bind nested patterns
                        if subject_val.is_struct_value() && !fields.is_empty() {
                            let field_vals = self.extract_enum_variant_fields(subject_val, subject_type, v);
                            for (i, field_pattern) in fields.iter().enumerate() {
                                if let Some((field_val, field_type)) = field_vals.get(i) {
                                    self.bind_pattern_vars(field_pattern, field_val, field_type);
                                }
                            }
                        }
                    }
                }
            }
            _ => {}
        }
    }
}
