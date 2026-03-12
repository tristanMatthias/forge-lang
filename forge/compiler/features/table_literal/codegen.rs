use crate::codegen::codegen::Codegen;
use crate::parser::ast::Expr;
use crate::lexer::Span;
use inkwell::values::BasicValueEnum;

impl<'ctx> Codegen<'ctx> {
    /// Compile a table literal by desugaring into a list of struct literals.
    pub(crate) fn compile_table_lit(
        &mut self,
        columns: &[String],
        rows: &[Vec<Expr>],
        span: &Span,
    ) -> Option<BasicValueEnum<'ctx>> {
        // Desugar each row into a StructLit, then compile as ListLit
        let elements: Vec<Expr> = rows
            .iter()
            .map(|row| {
                let fields: Vec<(String, Expr)> = columns
                    .iter()
                    .zip(row.iter())
                    .map(|(name, val)| (name.clone(), val.clone()))
                    .collect();
                Expr::StructLit {
                    name: None,
                    fields,
                    span: *span,
                }
            })
            .collect();

        self.compile_list_lit(&elements)
    }
}
