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
                            // Box DIRECT self-references (Type or Type?) AND other enum-typed fields.
                            // Non-self enum fields (e.g., Expr inside Statement) must be boxed
                            // because the self-hosted compiler's codegen expects pointer-sized slots
                            // for enum fields within other enums.
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
                            // Box fields that are large enum types (>4 slots) to match
                            // the Forge codegen's field type codes ('p' = boxed pointer)
                            let is_other_enum = if !is_self_ref {
                                let enum_name = if let Some(ref t) = f.type_ann {
                                    if let crate::parser::ast::TypeExpr::Named(n) = t {
                                        Some(n.as_str())
                                    } else { None }
                                } else {
                                    Some(f.name.as_str())
                                };
                                if let Some(en) = enum_name {
                                    // Box enum-typed fields and large struct fields (Block).
                                    // Must match the Forge codegen's field type table where 'p' = boxed.
                                    let is_enum = self.env.enum_types.contains_key(en);
                                    // Also box struct fields that are marked 'p' in the Forge
                                    // field type table (they're too large for inline storage).
                                    let is_primitive = matches!(en, "int" | "float" | "bool" | "string" | "ptr" | "i8" | "i16" | "i32" | "i64" | "u8" | "u16" | "u32" | "u64" | "f32" | "f64");
                                    let is_collection = en.starts_with("List") || en.starts_with("Map");
                                    // Box everything that's not a primitive, collection, or Span
                                    // (Span is stored inline as 4 i64 slots using code '4')
                                    let is_span = en == "Span";
                                    is_enum || (!is_primitive && !is_collection && !is_span)
                                } else { false }
                            } else { false };
                            let should_box = is_self_ref || is_other_enum;
                            let ty = if should_box {
                                boxed_fields.push(i);
                                if is_self_ref {
                                    // Self-ref: use stub to avoid infinite recursion
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
                                } else {
                                    // Other enum: resolve the actual type
                                    if let Some(ref t) = f.type_ann {
                                        self.resolve_type_expr(t)
                                    } else {
                                        self.env.resolve_type_name(&f.name)
                                    }
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
