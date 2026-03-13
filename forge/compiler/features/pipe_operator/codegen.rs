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
            // a |> f(args)  =>  f(a, args) if f is a known function, else a.f(args)
            Expr::Call { callee, args, type_args, .. } => {
                if let Expr::Ident(name, _) = callee.as_ref() {
                    // If it's a known function, pipe as first argument: f(a, extra_args...)
                    if let Some(func) = self.functions.get(name).copied() {
                        let piped = self.compile_expr(left)?;
                        let mut compiled_args: Vec<inkwell::values::BasicMetadataValueEnum<'ctx>> =
                            vec![piped.into()];
                        for arg in args {
                            let val = self.compile_expr(&arg.value)?;
                            compiled_args.push(val.into());
                        }
                        let result = self
                            .builder
                            .build_call(func, &compiled_args, "pipe_result")
                            .unwrap();
                        result.try_as_basic_value().left()
                    } else {
                        // Not a known function — try as method call on the piped value
                        self.compile_method_call(left, name, args, type_args)
                    }
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
