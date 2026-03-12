use crate::parser::ast::*;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

impl TypeChecker {
    /// Type-check a channel send expression.
    /// Checks both the channel and value expressions. Returns `Type::Void`.
    pub(crate) fn check_channel_send(&mut self, channel: &Expr, value: &Expr) -> Type {
        self.check_expr(channel);
        self.check_expr(value);
        Type::Void
    }

    /// Type-check a channel receive expression.
    /// Checks the channel expression. Returns `Type::Unknown` (received value type
    /// is not statically known since channels carry stringified values).
    pub(crate) fn check_channel_receive(&mut self, channel: &Expr) -> Type {
        self.check_expr(channel);
        Type::Unknown
    }
}
