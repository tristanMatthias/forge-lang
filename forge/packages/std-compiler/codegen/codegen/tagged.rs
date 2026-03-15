use super::*;

/// Helpers for working with tagged structs: {i8 tag, T payload}.
/// Used by nullable types (tag=0 null, tag=1 present) and
/// Result types (tag=0 ok, tag=1 err).
impl<'ctx> Codegen<'ctx> {
    /// Extract tag (index 0) from a tagged struct and compare to zero.
    /// Returns i1 (true if tag != 0, i.e. value is present/ok for nullable, err for Result).
    pub(crate) fn extract_tag_is_set(
        &mut self,
        struct_val: inkwell::values::StructValue<'ctx>,
        label: &str,
    ) -> Option<IntValue<'ctx>> {
        let tag = self.builder.build_extract_value(struct_val, 0, &format!("{}_tag", label)).ok()?;
        Some(self.builder.build_int_compare(
            IntPredicate::NE,
            tag.into_int_value(),
            self.context.i8_type().const_zero(),
            &format!("{}_is_set", label),
        ).unwrap())
    }

    /// Extract payload (index 1) from a tagged struct.
    pub(crate) fn extract_tagged_payload(
        &mut self,
        struct_val: inkwell::values::StructValue<'ctx>,
        label: &str,
    ) -> Option<BasicValueEnum<'ctx>> {
        self.builder.build_extract_value(struct_val, 1, &format!("{}_val", label)).ok()
    }
}
