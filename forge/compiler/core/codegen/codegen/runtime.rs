use super::*;

impl<'ctx> Codegen<'ctx> {
    pub(crate) fn declare_runtime_functions(&mut self) {
        let i64_type = self.context.i64_type();
        let f64_type = self.context.f64_type();
        let i8_type = self.context.i8_type();
        let void_type = self.context.void_type();
        let ptr_type = self.context.ptr_type(AddressSpace::default());
        let string_type = self.string_type();

        macro_rules! rt {
            ($self:expr, $name:expr, $ret:expr, $($param:expr),*) => {
                let fn_type = $ret.fn_type(&[$($param.into()),*], false);
                $self.module.add_function($name, fn_type, None);
            };
        }

        // Print functions
        rt!(self, "forge_println_string", void_type, string_type);
        rt!(self, "forge_println_int", void_type, i64_type);
        rt!(self, "forge_println_float", void_type, f64_type);
        rt!(self, "forge_println_bool", void_type, i8_type);
        rt!(self, "forge_print_string", void_type, string_type);
        rt!(self, "forge_print_int", void_type, i64_type);
        rt!(self, "forge_print_float", void_type, f64_type);
        rt!(self, "forge_print_bool", void_type, i8_type);

        // String construction and manipulation
        rt!(self, "forge_string_new", string_type, ptr_type, i64_type);
        rt!(self, "forge_string_concat", string_type, string_type, string_type);
        rt!(self, "forge_int_to_string", string_type, i64_type);
        rt!(self, "forge_float_to_string", string_type, f64_type);
        rt!(self, "forge_bool_to_string", string_type, i8_type);
        rt!(self, "forge_string_length", i64_type, string_type);
        rt!(self, "forge_string_upper", string_type, string_type);
        rt!(self, "forge_string_lower", string_type, string_type);
        rt!(self, "forge_string_trim", string_type, string_type);
        rt!(self, "forge_string_contains", i8_type, string_type, string_type);
        rt!(self, "forge_string_starts_with", i8_type, string_type, string_type);
        rt!(self, "forge_string_ends_with", i8_type, string_type, string_type);
        rt!(self, "forge_string_replace", string_type, string_type, string_type, string_type);
        rt!(self, "forge_string_parse_int", i64_type, string_type);
        rt!(self, "forge_string_repeat", string_type, string_type, i64_type);
        rt!(self, "forge_string_eq", i8_type, string_type, string_type);

        // List helpers
        rt!(self, "forge_list_to_json", string_type, ptr_type, i64_type);
        rt!(self, "forge_list_int_to_json", string_type, ptr_type, i64_type);

        // Memory and concurrency
        rt!(self, "forge_rc_retain", void_type, ptr_type);
        rt!(self, "forge_rc_release", void_type, ptr_type);
        rt!(self, "forge_alloc", ptr_type, i64_type);
        rt!(self, "forge_spawn", void_type, ptr_type);
        rt!(self, "forge_sleep_ms", void_type, i64_type);

        // strlen(ptr) -> i64 (conditional — may already be declared)
        if self.module.get_function("strlen").is_none() {
            rt!(self, "strlen", i64_type, ptr_type);
        }

        // Validation helpers
        rt!(self, "forge_validate_email", i64_type, string_type);
        rt!(self, "forge_validate_url", i64_type, string_type);
        rt!(self, "forge_validate_uuid", i64_type, string_type);
        rt!(self, "forge_validate_pattern", i64_type, string_type, string_type);

        // Datetime
        rt!(self, "forge_datetime_now", i64_type,);
        rt!(self, "forge_process_uptime", i64_type,);
        rt!(self, "forge_datetime_format", string_type, i64_type);
        rt!(self, "forge_datetime_parse", i64_type, ptr_type, i64_type);

        // Query comparison helpers
        for name in &["forge_query_gt", "forge_query_gte", "forge_query_lt", "forge_query_lte"] {
            rt!(self, *name, string_type, i64_type);
        }
        rt!(self, "forge_query_between", string_type, i64_type, i64_type);
        rt!(self, "forge_query_like", string_type, string_type);
    }

    /// Declare helper/utility functions needed by codegen.
    /// Core provider functions (forge_model_*, forge_http_*) are declared via
    /// extern fn statements from provider.fg files, loaded by the driver.
    /// This method only declares runtime helpers used by route/JSON codegen.
    pub(crate) fn declare_provider_functions(&mut self) {
        let i64_type = self.context.i64_type();
        let i32_type = self.context.i32_type();
        let i8_type = self.context.i8_type();
        let void_type = self.context.void_type();
        let ptr_type = self.context.ptr_type(AddressSpace::default());

        // snprintf - variadic, can't use rt! macro
        if self.module.get_function("snprintf").is_none() {
            let ft = i32_type.fn_type(&[ptr_type.into(), i64_type.into(), ptr_type.into()], true);
            self.module.add_function("snprintf", ft, None);
        }

        // forge_write_cstring - copy ForgeString to C buffer
        if self.module.get_function("forge_write_cstring").is_none() {
            let ft = void_type.fn_type(&[ptr_type.into(), i64_type.into(), ptr_type.into(), i64_type.into()], false);
            self.module.add_function("forge_write_cstring", ft, None);
        }

        // atoll - C string to long long
        if self.module.get_function("atoll").is_none() {
            let ft = i64_type.fn_type(&[ptr_type.into()], false);
            self.module.add_function("atoll", ft, None);
        }

        // Assert function: forge_assert(cond: i8, msg: ptr, msg_len: i64, file: ptr, file_len: i64, line: i64, col: i64)
        if self.module.get_function("forge_assert").is_none() {
            let ft = void_type.fn_type(&[
                i8_type.into(), ptr_type.into(), i64_type.into(),
                ptr_type.into(), i64_type.into(),
                i64_type.into(), i64_type.into(),
            ], false);
            self.module.add_function("forge_assert", ft, None);
        }
    }
}
