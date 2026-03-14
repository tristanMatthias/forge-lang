use crate::feature::{FeatureExpr, FeatureStmt};
use crate::feature_data;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

use super::types::{StructLitData, TypeDeclData};

impl TypeChecker {
    /// Type-check a type declaration via the Feature dispatch system.
    pub(crate) fn check_structs_feature(&mut self, fe: &FeatureStmt) {
        // TypeDecl is handled in register_top_level, nothing to do in check_statement
    }

    /// Register a type declaration in the top-level pass.
    pub(crate) fn register_type_decl_feature(&mut self, fe: &FeatureStmt) {
        if let Some(data) = feature_data!(fe, TypeDeclData) {
            // Check for conflicting annotations in intersection types
            self.check_intersection_annotation_conflicts(&data.value, fe.span);
            let field_annotations = self.extract_type_annotations(&data.value);
            if !field_annotations.is_empty() {
                self.env.type_annotations.insert(data.name.clone(), field_annotations);
            }
            if self.is_partial_type_expr(&data.value) {
                self.env.partial_types.insert(data.name.clone());
            }
            let ty = self.resolve_type_expr(&data.value);
            let ty = match ty {
                Type::Struct { fields, .. } => Type::Struct {
                    name: Some(data.name.clone()),
                    fields,
                },
                other => other,
            };
            self.env.type_aliases.insert(data.name.clone(), ty);
        }
    }

    /// Type-check a struct literal expression via the Feature dispatch system.
    pub(crate) fn check_struct_lit_feature(&mut self, fe: &FeatureExpr) -> Type {
        if let Some(data) = feature_data!(fe, StructLitData) {
            // Check for duplicate field names
            let mut seen_fields: std::collections::HashSet<&str> = std::collections::HashSet::new();
            for (field_name, field_val) in &data.fields {
                if !seen_fields.insert(field_name.as_str()) {
                    self.diagnostics.push(crate::errors::Diagnostic::error(
                        "F0012",
                        format!("duplicate field '{}' in struct literal", field_name),
                        field_val.span(),
                    ));
                }
            }

            let field_types: Vec<(String, Type)> = data.fields
                .iter()
                .map(|(name, val)| (name.clone(), self.check_expr(val)))
                .collect();

            if let Some(type_name) = &data.name {
                let resolved = self.env.resolve_type_name(type_name);
                if let Type::Struct { fields: type_fields, .. } = &resolved {
                    let known_names: Vec<&str> = type_fields.iter().map(|(n, _)| n.as_str()).collect();
                    for (field_name, field_val) in &data.fields {
                        if let Some((_, expected_ty)) = type_fields.iter().find(|(n, _)| n == field_name) {
                            // Check field type matches declared type
                            let actual_ty = field_types.iter()
                                .find(|(n, _)| n == field_name)
                                .map(|(_, t)| t.clone())
                                .unwrap_or(Type::Unknown);
                            if !self.types_compatible(expected_ty, &actual_ty) {
                                let field_span = field_val.span();
                                self.diagnostics.push(crate::errors::Diagnostic::error(
                                    "F0012",
                                    format!(
                                        "type mismatch for field '{}': expected {}, got {}",
                                        field_name, expected_ty, actual_ty
                                    ),
                                    field_span,
                                ));
                            }
                            continue;
                        }
                        if let Some(suggestion) = crate::errors::did_you_mean(field_name, &known_names, 2) {
                            let field_span = field_val.span();
                            self.diagnostics.push(crate::errors::Diagnostic::error(
                                "F0020",
                                format!("unknown field '{}' on type '{}' — did you mean '{}'?", field_name, type_name, suggestion),
                                field_span,
                            ));
                        }
                    }
                }
            }

            Type::Struct {
                name: data.name.clone(),
                fields: field_types,
            }
        } else {
            Type::Unknown
        }
    }
}
