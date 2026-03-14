use crate::parser::ast::Expr;

/// AST data for a channel send expression: `ch <- value`.
#[derive(Debug, Clone)]
pub struct ChannelSendData {
    pub channel: Box<Expr>,
    pub value: Box<Expr>,
}

crate::impl_feature_node!(ChannelSendData);

/// AST data for a channel receive expression: `<- ch`.
#[derive(Debug, Clone)]
pub struct ChannelReceiveData {
    pub channel: Box<Expr>,
}

crate::impl_feature_node!(ChannelReceiveData);
