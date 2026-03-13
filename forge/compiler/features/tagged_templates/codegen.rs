use inkwell::values::BasicValueEnum;

use crate::codegen::codegen::Codegen;
use crate::parser::ast::*;
use crate::typeck::types::Type;

impl<'ctx> Codegen<'ctx> {
    /// Compile a tagged template literal: `tag\`template ${expr}\``
    ///
    /// Builds a JSON string with the structure:
    /// `{"parts":["literal1","literal2",...],"values":["val1","val2",...]}`
    ///
    /// Then calls the tag function with this JSON string as the sole argument.
    /// The tag function can be an extern fn from a provider or a user-defined function.
    pub(crate) fn compile_tagged_template(
        &mut self,
        tag: &str,
        parts: &[TemplatePart],
    ) -> Option<BasicValueEnum<'ctx>> {
        let concat_fn = self.module.get_function("forge_string_concat").unwrap();

        // Build the JSON: {"parts":[...], "values":[...]}
        let mut json = self.build_string_literal("{\"parts\":[");

        // Collect literal parts and compile expression values
        let mut literals: Vec<BasicValueEnum<'ctx>> = Vec::new();
        let mut values: Vec<BasicValueEnum<'ctx>> = Vec::new();
        let mut current_literal = String::new();

        for part in parts {
            match part {
                TemplatePart::Literal(s) => {
                    current_literal.push_str(s);
                }
                TemplatePart::Expr(expr) => {
                    literals.push(self.build_string_literal(&json_escape_string(&current_literal)));
                    current_literal.clear();

                    let val = self.compile_expr(expr)?;
                    let expr_type = self.infer_type(expr);
                    // value_to_string returns None for non-stringifiable types
                    // (enums, structs, etc.) — use a placeholder to avoid ICE
                    let str_val = self.value_to_string(val, &expr_type)
                        .unwrap_or_else(|| self.build_string_literal("<unsupported>"));
                    values.push(str_val);
                }
            }
        }
        literals.push(self.build_string_literal(&json_escape_string(&current_literal)));

        // Build parts array JSON: "literal1","literal2",...
        for (i, lit) in literals.iter().enumerate() {
            let quote = self.build_string_literal("\"");
            json = self.builder.build_call(concat_fn, &[json.into(), quote.into()], "c")
                .unwrap().try_as_basic_value().left().unwrap();

            json = self.builder.build_call(concat_fn, &[json.into(), (*lit).into()], "c")
                .unwrap().try_as_basic_value().left().unwrap();

            let suffix = if i < literals.len() - 1 { "\"," } else { "\"" };
            let s = self.build_string_literal(suffix);
            json = self.builder.build_call(concat_fn, &[json.into(), s.into()], "c")
                .unwrap().try_as_basic_value().left().unwrap();
        }

        // Add ],values:[
        let mid = self.build_string_literal("],\"values\":[");
        json = self.builder.build_call(concat_fn, &[json.into(), mid.into()], "c")
            .unwrap().try_as_basic_value().left().unwrap();

        // Build values array JSON
        for (i, val) in values.iter().enumerate() {
            let quote = self.build_string_literal("\"");
            json = self.builder.build_call(concat_fn, &[json.into(), quote.into()], "c")
                .unwrap().try_as_basic_value().left().unwrap();

            let escaped = self.call_json_escape(*val);
            json = self.builder.build_call(concat_fn, &[json.into(), escaped.into()], "c")
                .unwrap().try_as_basic_value().left().unwrap();

            let suffix = if i < values.len() - 1 { "\"," } else { "\"" };
            let s = self.build_string_literal(suffix);
            json = self.builder.build_call(concat_fn, &[json.into(), s.into()], "c")
                .unwrap().try_as_basic_value().left().unwrap();
        }

        // Close: ]}
        let close = self.build_string_literal("]}");
        json = self.builder.build_call(concat_fn, &[json.into(), close.into()], "c")
            .unwrap().try_as_basic_value().left().unwrap();

        // Call the tag function with the JSON string
        self.call_tag_function(tag, json)
    }

    /// Resolve and call the tag function, handling extern fns, Forge fns, and fallbacks.
    fn call_tag_function(
        &mut self,
        tag: &str,
        json: BasicValueEnum<'ctx>,
    ) -> Option<BasicValueEnum<'ctx>> {
        let ptr_type = self.context.ptr_type(inkwell::AddressSpace::default());

        // 1. Check if the function is already declared in the LLVM module
        if let Some(func) = self.module.get_function(tag) {
            let param_count = func.count_params();

            if param_count != 1 {
                // Wrong param count — type checker should have caught this.
                // Return the JSON as-is to avoid crashing codegen.
                return Some(json);
            }

            let param_type = func.get_type().get_param_types()[0];

            if param_type == ptr_type.into() {
                // Extern fn (C ABI): takes raw ptr
                return self.call_extern_tag(func, json);
            } else {
                // Forge fn: takes ForgeString directly
                let result = self.builder.build_call(func, &[json.into()], "tagged_result")
                    .unwrap();
                return result.try_as_basic_value().left();
            }
        }

        // 2. Check if it's a variable in scope (closure / fn ptr)
        if let Some((_alloca, ty)) = self.lookup_var(tag) {
            match ty {
                Type::Function { return_type, .. } => {
                    let (alloca, _) = self.lookup_var(tag).unwrap();
                    let fn_ptr = self.builder.build_load(
                        ptr_type,
                        alloca,
                        "tag_fn",
                    ).unwrap().into_pointer_value();

                    let str_type = self.string_type();
                    let ret_llvm = self.type_to_llvm_basic(&return_type);
                    let fn_type = match ret_llvm {
                        inkwell::types::BasicTypeEnum::IntType(t) => t.fn_type(&[str_type.into()], false),
                        inkwell::types::BasicTypeEnum::FloatType(t) => t.fn_type(&[str_type.into()], false),
                        inkwell::types::BasicTypeEnum::StructType(t) => t.fn_type(&[str_type.into()], false),
                        inkwell::types::BasicTypeEnum::PointerType(t) => t.fn_type(&[str_type.into()], false),
                        inkwell::types::BasicTypeEnum::ArrayType(t) => t.fn_type(&[str_type.into()], false),
                        inkwell::types::BasicTypeEnum::VectorType(t) => t.fn_type(&[str_type.into()], false),
                    };

                    let result = self.builder.build_indirect_call(
                        fn_type, fn_ptr, &[json.into()], "tagged_result"
                    ).unwrap();
                    return result.try_as_basic_value().left();
                }
                _ => {
                    // Non-function variable — type checker should have caught this.
                    // Return the JSON as-is to avoid crashing codegen.
                    return Some(json);
                }
            }
        }

        // 3. Not found anywhere — declare as extern fn (late binding for providers)
        let fn_type = ptr_type.fn_type(&[ptr_type.into()], false);
        let func = self.module.add_function(tag, fn_type, None);
        self.call_extern_tag(func, json)
    }

    /// Call an extern fn (C ABI) that takes ptr and returns ptr, wrapping result as ForgeString.
    fn call_extern_tag(
        &mut self,
        func: inkwell::values::FunctionValue<'ctx>,
        json: BasicValueEnum<'ctx>,
    ) -> Option<BasicValueEnum<'ctx>> {
        let ptr_type = self.context.ptr_type(inkwell::AddressSpace::default());

        let ptr = self.builder.build_extract_value(
            json.into_struct_value(), 0, "json_ptr"
        ).unwrap();
        let result = self.builder.build_call(func, &[ptr.into()], "tagged_result")
            .unwrap();

        if let Some(ret) = result.try_as_basic_value().left() {
            if ret.is_pointer_value() {
                // Convert ptr return to ForgeString
                let raw_ptr = ret.into_pointer_value();
                let strlen_fn = self.module.get_function("strlen").unwrap_or_else(|| {
                    let ft = self.context.i64_type().fn_type(&[ptr_type.into()], false);
                    self.module.add_function("strlen", ft, None)
                });
                let len = self.builder.build_call(strlen_fn, &[raw_ptr.into()], "slen")
                    .unwrap().try_as_basic_value().left().unwrap();
                let str_new_fn = self.module.get_function("forge_string_new").unwrap();
                let forge_str = self.builder.build_call(
                    str_new_fn, &[raw_ptr.into(), len.into()], "tagged_str"
                ).unwrap().try_as_basic_value().left()?;
                Some(forge_str)
            } else {
                Some(ret)
            }
        } else {
            None
        }
    }

    /// Call forge_json_escape to escape a string value for JSON embedding
    fn call_json_escape(&mut self, val: BasicValueEnum<'ctx>) -> BasicValueEnum<'ctx> {
        let ptr_type = self.context.ptr_type(inkwell::AddressSpace::default());

        let escape_fn = self.module.get_function("forge_json_escape").unwrap_or_else(|| {
            let ft = ptr_type.fn_type(&[ptr_type.into(), self.context.i64_type().into()], false);
            self.module.add_function("forge_json_escape", ft, None)
        });

        let str_val = val.into_struct_value();
        let str_ptr = self.builder.build_extract_value(str_val, 0, "esc_ptr").unwrap();
        let str_len = self.builder.build_extract_value(str_val, 1, "esc_len").unwrap();

        let result = self.builder.build_call(
            escape_fn, &[str_ptr.into(), str_len.into()], "escaped"
        ).unwrap().try_as_basic_value().left().unwrap();
        let escaped_ptr = result.into_pointer_value();

        let strlen_fn = self.module.get_function("strlen").unwrap_or_else(|| {
            let ft = self.context.i64_type().fn_type(&[ptr_type.into()], false);
            self.module.add_function("strlen", ft, None)
        });
        let len = self.builder.build_call(strlen_fn, &[escaped_ptr.into()], "elen")
            .unwrap().try_as_basic_value().left().unwrap();
        let str_new_fn = self.module.get_function("forge_string_new").unwrap();
        self.builder.build_call(
            str_new_fn, &[escaped_ptr.into(), len.into()], "escaped_str"
        ).unwrap().try_as_basic_value().left().unwrap()
    }

    /// Infer the type of a tagged template expression.
    pub(crate) fn infer_tagged_template_type(&self, tag: &str) -> Type {
        // Check type checker's function registry first (most accurate)
        if let Some(fn_ty) = self.type_checker.env.lookup_function(tag) {
            if let Type::Function { return_type, .. } = fn_ty {
                return *return_type.clone();
            }
        }
        if let Some(info) = self.type_checker.env.lookup(tag) {
            if let Type::Function { return_type, .. } = &info.ty {
                return *return_type.clone();
            }
        }
        // Fallback: assume string (extern fns, late-bound)
        Type::String
    }
}

/// Escape a string for JSON embedding at compile time (for literal parts).
fn json_escape_string(s: &str) -> String {
    let mut out = String::with_capacity(s.len());
    for c in s.chars() {
        match c {
            '"' => out.push_str("\\\""),
            '\\' => out.push_str("\\\\"),
            '\n' => out.push_str("\\n"),
            '\t' => out.push_str("\\t"),
            '\r' => out.push_str("\\r"),
            c if (c as u32) < 0x20 => {
                out.push_str(&format!("\\u{:04x}", c as u32));
            }
            c => out.push(c),
        }
    }
    out
}
