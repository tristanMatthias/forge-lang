use crate::feature::FeatureExpr;
use crate::feature_check;
use crate::parser::ast::*;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

use super::types::DollarExecData;

impl TypeChecker {
    /// Type-check a dollar-exec expression via Feature dispatch.
    pub(crate) fn check_dollar_exec_feature(&mut self, fe: &FeatureExpr) -> Type {
        feature_check!(self, fe, DollarExecData, |data| self.check_dollar_exec(&data.parts))
    }

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
