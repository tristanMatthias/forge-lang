use crate::codegen::codegen::Codegen;
use crate::feature::FeatureStmt;
use crate::feature_stmt;

use super::types::DeferData;

impl<'ctx> Codegen<'ctx> {
    /// Compile a `defer` statement by saving the expression for later execution.
    ///
    /// The deferred expression is pushed onto `self.deferred_stmts` and will be
    /// compiled in reverse order before function returns (both explicit `return`
    /// statements and implicit returns at the end of `compile_fn`).
    pub(crate) fn compile_defer_feature(&mut self, fe: &FeatureStmt) {
        feature_stmt!(self, fe, DeferData, |data| self.deferred_stmts.push(data.body.clone()));
    }

    /// Execute all deferred statements in reverse order.
    ///
    /// Called before returning from a function (both explicit returns and
    /// implicit returns). Each deferred expression is compiled in LIFO order.
    pub(crate) fn execute_deferred_stmts(&mut self) {
        let deferred = self.deferred_stmts.clone();
        for d in deferred.iter().rev() {
            self.compile_expr(d);
        }
    }
}
