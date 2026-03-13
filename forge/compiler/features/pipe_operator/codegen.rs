use inkwell::values::BasicValueEnum;

use crate::codegen::codegen::Codegen;
use crate::parser::ast::*;

impl<'ctx> Codegen<'ctx> {
    /// Compile a pipe expression: `left |> right`
    ///
    /// Two forms:
    /// - `a |> f(args)` becomes `a.f(args)` (method call on piped value)
    /// - `a |> f` becomes `f(a)` (function application)
    pub(crate) fn compile_pipe(
        &mut self,
        left: &Expr,
        right: &Expr,
    ) -> Option<BasicValueEnum<'ctx>> {
        match right {
            // a |> f(args)  =>  a.f(args) (method call on piped value)
            Expr::Call { callee, args, type_args, .. } => {
                if let Expr::Ident(method_name, _) = callee.as_ref() {
                    self.compile_method_call(left, method_name, args, type_args)
                } else {
                    None
                }
            }
            // a |> f  =>  f(a) (function application)
            Expr::Ident(name, _) => {
                let arg = self.compile_expr(left)?;
                if let Some(func) = self.functions.get(name).copied() {
                    let result = self
                        .builder
                        .build_call(func, &[arg.into()], "pipe_result")
                        .unwrap();
                    result.try_as_basic_value().left()
                } else {
                    None
                }
            }
            _ => None,
        }
    }
}
