use super::*;

impl<'ctx> Codegen<'ctx> {
    pub(crate) fn declare_runtime_functions(&mut self) {
        let i64_type = self.context.i64_type();
        let f64_type = self.context.f64_type();
        let i8_type = self.context.i8_type();
        let void_type = self.context.void_type();
        let ptr_type = self.context.ptr_type(AddressSpace::default());
        let string_type = self.string_type();

        // forge_println_string(ForgeString)
        let fn_type = void_type.fn_type(&[string_type.into()], false);
        self.module.add_function("forge_println_string", fn_type, None);

        // forge_println_int(i64)
        let fn_type = void_type.fn_type(&[i64_type.into()], false);
        self.module.add_function("forge_println_int", fn_type, None);

        // forge_println_float(f64)
        let fn_type = void_type.fn_type(&[f64_type.into()], false);
        self.module.add_function("forge_println_float", fn_type, None);

        // forge_println_bool(i8)
        let fn_type = void_type.fn_type(&[i8_type.into()], false);
        self.module.add_function("forge_println_bool", fn_type, None);

        // forge_print_string(ForgeString)
        let fn_type = void_type.fn_type(&[string_type.into()], false);
        self.module.add_function("forge_print_string", fn_type, None);

        // forge_print_int(i64)
        let fn_type = void_type.fn_type(&[i64_type.into()], false);
        self.module.add_function("forge_print_int", fn_type, None);

        // forge_print_float(f64)
        let fn_type = void_type.fn_type(&[f64_type.into()], false);
        self.module.add_function("forge_print_float", fn_type, None);

        // forge_print_bool(i8)
        let fn_type = void_type.fn_type(&[i8_type.into()], false);
        self.module.add_function("forge_print_bool", fn_type, None);

        // forge_string_new(ptr, i64) -> ForgeString
        let fn_type = string_type.fn_type(&[ptr_type.into(), i64_type.into()], false);
        self.module.add_function("forge_string_new", fn_type, None);

        // forge_string_concat(ForgeString, ForgeString) -> ForgeString
        let fn_type = string_type.fn_type(&[string_type.into(), string_type.into()], false);
        self.module.add_function("forge_string_concat", fn_type, None);

        // forge_int_to_string(i64) -> ForgeString
        let fn_type = string_type.fn_type(&[i64_type.into()], false);
        self.module.add_function("forge_int_to_string", fn_type, None);

        // forge_float_to_string(f64) -> ForgeString
        let fn_type = string_type.fn_type(&[f64_type.into()], false);
        self.module.add_function("forge_float_to_string", fn_type, None);

        // forge_bool_to_string(i8) -> ForgeString
        let fn_type = string_type.fn_type(&[i8_type.into()], false);
        self.module.add_function("forge_bool_to_string", fn_type, None);

        // forge_string_length(ForgeString) -> i64
        let fn_type = i64_type.fn_type(&[string_type.into()], false);
        self.module.add_function("forge_string_length", fn_type, None);

        // forge_string_upper(ForgeString) -> ForgeString
        let fn_type = string_type.fn_type(&[string_type.into()], false);
        self.module.add_function("forge_string_upper", fn_type, None);

        // forge_string_lower(ForgeString) -> ForgeString
        let fn_type = string_type.fn_type(&[string_type.into()], false);
        self.module.add_function("forge_string_lower", fn_type, None);

        // forge_string_contains(ForgeString, ForgeString) -> i8
        let fn_type = i8_type.fn_type(&[string_type.into(), string_type.into()], false);
        self.module.add_function("forge_string_contains", fn_type, None);

        // forge_string_eq(ForgeString, ForgeString) -> i8
        let fn_type = i8_type.fn_type(&[string_type.into(), string_type.into()], false);
        self.module.add_function("forge_string_eq", fn_type, None);

        // forge_rc_retain(ptr)
        let fn_type = void_type.fn_type(&[ptr_type.into()], false);
        self.module.add_function("forge_rc_retain", fn_type, None);

        // forge_rc_release(ptr)
        let fn_type = void_type.fn_type(&[ptr_type.into()], false);
        self.module.add_function("forge_rc_release", fn_type, None);

        // forge_alloc(i64) -> ptr
        let fn_type = ptr_type.fn_type(&[i64_type.into()], false);
        self.module.add_function("forge_alloc", fn_type, None);
    }

    /// Declare helper/utility functions needed by the provider codegen.
    /// The core provider functions (forge_model_*, forge_http_*) are now declared
    /// via extern fn statements from provider.fg files, loaded by the driver.
    /// This method declares runtime helpers (JSON parsing, body extraction, etc.)
    /// and any provider functions not yet declared by extern fn (fallback).
    pub(crate) fn declare_provider_functions(&mut self) {
        let i64_type = self.context.i64_type();
        let i32_type = self.context.i32_type();
        let i8_type = self.context.i8_type();
        let void_type = self.context.void_type();
        let ptr_type = self.context.ptr_type(AddressSpace::default());
        let string_type = self.string_type();

        if self.uses_model {
            // Fallback: declare core model functions if not already declared via extern fn
            if self.module.get_function("forge_model_init").is_none() {
                let ft = void_type.fn_type(&[ptr_type.into()], false);
                self.module.add_function("forge_model_init", ft, None);
            }
            if self.module.get_function("forge_model_exec").is_none() {
                let ft = i32_type.fn_type(&[ptr_type.into()], false);
                self.module.add_function("forge_model_exec", ft, None);
            }
            if self.module.get_function("forge_model_insert").is_none() {
                let ft = i64_type.fn_type(&[ptr_type.into(), ptr_type.into(), i64_type.into()], false);
                self.module.add_function("forge_model_insert", ft, None);
            }
            if self.module.get_function("forge_model_update").is_none() {
                let ft = i64_type.fn_type(&[ptr_type.into(), ptr_type.into(), i64_type.into()], false);
                self.module.add_function("forge_model_update", ft, None);
            }
            if self.module.get_function("forge_model_query").is_none() {
                let ft = ptr_type.fn_type(&[ptr_type.into(), ptr_type.into(), i64_type.into()], false);
                self.module.add_function("forge_model_query", ft, None);
            }
            if self.module.get_function("forge_model_count").is_none() {
                let ft = i64_type.fn_type(&[ptr_type.into()], false);
                self.module.add_function("forge_model_count", ft, None);
            }
            if self.module.get_function("forge_model_free_string").is_none() {
                let ft = void_type.fn_type(&[ptr_type.into()], false);
                self.module.add_function("forge_model_free_string", ft, None);
            }

            // JSON parsing functions from runtime.c (always needed for model codegen)
            if self.module.get_function("forge_json_array_count").is_none() {
                let ft = i64_type.fn_type(&[ptr_type.into()], false);
                self.module.add_function("forge_json_array_count", ft, None);
            }
            if self.module.get_function("forge_json_get_string").is_none() {
                let ft = string_type.fn_type(&[ptr_type.into(), i64_type.into(), ptr_type.into()], false);
                self.module.add_function("forge_json_get_string", ft, None);
            }
            if self.module.get_function("forge_json_get_int").is_none() {
                let ft = i64_type.fn_type(&[ptr_type.into(), i64_type.into(), ptr_type.into()], false);
                self.module.add_function("forge_json_get_int", ft, None);
            }
            if self.module.get_function("forge_json_get_bool").is_none() {
                let ft = i8_type.fn_type(&[ptr_type.into(), i64_type.into(), ptr_type.into()], false);
                self.module.add_function("forge_json_get_bool", ft, None);
            }
        }

        if self.uses_http {
            // Fallback: declare core HTTP functions if not already declared via extern fn
            if self.module.get_function("forge_http_add_route").is_none() {
                let ft = void_type.fn_type(&[ptr_type.into(), ptr_type.into(), ptr_type.into()], false);
                self.module.add_function("forge_http_add_route", ft, None);
            }
            if self.module.get_function("forge_http_serve").is_none() {
                let i16_type = self.context.i16_type();
                let ft = void_type.fn_type(&[i16_type.into()], false);
                self.module.add_function("forge_http_serve", ft, None);
            }

            // JSON/body helpers from runtime.c
            if self.module.get_function("forge_params_get").is_none() {
                let ft = string_type.fn_type(&[ptr_type.into(), ptr_type.into()], false);
                self.module.add_function("forge_params_get", ft, None);
            }
            if self.module.get_function("forge_body_get_string").is_none() {
                let ft = ptr_type.fn_type(&[ptr_type.into(), ptr_type.into()], false);
                self.module.add_function("forge_body_get_string", ft, None);
            }
            if self.module.get_function("forge_body_get_int_str").is_none() {
                let ft = ptr_type.fn_type(&[ptr_type.into(), ptr_type.into()], false);
                self.module.add_function("forge_body_get_int_str", ft, None);
            }
            if self.module.get_function("forge_body_get_bool_str").is_none() {
                let ft = ptr_type.fn_type(&[ptr_type.into(), ptr_type.into()], false);
                self.module.add_function("forge_body_get_bool_str", ft, None);
            }
            if self.module.get_function("forge_body_has_field").is_none() {
                let ft = i8_type.fn_type(&[ptr_type.into(), ptr_type.into()], false);
                self.module.add_function("forge_body_has_field", ft, None);
            }
            if self.module.get_function("forge_json_unwrap_first").is_none() {
                let ft = i64_type.fn_type(&[ptr_type.into(), ptr_type.into(), i64_type.into()], false);
                self.module.add_function("forge_json_unwrap_first", ft, None);
            }
            if self.module.get_function("forge_json_fix_bools").is_none() {
                let ft = ptr_type.fn_type(&[ptr_type.into(), ptr_type.into()], false);
                self.module.add_function("forge_json_fix_bools", ft, None);
            }
            if self.module.get_function("free").is_none() {
                let ft = void_type.fn_type(&[ptr_type.into()], false);
                self.module.add_function("free", ft, None);
            }
        }

        // Assert function
        if self.module.get_function("forge_assert").is_none() {
            let ft = void_type.fn_type(&[i8_type.into(), ptr_type.into(), i64_type.into()], false);
            self.module.add_function("forge_assert", ft, None);
        }

        // snprintf - for building SQL
        if self.module.get_function("snprintf").is_none() {
            let ft = i32_type.fn_type(&[ptr_type.into(), i64_type.into(), ptr_type.into()], true);
            self.module.add_function("snprintf", ft, None);
        }

        // forge_write_cstring
        if self.module.get_function("forge_write_cstring").is_none() {
            let ft = void_type.fn_type(&[ptr_type.into(), i64_type.into(), ptr_type.into(), i64_type.into()], false);
            self.module.add_function("forge_write_cstring", ft, None);
        }
    }
}
