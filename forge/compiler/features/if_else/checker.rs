use crate::feature::FeatureExpr;
use crate::feature_data;
use crate::parser::ast::*;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

use super::types::IfData;

impl TypeChecker {
    /// Type-check an if/else expression via the Feature dispatch system.
    pub(crate) fn check_if_feature(&mut self, fe: &FeatureExpr) -> Type {
        if let Some(data) = feature_data!(fe, IfData) {
            self.check_if_expr_impl(&data.condition, &data.then_branch, data.else_branch.as_ref())
        } else {
            Type::Unknown
        }
    }

    /// Type-check an if/else expression.
    pub(crate) fn check_if_expr_impl(
        &mut self,
        condition: &Expr,
        then_branch: &Block,
        else_branch: Option<&Block>,
    ) -> Type {
        self.check_expr(condition);
        self.env.push_scope();
        let then_type = self.check_block_type(then_branch);
        self.env.pop_scope_silent();
        if let Some(else_b) = else_branch {
            self.env.push_scope();
            let _else_type = self.check_block_type(else_b);
            self.env.pop_scope_silent();
        }
        then_type
    }
}
