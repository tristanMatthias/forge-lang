use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::feature_check;
use crate::parser::ast::Expr;
use crate::typeck::types::Type;

/// AST data for a table literal: `table { col1 | col2 \n val1 | val2 }`
#[derive(Debug, Clone)]
pub struct TableLitData {
    pub columns: Vec<String>,
    pub rows: Vec<Vec<Expr>>,
}

impl crate::feature::FeatureNode for TableLitData {
    fn as_any(&self) -> &dyn std::any::Any { self }
    fn clone_box(&self) -> Box<dyn crate::feature::FeatureNode> { Box::new(self.clone()) }
    fn substitute_exprs(&self, fns: &crate::feature::SubFns) -> Box<dyn crate::feature::FeatureNode> {
        Box::new(TableLitData {
            columns: self.columns.clone(),
            rows: self.rows.iter().map(|row| row.iter().map(|e| (fns.sub_expr)(e)).collect()).collect(),
        })
    }
}

impl<'ctx> Codegen<'ctx> {
    /// Infer the type of a table literal via Feature dispatch.
    pub(crate) fn infer_table_lit_feature_type(&self, fe: &FeatureExpr) -> Type {
        feature_check!(self, fe, TableLitData, |data| {
            let fields: Vec<(String, Type)> = if let Some(first_row) = data.rows.first() {
                data.columns.iter().zip(first_row.iter())
                    .map(|(name, expr)| (name.clone(), self.infer_type(expr)))
                    .collect()
            } else {
                data.columns.iter().map(|n| (n.clone(), Type::Unknown)).collect()
            };
            Type::List(Box::new(Type::Struct { name: None, fields }))
        })
    }
}
