use inkwell::values::BasicValueEnum;
use crate::codegen::codegen::Codegen;
use crate::parser::ast::CallArg;

impl<'ctx> Codegen<'ctx> {
    /// Compile read_file(path) — reads entire file as string
    pub(crate) fn compile_read_file(&mut self, args: &[CallArg]) -> Option<BasicValueEnum<'ctx>> {
        if args.len() != 1 { return None; }
        let path_val = self.compile_expr(&args[0].value)?;
        self.call_runtime("forge_read_file", &[path_val.into()], "read_file")
    }

    /// Compile write_file(path, content) — writes string to file, returns bool
    pub(crate) fn compile_write_file(&mut self, args: &[CallArg]) -> Option<BasicValueEnum<'ctx>> {
        if args.len() != 2 { return None; }
        let path_val = self.compile_expr(&args[0].value)?;
        let content_val = self.compile_expr(&args[1].value)?;
        self.call_runtime("forge_write_file", &[path_val.into(), content_val.into()], "write_file")
    }

    /// Compile file_exists(path) — checks if file exists, returns bool
    pub(crate) fn compile_file_exists(&mut self, args: &[CallArg]) -> Option<BasicValueEnum<'ctx>> {
        if args.len() != 1 { return None; }
        let path_val = self.compile_expr(&args[0].value)?;
        self.call_runtime("forge_file_exists", &[path_val.into()], "file_exists")
    }
}
