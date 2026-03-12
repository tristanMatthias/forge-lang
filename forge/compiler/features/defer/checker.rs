use crate::parser::ast::*;
use crate::typeck::checker::TypeChecker;

impl TypeChecker {
    /// Type-check a `defer` statement by checking its body expression.
    pub(crate) fn check_defer(&mut self, body: &Expr) {
        self.check_expr(body);
    }
}
