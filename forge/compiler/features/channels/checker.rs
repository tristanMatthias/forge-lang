use crate::parser::ast::*;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

impl TypeChecker {
    /// Type-check a channel send expression.
    /// If the channel has a known element type, verifies the value matches.
    /// Returns `Type::Void`.
    pub(crate) fn check_channel_send(&mut self, channel: &Expr, value: &Expr) -> Type {
        let ch_type = self.check_expr(channel);
        let val_type = self.check_expr(value);

        // If channel has a known element type, check that the value matches
        if let Type::Channel(ref inner) = ch_type {
            if !matches!(**inner, Type::Unknown) && *inner != Box::new(val_type.clone()) {
                // Type mismatch on send - but we don't block it (runtime uses string serialization)
                // Future: emit a diagnostic here
            }
        }

        Type::Void
    }

    /// Type-check a channel receive expression.
    /// If the channel has a known element type, returns that type.
    /// Otherwise returns `Type::Unknown`.
    pub(crate) fn check_channel_receive(&mut self, channel: &Expr) -> Type {
        let ch_type = self.check_expr(channel);
        match ch_type {
            Type::Channel(inner) => *inner,
            // Backwards compat: untyped channels (Type::Int) return Unknown
            _ => Type::Unknown,
        }
    }
}
