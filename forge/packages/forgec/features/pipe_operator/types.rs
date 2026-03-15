use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::feature_check;
use crate::parser::ast::Expr;
use crate::typeck::types::Type;

/// AST data for a pipe expression: `left |> right`.
#[derive(Debug, Clone)]
pub struct PipeData {
    pub left: Box<Expr>,
    pub right: Box<Expr>,
}

impl crate::feature::FeatureNode for PipeData {
    fn as_any(&self) -> &dyn std::any::Any { self }
    fn clone_box(&self) -> Box<dyn crate::feature::FeatureNode> { Box::new(self.clone()) }
    fn substitute_exprs(&self, fns: &crate::feature::SubFns) -> Box<dyn crate::feature::FeatureNode> {
        Box::new(PipeData {
            left: Box::new((fns.sub_expr)(&self.left)),
            right: Box::new((fns.sub_expr)(&self.right)),
        })
    }
}

impl<'ctx> Codegen<'ctx> {
    /// Infer the return type of a pipe expression via the Feature dispatch system.
    pub(crate) fn infer_pipe_feature_type(&self, fe: &FeatureExpr) -> Type {
        feature_check!(self, fe, PipeData, |data| self.infer_pipe_type(&data.left, &data.right))
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
