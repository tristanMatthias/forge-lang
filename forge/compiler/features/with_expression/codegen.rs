use inkwell::values::BasicValueEnum;

use crate::codegen::codegen::Codegen;
use crate::parser::ast::*;
use crate::typeck::types::Type;

impl<'ctx> Codegen<'ctx> {
    /// Compile a `with` expression: `base with { field: value, ... }`
    ///
    /// Creates a copy of the struct with specified fields updated.
    pub(crate) fn compile_with(
        &mut self,
        base: &Expr,
        updates: &[(String, Expr)],
    ) -> Option<BasicValueEnum<'ctx>> {
        let base_val = self.compile_expr(base)?;
        let base_type = self.infer_type(base);

        if let Type::Struct { fields, .. } = &base_type {
            if !base_val.is_struct_value() {
                return None;
            }
            let mut struct_val = base_val.into_struct_value();

            for (field_name, new_val_expr) in updates {
                if let Some(idx) = fields.iter().position(|(name, _)| name == field_name) {
                    if let Some(new_val) = self.compile_expr(new_val_expr) {
                        struct_val = self
                            .builder
                            .build_insert_value(struct_val, new_val, idx as u32, "with_field")
                            .unwrap()
                            .into_struct_value();
                    }
                }
            }

            Some(struct_val.into())
        } else {
            Some(base_val)
        }
    }
}
