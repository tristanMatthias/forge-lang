use crate::feature::FeatureExpr;
use crate::feature_check;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

use super::types::SliceData;

impl TypeChecker {
    /// Type-check a slice expression via the Feature dispatch system.
    pub(crate) fn check_slice_feature(&mut self, fe: &FeatureExpr) -> Type {
        feature_check!(self, fe, SliceData, |data| {
            let obj_type = self.check_expr(&data.object);
            if let Some(ref s) = data.start {
                self.check_expr(s);
            }
            if let Some(ref e) = data.end {
                self.check_expr(e);
            }
            match &obj_type {
                Type::List(inner) => Type::List(inner.clone()),
                Type::String => Type::String,
                _ => Type::Unknown,
            }
        })
    }
}
