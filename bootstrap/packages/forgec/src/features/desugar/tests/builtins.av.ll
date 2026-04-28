; ModuleID = 'bootstrap'
source_filename = "bootstrap"

@.str = private unnamed_addr constant [6 x i8] c"min: \00", align 1
@.i2s_fmt = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"max: \00", align 1
@.i2s_fmt.2 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.3 = private unnamed_addr constant [10 x i8] c"min_neg: \00", align 1
@.i2s_fmt.4 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.5 = private unnamed_addr constant [11 x i8] c"max_same: \00", align 1
@.i2s_fmt.6 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.7 = private unnamed_addr constant [11 x i8] c"min_expr: \00", align 1
@.i2s_fmt.8 = private unnamed_addr constant [5 x i8] c"%lld\00", align 1
@.str.9 = private unnamed_addr constant [22 x i8] c"not yet implemented: \00", align 1
@.str.10 = private unnamed_addr constant [21 x i8] c"implement this later\00", align 1
@.panic_prefix = private unnamed_addr constant [8 x i8] c"panic: \00", align 1
@.str.11 = private unnamed_addr constant [13 x i8] c"todo_skipped\00", align 1
@.str.12 = private unnamed_addr constant [14 x i8] c"unreachable: \00", align 1
@.str.13 = private unnamed_addr constant [21 x i8] c"x should be positive\00", align 1
@.panic_prefix.14 = private unnamed_addr constant [8 x i8] c"panic: \00", align 1
@.str.15 = private unnamed_addr constant [20 x i8] c"unreachable_skipped\00", align 1

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
  %x = alloca i64, align 8
  %use_todo = alloca i1, align 1
  %ife_result79 = alloca i64, align 8
  %__b74 = alloca i64, align 8
  %__a72 = alloca i64, align 8
  %b = alloca i64, align 8
  %a = alloca i64, align 8
  %ife_result55 = alloca i64, align 8
  %__b50 = alloca i64, align 8
  %__a49 = alloca i64, align 8
  %ife_result33 = alloca i64, align 8
  %__b28 = alloca i64, align 8
  %__a27 = alloca i64, align 8
  %ife_result11 = alloca i64, align 8
  %__b8 = alloca i64, align 8
  %__a7 = alloca i64, align 8
  %ife_result = alloca i64, align 8
  %__b = alloca i64, align 8
  %__a = alloca i64, align 8
  store i64 3, ptr %__a, align 8
  store i64 10, ptr %__b, align 8
  %__a1 = load i64, ptr %__a, align 8
  %__b2 = load i64, ptr %__b, align 8
  %slt = icmp slt i64 %__a1, %__b2
  %slt_ext = zext i1 %slt to i64
  %ife_cond = icmp ne i64 %slt_ext, 0
  br i1 %ife_cond, label %ife_then, label %ife_else

ife_end:                                          ; preds = %ife_else, %ife_then
  %ife_val = load i64, ptr %ife_result, align 8
  %1 = call ptr @avra_rc_alloc(i64 32)
  %2 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %1, i64 32, ptr @.i2s_fmt, i64 %ife_val)
  %widen = sext i32 %2 to i64
  %3 = call i64 @strlen(ptr @.str)
  %4 = call i64 @strlen(ptr %1)
  %concat_total = add i64 %3, %4
  %concat_size = add i64 %concat_total, 1
  %5 = call ptr @avra_rc_alloc(i64 %concat_size)
  %6 = call ptr @memcpy(ptr %5, ptr @.str, i64 %3)
  %cast = ptrtoint ptr %5 to i64
  %dst2_int = add i64 %cast, %3
  %cast5 = inttoptr i64 %dst2_int to ptr
  %rhs_len_p1 = add i64 %4, 1
  %7 = call ptr @memcpy(ptr %cast5, ptr %1, i64 %rhs_len_p1)
  %8 = call i32 @puts(ptr %5)
  %widen6 = sext i32 %8 to i64
  store i64 3, ptr %__a7, align 8
  store i64 10, ptr %__b8, align 8
  %__a9 = load i64, ptr %__a7, align 8
  %__b10 = load i64, ptr %__b8, align 8
  %sgt = icmp sgt i64 %__a9, %__b10
  %sgt_ext = zext i1 %sgt to i64
  %ife_cond13 = icmp ne i64 %sgt_ext, 0
  br i1 %ife_cond13, label %ife_then14, label %ife_else15

ife_then:                                         ; preds = %entry
  %__a3 = load i64, ptr %__a, align 8
  store i64 %__a3, ptr %ife_result, align 8
  br label %ife_end

ife_else:                                         ; preds = %entry
  %__b4 = load i64, ptr %__b, align 8
  store i64 %__b4, ptr %ife_result, align 8
  br label %ife_end

ife_end12:                                        ; preds = %ife_else15, %ife_then14
  %ife_val18 = load i64, ptr %ife_result11, align 8
  %9 = call ptr @avra_rc_alloc(i64 32)
  %10 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %9, i64 32, ptr @.i2s_fmt.2, i64 %ife_val18)
  %widen19 = sext i32 %10 to i64
  %11 = call i64 @strlen(ptr @.str.1)
  %12 = call i64 @strlen(ptr %9)
  %concat_total20 = add i64 %11, %12
  %concat_size21 = add i64 %concat_total20, 1
  %13 = call ptr @avra_rc_alloc(i64 %concat_size21)
  %14 = call ptr @memcpy(ptr %13, ptr @.str.1, i64 %11)
  %cast22 = ptrtoint ptr %13 to i64
  %dst2_int23 = add i64 %cast22, %11
  %cast24 = inttoptr i64 %dst2_int23 to ptr
  %rhs_len_p125 = add i64 %12, 1
  %15 = call ptr @memcpy(ptr %cast24, ptr %9, i64 %rhs_len_p125)
  %16 = call i32 @puts(ptr %13)
  %widen26 = sext i32 %16 to i64
  store i64 -5, ptr %__a27, align 8
  store i64 5, ptr %__b28, align 8
  %__a29 = load i64, ptr %__a27, align 8
  %__b30 = load i64, ptr %__b28, align 8
  %slt31 = icmp slt i64 %__a29, %__b30
  %slt_ext32 = zext i1 %slt31 to i64
  %ife_cond35 = icmp ne i64 %slt_ext32, 0
  br i1 %ife_cond35, label %ife_then36, label %ife_else37

ife_then14:                                       ; preds = %ife_end
  %__a16 = load i64, ptr %__a7, align 8
  store i64 %__a16, ptr %ife_result11, align 8
  br label %ife_end12

ife_else15:                                       ; preds = %ife_end
  %__b17 = load i64, ptr %__b8, align 8
  store i64 %__b17, ptr %ife_result11, align 8
  br label %ife_end12

ife_end34:                                        ; preds = %ife_else37, %ife_then36
  %ife_val40 = load i64, ptr %ife_result33, align 8
  %17 = call ptr @avra_rc_alloc(i64 32)
  %18 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %17, i64 32, ptr @.i2s_fmt.4, i64 %ife_val40)
  %widen41 = sext i32 %18 to i64
  %19 = call i64 @strlen(ptr @.str.3)
  %20 = call i64 @strlen(ptr %17)
  %concat_total42 = add i64 %19, %20
  %concat_size43 = add i64 %concat_total42, 1
  %21 = call ptr @avra_rc_alloc(i64 %concat_size43)
  %22 = call ptr @memcpy(ptr %21, ptr @.str.3, i64 %19)
  %cast44 = ptrtoint ptr %21 to i64
  %dst2_int45 = add i64 %cast44, %19
  %cast46 = inttoptr i64 %dst2_int45 to ptr
  %rhs_len_p147 = add i64 %20, 1
  %23 = call ptr @memcpy(ptr %cast46, ptr %17, i64 %rhs_len_p147)
  %24 = call i32 @puts(ptr %21)
  %widen48 = sext i32 %24 to i64
  store i64 7, ptr %__a49, align 8
  store i64 7, ptr %__b50, align 8
  %__a51 = load i64, ptr %__a49, align 8
  %__b52 = load i64, ptr %__b50, align 8
  %sgt53 = icmp sgt i64 %__a51, %__b52
  %sgt_ext54 = zext i1 %sgt53 to i64
  %ife_cond57 = icmp ne i64 %sgt_ext54, 0
  br i1 %ife_cond57, label %ife_then58, label %ife_else59

ife_then36:                                       ; preds = %ife_end12
  %__a38 = load i64, ptr %__a27, align 8
  store i64 %__a38, ptr %ife_result33, align 8
  br label %ife_end34

ife_else37:                                       ; preds = %ife_end12
  %__b39 = load i64, ptr %__b28, align 8
  store i64 %__b39, ptr %ife_result33, align 8
  br label %ife_end34

ife_end56:                                        ; preds = %ife_else59, %ife_then58
  %ife_val62 = load i64, ptr %ife_result55, align 8
  %25 = call ptr @avra_rc_alloc(i64 32)
  %26 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %25, i64 32, ptr @.i2s_fmt.6, i64 %ife_val62)
  %widen63 = sext i32 %26 to i64
  %27 = call i64 @strlen(ptr @.str.5)
  %28 = call i64 @strlen(ptr %25)
  %concat_total64 = add i64 %27, %28
  %concat_size65 = add i64 %concat_total64, 1
  %29 = call ptr @avra_rc_alloc(i64 %concat_size65)
  %30 = call ptr @memcpy(ptr %29, ptr @.str.5, i64 %27)
  %cast66 = ptrtoint ptr %29 to i64
  %dst2_int67 = add i64 %cast66, %27
  %cast68 = inttoptr i64 %dst2_int67 to ptr
  %rhs_len_p169 = add i64 %28, 1
  %31 = call ptr @memcpy(ptr %cast68, ptr %25, i64 %rhs_len_p169)
  %32 = call i32 @puts(ptr %29)
  %widen70 = sext i32 %32 to i64
  store i64 4, ptr %a, align 8
  store i64 8, ptr %b, align 8
  %a71 = load i64, ptr %a, align 8
  store i64 %a71, ptr %__a72, align 8
  %b73 = load i64, ptr %b, align 8
  store i64 %b73, ptr %__b74, align 8
  %__a75 = load i64, ptr %__a72, align 8
  %__b76 = load i64, ptr %__b74, align 8
  %slt77 = icmp slt i64 %__a75, %__b76
  %slt_ext78 = zext i1 %slt77 to i64
  %ife_cond81 = icmp ne i64 %slt_ext78, 0
  br i1 %ife_cond81, label %ife_then82, label %ife_else83

ife_then58:                                       ; preds = %ife_end34
  %__a60 = load i64, ptr %__a49, align 8
  store i64 %__a60, ptr %ife_result55, align 8
  br label %ife_end56

ife_else59:                                       ; preds = %ife_end34
  %__b61 = load i64, ptr %__b50, align 8
  store i64 %__b61, ptr %ife_result55, align 8
  br label %ife_end56

ife_end80:                                        ; preds = %ife_else83, %ife_then82
  %ife_val86 = load i64, ptr %ife_result79, align 8
  %33 = call ptr @avra_rc_alloc(i64 32)
  %34 = call i32 (ptr, i64, ptr, ...) @snprintf(ptr %33, i64 32, ptr @.i2s_fmt.8, i64 %ife_val86)
  %widen87 = sext i32 %34 to i64
  %35 = call i64 @strlen(ptr @.str.7)
  %36 = call i64 @strlen(ptr %33)
  %concat_total88 = add i64 %35, %36
  %concat_size89 = add i64 %concat_total88, 1
  %37 = call ptr @avra_rc_alloc(i64 %concat_size89)
  %38 = call ptr @memcpy(ptr %37, ptr @.str.7, i64 %35)
  %cast90 = ptrtoint ptr %37 to i64
  %dst2_int91 = add i64 %cast90, %35
  %cast92 = inttoptr i64 %dst2_int91 to ptr
  %rhs_len_p193 = add i64 %36, 1
  %39 = call ptr @memcpy(ptr %cast92, ptr %33, i64 %rhs_len_p193)
  %40 = call i32 @puts(ptr %37)
  %widen94 = sext i32 %40 to i64
  store i1 false, ptr %use_todo, align 8
  %use_todo95 = load i1, ptr %use_todo, align 8
  br i1 %use_todo95, label %if_then, label %if_else

ife_then82:                                       ; preds = %ife_end56
  %__a84 = load i64, ptr %__a72, align 8
  store i64 %__a84, ptr %ife_result79, align 8
  br label %ife_end80

ife_else83:                                       ; preds = %ife_end56
  %__b85 = load i64, ptr %__b74, align 8
  store i64 %__b85, ptr %ife_result79, align 8
  br label %ife_end80

ifcont:                                           ; preds = %if_else, %if_then
  %41 = call i32 @puts(ptr @.str.11)
  %widen108 = sext i32 %41 to i64
  store i64 42, ptr %x, align 8
  %x109 = load i64, ptr %x, align 8
  %slt110 = icmp slt i64 %x109, 0
  %slt_ext111 = zext i1 %slt110 to i64
  %if_cond = icmp ne i64 %slt_ext111, 0
  br i1 %if_cond, label %if_then113, label %if_else114

if_then:                                          ; preds = %ife_end80
  %42 = call i64 @strlen(ptr @.str.9)
  %43 = call i64 @strlen(ptr @.str.10)
  %concat_total96 = add i64 %42, %43
  %concat_size97 = add i64 %concat_total96, 1
  %44 = call ptr @avra_rc_alloc(i64 %concat_size97)
  %45 = call ptr @memcpy(ptr %44, ptr @.str.9, i64 %42)
  %cast98 = ptrtoint ptr %44 to i64
  %dst2_int99 = add i64 %cast98, %42
  %cast100 = inttoptr i64 %dst2_int99 to ptr
  %rhs_len_p1101 = add i64 %43, 1
  %46 = call ptr @memcpy(ptr %cast100, ptr @.str.10, i64 %rhs_len_p1101)
  %47 = call i64 @strlen(ptr @.panic_prefix)
  %48 = call i64 @strlen(ptr %44)
  %concat_total102 = add i64 %47, %48
  %concat_size103 = add i64 %concat_total102, 1
  %49 = call ptr @avra_rc_alloc(i64 %concat_size103)
  %50 = call ptr @memcpy(ptr %49, ptr @.panic_prefix, i64 %47)
  %cast104 = ptrtoint ptr %49 to i64
  %dst2_int105 = add i64 %cast104, %47
  %cast106 = inttoptr i64 %dst2_int105 to ptr
  %rhs_len_p1107 = add i64 %48, 1
  %51 = call ptr @memcpy(ptr %cast106, ptr %44, i64 %rhs_len_p1107)
  call void @avra_eprintln(ptr %49)
  call void @exit(i32 1)
  br label %ifcont

if_else:                                          ; preds = %ife_end80
  br label %ifcont

ifcont112:                                        ; preds = %if_else114, %if_then113
  %52 = call i32 @puts(ptr @.str.15)
  %widen127 = sext i32 %52 to i64
  ret i64 0

if_then113:                                       ; preds = %ifcont
  %53 = call i64 @strlen(ptr @.str.12)
  %54 = call i64 @strlen(ptr @.str.13)
  %concat_total115 = add i64 %53, %54
  %concat_size116 = add i64 %concat_total115, 1
  %55 = call ptr @avra_rc_alloc(i64 %concat_size116)
  %56 = call ptr @memcpy(ptr %55, ptr @.str.12, i64 %53)
  %cast117 = ptrtoint ptr %55 to i64
  %dst2_int118 = add i64 %cast117, %53
  %cast119 = inttoptr i64 %dst2_int118 to ptr
  %rhs_len_p1120 = add i64 %54, 1
  %57 = call ptr @memcpy(ptr %cast119, ptr @.str.13, i64 %rhs_len_p1120)
  %58 = call i64 @strlen(ptr @.panic_prefix.14)
  %59 = call i64 @strlen(ptr %55)
  %concat_total121 = add i64 %58, %59
  %concat_size122 = add i64 %concat_total121, 1
  %60 = call ptr @avra_rc_alloc(i64 %concat_size122)
  %61 = call ptr @memcpy(ptr %60, ptr @.panic_prefix.14, i64 %58)
  %cast123 = ptrtoint ptr %60 to i64
  %dst2_int124 = add i64 %cast123, %58
  %cast125 = inttoptr i64 %dst2_int124 to ptr
  %rhs_len_p1126 = add i64 %59, 1
  %62 = call ptr @memcpy(ptr %cast125, ptr %55, i64 %rhs_len_p1126)
  call void @avra_eprintln(ptr %60)
  call void @exit(i32 1)
  br label %ifcont112

if_else114:                                       ; preds = %ifcont
  br label %ifcont112
}

define i64 @__bs_top_level() {
entry:
  call void @avra_rc_collect()
  ret i64 0
}
