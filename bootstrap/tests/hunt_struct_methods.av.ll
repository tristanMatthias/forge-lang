; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Vec2 = type { i64, i64 }

@a = global i64 0
@b = global i64 0
@c = global i64 0
@d = global i64 0
@e = global i64 0
@fld_name = private unnamed_addr constant [2 x i8] c"x\00", align 1
@sty_name = private unnamed_addr constant [5 x i8] c"Vec2\00", align 1
@src_file = private unnamed_addr constant [106 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_struct_methods.av\00", align 1
@fld_name.1 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@sty_name.2 = private unnamed_addr constant [5 x i8] c"Vec2\00", align 1
@src_file.3 = private unnamed_addr constant [106 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_struct_methods.av\00", align 1
@fld_name.4 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@sty_name.5 = private unnamed_addr constant [5 x i8] c"Vec2\00", align 1
@src_file.6 = private unnamed_addr constant [106 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_struct_methods.av\00", align 1
@fld_name.7 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@sty_name.8 = private unnamed_addr constant [5 x i8] c"Vec2\00", align 1
@src_file.9 = private unnamed_addr constant [106 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_struct_methods.av\00", align 1
@fld_name.10 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@sty_name.11 = private unnamed_addr constant [5 x i8] c"Vec2\00", align 1
@src_file.12 = private unnamed_addr constant [106 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_struct_methods.av\00", align 1
@fld_name.13 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@sty_name.14 = private unnamed_addr constant [5 x i8] c"Vec2\00", align 1
@src_file.15 = private unnamed_addr constant [106 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_struct_methods.av\00", align 1
@.str = private unnamed_addr constant [2 x i8] c"(\00", align 1
@fld_name.16 = private unnamed_addr constant [2 x i8] c"x\00", align 1
@sty_name.17 = private unnamed_addr constant [5 x i8] c"Vec2\00", align 1
@src_file.18 = private unnamed_addr constant [106 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_struct_methods.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.19 = private unnamed_addr constant [3 x i8] c", \00", align 1
@fld_name.20 = private unnamed_addr constant [2 x i8] c"y\00", align 1
@sty_name.21 = private unnamed_addr constant [5 x i8] c"Vec2\00", align 1
@src_file.22 = private unnamed_addr constant [106 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_struct_methods.av\00", align 1
@.i2s_fmt.23 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.24 = private unnamed_addr constant [2 x i8] c")\00", align 1
@fld_name.25 = private unnamed_addr constant [4 x i8] c"add\00", align 1
@sty_name.26 = private unnamed_addr constant [5 x i8] c"Vec2\00", align 1
@src_file.27 = private unnamed_addr constant [106 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_struct_methods.av\00", align 1
@fld_name.28 = private unnamed_addr constant [10 x i8] c"to_string\00", align 1
@sty_name.29 = private unnamed_addr constant [5 x i8] c"Vec2\00", align 1
@src_file.30 = private unnamed_addr constant [106 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_struct_methods.av\00", align 1
@fld_name.31 = private unnamed_addr constant [6 x i8] c"scale\00", align 1
@sty_name.32 = private unnamed_addr constant [5 x i8] c"Vec2\00", align 1
@src_file.33 = private unnamed_addr constant [106 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_struct_methods.av\00", align 1
@fld_name.34 = private unnamed_addr constant [10 x i8] c"to_string\00", align 1
@sty_name.35 = private unnamed_addr constant [5 x i8] c"Vec2\00", align 1
@src_file.36 = private unnamed_addr constant [106 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_struct_methods.av\00", align 1
@fld_name.37 = private unnamed_addr constant [6 x i8] c"scale\00", align 1
@sty_name.38 = private unnamed_addr constant [5 x i8] c"Vec2\00", align 1
@src_file.39 = private unnamed_addr constant [106 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_struct_methods.av\00", align 1
@fld_name.40 = private unnamed_addr constant [4 x i8] c"add\00", align 1
@sty_name.41 = private unnamed_addr constant [5 x i8] c"Vec2\00", align 1
@src_file.42 = private unnamed_addr constant [106 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_struct_methods.av\00", align 1
@fld_name.43 = private unnamed_addr constant [10 x i8] c"to_string\00", align 1
@sty_name.44 = private unnamed_addr constant [5 x i8] c"Vec2\00", align 1
@src_file.45 = private unnamed_addr constant [106 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/hunt_struct_methods.av\00", align 1

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

define ptr @Vec2__add(ptr %0, ptr %1) {
entry:
  %other = alloca ptr, align 8
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  store ptr %1, ptr %other, align 8
  %2 = call ptr @avra_rc_alloc(i64 16)
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 1, ptr @sty_name, i64 4, i64 %null_ext, ptr @src_file, i64 105, i64 6)
  %x_ptr = getelementptr inbounds nuw %Vec2, ptr %self1, i32 0, i32 0
  %x = load i64, ptr %x_ptr, align 8
  %other2 = load ptr, ptr %other, align 8
  %cast3 = ptrtoint ptr %other2 to i64
  %null_chk4 = icmp eq i64 %cast3, 0
  %null_ext5 = zext i1 %null_chk4 to i64
  call void @avra_null_deref_trap(ptr @fld_name.1, i64 1, ptr @sty_name.2, i64 4, i64 %null_ext5, ptr @src_file.3, i64 105, i64 6)
  %x_ptr6 = getelementptr inbounds nuw %Vec2, ptr %other2, i32 0, i32 0
  %x7 = load i64, ptr %x_ptr6, align 8
  %add = add i64 %x, %x7
  %fld_ptr = getelementptr inbounds nuw %Vec2, ptr %2, i32 0, i32 0
  store i64 %add, ptr %fld_ptr, align 8
  %self8 = load ptr, ptr %self, align 8
  %cast9 = ptrtoint ptr %self8 to i64
  %null_chk10 = icmp eq i64 %cast9, 0
  %null_ext11 = zext i1 %null_chk10 to i64
  call void @avra_null_deref_trap(ptr @fld_name.4, i64 1, ptr @sty_name.5, i64 4, i64 %null_ext11, ptr @src_file.6, i64 105, i64 6)
  %y_ptr = getelementptr inbounds nuw %Vec2, ptr %self8, i32 0, i32 1
  %y = load i64, ptr %y_ptr, align 8
  %other12 = load ptr, ptr %other, align 8
  %cast13 = ptrtoint ptr %other12 to i64
  %null_chk14 = icmp eq i64 %cast13, 0
  %null_ext15 = zext i1 %null_chk14 to i64
  call void @avra_null_deref_trap(ptr @fld_name.7, i64 1, ptr @sty_name.8, i64 4, i64 %null_ext15, ptr @src_file.9, i64 105, i64 6)
  %y_ptr16 = getelementptr inbounds nuw %Vec2, ptr %other12, i32 0, i32 1
  %y17 = load i64, ptr %y_ptr16, align 8
  %add18 = add i64 %y, %y17
  %fld_ptr19 = getelementptr inbounds nuw %Vec2, ptr %2, i32 0, i32 1
  store i64 %add18, ptr %fld_ptr19, align 8
  %cast20 = ptrtoint ptr %2 to i64
  %cast21 = inttoptr i64 %cast20 to ptr
  ret ptr %cast21
}

define ptr @Vec2__scale(ptr %0, i64 %1) {
entry:
  %factor = alloca i64, align 8
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  store i64 %1, ptr %factor, align 8
  %2 = call ptr @avra_rc_alloc(i64 16)
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.10, i64 1, ptr @sty_name.11, i64 4, i64 %null_ext, ptr @src_file.12, i64 105, i64 9)
  %x_ptr = getelementptr inbounds nuw %Vec2, ptr %self1, i32 0, i32 0
  %x = load i64, ptr %x_ptr, align 8
  %factor2 = load i64, ptr %factor, align 8
  %mul = mul i64 %x, %factor2
  %fld_ptr = getelementptr inbounds nuw %Vec2, ptr %2, i32 0, i32 0
  store i64 %mul, ptr %fld_ptr, align 8
  %self3 = load ptr, ptr %self, align 8
  %cast4 = ptrtoint ptr %self3 to i64
  %null_chk5 = icmp eq i64 %cast4, 0
  %null_ext6 = zext i1 %null_chk5 to i64
  call void @avra_null_deref_trap(ptr @fld_name.13, i64 1, ptr @sty_name.14, i64 4, i64 %null_ext6, ptr @src_file.15, i64 105, i64 9)
  %y_ptr = getelementptr inbounds nuw %Vec2, ptr %self3, i32 0, i32 1
  %y = load i64, ptr %y_ptr, align 8
  %factor7 = load i64, ptr %factor, align 8
  %mul8 = mul i64 %y, %factor7
  %fld_ptr9 = getelementptr inbounds nuw %Vec2, ptr %2, i32 0, i32 1
  store i64 %mul8, ptr %fld_ptr9, align 8
  %cast10 = ptrtoint ptr %2 to i64
  %cast11 = inttoptr i64 %cast10 to ptr
  ret ptr %cast11
}

define ptr @Vec2__to_string(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.16, i64 1, ptr @sty_name.17, i64 4, i64 %null_ext, ptr @src_file.18, i64 105, i64 12)
  %x_ptr = getelementptr inbounds nuw %Vec2, ptr %self1, i32 0, i32 0
  %x = load i64, ptr %x_ptr, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %x)
  %widen = sext i32 %2 to i64
  %3 = call i64 @strlen(ptr @.str)
  %4 = call i64 @strlen(ptr %1)
  %concat_total = add i64 %3, %4
  %concat_size = add i64 %concat_total, 1
  %5 = call ptr @avra_rc_alloc(i64 %concat_size)
  %6 = call ptr @memcpy(ptr %5, ptr @.str, i64 %3)
  %cast2 = ptrtoint ptr %5 to i64
  %dst2_int = add i64 %cast2, %3
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast3, ptr %1, i64 %rhs_len_p1)
  %8 = call i64 @strlen(ptr %5)
  %9 = call i64 @strlen(ptr @.str.19)
  %concat_total4 = add i64 %8, %9
  %concat_size5 = add i64 %concat_total4, 1
  %10 = call ptr @avra_rc_alloc(i64 %concat_size5)
  %11 = call ptr @memcpy(ptr %10, ptr %5, i64 %8)
  %cast6 = ptrtoint ptr %10 to i64
  %dst2_int7 = add i64 %cast6, %8
  %cast8 = inttoptr i64 %dst2_int7 to ptr
  %rhs_len_p19 = add i64 %9, 1
  %12 = call ptr @memcpy(ptr %cast8, ptr @.str.19, i64 %rhs_len_p19)
  %self10 = load ptr, ptr %self, align 8
  %cast11 = ptrtoint ptr %self10 to i64
  %null_chk12 = icmp eq i64 %cast11, 0
  %null_ext13 = zext i1 %null_chk12 to i64
  call void @avra_null_deref_trap(ptr @fld_name.20, i64 1, ptr @sty_name.21, i64 4, i64 %null_ext13, ptr @src_file.22, i64 105, i64 12)
  %y_ptr = getelementptr inbounds nuw %Vec2, ptr %self10, i32 0, i32 1
  %y = load i64, ptr %y_ptr, align 8
  %13 = call ptr @avra_rc_alloc(i64 32)
  %14 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %13, i64 32, ptr @.i2s_fmt.23, i64 %y)
  %widen14 = sext i32 %14 to i64
  %15 = call i64 @strlen(ptr %10)
  %16 = call i64 @strlen(ptr %13)
  %concat_total15 = add i64 %15, %16
  %concat_size16 = add i64 %concat_total15, 1
  %17 = call ptr @avra_rc_alloc(i64 %concat_size16)
  %18 = call ptr @memcpy(ptr %17, ptr %10, i64 %15)
  %cast17 = ptrtoint ptr %17 to i64
  %dst2_int18 = add i64 %cast17, %15
  %cast19 = inttoptr i64 %dst2_int18 to ptr
  %rhs_len_p120 = add i64 %16, 1
  %19 = call ptr @memcpy(ptr %cast19, ptr %13, i64 %rhs_len_p120)
  %20 = call i64 @strlen(ptr %17)
  %21 = call i64 @strlen(ptr @.str.24)
  %concat_total21 = add i64 %20, %21
  %concat_size22 = add i64 %concat_total21, 1
  %22 = call ptr @avra_rc_alloc(i64 %concat_size22)
  %23 = call ptr @memcpy(ptr %22, ptr %17, i64 %20)
  %cast23 = ptrtoint ptr %22 to i64
  %dst2_int24 = add i64 %cast23, %20
  %cast25 = inttoptr i64 %dst2_int24 to ptr
  %rhs_len_p126 = add i64 %21, 1
  %24 = call ptr @memcpy(ptr %cast25, ptr @.str.24, i64 %rhs_len_p126)
  ret ptr %22
}

define i64 @main() {
entry:
  %0 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %Vec2, ptr %0, i32 0, i32 0
  store i64 1, ptr %fld_ptr, align 8
  %fld_ptr1 = getelementptr inbounds nuw %Vec2, ptr %0, i32 0, i32 1
  store i64 2, ptr %fld_ptr1, align 8
  %cast = ptrtoint ptr %0 to i64
  store i64 %cast, ptr @a, align 8
  %1 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr2 = getelementptr inbounds nuw %Vec2, ptr %1, i32 0, i32 0
  store i64 3, ptr %fld_ptr2, align 8
  %fld_ptr3 = getelementptr inbounds nuw %Vec2, ptr %1, i32 0, i32 1
  store i64 4, ptr %fld_ptr3, align 8
  %cast4 = ptrtoint ptr %1 to i64
  store i64 %cast4, ptr @b, align 8
  %a = load ptr, ptr @a, align 8
  %cast5 = ptrtoint ptr %a to i64
  %null_chk = icmp eq i64 %cast5, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.25, i64 3, ptr @sty_name.26, i64 4, i64 %null_ext, ptr @src_file.27, i64 105, i64 18)
  %b = load ptr, ptr @b, align 8
  %2 = call ptr @Vec2__add(ptr %a, ptr %b)
  store ptr %2, ptr @c, align 8
  %c = load ptr, ptr @c, align 8
  %cast6 = ptrtoint ptr %c to i64
  %null_chk7 = icmp eq i64 %cast6, 0
  %null_ext8 = zext i1 %null_chk7 to i64
  call void @avra_null_deref_trap(ptr @fld_name.28, i64 9, ptr @sty_name.29, i64 4, i64 %null_ext8, ptr @src_file.30, i64 105, i64 19)
  %3 = call ptr @Vec2__to_string(ptr %c)
  %4 = call i32 @puts(ptr %3)
  %widen = sext i32 %4 to i64
  %c9 = load ptr, ptr @c, align 8
  %cast10 = ptrtoint ptr %c9 to i64
  %null_chk11 = icmp eq i64 %cast10, 0
  %null_ext12 = zext i1 %null_chk11 to i64
  call void @avra_null_deref_trap(ptr @fld_name.31, i64 5, ptr @sty_name.32, i64 4, i64 %null_ext12, ptr @src_file.33, i64 105, i64 20)
  %5 = call ptr @Vec2__scale(ptr %c9, i64 2)
  store ptr %5, ptr @d, align 8
  %d = load ptr, ptr @d, align 8
  %cast13 = ptrtoint ptr %d to i64
  %null_chk14 = icmp eq i64 %cast13, 0
  %null_ext15 = zext i1 %null_chk14 to i64
  call void @avra_null_deref_trap(ptr @fld_name.34, i64 9, ptr @sty_name.35, i64 4, i64 %null_ext15, ptr @src_file.36, i64 105, i64 21)
  %6 = call ptr @Vec2__to_string(ptr %d)
  %7 = call i32 @puts(ptr %6)
  %widen16 = sext i32 %7 to i64
  %8 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr17 = getelementptr inbounds nuw %Vec2, ptr %8, i32 0, i32 0
  store i64 1, ptr %fld_ptr17, align 8
  %fld_ptr18 = getelementptr inbounds nuw %Vec2, ptr %8, i32 0, i32 1
  store i64 1, ptr %fld_ptr18, align 8
  %cast19 = ptrtoint ptr %8 to i64
  %null_chk20 = icmp eq i64 %cast19, 0
  %null_ext21 = zext i1 %null_chk20 to i64
  call void @avra_null_deref_trap(ptr @fld_name.37, i64 5, ptr @sty_name.38, i64 4, i64 %null_ext21, ptr @src_file.39, i64 105, i64 24)
  %cast22 = inttoptr i64 %cast19 to ptr
  %9 = call ptr @Vec2__scale(ptr %cast22, i64 5)
  %cast23 = ptrtoint ptr %9 to i64
  %null_chk24 = icmp eq i64 %cast23, 0
  %null_ext25 = zext i1 %null_chk24 to i64
  call void @avra_null_deref_trap(ptr @fld_name.40, i64 3, ptr @sty_name.41, i64 4, i64 %null_ext25, ptr @src_file.42, i64 105, i64 24)
  %10 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr26 = getelementptr inbounds nuw %Vec2, ptr %10, i32 0, i32 0
  store i64 10, ptr %fld_ptr26, align 8
  %fld_ptr27 = getelementptr inbounds nuw %Vec2, ptr %10, i32 0, i32 1
  store i64 10, ptr %fld_ptr27, align 8
  %cast28 = ptrtoint ptr %10 to i64
  %cast29 = inttoptr i64 %cast28 to ptr
  %11 = call ptr @Vec2__add(ptr %9, ptr %cast29)
  store ptr %11, ptr @e, align 8
  %e = load ptr, ptr @e, align 8
  %cast30 = ptrtoint ptr %e to i64
  %null_chk31 = icmp eq i64 %cast30, 0
  %null_ext32 = zext i1 %null_chk31 to i64
  call void @avra_null_deref_trap(ptr @fld_name.43, i64 9, ptr @sty_name.44, i64 4, i64 %null_ext32, ptr @src_file.45, i64 105, i64 25)
  %12 = call ptr @Vec2__to_string(ptr %e)
  %13 = call i32 @puts(ptr %12)
  %widen33 = sext i32 %13 to i64
  %14 = call i32 @avra_test_summary()
  %widen34 = sext i32 %14 to i64
  call void @avra_rc_collect()
  ret i64 0
}
