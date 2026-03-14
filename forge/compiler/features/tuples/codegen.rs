use inkwell::values::BasicValueEnum;

use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::{feature_codegen, feature_check};
use crate::typeck::types::Type;

use super::types::TupleLitData;

impl<'ctx> Codegen<'ctx> {
    /// Compile a tuple literal expression via the Feature dispatch system.
    pub(crate) fn compile_tuple_lit_feature(
        &mut self,
        fe: &FeatureExpr,
    ) -> Option<BasicValueEnum<'ctx>> {
        feature_codegen!(self, fe, TupleLitData, |data| self.compile_tuple_lit(&data.elements))
    }

    /// Infer the type of a tuple literal expression.
    pub(crate) fn infer_tuple_lit_feature_type(&self, fe: &FeatureExpr) -> Type {
        feature_check!(self, fe, TupleLitData, |data| {
            Type::Tuple(data.elements.iter().map(|e| self.infer_type(e)).collect())
        })
    }
}
