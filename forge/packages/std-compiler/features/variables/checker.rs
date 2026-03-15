use crate::feature::FeatureStmt;
use crate::feature_data;
use crate::typeck::checker::TypeChecker;

use super::types::{LetDestructureData, VarDeclData, VarKind};

impl TypeChecker {
    /// Type-check a variable declaration (let/mut/const) via the Feature dispatch system.
    pub(crate) fn check_variables_feature(&mut self, fe: &FeatureStmt) {
        match fe.kind {
            "Let" | "Mut" | "Const" => {
                if let Some(data) = feature_data!(fe, VarDeclData) {
                    let val_type = self.check_expr(&data.value);
                    let ty = if let Some(ann) = &data.type_ann {
                        let ann_type = self.resolve_type_expr(ann);
                        self.check_type_mismatch_ctx(&ann_type, &val_type, fe.span, data.type_ann_span, Some(&data.value));
                        ann_type
                    } else {
                        val_type
                    };
                    let mutable = matches!(data.kind, VarKind::Mut);
                    self.env.define_with_span(data.name.clone(), ty, mutable, fe.span);
                }
            }
            "LetDestructure" => {
                if let Some(data) = feature_data!(fe, LetDestructureData) {
                    let val_type = self.check_expr(&data.value);
                    self.bind_destructure_pattern(&data.pattern, &val_type);
                }
            }
            _ => {}
        }
    }
}
