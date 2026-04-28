; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Config = type { i64 }
%Color = type { i64, i64, i64 }
%Point = type { i64, i64 }
%Named = type { ptr, i64 }

@fld_name = private unnamed_addr constant [2 x i8] c"x\00", align 1
@sty_name = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file = private unnamed_addr constant [97 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/copy_types.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name.1 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@sty_name.2 = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file.3 = private unnamed_addr constant [97 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/copy_types.av\00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name.5 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@sty_name.6 = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file.7 = private unnamed_addr constant [97 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/copy_types.av\00", align 1
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name.9 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@sty_name.10 = private unnamed_addr constant [6 x i8] c"Point\00", align 1
@src_file.11 = private unnamed_addr constant [97 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/copy_types.av\00", align 1
@.i2s_fmt.12 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name.13 = private unnamed_addr constant [2 x i8] c"r\00", align 1
@sty_name.14 = private unnamed_addr constant [6 x i8] c"Color\00", align 1
@src_file.15 = private unnamed_addr constant [97 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/copy_types.av\00", align 1
@fld_name.16 = private unnamed_addr constant [2 x i8] c"g\00", align 1
@sty_name.17 = private unnamed_addr constant [6 x i8] c"Color\00", align 1
@src_file.18 = private unnamed_addr constant [97 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/copy_types.av\00", align 1
@fld_name.19 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@sty_name.20 = private unnamed_addr constant [6 x i8] c"Color\00", align 1
@src_file.21 = private unnamed_addr constant [97 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/copy_types.av\00", align 1
@.str = private unnamed_addr constant [5 x i8] c"sum=\00", align 1
@.i2s_fmt.22 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.23 = private unnamed_addr constant [6 x i8] c"hello\00", align 1
@.str.24 = private unnamed_addr constant [10 x i8] c"not_copy=\00", align 1
@fld_name.25 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.26 = private unnamed_addr constant [6 x i8] c"Named\00", align 1
@src_file.27 = private unnamed_addr constant [97 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/copy_types.av\00", align 1
@.str.28 = private unnamed_addr constant [10 x i8] c"returned=\00", align 1
@fld_name.29 = private unnamed_addr constant [5 x i8] c"port\00", align 1
@sty_name.30 = private unnamed_addr constant [7 x i8] c"Config\00", align 1
@src_file.31 = private unnamed_addr constant [97 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/copy_types.av\00", align 1
@.i2s_fmt.32 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define ptr @make_config() {
entry:
  %0 = call ptr @avra_rc_alloc(i64 8)
  %fld_ptr = getelementptr inbounds nuw %Config, ptr %0, i32 0, i32 0
  store i64 8080, ptr %fld_ptr, align 8
  %cast = ptrtoint ptr %0 to i64
  %cast1 = inttoptr i64 %cast to ptr
  ret ptr %cast1
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %cfg = alloca ptr, align 8
  %n = alloca ptr, align 8
  %c = alloca ptr, align 8
  %c_copy = alloca %Color, align 8
  %for_end = alloca i64, align 8
  %i = alloca i64, align 8
  %total = alloca i64, align 8
  %p2 = alloca ptr, align 8
  %p = alloca ptr, align 8
  %1 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %Point, ptr %1, i32 0, i32 0
  store i64 42, ptr %fld_ptr, align 8
  %fld_ptr1 = getelementptr inbounds nuw %Point, ptr %1, i32 0, i32 1
  store i64 99, ptr %fld_ptr1, align 8
  %cast = ptrtoint ptr %1 to i64
  %cast2 = inttoptr i64 %cast to ptr
  store ptr %cast2, ptr %p, align 8
  %p3 = load ptr, ptr %p, align 8
  %cast4 = ptrtoint ptr %p3 to i64
  %null_chk = icmp eq i64 %cast4, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 1, ptr @sty_name, i64 5, i64 %null_ext, ptr @src_file, i64 96, i64 25)
  %x_ptr = getelementptr inbounds nuw %Point, ptr %p3, i32 0, i32 0
  %x = load i64, ptr %x_ptr, align 8
  %2 = call ptr @avra_rc_alloc(i64 32)
  %3 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %2, i64 32, ptr @.i2s_fmt, i64 %x)
  %widen = sext i32 %3 to i64
  %4 = call i32 @puts(ptr %2)
  %widen5 = sext i32 %4 to i64
  %p6 = load ptr, ptr %p, align 8
  %cast7 = ptrtoint ptr %p6 to i64
  %null_chk8 = icmp eq i64 %cast7, 0
  %null_ext9 = zext i1 %null_chk8 to i64
  call void @avra_null_deref_trap(ptr @fld_name.1, i64 1, ptr @sty_name.2, i64 5, i64 %null_ext9, ptr @src_file.3, i64 96, i64 26)
  %y_ptr = getelementptr inbounds nuw %Point, ptr %p6, i32 0, i32 1
  %y = load i64, ptr %y_ptr, align 8
  %5 = call ptr @avra_rc_alloc(i64 32)
  %6 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %5, i64 32, ptr @.i2s_fmt.4, i64 %y)
  %widen10 = sext i32 %6 to i64
  %7 = call i32 @puts(ptr %5)
  %widen11 = sext i32 %7 to i64
  %p12 = load ptr, ptr %p, align 8
  %8 = call ptr @avra_rc_alloc(i64 16)
  %with_cp_src = getelementptr inbounds nuw %Point, ptr %p12, i32 0, i32 0
  %with_cp_val = load i64, ptr %with_cp_src, align 8
  %with_cp_dst = getelementptr inbounds nuw %Point, ptr %8, i32 0, i32 0
  store i64 %with_cp_val, ptr %with_cp_dst, align 8
  %with_cp_src13 = getelementptr inbounds nuw %Point, ptr %p12, i32 0, i32 1
  %with_cp_val14 = load i64, ptr %with_cp_src13, align 8
  %with_cp_dst15 = getelementptr inbounds nuw %Point, ptr %8, i32 0, i32 1
  store i64 %with_cp_val14, ptr %with_cp_dst15, align 8
  %with_ovr = getelementptr inbounds nuw %Point, ptr %8, i32 0, i32 0
  store i64 200, ptr %with_ovr, align 8
  %with_ovr16 = getelementptr inbounds nuw %Point, ptr %8, i32 0, i32 1
  store i64 300, ptr %with_ovr16, align 8
  %cast17 = ptrtoint ptr %8 to i64
  %cast18 = inttoptr i64 %cast17 to ptr
  store ptr %cast18, ptr %p2, align 8
  %p219 = load ptr, ptr %p2, align 8
  %cast20 = ptrtoint ptr %p219 to i64
  %null_chk21 = icmp eq i64 %cast20, 0
  %null_ext22 = zext i1 %null_chk21 to i64
  call void @avra_null_deref_trap(ptr @fld_name.5, i64 1, ptr @sty_name.6, i64 5, i64 %null_ext22, ptr @src_file.7, i64 96, i64 30)
  %x_ptr23 = getelementptr inbounds nuw %Point, ptr %p219, i32 0, i32 0
  %x24 = load i64, ptr %x_ptr23, align 8
  %9 = call ptr @avra_rc_alloc(i64 32)
  %10 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %9, i64 32, ptr @.i2s_fmt.8, i64 %x24)
  %widen25 = sext i32 %10 to i64
  %11 = call i32 @puts(ptr %9)
  %widen26 = sext i32 %11 to i64
  %p227 = load ptr, ptr %p2, align 8
  %cast28 = ptrtoint ptr %p227 to i64
  %null_chk29 = icmp eq i64 %cast28, 0
  %null_ext30 = zext i1 %null_chk29 to i64
  call void @avra_null_deref_trap(ptr @fld_name.9, i64 1, ptr @sty_name.10, i64 5, i64 %null_ext30, ptr @src_file.11, i64 96, i64 31)
  %y_ptr31 = getelementptr inbounds nuw %Point, ptr %p227, i32 0, i32 1
  %y32 = load i64, ptr %y_ptr31, align 8
  %12 = call ptr @avra_rc_alloc(i64 32)
  %13 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %12, i64 32, ptr @.i2s_fmt.12, i64 %y32)
  %widen33 = sext i32 %13 to i64
  %14 = call i32 @puts(ptr %12)
  %widen34 = sext i32 %14 to i64
  store i64 0, ptr %total, align 8
  store i64 0, ptr %i, align 8
  store i64 10, ptr %for_end, align 8
  %15 = call ptr @avra_arena_new()
  br label %for.cond

for.cond:                                         ; preds = %for.incr, %entry
  %i35 = load i64, ptr %i, align 8
  %for_end_val = load i64, ptr %for_end, align 8
  %for_cmp = icmp slt i64 %i35, %for_end_val
  br i1 %for_cmp, label %for.body, label %for.exit

for.body:                                         ; preds = %for.cond
  %i36 = load i64, ptr %i, align 8
  %fld_ptr37 = getelementptr inbounds nuw %Color, ptr %c_copy, i32 0, i32 0
  store i64 %i36, ptr %fld_ptr37, align 8
  %i38 = load i64, ptr %i, align 8
  %mul = mul i64 %i38, 2
  %fld_ptr39 = getelementptr inbounds nuw %Color, ptr %c_copy, i32 0, i32 1
  store i64 %mul, ptr %fld_ptr39, align 8
  %i40 = load i64, ptr %i, align 8
  %mul41 = mul i64 %i40, 3
  %fld_ptr42 = getelementptr inbounds nuw %Color, ptr %c_copy, i32 0, i32 2
  store i64 %mul41, ptr %fld_ptr42, align 8
  %cast43 = ptrtoint ptr %c_copy to i64
  %cast44 = inttoptr i64 %cast43 to ptr
  store ptr %cast44, ptr %c, align 8
  %total45 = load i64, ptr %total, align 8
  %c46 = load ptr, ptr %c, align 8
  %cast47 = ptrtoint ptr %c46 to i64
  %null_chk48 = icmp eq i64 %cast47, 0
  %null_ext49 = zext i1 %null_chk48 to i64
  call void @avra_null_deref_trap(ptr @fld_name.13, i64 1, ptr @sty_name.14, i64 5, i64 %null_ext49, ptr @src_file.15, i64 96, i64 37)
  %r_ptr = getelementptr inbounds nuw %Color, ptr %c46, i32 0, i32 0
  %r = load i64, ptr %r_ptr, align 8
  %add = add i64 %total45, %r
  %c50 = load ptr, ptr %c, align 8
  %cast51 = ptrtoint ptr %c50 to i64
  %null_chk52 = icmp eq i64 %cast51, 0
  %null_ext53 = zext i1 %null_chk52 to i64
  call void @avra_null_deref_trap(ptr @fld_name.16, i64 1, ptr @sty_name.17, i64 5, i64 %null_ext53, ptr @src_file.18, i64 96, i64 37)
  %g_ptr = getelementptr inbounds nuw %Color, ptr %c50, i32 0, i32 1
  %g = load i64, ptr %g_ptr, align 8
  %add54 = add i64 %add, %g
  %c55 = load ptr, ptr %c, align 8
  %cast56 = ptrtoint ptr %c55 to i64
  %null_chk57 = icmp eq i64 %cast56, 0
  %null_ext58 = zext i1 %null_chk57 to i64
  call void @avra_null_deref_trap(ptr @fld_name.19, i64 1, ptr @sty_name.20, i64 5, i64 %null_ext58, ptr @src_file.21, i64 96, i64 37)
  %b_ptr = getelementptr inbounds nuw %Color, ptr %c55, i32 0, i32 2
  %b = load i64, ptr %b_ptr, align 8
  %add59 = add i64 %add54, %b
  store i64 %add59, ptr %total, align 8
  br label %for.incr

for.incr:                                         ; preds = %for.body
  %i60 = load i64, ptr %i, align 8
  %for_next = add i64 %i60, 1
  store i64 %for_next, ptr %i, align 8
  br label %for.cond

for.exit:                                         ; preds = %for.cond
  call void @avra_arena_destroy(ptr %15)
  %total61 = load i64, ptr %total, align 8
  %16 = call ptr @avra_rc_alloc(i64 32)
  %17 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %16, i64 32, ptr @.i2s_fmt.22, i64 %total61)
  %widen62 = sext i32 %17 to i64
  %18 = call i64 @strlen(ptr @.str)
  %19 = call i64 @strlen(ptr %16)
  %concat_total = add i64 %18, %19
  %concat_size = add i64 %concat_total, 1
  %20 = call ptr @avra_rc_alloc(i64 %concat_size)
  %21 = call ptr @memcpy(ptr %20, ptr @.str, i64 %18)
  %cast63 = ptrtoint ptr %20 to i64
  %dst2_int = add i64 %cast63, %18
  %cast64 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %19, 1
  %22 = call ptr @memcpy(ptr %cast64, ptr %16, i64 %rhs_len_p1)
  %23 = call i32 @puts(ptr %20)
  %widen65 = sext i32 %23 to i64
  %24 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr66 = getelementptr inbounds nuw %Named, ptr %24, i32 0, i32 0
  store ptr @.str.23, ptr %fld_ptr66, align 8
  %fld_ptr67 = getelementptr inbounds nuw %Named, ptr %24, i32 0, i32 1
  store i64 42, ptr %fld_ptr67, align 8
  %cast68 = ptrtoint ptr %24 to i64
  %cast69 = inttoptr i64 %cast68 to ptr
  store ptr %cast69, ptr %n, align 8
  %n70 = load ptr, ptr %n, align 8
  %cast71 = ptrtoint ptr %n70 to i64
  %null_chk72 = icmp eq i64 %cast71, 0
  %null_ext73 = zext i1 %null_chk72 to i64
  call void @avra_null_deref_trap(ptr @fld_name.25, i64 4, ptr @sty_name.26, i64 5, i64 %null_ext73, ptr @src_file.27, i64 96, i64 43)
  %name_ptr = getelementptr inbounds nuw %Named, ptr %n70, i32 0, i32 0
  %name = load ptr, ptr %name_ptr, align 8
  %25 = call i64 @strlen(ptr @.str.24)
  %26 = call i64 @strlen(ptr %name)
  %concat_total74 = add i64 %25, %26
  %concat_size75 = add i64 %concat_total74, 1
  %27 = call ptr @avra_rc_alloc(i64 %concat_size75)
  %28 = call ptr @memcpy(ptr %27, ptr @.str.24, i64 %25)
  %cast76 = ptrtoint ptr %27 to i64
  %dst2_int77 = add i64 %cast76, %25
  %cast78 = inttoptr i64 %dst2_int77 to ptr
  %rhs_len_p179 = add i64 %26, 1
  %29 = call ptr @memcpy(ptr %cast78, ptr %name, i64 %rhs_len_p179)
  %30 = call i32 @puts(ptr %27)
  %widen80 = sext i32 %30 to i64
  %31 = call ptr @make_config()
  store ptr %31, ptr %cfg, align 8
  %cfg81 = load ptr, ptr %cfg, align 8
  %cast82 = ptrtoint ptr %cfg81 to i64
  %null_chk83 = icmp eq i64 %cast82, 0
  %null_ext84 = zext i1 %null_chk83 to i64
  call void @avra_null_deref_trap(ptr @fld_name.29, i64 4, ptr @sty_name.30, i64 6, i64 %null_ext84, ptr @src_file.31, i64 96, i64 47)
  %port_ptr = getelementptr inbounds nuw %Config, ptr %cfg81, i32 0, i32 0
  %port = load i64, ptr %port_ptr, align 8
  %32 = call ptr @avra_rc_alloc(i64 32)
  %33 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %32, i64 32, ptr @.i2s_fmt.32, i64 %port)
  %widen85 = sext i32 %33 to i64
  %34 = call i64 @strlen(ptr @.str.28)
  %35 = call i64 @strlen(ptr %32)
  %concat_total86 = add i64 %34, %35
  %concat_size87 = add i64 %concat_total86, 1
  %36 = call ptr @avra_rc_alloc(i64 %concat_size87)
  %37 = call ptr @memcpy(ptr %36, ptr @.str.28, i64 %34)
  %cast88 = ptrtoint ptr %36 to i64
  %dst2_int89 = add i64 %cast88, %34
  %cast90 = inttoptr i64 %dst2_int89 to ptr
  %rhs_len_p191 = add i64 %35, 1
  %38 = call ptr @memcpy(ptr %cast90, ptr %32, i64 %rhs_len_p191)
  %39 = call i32 @puts(ptr %36)
  %widen92 = sext i32 %39 to i64
  %n_cleanup = load ptr, ptr %n, align 8
  %40 = call i64 @__release_Named(ptr %n_cleanup)
  %p2_cleanup = load ptr, ptr %p2, align 8
  call void @avra_rc_release(ptr %p2_cleanup)
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Named(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %Named, ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_name_skip
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_name_do:                                      ; preds = %do_free
  call void @avra_rc_release(ptr %rel_name)
  br label %rel_name_skip
}
