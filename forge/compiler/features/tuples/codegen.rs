use inkwell::values::BasicValueEnum;

use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::feature_data;
use crate::typeck::types::Type;

use super::types::TupleLitData;

impl<'ctx> Codegen<'ctx> {
    /// Compile a tuple literal expression via the Feature dispatch system.
    pub(crate) fn compile_tuple_lit_feature(
        &mut self,
        fe: &FeatureExpr,
    ) -> Option<BasicValueEnum<'ctx>> {
        if let Some(data) = feature_data!(fe, TupleLitData) {
            self.compile_tuple_lit(&data.elements)
        } else {
            None
        }
    }

    /// Infer the type of a tuple literal expression.
    pub(crate) fn infer_tuple_lit_feature_type(&self, fe: &FeatureExpr) -> Type {
        if let Some(data) = feature_data!(fe, TupleLitData) {
            Type::Tuple(data.elements.iter().map(|e| self.infer_type(e)).collect())
        } else {
            Type::Unknown
        }
    }
}
