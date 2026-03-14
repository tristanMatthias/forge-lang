use inkwell::values::BasicValueEnum;

use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::feature_data;
use crate::parser::ast::*;

use super::types::RangeData;

impl<'ctx> Codegen<'ctx> {
    /// Compile a range expression via the Feature dispatch system.
    pub(crate) fn compile_range_feature(
        &mut self,
        fe: &FeatureExpr,
    ) -> Option<BasicValueEnum<'ctx>> {
        if let Some(data) = feature_data!(fe, RangeData) {
            self.compile_range(&data.start, &data.end, data.inclusive)
        } else {
            None
        }
    }

    /// Compile a range expression.
    /// Ranges are primarily used in for loops, not as standalone values.
    /// The for loop handles range compilation directly by matching on Expr::Range.
    pub(crate) fn compile_range(
        &mut self,
        start: &Expr,
        end: &Expr,
        _inclusive: bool,
    ) -> Option<BasicValueEnum<'ctx>> {
        // Ranges are used in for loops, not as values typically
        // Store start and end for the for loop to pick up
        let _start_val = self.compile_expr(start)?;
        let _end_val = self.compile_expr(end)?;
        None
    }
}
