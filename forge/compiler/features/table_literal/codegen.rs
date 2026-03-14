use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::feature_data;
use crate::parser::ast::Expr;
use crate::lexer::Span;
use inkwell::values::BasicValueEnum;

use super::types::TableLitData;

impl<'ctx> Codegen<'ctx> {
    /// Compile a table literal via Feature dispatch.
    pub(crate) fn compile_table_lit_feature(
        &mut self,
        fe: &FeatureExpr,
    ) -> Option<BasicValueEnum<'ctx>> {
        if let Some(data) = feature_data!(fe, TableLitData) {
            self.compile_table_lit(&data.columns, &data.rows, &fe.span)
        } else {
            None
        }
    }

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
