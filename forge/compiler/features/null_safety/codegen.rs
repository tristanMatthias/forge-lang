use inkwell::values::BasicValueEnum;
use inkwell::IntPredicate;

use crate::codegen::codegen::Codegen;
use crate::parser::ast::*;
use crate::typeck::types::Type;

impl<'ctx> Codegen<'ctx> {
    pub(crate) fn compile_null_coalesce(
        &mut self,
        left: &Expr,
        right: &Expr,
    ) -> Option<BasicValueEnum<'ctx>> {
        let left_type = self.infer_type(left);

        if left_type.is_nullable() {
            let left_val = self.compile_expr(left)?;
            let right_val = self.compile_expr(right)?;

            // For nullable types represented as {i8, T}, check the tag
            if left_val.is_struct_value() {
                let struct_val = left_val.into_struct_value();
                let tag = self.builder.build_extract_value(struct_val, 0, "null_tag").ok()?;
                let is_present = self.builder.build_int_compare(
                    IntPredicate::NE,
                    tag.into_int_value(),
                    self.context.i8_type().const_zero(),
                    "is_present",
                ).unwrap();

                let function = self.builder.get_insert_block().unwrap().get_parent().unwrap();
                let then_bb = self.context.append_basic_block(function, "coalesce_present");
                let else_bb = self.context.append_basic_block(function, "coalesce_null");
                let merge_bb = self.context.append_basic_block(function, "coalesce_merge");

                self.builder.build_conditional_branch(is_present, then_bb, else_bb).unwrap();

                self.builder.position_at_end(then_bb);
                let present_val = self.builder.build_extract_value(struct_val, 1, "present_val").ok()?;
                // Need to coerce present_val to match right_val type
                let present_val = self.coerce_value(present_val, right_val.get_type());
                let then_end = self.builder.get_insert_block().unwrap();
                self.builder.build_unconditional_branch(merge_bb).unwrap();

                self.builder.position_at_end(else_bb);
                let else_end = self.builder.get_insert_block().unwrap();
                self.builder.build_unconditional_branch(merge_bb).unwrap();

                self.builder.position_at_end(merge_bb);
                let phi = self.builder.build_phi(right_val.get_type(), "coalesce_result").unwrap();
                phi.add_incoming(&[
                    (&present_val, then_end),
                    (&right_val, else_end),
                ]);
                return Some(phi.as_basic_value());
            }
        }

        // Fallback: just return left or right
        let left_val = self.compile_expr(left);
        let right_val = self.compile_expr(right);
        left_val.or(right_val)
    }

    pub(crate) fn compile_null_propagate(
        &mut self,
        object: &Expr,
        field: &str,
    ) -> Option<BasicValueEnum<'ctx>> {
        let obj_type = self.infer_type(object);
        let inner_type = match &obj_type {
            Type::Nullable(inner) => inner.as_ref().clone(),
            _ => obj_type.clone(),
        };

        let obj_val = self.compile_expr(object)?;

        // Determine the field result type
        let field_result_type = match &inner_type {
            Type::String => match field {
                "length" => Type::Int,
                "upper" | "lower" => Type::String,
                _ => Type::Unknown,
            },
            Type::Struct { fields, .. } => {
                fields.iter().find(|(n, _)| n == field)
                    .map(|(_, ty)| ty.clone())
                    .unwrap_or(Type::Unknown)
            }
            _ => Type::Unknown,
        };

        let nullable_result_type = Type::Nullable(Box::new(field_result_type.clone()));
        let nullable_result_llvm = self.type_to_llvm_basic(&nullable_result_type);

        if !obj_val.is_struct_value() {
            return None;
        }

        let struct_val = obj_val.into_struct_value();
        let tag = self.builder.build_extract_value(struct_val, 0, "np_tag").ok()?;
        let is_present = self.builder.build_int_compare(
            IntPredicate::NE,
            tag.into_int_value(),
            self.context.i8_type().const_zero(),
            "np_present",
        ).unwrap();

        let function = self.builder.get_insert_block().unwrap().get_parent().unwrap();
        let then_bb = self.context.append_basic_block(function, "np_present");
        let else_bb = self.context.append_basic_block(function, "np_null");
        let merge_bb = self.context.append_basic_block(function, "np_merge");

        self.builder.build_conditional_branch(is_present, then_bb, else_bb).unwrap();

        // Present path: extract inner value and access field
        self.builder.position_at_end(then_bb);
        let inner_val = self.builder.build_extract_value(struct_val, 1, "np_inner").ok()?;

        let field_val = match &inner_type {
            Type::String => match field {
                "length" => {
                    let len_fn = self.module.get_function("forge_string_length").unwrap();
                    let result = self.builder.build_call(len_fn, &[inner_val.into()], "len").unwrap();
                    result.try_as_basic_value().left()
                }
                "upper" => {
                    let upper_fn = self.module.get_function("forge_string_upper").unwrap();
                    let result = self.builder.build_call(upper_fn, &[inner_val.into()], "upper").unwrap();
                    result.try_as_basic_value().left()
                }
                "lower" => {
                    let lower_fn = self.module.get_function("forge_string_lower").unwrap();
                    let result = self.builder.build_call(lower_fn, &[inner_val.into()], "lower").unwrap();
                    result.try_as_basic_value().left()
                }
                _ => None,
            },
            Type::Struct { fields, .. } => {
                if let Some(idx) = fields.iter().position(|(n, _)| n == field) {
                    if inner_val.is_struct_value() {
                        self.builder.build_extract_value(inner_val.into_struct_value(), idx as u32, field).ok()
                    } else {
                        None
                    }
                } else {
                    None
                }
            }
            _ => None,
        };

        let field_val = field_val?;

        // Wrap field_val in nullable
        let present_result = self.wrap_in_nullable(field_val, &nullable_result_type);
        let then_end = self.builder.get_insert_block().unwrap();
        self.builder.build_unconditional_branch(merge_bb).unwrap();

        // Null path: return null
        self.builder.position_at_end(else_bb);
        let null_result = self.create_null_value(&nullable_result_type);
        let else_end = self.builder.get_insert_block().unwrap();
        self.builder.build_unconditional_branch(merge_bb).unwrap();

        // Merge
        self.builder.position_at_end(merge_bb);
        let phi = self.builder.build_phi(nullable_result_llvm, "np_result").unwrap();
        phi.add_incoming(&[(&present_result, then_end), (&null_result, else_end)]);
        Some(phi.as_basic_value())
    }

    pub(crate) fn wrap_in_nullable(&mut self, val: BasicValueEnum<'ctx>, nullable_ty: &Type) -> BasicValueEnum<'ctx> {
        let nullable_llvm_ty = self.type_to_llvm_basic(nullable_ty);
        let alloca = self.builder.build_alloca(nullable_llvm_ty, "nullable_wrap").unwrap();
        let struct_ty = nullable_llvm_ty.into_struct_type();

        // Store tag = 1 (present)
        let tag_ptr = self.builder.build_struct_gep(struct_ty, alloca, 0, "tag_ptr").unwrap();
        self.builder.build_store(tag_ptr, self.context.i8_type().const_int(1, false)).unwrap();

        // Store value
        let val_ptr = self.builder.build_struct_gep(struct_ty, alloca, 1, "val_ptr").unwrap();
        // Coerce the value if needed to match the inner type
        let inner_ty = match nullable_ty {
            Type::Nullable(inner) => self.type_to_llvm_basic(inner),
            _ => val.get_type(),
        };
        let coerced = self.coerce_value(val, inner_ty);
        self.builder.build_store(val_ptr, coerced).unwrap();

        // Load the full struct
        self.builder.build_load(nullable_llvm_ty, alloca, "nullable_val").unwrap()
    }

    /// Create a null nullable value of the given nullable type
    pub(crate) fn create_null_value(&mut self, nullable_ty: &Type) -> BasicValueEnum<'ctx> {
        let nullable_llvm_ty = self.type_to_llvm_basic(nullable_ty);
        nullable_llvm_ty.into_struct_type().const_zero().into()
    }

    /// Detect if a condition is `name != null` and return (name, inner_type) for narrowing
    pub(crate) fn detect_null_check(&self, condition: &Expr) -> Option<(String, Type)> {
        if let Expr::Binary { left, op, right, .. } = condition {
            if matches!(op, BinaryOp::NotEq) {
                // Check: left is ident, right is null
                if let (Expr::Ident(name, _), Expr::NullLit(_)) = (left.as_ref(), right.as_ref()) {
                    let ty = self.infer_type(left);
                    if let Type::Nullable(inner) = ty {
                        return Some((name.clone(), *inner));
                    }
                }
                // Check: left is null, right is ident
                if let (Expr::NullLit(_), Expr::Ident(name, _)) = (left.as_ref(), right.as_ref()) {
                    let ty = self.infer_type(right);
                    if let Type::Nullable(inner) = ty {
                        return Some((name.clone(), *inner));
                    }
                }
            }
        }
        None
    }

    pub(crate) fn infer_if_branch_type(&self, block: &Block) -> Type {
        self.infer_if_branch_type_block(block)
    }

    pub(crate) fn infer_if_branch_type_block(&self, block: &Block) -> Type {
        if let Some(last) = block.statements.last() {
            match last {
                Statement::Expr(e) => self.infer_type(e),
                _ => Type::Void,
            }
        } else {
            Type::Void
        }
    }
}
