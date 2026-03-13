use inkwell::values::BasicValueEnum;
use crate::codegen::codegen::Codegen;
use crate::parser::ast::CallArg;

impl<'ctx> Codegen<'ctx> {
    /// Compile datetime_now() — returns current epoch milliseconds as i64
    pub(crate) fn compile_datetime_now(&mut self) -> Option<BasicValueEnum<'ctx>> {
        let func = self.module.get_function("forge_datetime_now").unwrap();
        let result = self.builder.build_call(func, &[], "now").unwrap();
        result.try_as_basic_value().left()
    }

    /// Compile datetime_format(epoch_ms) — returns formatted string
    pub(crate) fn compile_datetime_format(&mut self, args: &[CallArg]) -> Option<BasicValueEnum<'ctx>> {
        if args.is_empty() { return None; }
        let val = self.compile_expr(&args[0].value)?;
        let func = self.module.get_function("forge_datetime_format").unwrap();
        let result = self.builder.build_call(func, &[val.into()], "dtfmt").unwrap();
        result.try_as_basic_value().left()
    }

    /// Compile datetime_parse(string) — returns epoch milliseconds as i64
    pub(crate) fn compile_datetime_parse(&mut self, args: &[CallArg]) -> Option<BasicValueEnum<'ctx>> {
        if args.is_empty() { return None; }
        let val = self.compile_expr(&args[0].value)?;
        // val is a ForgeString struct {ptr, len} — extract fields
        let ptr_val = self.builder.build_extract_value(val.into_struct_value(), 0, "str_ptr").unwrap();
        let len_val = self.builder.build_extract_value(val.into_struct_value(), 1, "str_len").unwrap();
        let func = self.module.get_function("forge_datetime_parse").unwrap();
        let result = self.builder.build_call(func, &[ptr_val.into(), len_val.into()], "dtparse").unwrap();
        result.try_as_basic_value().left()
    }
}
