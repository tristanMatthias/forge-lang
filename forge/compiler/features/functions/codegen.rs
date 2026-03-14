use crate::codegen::codegen::{Codegen, GenericFnInfo};
use crate::feature::FeatureStmt;
use crate::feature_data;
use crate::parser::ast::Statement;

use super::types::{FnDeclData, ReturnData};

impl<'ctx> Codegen<'ctx> {
    /// Compile a function declaration or return statement via the Feature dispatch system.
    pub(crate) fn compile_functions_feature(&mut self, fe: &FeatureStmt) {
        match fe.kind {
            "FnDecl" => {
                if let Some(data) = feature_data!(fe, FnDeclData) {
                    // Skip generic functions - they are monomorphized on demand
                    if !data.type_params.is_empty() {
                        return;
                    }
                    self.compile_fn(&data.name, &data.params, data.return_type.as_ref(), &data.body);
                }
            }
            "Return" => {
                if let Some(data) = feature_data!(fe, ReturnData) {
                    // Execute deferred statements before returning
                    self.execute_deferred_stmts();
                    if let Some(val) = &data.value {
                        let compiled = self.compile_expr(val);
                        if let Some(v) = compiled {
                            self.builder.build_return(Some(&v)).unwrap();
                        } else {
                            self.builder.build_return(None).unwrap();
                        }
                    } else if self.current_fn_name.as_deref() == Some("main") {
                        self.builder
                            .build_return(Some(&self.context.i32_type().const_zero()))
                            .unwrap();
                    } else {
                        self.builder.build_return(None).unwrap();
                    }
                }
            }
            _ => {}
        }
    }

    /// Handle function feature stmts in compile_program's first pass.
    pub(crate) fn compile_program_functions_feature(&mut self, fe: &FeatureStmt) {
        match fe.kind {
            "FnDecl" => {
                if let Some(data) = feature_data!(fe, FnDeclData) {
                    if !data.type_params.is_empty() {
                        self.generic_fns.insert(data.name.clone(), GenericFnInfo {
                            type_params: data.type_params.clone(),
                            params: data.params.clone(),
                            return_type: data.return_type.clone(),
                            body: data.body.clone(),
                        });
                    }
                }
            }
            _ => {}
        }
    }

    /// Declare function in compile_program's declaration pass.
    pub(crate) fn declare_program_functions_feature(&mut self, fe: &FeatureStmt) {
        if let Some(data) = feature_data!(fe, FnDeclData) {
            if data.type_params.is_empty() {
                self.declare_function(&data.name, &data.params, data.return_type.as_ref());
            }
        }
    }

    /// Check if a feature stmt is an explicit main function.
    pub(crate) fn is_feature_main_fn(fe: &FeatureStmt) -> bool {
        if fe.feature_id == "functions" && fe.kind == "FnDecl" {
            if let Some(data) = feature_data!(fe, FnDeclData) {
                return data.name == "main";
            }
        }
        false
    }

    /// Check if a feature stmt is a declaration-only statement (for has_top_level_stmts detection).
    pub(crate) fn is_feature_declaration_only(fe: &FeatureStmt) -> bool {
        match fe.feature_id {
            "functions" => fe.kind == "FnDecl",
            "variables" => fe.kind == "Mut",
            "structs" => fe.kind == "TypeDecl",
            "traits" => fe.kind == "TraitDecl" || fe.kind == "ImplBlock",
            "imports" => fe.kind == "Use",
            _ => false,
        }
    }

    /// Compile module-level function features
    pub(crate) fn compile_module_functions_feature(&mut self, fe: &FeatureStmt, prefix: &str) {
        if let Some(data) = feature_data!(fe, FnDeclData) {
            let mangled = format!("{}_{}", prefix, data.name);
            self.compile_fn(&mangled, &data.params, data.return_type.as_ref(), &data.body);
        }
    }

    /// Declare module-level function features
    pub(crate) fn declare_module_functions_feature(&mut self, fe: &FeatureStmt, prefix: &str) {
        if let Some(data) = feature_data!(fe, FnDeclData) {
            let mangled = format!("{}_{}", prefix, data.name);
            self.declare_function(&mangled, &data.params, data.return_type.as_ref());
        }
    }
}
