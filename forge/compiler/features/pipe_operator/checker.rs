use crate::feature::FeatureExpr;
use crate::feature_data;
use crate::parser::ast::*;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

use super::types::PipeData;

impl TypeChecker {
    /// Type-check a pipe expression via the Feature dispatch system.
    pub(crate) fn check_pipe_feature(&mut self, fe: &FeatureExpr) -> Type {
        if let Some(data) = feature_data!(fe, PipeData) {
            self.check_pipe(&data.left, &data.right)
        } else {
            Type::Unknown
        }
    }

    /// Type-check a pipe expression.
    pub(crate) fn check_pipe(&mut self, left: &Expr, right: &Expr) -> Type {
        let _left_type = self.check_expr(left);

        match right {
            Expr::Call { callee, args, .. } => {
                // Check arguments
                for arg in args {
                    self.check_expr(&arg.value);
                }
                // Don't check callee as a standalone identifier — it's a method name
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
