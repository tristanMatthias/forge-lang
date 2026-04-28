; ModuleID = 'bootstrap'
source_filename = "bootstrap"

%Dog = type { ptr, ptr }
%Cat = type { ptr, i1 }
%Spider = type { ptr }

@.str = private unnamed_addr constant [11 x i8] c"woof from \00", align 1
@fld_name = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name = private unnamed_addr constant [4 x i8] c"Dog\00", align 1
@src_file = private unnamed_addr constant [105 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/dyn_dispatch_combo.av\00", align 1
@.str.1 = private unnamed_addr constant [11 x i8] c"meow from \00", align 1
@fld_name.2 = private unnamed_addr constant [5 x i8] c"name\00", align 1
@sty_name.3 = private unnamed_addr constant [4 x i8] c"Cat\00", align 1
@src_file.4 = private unnamed_addr constant [105 x i8] c"/Users/tristan/projects/tristanMatthias/forge-crafting-intepreters/bootstrap/tests/dyn_dispatch_combo.av\00", align 1
@.str.5 = private unnamed_addr constant [4 x i8] c"...\00", align 1
@.str.6 = private unnamed_addr constant [3 x i8] c" (\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.7 = private unnamed_addr constant [7 x i8] c" legs)\00", align 1
@.str.8 = private unnamed_addr constant [4 x i8] c"!!!\00", align 1
@.str.9 = private unnamed_addr constant [6 x i8] c" has \00", align 1
@.i2s_fmt.10 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.11 = private unnamed_addr constant [6 x i8] c" legs\00", align 1
@.str.12 = private unnamed_addr constant [7 x i8] c"normal\00", align 1
@.str.13 = private unnamed_addr constant [5 x i8] c"many\00", align 1
@.str.14 = private unnamed_addr constant [4 x i8] c"Rex\00", align 1
@.str.15 = private unnamed_addr constant [4 x i8] c"Lab\00", align 1
@.str.16 = private unnamed_addr constant [9 x i8] c"Whiskers\00", align 1
@.str.17 = private unnamed_addr constant [10 x i8] c"tarantula\00", align 1
@.i2s_fmt.18 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.19 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.i2s_fmt.20 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1

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

define ptr @Dog__speak(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name, i64 4, ptr @sty_name, i64 3, i64 %null_ext, ptr @src_file, i64 104, i64 13)
  %name_ptr = getelementptr inbounds nuw %Dog, ptr %self1, i32 0, i32 0
  %name = load ptr, ptr %name_ptr, align 8
  %1 = call i64 @strlen(ptr @.str)
  %2 = call i64 @strlen(ptr %name)
  %concat_total = add i64 %1, %2
  %concat_size = add i64 %concat_total, 1
  %3 = call ptr @avra_rc_alloc(i64 %concat_size)
  %4 = call ptr @memcpy(ptr %3, ptr @.str, i64 %1)
  %cast2 = ptrtoint ptr %3 to i64
  %dst2_int = add i64 %cast2, %1
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %2, 1
  %5 = call ptr @memcpy(ptr %cast3, ptr %name, i64 %rhs_len_p1)
  ret ptr %3
}

define i64 @Dog__legs(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  ret i64 4
}

define ptr @Cat__speak(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  %self1 = load ptr, ptr %self, align 8
  %cast = ptrtoint ptr %self1 to i64
  %null_chk = icmp eq i64 %cast, 0
  %null_ext = zext i1 %null_chk to i64
  call void @avra_null_deref_trap(ptr @fld_name.2, i64 4, ptr @sty_name.3, i64 3, i64 %null_ext, ptr @src_file.4, i64 104, i64 18)
  %name_ptr = getelementptr inbounds nuw %Cat, ptr %self1, i32 0, i32 0
  %name = load ptr, ptr %name_ptr, align 8
  %1 = call i64 @strlen(ptr @.str.1)
  %2 = call i64 @strlen(ptr %name)
  %concat_total = add i64 %1, %2
  %concat_size = add i64 %concat_total, 1
  %3 = call ptr @avra_rc_alloc(i64 %concat_size)
  %4 = call ptr @memcpy(ptr %3, ptr @.str.1, i64 %1)
  %cast2 = ptrtoint ptr %3 to i64
  %dst2_int = add i64 %cast2, %1
  %cast3 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %2, 1
  %5 = call ptr @memcpy(ptr %cast3, ptr %name, i64 %rhs_len_p1)
  ret ptr %3
}

define i64 @Cat__legs(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  ret i64 4
}

define ptr @Spider__speak(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  ret ptr @.str.5
}

define i64 @Spider__legs(ptr %0) {
entry:
  %self = alloca ptr, align 8
  store ptr %0, ptr %self, align 8
  ret i64 8
}

define ptr @describe_animal(i64 %0) {
entry:
  %a = alloca ptr, align 8
  %cast = inttoptr i64 %0 to ptr
  store ptr %cast, ptr %a, align 8
  %a1 = load ptr, ptr %a, align 8
  %1 = call i64 @avra_trait_object_value(ptr %a1)
  %2 = call ptr @avra_trait_object_vtable(ptr %a1)
  %3 = call i64 @avra_array_get(ptr %2, i64 0)
  %4 = call i64 @avra_closure_call_1(i64 %3, i64 %1)
  %cast2 = inttoptr i64 %4 to ptr
  %5 = call i64 @strlen(ptr %cast2)
  %6 = call i64 @strlen(ptr @.str.6)
  %concat_total = add i64 %5, %6
  %concat_size = add i64 %concat_total, 1
  %7 = call ptr @avra_rc_alloc(i64 %concat_size)
  %8 = call ptr @memcpy(ptr %7, ptr %cast2, i64 %5)
  %cast3 = ptrtoint ptr %7 to i64
  %dst2_int = add i64 %cast3, %5
  %cast4 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %6, 1
  %9 = call ptr @memcpy(ptr %cast4, ptr @.str.6, i64 %rhs_len_p1)
  %a5 = load ptr, ptr %a, align 8
  %10 = call i64 @avra_trait_object_value(ptr %a5)
  %11 = call ptr @avra_trait_object_vtable(ptr %a5)
  %12 = call i64 @avra_array_get(ptr %11, i64 1)
  %13 = call i64 @avra_closure_call_1(i64 %12, i64 %10)
  %14 = call ptr @avra_rc_alloc(i64 32)
  %15 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %14, i64 32, ptr @.i2s_fmt, i64 %13)
  %widen = sext i32 %15 to i64
  %16 = call i64 @strlen(ptr %7)
  %17 = call i64 @strlen(ptr %14)
  %concat_total6 = add i64 %16, %17
  %concat_size7 = add i64 %concat_total6, 1
  %18 = call ptr @avra_rc_alloc(i64 %concat_size7)
  %19 = call ptr @memcpy(ptr %18, ptr %7, i64 %16)
  %cast8 = ptrtoint ptr %18 to i64
  %dst2_int9 = add i64 %cast8, %16
  %cast10 = inttoptr i64 %dst2_int9 to ptr
  %rhs_len_p111 = add i64 %17, 1
  %20 = call ptr @memcpy(ptr %cast10, ptr %14, i64 %rhs_len_p111)
  %21 = call i64 @strlen(ptr %18)
  %22 = call i64 @strlen(ptr @.str.7)
  %concat_total12 = add i64 %21, %22
  %concat_size13 = add i64 %concat_total12, 1
  %23 = call ptr @avra_rc_alloc(i64 %concat_size13)
  %24 = call ptr @memcpy(ptr %23, ptr %18, i64 %21)
  %cast14 = ptrtoint ptr %23 to i64
  %dst2_int15 = add i64 %cast14, %21
  %cast16 = inttoptr i64 %dst2_int15 to ptr
  %rhs_len_p117 = add i64 %22, 1
  %25 = call ptr @memcpy(ptr %cast16, ptr @.str.7, i64 %rhs_len_p117)
  ret ptr %23
}

define i64 @total_legs(i64 %0, i64 %1) {
entry:
  %b = alloca ptr, align 8
  %a = alloca ptr, align 8
  %cast = inttoptr i64 %0 to ptr
  store ptr %cast, ptr %a, align 8
  %cast1 = inttoptr i64 %1 to ptr
  store ptr %cast1, ptr %b, align 8
  %a2 = load ptr, ptr %a, align 8
  %2 = call i64 @avra_trait_object_value(ptr %a2)
  %3 = call ptr @avra_trait_object_vtable(ptr %a2)
  %4 = call i64 @avra_array_get(ptr %3, i64 1)
  %5 = call i64 @avra_closure_call_1(i64 %4, i64 %2)
  %b3 = load ptr, ptr %b, align 8
  %6 = call i64 @avra_trait_object_value(ptr %b3)
  %7 = call ptr @avra_trait_object_vtable(ptr %b3)
  %8 = call i64 @avra_array_get(ptr %7, i64 1)
  %9 = call i64 @avra_closure_call_1(i64 %8, i64 %6)
  %add = add i64 %5, %9
  ret i64 %add
}

define ptr @which_sound(i64 %0, i1 %1) {
entry:
  %sif_result = alloca i64, align 8
  %loud = alloca i1, align 1
  %a = alloca ptr, align 8
  %cast = inttoptr i64 %0 to ptr
  store ptr %cast, ptr %a, align 8
  store i1 %1, ptr %loud, align 8
  %loud1 = load i1, ptr %loud, align 8
  store i64 0, ptr %sif_result, align 8
  br i1 %loud1, label %sif_then, label %sif_else

sif_then:                                         ; preds = %entry
  %a2 = load ptr, ptr %a, align 8
  %2 = call i64 @avra_trait_object_value(ptr %a2)
  %3 = call ptr @avra_trait_object_vtable(ptr %a2)
  %4 = call i64 @avra_array_get(ptr %3, i64 0)
  %5 = call i64 @avra_closure_call_1(i64 %4, i64 %2)
  %cast3 = inttoptr i64 %5 to ptr
  %6 = call i64 @strlen(ptr %cast3)
  %7 = call i64 @strlen(ptr @.str.8)
  %concat_total = add i64 %6, %7
  %concat_size = add i64 %concat_total, 1
  %8 = call ptr @avra_rc_alloc(i64 %concat_size)
  %9 = call ptr @memcpy(ptr %8, ptr %cast3, i64 %6)
  %cast4 = ptrtoint ptr %8 to i64
  %dst2_int = add i64 %cast4, %6
  %cast5 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %7, 1
  %10 = call ptr @memcpy(ptr %cast5, ptr @.str.8, i64 %rhs_len_p1)
  %cast6 = ptrtoint ptr %8 to i64
  store i64 %cast6, ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %entry
  %a7 = load ptr, ptr %a, align 8
  %11 = call i64 @avra_trait_object_value(ptr %a7)
  %12 = call ptr @avra_trait_object_vtable(ptr %a7)
  %13 = call i64 @avra_array_get(ptr %12, i64 0)
  %14 = call i64 @avra_closure_call_1(i64 %13, i64 %11)
  %cast8 = inttoptr i64 %14 to ptr
  %cast9 = ptrtoint ptr %cast8 to i64
  store i64 %cast9, ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  %cast10 = inttoptr i64 %sif_val to ptr
  ret ptr %cast10
}

define ptr @animal_template(i64 %0) {
entry:
  %a = alloca ptr, align 8
  %cast = inttoptr i64 %0 to ptr
  store ptr %cast, ptr %a, align 8
  %a1 = load ptr, ptr %a, align 8
  %1 = call i64 @avra_trait_object_value(ptr %a1)
  %2 = call ptr @avra_trait_object_vtable(ptr %a1)
  %3 = call i64 @avra_array_get(ptr %2, i64 0)
  %4 = call i64 @avra_closure_call_1(i64 %3, i64 %1)
  %cast2 = inttoptr i64 %4 to ptr
  %5 = call i64 @strlen(ptr %cast2)
  %6 = call i64 @strlen(ptr @.str.9)
  %concat_total = add i64 %5, %6
  %concat_size = add i64 %concat_total, 1
  %7 = call ptr @avra_rc_alloc(i64 %concat_size)
  %8 = call ptr @memcpy(ptr %7, ptr %cast2, i64 %5)
  %cast3 = ptrtoint ptr %7 to i64
  %dst2_int = add i64 %cast3, %5
  %cast4 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %6, 1
  %9 = call ptr @memcpy(ptr %cast4, ptr @.str.9, i64 %rhs_len_p1)
  %a5 = load ptr, ptr %a, align 8
  %10 = call i64 @avra_trait_object_value(ptr %a5)
  %11 = call ptr @avra_trait_object_vtable(ptr %a5)
  %12 = call i64 @avra_array_get(ptr %11, i64 1)
  %13 = call i64 @avra_closure_call_1(i64 %12, i64 %10)
  %14 = call ptr @avra_rc_alloc(i64 32)
  %15 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %14, i64 32, ptr @.i2s_fmt.10, i64 %13)
  %widen = sext i32 %15 to i64
  %16 = call i64 @strlen(ptr %7)
  %17 = call i64 @strlen(ptr %14)
  %concat_total6 = add i64 %16, %17
  %concat_size7 = add i64 %concat_total6, 1
  %18 = call ptr @avra_rc_alloc(i64 %concat_size7)
  %19 = call ptr @memcpy(ptr %18, ptr %7, i64 %16)
  %cast8 = ptrtoint ptr %18 to i64
  %dst2_int9 = add i64 %cast8, %16
  %cast10 = inttoptr i64 %dst2_int9 to ptr
  %rhs_len_p111 = add i64 %17, 1
  %20 = call ptr @memcpy(ptr %cast10, ptr %14, i64 %rhs_len_p111)
  %21 = call i64 @strlen(ptr %18)
  %22 = call i64 @strlen(ptr @.str.11)
  %concat_total12 = add i64 %21, %22
  %concat_size13 = add i64 %concat_total12, 1
  %23 = call ptr @avra_rc_alloc(i64 %concat_size13)
  %24 = call ptr @memcpy(ptr %23, ptr %18, i64 %21)
  %cast14 = ptrtoint ptr %23 to i64
  %dst2_int15 = add i64 %cast14, %21
  %cast16 = inttoptr i64 %dst2_int15 to ptr
  %rhs_len_p117 = add i64 %22, 1
  %25 = call ptr @memcpy(ptr %cast16, ptr @.str.11, i64 %rhs_len_p117)
  ret ptr %23
}

define ptr @classify_legs(i64 %0) {
entry:
  %sif_result = alloca i64, align 8
  %n = alloca i64, align 8
  %a = alloca ptr, align 8
  %cast = inttoptr i64 %0 to ptr
  store ptr %cast, ptr %a, align 8
  %a1 = load ptr, ptr %a, align 8
  %1 = call i64 @avra_trait_object_value(ptr %a1)
  %2 = call ptr @avra_trait_object_vtable(ptr %a1)
  %3 = call i64 @avra_array_get(ptr %2, i64 1)
  %4 = call i64 @avra_closure_call_1(i64 %3, i64 %1)
  store i64 %4, ptr %n, align 8
  %n2 = load i64, ptr %n, align 8
  %sle = icmp sle i64 %n2, 4
  %sle_ext = zext i1 %sle to i64
  %sif_cond = icmp ne i64 %sle_ext, 0
  store i64 0, ptr %sif_result, align 8
  br i1 %sif_cond, label %sif_then, label %sif_else

sif_then:                                         ; preds = %entry
  store i64 ptrtoint (ptr @.str.12 to i64), ptr %sif_result, align 8
  br label %sif_end

sif_else:                                         ; preds = %entry
  store i64 ptrtoint (ptr @.str.13 to i64), ptr %sif_result, align 8
  br label %sif_end

sif_end:                                          ; preds = %sif_else, %sif_then
  %sif_val = load i64, ptr %sif_result, align 8
  %cast3 = inttoptr i64 %sif_val to ptr
  ret ptr %cast3
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %s = alloca ptr, align 8
  %c = alloca ptr, align 8
  %d = alloca ptr, align 8
  %1 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr = getelementptr inbounds nuw %Dog, ptr %1, i32 0, i32 0
  store ptr @.str.14, ptr %fld_ptr, align 8
  %fld_ptr1 = getelementptr inbounds nuw %Dog, ptr %1, i32 0, i32 1
  store ptr @.str.15, ptr %fld_ptr1, align 8
  %cast = ptrtoint ptr %1 to i64
  %2 = call ptr @avra_array_new()
  %3 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %3, i64 -559038737)
  call void @avra_array_push(ptr %3, i64 ptrtoint (ptr @Dog__speak to i64))
  %cast2 = ptrtoint ptr %3 to i64
  call void @avra_array_push(ptr %2, i64 %cast2)
  %4 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %4, i64 -559038737)
  call void @avra_array_push(ptr %4, i64 ptrtoint (ptr @Dog__legs to i64))
  %cast3 = ptrtoint ptr %4 to i64
  call void @avra_array_push(ptr %2, i64 %cast3)
  %cast4 = inttoptr i64 %cast to ptr
  %cast5 = ptrtoint ptr %2 to i64
  %5 = call i64 @avra_trait_object_new(ptr %cast4, i64 %cast5)
  %cast6 = inttoptr i64 %5 to ptr
  store ptr %cast6, ptr %d, align 8
  %6 = call ptr @avra_rc_alloc(i64 16)
  %fld_ptr7 = getelementptr inbounds nuw %Cat, ptr %6, i32 0, i32 0
  store ptr @.str.16, ptr %fld_ptr7, align 8
  %fld_ptr8 = getelementptr inbounds nuw %Cat, ptr %6, i32 0, i32 1
  store i1 true, ptr %fld_ptr8, align 8
  %cast9 = ptrtoint ptr %6 to i64
  %7 = call ptr @avra_array_new()
  %8 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %8, i64 -559038737)
  call void @avra_array_push(ptr %8, i64 ptrtoint (ptr @Cat__speak to i64))
  %cast10 = ptrtoint ptr %8 to i64
  call void @avra_array_push(ptr %7, i64 %cast10)
  %9 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %9, i64 -559038737)
  call void @avra_array_push(ptr %9, i64 ptrtoint (ptr @Cat__legs to i64))
  %cast11 = ptrtoint ptr %9 to i64
  call void @avra_array_push(ptr %7, i64 %cast11)
  %cast12 = inttoptr i64 %cast9 to ptr
  %cast13 = ptrtoint ptr %7 to i64
  %10 = call i64 @avra_trait_object_new(ptr %cast12, i64 %cast13)
  %cast14 = inttoptr i64 %10 to ptr
  store ptr %cast14, ptr %c, align 8
  %11 = call ptr @avra_rc_alloc(i64 8)
  %fld_ptr15 = getelementptr inbounds nuw %Spider, ptr %11, i32 0, i32 0
  store ptr @.str.17, ptr %fld_ptr15, align 8
  %cast16 = ptrtoint ptr %11 to i64
  %12 = call ptr @avra_array_new()
  %13 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %13, i64 -559038737)
  call void @avra_array_push(ptr %13, i64 ptrtoint (ptr @Spider__speak to i64))
  %cast17 = ptrtoint ptr %13 to i64
  call void @avra_array_push(ptr %12, i64 %cast17)
  %14 = call ptr @avra_array_new()
  call void @avra_array_push(ptr %14, i64 -559038737)
  call void @avra_array_push(ptr %14, i64 ptrtoint (ptr @Spider__legs to i64))
  %cast18 = ptrtoint ptr %14 to i64
  call void @avra_array_push(ptr %12, i64 %cast18)
  %cast19 = inttoptr i64 %cast16 to ptr
  %cast20 = ptrtoint ptr %12 to i64
  %15 = call i64 @avra_trait_object_new(ptr %cast19, i64 %cast20)
  %cast21 = inttoptr i64 %15 to ptr
  store ptr %cast21, ptr %s, align 8
  %d22 = load ptr, ptr %d, align 8
  %16 = call i64 @avra_trait_object_value(ptr %d22)
  %17 = call ptr @avra_trait_object_vtable(ptr %d22)
  %18 = call i64 @avra_array_get(ptr %17, i64 0)
  %19 = call i64 @avra_closure_call_1(i64 %18, i64 %16)
  %cast23 = inttoptr i64 %19 to ptr
  %20 = call i32 @puts(ptr %cast23)
  %widen = sext i32 %20 to i64
  %c24 = load ptr, ptr %c, align 8
  %21 = call i64 @avra_trait_object_value(ptr %c24)
  %22 = call ptr @avra_trait_object_vtable(ptr %c24)
  %23 = call i64 @avra_array_get(ptr %22, i64 0)
  %24 = call i64 @avra_closure_call_1(i64 %23, i64 %21)
  %cast25 = inttoptr i64 %24 to ptr
  %25 = call i32 @puts(ptr %cast25)
  %widen26 = sext i32 %25 to i64
  %s27 = load ptr, ptr %s, align 8
  %26 = call i64 @avra_trait_object_value(ptr %s27)
  %27 = call ptr @avra_trait_object_vtable(ptr %s27)
  %28 = call i64 @avra_array_get(ptr %27, i64 0)
  %29 = call i64 @avra_closure_call_1(i64 %28, i64 %26)
  %cast28 = inttoptr i64 %29 to ptr
  %30 = call i32 @puts(ptr %cast28)
  %widen29 = sext i32 %30 to i64
  %d30 = load ptr, ptr %d, align 8
  %31 = call i64 @avra_trait_object_value(ptr %d30)
  %32 = call ptr @avra_trait_object_vtable(ptr %d30)
  %33 = call i64 @avra_array_get(ptr %32, i64 1)
  %34 = call i64 @avra_closure_call_1(i64 %33, i64 %31)
  %35 = call ptr @avra_rc_alloc(i64 32)
  %36 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %35, i64 32, ptr @.i2s_fmt.18, i64 %34)
  %widen31 = sext i32 %36 to i64
  %37 = call i32 @puts(ptr %35)
  %widen32 = sext i32 %37 to i64
  %s33 = load ptr, ptr %s, align 8
  %38 = call i64 @avra_trait_object_value(ptr %s33)
  %39 = call ptr @avra_trait_object_vtable(ptr %s33)
  %40 = call i64 @avra_array_get(ptr %39, i64 1)
  %41 = call i64 @avra_closure_call_1(i64 %40, i64 %38)
  %42 = call ptr @avra_rc_alloc(i64 32)
  %43 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %42, i64 32, ptr @.i2s_fmt.19, i64 %41)
  %widen34 = sext i32 %43 to i64
  %44 = call i32 @puts(ptr %42)
  %widen35 = sext i32 %44 to i64
  %d36 = load ptr, ptr %d, align 8
  %cast37 = ptrtoint ptr %d36 to i64
  %45 = call ptr @describe_animal(i64 %cast37)
  %46 = call i32 @puts(ptr %45)
  %widen38 = sext i32 %46 to i64
  %c39 = load ptr, ptr %c, align 8
  %cast40 = ptrtoint ptr %c39 to i64
  %47 = call ptr @describe_animal(i64 %cast40)
  %48 = call i32 @puts(ptr %47)
  %widen41 = sext i32 %48 to i64
  %s42 = load ptr, ptr %s, align 8
  %cast43 = ptrtoint ptr %s42 to i64
  %49 = call ptr @describe_animal(i64 %cast43)
  %50 = call i32 @puts(ptr %49)
  %widen44 = sext i32 %50 to i64
  %d45 = load ptr, ptr %d, align 8
  %s46 = load ptr, ptr %s, align 8
  %cast47 = ptrtoint ptr %d45 to i64
  %cast48 = ptrtoint ptr %s46 to i64
  %51 = call i64 @total_legs(i64 %cast47, i64 %cast48)
  %52 = call ptr @avra_rc_alloc(i64 32)
  %53 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %52, i64 32, ptr @.i2s_fmt.20, i64 %51)
  %widen49 = sext i32 %53 to i64
  %54 = call i32 @puts(ptr %52)
  %widen50 = sext i32 %54 to i64
  %d51 = load ptr, ptr %d, align 8
  %cast52 = ptrtoint ptr %d51 to i64
  %55 = call ptr @which_sound(i64 %cast52, i1 true)
  %56 = call i32 @puts(ptr %55)
  %widen53 = sext i32 %56 to i64
  %c54 = load ptr, ptr %c, align 8
  %cast55 = ptrtoint ptr %c54 to i64
  %57 = call ptr @which_sound(i64 %cast55, i1 false)
  %58 = call i32 @puts(ptr %57)
  %widen56 = sext i32 %58 to i64
  %d57 = load ptr, ptr %d, align 8
  %cast58 = ptrtoint ptr %d57 to i64
  %59 = call ptr @animal_template(i64 %cast58)
  %60 = call i32 @puts(ptr %59)
  %widen59 = sext i32 %60 to i64
  %s60 = load ptr, ptr %s, align 8
  %cast61 = ptrtoint ptr %s60 to i64
  %61 = call ptr @animal_template(i64 %cast61)
  %62 = call i32 @puts(ptr %61)
  %widen62 = sext i32 %62 to i64
  %d63 = load ptr, ptr %d, align 8
  %cast64 = ptrtoint ptr %d63 to i64
  %63 = call ptr @classify_legs(i64 %cast64)
  %64 = call i32 @puts(ptr %63)
  %widen65 = sext i32 %64 to i64
  %s66 = load ptr, ptr %s, align 8
  %cast67 = ptrtoint ptr %s66 to i64
  %65 = call ptr @classify_legs(i64 %cast67)
  %66 = call i32 @puts(ptr %65)
  %widen68 = sext i32 %66 to i64
  ret i64 0
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}

define i64 @__release_Spider(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_species_ptr = getelementptr inbounds nuw %Spider, ptr %0, i32 0, i32 0
  %rel_species = load ptr, ptr %rel_species_ptr, align 8
  %is_null_species = icmp eq ptr %rel_species, null
  br i1 %is_null_species, label %rel_species_skip, label %rel_species_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_species_skip
  ret i64 0

rel_species_skip:                                 ; preds = %rel_species_do, %do_free
  call void @avra_rc_free(ptr %0)
  br label %done

rel_species_do:                                   ; preds = %do_free
  call void @avra_rc_release(ptr %rel_species)
  br label %rel_species_skip
}

define i64 @__release_Cat(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %Cat, ptr %0, i32 0, i32 0
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

define i64 @__release_Dog(ptr %0) {
entry:
  %1 = call i64 @avra_rc_should_free(ptr %0)
  %should_free = icmp ne i64 %1, 0
  br i1 %should_free, label %do_free, label %alive

do_free:                                          ; preds = %entry
  %rel_name_ptr = getelementptr inbounds nuw %Dog, ptr %0, i32 0, i32 0
  %rel_name = load ptr, ptr %rel_name_ptr, align 8
  %is_null_name = icmp eq ptr %rel_name, null
  br i1 %is_null_name, label %rel_name_skip, label %rel_name_do

alive:                                            ; preds = %entry
  br label %done

done:                                             ; preds = %alive, %rel_breed_skip
  ret i64 0

rel_name_skip:                                    ; preds = %rel_name_do, %do_free
  %rel_breed_ptr = getelementptr inbounds nuw %Dog, ptr %0, i32 0, i32 1
  %rel_breed = load ptr, ptr %rel_breed_ptr, align 8
  %is_null_breed = icmp eq ptr %rel_breed, null
  br i1 %is_null_breed, label %rel_breed_skip, label %rel_breed_do

rel_name_do:                                      ; preds = %do_free
  call void @avra_rc_release(ptr %rel_name)
  br label %rel_name_skip

rel_breed_skip:                                   ; preds = %rel_breed_do, %rel_name_skip
  call void @avra_rc_free(ptr %0)
  br label %done

rel_breed_do:                                     ; preds = %rel_name_skip
  call void @avra_rc_release(ptr %rel_breed)
  br label %rel_breed_skip
}
