use super::*;

impl<'ctx> Codegen<'ctx> {
    pub(crate) fn build_string_literal(&mut self, s: &str) -> BasicValueEnum<'ctx> {
        let str_val = self.builder.build_global_string_ptr(s, "str").unwrap();
        let len = self.context.i64_type().const_int(s.len() as u64, false);
        self.call_runtime("forge_string_new", &[str_val.as_pointer_value().into(), len.into()], "str").unwrap()
    }

    pub(crate) fn compile_enum_constructor(
        &mut self,
        _enum_name: &str,
        variant_name: &str,
        args: &[CallArg],
        variants: &[crate::typeck::types::EnumVariantType],
    ) -> Option<BasicValueEnum<'ctx>> {
        let variant_idx = variants.iter().position(|v| v.name == variant_name)?;
        let variant = &variants[variant_idx];

        // Use the canonical enum LLVM type (same for all variants)
        let enum_type = Type::Enum {
            name: _enum_name.to_string(),
            variants: variants.to_vec(),
        };
        let enum_llvm_type = self.type_to_llvm_basic(&enum_type);
        let enum_struct_type = enum_llvm_type.into_struct_type();

        // Alloca the enum, zero-initialize, set tag
        let enum_alloca = self.builder.build_alloca(enum_struct_type, "enum_tmp").unwrap();
        self.builder.build_store(enum_alloca, enum_struct_type.const_zero()).unwrap();

        // Set tag at index 0
        let tag_ptr = self.builder.build_struct_gep(
            enum_struct_type, enum_alloca, 0, "tag_ptr"
        ).unwrap();
        self.builder.build_store(tag_ptr, self.context.i8_type().const_int(variant_idx as u64, false)).unwrap();

        // Store fields via memory bitcast (like Result payload storage)
        // GEP to payload start (index 1) and bitcast to a struct of the variant's field types
        if !args.is_empty() && !variant.fields.is_empty() {
            let payload_ptr = self.builder.build_struct_gep(
                enum_struct_type, enum_alloca, 1, "payload_ptr"
            ).unwrap();

            // Build a struct type for this variant's fields
            // Boxed fields are stored as i64 (pointer-sized) instead of the recursive type
            let variant_field_types: Vec<inkwell::types::BasicTypeEnum<'ctx>> = variant.fields.iter()
                .enumerate()
                .map(|(i, (_, ty))| {
                    if variant.boxed_fields.contains(&i) {
                        self.context.i64_type().into()
                    } else {
                        self.type_to_llvm_basic(ty)
                    }
                })
                .collect();
            let variant_struct_type = self.context.struct_type(&variant_field_types, false);

            // Cast payload pointer to variant struct type pointer
            let typed_ptr = self.builder.build_bit_cast(
                payload_ptr,
                self.context.ptr_type(inkwell::AddressSpace::default()),
                "variant_ptr",
            ).unwrap().into_pointer_value();

            // Build the variant struct value
            let mut variant_val = variant_struct_type.get_undef();
            for (i, arg) in args.iter().enumerate() {
                if let Some(val) = self.compile_expr(&arg.value) {
                    let stored_val = if variant.boxed_fields.contains(&i) {
                        // Box: heap-allocate the value and store pointer as i64
                        let val_ty = val.get_type();
                        let val_size = val_ty.size_of().unwrap();
                        let heap_ptr = self.call_runtime(
                            "forge_alloc", &[val_size.into()], "boxed_field"
                        ).unwrap().into_pointer_value();
                        self.builder.build_store(heap_ptr, val).unwrap();
                        // Convert pointer to i64 for storage in the i64-slot union
                        self.builder.build_ptr_to_int(
                            heap_ptr, self.context.i64_type(), "boxed_ptr_int"
                        ).unwrap().into()
                    } else {
                        val
                    };
                    variant_val = self.builder
                        .build_insert_value(variant_val, stored_val, i as u32, "vfield")
                        .unwrap()
                        .into_struct_value();
                }
            }
            self.builder.build_store(typed_ptr, variant_val).unwrap();
        }

        // Load and return the enum value
        let result = self.builder.build_load(enum_struct_type, enum_alloca, "enum_val").unwrap();
        Some(result)
    }
}
