; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Dog = type { ptr }
%Cat = type { ptr }

@.str = private unnamed_addr constant [6 x i8] c"dog (\00", align 1
@fld_name = private unnamed_addr constant [6 x i8] c"breed\00", align 1
@sty_name = private unnamed_addr constant [4 x i8] c"Dog\00", align 1
@src_file = private unnamed_addr constant [104 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_conformance.av\00", align 1
@.str.1 = private unnamed_addr constant [2 x i8] c")\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"woof\00", align 1
@.str.3 = private unnamed_addr constant [6 x i8] c"cat (\00", align 1
@fld_name.4 = private unnamed_addr constant [6 x i8] c"color\00", align 1
@sty_name.5 = private unnamed_addr constant [4 x i8] c"Cat\00", align 1
@src_file.6 = private unnamed_addr constant [104 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_conformance.av\00", align 1
@.str.7 = private unnamed_addr constant [2 x i8] c")\00", align 1
@.str.8 = private unnamed_addr constant [5 x i8] c"meow\00", align 1
@fld_name.9 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.10 = private unnamed_addr constant [4 x i8] c"Dog\00", align 1
@src_file.11 = private unnamed_addr constant [104 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_conformance.av\00", align 1
@.str.12 = private unnamed_addr constant [7 x i8] c" says \00", align 1
@fld_name.13 = private unnamed_addr constant [6 x i8] c"sound\00", align 1
@sty_name.14 = private unnamed_addr constant [4 x i8] c"Dog\00", align 1
@src_file.15 = private unnamed_addr constant [104 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_conformance.av\00", align 1
@.str.16 = private unnamed_addr constant [8 x i8] c" (size \00", align 1
@fld_name.17 = private unnamed_addr constant [5 x i8] c"size\00", align 1
@sty_name.18 = private unnamed_addr constant [4 x i8] c"Dog\00", align 1
@src_file.19 = private unnamed_addr constant [104 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_conformance.av\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.20 = private unnamed_addr constant [2 x i8] c")\00", align 1
@.str.21 = private unnamed_addr constant [9 x i8] c"labrador\00", align 1
@.str.22 = private unnamed_addr constant [6 x i8] c"black\00", align 1
@fld_name.23 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.24 = private unnamed_addr constant [4 x i8] c"Dog\00", align 1
@src_file.25 = private unnamed_addr constant [104 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_conformance.av\00", align 1
@fld_name.26 = private unnamed_addr constant [6 x i8] c"sound\00", align 1
@sty_name.27 = private unnamed_addr constant [4 x i8] c"Dog\00", align 1
@src_file.28 = private unnamed_addr constant [104 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_conformance.av\00", align 1
@fld_name.29 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.30 = private unnamed_addr constant [4 x i8] c"Cat\00", align 1
@src_file.31 = private unnamed_addr constant [104 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_conformance.av\00", align 1
@fld_name.32 = private unnamed_addr constant [6 x i8] c"sound\00", align 1
@sty_name.33 = private unnamed_addr constant [4 x i8] c"Cat\00", align 1
@src_file.34 = private unnamed_addr constant [104 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_conformance.av\00", align 1
@fld_name.35 = private unnamed_addr constant [5 x i8] c"size\00", align 1
@sty_name.36 = private unnamed_addr constant [4 x i8] c"Dog\00", align 1
@src_file.37 = private unnamed_addr constant [104 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_conformance.av\00", align 1
@.i2s_fmt.38 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@fld_name.39 = private unnamed_addr constant [5 x i8] c"size\00", align 1
@sty_name.40 = private unnamed_addr constant [4 x i8] c"Cat\00", align 1
@src_file.41 = private unnamed_addr constant [104 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/trait_conformance.av\00", align 1
@.i2s_fmt.42 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define ptr @Dog__name(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 5, ptr @sty_name, i64 3, i64 %null_ext, ptr @src_file, i64 103, i64 12)
  %breed_ptr = getelementptr inbounds nuw %Dog, ptr %self1, i32 0, i32 0
  %breed = load ptr, ptr %breed_ptr, align 8
  %1 = call i64 @strlen(ptr @.str)
  %2 = call i64 @strlen(ptr %breed)
  %concat_total = add i64 %1, %2
  %concat_size = add i64 %concat_total, 1
  %3 = call ptr @avra_rc_alloc(i64 %concat_size)
  %4 = call ptr @memcpy(ptr %3, ptr @.str, i64 %1)
  %cast2 = ptrtoint ptr %3 to i64
  %dst2_int = add i64 %cast2, %1
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %2, 1
  %5 = call ptr @memcpy(ptr %cast3, ptr %breed, i64 %rhs_len_p1)
  %6 = call i64 @strlen(ptr %3)
  %7 = call i64 @strlen(ptr @.str.1)
  %concat_total4 = add i64 %6, %7
  %concat_size5 = add i64 %concat_total4, 1
  %8 = call ptr @avra_rc_alloc(i64 %concat_size5)
  %9 = call ptr @memcpy(ptr %8, ptr %3, i64 %6)
  %cast6 = ptrtoint ptr %8 to i64
  %dst2_int7 = add i64 %cast6, %6
  %cast8 = inttoptr i64 %dst2_int7 to ptr
  %rhs_len_p19 = add i64 %7, 1
  %10 = call ptr @memcpy(ptr %cast8, ptr @.str.1, i64 %rhs_len_p19)
  ret ptr %8
}

define ptr @Dog__sound(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  ret ptr @.str.2
}

define ptr @Cat__name(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.4, i64 5, ptr @sty_name.5, i64 3, i64 %null_ext, ptr @src_file.6, i64 103, i64 17)
  %color_ptr = getelementptr inbounds nuw %Cat, ptr %self1, i32 0, i32 0
  %color = load ptr, ptr %color_ptr, align 8
  %1 = call i64 @strlen(ptr @.str.3)
  %2 = call i64 @strlen(ptr %color)
  %concat_total = add i64 %1, %2
  %concat_size = add i64 %concat_total, 1
  %3 = call ptr @avra_rc_alloc(i64 %concat_size)
  %4 = call ptr @memcpy(ptr %3, ptr @.str.3, i64 %1)
  %cast2 = ptrtoint ptr %3 to i64
  %dst2_int = add i64 %cast2, %1
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %2, 1
  %5 = call ptr @memcpy(ptr %cast3, ptr %color, i64 %rhs_len_p1)
  %6 = call i64 @strlen(ptr %3)
  %7 = call i64 @strlen(ptr @.str.7)
  %concat_total4 = add i64 %6, %7
  %concat_size5 = add i64 %concat_total4, 1
  %8 = call ptr @avra_rc_alloc(i64 %concat_size5)
  %9 = call ptr @memcpy(ptr %8, ptr %3, i64 %6)
  %cast6 = ptrtoint ptr %8 to i64
  %dst2_int7 = add i64 %cast6, %6
  %cast8 = inttoptr i64 %dst2_int7 to ptr
  %rhs_len_p19 = add i64 %7, 1
  %10 = call ptr @memcpy(ptr %cast8, ptr @.str.7, i64 %rhs_len_p19)
  ret ptr %8
}

define ptr @Cat__sound(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  ret ptr @.str.8
}

define i64 @Dog__size(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  ret i64 30
}

define i64 @Cat__size(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  ret i64 10
}

define ptr @describe(ptr %0) {
entry:
  %d = alloca ptr, align 8
  store ptr %0, ptr %d, align 8
  %d1 = load ptr, ptr %d, align 8
  %cast = ptrtoint ptr %d1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.9, i64 4, ptr @sty_name.10, i64 3, i64 %null_ext, ptr @src_file.11, i64 103, i64 35)
  %1 = call ptr @Dog__name(ptr %d1)
  %2 = call i64 @strlen(ptr %1)
  %3 = call i64 @strlen(ptr @.str.12)
  %concat_total = add i64 %2, %3
  %concat_size = add i64 %concat_total, 1
  %4 = call ptr @avra_rc_alloc(i64 %concat_size)
  %5 = call ptr @memcpy(ptr %4, ptr %1, i64 %2)
  %cast2 = ptrtoint ptr %4 to i64
  %dst2_int = add i64 %cast2, %2
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %3, 1
  %6 = call ptr @memcpy(ptr %cast3, ptr @.str.12, i64 %rhs_len_p1)
  %d4 = load ptr, ptr %d, align 8
  %cast5 = ptrtoint ptr %d4 to i64
  %null_chk6 = icmp eq i64 %cast5, 0
  %null_ext7 = zext i1 %null_chk6 to i64
  call void @avra_null_deref_trap(ptr @fld_name.13, i64 5, ptr @sty_name.14, i64 3, i64 %null_ext7, ptr @src_file.15, i64 103, i64 35)
  %7 = call ptr @Dog__sound(ptr %d4)
  %8 = call i64 @strlen(ptr %4)
  %9 = call i64 @strlen(ptr %7)
  %concat_total8 = add i64 %8, %9
  %concat_size9 = add i64 %concat_total8, 1
  %10 = call ptr @avra_rc_alloc(i64 %concat_size9)
  %11 = call ptr @memcpy(ptr %10, ptr %4, i64 %8)
  %cast10 = ptrtoint ptr %10 to i64
  %dst2_int11 = add i64 %cast10, %8
  %cast12 = inttoptr i64 %dst2_int11 to ptr
  %rhs_len_p113 = add i64 %9, 1
  %12 = call ptr @memcpy(ptr %cast12, ptr %7, i64 %rhs_len_p113)
  %13 = call i64 @strlen(ptr %10)
  %14 = call i64 @strlen(ptr @.str.16)
  %concat_total14 = add i64 %13, %14
  %concat_size15 = add i64 %concat_total14, 1
  %15 = call ptr @avra_rc_alloc(i64 %concat_size15)
  %16 = call ptr @memcpy(ptr %15, ptr %10, i64 %13)
  %cast16 = ptrtoint ptr %15 to i64
  %dst2_int17 = add i64 %cast16, %13
  %cast18 = inttoptr i64 %dst2_int17 to ptr
  %rhs_len_p119 = add i64 %14, 1
  %17 = call ptr @memcpy(ptr %cast18, ptr @.str.16, i64 %rhs_len_p119)
  %d20 = load ptr, ptr %d, align 8
  %cast21 = ptrtoint ptr %d20 to i64
  %null_chk22 = icmp eq i64 %cast21, 0
  %null_ext23 = zext i1 %null_chk22 to i64
  call void @avra_null_deref_trap(ptr @fld_name.17, i64 4, ptr @sty_name.18, i64 3, i64 %null_ext23, ptr @src_file.19, i64 103, i64 35)
  %18 = call i64 @Dog__size(ptr %d20)
  %19 = call ptr @avra_rc_alloc(i64 32)
  %20 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %19, i64 32, ptr @.i2s_fmt, i64 %18)
  %widen = sext i32 %20 to i64
  %21 = call i64 @strlen(ptr %15)
  %22 = call i64 @strlen(ptr %19)
  %concat_total24 = add i64 %21, %22
  %concat_size25 = add i64 %concat_total24, 1
  %23 = call ptr @avra_rc_alloc(i64 %concat_size25)
  %24 = call ptr @memcpy(ptr %23, ptr %15, i64 %21)
  %cast26 = ptrtoint ptr %23 to i64
  %dst2_int27 = add i64 %cast26, %21
  %cast28 = inttoptr i64 %dst2_int27 to ptr
  %rhs_len_p129 = add i64 %22, 1
  %25 = call ptr @memcpy(ptr %cast28, ptr %19, i64 %rhs_len_p129)
  %26 = call i64 @strlen(ptr %23)
  %27 = call i64 @strlen(ptr @.str.20)
  %concat_total30 = add i64 %26, %27
  %concat_size31 = add i64 %concat_total30, 1
  %28 = call ptr @avra_rc_alloc(i64 %concat_size31)
  %29 = call ptr @memcpy(ptr %28, ptr %23, i64 %26)
  %cast32 = ptrtoint ptr %28 to i64
  %dst2_int33 = add i64 %cast32, %26
  %cast34 = inttoptr i64 %dst2_int33 to ptr
  %rhs_len_p135 = add i64 %27, 1
  %30 = call ptr @memcpy(ptr %cast34, ptr @.str.20, i64 %rhs_len_p135)
  ret ptr %28
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %c = alloca ptr, align 8
  %d = alloca ptr, align 8
  %1 = call ptr @avra_rc_alloc(i64 8)
  %fld_ptr = getelementptr inbounds nuw %Dog, ptr %1, i32 0, i32 0
  store ptr @.str.21, ptr %fld_ptr, align 8
  %cast = ptrtoint ptr %1 to i64
  %cast1 = inttoptr i64 %cast to ptr
  store ptr %cast1, ptr %d, align 8
  %2 = call ptr @avra_rc_alloc(i64 8)
  %fld_ptr2 = getelementptr inbounds nuw %Cat, ptr %2, i32 0, i32 0
  store ptr @.str.22, ptr %fld_ptr2, align 8
  %cast3 = ptrtoint ptr %2 to i64
  %cast4 = inttoptr i64 %cast3 to ptr
  store ptr %cast4, ptr %c, align 8
  %d5 = load ptr, ptr %d, align 8
  %cast6 = ptrtoint ptr %d5 to i64
  %null_chk = icmp eq i64 %cast6, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.23, i64 4, ptr @sty_name.24, i64 3, i64 %null_ext, ptr @src_file.25, i64 103, i64 42)
  %3 = call ptr @Dog__name(ptr %d5)
  %4 = call i32 @puts(ptr %3)
  %widen = sext i32 %4 to i64
  %d7 = load ptr, ptr %d, align 8
  %cast8 = ptrtoint ptr %d7 to i64
  %null_chk9 = icmp eq i64 %cast8, 0
  %null_ext10 = zext i1 %null_chk9 to i64
  call void @avra_null_deref_trap(ptr @fld_name.26, i64 5, ptr @sty_name.27, i64 3, i64 %null_ext10, ptr @src_file.28, i64 103, i64 43)
  %5 = call ptr @Dog__sound(ptr %d7)
  %6 = call i32 @puts(ptr %5)
  %widen11 = sext i32 %6 to i64
  %c12 = load ptr, ptr %c, align 8
  %cast13 = ptrtoint ptr %c12 to i64
  %null_chk14 = icmp eq i64 %cast13, 0
  %null_ext15 = zext i1 %null_chk14 to i64
  call void @avra_null_deref_trap(ptr @fld_name.29, i64 4, ptr @sty_name.30, i64 3, i64 %null_ext15, ptr @src_file.31, i64 103, i64 44)
  %7 = call ptr @Cat__name(ptr %c12)
  %8 = call i32 @puts(ptr %7)
  %widen16 = sext i32 %8 to i64
  %c17 = load ptr, ptr %c, align 8
  %cast18 = ptrtoint ptr %c17 to i64
  %null_chk19 = icmp eq i64 %cast18, 0
  %null_ext20 = zext i1 %null_chk19 to i64
  call void @avra_null_deref_trap(ptr @fld_name.32, i64 5, ptr @sty_name.33, i64 3, i64 %null_ext20, ptr @src_file.34, i64 103, i64 45)
  %9 = call ptr @Cat__sound(ptr %c17)
  %10 = call i32 @puts(ptr %9)
  %widen21 = sext i32 %10 to i64
  %d22 = load ptr, ptr %d, align 8
  %cast23 = ptrtoint ptr %d22 to i64
  %null_chk24 = icmp eq i64 %cast23, 0
  %null_ext25 = zext i1 %null_chk24 to i64
  call void @avra_null_deref_trap(ptr @fld_name.35, i64 4, ptr @sty_name.36, i64 3, i64 %null_ext25, ptr @src_file.37, i64 103, i64 47)
  %11 = call i64 @Dog__size(ptr %d22)
  %12 = call ptr @avra_rc_alloc(i64 32)
  %13 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %12, i64 32, ptr @.i2s_fmt.38, i64 %11)
  %widen26 = sext i32 %13 to i64
  %14 = call i32 @puts(ptr %12)
  %widen27 = sext i32 %14 to i64
  %c28 = load ptr, ptr %c, align 8
  %cast29 = ptrtoint ptr %c28 to i64
  %null_chk30 = icmp eq i64 %cast29, 0
  %null_ext31 = zext i1 %null_chk30 to i64
  call void @avra_null_deref_trap(ptr @fld_name.39, i64 4, ptr @sty_name.40, i64 3, i64 %null_ext31, ptr @src_file.41, i64 103, i64 48)
  %15 = call i64 @Cat__size(ptr %c28)
  %16 = call ptr @avra_rc_alloc(i64 32)
  %17 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %16, i64 32, ptr @.i2s_fmt.42, i64 %15)
  %widen32 = sext i32 %17 to i64
  %18 = call i32 @puts(ptr %16)
  %widen33 = sext i32 %18 to i64
  %d34 = load ptr, ptr %d, align 8
  %19 = call ptr @describe(ptr %d34)
  %20 = call i32 @puts(ptr %19)
  %widen35 = sext i32 %20 to i64
  %c_cleanup = load ptr, ptr %c, align 8
  %21 = call i64 @__release_Cat(ptr %c_cleanup)
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Cat(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_color_ptr = getelementptr inbounds nuw %Cat, ptr %0, i32 0, i32 0
  %rel_color = load ptr, ptr %rel_color_ptr, align 8
  %is_null_color = icmp eq ptr %rel_color, null
  br i1 %is_null_color, label %rel_color_skip, label %rel_color_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_color_skip
  ret i64 0

rel_color_skip:                                   ; preds = %rel_color_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_color_do:                                     ; preds = %do_free
  call void @avra_rc_release(ptr %rel_color)
  br label %rel_color_skip
}

define i64 @__release_Dog(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_breed_ptr = getelementptr inbounds nuw %Dog, ptr %0, i32 0, i32 0
  %rel_breed = load ptr, ptr %rel_breed_ptr, align 8
  %is_null_breed = icmp eq ptr %rel_breed, null
  br i1 %is_null_breed, label %rel_breed_skip, label %rel_breed_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_breed_skip
  ret i64 0

rel_breed_skip:                                   ; preds = %rel_breed_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_breed_do:                                     ; preds = %do_free
  call void @avra_rc_release(ptr %rel_breed)
  br label %rel_breed_skip
}
