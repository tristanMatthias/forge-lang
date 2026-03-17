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
                .map(|v| {
                    let mut boxed_fields = Vec::new();
                    let fields: Vec<(String, Type)> = v
                        .fields
                        .iter()
                        .enumerate()
                        .map(|(i, f)| {
                            // Only box DIRECT self-references (Type or Type?), not
                            // indirect ones through List<Type> (those are heap-allocated).
                            let is_self_ref = if let Some(ref t) = f.type_ann {
                                match t {
                                    crate::parser::ast::TypeExpr::Named(n) => n == &data.name,
                                    crate::parser::ast::TypeExpr::Nullable(inner) => {
                                        matches!(inner.as_ref(), crate::parser::ast::TypeExpr::Named(n) if n == &data.name)
                                    }
                                    _ => false,
                                }
                            } else {
                                f.name == data.name
                            };
                            let ty = if is_self_ref {
                                boxed_fields.push(i);
                                // Preserve Nullable wrapper for boxed self-refs
                                let stub = Type::Enum { name: data.name.clone(), variants: vec![] };
                                if let Some(ref t) = f.type_ann {
                                    if matches!(t, crate::parser::ast::TypeExpr::Nullable(_)) {
                                        Type::Nullable(Box::new(stub))
                                    } else {
                                        stub
                                    }
                                } else {
                                    stub
                                }
                            } else if let Some(ref t) = f.type_ann {
                                self.resolve_type_expr(t)
                            } else {
                                // Positional field: name IS the type (e.g., Ident(string))
                                self.env.resolve_type_name(&f.name)
                            };
                            // For positional fields, use index as field name
                            let field_name = if f.type_ann.is_none() {
                                format!("{}", i)
                            } else {
                                f.name.clone()
                            };
                            (field_name, ty)
                        })
                        .collect();
                    EnumVariantType {
                        name: v.name.clone(),
                        fields,
                        boxed_fields,
                    }
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
