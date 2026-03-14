use crate::errors::Diagnostic;
use crate::feature::FeatureStmt;
use crate::feature_data;
use crate::parser::ast::*;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

use super::types::{ImplBlockData, TraitDeclData};

impl TypeChecker {
    /// Type-check a trait declaration.
    pub(crate) fn check_trait_decl(&mut self, _stmt: &Statement) {
        // Trait declarations are currently handled as no-ops in the checker.
    }

    /// Type-check an impl block.
    pub(crate) fn check_impl_block(&mut self, _stmt: &Statement) {
        // Impl blocks are currently handled as no-ops in the checker.
    }

    /// Type-check trait feature statements via the Feature dispatch system.
    pub(crate) fn check_traits_feature(&mut self, fe: &FeatureStmt) {
        match fe.kind {
            "ImplBlock" => {
                if let Some(data) = feature_data!(fe, ImplBlockData) {
                    // Bug 23: Check that the target type exists
                    let target_type = self.env.resolve_type_name(&data.type_name);
                    if matches!(target_type, Type::Error) {
                        self.diagnostics.push(Diagnostic::error(
                            "F0012",
                            format!("cannot implement methods for undefined type '{}'", data.type_name),
                            fe.span,
                        ).with_help("define the type first with `type` or `enum`".to_string()));
                        return;
                    }

                    // Bug 22: Check that all required trait methods are implemented
                    if let Some(trait_name) = &data.trait_name {
                        if let Some(required_methods) = self.env.trait_methods.get(trait_name).cloned() {
                            let impl_method_names: Vec<String> = data.methods.iter().filter_map(|m| {
                                match m {
                                    Statement::FnDecl { name, .. } => Some(name.clone()),
                                    Statement::Feature(fe) => {
                                        if let Some(fn_data) = feature_data!(fe, crate::features::functions::types::FnDeclData) {
                                            Some(fn_data.name.clone())
                                        } else {
                                            None
                                        }
                                    }
                                    _ => None,
                                }
                            }).collect();

                            let missing: Vec<&String> = required_methods.iter()
                                .filter(|m| !impl_method_names.contains(m))
                                .collect();

                            if !missing.is_empty() {
                                let missing_str = missing.iter().map(|m| format!("'{}'", m)).collect::<Vec<_>>().join(", ");
                                self.diagnostics.push(Diagnostic::error(
                                    "F0012",
                                    format!(
                                        "impl {} for {} is missing required method{}: {}",
                                        trait_name,
                                        data.type_name,
                                        if missing.len() == 1 { "" } else { "s" },
                                        missing_str,
                                    ),
                                    fe.span,
                                ).with_help(format!("add the missing method{} to satisfy the trait", if missing.len() == 1 { "" } else { "s" })));
                            }
                        }
                    }
                }
            }
            _ => {}
        }
    }

    /// Register a trait declaration in the top-level pass.
    pub(crate) fn register_traits_feature(&mut self, fe: &FeatureStmt) {
        match fe.kind {
            "TraitDecl" => {
                if let Some(data) = feature_data!(fe, TraitDeclData) {
                    // Collect required methods (those without default bodies)
                    let required_methods: Vec<String> = data.methods.iter()
                        .filter(|m| m.default_body.is_none())
                        .map(|m| m.name.clone())
                        .collect();
                    self.env.trait_methods.insert(data.name.clone(), required_methods);
                    // Also store ALL method names (required + default)
                    let all_methods: Vec<String> = data.methods.iter()
                        .map(|m| m.name.clone())
                        .collect();
                    self.env.trait_all_methods.insert(data.name.clone(), all_methods);
                }
            }
            "ImplBlock" => {
                if let Some(data) = feature_data!(fe, ImplBlockData) {
                    // Register trait implementation
                    if let Some(trait_name) = &data.trait_name {
                        self.env.type_traits
                            .entry(data.type_name.clone())
                            .or_insert_with(Vec::new)
                            .push(trait_name.clone());
                    }
                    // Collect methods first to avoid borrow conflict
                    let mut new_methods: Vec<(String, Type)> = Vec::new();
                    for m in &data.methods {
                        let (name, ret) = match m {
                            Statement::FnDecl { name, return_type, .. } => {
                                let ret = return_type.as_ref()
                                    .map(|t| self.resolve_type_expr(t))
                                    .unwrap_or(Type::Void);
                                (name.clone(), ret)
                            }
                            Statement::Feature(fe) => {
                                if let Some(fn_data) = feature_data!(fe, crate::features::functions::types::FnDeclData) {
                                    let ret = fn_data.return_type.as_ref()
                                        .map(|t| self.resolve_type_expr(t))
                                        .unwrap_or(Type::Void);
                                    (fn_data.name.clone(), ret)
                                } else {
                                    continue;
                                }
                            }
                            _ => continue,
                        };
                        new_methods.push((name, ret));
                    }
                    let methods = self.env.type_methods
                        .entry(data.type_name.clone())
                        .or_insert_with(Vec::new);
                    for (name, ret) in new_methods {
                        if !methods.iter().any(|(n, _)| n == &name) {
                            methods.push((name, ret));
                        }
                    }
                }
            }
            _ => {}
        }
    }
}
