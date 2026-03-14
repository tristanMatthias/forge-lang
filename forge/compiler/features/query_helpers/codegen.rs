use inkwell::values::BasicValueEnum;
use crate::codegen::codegen::Codegen;
use crate::parser::ast::CallArg;

impl<'ctx> Codegen<'ctx> {
    /// Compile query_gt/query_gte/query_lt/query_lte — single int arg, returns ForgeString
    pub(crate) fn compile_query_int1(&mut self, args: &[CallArg], runtime_fn: &str) -> Option<BasicValueEnum<'ctx>> {
        if args.is_empty() { return None; }
        let val = self.compile_expr(&args[0].value)?;
        let func = self.module.get_function(runtime_fn).unwrap();
        let result = self.builder.build_call(func, &[val.into()], "qfilter").unwrap();
        result.try_as_basic_value().left()
    }

    /// Compile query_between(low, high) — two int args, returns ForgeString
    pub(crate) fn compile_query_between(&mut self, args: &[CallArg]) -> Option<BasicValueEnum<'ctx>> {
        if args.len() < 2 { return None; }
        let low = self.compile_expr(&args[0].value)?;
        let high = self.compile_expr(&args[1].value)?;
        let func = self.module.get_function("forge_query_between").unwrap();
        let result = self.builder.build_call(func, &[low.into(), high.into()], "qbetween").unwrap();
        result.try_as_basic_value().left()
    }

    /// Compile query_like(pattern) — string arg, returns ForgeString
    pub(crate) fn compile_query_like(&mut self, args: &[CallArg]) -> Option<BasicValueEnum<'ctx>> {
        if args.is_empty() { return None; }
        let val = self.compile_expr(&args[0].value)?;
        let func = self.module.get_function("forge_query_like").unwrap();
        let result = self.builder.build_call(func, &[val.into()], "qlike").unwrap();
        result.try_as_basic_value().left()
    }
}
