use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::feature_data;
use crate::parser::ast::{TemplatePart, TypeExpr};
use crate::typeck::types::Type;

/// AST data for a tagged template literal: `tag\`template ${expr}\``
#[derive(Debug, Clone)]
pub struct TaggedTemplateData {
    pub tag: String,
    pub parts: Vec<TemplatePart>,
    pub type_param: Option<TypeExpr>,
}

crate::impl_feature_node!(TaggedTemplateData);

impl<'ctx> Codegen<'ctx> {
    /// Infer the type of a tagged template via the Feature dispatch system.
    pub(crate) fn infer_tagged_template_feature_type(&self, fe: &FeatureExpr) -> Type {
        if let Some(data) = feature_data!(fe, TaggedTemplateData) {
            if let Some(tp) = &data.type_param {
                self.type_checker.resolve_type_expr(tp)
            } else {
                self.infer_tagged_template_type(&data.tag)
            }
        } else {
            Type::Unknown
        }
    }
}
