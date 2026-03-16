use crate::feature::FeatureStmt;
use crate::feature_stmt;
use crate::parser::ast::*;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

use super::types::SelectData;

impl TypeChecker {
    /// Type-check a select statement via the Feature dispatch system.
    pub(crate) fn check_select_feature(&mut self, fe: &FeatureStmt) {
        feature_stmt!(self, fe, SelectData, |data| self.check_select(&data.arms));
    }

    /// Type-check a `select { ... }` statement.
    ///
    /// Checks each arm's channel expression, optional guard, and body block.
    pub(crate) fn check_select(&mut self, arms: &[SelectArm]) {
        for arm in arms {
            self.check_expr(&arm.channel);
            if let Some(guard) = &arm.guard {
                self.check_expr(guard);
            }
            self.env.push_scope();
            if let Pattern::Ident(name, _) = &arm.binding {
                self.env.define(name.clone(), Type::Unknown, false);
            }
            self.check_block(&arm.body);
            self.env.pop_scope_silent();
        }
    }
}
