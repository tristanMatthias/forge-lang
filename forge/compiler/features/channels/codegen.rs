use inkwell::values::BasicValueEnum;

use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::feature_data;
use crate::parser::ast::*;

use super::types::{ChannelReceiveData, ChannelSendData};

impl<'ctx> Codegen<'ctx> {
    /// Compile a channel expression via the Feature dispatch system.
    pub(crate) fn compile_channel_feature(
        &mut self,
        fe: &FeatureExpr,
    ) -> Option<BasicValueEnum<'ctx>> {
        match fe.kind {
            "ChannelSend" => {
                if let Some(data) = feature_data!(fe, ChannelSendData) {
                    self.compile_channel_send(&data.channel, &data.value)
                } else {
                    None
                }
            }
            "ChannelReceive" => {
                if let Some(data) = feature_data!(fe, ChannelReceiveData) {
                    self.compile_channel_receive(&data.channel)
                } else {
                    None
                }
            }
            _ => None,
        }
    }

    /// Compile a channel send expression: `ch <- val`
    ///
    /// The channel is an int (channel ID). The value is stringified to a C pointer
    /// and passed to `forge_channel_send(id, data_ptr)`.
    pub(crate) fn compile_channel_send(
        &mut self,
        channel: &Expr,
        value: &Expr,
    ) -> Option<BasicValueEnum<'ctx>> {
        // Channel is an int (channel ID), value needs to be stringified
        let ch_val = self.compile_expr(channel)?;
        let ch_id = if ch_val.is_int_value() {
            ch_val.into_int_value()
        } else {
            return None;
        };

        // Stringify the value - convert to ForgeString, then to C ptr for extern fn
        let val_compiled = self.compile_expr(value)?;
        let val_string = self.value_to_cstring_ptr(val_compiled, value);

        // Call forge_channel_send(id, data_ptr)
        let send_fn = self.module.get_function("forge_channel_send")
            .expect("forge_channel_send not declared - did you `use @std.channel`?");
        let send_args = [ch_id.into(), val_string.into()];
        self.builder.build_call(send_fn, &send_args, "send").unwrap();
        None
    }

    /// Compile a channel receive expression: `<- ch`
    ///
    /// Calls `forge_channel_receive(id)` which returns a raw C string pointer,
    /// then converts the result to a ForgeString via `strlen` + `forge_string_new`.
    pub(crate) fn compile_channel_receive(
        &mut self,
        channel: &Expr,
    ) -> Option<BasicValueEnum<'ctx>> {
        let ch_val = self.compile_expr(channel)?;
        let ch_id = if ch_val.is_int_value() {
            ch_val.into_int_value()
        } else {
            return None;
        };

        // Call forge_channel_receive(id) -> ptr (C string)
        let recv_fn = self.module.get_function("forge_channel_receive")
            .expect("forge_channel_receive not declared - did you `use @std.channel`?");
        let result = self.builder.build_call(recv_fn, &[ch_id.into()], "recv").unwrap();
        let raw_ptr = result.try_as_basic_value().left()?;

        // Convert ptr to ForgeString: strlen(ptr) + forge_string_new(ptr, len)
        let strlen_fn = self.module.get_function("strlen").unwrap();
        let len = self.builder.build_call(strlen_fn, &[raw_ptr.into()], "len").unwrap()
            .try_as_basic_value().left()?.into_int_value();
        let string_new = self.module.get_function("forge_string_new").unwrap();
        let forge_str = self.builder.build_call(string_new, &[raw_ptr.into(), len.into()], "str").unwrap()
            .try_as_basic_value().left()?;
        Some(forge_str)
    }
}
