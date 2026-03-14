use crate::feature::FeatureStmt;
use crate::feature_data;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

use super::types::{FnDeclData, ReturnData};

impl TypeChecker {
    /// Type-check a function declaration or return statement via the Feature dispatch system.
    pub(crate) fn check_functions_feature(&mut self, fe: &FeatureStmt) {
        match fe.kind {
            "FnDecl" => {
                if let Some(data) = feature_data!(fe, FnDeclData) {
                    self.env.push_scope();

                    let ret_type = data.return_type
                        .as_ref()
                        .map(|t| self.resolve_type_expr(t))
                        .unwrap_or(Type::Void);

                    let old_return = self.current_fn_return_type.take();
                    self.current_fn_return_type = Some(ret_type.clone());

                    for param in &data.params {
                        let ty = param
                            .type_ann
                            .as_ref()
                            .map(|t| self.resolve_type_expr(t))
                            .unwrap_or(Type::Unknown);
                        self.env.define(param.name.clone(), ty, false);
                    }

                    self.check_block(&data.body);
                    self.env.pop_scope_silent();
                    self.current_fn_return_type = old_return;
                }
            }
            "Return" => {
                if let Some(data) = feature_data!(fe, ReturnData) {
                    if let Some(val) = &data.value {
                        let val_type = self.check_expr(val);
                        if let Some(expected) = self.current_fn_return_type.clone() {
                            self.check_type_mismatch_ctx(&expected, &val_type, fe.span, None, Some(val));
                        }
                    }
                }
            }
            _ => {}
        }
    }

    /// Register a function declaration in the top-level pass.
    pub(crate) fn register_fn_feature(&mut self, fe: &FeatureStmt) {
        if let Some(data) = feature_data!(fe, FnDeclData) {
            let param_types: Vec<Type> = data.params
                .iter()
                .map(|p| {
                    p.type_ann
                        .as_ref()
                        .map(|t| self.resolve_type_expr(t))
                        .unwrap_or(Type::Unknown)
                })
                .collect();
            let ret = data.return_type
                .as_ref()
                .map(|t| self.resolve_type_expr(t))
                .unwrap_or(Type::Void);
            self.env.fn_spans.insert(data.name.clone(), fe.span);
            self.env.functions.insert(
                data.name.clone(),
                Type::Function {
                    params: param_types,
                    return_type: Box::new(ret),
                },
            );
        }
    }
}
