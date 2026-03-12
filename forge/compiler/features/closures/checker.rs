use crate::parser::ast::*;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

impl TypeChecker {
    /// Type-check a closure expression.
    ///
    /// Opens a new scope, defines parameters with their type annotations (or Unknown),
    /// checks the body, then returns a `Type::Function` with inferred param/return types.
    pub(crate) fn check_closure(&mut self, params: &[Param], body: &Expr) -> Type {
        self.env.push_scope();
        let param_types: Vec<Type> = params
            .iter()
            .map(|p| {
                let ty = p
                    .type_ann
                    .as_ref()
                    .map(|t| self.resolve_type_expr(t))
                    .unwrap_or(Type::Unknown);
                self.env.define(p.name.clone(), ty.clone(), false);
                ty
            })
            .collect();
        let ret_type = self.check_expr(body);
        self.env.pop_scope_silent();
        Type::Function {
            params: param_types,
            return_type: Box::new(ret_type),
        }
    }
}
