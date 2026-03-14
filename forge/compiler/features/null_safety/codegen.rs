use inkwell::values::BasicValueEnum;

use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::{feature_codegen, feature_data};
use crate::parser::ast::*;
use crate::typeck::types::Type;

use super::types::{NullCoalesceData, NullPropagateData, ForceUnwrapData};

impl<'ctx> Codegen<'ctx> {
    /// Compile a null coalesce expression via Feature dispatch.
    pub(crate) fn compile_null_coalesce_feature(
        &mut self,
        fe: &FeatureExpr,
    ) -> Option<BasicValueEnum<'ctx>> {
        feature_codegen!(self, fe, NullCoalesceData, |data| self.compile_null_coalesce(&data.left, &data.right))
    }

    /// Compile a null propagate expression via Feature dispatch.
    pub(crate) fn compile_null_propagate_feature(
        &mut self,
        fe: &FeatureExpr,
    ) -> Option<BasicValueEnum<'ctx>> {
        feature_codegen!(self, fe, NullPropagateData, |data| self.compile_null_propagate(&data.object, &data.field))
    }

    /// Compile a force unwrap expression via Feature dispatch: `expr!`
    pub(crate) fn compile_force_unwrap_feature(
        &mut self,
        fe: &FeatureExpr,
    ) -> Option<BasicValueEnum<'ctx>> {
        if let Some(data) = feature_data!(fe, ForceUnwrapData) {
            let operand_type = self.infer_type(&data.operand);
            let val = self.compile_expr(&data.operand)?;

            if let Type::Nullable(inner) = &operand_type {
                if val.is_struct_value() {
                    // Nullable is {i8 tag, T value} - just extract the value
                    let struct_val = val.into_struct_value();
                    let inner_val = self.extract_tagged_payload(struct_val, "force_unwrap")?;
                    // May need to coerce to the expected inner type
                    let inner_llvm = self.type_to_llvm_basic(inner);
                    if inner_val.get_type() != inner_llvm {
                        Some(self.coerce_value(inner_val, inner_llvm))
                    } else {
                        Some(inner_val)
                    }
                } else {
                    Some(val)
                }
            } else {
                // Not nullable, just pass through
                Some(val)
            }
        } else {
            None
        }
    }

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
                let is_present = self.extract_tag_is_set(struct_val, "null")?;

                let function = self.builder.get_insert_block().unwrap().get_parent().unwrap();
                let then_bb = self.context.append_basic_block(function, "coalesce_present");
                let else_bb = self.context.append_basic_block(function, "coalesce_null");
                let merge_bb = self.context.append_basic_block(function, "coalesce_merge");

                self.builder.build_conditional_branch(is_present, then_bb, else_bb).unwrap();

                self.builder.position_at_end(then_bb);
                let present_val = self.extract_tagged_payload(struct_val, "present")?;
                // If right side is nullable, wrap present_val in nullable to match
                let right_type = self.infer_type(right);
                let present_val = if right_type.is_nullable() && present_val.get_type() != right_val.get_type() {
                    self.wrap_in_nullable(present_val, &right_type)
                } else {
                    self.coerce_value(present_val, right_val.get_type())
                };
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
        let is_present = self.extract_tag_is_set(struct_val, "np")?;

        let function = self.builder.get_insert_block().unwrap().get_parent().unwrap();
        let then_bb = self.context.append_basic_block(function, "np_present");
        let else_bb = self.context.append_basic_block(function, "np_null");
        let merge_bb = self.context.append_basic_block(function, "np_merge");

        self.builder.build_conditional_branch(is_present, then_bb, else_bb).unwrap();

        // Present path: extract inner value and access field
        self.builder.position_at_end(then_bb);
        let inner_val = self.extract_tagged_payload(struct_val, "np")?;

        let field_val = match &inner_type {
            Type::String => match field {
                "length" => self.call_runtime("forge_string_length", &[inner_val.into()], "len"),
                "upper" => self.call_runtime("forge_string_upper", &[inner_val.into()], "upper"),
                "lower" => self.call_runtime("forge_string_lower", &[inner_val.into()], "lower"),
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

    /// If the declared type is nullable but the value isn't already the correct nullable struct,
    /// wrap or re-create appropriately.
    /// - Non-nullable value → wrap with tag=1 (present)
    /// - Null with wrong inner type → create properly-typed null with tag=0
    pub(crate) fn maybe_wrap_nullable(&mut self, val: BasicValueEnum<'ctx>, ty: &Type) -> BasicValueEnum<'ctx> {
        if let Type::Nullable(_) = ty {
            let expected_llvm = self.type_to_llvm_basic(ty);
            if val.get_type() != expected_llvm {
                // Check if this is a null value (a nullable struct with tag=0).
                // Null literals compile to const_zero struct of {i8, i64} regardless of target type.
                // If the value is a struct with 2 fields and the first is i8, assume it's a nullable
                // and check if it's const_zero (null). If so, recreate with the correct target type.
                if val.is_struct_value() {
                    let sv = val.into_struct_value();
                    if sv.is_const() && sv.get_type().count_fields() == 2 {
                        // Likely a null literal with wrong inner type — recreate
                        return self.create_null_value(ty);
                    }
                }
                return self.wrap_in_nullable(val, ty);
            }
        }
        val
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
