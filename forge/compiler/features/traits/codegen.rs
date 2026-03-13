use std::collections::HashMap;

use crate::codegen::codegen::Codegen;
use crate::parser::ast::*;
use crate::typeck::types::Type;

impl<'ctx> Codegen<'ctx> {
    /// Compile all impl block methods, including default methods from traits.
    pub(crate) fn compile_all_impl_methods(&mut self) {
        let impls = self.impls.clone();
        for impl_info in &impls {
            let type_name = &impl_info.type_name;
            let self_type = self.resolve_named_type(type_name);

            for (method_name, method_info) in &impl_info.methods {
                let mangled = format!("{}_{}", type_name, method_name);

                // Build params with self type resolved
                let mut resolved_params = Vec::new();
                for p in &method_info.params {
                    if p.name == "self" {
                        // self has the implementing type
                        resolved_params.push(Param {
                            name: "self".to_string(),
                            type_ann: Some(self.type_to_type_expr(&self_type)),
                            default: None,
                            span: p.span,
                        });
                    } else {
                        // Resolve param types: if the type refers to the implementing type name, use that
                        let mut param = p.clone();
                        if let Some(ref type_ann) = p.type_ann {
                            param.type_ann = Some(self.resolve_impl_type_expr(type_ann, type_name, &impl_info.associated_types));
                        }
                        resolved_params.push(param);
                    }
                }

                self.declare_function(&mangled, &resolved_params, method_info.return_type.as_ref());
                self.compile_fn(&mangled, &resolved_params, method_info.return_type.as_ref(), &method_info.body);
            }

            // Generate default methods from the trait if not overridden
            if let Some(ref trait_name) = impl_info.trait_name {
                if let Some(trait_info) = self.traits.get(trait_name).cloned() {
                    for trait_method in &trait_info.methods {
                        if !impl_info.methods.contains_key(&trait_method.name) {
                            if let Some(ref default_body) = trait_method.default_body {
                                let mangled = format!("{}_{}", type_name, trait_method.name);
                                let mut resolved_params = Vec::new();
                                for p in &trait_method.params {
                                    if p.name == "self" {
                                        resolved_params.push(Param {
                                            name: "self".to_string(),
                                            type_ann: Some(self.type_to_type_expr(&self_type)),
                                            default: None,
                                            span: p.span,
                                        });
                                    } else {
                                        resolved_params.push(p.clone());
                                    }
                                }
                                self.declare_function(&mangled, &resolved_params, trait_method.return_type.as_ref());
                                self.compile_fn(&mangled, &resolved_params, trait_method.return_type.as_ref(), default_body);
                            }
                        }
                    }
                }
            }
        }
    }

    /// Convert a Type back to a TypeExpr for use in param declarations
    pub(crate) fn type_to_type_expr(&self, ty: &Type) -> TypeExpr {
        match ty {
            Type::Int => TypeExpr::Named("int".to_string()),
            Type::Float => TypeExpr::Named("float".to_string()),
            Type::Bool => TypeExpr::Named("bool".to_string()),
            Type::String => TypeExpr::Named("string".to_string()),
            Type::Void => TypeExpr::Named("void".to_string()),
            Type::Struct { name: Some(n), .. } => {
                // Use the named type so resolution preserves the name
                TypeExpr::Named(n.clone())
            }
            Type::Struct { name: None, fields } => {
                TypeExpr::Struct {
                    fields: fields.iter().map(|(fname, fty)| (fname.clone(), self.type_to_type_expr(fty), Vec::new())).collect(),
                }
            }
            Type::List(inner) => TypeExpr::Generic {
                name: "List".to_string(),
                args: vec![self.type_to_type_expr(inner)],
            },
            Type::Nullable(inner) => TypeExpr::Nullable(Box::new(self.type_to_type_expr(inner))),
            Type::Tuple(elems) => TypeExpr::Tuple(elems.iter().map(|e| self.type_to_type_expr(e)).collect()),
            _ => TypeExpr::Named("int".to_string()), // fallback
        }
    }

    /// Resolve a type expression in the context of an impl block
    pub(crate) fn resolve_impl_type_expr(&self, type_expr: &TypeExpr, type_name: &str, associated_types: &[(String, TypeExpr)]) -> TypeExpr {
        match type_expr {
            TypeExpr::Named(name) => {
                if name == type_name {
                    // Self-referencing type - resolve to the actual struct
                    if let Some(ty) = self.named_types.get(name) {
                        self.type_to_type_expr(ty)
                    } else {
                        type_expr.clone()
                    }
                } else {
                    // Check associated types
                    for (assoc_name, assoc_type) in associated_types {
                        if name == assoc_name {
                            return assoc_type.clone();
                        }
                    }
                    type_expr.clone()
                }
            }
            _ => type_expr.clone(),
        }
    }

    /// Resolve a type name to its full Type
    pub(crate) fn resolve_named_type(&self, name: &str) -> Type {
        if let Some(ty) = self.named_types.get(name) {
            ty.clone()
        } else if let Some(ty) = self.type_checker.env.type_aliases.get(name) {
            match ty {
                Type::Struct { fields, name: None } => Type::Struct {
                    name: Some(name.to_string()),
                    fields: fields.clone(),
                },
                other => other.clone(),
            }
        } else {
            match name {
                "int" => Type::Int,
                "float" => Type::Float,
                "bool" => Type::Bool,
                "string" => Type::String,
                _ => Type::Unknown,
            }
        }
    }

    /// Look up an impl method for a given type and method name
    pub(crate) fn find_impl_method(&self, type_name: &str, method_name: &str) -> Option<String> {
        let mangled = format!("{}_{}", type_name, method_name);
        if self.functions.contains_key(&mangled) {
            return Some(mangled);
        }
        // Also check impls registry
        for impl_info in &self.impls {
            if impl_info.type_name == type_name && impl_info.methods.contains_key(method_name) {
                return Some(mangled);
            }
            // Check default methods from trait
            if impl_info.type_name == type_name {
                if let Some(ref trait_name) = impl_info.trait_name {
                    if let Some(trait_info) = self.traits.get(trait_name) {
                        for tm in &trait_info.methods {
                            if tm.name == method_name && tm.default_body.is_some() {
                                return Some(mangled);
                            }
                        }
                    }
                }
            }
        }
        None
    }

    /// Find operator trait impl for a type: given type_name and op (Add, Sub, etc), return mangled method name
    pub(crate) fn find_operator_impl(&self, type_name: &str, trait_name: &str, method_name: &str) -> Option<String> {
        for impl_info in &self.impls {
            if impl_info.type_name == type_name {
                if let Some(ref tn) = impl_info.trait_name {
                    if tn == trait_name {
                        let mangled = format!("{}_{}", type_name, method_name);
                        return Some(mangled);
                    }
                }
            }
        }
        None
    }

    /// Get the type name from a Type
    pub(crate) fn get_type_name(&self, ty: &Type) -> Option<String> {
        match ty {
            Type::Struct { name: Some(n), .. } => Some(n.clone()),
            Type::Int => Some("int".to_string()),
            Type::Float => Some("float".to_string()),
            Type::Bool => Some("bool".to_string()),
            Type::String => Some("string".to_string()),
            _ => None,
        }
    }
}
