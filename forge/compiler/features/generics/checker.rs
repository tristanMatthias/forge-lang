use crate::parser::ast::*;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

impl TypeChecker {
    /// Check a generic function declaration.
    ///
    /// Generic functions are currently checked like regular functions:
    /// their body is type-checked with type parameters treated as Unknown.
    /// The checker registers the function signature in the environment
    /// (handled in the main `check_statement` for FnDecl).
    ///
    /// Future work: check trait bounds on type parameters, verify
    /// constraints are satisfied at call sites.
    pub(crate) fn check_generic_fn_decl(
        &mut self,
        _name: &str,
        _type_params: &[TypeParam],
        params: &[Param],
        return_type: &Option<TypeExpr>,
        body: &Block,
    ) {
        self.env.push_scope();

        let ret_type = return_type
            .as_ref()
            .map(|t| self.resolve_type_expr(t))
            .unwrap_or(Type::Void);

        let old_return = self.current_fn_return_type.take();
        self.current_fn_return_type = Some(ret_type);

        for param in params {
            let ty = param
                .type_ann
                .as_ref()
                .map(|t| self.resolve_type_expr(t))
                .unwrap_or(Type::Unknown);
            self.env.define(param.name.clone(), ty, false);
        }

        self.check_block(body);

        self.current_fn_return_type = old_return;
        self.env.pop_scope_silent();
    }
}
