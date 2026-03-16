use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

impl TypeChecker {
    /// Try to resolve a contextual `.variant` reference against known enum types.
    /// Returns the enum type if exactly one registered enum has this variant name.
    /// Returns `Type::Unknown` if no enum matches (deferred to codegen or error).
    pub(crate) fn resolve_contextual_variant(&self, dot_name: &str) -> Type {
        let variant_name = &dot_name[1..]; // strip leading dot
        let mut found: Option<Type> = None;
        for (_enum_name, ty) in &self.env.enum_types {
            if let Type::Enum { variants, .. } = ty {
                if variants.iter().any(|v| v.name == variant_name) {
                    if found.is_some() {
                        // Ambiguous: multiple enums have this variant — require explicit qualification
                        return Type::Unknown;
                    }
                    found = Some(ty.clone());
                }
            }
        }
        found.unwrap_or(Type::Unknown)
    }
}
