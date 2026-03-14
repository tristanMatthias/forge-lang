use inkwell::values::BasicValueEnum;

use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::feature_data;
use crate::typeck::types::Type;

use super::types::{ListLitData, MapLitData};

impl<'ctx> Codegen<'ctx> {
    /// Compile a list literal expression via the Feature dispatch system.
    pub(crate) fn compile_list_lit_feature(
        &mut self,
        fe: &FeatureExpr,
    ) -> Option<BasicValueEnum<'ctx>> {
        if let Some(data) = feature_data!(fe, ListLitData) {
            self.compile_list_lit(&data.elements)
        } else {
            None
        }
    }

    /// Compile a map literal expression via the Feature dispatch system.
    pub(crate) fn compile_map_lit_feature(
        &mut self,
        fe: &FeatureExpr,
    ) -> Option<BasicValueEnum<'ctx>> {
        if let Some(data) = feature_data!(fe, MapLitData) {
            self.compile_map_lit(&data.entries)
        } else {
            None
        }
    }

    /// Infer the type of a list literal expression.
    pub(crate) fn infer_list_lit_feature_type(&self, fe: &FeatureExpr) -> Type {
        if let Some(data) = feature_data!(fe, ListLitData) {
            let elem_type = if let Some(first) = data.elements.first() {
                self.infer_type(first)
            } else {
                Type::Unknown
            };
            Type::List(Box::new(elem_type))
        } else {
            Type::Unknown
        }
    }

    /// Infer the type of a map literal expression.
    pub(crate) fn infer_map_lit_feature_type(&self, fe: &FeatureExpr) -> Type {
        if let Some(data) = feature_data!(fe, MapLitData) {
            let (key_type, val_type) = if let Some((k, v)) = data.entries.first() {
                (self.infer_type(k), self.infer_type(v))
            } else {
                (Type::Unknown, Type::Unknown)
            };
            Type::Map(Box::new(key_type), Box::new(val_type))
        } else {
            Type::Unknown
        }
    }
}
