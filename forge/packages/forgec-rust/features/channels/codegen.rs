use inkwell::values::BasicValueEnum;

use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::feature_codegen;
use crate::parser::ast::*;

use super::types::{ChannelReceiveData, ChannelSendData};

impl<'ctx> Codegen<'ctx> {
    /// Compile a channel expression via the Feature dispatch system.
    pub(crate) fn compile_channel_feature(
        &mut self,
        fe: &FeatureExpr,
    ) -> Option<BasicValueEnum<'ctx>> {
        match fe.kind {
            "ChannelSend" => feature_codegen!(self, fe, ChannelSendData, |data| self.compile_channel_send(&data.channel, &data.value)),
            "ChannelReceive" => feature_codegen!(self, fe, ChannelReceiveData, |data| self.compile_channel_receive(&data.channel)),
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
        // Check if target is a channel (int) or a component (struct with .send())
        let target_type = self.infer_type(channel);
        if let crate::typeck::types::Type::Struct { .. } = &target_type {
            // Component send: desugar `target <- value` to `target.send(value)`
            return self.compile_method_call(
                channel,
                "send",
                &[CallArg { name: None, value: value.clone() }],
                &[],
            );
        }

        // Channel is an int (channel ID), value needs to be stringified
        let ch_val = self.compile_expr(channel)?;
        let ch_id = if ch_val.is_int_value() {
            ch_val.into_int_value()
        } else {
            // Fallback: try .send() method call for any non-int target
            return self.compile_method_call(
                channel,
                "send",
                &[CallArg { name: None, value: value.clone() }],
                &[],
            );
        };

        // Stringify the value - convert to ForgeString, then to C ptr for extern fn
        let val_compiled = self.compile_expr(value)?;
        let val_string = self.value_to_cstring_ptr(val_compiled, value);

        // Call forge_channel_send(id, data_ptr)
        self.call_runtime_expect(
            "forge_channel_send", &[ch_id.into(), val_string.into()], "send",
            "forge_channel_send not declared - did you `use @std.channel`?",
        );
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
        let raw_ptr = self.call_runtime_expect(
            "forge_channel_receive", &[ch_id.into()], "recv",
            "forge_channel_receive not declared - did you `use @std.channel`?",
        )?;

        // Convert ptr to ForgeString: strlen(ptr) + forge_string_new(ptr, len)
        let len = self.call_runtime("strlen", &[raw_ptr.into()], "len")?;
        let forge_str = self.call_runtime("forge_string_new", &[raw_ptr.into(), len.into()], "str")?;
        Some(forge_str)
    }

    /// Dispatch channel method calls (close, drain). Called from core dispatch.
    pub(crate) fn dispatch_channel_method(
        &mut self,
        obj_val: inkwell::values::BasicValueEnum<'ctx>,
        method: &str,
    ) -> Option<inkwell::values::BasicValueEnum<'ctx>> {
        let fn_name = match method {
            "close" => "forge_channel_close",
            "drain" => "forge_channel_drain",
            _ => return None,
        };
        if let Some(func) = self.module.get_function(fn_name) {
            let result = self.builder.build_call(func, &[obj_val.into()], method).unwrap();
            result.try_as_basic_value().left()
        } else {
            None
        }
    }
}
