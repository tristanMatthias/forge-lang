use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::feature_data;
use crate::parser::ast::{Block, Expr, Statement};
use crate::typeck::types::Type;

/// AST data for an if/else expression.
#[derive(Debug, Clone)]
pub struct IfData {
    pub condition: Box<Expr>,
    pub then_branch: Block,
    pub else_branch: Option<Block>,
}

crate::impl_feature_node!(IfData);

impl<'ctx> Codegen<'ctx> {
    /// Infer the return type of an if/else expression via the Feature dispatch system.
    pub(crate) fn infer_if_feature_type(&self, fe: &FeatureExpr) -> Type {
        if let Some(data) = feature_data!(fe, IfData) {
            self.infer_if_type(&data.then_branch, data.else_branch.as_ref())
        } else {
            Type::Unknown
        }
    }

    /// Infer the return type of an if/else expression.
    pub(crate) fn infer_if_type(&self, then_branch: &Block, else_branch: Option<&Block>) -> Type {
        let then_type = if let Some(last) = then_branch.statements.last() {
            match last {
                Statement::Expr(e) => self.infer_type(e),
                _ => Type::Void,
            }
        } else {
            Type::Void
        };
        let else_type = else_branch.and_then(|eb| {
            eb.statements.last().and_then(|s| match s {
                Statement::Expr(e) => Some(self.infer_type(e)),
                _ => None,
            })
        }).unwrap_or(Type::Void);
        // If one branch is nullable (null) and the other is not, wrap in Nullable
        let then_is_null = matches!(then_type, Type::Nullable(_));
        let else_is_null = matches!(else_type, Type::Nullable(_));
        if then_is_null && !else_is_null && else_type != Type::Void {
            Type::Nullable(Box::new(else_type))
        } else if else_is_null && !then_is_null && then_type != Type::Void {
            Type::Nullable(Box::new(then_type))
        } else {
            // Pick the more specific type when one branch is underspecified
            self.unify_branch_types(&then_type, &else_type)
        }
    }
}
