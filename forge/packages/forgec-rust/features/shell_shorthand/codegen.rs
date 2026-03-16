use inkwell::values::BasicValueEnum;

use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::feature_codegen;
use crate::parser::ast::*;

use super::types::DollarExecData;

impl<'ctx> Codegen<'ctx> {
    /// Compile a dollar-exec expression via Feature dispatch.
    pub(crate) fn compile_dollar_exec_feature(
        &mut self,
        fe: &FeatureExpr,
    ) -> Option<BasicValueEnum<'ctx>> {
        feature_codegen!(self, fe, DollarExecData, |data| self.compile_dollar_exec(&data.parts))
    }

    /// Compile a dollar-exec expression: `$"echo hello ${name}"` or `$\`cmd\``
    ///
    /// Builds the command string from template parts, extracts the raw C pointer,
    /// calls `forge_process_exec(cmd)` which returns a raw pointer to stdout,
    /// then converts the result to a ForgeString.
    pub(crate) fn compile_dollar_exec(
        &mut self,
        parts: &[TemplatePart],
    ) -> Option<BasicValueEnum<'ctx>> {
        // Build the command string from template parts
        let cmd_str = self.compile_template(parts)?;

        // Extract ptr from ForgeString
        let cmd_ptr = self.builder.build_extract_value(
            cmd_str.into_struct_value(), 0, "cmd_ptr"
        ).unwrap();

        // Declare forge_process_exec if not already declared
        let ptr_type = self.context.ptr_type(inkwell::AddressSpace::default());
        let exec_fn = self.module.get_function("forge_process_exec").unwrap_or_else(|| {
            let ft = ptr_type.fn_type(&[ptr_type.into()], false);
            self.module.add_function("forge_process_exec", ft, None)
        });

        // Call forge_process_exec(cmd) — returns raw ptr to stdout string
        let result = self.builder.build_call(
            exec_fn, &[cmd_ptr.into()], "exec_result"
        ).unwrap();
        let raw_ptr = result.try_as_basic_value().left()?.into_pointer_value();

        // Convert ptr to ForgeString
        let len = self.call_runtime("strlen", &[raw_ptr.into()], "slen").unwrap();
        let stdout_str = self.call_runtime("forge_string_new", &[raw_ptr.into(), len.into()], "stdout_str")?;

        Some(stdout_str)
    }
}
