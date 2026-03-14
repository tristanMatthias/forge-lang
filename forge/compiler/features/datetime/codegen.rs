use inkwell::values::BasicValueEnum;
use crate::codegen::codegen::Codegen;
use crate::parser::ast::CallArg;

impl<'ctx> Codegen<'ctx> {
    /// Compile datetime_now() — returns current epoch milliseconds as i64
    pub(crate) fn compile_datetime_now(&mut self) -> Option<BasicValueEnum<'ctx>> {
        self.call_runtime("forge_datetime_now", &[], "now")
    }

    /// Compile datetime_format(epoch_ms) — returns formatted string
    pub(crate) fn compile_datetime_format(&mut self, args: &[CallArg]) -> Option<BasicValueEnum<'ctx>> {
        if args.is_empty() { return None; }
        let val = self.compile_expr(&args[0].value)?;
        self.call_runtime("forge_datetime_format", &[val.into()], "dtfmt")
    }

    /// Compile datetime_parse(string) — returns epoch milliseconds as i64
    pub(crate) fn compile_datetime_parse(&mut self, args: &[CallArg]) -> Option<BasicValueEnum<'ctx>> {
        if args.is_empty() { return None; }
        let val = self.compile_expr(&args[0].value)?;
        // val is a ForgeString struct {ptr, len} — extract fields
        let ptr_val = self.builder.build_extract_value(val.into_struct_value(), 0, "str_ptr").unwrap();
        let len_val = self.builder.build_extract_value(val.into_struct_value(), 1, "str_len").unwrap();
        self.call_runtime("forge_datetime_parse", &[ptr_val.into(), len_val.into()], "dtparse")
    }
}
