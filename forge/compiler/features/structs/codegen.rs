use inkwell::values::BasicValueEnum;

use crate::codegen::codegen::Codegen;
use crate::feature::{FeatureExpr, FeatureStmt};
use crate::parser::ast::Expr;
use crate::{feature_codegen, feature_check, feature_data};
use crate::typeck::types::Type;

use super::types::{StructLitData, TypeDeclData};

impl<'ctx> Codegen<'ctx> {
    pub(crate) fn compile_struct_lit(
        &mut self,
        fields: &[(String, Expr)],
    ) -> Option<BasicValueEnum<'ctx>> {
        // If we have a target type with more fields (e.g., partial structs),
        // build the struct according to the target type, filling missing nullable fields with null
        if let Some(Type::Struct { fields: target_fields, .. }) = &self.struct_target_type.clone() {
            if target_fields.len() >= fields.len() && !target_fields.is_empty() {
                let provided: std::collections::HashMap<&str, &Expr> =
                    fields.iter().map(|(n, e)| (n.as_str(), e)).collect();

                let mut all_field_types = Vec::new();
                let mut all_field_vals = Vec::new();

                for (fname, ftype) in target_fields {
                    if let Some(expr) = provided.get(fname.as_str()) {
                        // For null literals targeting nullable fields, build a properly-typed
                        // null value using the target field type (not the generic i64 fallback)
                        if matches!(expr, Expr::NullLit(_)) && matches!(ftype, Type::Nullable(_)) {
                            let llvm_ty = self.type_to_llvm_basic(ftype);
                            let null_val = llvm_ty.into_struct_type().const_zero();
                            all_field_types.push(llvm_ty);
                            all_field_vals.push(null_val.into());
                        } else {
                            let val = self.compile_expr(expr)?;
                            let ty = self.infer_type(expr);
                            // Wrap in nullable if target is nullable but value isn't
                            if matches!(ftype, Type::Nullable(_)) && !matches!(&ty, Type::Nullable(_)) {
                                let inner_llvm = val.get_type();
                                let nullable_type = self.context.struct_type(
                                    &[self.context.i8_type().into(), inner_llvm.into()],
                                    false,
                                );
                                let mut nullable_val = nullable_type.get_undef();
                                nullable_val = self.builder
                                    .build_insert_value(nullable_val, self.context.i8_type().const_int(1, false), 0, "has")
                                    .unwrap().into_struct_value();
                                nullable_val = self.builder
                                    .build_insert_value(nullable_val, val, 1, "val")
                                    .unwrap().into_struct_value();
                                all_field_types.push(self.type_to_llvm_basic(ftype));
                                all_field_vals.push(nullable_val.into());
                            } else {
                                all_field_types.push(val.get_type());
                                all_field_vals.push(val);
                            }
                        }
                    } else {
                        // Missing field — must be nullable, fill with null (tag=0)
                        let llvm_ty = self.type_to_llvm_basic(ftype);
                        let null_val = llvm_ty.into_struct_type().const_zero();
                        all_field_types.push(llvm_ty);
                        all_field_vals.push(null_val.into());
                    }
                }

                let struct_type = self.context.struct_type(
                    &all_field_types.iter().map(|t| (*t).into()).collect::<Vec<_>>(),
                    false,
                );
                let mut struct_val = struct_type.get_undef();
                for (i, val) in all_field_vals.iter().enumerate() {
                    struct_val = self.builder
                        .build_insert_value(struct_val, *val, i as u32, "field")
                        .unwrap()
                        .into_struct_value();
                }
                return Some(struct_val.into());
            }
        }

        let mut field_types = Vec::new();
        let mut field_vals = Vec::new();
        let mut type_fields = Vec::new();

        for (name, expr) in fields {
            let val = self.compile_expr(expr)?;
            let ty = self.infer_type(expr);
            // Use the actual LLVM type from the compiled value rather than the
            // inferred type. infer_type can return Type::Unknown for complex
            // expressions (e.g. static method calls like fs.filename(p) inside
            // struct literals), which maps to i64 and causes type mismatches.
            field_types.push(val.get_type());
            field_vals.push(val);
            type_fields.push((name.clone(), ty));
        }

        let struct_type = self.context.struct_type(
            &field_types.iter().map(|t| (*t).into()).collect::<Vec<_>>(),
            false,
        );

        let mut struct_val = struct_type.get_undef();
        for (i, val) in field_vals.iter().enumerate() {
            struct_val = self.builder
                .build_insert_value(struct_val, *val, i as u32, "field")
                .unwrap()
                .into_struct_value();
        }

        Some(struct_val.into())
    }

    /// Compile a struct literal expression via the Feature dispatch system.
    pub(crate) fn compile_struct_lit_feature(
        &mut self,
        fe: &FeatureExpr,
    ) -> Option<BasicValueEnum<'ctx>> {
        feature_codegen!(self, fe, StructLitData, |data| self.compile_struct_lit(&data.fields))
    }

    /// Infer the type of a struct literal expression.
    pub(crate) fn infer_struct_lit_feature_type(&self, fe: &FeatureExpr) -> Type {
        feature_check!(self, fe, StructLitData, |data| {
            if let Some(ref type_name) = data.name {
                if let Some(ty) = self.named_types.get(type_name) {
                    return ty.clone();
                }
                if let Some(ty) = self.type_checker.env.type_aliases.get(type_name) {
                    return match ty {
                        Type::Struct { fields: f, name: None } => Type::Struct {
                            name: Some(type_name.clone()),
                            fields: f.clone(),
                        },
                        other => other.clone(),
                    };
                }
            }
            let field_types: Vec<(String, Type)> = data.fields
                .iter()
                .map(|(name, expr)| (name.clone(), self.infer_type(expr)))
                .collect();
            Type::Struct {
                name: data.name.clone(),
                fields: field_types,
            }
        })
    }

    /// Handle type declaration in compile_program's first pass.
    pub(crate) fn compile_program_structs_feature(&mut self, fe: &FeatureStmt) {
        if let Some(data) = feature_data!(fe, TypeDeclData) {
            let ty = self.type_checker.resolve_type_expr(&data.value);
            let named_ty = match ty {
                Type::Struct { fields, .. } => Type::Struct {
                    name: Some(data.name.clone()),
                    fields,
                },
                other => other,
            };
            self.named_types.insert(data.name.clone(), named_ty);
        }
    }
}
