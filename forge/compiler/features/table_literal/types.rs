use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::feature_data;
use crate::parser::ast::Expr;
use crate::typeck::types::Type;

/// AST data for a table literal: `table { col1 | col2 \n val1 | val2 }`
#[derive(Debug, Clone)]
pub struct TableLitData {
    pub columns: Vec<String>,
    pub rows: Vec<Vec<Expr>>,
}

crate::impl_feature_node!(TableLitData);

impl<'ctx> Codegen<'ctx> {
    /// Infer the type of a table literal via Feature dispatch.
    pub(crate) fn infer_table_lit_feature_type(&self, fe: &FeatureExpr) -> Type {
        if let Some(data) = feature_data!(fe, TableLitData) {
            let fields: Vec<(String, Type)> = if let Some(first_row) = data.rows.first() {
                data.columns.iter().zip(first_row.iter())
                    .map(|(name, expr)| (name.clone(), self.infer_type(expr)))
                    .collect()
            } else {
                data.columns.iter().map(|n| (n.clone(), Type::Unknown)).collect()
            };
            Type::List(Box::new(Type::Struct { name: None, fields }))
        } else {
            Type::Unknown
        }
    }
}
