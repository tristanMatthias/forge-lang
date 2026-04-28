; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@.str = private unnamed_addr constant [6 x i8] c"world\00", align 1
@.str.1 = private unnamed_addr constant [7 x i8] c"hello \00", align 1
@.str.2 = private unnamed_addr constant [2 x i8] c"!\00", align 1
@.str.3 = private unnamed_addr constant [5 x i8] c"2+3=\00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.4 = private unnamed_addr constant [9 x i8] c"result: \00", align 1
@.str.5 = private unnamed_addr constant [4 x i8] c"yes\00", align 1
@.str.6 = private unnamed_addr constant [3 x i8] c"no\00", align 1
@.str.7 = private unnamed_addr constant [8 x i8] c"count: \00", align 1
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.9 = private unnamed_addr constant [9 x i8] c"nested: \00", align 1
@.str.10 = private unnamed_addr constant [6 x i8] c"inner\00", align 1
@.str.11 = private unnamed_addr constant [6 x i8] c"outer\00", align 1
@.str.12 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@.str.13 = private unnamed_addr constant [2 x i8] c"b\00", align 1
@.str.14 = private unnamed_addr constant [8 x i8] c"multi: \00", align 1
@.str.15 = private unnamed_addr constant [6 x i8] c" and \00", align 1

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
  %0 = call i64 @__bs_top_level()
  %b = alloca ptr, align 8
  %a = alloca ptr, align 8
  %ife_result33 = alloca i64, align 8
  %x = alloca i64, align 8
  %ife_result = alloca i64, align 8
  %name = alloca ptr, align 8
  store ptr @.str, ptr %name, align 8
  %name1 = load ptr, ptr %name, align 8
  %1 = call i64 @strlen(ptr @.str.1)
  %2 = call i64 @strlen(ptr %name1)
  %concat_total = add i64 %1, %2
  %concat_size = add i64 %concat_total, 1
  %3 = call ptr @avra_rc_alloc(i64 %concat_size)
  %4 = call ptr @memcpy(ptr %3, ptr @.str.1, i64 %1)
  %cast = ptrtoint ptr %3 to i64
  %dst2_int = add i64 %cast, %1
  %cast2 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %2, 1
  %5 = call ptr @memcpy(ptr %cast2, ptr %name1, i64 %rhs_len_p1)
  %6 = call i64 @strlen(ptr %3)
  %7 = call i64 @strlen(ptr @.str.2)
  %concat_total3 = add i64 %6, %7
  %concat_size4 = add i64 %concat_total3, 1
  %8 = call ptr @avra_rc_alloc(i64 %concat_size4)
  %9 = call ptr @memcpy(ptr %8, ptr %3, i64 %6)
  %cast5 = ptrtoint ptr %8 to i64
  %dst2_int6 = add i64 %cast5, %6
  %cast7 = inttoptr i64 %dst2_int6 to ptr
  %rhs_len_p18 = add i64 %7, 1
  %10 = call ptr @memcpy(ptr %cast7, ptr @.str.2, i64 %rhs_len_p18)
  %11 = call i32 @puts(ptr %8)
  %widen = sext i32 %11 to i64
  %12 = call ptr @avra_rc_alloc(i64 32)
  %13 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %12, i64 32, ptr @.i2s_fmt, i64 5)
  %widen9 = sext i32 %13 to i64
  %14 = call i64 @strlen(ptr @.str.3)
  %15 = call i64 @strlen(ptr %12)
  %concat_total10 = add i64 %14, %15
  %concat_size11 = add i64 %concat_total10, 1
  %16 = call ptr @avra_rc_alloc(i64 %concat_size11)
  %17 = call ptr @memcpy(ptr %16, ptr @.str.3, i64 %14)
  %cast12 = ptrtoint ptr %16 to i64
  %dst2_int13 = add i64 %cast12, %14
  %cast14 = inttoptr i64 %dst2_int13 to ptr
  %rhs_len_p115 = add i64 %15, 1
  %18 = call ptr @memcpy(ptr %cast14, ptr %12, i64 %rhs_len_p115)
  %19 = call i32 @puts(ptr %16)
  %widen16 = sext i32 %19 to i64
  br i1 true, label %ife_then, label %ife_else

ife_end:                                          ; preds = %ife_else, %ife_then
  %ife_val = load i64, ptr %ife_result, align 8
  %rhs_ptr = inttoptr i64 %ife_val to ptr
  %20 = call i64 @strlen(ptr @.str.4)
  %21 = call i64 @strlen(ptr %rhs_ptr)
  %concat_total17 = add i64 %20, %21
  %concat_size18 = add i64 %concat_total17, 1
  %22 = call ptr @avra_rc_alloc(i64 %concat_size18)
  %23 = call ptr @memcpy(ptr %22, ptr @.str.4, i64 %20)
  %cast19 = ptrtoint ptr %22 to i64
  %dst2_int20 = add i64 %cast19, %20
  %cast21 = inttoptr i64 %dst2_int20 to ptr
  %rhs_len_p122 = add i64 %21, 1
  %24 = call ptr @memcpy(ptr %cast21, ptr %rhs_ptr, i64 %rhs_len_p122)
  %25 = call i32 @puts(ptr %22)
  %widen23 = sext i32 %25 to i64
  store i64 42, ptr %x, align 8
  %x24 = load i64, ptr %x, align 8
  %26 = call ptr @avra_rc_alloc(i64 32)
  %27 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %26, i64 32, ptr @.i2s_fmt.8, i64 %x24)
  %widen25 = sext i32 %27 to i64
  %28 = call i64 @strlen(ptr @.str.7)
  %29 = call i64 @strlen(ptr %26)
  %concat_total26 = add i64 %28, %29
  %concat_size27 = add i64 %concat_total26, 1
  %30 = call ptr @avra_rc_alloc(i64 %concat_size27)
  %31 = call ptr @memcpy(ptr %30, ptr @.str.7, i64 %28)
  %cast28 = ptrtoint ptr %30 to i64
  %dst2_int29 = add i64 %cast28, %28
  %cast30 = inttoptr i64 %dst2_int29 to ptr
  %rhs_len_p131 = add i64 %29, 1
  %32 = call ptr @memcpy(ptr %cast30, ptr %26, i64 %rhs_len_p131)
  %33 = call i32 @puts(ptr %30)
  %widen32 = sext i32 %33 to i64
  br i1 true, label %ife_then35, label %ife_else36

ife_then:                                         ; preds = %entry
  store i64 ptrtoint (ptr @.str.5 to i64), ptr %ife_result, align 8
  br label %ife_end

ife_else:                                         ; preds = %entry
  store i64 ptrtoint (ptr @.str.6 to i64), ptr %ife_result, align 8
  br label %ife_end

ife_end34:                                        ; preds = %ife_else36, %ife_then35
  %ife_val37 = load i64, ptr %ife_result33, align 8
  %rhs_ptr38 = inttoptr i64 %ife_val37 to ptr
  %34 = call i64 @strlen(ptr @.str.9)
  %35 = call i64 @strlen(ptr %rhs_ptr38)
  %concat_total39 = add i64 %34, %35
  %concat_size40 = add i64 %concat_total39, 1
  %36 = call ptr @avra_rc_alloc(i64 %concat_size40)
  %37 = call ptr @memcpy(ptr %36, ptr @.str.9, i64 %34)
  %cast41 = ptrtoint ptr %36 to i64
  %dst2_int42 = add i64 %cast41, %34
  %cast43 = inttoptr i64 %dst2_int42 to ptr
  %rhs_len_p144 = add i64 %35, 1
  %38 = call ptr @memcpy(ptr %cast43, ptr %rhs_ptr38, i64 %rhs_len_p144)
  %39 = call i32 @puts(ptr %36)
  %widen45 = sext i32 %39 to i64
  store ptr @.str.12, ptr %a, align 8
  store ptr @.str.13, ptr %b, align 8
  %a46 = load ptr, ptr %a, align 8
  %40 = call i64 @strlen(ptr @.str.14)
  %41 = call i64 @strlen(ptr %a46)
  %concat_total47 = add i64 %40, %41
  %concat_size48 = add i64 %concat_total47, 1
  %42 = call ptr @avra_rc_alloc(i64 %concat_size48)
  %43 = call ptr @memcpy(ptr %42, ptr @.str.14, i64 %40)
  %cast49 = ptrtoint ptr %42 to i64
  %dst2_int50 = add i64 %cast49, %40
  %cast51 = inttoptr i64 %dst2_int50 to ptr
  %rhs_len_p152 = add i64 %41, 1
  %44 = call ptr @memcpy(ptr %cast51, ptr %a46, i64 %rhs_len_p152)
  %45 = call i64 @strlen(ptr %42)
  %46 = call i64 @strlen(ptr @.str.15)
  %concat_total53 = add i64 %45, %46
  %concat_size54 = add i64 %concat_total53, 1
  %47 = call ptr @avra_rc_alloc(i64 %concat_size54)
  %48 = call ptr @memcpy(ptr %47, ptr %42, i64 %45)
  %cast55 = ptrtoint ptr %47 to i64
  %dst2_int56 = add i64 %cast55, %45
  %cast57 = inttoptr i64 %dst2_int56 to ptr
  %rhs_len_p158 = add i64 %46, 1
  %49 = call ptr @memcpy(ptr %cast57, ptr @.str.15, i64 %rhs_len_p158)
  %b59 = load ptr, ptr %b, align 8
  %50 = call i64 @strlen(ptr %47)
  %51 = call i64 @strlen(ptr %b59)
  %concat_total60 = add i64 %50, %51
  %concat_size61 = add i64 %concat_total60, 1
  %52 = call ptr @avra_rc_alloc(i64 %concat_size61)
  %53 = call ptr @memcpy(ptr %52, ptr %47, i64 %50)
  %cast62 = ptrtoint ptr %52 to i64
  %dst2_int63 = add i64 %cast62, %50
  %cast64 = inttoptr i64 %dst2_int63 to ptr
  %rhs_len_p165 = add i64 %51, 1
  %54 = call ptr @memcpy(ptr %cast64, ptr %b59, i64 %rhs_len_p165)
  %55 = call i32 @puts(ptr %52)
  %widen66 = sext i32 %55 to i64
  ret i64 0

ife_then35:                                       ; preds = %ife_end
  store i64 ptrtoint (ptr @.str.10 to i64), ptr %ife_result33, align 8
  br label %ife_end34

ife_else36:                                       ; preds = %ife_end
  store i64 ptrtoint (ptr @.str.11 to i64), ptr %ife_result33, align 8
  br label %ife_end34
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}
