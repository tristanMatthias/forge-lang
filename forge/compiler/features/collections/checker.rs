use crate::feature::FeatureExpr;
use crate::feature_check;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

use super::types::{ListLitData, MapLitData};

impl TypeChecker {
    /// Type-check a list literal expression via the Feature dispatch system.
    pub(crate) fn check_list_lit_feature(&mut self, fe: &FeatureExpr) -> Type {
        feature_check!(self, fe, ListLitData, |data| {
            let elem_type = if let Some(first) = data.elements.first() {
                self.check_expr(first)
            } else {
                Type::Unknown
            };
            for elem in data.elements.iter().skip(1) {
                self.check_expr(elem);
            }
            Type::List(Box::new(elem_type))
        })
    }

    /// Type-check a map literal expression via the Feature dispatch system.
    pub(crate) fn check_map_lit_feature(&mut self, fe: &FeatureExpr) -> Type {
        feature_check!(self, fe, MapLitData, |data| {
            let (key_type, val_type) = if let Some((k, v)) = data.entries.first() {
                (self.check_expr(k), self.check_expr(v))
            } else {
                (Type::Unknown, Type::Unknown)
            };
            Type::Map(Box::new(key_type), Box::new(val_type))
        })
    }
}
