use crate::feature::FeatureExpr;
use crate::feature_data;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

use super::types::{ListLitData, MapLitData};

impl TypeChecker {
    /// Type-check a list literal expression via the Feature dispatch system.
    pub(crate) fn check_list_lit_feature(&mut self, fe: &FeatureExpr) -> Type {
        if let Some(data) = feature_data!(fe, ListLitData) {
            let elem_type = if let Some(first) = data.elements.first() {
                self.check_expr(first)
            } else {
                Type::Unknown
            };
            for elem in data.elements.iter().skip(1) {
                self.check_expr(elem);
            }
            Type::List(Box::new(elem_type))
        } else {
            Type::Unknown
        }
    }

    /// Type-check a map literal expression via the Feature dispatch system.
    pub(crate) fn check_map_lit_feature(&mut self, fe: &FeatureExpr) -> Type {
        if let Some(data) = feature_data!(fe, MapLitData) {
            let (key_type, val_type) = if let Some((k, v)) = data.entries.first() {
                (self.check_expr(k), self.check_expr(v))
            } else {
                (Type::Unknown, Type::Unknown)
            };
            Type::Map(Box::new(key_type), Box::new(val_type))
        } else {
            Type::Unknown
        }
    }
}
