use crate::feature::FeatureExpr;
use crate::feature_data;
use crate::parser::ast::*;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

use super::types::SpawnData;

impl TypeChecker {
    /// Type-check a spawn block via the Feature dispatch system.
    /// Spawn blocks return `Type::Unknown` (they execute concurrently).
    pub(crate) fn check_spawn_feature(&mut self, fe: &FeatureExpr) -> Type {
        if let Some(data) = feature_data!(fe, SpawnData) {
            self.check_spawn_block(&data.body)
        } else {
            Type::Unknown
        }
    }

    /// Type-check a spawn block by checking its body.
    pub(crate) fn check_spawn_block(&mut self, body: &Block) -> Type {
        self.check_block(body);
        Type::Unknown
    }
}
