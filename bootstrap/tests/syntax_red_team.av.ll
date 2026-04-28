; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@.str = private unnamed_addr constant [7 x i8] c"pipe: \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"Alice\00", align 1
@.str.2 = private unnamed_addr constant [9 x i8] c"interp: \00", align 1
@.str.3 = private unnamed_addr constant [5 x i8] c" is \00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.5 = private unnamed_addr constant [6 x i8] c"small\00", align 1
@.str.6 = private unnamed_addr constant [7 x i8] c"medium\00", align 1
@.str.7 = private unnamed_addr constant [6 x i8] c"large\00", align 1
@.str.8 = private unnamed_addr constant [7 x i8] c"when: \00", align 1
@.str.9 = private unnamed_addr constant [8 x i8] c"slice: \00", align 1
@.str.10 = private unnamed_addr constant [6 x i8] c"hello\00", align 1

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

define i64 @double(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %mul = mul i64 %x1, 2
  ret i64 %mul
}

define i64 @inc(i64 %0) {
entry:
  %x = alloca i64, align 8
  store i64 %0, ptr %x, align 8
  %x1 = load i64, ptr %x, align 8
  %add = add i64 %x1, 1
  ret i64 %add
}

define i64 @main() {
entry:
  %0 = call i64 @__bs_top_level()
  %label = alloca ptr, align 8
  %when_result = alloca i64, align 8
  %x = alloca i64, align 8
  %age = alloca i64, align 8
  %name = alloca ptr, align 8
  %r = alloca i64, align 8
  %1 = call i64 @double(i64 5)
  %2 = call i64 @inc(i64 %1)
  store i64 %2, ptr %r, align 8
  %r1 = load i64, ptr %r, align 8
  %3 = call ptr @avra_rc_alloc(i64 32)
  %4 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %3, i64 32, ptr @.i2s_fmt, i64 %r1)
  %widen = sext i32 %4 to i64
  %5 = call i64 @strlen(ptr @.str)
  %6 = call i64 @strlen(ptr %3)
  %concat_total = add i64 %5, %6
  %concat_size = add i64 %concat_total, 1
  %7 = call ptr @avra_rc_alloc(i64 %concat_size)
  %8 = call ptr @memcpy(ptr %7, ptr @.str, i64 %5)
  %cast = ptrtoint ptr %7 to i64
  %dst2_int = add i64 %cast, %5
  %cast2 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %6, 1
  %9 = call ptr @memcpy(ptr %cast2, ptr %3, i64 %rhs_len_p1)
  %10 = call i32 @puts(ptr %7)
  %widen3 = sext i32 %10 to i64
  store ptr @.str.1, ptr %name, align 8
  store i64 30, ptr %age, align 8
  %name4 = load ptr, ptr %name, align 8
  %11 = call i64 @strlen(ptr @.str.2)
  %12 = call i64 @strlen(ptr %name4)
  %concat_total5 = add i64 %11, %12
  %concat_size6 = add i64 %concat_total5, 1
  %13 = call ptr @avra_rc_alloc(i64 %concat_size6)
  %14 = call ptr @memcpy(ptr %13, ptr @.str.2, i64 %11)
  %cast7 = ptrtoint ptr %13 to i64
  %dst2_int8 = add i64 %cast7, %11
  %cast9 = inttoptr i64 %dst2_int8 to ptr
  %rhs_len_p110 = add i64 %12, 1
  %15 = call ptr @memcpy(ptr %cast9, ptr %name4, i64 %rhs_len_p110)
  %16 = call i64 @strlen(ptr %13)
  %17 = call i64 @strlen(ptr @.str.3)
  %concat_total11 = add i64 %16, %17
  %concat_size12 = add i64 %concat_total11, 1
  %18 = call ptr @avra_rc_alloc(i64 %concat_size12)
  %19 = call ptr @memcpy(ptr %18, ptr %13, i64 %16)
  %cast13 = ptrtoint ptr %18 to i64
  %dst2_int14 = add i64 %cast13, %16
  %cast15 = inttoptr i64 %dst2_int14 to ptr
  %rhs_len_p116 = add i64 %17, 1
  %20 = call ptr @memcpy(ptr %cast15, ptr @.str.3, i64 %rhs_len_p116)
  %age17 = load i64, ptr %age, align 8
  %21 = call ptr @avra_rc_alloc(i64 32)
  %22 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %21, i64 32, ptr @.i2s_fmt.4, i64 %age17)
  %widen18 = sext i32 %22 to i64
  %23 = call i64 @strlen(ptr %18)
  %24 = call i64 @strlen(ptr %21)
  %concat_total19 = add i64 %23, %24
  %concat_size20 = add i64 %concat_total19, 1
  %25 = call ptr @avra_rc_alloc(i64 %concat_size20)
  %26 = call ptr @memcpy(ptr %25, ptr %18, i64 %23)
  %cast21 = ptrtoint ptr %25 to i64
  %dst2_int22 = add i64 %cast21, %23
  %cast23 = inttoptr i64 %dst2_int22 to ptr
  %rhs_len_p124 = add i64 %24, 1
  %27 = call ptr @memcpy(ptr %cast23, ptr %21, i64 %rhs_len_p124)
  %28 = call i32 @puts(ptr %25)
  %widen25 = sext i32 %28 to i64
  store i64 50, ptr %x, align 8
  store i64 0, ptr %when_result, align 8
  %x26 = load i64, ptr %x, align 8
  %slt = icmp slt i64 %x26, 10
  %slt_ext = zext i1 %slt to i64
  %when_cond = icmp ne i64 %slt_ext, 0
  br i1 %when_cond, label %when_arm, label %when_next

when_end:                                         ; preds = %when_next32, %when_arm31, %when_arm
  %when_val = load i64, ptr %when_result, align 8
  %cast33 = inttoptr i64 %when_val to ptr
  store ptr %cast33, ptr %label, align 8
  %label34 = load ptr, ptr %label, align 8
  %29 = call i64 @strlen(ptr @.str.8)
  %30 = call i64 @strlen(ptr %label34)
  %concat_total35 = add i64 %29, %30
  %concat_size36 = add i64 %concat_total35, 1
  %31 = call ptr @avra_rc_alloc(i64 %concat_size36)
  %32 = call ptr @memcpy(ptr %31, ptr @.str.8, i64 %29)
  %cast37 = ptrtoint ptr %31 to i64
  %dst2_int38 = add i64 %cast37, %29
  %cast39 = inttoptr i64 %dst2_int38 to ptr
  %rhs_len_p140 = add i64 %30, 1
  %33 = call ptr @memcpy(ptr %cast39, ptr %label34, i64 %rhs_len_p140)
  %34 = call i32 @puts(ptr %31)
  %widen41 = sext i32 %34 to i64
  %35 = call ptr @avra_str_substring(ptr @.str.10, i64 0, i64 3)
  %36 = call i64 @strlen(ptr @.str.9)
  %37 = call i64 @strlen(ptr %35)
  %concat_total42 = add i64 %36, %37
  %concat_size43 = add i64 %concat_total42, 1
  %38 = call ptr @avra_rc_alloc(i64 %concat_size43)
  %39 = call ptr @memcpy(ptr %38, ptr @.str.9, i64 %36)
  %cast44 = ptrtoint ptr %38 to i64
  %dst2_int45 = add i64 %cast44, %36
  %cast46 = inttoptr i64 %dst2_int45 to ptr
  %rhs_len_p147 = add i64 %37, 1
  %40 = call ptr @memcpy(ptr %cast46, ptr %35, i64 %rhs_len_p147)
  %41 = call i32 @puts(ptr %38)
  %widen48 = sext i32 %41 to i64
  ret i64 0

when_arm:                                         ; preds = %entry
  store i64 ptrtoint (ptr @.str.5 to i64), ptr %when_result, align 8
  br label %when_end

when_next:                                        ; preds = %entry
  %x27 = load i64, ptr %x, align 8
  %slt28 = icmp slt i64 %x27, 100
  %slt_ext29 = zext i1 %slt28 to i64
  %when_cond30 = icmp ne i64 %slt_ext29, 0
  br i1 %when_cond30, label %when_arm31, label %when_next32

when_arm31:                                       ; preds = %when_next
  store i64 ptrtoint (ptr @.str.6 to i64), ptr %when_result, align 8
  br label %when_end

when_next32:                                      ; preds = %when_next
  store i64 ptrtoint (ptr @.str.7 to i64), ptr %when_result, align 8
  br label %when_end
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}
