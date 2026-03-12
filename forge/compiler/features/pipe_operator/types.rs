use crate::codegen::codegen::Codegen;
use crate::parser::ast::*;
use crate::typeck::types::Type;

impl<'ctx> Codegen<'ctx> {
    /// Infer the return type of a pipe expression.
    ///
    /// `left |> f(args)` is treated as `left.f(args)`, so infer via method return type.
    /// `left |> f` is treated as `f(left)`, so infer via function return type.
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
