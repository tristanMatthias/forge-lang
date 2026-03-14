use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::feature_data;
use crate::parser::ast::Expr;
use crate::typeck::types::Type;

/// AST data for a pipe expression: `left |> right`.
#[derive(Debug, Clone)]
pub struct PipeData {
    pub left: Box<Expr>,
    pub right: Box<Expr>,
}

crate::impl_feature_node!(PipeData);

impl<'ctx> Codegen<'ctx> {
    /// Infer the return type of a pipe expression via the Feature dispatch system.
    pub(crate) fn infer_pipe_feature_type(&self, fe: &FeatureExpr) -> Type {
        if let Some(data) = feature_data!(fe, PipeData) {
            self.infer_pipe_type(&data.left, &data.right)
        } else {
            Type::Unknown
        }
    }

    /// Infer the return type of a pipe expression.
    pub(crate) fn infer_pipe_type(&self, left: &Expr, right: &Expr) -> Type {
        if let Expr::Call { callee, args, .. } = right {
            if let Expr::Ident(method_name, _) = callee.as_ref() {
                let left_type = self.infer_type(left);
                return self.infer_method_return_type(&left_type, method_name, args);
            }
        }
        let rt = self.infer_type(right);
        match &rt {
            Type::Function { return_type, .. } => *return_type.clone(),
            _ => rt,
        }
    }
}
