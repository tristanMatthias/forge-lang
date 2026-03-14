use inkwell::values::BasicValueEnum;

use crate::codegen::codegen::Codegen;
use crate::feature::{FeatureExpr, FeatureStmt};
use crate::{feature_codegen, feature_check, feature_data};
use crate::typeck::types::Type;

use super::types::{StructLitData, TypeDeclData};

impl<'ctx> Codegen<'ctx> {
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
