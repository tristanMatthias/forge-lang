use inkwell::values::BasicValueEnum;

use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::feature_data;

use super::types::IfData;

impl<'ctx> Codegen<'ctx> {
    /// Compile an if/else expression via the Feature dispatch system.
    pub(crate) fn compile_if_feature(
        &mut self,
        fe: &FeatureExpr,
    ) -> Option<BasicValueEnum<'ctx>> {
        if let Some(data) = feature_data!(fe, IfData) {
            self.compile_if(&data.condition, &data.then_branch, data.else_branch.as_ref())
        } else {
            None
        }
    }
}
