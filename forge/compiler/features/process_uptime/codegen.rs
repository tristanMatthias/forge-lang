use inkwell::values::BasicValueEnum;
use crate::codegen::codegen::Codegen;

impl<'ctx> Codegen<'ctx> {
    /// Compile process_uptime() — returns milliseconds since program start as i64
    pub(crate) fn compile_process_uptime(&mut self) -> Option<BasicValueEnum<'ctx>> {
        let func = self.module.get_function("forge_process_uptime").unwrap();
        let result = self.builder.build_call(func, &[], "uptime").unwrap();
        result.try_as_basic_value().left()
    }
}
