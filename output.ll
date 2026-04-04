; ModuleID = 'forgec_output'
source_filename = "forgec_output"

%ForgeString = type { ptr, i64 }

declare void @forge_println_string(%ForgeString)

declare %ForgeString @forge_int_to_string(i64)

declare %ForgeString @forge_string_new(ptr, i64)

declare %ForgeString @forge_string_concat(%ForgeString, %ForgeString)

declare %ForgeString @forge_string_char_at(%ForgeString, i64)

declare i64 @forge_string_length(%ForgeString)

declare i8 @forge_string_eq(%ForgeString, %ForgeString)

declare i64 @forge_string_compare(%ForgeString, %ForgeString)

declare %ForgeString @forge_string_substring(%ForgeString, i64, i64)

declare i64 @forge_string_index_of(%ForgeString, %ForgeString)

declare i64 @forge_c_index_of(%ForgeString, %ForgeString)

declare ptr @forge_alloc(i64)

declare void @forge_memcpy(ptr, ptr, i64)

declare ptr @forge_map_new()

declare i8 @forge_map_has(ptr, %ForgeString)

declare i64 @forge_map_get(ptr, %ForgeString)

declare void @forge_map_set(ptr, %ForgeString, i64)

declare void @forge_set_args(i32, ptr)

declare %ForgeString @forge_selfhost_process_args()

declare %ForgeString @forge_selfhost_fs_read(%ForgeString)

declare void @forge_selfhost_process_exit(i64)

declare %ForgeString @forge_selfhost_process_run(%ForgeString, %ForgeString)

declare void @forge_eprintln_string(%ForgeString)

declare ptr @forge_llvm_context_create()

declare void @forge_llvm_context_dispose(ptr)

declare ptr @forge_llvm_module_create(ptr, ptr)

declare void @forge_llvm_module_dispose(ptr)

declare ptr @forge_llvm_print_module_to_file(ptr, ptr)

declare ptr @forge_llvm_verify_module(ptr)

declare ptr @forge_llvm_int1_type(ptr)

declare ptr @forge_llvm_int8_type(ptr)

declare ptr @forge_llvm_int32_type(ptr)

declare ptr @forge_llvm_int64_type(ptr)

declare ptr @forge_llvm_double_type(ptr)

declare ptr @forge_llvm_void_type(ptr)

declare ptr @forge_llvm_pointer_type(ptr)

declare ptr @forge_llvm_function_type(ptr, ptr, ptr, ptr)

declare ptr @forge_llvm_struct_create_named(ptr, ptr)

declare ptr @forge_llvm_struct_set_body(ptr, ptr, ptr, ptr)

declare ptr @forge_llvm_struct_type(ptr, ptr, ptr)

declare ptr @forge_llvm_get_type_by_name(ptr, ptr)

declare ptr @forge_llvm_size_of(ptr)

declare ptr @forge_llvm_type_array_new(ptr)

declare void @forge_llvm_type_array_set(ptr, ptr, ptr)

declare void @forge_llvm_type_array_free(ptr)

declare ptr @forge_llvm_add_function(ptr, ptr, ptr)

declare ptr @forge_llvm_get_named_function(ptr, ptr)

declare ptr @forge_llvm_get_param(ptr, ptr)

declare ptr @forge_llvm_append_basic_block(ptr, ptr, ptr)

declare ptr @forge_llvm_get_insert_block(ptr)

declare ptr @forge_llvm_get_basic_block_parent(ptr)

declare ptr @forge_llvm_block_has_terminator(ptr)

declare ptr @forge_llvm_get_entry_basic_block(ptr)

declare ptr @forge_llvm_get_first_instruction(ptr)

declare ptr @forge_llvm_create_builder(ptr)

declare void @forge_llvm_dispose_builder(ptr)

declare void @forge_llvm_position_at_end(ptr, ptr)

declare void @forge_llvm_position_before(ptr, ptr)

declare ptr @forge_llvm_build_ret(ptr, ptr)

declare ptr @forge_llvm_build_ret_void(ptr)

declare ptr @forge_llvm_build_br(ptr, ptr)

declare ptr @forge_llvm_build_cond_br(ptr, ptr, ptr, ptr)

declare ptr @forge_llvm_build_alloca(ptr, ptr, ptr)

declare ptr @forge_llvm_build_store(ptr, ptr, ptr)

declare ptr @forge_llvm_build_load(ptr, ptr, ptr, ptr)

declare ptr @forge_llvm_build_call(ptr, ptr, ptr, ptr, ptr, ptr)

declare ptr @forge_llvm_build_add(ptr, ptr, ptr, ptr)

declare ptr @forge_llvm_build_sub(ptr, ptr, ptr, ptr)

declare ptr @forge_llvm_build_mul(ptr, ptr, ptr, ptr)

declare ptr @forge_llvm_build_sdiv(ptr, ptr, ptr, ptr)

declare ptr @forge_llvm_build_srem(ptr, ptr, ptr, ptr)

declare ptr @forge_llvm_build_and(ptr, ptr, ptr, ptr)

declare ptr @forge_llvm_build_or(ptr, ptr, ptr, ptr)

declare ptr @forge_llvm_build_xor(ptr, ptr, ptr, ptr)

declare ptr @forge_llvm_build_shl(ptr, ptr, ptr, ptr)

declare ptr @forge_llvm_build_ashr(ptr, ptr, ptr, ptr)

declare ptr @forge_llvm_build_icmp(ptr, ptr, ptr, ptr, ptr)

declare ptr @forge_llvm_build_trunc(ptr, ptr, ptr, ptr)

declare ptr @forge_llvm_build_zext(ptr, ptr, ptr, ptr)

declare ptr @forge_llvm_build_bitcast(ptr, ptr, ptr, ptr)

declare ptr @forge_llvm_build_struct_gep2(ptr, ptr, ptr, ptr, ptr)

declare ptr @forge_llvm_build_gep2(ptr, ptr, ptr, ptr, ptr, ptr)

declare ptr @forge_llvm_build_extract_value(ptr, ptr, ptr, ptr)

declare ptr @forge_llvm_build_insert_value(ptr, ptr, ptr, ptr, ptr)

declare ptr @forge_llvm_build_phi(ptr, ptr, ptr)

declare ptr @forge_llvm_add_incoming(ptr, ptr, ptr)

declare ptr @forge_llvm_build_ptr_to_int(ptr, ptr, ptr, ptr)

declare ptr @forge_llvm_build_inttoptr(ptr, ptr, ptr, ptr)

declare ptr @forge_llvm_build_global_string_ptr(ptr, ptr, ptr)

declare void @forge_llvm_set_initializer(ptr, ptr)

declare ptr @forge_llvm_add_global(ptr, ptr, ptr)

declare ptr @forge_llvm_const_int(ptr, ptr, ptr)

declare ptr @forge_llvm_const_null(ptr)

declare ptr @forge_llvm_const_real(ptr, ptr)

declare ptr @forge_llvm_const_string(ptr, ptr, ptr)

declare ptr @forge_llvm_get_undef(ptr)

declare ptr @forge_llvm_value_array_new(ptr)

declare void @forge_llvm_value_array_set(ptr, ptr, ptr)

declare ptr @forge_llvm_value_array_get(ptr, ptr)

declare void @forge_llvm_value_array_free(ptr)

declare ptr @forge_llvm_global_get_value_type(ptr)
