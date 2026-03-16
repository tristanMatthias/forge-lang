use inkwell::values::BasicValueEnum;

use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::feature_check;
use crate::feature_codegen;
use crate::parser::ast::*;
use crate::typeck::types::Type;

use super::types::MatchTableData;

impl<'ctx> Codegen<'ctx> {
    /// Compile a match table by desugaring to a regular match expression.
    /// Each row becomes a match arm that returns a struct literal.
    pub(crate) fn compile_match_table_feature(
        &mut self,
        fe: &FeatureExpr,
    ) -> Option<BasicValueEnum<'ctx>> {
        feature_codegen!(self, fe, MatchTableData, |data| {
            // Desugar: build match arms where each arm body is a struct literal
            let arms: Vec<MatchArm> = data.rows.iter().map(|row| {
                // Build struct literal fields from column names + row values
                let fields: Vec<(String, Expr)> = data.columns.iter()
                    .zip(row.values.iter())
                    .map(|(col, val)| (col.clone(), val.clone()))
                    .collect();

                let body = feature_expr(
                    "structs",
                    "StructLit",
                    Box::new(crate::features::structs::types::StructLitData {
                        name: None,
                        fields,
                        span: fe.span,
                    }),
                    fe.span,
                );

                MatchArm {
                    pattern: row.pattern.clone(),
                    guard: None,
                    body,
                    span: fe.span,
                }
            }).collect();

            self.compile_match(&data.subject, &arms)
        })
    }

    /// Infer the return type of a match table expression.
    pub(crate) fn infer_match_table_feature_type(&self, fe: &FeatureExpr) -> Type {
        feature_check!(self, fe, MatchTableData, |data| {
            let fields: Vec<(String, Type)> = data.columns.iter()
                .enumerate()
                .map(|(i, name)| {
                    // Infer from the first row's values
                    let ty = if let Some(first_row) = data.rows.first() {
                        if let Some(val) = first_row.values.get(i) {
                            self.infer_type(val)
                        } else {
                            Type::Unknown
                        }
                    } else {
                        Type::Unknown
                    };
                    (name.clone(), ty)
                })
                .collect();
            Type::Struct { name: None, fields }
        })
    }
}
