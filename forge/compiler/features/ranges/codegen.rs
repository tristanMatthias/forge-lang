use inkwell::values::BasicValueEnum;

use crate::codegen::codegen::Codegen;
use crate::parser::ast::*;

impl<'ctx> Codegen<'ctx> {
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
