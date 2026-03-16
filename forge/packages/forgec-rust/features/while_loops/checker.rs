use crate::feature::FeatureStmt;
use crate::feature_data;
use crate::typeck::checker::TypeChecker;

use super::types::{BreakData, LoopData, WhileData};

impl TypeChecker {
    /// Type-check a while_loops feature statement via the Feature dispatch system.
    pub(crate) fn check_while_loops_feature(&mut self, fe: &FeatureStmt) {
        match fe.kind {
            "While" => {
                if let Some(data) = feature_data!(fe, WhileData) {
                    self.check_while(&data.condition, &data.body);
                }
            }
            "Loop" => {
                if let Some(data) = feature_data!(fe, LoopData) {
                    self.check_loop(&data.body);
                }
            }
            "Break" => {
                if let Some(data) = feature_data!(fe, BreakData) {
                    self.check_break(data.value.as_ref());
                }
            }
            "Continue" => {
                // No type checking needed for continue
            }
            _ => {}
        }
    }
}
