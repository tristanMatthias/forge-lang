use inkwell::values::BasicValueEnum;
use crate::codegen::codegen::Codegen;
use crate::parser::ast::CallArg;

impl<'ctx> Codegen<'ctx> {
    /// Compile query_gt/query_gte/query_lt/query_lte — single int arg, returns ForgeString
    pub(crate) fn compile_query_int1(&mut self, args: &[CallArg], runtime_fn: &str) -> Option<BasicValueEnum<'ctx>> {
        if args.is_empty() { return None; }
        let val = self.compile_expr(&args[0].value)?;
        self.call_runtime(runtime_fn, &[val.into()], "qfilter")
    }

    /// Compile query_between(low, high) — two int args, returns ForgeString
    pub(crate) fn compile_query_between(&mut self, args: &[CallArg]) -> Option<BasicValueEnum<'ctx>> {
        if args.len() < 2 { return None; }
        let low = self.compile_expr(&args[0].value)?;
        let high = self.compile_expr(&args[1].value)?;
        self.call_runtime("forge_query_between", &[low.into(), high.into()], "qbetween")
    }

    /// Compile query_like(pattern) — string arg, returns ForgeString
    pub(crate) fn compile_query_like(&mut self, args: &[CallArg]) -> Option<BasicValueEnum<'ctx>> {
        if args.is_empty() { return None; }
        let val = self.compile_expr(&args[0].value)?;
        self.call_runtime("forge_query_like", &[val.into()], "qlike")
    }
}
