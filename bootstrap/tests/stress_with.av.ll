; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Config = type { ptr, i64, i64, i64 }

@base = global i64 0
@dev = global i64 0
@prod = global i64 0
@staging = global i64 0
@.str = private unnamed_addr constant [10 x i8] c"localhost\00", align 1
@fld_name = private unnamed_addr constant [6 x i8] c"debug\00", align 1
@sty_name = private unnamed_addr constant [7 x i8] c"Config\00", align 1
@src_file = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/stress_with.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name.1 = private unnamed_addr constant [5 x i8] c"port\00", align 1
@sty_name.2 = private unnamed_addr constant [7 x i8] c"Config\00", align 1
@src_file.3 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/stress_with.av\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.5 = private unnamed_addr constant [17 x i8] c"prod.example.com\00", align 1
@fld_name.6 = private unnamed_addr constant [5 x i8] c"host\00", align 1
@sty_name.7 = private unnamed_addr constant [7 x i8] c"Config\00", align 1
@src_file.8 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/stress_with.av\00", align 1
@fld_name.9 = private unnamed_addr constant [5 x i8] c"port\00", align 1
@sty_name.10 = private unnamed_addr constant [7 x i8] c"Config\00", align 1
@src_file.11 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/stress_with.av\00", align 1
@.i2s_fmt.12 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.13 = private unnamed_addr constant [8 x i8] c"staging\00", align 1
@fld_name.14 = private unnamed_addr constant [5 x i8] c"host\00", align 1
@sty_name.15 = private unnamed_addr constant [7 x i8] c"Config\00", align 1
@src_file.16 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/stress_with.av\00", align 1
@fld_name.17 = private unnamed_addr constant [5 x i8] c"port\00", align 1
@sty_name.18 = private unnamed_addr constant [7 x i8] c"Config\00", align 1
@src_file.19 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/stress_with.av\00", align 1
@.i2s_fmt.20 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name.21 = private unnamed_addr constant [6 x i8] c"debug\00", align 1
@sty_name.22 = private unnamed_addr constant [7 x i8] c"Config\00", align 1
@src_file.23 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/stress_with.av\00", align 1
@.i2s_fmt.24 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name.25 = private unnamed_addr constant [8 x i8] c"timeout\00", align 1
@sty_name.26 = private unnamed_addr constant [7 x i8] c"Config\00", align 1
@src_file.27 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/stress_with.av\00", align 1
@.i2s_fmt.28 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name.29 = private unnamed_addr constant [5 x i8] c"host\00", align 1
@sty_name.30 = private unnamed_addr constant [7 x i8] c"Config\00", align 1
@src_file.31 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/stress_with.av\00", align 1
@fld_name.32 = private unnamed_addr constant [5 x i8] c"port\00", align 1
@sty_name.33 = private unnamed_addr constant [7 x i8] c"Config\00", align 1
@src_file.34 = private unnamed_addr constant [98 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/stress_with.av\00", align 1
@.i2s_fmt.35 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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
  %0 = call ptr @avra_rc_alloc(i64 32)
  %fld_ptr = getelementptr inbounds nuw %Config, ptr %0, i32 0, i32 0
  store ptr @.str, ptr %fld_ptr, align 8
  %fld_ptr1 = getelementptr inbounds nuw %Config, ptr %0, i32 0, i32 1
  store i64 80, ptr %fld_ptr1, align 8
  %fld_ptr2 = getelementptr inbounds nuw %Config, ptr %0, i32 0, i32 2
  store i64 0, ptr %fld_ptr2, align 8
  %fld_ptr3 = getelementptr inbounds nuw %Config, ptr %0, i32 0, i32 3
  store i64 30, ptr %fld_ptr3, align 8
  %cast = ptrtoint ptr %0 to i64
  store i64 %cast, ptr @base, align 8
  %base = load ptr, ptr @base, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %with_cp_src = getelementptr inbounds nuw %Config, ptr %base, i32 0, i32 0
  %with_cp_val = load ptr, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %Config, ptr %1, i32 0, i32 0
  store ptr %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src4 = getelementptr inbounds nuw %Config, ptr %base, i32 0, i32 1
  %with_cp_val5 = load i64, ptr %with_cp_src4, align 8
  %with_cp_dst6 = getelementptr inbounds nuw %Config, ptr %1, i32 0, i32 1
  store i64 %with_cp_val5, ptr %with_cp_dst6, align 8
  %with_cp_src7 = getelementptr inbounds nuw %Config, ptr %base, i32 0, i32 2
  %with_cp_val8 = load i64, ptr %with_cp_src7, align 8
  %with_cp_dst9 = getelementptr inbounds nuw %Config, ptr %1, i32 0, i32 2
  store i64 %with_cp_val8, ptr %with_cp_dst9, align 8
  %with_cp_src10 = getelementptr inbounds nuw %Config, ptr %base, i32 0, i32 3
  %with_cp_val11 = load i64, ptr %with_cp_src10, align 8
  %with_cp_dst12 = getelementptr inbounds nuw %Config, ptr %1, i32 0, i32 3
  store i64 %with_cp_val11, ptr %with_cp_dst12, align 8
  %with_ovr = getelementptr inbounds nuw %Config, ptr %1, i32 0, i32 2
  store i64 1, ptr %with_ovr, align 8
  %cast13 = ptrtoint ptr %1 to i64
  store i64 %cast13, ptr @dev, align 8
  %dev = load ptr, ptr @dev, align 8
  %cast14 = ptrtoint ptr %dev to i64
  %null_chk = icmp eq i64 %cast14, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 5, ptr @sty_name, i64 6, i64 %null_ext, ptr @src_file, i64 97, i64 13)
  %debug_ptr = getelementptr inbounds nuw %Config, ptr %dev, i32 0, i32 2
  %debug = load i64, ptr %debug_ptr, align 8
  %2 = call ptr @avra_rc_alloc(i64 32)
  %3 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %2, i64 32, ptr @.i2s_fmt, i64 %debug)
  %widen = sext i32 %3 to i64
  %4 = call i32 @puts(ptr %2)
  %widen15 = sext i32 %4 to i64
  %dev16 = load ptr, ptr @dev, align 8
  %cast17 = ptrtoint ptr %dev16 to i64
  %null_chk18 = icmp eq i64 %cast17, 0
  %null_ext19 = zext i1 %null_chk18 to i64
  call void @avra_null_deref_trap(ptr @fld_name.1, i64 4, ptr @sty_name.2, i64 6, i64 %null_ext19, ptr @src_file.3, i64 97, i64 14)
  %port_ptr = getelementptr inbounds nuw %Config, ptr %dev16, i32 0, i32 1
  %port = load i64, ptr %port_ptr, align 8
  %5 = call ptr @avra_rc_alloc(i64 32)
  %6 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %5, i64 32, ptr @.i2s_fmt.4, i64 %port)
  %widen20 = sext i32 %6 to i64
  %7 = call i32 @puts(ptr %5)
  %widen21 = sext i32 %7 to i64
  %base22 = load ptr, ptr @base, align 8
  %8 = call ptr @avra_rc_alloc(i64 32)
  %with_cp_src23 = getelementptr inbounds nuw %Config, ptr %base22, i32 0, i32 0
  %with_cp_val24 = load ptr, ptr %with_cp_src23, align 8
  %with_cp_dst25 = getelementptr inbounds nuw %Config, ptr %8, i32 0, i32 0
  store ptr %with_cp_val24, ptr %with_cp_dst25, align 8
  %with_cp_src26 = getelementptr inbounds nuw %Config, ptr %base22, i32 0, i32 1
  %with_cp_val27 = load i64, ptr %with_cp_src26, align 8
  %with_cp_dst28 = getelementptr inbounds nuw %Config, ptr %8, i32 0, i32 1
  store i64 %with_cp_val27, ptr %with_cp_dst28, align 8
  %with_cp_src29 = getelementptr inbounds nuw %Config, ptr %base22, i32 0, i32 2
  %with_cp_val30 = load i64, ptr %with_cp_src29, align 8
  %with_cp_dst31 = getelementptr inbounds nuw %Config, ptr %8, i32 0, i32 2
  store i64 %with_cp_val30, ptr %with_cp_dst31, align 8
  %with_cp_src32 = getelementptr inbounds nuw %Config, ptr %base22, i32 0, i32 3
  %with_cp_val33 = load i64, ptr %with_cp_src32, align 8
  %with_cp_dst34 = getelementptr inbounds nuw %Config, ptr %8, i32 0, i32 3
  store i64 %with_cp_val33, ptr %with_cp_dst34, align 8
  %with_ovr35 = getelementptr inbounds nuw %Config, ptr %8, i32 0, i32 0
  store ptr @.str.5, ptr %with_ovr35, align 8
  %with_ovr36 = getelementptr inbounds nuw %Config, ptr %8, i32 0, i32 1
  store i64 443, ptr %with_ovr36, align 8
  %cast37 = ptrtoint ptr %8 to i64
  store i64 %cast37, ptr @prod, align 8
  %prod = load ptr, ptr @prod, align 8
  %cast38 = ptrtoint ptr %prod to i64
  %null_chk39 = icmp eq i64 %cast38, 0
  %null_ext40 = zext i1 %null_chk39 to i64
  call void @avra_null_deref_trap(ptr @fld_name.6, i64 4, ptr @sty_name.7, i64 6, i64 %null_ext40, ptr @src_file.8, i64 97, i64 18)
  %host_ptr = getelementptr inbounds nuw %Config, ptr %prod, i32 0, i32 0
  %host = load ptr, ptr %host_ptr, align 8
  %9 = call i32 @puts(ptr %host)
  %widen41 = sext i32 %9 to i64
  %prod42 = load ptr, ptr @prod, align 8
  %cast43 = ptrtoint ptr %prod42 to i64
  %null_chk44 = icmp eq i64 %cast43, 0
  %null_ext45 = zext i1 %null_chk44 to i64
  call void @avra_null_deref_trap(ptr @fld_name.9, i64 4, ptr @sty_name.10, i64 6, i64 %null_ext45, ptr @src_file.11, i64 97, i64 19)
  %port_ptr46 = getelementptr inbounds nuw %Config, ptr %prod42, i32 0, i32 1
  %port47 = load i64, ptr %port_ptr46, align 8
  %10 = call ptr @avra_rc_alloc(i64 32)
  %11 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %10, i64 32, ptr @.i2s_fmt.12, i64 %port47)
  %widen48 = sext i32 %11 to i64
  %12 = call i32 @puts(ptr %10)
  %widen49 = sext i32 %12 to i64
  %base50 = load ptr, ptr @base, align 8
  %13 = call ptr @avra_rc_alloc(i64 32)
  %with_cp_src51 = getelementptr inbounds nuw %Config, ptr %base50, i32 0, i32 0
  %with_cp_val52 = load ptr, ptr %with_cp_src51, align 8
  %with_cp_dst53 = getelementptr inbounds nuw %Config, ptr %13, i32 0, i32 0
  store ptr %with_cp_val52, ptr %with_cp_dst53, align 8
  %with_cp_src54 = getelementptr inbounds nuw %Config, ptr %base50, i32 0, i32 1
  %with_cp_val55 = load i64, ptr %with_cp_src54, align 8
  %with_cp_dst56 = getelementptr inbounds nuw %Config, ptr %13, i32 0, i32 1
  store i64 %with_cp_val55, ptr %with_cp_dst56, align 8
  %with_cp_src57 = getelementptr inbounds nuw %Config, ptr %base50, i32 0, i32 2
  %with_cp_val58 = load i64, ptr %with_cp_src57, align 8
  %with_cp_dst59 = getelementptr inbounds nuw %Config, ptr %13, i32 0, i32 2
  store i64 %with_cp_val58, ptr %with_cp_dst59, align 8
  %with_cp_src60 = getelementptr inbounds nuw %Config, ptr %base50, i32 0, i32 3
  %with_cp_val61 = load i64, ptr %with_cp_src60, align 8
  %with_cp_dst62 = getelementptr inbounds nuw %Config, ptr %13, i32 0, i32 3
  store i64 %with_cp_val61, ptr %with_cp_dst62, align 8
  %with_ovr63 = getelementptr inbounds nuw %Config, ptr %13, i32 0, i32 0
  store ptr @.str.13, ptr %with_ovr63, align 8
  %cast64 = ptrtoint ptr %13 to i64
  %14 = call ptr @avra_rc_alloc(i64 32)
  %cast65 = inttoptr i64 %cast64 to ptr
  %with_cp_src66 = getelementptr inbounds nuw %Config, ptr %cast65, i32 0, i32 0
  %with_cp_val67 = load ptr, ptr %with_cp_src66, align 8
  %with_cp_dst68 = getelementptr inbounds nuw %Config, ptr %14, i32 0, i32 0
  store ptr %with_cp_val67, ptr %with_cp_dst68, align 8
  %with_cp_src69 = getelementptr inbounds nuw %Config, ptr %cast65, i32 0, i32 1
  %with_cp_val70 = load i64, ptr %with_cp_src69, align 8
  %with_cp_dst71 = getelementptr inbounds nuw %Config, ptr %14, i32 0, i32 1
  store i64 %with_cp_val70, ptr %with_cp_dst71, align 8
  %with_cp_src72 = getelementptr inbounds nuw %Config, ptr %cast65, i32 0, i32 2
  %with_cp_val73 = load i64, ptr %with_cp_src72, align 8
  %with_cp_dst74 = getelementptr inbounds nuw %Config, ptr %14, i32 0, i32 2
  store i64 %with_cp_val73, ptr %with_cp_dst74, align 8
  %with_cp_src75 = getelementptr inbounds nuw %Config, ptr %cast65, i32 0, i32 3
  %with_cp_val76 = load i64, ptr %with_cp_src75, align 8
  %with_cp_dst77 = getelementptr inbounds nuw %Config, ptr %14, i32 0, i32 3
  store i64 %with_cp_val76, ptr %with_cp_dst77, align 8
  %with_ovr78 = getelementptr inbounds nuw %Config, ptr %14, i32 0, i32 1
  store i64 8443, ptr %with_ovr78, align 8
  %cast79 = ptrtoint ptr %14 to i64
  %15 = call ptr @avra_rc_alloc(i64 32)
  %cast80 = inttoptr i64 %cast79 to ptr
  %with_cp_src81 = getelementptr inbounds nuw %Config, ptr %cast80, i32 0, i32 0
  %with_cp_val82 = load ptr, ptr %with_cp_src81, align 8
  %with_cp_dst83 = getelementptr inbounds nuw %Config, ptr %15, i32 0, i32 0
  store ptr %with_cp_val82, ptr %with_cp_dst83, align 8
  %with_cp_src84 = getelementptr inbounds nuw %Config, ptr %cast80, i32 0, i32 1
  %with_cp_val85 = load i64, ptr %with_cp_src84, align 8
  %with_cp_dst86 = getelementptr inbounds nuw %Config, ptr %15, i32 0, i32 1
  store i64 %with_cp_val85, ptr %with_cp_dst86, align 8
  %with_cp_src87 = getelementptr inbounds nuw %Config, ptr %cast80, i32 0, i32 2
  %with_cp_val88 = load i64, ptr %with_cp_src87, align 8
  %with_cp_dst89 = getelementptr inbounds nuw %Config, ptr %15, i32 0, i32 2
  store i64 %with_cp_val88, ptr %with_cp_dst89, align 8
  %with_cp_src90 = getelementptr inbounds nuw %Config, ptr %cast80, i32 0, i32 3
  %with_cp_val91 = load i64, ptr %with_cp_src90, align 8
  %with_cp_dst92 = getelementptr inbounds nuw %Config, ptr %15, i32 0, i32 3
  store i64 %with_cp_val91, ptr %with_cp_dst92, align 8
  %with_ovr93 = getelementptr inbounds nuw %Config, ptr %15, i32 0, i32 2
  store i64 1, ptr %with_ovr93, align 8
  %cast94 = ptrtoint ptr %15 to i64
  store i64 %cast94, ptr @staging, align 8
  %staging = load ptr, ptr @staging, align 8
  %cast95 = ptrtoint ptr %staging to i64
  %null_chk96 = icmp eq i64 %cast95, 0
  %null_ext97 = zext i1 %null_chk96 to i64
  call void @avra_null_deref_trap(ptr @fld_name.14, i64 4, ptr @sty_name.15, i64 6, i64 %null_ext97, ptr @src_file.16, i64 97, i64 23)
  %host_ptr98 = getelementptr inbounds nuw %Config, ptr %staging, i32 0, i32 0
  %host99 = load ptr, ptr %host_ptr98, align 8
  %16 = call i32 @puts(ptr %host99)
  %widen100 = sext i32 %16 to i64
  %staging101 = load ptr, ptr @staging, align 8
  %cast102 = ptrtoint ptr %staging101 to i64
  %null_chk103 = icmp eq i64 %cast102, 0
  %null_ext104 = zext i1 %null_chk103 to i64
  call void @avra_null_deref_trap(ptr @fld_name.17, i64 4, ptr @sty_name.18, i64 6, i64 %null_ext104, ptr @src_file.19, i64 97, i64 24)
  %port_ptr105 = getelementptr inbounds nuw %Config, ptr %staging101, i32 0, i32 1
  %port106 = load i64, ptr %port_ptr105, align 8
  %17 = call ptr @avra_rc_alloc(i64 32)
  %18 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %17, i64 32, ptr @.i2s_fmt.20, i64 %port106)
  %widen107 = sext i32 %18 to i64
  %19 = call i32 @puts(ptr %17)
  %widen108 = sext i32 %19 to i64
  %staging109 = load ptr, ptr @staging, align 8
  %cast110 = ptrtoint ptr %staging109 to i64
  %null_chk111 = icmp eq i64 %cast110, 0
  %null_ext112 = zext i1 %null_chk111 to i64
  call void @avra_null_deref_trap(ptr @fld_name.21, i64 5, ptr @sty_name.22, i64 6, i64 %null_ext112, ptr @src_file.23, i64 97, i64 25)
  %debug_ptr113 = getelementptr inbounds nuw %Config, ptr %staging109, i32 0, i32 2
  %debug114 = load i64, ptr %debug_ptr113, align 8
  %20 = call ptr @avra_rc_alloc(i64 32)
  %21 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %20, i64 32, ptr @.i2s_fmt.24, i64 %debug114)
  %widen115 = sext i32 %21 to i64
  %22 = call i32 @puts(ptr %20)
  %widen116 = sext i32 %22 to i64
  %staging117 = load ptr, ptr @staging, align 8
  %cast118 = ptrtoint ptr %staging117 to i64
  %null_chk119 = icmp eq i64 %cast118, 0
  %null_ext120 = zext i1 %null_chk119 to i64
  call void @avra_null_deref_trap(ptr @fld_name.25, i64 7, ptr @sty_name.26, i64 6, i64 %null_ext120, ptr @src_file.27, i64 97, i64 26)
  %timeout_ptr = getelementptr inbounds nuw %Config, ptr %staging117, i32 0, i32 3
  %timeout = load i64, ptr %timeout_ptr, align 8
  %23 = call ptr @avra_rc_alloc(i64 32)
  %24 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %23, i64 32, ptr @.i2s_fmt.28, i64 %timeout)
  %widen121 = sext i32 %24 to i64
  %25 = call i32 @puts(ptr %23)
  %widen122 = sext i32 %25 to i64
  %base123 = load ptr, ptr @base, align 8
  %cast124 = ptrtoint ptr %base123 to i64
  %null_chk125 = icmp eq i64 %cast124, 0
  %null_ext126 = zext i1 %null_chk125 to i64
  call void @avra_null_deref_trap(ptr @fld_name.29, i64 4, ptr @sty_name.30, i64 6, i64 %null_ext126, ptr @src_file.31, i64 97, i64 29)
  %host_ptr127 = getelementptr inbounds nuw %Config, ptr %base123, i32 0, i32 0
  %host128 = load ptr, ptr %host_ptr127, align 8
  %26 = call i32 @puts(ptr %host128)
  %widen129 = sext i32 %26 to i64
  %base130 = load ptr, ptr @base, align 8
  %cast131 = ptrtoint ptr %base130 to i64
  %null_chk132 = icmp eq i64 %cast131, 0
  %null_ext133 = zext i1 %null_chk132 to i64
  call void @avra_null_deref_trap(ptr @fld_name.32, i64 4, ptr @sty_name.33, i64 6, i64 %null_ext133, ptr @src_file.34, i64 97, i64 30)
  %port_ptr134 = getelementptr inbounds nuw %Config, ptr %base130, i32 0, i32 1
  %port135 = load i64, ptr %port_ptr134, align 8
  %27 = call ptr @avra_rc_alloc(i64 32)
  %28 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %27, i64 32, ptr @.i2s_fmt.35, i64 %port135)
  %widen136 = sext i32 %28 to i64
  %29 = call i32 @puts(ptr %27)
  %widen137 = sext i32 %29 to i64
  %30 = call i32 @avra_test_summary()
  %widen138 = sext i32 %30 to i64
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Config(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_host_ptr = getelementptr inbounds nuw %Config, ptr %0, i32 0, i32 0
  %rel_host = load ptr, ptr %rel_host_ptr, align 8
  %is_null_host = icmp eq ptr %rel_host, null
  br i1 %is_null_host, label %rel_host_skip, label %rel_host_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_host_skip
  ret i64 0

rel_host_skip:                                    ; preds = %rel_host_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_host_do:                                      ; preds = %do_free
  call void @avra_rc_release(ptr %rel_host)
  br label %rel_host_skip
}
