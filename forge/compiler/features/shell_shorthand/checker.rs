use crate::parser::ast::*;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

impl TypeChecker {
    /// Type-check a dollar-exec expression.
    ///
    /// Checks all interpolated expressions within the template parts.
    /// Always returns `Type::String` since dollar-exec captures stdout.
    pub(crate) fn check_dollar_exec(&mut self, parts: &[TemplatePart]) -> Type {
        for part in parts {
            if let TemplatePart::Expr(e) = part {
                self.check_expr(e);
            }
        }
        Type::String
    }
}
