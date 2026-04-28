; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Config = type { ptr, i64, i64, i64, i64 }

@prod = global i64 0
@dev = global i64 0
@.str = private unnamed_addr constant [10 x i8] c"localhost\00", align 1
@.str.1 = private unnamed_addr constant [17 x i8] c"prod.example.com\00", align 1
@.str.2 = private unnamed_addr constant [7 x i8] c"prod: \00", align 1
@fld_name = private unnamed_addr constant [5 x i8] c"host\00", align 1
@sty_name = private unnamed_addr constant [7 x i8] c"Config\00", align 1
@src_file = private unnamed_addr constant [99 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/prod_builder.av\00", align 1
@.str.3 = private unnamed_addr constant [2 x i8] c":\00", align 1
@fld_name.4 = private unnamed_addr constant [5 x i8] c"port\00", align 1
@sty_name.5 = private unnamed_addr constant [7 x i8] c"Config\00", align 1
@src_file.6 = private unnamed_addr constant [99 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/prod_builder.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.7 = private unnamed_addr constant [8 x i8] c" debug=\00", align 1
@fld_name.8 = private unnamed_addr constant [6 x i8] c"debug\00", align 1
@sty_name.9 = private unnamed_addr constant [7 x i8] c"Config\00", align 1
@src_file.10 = private unnamed_addr constant [99 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/prod_builder.av\00", align 1
@.i2s_fmt.11 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.12 = private unnamed_addr constant [6 x i8] c"dev: \00", align 1
@fld_name.13 = private unnamed_addr constant [5 x i8] c"host\00", align 1
@sty_name.14 = private unnamed_addr constant [7 x i8] c"Config\00", align 1
@src_file.15 = private unnamed_addr constant [99 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/prod_builder.av\00", align 1
@.str.16 = private unnamed_addr constant [2 x i8] c":\00", align 1
@fld_name.17 = private unnamed_addr constant [5 x i8] c"port\00", align 1
@sty_name.18 = private unnamed_addr constant [7 x i8] c"Config\00", align 1
@src_file.19 = private unnamed_addr constant [99 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/prod_builder.av\00", align 1
@.i2s_fmt.20 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.21 = private unnamed_addr constant [8 x i8] c" debug=\00", align 1
@fld_name.22 = private unnamed_addr constant [6 x i8] c"debug\00", align 1
@sty_name.23 = private unnamed_addr constant [7 x i8] c"Config\00", align 1
@src_file.24 = private unnamed_addr constant [99 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/prod_builder.av\00", align 1
@.i2s_fmt.25 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define ptr @default_config() {
entry:
  %0 = call ptr @avra_rc_alloc(i64 40)
  %fld_ptr = getelementptr inbounds nuw %Config, ptr %0, i32 0, i32 0
  store ptr @.str, ptr %fld_ptr, align 8
  %fld_ptr1 = getelementptr inbounds nuw %Config, ptr %0, i32 0, i32 1
  store i64 8080, ptr %fld_ptr1, align 8
  %fld_ptr2 = getelementptr inbounds nuw %Config, ptr %0, i32 0, i32 2
  store i64 4, ptr %fld_ptr2, align 8
  %fld_ptr3 = getelementptr inbounds nuw %Config, ptr %0, i32 0, i32 3
  store i64 0, ptr %fld_ptr3, align 8
  %fld_ptr4 = getelementptr inbounds nuw %Config, ptr %0, i32 0, i32 4
  store i64 30, ptr %fld_ptr4, align 8
  %cast = ptrtoint ptr %0 to i64
  %cast5 = inttoptr i64 %cast to ptr
  ret ptr %cast5
}

define ptr @with_host(ptr %0, ptr %1) {
entry:
  %host = alloca ptr, align 8
  %cfg = alloca ptr, align 8
  store ptr %0, ptr %cfg, align 8
  store ptr %1, ptr %host, align 8
  %cfg1 = load ptr, ptr %cfg, align 8
  %2 = call ptr @avra_rc_alloc(i64 40)
  %with_cp_src = getelementptr inbounds nuw %Config, ptr %cfg1, i32 0, i32 0
  %with_cp_val = load ptr, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %Config, ptr %2, i32 0, i32 0
  store ptr %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src2 = getelementptr inbounds nuw %Config, ptr %cfg1, i32 0, i32 1
  %with_cp_val3 = load i64, ptr %with_cp_src2, align 8
  %with_cp_dst4 = getelementptr inbounds nuw %Config, ptr %2, i32 0, i32 1
  store i64 %with_cp_val3, ptr %with_cp_dst4, align 8
  %with_cp_src5 = getelementptr inbounds nuw %Config, ptr %cfg1, i32 0, i32 2
  %with_cp_val6 = load i64, ptr %with_cp_src5, align 8
  %with_cp_dst7 = getelementptr inbounds nuw %Config, ptr %2, i32 0, i32 2
  store i64 %with_cp_val6, ptr %with_cp_dst7, align 8
  %with_cp_src8 = getelementptr inbounds nuw %Config, ptr %cfg1, i32 0, i32 3
  %with_cp_val9 = load i64, ptr %with_cp_src8, align 8
  %with_cp_dst10 = getelementptr inbounds nuw %Config, ptr %2, i32 0, i32 3
  store i64 %with_cp_val9, ptr %with_cp_dst10, align 8
  %with_cp_src11 = getelementptr inbounds nuw %Config, ptr %cfg1, i32 0, i32 4
  %with_cp_val12 = load i64, ptr %with_cp_src11, align 8
  %with_cp_dst13 = getelementptr inbounds nuw %Config, ptr %2, i32 0, i32 4
  store i64 %with_cp_val12, ptr %with_cp_dst13, align 8
  %host14 = load ptr, ptr %host, align 8
  %with_ovr = getelementptr inbounds nuw %Config, ptr %2, i32 0, i32 0
  store ptr %host14, ptr %with_ovr, align 8
  %cast = ptrtoint ptr %2 to i64
  %cast15 = inttoptr i64 %cast to ptr
  ret ptr %cast15
}

define ptr @with_port(ptr %0, i64 %1) {
entry:
  %port = alloca i64, align 8
  %cfg = alloca ptr, align 8
  store ptr %0, ptr %cfg, align 8
  store i64 %1, ptr %port, align 8
  %cfg1 = load ptr, ptr %cfg, align 8
  %2 = call ptr @avra_rc_alloc(i64 40)
  %with_cp_src = getelementptr inbounds nuw %Config, ptr %cfg1, i32 0, i32 0
  %with_cp_val = load ptr, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %Config, ptr %2, i32 0, i32 0
  store ptr %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src2 = getelementptr inbounds nuw %Config, ptr %cfg1, i32 0, i32 1
  %with_cp_val3 = load i64, ptr %with_cp_src2, align 8
  %with_cp_dst4 = getelementptr inbounds nuw %Config, ptr %2, i32 0, i32 1
  store i64 %with_cp_val3, ptr %with_cp_dst4, align 8
  %with_cp_src5 = getelementptr inbounds nuw %Config, ptr %cfg1, i32 0, i32 2
  %with_cp_val6 = load i64, ptr %with_cp_src5, align 8
  %with_cp_dst7 = getelementptr inbounds nuw %Config, ptr %2, i32 0, i32 2
  store i64 %with_cp_val6, ptr %with_cp_dst7, align 8
  %with_cp_src8 = getelementptr inbounds nuw %Config, ptr %cfg1, i32 0, i32 3
  %with_cp_val9 = load i64, ptr %with_cp_src8, align 8
  %with_cp_dst10 = getelementptr inbounds nuw %Config, ptr %2, i32 0, i32 3
  store i64 %with_cp_val9, ptr %with_cp_dst10, align 8
  %with_cp_src11 = getelementptr inbounds nuw %Config, ptr %cfg1, i32 0, i32 4
  %with_cp_val12 = load i64, ptr %with_cp_src11, align 8
  %with_cp_dst13 = getelementptr inbounds nuw %Config, ptr %2, i32 0, i32 4
  store i64 %with_cp_val12, ptr %with_cp_dst13, align 8
  %port14 = load i64, ptr %port, align 8
  %with_ovr = getelementptr inbounds nuw %Config, ptr %2, i32 0, i32 1
  store i64 %port14, ptr %with_ovr, align 8
  %cast = ptrtoint ptr %2 to i64
  %cast15 = inttoptr i64 %cast to ptr
  ret ptr %cast15
}

define ptr @with_debug(ptr %0) {
entry:
  %cfg = alloca ptr, align 8
  store ptr %0, ptr %cfg, align 8
  %cfg1 = load ptr, ptr %cfg, align 8
  %1 = call ptr @avra_rc_alloc(i64 40)
  %with_cp_src = getelementptr inbounds nuw %Config, ptr %cfg1, i32 0, i32 0
  %with_cp_val = load ptr, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %Config, ptr %1, i32 0, i32 0
  store ptr %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src2 = getelementptr inbounds nuw %Config, ptr %cfg1, i32 0, i32 1
  %with_cp_val3 = load i64, ptr %with_cp_src2, align 8
  %with_cp_dst4 = getelementptr inbounds nuw %Config, ptr %1, i32 0, i32 1
  store i64 %with_cp_val3, ptr %with_cp_dst4, align 8
  %with_cp_src5 = getelementptr inbounds nuw %Config, ptr %cfg1, i32 0, i32 2
  %with_cp_val6 = load i64, ptr %with_cp_src5, align 8
  %with_cp_dst7 = getelementptr inbounds nuw %Config, ptr %1, i32 0, i32 2
  store i64 %with_cp_val6, ptr %with_cp_dst7, align 8
  %with_cp_src8 = getelementptr inbounds nuw %Config, ptr %cfg1, i32 0, i32 3
  %with_cp_val9 = load i64, ptr %with_cp_src8, align 8
  %with_cp_dst10 = getelementptr inbounds nuw %Config, ptr %1, i32 0, i32 3
  store i64 %with_cp_val9, ptr %with_cp_dst10, align 8
  %with_cp_src11 = getelementptr inbounds nuw %Config, ptr %cfg1, i32 0, i32 4
  %with_cp_val12 = load i64, ptr %with_cp_src11, align 8
  %with_cp_dst13 = getelementptr inbounds nuw %Config, ptr %1, i32 0, i32 4
  store i64 %with_cp_val12, ptr %with_cp_dst13, align 8
  %with_ovr = getelementptr inbounds nuw %Config, ptr %1, i32 0, i32 3
  store i64 1, ptr %with_ovr, align 8
  %cast = ptrtoint ptr %1 to i64
  %cast14 = inttoptr i64 %cast to ptr
  ret ptr %cast14
}

define i64 @main() {
entry:
  %0 = call ptr @default_config()
  %1 = call ptr @with_host(ptr %0, ptr @.str.1)
  %2 = call ptr @with_port(ptr %1, i64 443)
  store ptr %2, ptr @prod, align 8
  %3 = call ptr @default_config()
  %4 = call ptr @with_debug(ptr %3)
  store ptr %4, ptr @dev, align 8
  %prod = load ptr, ptr @prod, align 8
  %cast = ptrtoint ptr %prod to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 4, ptr @sty_name, i64 6, i64 %null_ext, ptr @src_file, i64 98, i64 25)
  %host_ptr = getelementptr inbounds nuw %Config, ptr %prod, i32 0, i32 0
  %host = load ptr, ptr %host_ptr, align 8
  %5 = call i64 @strlen(ptr @.str.2)
  %6 = call i64 @strlen(ptr %host)
  %concat_total = add i64 %5, %6
  %concat_size = add i64 %concat_total, 1
  %7 = call ptr @avra_rc_alloc(i64 %concat_size)
  %8 = call ptr @memcpy(ptr %7, ptr @.str.2, i64 %5)
  %cast1 = ptrtoint ptr %7 to i64
  %dst2_int = add i64 %cast1, %5
  %cast2 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %6, 1
  %9 = call ptr @memcpy(ptr %cast2, ptr %host, i64 %rhs_len_p1)
  %10 = call i64 @strlen(ptr %7)
  %11 = call i64 @strlen(ptr @.str.3)
  %concat_total3 = add i64 %10, %11
  %concat_size4 = add i64 %concat_total3, 1
  %12 = call ptr @avra_rc_alloc(i64 %concat_size4)
  %13 = call ptr @memcpy(ptr %12, ptr %7, i64 %10)
  %cast5 = ptrtoint ptr %12 to i64
  %dst2_int6 = add i64 %cast5, %10
  %cast7 = inttoptr i64 %dst2_int6 to ptr
  %rhs_len_p18 = add i64 %11, 1
  %14 = call ptr @memcpy(ptr %cast7, ptr @.str.3, i64 %rhs_len_p18)
  %prod9 = load ptr, ptr @prod, align 8
  %cast10 = ptrtoint ptr %prod9 to i64
  %null_chk11 = icmp eq i64 %cast10, 0
  %null_ext12 = zext i1 %null_chk11 to i64
  call void @avra_null_deref_trap(ptr @fld_name.4, i64 4, ptr @sty_name.5, i64 6, i64 %null_ext12, ptr @src_file.6, i64 98, i64 25)
  %port_ptr = getelementptr inbounds nuw %Config, ptr %prod9, i32 0, i32 1
  %port = load i64, ptr %port_ptr, align 8
  %15 = call ptr @avra_rc_alloc(i64 32)
  %16 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %15, i64 32, ptr @.i2s_fmt, i64 %port)
  %widen = sext i32 %16 to i64
  %17 = call i64 @strlen(ptr %12)
  %18 = call i64 @strlen(ptr %15)
  %concat_total13 = add i64 %17, %18
  %concat_size14 = add i64 %concat_total13, 1
  %19 = call ptr @avra_rc_alloc(i64 %concat_size14)
  %20 = call ptr @memcpy(ptr %19, ptr %12, i64 %17)
  %cast15 = ptrtoint ptr %19 to i64
  %dst2_int16 = add i64 %cast15, %17
  %cast17 = inttoptr i64 %dst2_int16 to ptr
  %rhs_len_p118 = add i64 %18, 1
  %21 = call ptr @memcpy(ptr %cast17, ptr %15, i64 %rhs_len_p118)
  %22 = call i64 @strlen(ptr %19)
  %23 = call i64 @strlen(ptr @.str.7)
  %concat_total19 = add i64 %22, %23
  %concat_size20 = add i64 %concat_total19, 1
  %24 = call ptr @avra_rc_alloc(i64 %concat_size20)
  %25 = call ptr @memcpy(ptr %24, ptr %19, i64 %22)
  %cast21 = ptrtoint ptr %24 to i64
  %dst2_int22 = add i64 %cast21, %22
  %cast23 = inttoptr i64 %dst2_int22 to ptr
  %rhs_len_p124 = add i64 %23, 1
  %26 = call ptr @memcpy(ptr %cast23, ptr @.str.7, i64 %rhs_len_p124)
  %prod25 = load ptr, ptr @prod, align 8
  %cast26 = ptrtoint ptr %prod25 to i64
  %null_chk27 = icmp eq i64 %cast26, 0
  %null_ext28 = zext i1 %null_chk27 to i64
  call void @avra_null_deref_trap(ptr @fld_name.8, i64 5, ptr @sty_name.9, i64 6, i64 %null_ext28, ptr @src_file.10, i64 98, i64 25)
  %debug_ptr = getelementptr inbounds nuw %Config, ptr %prod25, i32 0, i32 3
  %debug = load i64, ptr %debug_ptr, align 8
  %27 = call ptr @avra_rc_alloc(i64 32)
  %28 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %27, i64 32, ptr @.i2s_fmt.11, i64 %debug)
  %widen29 = sext i32 %28 to i64
  %29 = call i64 @strlen(ptr %24)
  %30 = call i64 @strlen(ptr %27)
  %concat_total30 = add i64 %29, %30
  %concat_size31 = add i64 %concat_total30, 1
  %31 = call ptr @avra_rc_alloc(i64 %concat_size31)
  %32 = call ptr @memcpy(ptr %31, ptr %24, i64 %29)
  %cast32 = ptrtoint ptr %31 to i64
  %dst2_int33 = add i64 %cast32, %29
  %cast34 = inttoptr i64 %dst2_int33 to ptr
  %rhs_len_p135 = add i64 %30, 1
  %33 = call ptr @memcpy(ptr %cast34, ptr %27, i64 %rhs_len_p135)
  %34 = call i32 @puts(ptr %31)
  %widen36 = sext i32 %34 to i64
  %dev = load ptr, ptr @dev, align 8
  %cast37 = ptrtoint ptr %dev to i64
  %null_chk38 = icmp eq i64 %cast37, 0
  %null_ext39 = zext i1 %null_chk38 to i64
  call void @avra_null_deref_trap(ptr @fld_name.13, i64 4, ptr @sty_name.14, i64 6, i64 %null_ext39, ptr @src_file.15, i64 98, i64 26)
  %host_ptr40 = getelementptr inbounds nuw %Config, ptr %dev, i32 0, i32 0
  %host41 = load ptr, ptr %host_ptr40, align 8
  %35 = call i64 @strlen(ptr @.str.12)
  %36 = call i64 @strlen(ptr %host41)
  %concat_total42 = add i64 %35, %36
  %concat_size43 = add i64 %concat_total42, 1
  %37 = call ptr @avra_rc_alloc(i64 %concat_size43)
  %38 = call ptr @memcpy(ptr %37, ptr @.str.12, i64 %35)
  %cast44 = ptrtoint ptr %37 to i64
  %dst2_int45 = add i64 %cast44, %35
  %cast46 = inttoptr i64 %dst2_int45 to ptr
  %rhs_len_p147 = add i64 %36, 1
  %39 = call ptr @memcpy(ptr %cast46, ptr %host41, i64 %rhs_len_p147)
  %40 = call i64 @strlen(ptr %37)
  %41 = call i64 @strlen(ptr @.str.16)
  %concat_total48 = add i64 %40, %41
  %concat_size49 = add i64 %concat_total48, 1
  %42 = call ptr @avra_rc_alloc(i64 %concat_size49)
  %43 = call ptr @memcpy(ptr %42, ptr %37, i64 %40)
  %cast50 = ptrtoint ptr %42 to i64
  %dst2_int51 = add i64 %cast50, %40
  %cast52 = inttoptr i64 %dst2_int51 to ptr
  %rhs_len_p153 = add i64 %41, 1
  %44 = call ptr @memcpy(ptr %cast52, ptr @.str.16, i64 %rhs_len_p153)
  %dev54 = load ptr, ptr @dev, align 8
  %cast55 = ptrtoint ptr %dev54 to i64
  %null_chk56 = icmp eq i64 %cast55, 0
  %null_ext57 = zext i1 %null_chk56 to i64
  call void @avra_null_deref_trap(ptr @fld_name.17, i64 4, ptr @sty_name.18, i64 6, i64 %null_ext57, ptr @src_file.19, i64 98, i64 26)
  %port_ptr58 = getelementptr inbounds nuw %Config, ptr %dev54, i32 0, i32 1
  %port59 = load i64, ptr %port_ptr58, align 8
  %45 = call ptr @avra_rc_alloc(i64 32)
  %46 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %45, i64 32, ptr @.i2s_fmt.20, i64 %port59)
  %widen60 = sext i32 %46 to i64
  %47 = call i64 @strlen(ptr %42)
  %48 = call i64 @strlen(ptr %45)
  %concat_total61 = add i64 %47, %48
  %concat_size62 = add i64 %concat_total61, 1
  %49 = call ptr @avra_rc_alloc(i64 %concat_size62)
  %50 = call ptr @memcpy(ptr %49, ptr %42, i64 %47)
  %cast63 = ptrtoint ptr %49 to i64
  %dst2_int64 = add i64 %cast63, %47
  %cast65 = inttoptr i64 %dst2_int64 to ptr
  %rhs_len_p166 = add i64 %48, 1
  %51 = call ptr @memcpy(ptr %cast65, ptr %45, i64 %rhs_len_p166)
  %52 = call i64 @strlen(ptr %49)
  %53 = call i64 @strlen(ptr @.str.21)
  %concat_total67 = add i64 %52, %53
  %concat_size68 = add i64 %concat_total67, 1
  %54 = call ptr @avra_rc_alloc(i64 %concat_size68)
  %55 = call ptr @memcpy(ptr %54, ptr %49, i64 %52)
  %cast69 = ptrtoint ptr %54 to i64
  %dst2_int70 = add i64 %cast69, %52
  %cast71 = inttoptr i64 %dst2_int70 to ptr
  %rhs_len_p172 = add i64 %53, 1
  %56 = call ptr @memcpy(ptr %cast71, ptr @.str.21, i64 %rhs_len_p172)
  %dev73 = load ptr, ptr @dev, align 8
  %cast74 = ptrtoint ptr %dev73 to i64
  %null_chk75 = icmp eq i64 %cast74, 0
  %null_ext76 = zext i1 %null_chk75 to i64
  call void @avra_null_deref_trap(ptr @fld_name.22, i64 5, ptr @sty_name.23, i64 6, i64 %null_ext76, ptr @src_file.24, i64 98, i64 26)
  %debug_ptr77 = getelementptr inbounds nuw %Config, ptr %dev73, i32 0, i32 3
  %debug78 = load i64, ptr %debug_ptr77, align 8
  %57 = call ptr @avra_rc_alloc(i64 32)
  %58 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %57, i64 32, ptr @.i2s_fmt.25, i64 %debug78)
  %widen79 = sext i32 %58 to i64
  %59 = call i64 @strlen(ptr %54)
  %60 = call i64 @strlen(ptr %57)
  %concat_total80 = add i64 %59, %60
  %concat_size81 = add i64 %concat_total80, 1
  %61 = call ptr @avra_rc_alloc(i64 %concat_size81)
  %62 = call ptr @memcpy(ptr %61, ptr %54, i64 %59)
  %cast82 = ptrtoint ptr %61 to i64
  %dst2_int83 = add i64 %cast82, %59
  %cast84 = inttoptr i64 %dst2_int83 to ptr
  %rhs_len_p185 = add i64 %60, 1
  %63 = call ptr @memcpy(ptr %cast84, ptr %57, i64 %rhs_len_p185)
  %64 = call i32 @puts(ptr %61)
  %widen86 = sext i32 %64 to i64
  %65 = call i32 @avra_test_summary()
  %widen87 = sext i32 %65 to i64
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
