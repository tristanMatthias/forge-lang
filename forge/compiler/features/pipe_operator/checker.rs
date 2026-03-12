use crate::parser::ast::*;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

impl TypeChecker {
    /// Type-check a pipe expression by checking both sides.
    pub(crate) fn check_pipe(&mut self, left: &Expr, right: &Expr) -> Type {
        self.check_expr(left);
        self.check_expr(right)
    }
}
