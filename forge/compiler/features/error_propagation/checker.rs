use crate::feature::FeatureExpr;
use crate::feature_data;
use crate::parser::ast::*;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

use super::types::{ErrorPropagateData, OkExprData, ErrExprData, CatchData};

impl TypeChecker {
    /// Type-check `expr?` via Feature dispatch.
    pub(crate) fn check_error_propagate_feature(&mut self, fe: &FeatureExpr) -> Type {
        if let Some(data) = feature_data!(fe, ErrorPropagateData) {
            self.check_error_propagate(&data.operand)
        } else {
            Type::Unknown
        }
    }

    /// Type-check `expr?` — error propagation operator.
    pub(crate) fn check_error_propagate(&mut self, operand: &Expr) -> Type {
        let op_type = self.check_expr(operand);
        match &op_type {
            Type::Result(ok, _) => *ok.clone(),
            _ => op_type,
        }
    }

    /// Type-check `ok(value)` via Feature dispatch.
    pub(crate) fn check_ok_expr_feature(&mut self, fe: &FeatureExpr) -> Type {
        if let Some(data) = feature_data!(fe, OkExprData) {
            self.check_ok_expr(&data.value)
        } else {
            Type::Unknown
        }
    }

    /// Type-check `ok(value)` — wraps a value in `Result<T, String>`.
    pub(crate) fn check_ok_expr(&mut self, value: &Expr) -> Type {
        let val_type = self.check_expr(value);
        Type::Result(Box::new(val_type), Box::new(Type::String))
    }

    /// Type-check `err(value)` via Feature dispatch.
    pub(crate) fn check_err_expr_feature(&mut self, fe: &FeatureExpr) -> Type {
        if let Some(data) = feature_data!(fe, ErrExprData) {
            self.check_err_expr(&data.value)
        } else {
            Type::Unknown
        }
    }

    /// Type-check `err(value)` — wraps a value in `Result<Unknown, T>`.
    pub(crate) fn check_err_expr(&mut self, value: &Expr) -> Type {
        let val_type = self.check_expr(value);
        Type::Result(Box::new(Type::Unknown), Box::new(val_type))
    }

    /// Type-check `expr catch (binding) { handler }` via Feature dispatch.
    pub(crate) fn check_catch_feature(&mut self, fe: &FeatureExpr) -> Type {
        if let Some(data) = feature_data!(fe, CatchData) {
            self.check_catch(&data.expr, &data.binding, &data.handler)
        } else {
            Type::Unknown
        }
    }

    /// Type-check `expr catch (binding) { handler }`.
    pub(crate) fn check_catch(&mut self, expr: &Expr, binding: &Option<String>, handler: &Block) -> Type {
        let expr_type = self.check_expr(expr);
        self.env.push_scope();
        if let Some(name) = binding {
            self.env.define(name.clone(), Type::String, false);
        }
        let handler_type = self.check_block_type(handler);
        self.env.pop_scope_silent();
        match &expr_type {
            Type::Result(ok, _) => *ok.clone(),
            _ => handler_type,
        }
    }
}
