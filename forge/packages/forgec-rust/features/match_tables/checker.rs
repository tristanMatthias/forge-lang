use crate::feature::FeatureExpr;
use crate::feature_check;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

use super::types::MatchTableData;

impl TypeChecker {
    /// Type-check a match table expression via the Feature dispatch system.
    pub(crate) fn check_match_table_feature(&mut self, fe: &FeatureExpr) -> Type {
        feature_check!(self, fe, MatchTableData, |data| {
            // Check the subject expression
            self.check_expr(&data.subject);

            // Check each row's values
            let mut col_types: Vec<Type> = Vec::new();
            for row in &data.rows {
                self.env.push_scope();
                // Bind pattern variables
                self.bind_pattern(&row.pattern);

                if row.values.len() != data.columns.len() {
                    // Mismatch — will be caught, but avoid panic
                    self.env.pop_scope_silent();
                    continue;
                }

                for (i, val) in row.values.iter().enumerate() {
                    let ty = self.check_expr(val);
                    if col_types.len() <= i {
                        col_types.push(ty);
                    }
                }
                self.env.pop_scope_silent();
            }

            // Build struct type from column names + inferred types
            let fields: Vec<(String, Type)> = data.columns.iter().enumerate()
                .map(|(i, name)| {
                    let ty = col_types.get(i).cloned().unwrap_or(Type::Unknown);
                    (name.clone(), ty)
                })
                .collect();

            Type::Struct { name: None, fields }
        })
    }
}
