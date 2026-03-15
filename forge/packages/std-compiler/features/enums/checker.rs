use crate::feature::FeatureStmt;
use crate::feature_data;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::{EnumVariantType, Type};

use super::types::EnumDeclData;

impl TypeChecker {
    /// Type-check an enum declaration via the Feature dispatch system.
    /// This registers the enum type in the top-level pass.
    pub(crate) fn check_enum_feature(&mut self, _fe: &FeatureStmt) {
        // Already handled in register_top_level_feature
    }

    /// Register an enum type during the top-level registration pass.
    pub(crate) fn register_enum_feature(&mut self, fe: &FeatureStmt) {
        if let Some(data) = feature_data!(fe, EnumDeclData) {
            let variant_types: Vec<EnumVariantType> = data
                .variants
                .iter()
                .map(|v| EnumVariantType {
                    name: v.name.clone(),
                    fields: v
                        .fields
                        .iter()
                        .map(|f| {
                            let ty = f
                                .type_ann
                                .as_ref()
                                .map(|t| self.resolve_type_expr(t))
                                .unwrap_or(Type::Unknown);
                            (f.name.clone(), ty)
                        })
                        .collect(),
                })
                .collect();
            let enum_type = Type::Enum {
                name: data.name.clone(),
                variants: variant_types,
            };
            self.env.enum_types.insert(data.name.clone(), enum_type);
        }
    }
}
