use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::feature_check;
use crate::parser::ast::*;
use crate::typeck::types::Type;

/// AST data for error propagation: `expr?`
#[derive(Debug, Clone)]
pub struct ErrorPropagateData {
    pub operand: Box<Expr>,
}

crate::impl_feature_node!(ErrorPropagateData);

/// AST data for Ok constructor: `ok(value)`
#[derive(Debug, Clone)]
pub struct OkExprData {
    pub value: Box<Expr>,
}

crate::impl_feature_node!(OkExprData);

/// AST data for Err constructor: `err(value)`
#[derive(Debug, Clone)]
pub struct ErrExprData {
    pub value: Box<Expr>,
}

crate::impl_feature_node!(ErrExprData);

/// AST data for catch expression: `expr catch (binding) { handler }`
#[derive(Debug, Clone)]
pub struct CatchData {
    pub expr: Box<Expr>,
    pub binding: Option<String>,
    pub handler: Block,
}

crate::impl_feature_node!(CatchData);

impl<'ctx> Codegen<'ctx> {
    /// Infer the type of `ok(value)` via Feature dispatch.
    pub(crate) fn infer_ok_expr_feature_type(&self, fe: &FeatureExpr) -> Type {
        feature_check!(self, fe, OkExprData, |data| self.infer_ok_expr_type(&data.value))
    }

    /// Infer the type of `ok(value)` — returns `Result<T, String>`.
    pub(crate) fn infer_ok_expr_type(&self, value: &Expr) -> Type {
        Type::Result(Box::new(self.infer_type(value)), Box::new(Type::String))
    }

    /// Infer the type of `err(value)` via Feature dispatch.
    pub(crate) fn infer_err_expr_feature_type(&self, fe: &FeatureExpr) -> Type {
        feature_check!(self, fe, ErrExprData, |data| self.infer_err_expr_type(&data.value))
    }

    /// Infer the type of `err(value)` — returns `Result<Unknown, T>`.
    pub(crate) fn infer_err_expr_type(&self, value: &Expr) -> Type {
        Type::Result(Box::new(Type::Unknown), Box::new(self.infer_type(value)))
    }

    /// Infer the type of `expr catch { handler }` via Feature dispatch.
    pub(crate) fn infer_catch_feature_type(&self, fe: &FeatureExpr) -> Type {
        feature_check!(self, fe, CatchData, |data| self.infer_catch_type(&data.expr))
    }

    /// Infer the type of `expr catch { handler }`.
    pub(crate) fn infer_catch_type(&self, expr: &Expr) -> Type {
        let et = self.infer_type(expr);
        match &et {
            Type::Result(ok, _) => {
                let ok_type = *ok.clone();
                if matches!(ok_type, Type::Unknown) {
                    // Use handler type — but we don't have handler here, return ok
                    ok_type
                } else {
                    ok_type
                }
            }
            _ => et,
        }
    }

    /// Infer the type of `expr?` via Feature dispatch.
    pub(crate) fn infer_error_propagate_feature_type(&self, fe: &FeatureExpr) -> Type {
        feature_check!(self, fe, ErrorPropagateData, |data| self.infer_error_propagate_type(&data.operand))
    }

    /// Infer the type of `expr?` — error propagation.
    pub(crate) fn infer_error_propagate_type(&self, operand: &Expr) -> Type {
        let ot = self.infer_type(operand);
        match &ot {
            Type::Result(ok, _) => *ok.clone(),
            _ => ot,
        }
    }
}
