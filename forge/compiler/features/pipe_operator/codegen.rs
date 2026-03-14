use inkwell::values::BasicValueEnum;

use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::feature_data;
use crate::parser::ast::*;

use super::types::PipeData;

impl<'ctx> Codegen<'ctx> {
    /// Compile a pipe expression via the Feature dispatch system.
    pub(crate) fn compile_pipe_feature(
        &mut self,
        fe: &FeatureExpr,
    ) -> Option<BasicValueEnum<'ctx>> {
        if let Some(data) = feature_data!(fe, PipeData) {
            self.compile_pipe(&data.left, &data.right)
        } else {
            None
        }
    }

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
                } else if let Some((ptr, _ty)) = self.lookup_var(name) {
                    // Variable holding a function pointer (e.g. closure)
                    let fn_ptr_val = self.builder.build_load(
                        self.context.ptr_type(inkwell::AddressSpace::default()),
                        ptr,
                        "fn_ptr",
                    ).unwrap();
                    let fn_type = self.context.i64_type().fn_type(
                        &[self.context.i64_type().into()],
                        false,
                    );
                    let result = self.builder.build_indirect_call(
                        fn_type,
                        fn_ptr_val.into_pointer_value(),
                        &[arg.into()],
                        "pipe_closure_result",
                    ).unwrap();
                    result.try_as_basic_value().left()
                } else {
                    None
                }
            }
            _ => None,
        }
    }
}
