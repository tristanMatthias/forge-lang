use crate::parser::ast::Expr;

/// AST data for a channel send expression: `ch <- value`.
#[derive(Debug, Clone)]
pub struct ChannelSendData {
    pub channel: Box<Expr>,
    pub value: Box<Expr>,
}

impl crate::feature::FeatureNode for ChannelSendData {
    fn as_any(&self) -> &dyn std::any::Any { self }
    fn clone_box(&self) -> Box<dyn crate::feature::FeatureNode> { Box::new(self.clone()) }
    fn substitute_exprs(&self, fns: &crate::feature::SubFns) -> Box<dyn crate::feature::FeatureNode> {
        Box::new(ChannelSendData {
            channel: Box::new((fns.sub_expr)(&self.channel)),
            value: Box::new((fns.sub_expr)(&self.value)),
        })
    }
}

/// AST data for a channel receive expression: `<- ch`.
#[derive(Debug, Clone)]
pub struct ChannelReceiveData {
    pub channel: Box<Expr>,
}

impl crate::feature::FeatureNode for ChannelReceiveData {
    fn as_any(&self) -> &dyn std::any::Any { self }
    fn clone_box(&self) -> Box<dyn crate::feature::FeatureNode> { Box::new(self.clone()) }
    fn substitute_exprs(&self, fns: &crate::feature::SubFns) -> Box<dyn crate::feature::FeatureNode> {
        Box::new(ChannelReceiveData {
            channel: Box::new((fns.sub_expr)(&self.channel)),
        })
    }
}
