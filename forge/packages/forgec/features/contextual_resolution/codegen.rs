use crate::codegen::codegen::Codegen;
use crate::typeck::types::Type;
use inkwell::values::BasicValueEnum;

impl<'ctx> Codegen<'ctx> {
    /// Compile a contextual `.variant` reference by finding the matching enum.
    /// Searches all registered enum types for a variant with the given name.
    /// Returns `None` if no unique match is found.
    pub(crate) fn compile_contextual_variant(&mut self, dot_name: &str) -> Option<BasicValueEnum<'ctx>> {
        let variant_name = &dot_name[1..]; // strip leading dot
        let enum_types: Vec<_> = self.type_checker.env.enum_types.clone().into_iter().collect();
        for (enum_name, ty) in &enum_types {
            if let Type::Enum { variants, .. } = ty {
                if let Some(idx) = variants.iter().position(|v| v.name == variant_name) {
                    // Only resolve no-arg variants contextually
                    if variants[idx].fields.is_empty() {
                        return self.compile_enum_constructor(enum_name, variant_name, &[], variants);
                    }
                }
            }
        }
        None
    }
}
