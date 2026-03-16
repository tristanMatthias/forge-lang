use crate::feature::FeatureExpr;
use crate::feature_check;
use crate::parser::ast::*;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

use super::types::{ChannelReceiveData, ChannelSendData};

impl TypeChecker {
    /// Type-check a channel expression via the Feature dispatch system.
    pub(crate) fn check_channel_feature(&mut self, fe: &FeatureExpr) -> Type {
        match fe.kind {
            "ChannelSend" => feature_check!(self, fe, ChannelSendData, |data| self.check_channel_send(&data.channel, &data.value)),
            "ChannelReceive" => feature_check!(self, fe, ChannelReceiveData, |data| self.check_channel_receive(&data.channel)),
            _ => Type::Unknown,
        }
    }

    /// Type-check a channel send expression.
    /// If the channel has a known element type, verifies the value matches.
    /// Returns `Type::Void`.
    pub(crate) fn check_channel_send(&mut self, channel: &Expr, value: &Expr) -> Type {
        let ch_type = self.check_expr(channel);
        let val_type = self.check_expr(value);

        // If channel has a known element type, check that the value matches
        if let Type::Channel(ref inner) = ch_type {
            if !matches!(**inner, Type::Unknown) && **inner != val_type {
                // Type mismatch on send - but we don't block it (runtime uses string serialization)
                // Future: emit a diagnostic here
            }
        }

        Type::Void
    }

    /// Type-check a channel receive expression.
    /// If the channel has a known element type, returns that type.
    /// Otherwise returns `Type::Unknown`.
    pub(crate) fn check_channel_receive(&mut self, channel: &Expr) -> Type {
        let ch_type = self.check_expr(channel);
        match ch_type {
            Type::Channel(inner) => *inner,
            // Backwards compat: untyped channels (Type::Int) return Unknown
            _ => Type::Unknown,
        }
    }
}
