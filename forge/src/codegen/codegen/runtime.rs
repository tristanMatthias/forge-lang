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

        // forge_string_trim(ForgeString) -> ForgeString
        let fn_type = string_type.fn_type(&[string_type.into()], false);
        self.module.add_function("forge_string_trim", fn_type, None);

        // forge_string_contains(ForgeString, ForgeString) -> i8
        let fn_type = i8_type.fn_type(&[string_type.into(), string_type.into()], false);
        self.module.add_function("forge_string_contains", fn_type, None);

        // forge_string_eq(ForgeString, ForgeString) -> i8
        let fn_type = i8_type.fn_type(&[string_type.into(), string_type.into()], false);
        self.module.add_function("forge_string_eq", fn_type, None);

        // forge_list_to_json(ptr, i64) -> ForgeString
        let fn_type = string_type.fn_type(&[ptr_type.into(), i64_type.into()], false);
        self.module.add_function("forge_list_to_json", fn_type, None);

        // forge_rc_retain(ptr)
        let fn_type = void_type.fn_type(&[ptr_type.into()], false);
        self.module.add_function("forge_rc_retain", fn_type, None);

        // forge_rc_release(ptr)
        let fn_type = void_type.fn_type(&[ptr_type.into()], false);
        self.module.add_function("forge_rc_release", fn_type, None);

        // forge_alloc(i64) -> ptr
        let fn_type = ptr_type.fn_type(&[i64_type.into()], false);
        self.module.add_function("forge_alloc", fn_type, None);

        // forge_spawn(fn_ptr)
        let fn_type = void_type.fn_type(&[ptr_type.into()], false);
        self.module.add_function("forge_spawn", fn_type, None);

        // forge_sleep_ms(i64)
        let fn_type = void_type.fn_type(&[i64_type.into()], false);
        self.module.add_function("forge_sleep_ms", fn_type, None);

        // strlen(ptr) -> i64 (for string conversion from extern ptr)
        if self.module.get_function("strlen").is_none() {
            let fn_type = i64_type.fn_type(&[ptr_type.into()], false);
            self.module.add_function("strlen", fn_type, None);
        }
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

        // snprintf - for JSON serialization
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

        // Assert function
        if self.module.get_function("forge_assert").is_none() {
            let ft = void_type.fn_type(&[i8_type.into(), ptr_type.into(), i64_type.into()], false);
            self.module.add_function("forge_assert", ft, None);
        }
    }
}
