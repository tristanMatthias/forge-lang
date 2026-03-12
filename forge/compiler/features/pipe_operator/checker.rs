use crate::parser::ast::*;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

impl TypeChecker {
    /// Type-check a pipe expression.
    /// `x |> method(args)` desugars to `x.method(args)` at codegen, so the right side's
    /// callee may be a method name, not a standalone function. We check the left side
    /// and then check the right side tolerantly — if the callee is an unknown identifier
    /// that looks like a method call, we allow it rather than errecting an error.
    pub(crate) fn check_pipe(&mut self, left: &Expr, right: &Expr) -> Type {
        let _left_type = self.check_expr(left);

        // For `x |> method(args)`, the right side is Call { callee: Ident("method"), args }.
        // The method name isn't a standalone function — it's a method on the left value.
        // Check args but don't error on the callee if it's an unknown ident.
        match right {
            Expr::Call { callee, args, .. } => {
                // Check arguments
                for arg in args {
                    self.check_expr(&arg.value);
                }
                // Don't check callee as a standalone identifier — it's a method name
                // Just return Unknown since we can't easily resolve method return types
                if let Expr::Ident(name, _) = callee.as_ref() {
                    // If it's a known function, use its return type
                    if let Some(fn_type) = self.env.lookup_function(name).cloned() {
                        if let Type::Function { return_type, .. } = fn_type {
                            return *return_type;
                        }
                    }
                }
                Type::Unknown
            }
            _ => self.check_expr(right),
        }
    }
}
