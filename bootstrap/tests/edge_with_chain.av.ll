; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%A = type { i64, i64, i64, i64, i64 }

@base = global i64 0
@changed = global i64 0
@fld_name = private unnamed_addr constant [3 x i8] c"v1\00", align 1
@sty_name = private unnamed_addr constant [2 x i8] c"A\00", align 1
@src_file = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/edge_with_chain.av\00", align 1
@fld_name.1 = private unnamed_addr constant [3 x i8] c"v2\00", align 1
@sty_name.2 = private unnamed_addr constant [2 x i8] c"A\00", align 1
@src_file.3 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/edge_with_chain.av\00", align 1
@fld_name.4 = private unnamed_addr constant [3 x i8] c"v3\00", align 1
@sty_name.5 = private unnamed_addr constant [2 x i8] c"A\00", align 1
@src_file.6 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/edge_with_chain.av\00", align 1
@fld_name.7 = private unnamed_addr constant [3 x i8] c"v4\00", align 1
@sty_name.8 = private unnamed_addr constant [2 x i8] c"A\00", align 1
@src_file.9 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/edge_with_chain.av\00", align 1
@fld_name.10 = private unnamed_addr constant [3 x i8] c"v5\00", align 1
@sty_name.11 = private unnamed_addr constant [2 x i8] c"A\00", align 1
@src_file.12 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/edge_with_chain.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name.13 = private unnamed_addr constant [3 x i8] c"v1\00", align 1
@sty_name.14 = private unnamed_addr constant [2 x i8] c"A\00", align 1
@src_file.15 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/edge_with_chain.av\00", align 1
@fld_name.16 = private unnamed_addr constant [3 x i8] c"v2\00", align 1
@sty_name.17 = private unnamed_addr constant [2 x i8] c"A\00", align 1
@src_file.18 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/edge_with_chain.av\00", align 1
@fld_name.19 = private unnamed_addr constant [3 x i8] c"v3\00", align 1
@sty_name.20 = private unnamed_addr constant [2 x i8] c"A\00", align 1
@src_file.21 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/edge_with_chain.av\00", align 1
@fld_name.22 = private unnamed_addr constant [3 x i8] c"v4\00", align 1
@sty_name.23 = private unnamed_addr constant [2 x i8] c"A\00", align 1
@src_file.24 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/edge_with_chain.av\00", align 1
@fld_name.25 = private unnamed_addr constant [3 x i8] c"v5\00", align 1
@sty_name.26 = private unnamed_addr constant [2 x i8] c"A\00", align 1
@src_file.27 = private unnamed_addr constant [102 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/edge_with_chain.av\00", align 1
@.i2s_fmt.28 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

declare i32 @puts(ptr)

declare void @avra_eprintln(ptr)

declare i64 @strlen(ptr)

declare ptr @malloc(i64)

declare ptr @avra_rc_alloc(i64)

declare void @avra_rc_retain(ptr)

declare void @avra_rc_release(ptr)

declare i64 @avra_rc_should_free(ptr)

declare void @avra_rc_free(ptr)

declare void @avra_rc_suspect(ptr)

declare void @avra_rc_collect()

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @strcmp(ptr, ptr)

declare i32 @snprintf(ptr, i64, ptr, ...)

declare i32 @atoi(ptr)

declare i64 @avra_parse_int(ptr)

declare void @exit(i32)

declare void @avra_null_arg_check(ptr, i64, ptr, i64, i64)

declare void @avra_null_deref_trap(ptr, i64, ptr, i64, i64, ptr, i64, i64)

declare void @avra_div_by_zero_trap(i64, ptr, i64, i64)

declare ptr @avra_array_new()

declare void @avra_array_push(ptr, i64)

declare i64 @avra_array_get(ptr, i64)

declare i64 @avra_array_len(ptr)

declare void @avra_array_set(ptr, i64, i64)

declare i64 @avra_array_pop(ptr)

declare ptr @avra_array_slice(ptr, i64, i64)

declare i64 @avra_closure_get_fn(i64)

declare i64 @avra_closure_num_captures(i64)

declare i64 @avra_closure_get_capture(ptr, i64)

declare i64 @avra_closure_call_0(i64)

declare i64 @avra_closure_call_1(i64, i64)

declare i64 @avra_closure_call_2(i64, i64, i64)

declare i64 @avra_closure_call_3(i64, i64, i64, i64)

declare i64 @avra_closure_call_4(i64, i64, i64, i64, i64)

declare i64 @avra_closure_call_5(i64, i64, i64, i64, i64, i64)

declare ptr @avra_array_map(ptr, i64)

declare ptr @avra_array_filter(ptr, i64)

declare void @avra_array_foreach(ptr, i64)

declare i64 @avra_array_reduce(ptr, i64, i64)

declare i64 @avra_array_contains(ptr, i64)

declare i64 @avra_array_index_of(ptr, i64)

declare ptr @avra_array_reverse(ptr)

declare i64 @avra_str_contains(ptr, ptr)

declare i64 @avra_str_starts_with(ptr, ptr)

declare i64 @avra_str_ends_with(ptr, ptr)

declare i64 @avra_str_index_of(ptr, ptr)

declare ptr @avra_str_split(ptr, ptr)

declare ptr @avra_str_replace(ptr, ptr, ptr)

declare ptr @avra_str_trim(ptr)

declare ptr @avra_str_to_upper(ptr)

declare ptr @avra_str_to_lower(ptr)

declare ptr @avra_str_join(ptr, ptr)

declare ptr @avra_str_char_at(ptr, i64)

declare ptr @avra_str_substring(ptr, i64, i64)

declare ptr @avra_str_repeat(ptr, i64)

declare ptr @avra_str_reverse(ptr)

declare ptr @avra_map_new_cstr()

declare void @avra_map_set_cstr(ptr, ptr, i64)

declare i64 @avra_map_get_cstr(ptr, ptr)

declare i64 @avra_map_has_cstr(ptr, ptr)

declare i64 @avra_map_len_cstr(ptr)

declare ptr @avra_map_keys_cstr(ptr)

declare ptr @avra_map_values_cstr(ptr)

declare i64 @avra_map_remove_cstr(ptr, ptr)

declare ptr @avra_file_read(ptr)

declare i64 @avra_file_write(ptr, ptr)

declare i64 @avra_file_exists(ptr)

declare ptr @avra_intmap_new()

declare void @avra_intmap_set(ptr, i64, i64)

declare i64 @avra_intmap_get(ptr, i64)

declare i64 @avra_intmap_has(ptr, i64)

declare i64 @avra_float_parse(ptr)

declare i64 @avra_float_to_string(i64)

declare ptr @avra_format_float(i64, ptr)

declare ptr @avra_format_int(i64, ptr)

declare void @avra_ptr_store_byte(ptr, i64, i64)

declare i64 @avra_string_from_ptr(ptr, i64)

declare i64 @avra_trait_object_new(ptr, i64)

declare i64 @avra_trait_object_value(ptr)

declare ptr @avra_trait_object_vtable(ptr)

declare i64 @avra_datetime_now()

declare i64 @avra_datetime_format(ptr, i64)

declare i64 @avra_datetime_year(ptr)

declare i64 @avra_datetime_month(ptr)

declare i64 @avra_datetime_day(ptr)

declare i64 @avra_datetime_hour(ptr)

declare i64 @avra_datetime_minute(ptr)

declare i64 @avra_datetime_second(ptr)

declare ptr @avra_json_stringify_int(ptr)

declare ptr @avra_json_stringify_string(ptr)

declare ptr @avra_json_stringify_bool(ptr)

declare i64 @avra_json_get_int(ptr, i64)

declare i64 @avra_json_get_string(ptr, i64)

declare i64 @avra_json_get_bool(ptr, i64)

declare i64 @avra_semver_major(ptr)

declare i64 @avra_semver_minor(ptr)

declare i64 @avra_semver_patch(ptr)

declare i64 @avra_semver_compare(ptr, i64)

declare i64 @avra_validate_not_null(ptr, i64)

declare i64 @avra_validate_positive(ptr, i64)

declare i64 @avra_validate_not_empty(ptr, i64)

declare i64 @avra_toml_get_string(ptr, i64)

declare i64 @avra_toml_get_int(ptr, i64)

declare i64 @avra_toml_get_bool(ptr, i64)

declare i64 @avra_toml_get_section_string(ptr, i64, i64)

declare i64 @avra_toml_has_section(ptr, i64)

declare i64 @avra_spawn(ptr)

declare i64 @avra_task_await(ptr)

declare i32 @avra_thread_join(ptr)

declare void @avra_yield()

declare void @avra_scheduler_run()

declare ptr @avra_task_group_new()

declare void @avra_task_group_add(ptr, ptr)

declare void @avra_task_group_await_all(ptr)

declare ptr @avra_channel_new()

declare void @avra_channel_send(ptr, i64)

declare i64 @avra_channel_recv(ptr)

declare i32 @avra_channel_close(ptr)

declare i32 @avra_parallel_run(ptr)

declare i64 @avra_select(ptr, i64)

declare i64 @avra_select_index(ptr)

declare i64 @avra_select_value(ptr)

declare i32 @avra_test_start_spec(ptr)

declare i32 @avra_test_end_spec(ptr)

declare i32 @avra_test_start_given(ptr)

declare i32 @avra_test_end_given(ptr)

declare i64 @avra_test_run_then(ptr, i64)

declare i32 @avra_test_skip(ptr)

declare i32 @avra_test_todo(ptr)

declare i32 @avra_test_summary()

declare void @avra_test_flush()

declare ptr @avra_arena_new()

declare ptr @avra_arena_alloc(ptr, i64)

declare void @avra_arena_destroy(ptr)

declare void @avra_match_unreachable(ptr, i64, ptr, i64)

declare i32 @avra_llvm_is_ptr_value(ptr)

declare ptr @avra_llvm_typeof(ptr)

declare ptr @avra_llvm_cast_to_type(ptr, ptr, ptr)

declare i32 @avra_llvm_is_void_value(ptr)

declare void @avra_llvm_build_store_cast(ptr, ptr, ptr)

declare i32 @avra_llvm_verify_function(ptr)

declare i64 @avra_llvm_type_kind(ptr)

declare i64 @avra_llvm_int_type_width(ptr)

declare ptr @avra_llvm_build_call_coerce(ptr, ptr, ptr, ptr, i64, ptr)

declare i64 @avra_test_roughly(double, double, double)

define i64 @main() {
entry:
  %0 = call ptr @avra_rc_alloc(i64 40)
  %fld_ptr = getelementptr inbounds nuw %A, ptr %0, i32 0, i32 0
  store i64 1, ptr %fld_ptr, align 8
  %fld_ptr1 = getelementptr inbounds nuw %A, ptr %0, i32 0, i32 1
  store i64 2, ptr %fld_ptr1, align 8
  %fld_ptr2 = getelementptr inbounds nuw %A, ptr %0, i32 0, i32 2
  store i64 3, ptr %fld_ptr2, align 8
  %fld_ptr3 = getelementptr inbounds nuw %A, ptr %0, i32 0, i32 3
  store i64 4, ptr %fld_ptr3, align 8
  %fld_ptr4 = getelementptr inbounds nuw %A, ptr %0, i32 0, i32 4
  store i64 5, ptr %fld_ptr4, align 8
  %cast = ptrtoint ptr %0 to i64
  store i64 %cast, ptr @base, align 8
  %base = load ptr, ptr @base, align 8
  %1 = call ptr @avra_rc_alloc(i64 40)
  %with_cp_src = getelementptr inbounds nuw %A, ptr %base, i32 0, i32 0
  %with_cp_val = load i64, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %A, ptr %1, i32 0, i32 0
  store i64 %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src5 = getelementptr inbounds nuw %A, ptr %base, i32 0, i32 1
  %with_cp_val6 = load i64, ptr %with_cp_src5, align 8
  %with_cp_dst7 = getelementptr inbounds nuw %A, ptr %1, i32 0, i32 1
  store i64 %with_cp_val6, ptr %with_cp_dst7, align 8
  %with_cp_src8 = getelementptr inbounds nuw %A, ptr %base, i32 0, i32 2
  %with_cp_val9 = load i64, ptr %with_cp_src8, align 8
  %with_cp_dst10 = getelementptr inbounds nuw %A, ptr %1, i32 0, i32 2
  store i64 %with_cp_val9, ptr %with_cp_dst10, align 8
  %with_cp_src11 = getelementptr inbounds nuw %A, ptr %base, i32 0, i32 3
  %with_cp_val12 = load i64, ptr %with_cp_src11, align 8
  %with_cp_dst13 = getelementptr inbounds nuw %A, ptr %1, i32 0, i32 3
  store i64 %with_cp_val12, ptr %with_cp_dst13, align 8
  %with_cp_src14 = getelementptr inbounds nuw %A, ptr %base, i32 0, i32 4
  %with_cp_val15 = load i64, ptr %with_cp_src14, align 8
  %with_cp_dst16 = getelementptr inbounds nuw %A, ptr %1, i32 0, i32 4
  store i64 %with_cp_val15, ptr %with_cp_dst16, align 8
  %with_ovr = getelementptr inbounds nuw %A, ptr %1, i32 0, i32 0
  store i64 10, ptr %with_ovr, align 8
  %cast17 = ptrtoint ptr %1 to i64
  %2 = call ptr @avra_rc_alloc(i64 40)
  %cast18 = inttoptr i64 %cast17 to ptr
  %with_cp_src19 = getelementptr inbounds nuw %A, ptr %cast18, i32 0, i32 0
  %with_cp_val20 = load i64, ptr %with_cp_src19, align 8
  %with_cp_dst21 = getelementptr inbounds nuw %A, ptr %2, i32 0, i32 0
  store i64 %with_cp_val20, ptr %with_cp_dst21, align 8
  %with_cp_src22 = getelementptr inbounds nuw %A, ptr %cast18, i32 0, i32 1
  %with_cp_val23 = load i64, ptr %with_cp_src22, align 8
  %with_cp_dst24 = getelementptr inbounds nuw %A, ptr %2, i32 0, i32 1
  store i64 %with_cp_val23, ptr %with_cp_dst24, align 8
  %with_cp_src25 = getelementptr inbounds nuw %A, ptr %cast18, i32 0, i32 2
  %with_cp_val26 = load i64, ptr %with_cp_src25, align 8
  %with_cp_dst27 = getelementptr inbounds nuw %A, ptr %2, i32 0, i32 2
  store i64 %with_cp_val26, ptr %with_cp_dst27, align 8
  %with_cp_src28 = getelementptr inbounds nuw %A, ptr %cast18, i32 0, i32 3
  %with_cp_val29 = load i64, ptr %with_cp_src28, align 8
  %with_cp_dst30 = getelementptr inbounds nuw %A, ptr %2, i32 0, i32 3
  store i64 %with_cp_val29, ptr %with_cp_dst30, align 8
  %with_cp_src31 = getelementptr inbounds nuw %A, ptr %cast18, i32 0, i32 4
  %with_cp_val32 = load i64, ptr %with_cp_src31, align 8
  %with_cp_dst33 = getelementptr inbounds nuw %A, ptr %2, i32 0, i32 4
  store i64 %with_cp_val32, ptr %with_cp_dst33, align 8
  %with_ovr34 = getelementptr inbounds nuw %A, ptr %2, i32 0, i32 1
  store i64 20, ptr %with_ovr34, align 8
  %cast35 = ptrtoint ptr %2 to i64
  %3 = call ptr @avra_rc_alloc(i64 40)
  %cast36 = inttoptr i64 %cast35 to ptr
  %with_cp_src37 = getelementptr inbounds nuw %A, ptr %cast36, i32 0, i32 0
  %with_cp_val38 = load i64, ptr %with_cp_src37, align 8
  %with_cp_dst39 = getelementptr inbounds nuw %A, ptr %3, i32 0, i32 0
  store i64 %with_cp_val38, ptr %with_cp_dst39, align 8
  %with_cp_src40 = getelementptr inbounds nuw %A, ptr %cast36, i32 0, i32 1
  %with_cp_val41 = load i64, ptr %with_cp_src40, align 8
  %with_cp_dst42 = getelementptr inbounds nuw %A, ptr %3, i32 0, i32 1
  store i64 %with_cp_val41, ptr %with_cp_dst42, align 8
  %with_cp_src43 = getelementptr inbounds nuw %A, ptr %cast36, i32 0, i32 2
  %with_cp_val44 = load i64, ptr %with_cp_src43, align 8
  %with_cp_dst45 = getelementptr inbounds nuw %A, ptr %3, i32 0, i32 2
  store i64 %with_cp_val44, ptr %with_cp_dst45, align 8
  %with_cp_src46 = getelementptr inbounds nuw %A, ptr %cast36, i32 0, i32 3
  %with_cp_val47 = load i64, ptr %with_cp_src46, align 8
  %with_cp_dst48 = getelementptr inbounds nuw %A, ptr %3, i32 0, i32 3
  store i64 %with_cp_val47, ptr %with_cp_dst48, align 8
  %with_cp_src49 = getelementptr inbounds nuw %A, ptr %cast36, i32 0, i32 4
  %with_cp_val50 = load i64, ptr %with_cp_src49, align 8
  %with_cp_dst51 = getelementptr inbounds nuw %A, ptr %3, i32 0, i32 4
  store i64 %with_cp_val50, ptr %with_cp_dst51, align 8
  %with_ovr52 = getelementptr inbounds nuw %A, ptr %3, i32 0, i32 2
  store i64 30, ptr %with_ovr52, align 8
  %cast53 = ptrtoint ptr %3 to i64
  %4 = call ptr @avra_rc_alloc(i64 40)
  %cast54 = inttoptr i64 %cast53 to ptr
  %with_cp_src55 = getelementptr inbounds nuw %A, ptr %cast54, i32 0, i32 0
  %with_cp_val56 = load i64, ptr %with_cp_src55, align 8
  %with_cp_dst57 = getelementptr inbounds nuw %A, ptr %4, i32 0, i32 0
  store i64 %with_cp_val56, ptr %with_cp_dst57, align 8
  %with_cp_src58 = getelementptr inbounds nuw %A, ptr %cast54, i32 0, i32 1
  %with_cp_val59 = load i64, ptr %with_cp_src58, align 8
  %with_cp_dst60 = getelementptr inbounds nuw %A, ptr %4, i32 0, i32 1
  store i64 %with_cp_val59, ptr %with_cp_dst60, align 8
  %with_cp_src61 = getelementptr inbounds nuw %A, ptr %cast54, i32 0, i32 2
  %with_cp_val62 = load i64, ptr %with_cp_src61, align 8
  %with_cp_dst63 = getelementptr inbounds nuw %A, ptr %4, i32 0, i32 2
  store i64 %with_cp_val62, ptr %with_cp_dst63, align 8
  %with_cp_src64 = getelementptr inbounds nuw %A, ptr %cast54, i32 0, i32 3
  %with_cp_val65 = load i64, ptr %with_cp_src64, align 8
  %with_cp_dst66 = getelementptr inbounds nuw %A, ptr %4, i32 0, i32 3
  store i64 %with_cp_val65, ptr %with_cp_dst66, align 8
  %with_cp_src67 = getelementptr inbounds nuw %A, ptr %cast54, i32 0, i32 4
  %with_cp_val68 = load i64, ptr %with_cp_src67, align 8
  %with_cp_dst69 = getelementptr inbounds nuw %A, ptr %4, i32 0, i32 4
  store i64 %with_cp_val68, ptr %with_cp_dst69, align 8
  %with_ovr70 = getelementptr inbounds nuw %A, ptr %4, i32 0, i32 3
  store i64 40, ptr %with_ovr70, align 8
  %cast71 = ptrtoint ptr %4 to i64
  %5 = call ptr @avra_rc_alloc(i64 40)
  %cast72 = inttoptr i64 %cast71 to ptr
  %with_cp_src73 = getelementptr inbounds nuw %A, ptr %cast72, i32 0, i32 0
  %with_cp_val74 = load i64, ptr %with_cp_src73, align 8
  %with_cp_dst75 = getelementptr inbounds nuw %A, ptr %5, i32 0, i32 0
  store i64 %with_cp_val74, ptr %with_cp_dst75, align 8
  %with_cp_src76 = getelementptr inbounds nuw %A, ptr %cast72, i32 0, i32 1
  %with_cp_val77 = load i64, ptr %with_cp_src76, align 8
  %with_cp_dst78 = getelementptr inbounds nuw %A, ptr %5, i32 0, i32 1
  store i64 %with_cp_val77, ptr %with_cp_dst78, align 8
  %with_cp_src79 = getelementptr inbounds nuw %A, ptr %cast72, i32 0, i32 2
  %with_cp_val80 = load i64, ptr %with_cp_src79, align 8
  %with_cp_dst81 = getelementptr inbounds nuw %A, ptr %5, i32 0, i32 2
  store i64 %with_cp_val80, ptr %with_cp_dst81, align 8
  %with_cp_src82 = getelementptr inbounds nuw %A, ptr %cast72, i32 0, i32 3
  %with_cp_val83 = load i64, ptr %with_cp_src82, align 8
  %with_cp_dst84 = getelementptr inbounds nuw %A, ptr %5, i32 0, i32 3
  store i64 %with_cp_val83, ptr %with_cp_dst84, align 8
  %with_cp_src85 = getelementptr inbounds nuw %A, ptr %cast72, i32 0, i32 4
  %with_cp_val86 = load i64, ptr %with_cp_src85, align 8
  %with_cp_dst87 = getelementptr inbounds nuw %A, ptr %5, i32 0, i32 4
  store i64 %with_cp_val86, ptr %with_cp_dst87, align 8
  %with_ovr88 = getelementptr inbounds nuw %A, ptr %5, i32 0, i32 4
  store i64 50, ptr %with_ovr88, align 8
  %cast89 = ptrtoint ptr %5 to i64
  store i64 %cast89, ptr @changed, align 8
  %changed = load ptr, ptr @changed, align 8
  %cast90 = ptrtoint ptr %changed to i64
  %null_chk = icmp eq i64 %cast90, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 2, ptr @sty_name, i64 1, i64 %null_ext, ptr @src_file, i64 101, i64 5)
  %v1_ptr = getelementptr inbounds nuw %A, ptr %changed, i32 0, i32 0
  %v1 = load i64, ptr %v1_ptr, align 8
  %changed91 = load ptr, ptr @changed, align 8
  %cast92 = ptrtoint ptr %changed91 to i64
  %null_chk93 = icmp eq i64 %cast92, 0
  %null_ext94 = zext i1 %null_chk93 to i64
  call void @avra_null_deref_trap(ptr @fld_name.1, i64 2, ptr @sty_name.2, i64 1, i64 %null_ext94, ptr @src_file.3, i64 101, i64 5)
  %v2_ptr = getelementptr inbounds nuw %A, ptr %changed91, i32 0, i32 1
  %v2 = load i64, ptr %v2_ptr, align 8
  %add = add i64 %v1, %v2
  %changed95 = load ptr, ptr @changed, align 8
  %cast96 = ptrtoint ptr %changed95 to i64
  %null_chk97 = icmp eq i64 %cast96, 0
  %null_ext98 = zext i1 %null_chk97 to i64
  call void @avra_null_deref_trap(ptr @fld_name.4, i64 2, ptr @sty_name.5, i64 1, i64 %null_ext98, ptr @src_file.6, i64 101, i64 5)
  %v3_ptr = getelementptr inbounds nuw %A, ptr %changed95, i32 0, i32 2
  %v3 = load i64, ptr %v3_ptr, align 8
  %add99 = add i64 %add, %v3
  %changed100 = load ptr, ptr @changed, align 8
  %cast101 = ptrtoint ptr %changed100 to i64
  %null_chk102 = icmp eq i64 %cast101, 0
  %null_ext103 = zext i1 %null_chk102 to i64
  call void @avra_null_deref_trap(ptr @fld_name.7, i64 2, ptr @sty_name.8, i64 1, i64 %null_ext103, ptr @src_file.9, i64 101, i64 5)
  %v4_ptr = getelementptr inbounds nuw %A, ptr %changed100, i32 0, i32 3
  %v4 = load i64, ptr %v4_ptr, align 8
  %add104 = add i64 %add99, %v4
  %changed105 = load ptr, ptr @changed, align 8
  %cast106 = ptrtoint ptr %changed105 to i64
  %null_chk107 = icmp eq i64 %cast106, 0
  %null_ext108 = zext i1 %null_chk107 to i64
  call void @avra_null_deref_trap(ptr @fld_name.10, i64 2, ptr @sty_name.11, i64 1, i64 %null_ext108, ptr @src_file.12, i64 101, i64 5)
  %v5_ptr = getelementptr inbounds nuw %A, ptr %changed105, i32 0, i32 4
  %v5 = load i64, ptr %v5_ptr, align 8
  %add109 = add i64 %add104, %v5
  %6 = call ptr @avra_rc_alloc(i64 32)
  %7 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %6, i64 32, ptr @.i2s_fmt, i64 %add109)
  %widen = sext i32 %7 to i64
  %8 = call i32 @puts(ptr %6)
  %widen110 = sext i32 %8 to i64
  %base111 = load ptr, ptr @base, align 8
  %cast112 = ptrtoint ptr %base111 to i64
  %null_chk113 = icmp eq i64 %cast112, 0
  %null_ext114 = zext i1 %null_chk113 to i64
  call void @avra_null_deref_trap(ptr @fld_name.13, i64 2, ptr @sty_name.14, i64 1, i64 %null_ext114, ptr @src_file.15, i64 101, i64 7)
  %v1_ptr115 = getelementptr inbounds nuw %A, ptr %base111, i32 0, i32 0
  %v1116 = load i64, ptr %v1_ptr115, align 8
  %base117 = load ptr, ptr @base, align 8
  %cast118 = ptrtoint ptr %base117 to i64
  %null_chk119 = icmp eq i64 %cast118, 0
  %null_ext120 = zext i1 %null_chk119 to i64
  call void @avra_null_deref_trap(ptr @fld_name.16, i64 2, ptr @sty_name.17, i64 1, i64 %null_ext120, ptr @src_file.18, i64 101, i64 7)
  %v2_ptr121 = getelementptr inbounds nuw %A, ptr %base117, i32 0, i32 1
  %v2122 = load i64, ptr %v2_ptr121, align 8
  %add123 = add i64 %v1116, %v2122
  %base124 = load ptr, ptr @base, align 8
  %cast125 = ptrtoint ptr %base124 to i64
  %null_chk126 = icmp eq i64 %cast125, 0
  %null_ext127 = zext i1 %null_chk126 to i64
  call void @avra_null_deref_trap(ptr @fld_name.19, i64 2, ptr @sty_name.20, i64 1, i64 %null_ext127, ptr @src_file.21, i64 101, i64 7)
  %v3_ptr128 = getelementptr inbounds nuw %A, ptr %base124, i32 0, i32 2
  %v3129 = load i64, ptr %v3_ptr128, align 8
  %add130 = add i64 %add123, %v3129
  %base131 = load ptr, ptr @base, align 8
  %cast132 = ptrtoint ptr %base131 to i64
  %null_chk133 = icmp eq i64 %cast132, 0
  %null_ext134 = zext i1 %null_chk133 to i64
  call void @avra_null_deref_trap(ptr @fld_name.22, i64 2, ptr @sty_name.23, i64 1, i64 %null_ext134, ptr @src_file.24, i64 101, i64 7)
  %v4_ptr135 = getelementptr inbounds nuw %A, ptr %base131, i32 0, i32 3
  %v4136 = load i64, ptr %v4_ptr135, align 8
  %add137 = add i64 %add130, %v4136
  %base138 = load ptr, ptr @base, align 8
  %cast139 = ptrtoint ptr %base138 to i64
  %null_chk140 = icmp eq i64 %cast139, 0
  %null_ext141 = zext i1 %null_chk140 to i64
  call void @avra_null_deref_trap(ptr @fld_name.25, i64 2, ptr @sty_name.26, i64 1, i64 %null_ext141, ptr @src_file.27, i64 101, i64 7)
  %v5_ptr142 = getelementptr inbounds nuw %A, ptr %base138, i32 0, i32 4
  %v5143 = load i64, ptr %v5_ptr142, align 8
  %add144 = add i64 %add137, %v5143
  %9 = call ptr @avra_rc_alloc(i64 32)
  %10 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %9, i64 32, ptr @.i2s_fmt.28, i64 %add144)
  %widen145 = sext i32 %10 to i64
  %11 = call i32 @puts(ptr %9)
  %widen146 = sext i32 %11 to i64
  %12 = call i32 @avra_test_summary()
  %widen147 = sext i32 %12 to i64
  call void @avra_rc_collect()
  ret i64 0
}
