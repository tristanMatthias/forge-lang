use crate::feature::FeatureExpr;
use crate::feature_check;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

use super::types::NullThrowData;

impl TypeChecker {
    /// Type-check a null throw expression via Feature dispatch.
    /// If value is Nullable(T), the result type is T (unwrapped).
    pub(crate) fn check_null_throw_feature(&mut self, fe: &FeatureExpr) -> Type {
        feature_check!(self, fe, NullThrowData, |data| {
            let val_type = self.check_expr(&data.value);
            let _err_type = self.check_expr(&data.error);
            match val_type {
                Type::Nullable(inner) => *inner,
                other => other,
            }
        })
    }
}
