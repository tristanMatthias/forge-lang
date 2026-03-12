use crate::parser::ast::*;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

impl TypeChecker {
    /// Type-check a range expression. The range type is Range<T> where T is the start type.
    pub(crate) fn check_range(&mut self, start: &Expr) -> Type {
        let start_type = self.check_expr(start);
        Type::Range(Box::new(start_type))
    }
}
