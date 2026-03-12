use inkwell::values::BasicValueEnum;
use crate::codegen::codegen::Codegen;
use crate::parser::ast::*;

impl<'ctx> Codegen<'ctx> {
    /// Compile a template literal by concatenating all parts.
    ///
    /// Literal segments become string constants; expression segments are compiled
    /// and converted to strings via `value_to_string`, then concatenated with
    /// `forge_string_concat`.
    pub(crate) fn compile_template(&mut self, parts: &[TemplatePart]) -> Option<BasicValueEnum<'ctx>> {
        let mut result: Option<BasicValueEnum<'ctx>> = None;
        let concat_fn = self.module.get_function("forge_string_concat").unwrap();

        for part in parts {
            let part_val = match part {
                TemplatePart::Literal(s) => self.build_string_literal(s),
                TemplatePart::Expr(expr) => {
                    let val = self.compile_expr(expr)?;
                    let expr_type = self.infer_type(expr);
                    self.value_to_string(val, &expr_type)?
                }
            };

            result = Some(if let Some(prev) = result {
                let call = self.builder.build_call(
                    concat_fn,
                    &[prev.into(), part_val.into()],
                    "concat",
                ).unwrap();
                call.try_as_basic_value().left().unwrap()
            } else {
                part_val
            });
        }

        result
    }
}
