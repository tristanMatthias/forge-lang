use crate::codegen::codegen::Codegen;
use crate::feature::FeatureStmt;
use crate::feature_data;

use super::types::{BreakData, LoopData, WhileData};

impl<'ctx> Codegen<'ctx> {
    /// Compile a while_loops feature statement via the Feature dispatch system.
    pub(crate) fn compile_while_loops_feature(&mut self, fe: &FeatureStmt) {
        match fe.kind {
            "While" => {
                if let Some(data) = feature_data!(fe, WhileData) {
                    self.compile_while(&data.condition, &data.body);
                }
            }
            "Loop" => {
                if let Some(data) = feature_data!(fe, LoopData) {
                    self.compile_loop(&data.body);
                }
            }
            "Break" => {
                if let Some(data) = feature_data!(fe, BreakData) {
                    self.compile_break(data.value.as_ref());
                }
            }
            "Continue" => {
                self.compile_continue();
            }
            _ => {}
        }
    }
}
