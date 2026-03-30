; ModuleID = 'forgec_output'
source_filename = "forgec_output"

%ForgeString = type { ptr, i64 }

@0 = constant [18 x i8] c"hello from stage 2"

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

declare void @forge_param_type_clear()

declare void @forge_param_type_add(%ForgeString)

declare %ForgeString @forge_param_type_get(i64)

declare void @forge_param_name_clear()

declare void @forge_param_name_add(%ForgeString)

declare %ForgeString @forge_param_name_get(i64)

declare void @forge_set_self_type(%ForgeString)

declare %ForgeString @forge_get_self_type()

declare void @forge_debug_enum()

declare void @forge_set_alloca_name(%ForgeString)

declare void @forge_set_alloca_name_c(%ForgeString)

declare void @forge_arm_pending_alloca()

declare void @forge_clear_last_let_name()

declare i64 @forge_let_needs_alloca()

declare void @forge_set_last_let_name(%ForgeString)

declare void @forge_let_to_alloca_name()

declare void @forge_struct_var_clear()

declare void @forge_struct_var_add(%ForgeString, %ForgeString)

declare %ForgeString @forge_struct_var_get(%ForgeString)

declare void @forge_var_name_clear()

declare void @forge_var_name_push(%ForgeString)

declare i64 @forge_var_name_exists(%ForgeString)

declare void @forge_var_name_set_scope(i64)

declare void @forge_fn_reg_clear()

declare void @forge_fn_reg_add(%ForgeString, %ForgeString)

declare %ForgeString @forge_fn_reg_get_ret(%ForgeString)

declare i64 @forge_fn_reg_count()

declare i64 @forge_scan_csv(%ForgeString)

declare void @forge_scan_csv_set_cb(ptr)

declare void @forge_save_csv(%ForgeString)

declare i64 @forge_csv_byte_at(i64)

declare i64 @forge_csv_length()

declare %ForgeString @forge_csv_substr(i64, i64)

declare %ForgeString @forge_scan_csv_path(i64)

declare %ForgeString @forge_csv_next()

declare void @forge_csv_scan_reset()

declare i64 @forge_csv_scan_idx()

declare i64 @forge_csv_has_next()

declare void @forge_mod_csv_clear()

declare void @forge_mod_csv_add(%ForgeString)

declare %ForgeString @forge_mod_csv_get()

declare i64 @forge_sh_indexof(%ForgeString, %ForgeString)

declare %ForgeString @forge_sh_substr(%ForgeString, i64, i64)

declare i64 @forge_sh_byteat(%ForgeString, i64)

declare i64 @forge_sh_length(%ForgeString)

declare i64 @forge_kind_id_for_keyword(%ForgeString)

declare void @forge_parser_set_pos(i64)

declare i64 @forge_parser_get_pos()

declare void @forge_parser_advance_pos()

declare void @forge_parser_set_ptr(ptr)

declare i64 @forge_parser_consume_empty_params()

declare %ForgeString @forge_parser_consume_block(%ForgeString)

declare i64 @forge_parser_is_at_rparen()

declare i64 @forge_parser_is_at_end()

declare i64 @forge_parser_expect_id(i64)

declare i64 @forge_parser_check_id(i64)

declare void @forge_parser_skip_newlines()

declare void @forge_debug_parser_state(%ForgeString)

declare void @forge_enable_peek_trace()

declare void @forge_set_token_list(%ForgeString)

declare i64 @forge_peek_kind_id(i64)

declare %ForgeString @forge_peek_text(i64)

declare i64 @forge_token_list_len()

declare i64 @forge_is_alpha(%ForgeString)

declare i64 @forge_is_digit(%ForgeString)

declare i64 @forge_is_alnum(%ForgeString)

declare i64 @forge_is_ident_start(%ForgeString)

declare i64 @forge_is_ident_continue(%ForgeString)

declare i64 @forge_is_hex_digit(%ForgeString)

declare i64 @forge_is_whitespace_not_newline(%ForgeString)

declare %ForgeString @forge_list_push(%ForgeString, ptr, i64)

declare %ForgeString @forge_list_push_str(%ForgeString, %ForgeString)

declare void @forge_fn_store_clear()

declare void @forge_fn_store_add(%ForgeString, %ForgeString)

declare %ForgeString @forge_fn_store_get_body(i64)

declare %ForgeString @forge_fn_store_get_name(i64)

declare i64 @forge_fn_store_count()

declare void @forge_dump_token_list(%ForgeString)

declare ptr @forge_alloc(i64)

declare void @forge_memcpy(ptr, ptr, i64)

declare ptr @forge_map_new()

declare i8 @forge_map_has(ptr, %ForgeString)

declare i64 @forge_map_get(ptr, %ForgeString)

declare void @forge_map_set(ptr, %ForgeString, i64)

declare void @forge_set_args(i32, ptr)

declare %ForgeString @forge_selfhost_process_args()

declare i64 @forge_fn_is_str_return(%ForgeString)

declare void @forge_list_var_add(%ForgeString)

declare void @forge_ptr_var_add(%ForgeString)

declare i64 @forge_ptr_var_check(%ForgeString)

declare void @forge_ptr_var_clear()

declare void @forge_ptr_var_set_global()

declare i64 @forge_list_var_check(%ForgeString)

declare void @forge_list_var_clear()

declare %ForgeString @forge_selfhost_get_arg(i64)

declare void @forge_str_var_set_global_count()

declare %ForgeString @forge_selfhost_fs_read(%ForgeString)

declare void @forge_selfhost_process_exit(i64)

declare %ForgeString @forge_selfhost_process_run(%ForgeString, %ForgeString)

declare void @forge_eprintln_string(%ForgeString)

declare i64 @forge_string_to_int(%ForgeString)

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

declare ptr @forge_llvm_get_allocated_type(ptr)

declare ptr @forge_llvm_type_of(ptr)

declare ptr @forge_llvm_get_type_kind(ptr)

declare ptr @forge_llvm_emit_object_file(ptr, ptr)

declare i64 @forge_alloca_cache_clear()

declare i64 @forge_alloca_cache_set(%ForgeString, ptr)

declare ptr @forge_alloca_cache_get(%ForgeString)

declare void @forge_alloca_cache_set_type(%ForgeString, ptr)

declare void @forge_alloca_cache_set_last_type(ptr)

declare ptr @forge_alloca_cache_get_type(%ForgeString)

declare i64 @forge_str_var_add(%ForgeString)

declare i64 @forge_str_var_check(%ForgeString)

declare i64 @forge_str_var_clear()

declare i64 @forge_idx_cache_clear()

declare i64 @forge_idx_cache_set(i64, ptr)

declare ptr @forge_idx_cache_get(i64)

declare i64 @forge_var_counter_get()

declare i64 @forge_var_counter_inc()

declare i64 @forge_var_counter_reset(i64)

declare ptr @forge_llvm_build_extract_value.1(ptr, ptr, i64, %ForgeString)

declare i64 @forge_sh_indexof.2(%ForgeString, %ForgeString)

declare %ForgeString @forge_sh_substr.3(%ForgeString, i64, i64)

declare i64 @forge_sh_byteat.4(%ForgeString, i64)

declare i64 @forge_sh_length.5(%ForgeString)

define i32 @main(i32 %0, ptr %1) {
bb0:
  call void @forge_set_args(i32 %0, ptr %1)
  call void @forge_println_string({ ptr, i64 } { ptr @0, i64 18 })
  ret i32 0
}
