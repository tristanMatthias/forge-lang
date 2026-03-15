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

impl crate::feature::FeatureNode for TaggedTemplateData {
    fn as_any(&self) -> &dyn std::any::Any { self }
    fn clone_box(&self) -> Box<dyn crate::feature::FeatureNode> { Box::new(self.clone()) }
    fn substitute_exprs(&self, fns: &crate::feature::SubFns) -> Box<dyn crate::feature::FeatureNode> {
        Box::new(TaggedTemplateData {
            tag: (fns.sub_ident)(&self.tag),
            parts: self.parts.iter().map(|p| match p {
                TemplatePart::Literal(s) => TemplatePart::Literal((fns.sub_ident)(s)),
                TemplatePart::Expr(e) => TemplatePart::Expr(Box::new((fns.sub_expr)(e))),
            }).collect(),
            type_param: self.type_param.clone(),
        })
    }
}

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
