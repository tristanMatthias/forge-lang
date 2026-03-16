use crate::parser::ast::{Expr, Pattern};

/// AST data for a match table expression.
#[derive(Debug, Clone)]
pub struct MatchTableData {
    pub subject: Box<Expr>,
    pub columns: Vec<String>,
    pub rows: Vec<MatchTableRow>,
}

#[derive(Debug, Clone)]
pub struct MatchTableRow {
    pub pattern: Pattern,
    pub values: Vec<Expr>,
}

impl crate::feature::FeatureNode for MatchTableData {
    fn as_any(&self) -> &dyn std::any::Any { self }
    fn clone_box(&self) -> Box<dyn crate::feature::FeatureNode> { Box::new(self.clone()) }
    fn substitute_exprs(&self, fns: &crate::feature::SubFns) -> Box<dyn crate::feature::FeatureNode> {
        Box::new(MatchTableData {
            subject: Box::new((fns.sub_expr)(&self.subject)),
            columns: self.columns.clone(),
            rows: self.rows.iter().map(|row| MatchTableRow {
                pattern: row.pattern.clone(),
                values: row.values.iter().map(|v| (fns.sub_expr)(v)).collect(),
            }).collect(),
        })
    }
}
