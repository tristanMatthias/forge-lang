use inkwell::values::BasicValueEnum;
use inkwell::AddressSpace;

use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::feature_data;
use crate::parser::ast::*;
use crate::typeck::types::Type;

use super::types::NullThrowData;

impl<'ctx> Codegen<'ctx> {
    /// Compile a null throw expression via Feature dispatch.
    ///
    /// Generates: check if value is null → if so, call forge_panic with error message and abort.
    /// If present, extract and return the inner value.
    pub(crate) fn compile_null_throw_feature(
        &mut self,
        fe: &FeatureExpr,
    ) -> Option<BasicValueEnum<'ctx>> {
        if let Some(data) = feature_data!(fe, NullThrowData) {
            let value_type = self.infer_type(&data.value);
            let val = self.compile_expr(&data.value)?;

            if let Type::Nullable(ref inner) = value_type {
                if val.is_struct_value() {
                    let struct_val = val.into_struct_value();
                    let is_present = self.extract_tag_is_set(struct_val, "null_throw")?;

                    let function = self.current_function();
                    let then_bb = self.context.append_basic_block(function, "null_throw_present");
                    let else_bb = self.context.append_basic_block(function, "null_throw_panic");
                    let merge_bb = self.context.append_basic_block(function, "null_throw_merge");

                    self.builder.build_conditional_branch(is_present, then_bb, else_bb).unwrap();

                    // Present path: extract inner value
                    self.builder.position_at_end(then_bb);
                    let inner_val = self.extract_tagged_payload(struct_val, "null_throw")?;
                    let inner_llvm = self.type_to_llvm_basic(inner);
                    let present_val = if inner_val.get_type() != inner_llvm {
                        self.coerce_value(inner_val, inner_llvm)
                    } else {
                        inner_val
                    };
                    let then_end = self.builder.get_insert_block().unwrap();
                    self.builder.build_unconditional_branch(merge_bb).unwrap();

                    // Null path: panic with error message
                    self.builder.position_at_end(else_bb);
                    let error_msg = self.extract_throw_error_name(&data.error);
                    let msg_ptr = self.builder.build_global_string_ptr(&error_msg, "panic_msg").unwrap();
                    let msg_len = self.context.i64_type().const_int(error_msg.len() as u64, false);

                    let panic_fn = self.module.get_function("forge_panic").unwrap_or_else(|| {
                        let ptr_type = self.context.ptr_type(AddressSpace::default());
                        let i64t = self.context.i64_type();
                        let ft = self.context.void_type().fn_type(
                            &[ptr_type.into(), i64t.into()],
                            false,
                        );
                        self.module.add_function("forge_panic", ft, None)
                    });
                    self.builder.build_call(panic_fn, &[msg_ptr.as_pointer_value().into(), msg_len.into()], "").unwrap();
                    self.builder.build_unreachable().unwrap();

                    // Merge (only reachable from present path)
                    self.builder.position_at_end(merge_bb);
                    let phi = self.builder.build_phi(present_val.get_type(), "null_throw_result").unwrap();
                    phi.add_incoming(&[(&present_val, then_end)]);
                    return Some(phi.as_basic_value());
                }
            }

            // Not nullable — just pass through
            Some(val)
        } else {
            None
        }
    }

    /// Extract the error name from the throw expression for the panic message.
    /// For `.not_found` (Ident(".not_found")), returns "not_found".
    /// For string literals, returns the string content.
    /// Otherwise returns a generic message.
    fn extract_throw_error_name(&self, error: &Expr) -> String {
        match error {
            Expr::Ident(name, _) => {
                if let Some(stripped) = name.strip_prefix('.') {
                    stripped.to_string()
                } else {
                    name.clone()
                }
            }
            Expr::StringLit(s, _) => s.clone(),
            _ => "null_throw".to_string(),
        }
    }
}
