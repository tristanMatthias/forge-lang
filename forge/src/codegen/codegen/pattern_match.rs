use super::*;

impl<'ctx> Codegen<'ctx> {
    pub(crate) fn compile_match(
        &mut self,
        subject: &Expr,
        arms: &[MatchArm],
    ) -> Option<BasicValueEnum<'ctx>> {
        let subject_val = self.compile_expr(subject)?;
        let subject_type = self.infer_type(subject);

        let function = self.builder.get_insert_block().unwrap().get_parent().unwrap();
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
                } else {
                    None
                }
            }
            Pattern::Enum { variant, .. } => {
                // Check the tag of the enum
                if let Type::Enum { variants, .. } = subject_type {
                    if let Some(idx) = variants.iter().position(|v| v.name == *variant) {
                        if subject_val.is_struct_value() {
                            let struct_val = subject_val.into_struct_value();
                            let tag = self.builder.build_extract_value(struct_val, 0, "tag").ok()?;
                            let expected = self.context.i8_type().const_int(idx as u64, false);
                            Some(
                                self.builder
                                    .build_int_compare(IntPredicate::EQ, tag.into_int_value(), expected, "enum_match")
                                    .unwrap(),
                            )
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
                if let Type::Enum { variants, .. } = subject_type {
                    if let Some(v) = variants.iter().find(|v| v.name == *variant) {
                        // Extract fields from the enum struct
                        if subject_val.is_struct_value() {
                            let struct_val = subject_val.into_struct_value();
                            for (i, (field_pattern, (field_name, field_type))) in
                                fields.iter().zip(v.fields.iter()).enumerate()
                            {
                                if let Pattern::Ident(name, _) = field_pattern {
                                    // Field data starts at index 1 (after tag)
                                    if let Some(field_val) = self.builder.build_extract_value(
                                        struct_val,
                                        (i + 1) as u32,
                                        &name,
                                    ).ok() {
                                        let alloca = self.create_entry_block_alloca(field_type, name);
                                        self.builder.build_store(alloca, field_val).unwrap();
                                        self.define_var(name.clone(), alloca, field_type.clone());
                                    }
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
