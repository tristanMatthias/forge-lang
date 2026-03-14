use inkwell::values::BasicValueEnum;
use crate::codegen::codegen::Codegen;

impl<'ctx> Codegen<'ctx> {
    /// Compile process_uptime() — returns milliseconds since program start as i64
    pub(crate) fn compile_process_uptime(&mut self) -> Option<BasicValueEnum<'ctx>> {
        self.call_runtime("forge_process_uptime", &[], "uptime")
    }
}
