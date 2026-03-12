use crate::parser::ast::*;
use crate::typeck::checker::TypeChecker;

impl TypeChecker {
    /// Type-check a `select { ... }` statement.
    ///
    /// Checks each arm's channel expression, optional guard, and body block.
    pub(crate) fn check_select(&mut self, arms: &[SelectArm]) {
        for arm in arms {
            self.check_expr(&arm.channel);
            if let Some(guard) = &arm.guard {
                self.check_expr(guard);
            }
            self.check_block(&arm.body);
        }
    }
}
