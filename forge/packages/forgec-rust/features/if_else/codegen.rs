use inkwell::values::BasicValueEnum;

use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::feature_codegen;

use super::types::IfData;

impl<'ctx> Codegen<'ctx> {
    /// Compile an if/else expression via the Feature dispatch system.
    pub(crate) fn compile_if_feature(
        &mut self,
        fe: &FeatureExpr,
    ) -> Option<BasicValueEnum<'ctx>> {
        feature_codegen!(self, fe, IfData, |data| self.compile_if(&data.condition, &data.then_branch, data.else_branch.as_ref()))
    }
}
