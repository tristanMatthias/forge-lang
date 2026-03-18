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
                                let target_llvm = self.type_to_llvm_basic(ftype);
                                if val.get_type() != target_llvm {
                                    // Value type doesn't match target — coerce
                                    let coerced = self.coerce_value(val, target_llvm);
                                    all_field_types.push(target_llvm);
                                    all_field_vals.push(coerced);
                                } else {
                                    all_field_types.push(target_llvm);
                                    all_field_vals.push(val);
                                }
                            }
                        }
                    } else {
                        // Missing field — fill with zero value
                        let llvm_ty = self.type_to_llvm_basic(ftype);
                        let zero_val = if llvm_ty.is_struct_type() {
                            llvm_ty.into_struct_type().const_zero().into()
                        } else if llvm_ty.is_int_type() {
                            llvm_ty.into_int_type().const_zero().into()
                        } else if llvm_ty.is_float_type() {
                            llvm_ty.into_float_type().const_zero().into()
                        } else if llvm_ty.is_pointer_type() {
                            llvm_ty.into_pointer_type().const_null().into()
                        } else {
                            llvm_ty.into_struct_type().const_zero().into()
                        };
                        all_field_types.push(llvm_ty);
                        all_field_vals.push(zero_val);
                    }
                }

                // Use named struct type if the target type has a name
                let struct_type = if let Some(Type::Struct { name: Some(n), .. }) = &self.struct_target_type {
                    self.context.get_struct_type(n).unwrap_or_else(|| {
                        self.context.struct_type(
                            &all_field_types.iter().map(|t| (*t).into()).collect::<Vec<_>>(),
                            false,
                        )
                    })
                } else {
                    self.context.struct_type(
                        &all_field_types.iter().map(|t| (*t).into()).collect::<Vec<_>>(),
                        false,
                    )
                };
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

        // Try to use the current function's return type for field type resolution
        // This ensures enum fields use the canonical (full-size) type, not narrow types
        let return_struct_fields: Option<Vec<(String, Type)>> = self.current_fn_return_type.as_ref()
            .and_then(|t| match t {
                Type::Struct { fields: f, .. } => Some(f.clone()),
                Type::Nullable(inner) => match inner.as_ref() {
                    Type::Struct { fields: f, .. } => Some(f.clone()),
                    _ => None,
                },
                _ => None,
            });

        for (name, expr) in fields {
            let val = self.compile_expr(expr)?;
            let ty = self.infer_type(expr);

            // If we have a target struct type, use its field type for LLVM
            let llvm_ty = if let Some(ref target_fields) = return_struct_fields {
                if let Some((_, ftype)) = target_fields.iter().find(|(n, _)| n == name) {
                    let target_llvm = self.type_to_llvm_basic(ftype);
                    if val.get_type() != target_llvm {
                        field_vals.push(self.coerce_value(val, target_llvm));
                        field_types.push(target_llvm);
                        type_fields.push((name.clone(), ty));
                        continue;
                    }
                    target_llvm
                } else {
                    val.get_type()
                }
            } else {
                val.get_type()
            };

            field_types.push(llvm_ty);
            field_vals.push(val);
            type_fields.push((name.clone(), ty));
        }

        // Build struct type — try to match a named LLVM struct from the type system
        let struct_type = {
            let type_fields_ty = Type::Struct {
                name: None,
                fields: type_fields.clone(),
            };
            // Check if the return type or target type has a matching named struct
            let named_type = self.current_fn_return_type.as_ref()
                .and_then(|rt| match rt {
                    Type::Struct { name: Some(n), .. } => self.context.get_struct_type(n),
                    Type::Nullable(inner) => match inner.as_ref() {
                        Type::Struct { name: Some(n), .. } => self.context.get_struct_type(n),
                        _ => None,
                    },
                    _ => None,
                })
                .or_else(|| self.struct_target_type.as_ref().and_then(|st| match st {
                    Type::Struct { name: Some(n), .. } => self.context.get_struct_type(n),
                    _ => None,
                }));
            if let Some(named) = named_type {
                if named.count_fields() == field_types.len() as u32 {
                    named
                } else {
                    self.context.struct_type(
                        &field_types.iter().map(|t| (*t).into()).collect::<Vec<_>>(),
                        false,
                    )
                }
            } else {
                self.context.struct_type(
                    &field_types.iter().map(|t| (*t).into()).collect::<Vec<_>>(),
                    false,
                )
            }
        };

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
        feature_codegen!(self, fe, StructLitData, |data| {
            // Set struct_target_type from the struct name so the literal
            // uses the named LLVM type (e.g., %FeatureStmt not anonymous)
            if let Some(ref name) = data.name {
                if let Some(ty) = self.type_checker.env.type_aliases.get(name).cloned() {
                    let prev = self.struct_target_type.take();
                    self.struct_target_type = Some(match ty {
                        Type::Struct { fields, name: None } => Type::Struct {
                            name: Some(name.clone()),
                            fields,
                        },
                        other => other,
                    });
                    let result = self.compile_struct_lit(&data.fields);
                    self.struct_target_type = prev;
                    return result;
                }
            }
            self.compile_struct_lit(&data.fields)
        })
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
